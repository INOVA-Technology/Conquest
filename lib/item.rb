class Item

	attr_reader :name, :description, :hidden, :can_pickup, :item_xp, :cost

	alias_method :can_pickup?, :can_pickup
	alias_method :hidden?, :hidden

	def initialize(options = {})
		# required:
		@name = options[:name]
		@description = options[:desc]
		@prefix = options[:prefix] || "" # not need when the item is plural
		@prefix += " " unless @prefix.empty?

		@options = options
		@hidden = options[:hidden] || false
		@can_pickup = !options[:hidden] || true
		@task = options[:task]
		@item_xp = options[:xp] || 0
		@cost = options[:cost] || 0
	end

	def pickup
		hash = {}
		hash[:quest] = @options[:starts_quest]
		hash[:achievement] = @options[:unlocks]
		hash[:task] = @task if @task
		hash
	end

	def name_with_prefix
		@prefix + @name.downcase
	end

	def info
		puts @description 
		look_info
	end

	def look_info
	end

end

class Prop < Item
	def initialize(options = {})
		super
		@hidden = true
		@can_pickup = false
	end
end

# SUBCLASSES BELOW:

class Food < Item

	attr_accessor :restores

	def initialize(options = {})
		super
		@restores = @options[:restores]
	end

	def look_info
		puts "Restores #@restores health."
	end
end

class Book < Item
	#attr_accessor :print
	
	def initialize(options = {})
		super
		@title = @options[:title]
		@print = @options[:print]
	end

	def read
		puts @title.yellow
		puts @print.yellow
	end

end

class Weapon < Item
	attr_accessor :attacks, :regex_attacks, :upgrade

	def initialize(options = {})
		super
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

