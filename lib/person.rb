class Person
	# this would make more sence if it were "class Person < Item"
	# its a lot like an item, but I like that it's in a separate file
	# I'll probably add that in or you can idc

	attr_accessor :name, :description, :race, :hidden, :can_pickup, :talk, :action, :item_wanted, :health, :task, :gold

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

		# never set in options
		@is_alive = true
		@bad = false
		@merchant = false
		add_info
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

	def add_info
	end

	def take_damage(amount)
		@health -= amount
		die unless is_alive
	end

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

	def buy(input, player_gold)
		item = input.to_sym
		give_to_player = {}
		if item = @stock[item]
			if player_gold >= (price = item.cost)
				give_to_player[:items] = @stock.delete(item)
				give_to_player[:gold] = -price
				puts "You bought #{item.name} for #{price} gold"
			else
				puts "u ain't got the cash, boy."
			end
		else
			puts "That isn't sold here"
		end
		give_to_player
	end

end