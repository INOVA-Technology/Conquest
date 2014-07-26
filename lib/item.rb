class Item

	attr_reader :name, :description, :hidden, :can_pickup, :item_xp

	def initialize(options = {})
		@name = options[:name]
		@description = options[:desc]
		@options = options
		@hidden = (options[:hidden] || false)
		@can_pickup = (!options[:hidden] || true)
		@task = options[:task]
		@item_xp = (options[:xp] || 0)
		add_info
	end

	def pickup
		quest = @options[:starts_quest]
		$quests[quest].start if quest
		achievement = @options[:unlocks]
		$achievements[achievement].unlock if achievement
		self
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

# SUBCLASSES BELOW:

class Food < Item

	def add_info
		@restores = @options[:restores]
	end

	def eat
		$player.health += @restores
	end
end

class Weapon < Item

	attr_accessor :damage, :attacks, :regex_attacks, :upgrade

	def add_info
		@upgrade = 0
		@attacks = @options[:attacks] # ex. {uppercut: 5..10, slash: 6..8, attack: 3..7} they all gotta be ranges, even 5..5 workss
		@regex_attacks = @options[:regex_attacks] # ex. "uppercut|slash|attack"
	end
end

class Tree < Prop

	def climb
		$quests[@task[:quest]].complete(@task[:task]) if @task
		if @options[:can_climb]
			puts @description
		else
			puts "You start climbing the tree, but you don't get far before you fall down." # 👻
		end
	end
end

