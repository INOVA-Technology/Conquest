class Person
	# this would make more sence if it were "class Person < Item"
	# its a lot like an item, but I like that it's in a separate file
	# I'll probably add that in or you can idc

	attr_accessor :name, :description, :race, :hidden, :can_pickup, :talk, :action, :item_wanted, :health, :task, :gold, :alt_names

	alias_method :hidden?, :hidden
	alias_method :can_pickup?, :can_pickup

	def initialize(options = {})

		# required: 
		@name = options[:name]
		@description = options[:desc]
		@race = options[:race]
		@options = options

		# not required but recommended:
		@talk = (options[:talk] || "#@name doesn't want to talk right now.")
		@health = (options[:health] || 15)
		@damage = (@options[:damage] || (3..6))
		@alt_names = options[:alt_names] || []
		@alt_names << @name.downcase unless @alt_names.include?(@name.downcase)

		# not required: 
		@action = options[:action].to_s.yellow
		@item_wanted = options[:item_wanted]
		@hidden = (options[:hidden] || false)
		@task = (options[:task] || nil)
		# This was left in because some characters will be able to be picked up
		@can_pickup = (options[:hidden] || true)

		@on_talk = options[:on_talk] || {} # ex. {task: ..., xp: ..., achievement: ..., dropped_items: ...}
		@on_action = options[:on_action] || {}
		@on_death = options[:on_death] || {}
		@on_death = {xp: 3, gold: 3}.merge(@on_death)

		# never set in options
		@is_alive = true
		@bad = false
		@merchant = false
	end

	def speak
		puts @talk.yellow
		@on_talk
	end

	def do_action
		puts @action
		@on_action
	end

	def die
		good = "You killed #{@name.cyan}. How rude."
		bad = "You have slain #{@name.red}!"
		puts (@bad ? bad : good) % @name
		@on_death
	end

	def is_alive
		@health > 0
	end

	alias_method :is_alive?, :is_alive

	def take_damage(amount)
		@health -= amount
		die unless is_alive
	end

	def attack
		rand(@damage)
	end

	def info
		puts "#@name's info:"
		puts "Health: #@health"
		puts "Race: #@race"
	end
end

class Enemy < Person
	def initialize(options = {})
		super
		@bad = true
	end
end

class Merchant < Person
	def initialize(options = {})
		super
		@on_death[:gold] = 45
		@damage = 15..30
		@talk = options[:talk] || "Like to shop around a bit, eh?"
		@stock = ObjectManager.new(options[:stock] || [])
		@on_death[:dropped_items] = @stock + (@on_death[:dropped_items] || ObjectManager.new([]))
	end

	def store(goldylocks)
		puts @talk.yellow
		puts "Items for sale:".magenta
		@stock.each do |item|
			puts "#{item.name}: #{(item.cost.to_s + ' gold').yellow}"
		end
		puts "\n"
		puts "Your gold: #{goldylocks}"
	end

	def sells(item)
		!!@stock[item]
	end
	
	alias_method :sells?, :sells

	def sell(item_name, player_gold)
		player_reward = {}
		if sells(item_name)
			item = @stock[item_name.to_sym]
			if player_gold >= (price = item.cost)
				player_reward[:items] = ObjectManager.new([
					@stock.delete(item_name)])
				player_reward[:gold] = -price
				@on_death[:gold] += price
				puts "You bought #{item.name} for #{price} gold"
			else
				puts "u ain't got the cash, boy."
			end
		else
			puts "That isn't sold here"
		end
		player_reward
	end

end