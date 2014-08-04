class Item

	attr_reader :name, :description, :hidden, :can_pickup, :item_xp, :cost

	alias_method :can_pickup?, :can_pickup
	alias_method :hidden?, :hidden

	def initialize(options = {})
		@name = options[:name]
		@description = options[:desc]
		@options = options
		@hidden = options[:hidden] || false
		@can_pickup = !options[:hidden] || true
		@task = options[:task]
		@item_xp = options[:xp] || 0
		@cost = options[:cost] || 0
		add_info
	end

	def pickup
		hash = {}
		hash[:quest] = @options[:starts_quest]
		hash[:achievement] = @options[:unlocks]
		hash[:task] = @task if @task
		hash
	end

	def info
		puts @description 
		look_info
	end

	def look_info
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

	attr_accessor :restores

	def add_info
		@restores = @options[:restores]
	end

	def look_info
		puts "Restores #@restores health."
	end
end

class Book < Item
	#attr_accessor :print
	
	def add_info
		@title = @options[:title]
		@print = @options[:print]
	end

	def read
		puts @title.yellow
		puts @print.yellow
	end

end

class Weapon < Item
	attr_reader :upgrade
	attr_accessor :attacks, :regex_attacks, :upgrade

	def add_info
		@upgrade = 0
		@attacks = @options[:attacks] # ex. {uppercut: 5..10, slash: 6..8, attack: 3..7} they all gotta be ranges, even 5..5 workss
		@regex_attacks = @options[:regex_attacks] # ex. "uppercut|slash|attack"
	end

	def look_info
		puts "Upgrades: +#{upgrade} damage"
	end
end

class Tree < Prop

	def climb
		if @options[:on_climb]
			puts @options[:on_climb]
		else
			puts "You start climbing the tree, but you don't get far before you fall down." # 👻
		end
		hash = {}
		hash[:quest] = @options[:starts_quest]
		hash[:achievement] = @options[:unlocks]
		hash[:task] = @task if @task
		hash
	end
	
end

