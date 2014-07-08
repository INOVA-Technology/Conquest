class Item

	attr_reader :name, :description, :hidden, :can_pickup

	def initialize(name, description, options = {})
		@name = name
		@description = description
		@options = options
		@hidden = options[:hidden] || false
		@can_pickup = options[:hidden] || true
		@task = options[:task]
		add_info
	end

	def add_info
	end

end

class Prop < Item
	def add_info
		@hidden = true
		@can_pickup = false
	end
end

# sends you to a new room, usally something that
# has more functionality than just a room
class Transporter < Prop

	attr_accessor :goto

	def add_info
		@hidden = true
		@can_pickup = false
		@goto = options[:goto]
	end
end

# SUBCLASSES BELOW: (only subclass when you have a good reason)

# will add an eat method to this
class Food < Item
end

class Tree < Prop

	def climb
		if @task
			puts "I'll add this feature (task completion)"
			# $quests[@task[:quest]][@task[:task]].complete
			# add once quests becomes $quests
		end
		if @options[:can_climb]
			puts @description
		else
			puts "You start climbing the tree, but you don't get far before you fall down."
		end
	end
end
