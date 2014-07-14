class Item < ConquestClass


	attr_reader :name, :description, :hidden, :can_pickup, :is_weapon, :damage

	def setup(options = {})
		@name ||= options[:name]
		@description ||= options[:desc]
		@options ||= options
		@hidden ||= (options[:hidden] || false)
		@can_pickup ||= (!options[:hidden] || true)
		@task ||= options[:task]
		@is_weapon ||= options[:isweapon]
		@damage ||= options[:damage]
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

# SUBCLASSES BELOW: (only subclass when you have a good reason)

class Food < Item

	def add_info
		@restores = @options[:restores]
	end

	def eat
		$player.health += @restores
	end
end

class Tree < Prop

	def climb
		$quests[@task[:quest]].complete(@task[:task]) if @task
		if @options[:can_climb]
			puts @description
		else
			puts "You start climbing the tree, but you don't get far before you fall down."
		end
	end
end
