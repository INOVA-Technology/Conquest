class Person
	# this would make more sence if it were "class Person < Item"
	# its a lot like an item, but I like that it's in a separate file
	# I'll probably add that in or you can idc

	attr_accessor :name, :description, :race, :hidden, :can_pickup, :talk, :action, :item_wanted, :health, :task, :gold

	alias_method :hidden?, :hidden
	alias_method :can_pickup?, :can_pickup

	def initialize(options = {})
		# this seems to be getting cluttered

		# required: 
		@name = options[:name]
		@description = options[:desc]
		@race = options[:race]
		@options = options

		# not required but recommended:
		@talk = (options[:talk] || "#@name doesn't want to talk right now.")
		@health = (options[:health] || 15)
		@damage = (@options[:damage] || (3..6))
		@items = (@options[:items] || {})
		@xp = (@options[:xp] || rand(0..5)) # make this small for good guys
		@gold = (@options[:gold] || rand(0..10))

		# not required: 
		@action = options[:action].to_s.yellow
		@item_wanted = options[:item_wanted]
		@hidden = (options[:hidden] || false)
		@task = (options[:task] || nil)
		# This was left in because some characters will be able to be picked up
		@can_pickup = (options[:hidden] || true)
		@on_talk = options[:on_talk] || {}

		# never set in options
		@is_alive = true
		@bad = false
		@merchant = false
		add_info
	end

	def speak
		puts @talk.yellow
		{achievement: @on_talk[:achievement], task: @on_talk[:task]}
	end

	def die
		good = "You killed #{@name.cyan}. How rude."
		bad = "You have slain #{@name.red}!"
		puts (@bad ? bad : good) % @name
		{xp: @xp, gold: @gold, dropped_items: @items}
	end

	def is_alive
		@health > 0
	end

	alias_method :is_alive?, :is_alive

	def add_info
	end

	def take_damage(amount)
		@health -= amount
		die unless is_alive	end

	def attack
		rand(@damage)
	end

	def info
		puts "#{name}'s info"
		puts "Health: #@health"
	end
end

class Enemy < Person
	def add_info
		@bad = true
	end
end

class Merchant < Person
	def add_info
		rand1 = rand(0..10)
		rand2 = rand(10..30)
		@gold = rand(20..100)
		@damage = (rand1..rand2)
		@talk = @options[:talk] || "Like to shop around a bit, eh?"
		@stock = @options[:stock] || {}
	end

	def store
		puts @talk
		puts "Items for sale:".magenta
		@stock.values.each do |item|
			puts "#{item.name}: #{(item.cost.to_s + ' gold').yellow}"
		end
	end

	def sells(item)
		!!@stock[item.to_sym]
	end
	
	alias_method :sells?, :sells

	def sell(item_name, player_gold)
		player_reward = {}
		if sells(item_name)
			item = @stock[item_name.to_sym]
			if player_gold >= (price = item.cost)
				player_reward[:items] = @stock.delete(item)
				player_reward[:gold] = -price
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