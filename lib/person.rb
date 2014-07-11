class Person
	# this would make more sence if it were "class Person < Item"
	# its a lot like an item, but I like that it's in a separate file
	# I'll probably add that in or you can idc

	attr_reader :name, :description, :race, :hidden, :can_pickup, :talk, :action, :item_wanted

		def initialize(name, description, options = {})
			# this seems to be getting cluttered
			@name = name
			@description = description
			@options = options
			@hidden = options[:hidden] || false
			@race = options[:race]
			@talk = options[:talk]
			@talk = @talk.yellow if @talk
			@action = options[:action]
			@item_wanted = options[:item_wanted]
			# This was left in because some characters will be able to be picked up
			@can_pickup = options[:hidden] || true 
			add_info
		end

		def add_info
		end



end

class Enemy < Person

	attr_reader :health, :damage
	
	def add_info
		@health = @options[:health]
		@damage = @options[:damage]
		@name = @name.red
	end

	def is_alive
		health > 0
	end

	def health=(new_health)
		@health = new_health
		check_dead
	end

	def check_dead
		if @health <= 0
			die
		end
	end

	def die
		puts "You have slain the #{name}"
	end

end