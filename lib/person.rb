class Person
	# this would make more sence if it were "class Person < Item"
	# its a lot like an item, but I like that it's in a separate file
	# I'll probably add that in or you can idc

	attr_accessor :name, :description, :race, :hidden, :can_pickup, :talk, :action, :item_wanted, :health, :task, :gold, :merchant

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
		$player.give_xp(@xp)
		$player.give_gold(@gold)
		$player.current_room.items.merge(@items)
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

		@merchant = true
		@gold = rand(20..100)
		@damage = (rand1..rand2)
		@talk = (@options[:talk] || "Like to shop around a bit, eh?")

		@stock = {"peach" => 5, "ice" => 2}

	end

	def store
		puts @talk
		puts "items".magenta
		@stock.each {|x, y|
			puts "#{x.cyan} cost:#{y.to_s.yellow}"
		}

		input = prompt.downcase
			if input == "peach"
				if $player.gold >= @stock[input] 
					$player.items[input.to_sym] = Food.new(name: "Peach", desc: "A delicious peach", restores: 5)
				else
					puts "u ain't got the cash, boy."
					store
				end
			elsif input == "ice"
				if $player.gold >= @stock[input] 
					$player.items[input.to_sym] = Food.new(name: "Ice", desc: "Just some ice", restores: 1)
				else
					puts "u ain't got the cash, boy."
					store
				end
			else
				puts "thats not an item"
				store
			end
		$player.gold -= @stock[input]
		puts "You bought #{input} for #{@stock[input]} gold"

	end

end





















