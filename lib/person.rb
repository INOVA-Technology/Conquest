class Person
	# this would make more sence if it were "class Person < Item"
	# its a lot like an item, but I like that it's in a separate file
	# I'll probably add that in or you can idc

	attr_accessor :name, :description, :race, :hidden, :can_pickup, :talk, :action, :item_wanted, :health, :task

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
		@xp = (@options[:xp] || 0) # make this small for good guys

		# not required: 
		@action = options[:action]
		@item_wanted = options[:item_wanted]
		@hidden = (options[:hidden] || false)
		@task = (options[:task] || nil)
		# This was left in because some characters will be able to be picked up
		@can_pickup = (options[:hidden] || true)

		# never set in options
		@is_alive = true
		@bad = false
		add_info
	end

	def die
		good = "You killed %s. How rude."
		bad = "You have slain %s!"
		puts (@bad ? bad : good) % @name
		$player.give_xp(@xp)
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
