class Item

	attr_reader :name, :description, :hidden, :can_pickup, :item_xp, :cost, :alt_names

	alias_method :can_pickup?, :can_pickup
	alias_method :hidden?, :hidden

	def initialize(options = {})
		# required:
		@name = options[:name]
		@description = options[:desc]
		@prefix = options[:prefix] || "" # not needed when the item is plural
		@prefix += " " unless @prefix.empty?
		@options = options

		# not required:
		@can_pickup = !options[:hidden] || true
		@hidden = options[:hidden] || false
		@on_pickup = options[:on_pickup] || {}
		@alt_names = options[:alt_names] || []
		@alt_names << @name.downcase unless @alt_names.include?(@name.downcase)

		# only for merchants:
		@cost = options[:cost] || 0
	end

	def pickup
		@on_pickup
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

	attr_accessor :restores, :on_eat

	def initialize(options = {})
		super
		# @restores = options[:restores]
		@on_eat = options[:on_eat] || {}
		# @on_eat[:health] = @restores
	end

	def look_info
		puts "Restores #{@on_eat[:health]} health."
	end

	def eat
		@on_eat
	end
end

class Book < Item
	#attr_accessor :print
	
	def initialize(options = {})
		super
		@title = options[:title]
		@print = options[:print]
		@on_read = options[:on_read] || {}
	end

	def read
		puts @title.yellow
		puts @print.yellow
		@on_read
	end

end

class Weapon < Item
	attr_accessor :attacks, :regex_attacks, :upgrade

	def initialize(options = {})
		super
		@upgrade = 0
		@attacks = options[:attacks] # ex. {uppercut: 5..10, slash: 6..8, attack: 3..7} they all gotta be ranges, even 5..5 workss
		@regex_attacks = options[:regex_attacks] # ex. "uppercut|slash|attack"
	end

	def look_info
		puts "Upgrades: +#{upgrade} damage"
	end
end

class Armour < Item
	attr_accessor :protects, :type

	def initialize(options = {})
		super
		@protects = options[:protects]
		@type = options[:type]
		# type must be one of the following: :helmet, :chestplate, :pants, :boots, :shield
		# but feel free to add other kinds to this list
	end
end

class Tree < Prop

	def initialize(options = {})
		super
		@on_climb = options[:on_climb] || {}
		@message = options[:message]
	end

	def climb
		if @message
			puts @message
		else
			puts "You start climbing the tree, but you don't get far before you fall down." # 👻
		end
		@on_climb
	end
	
end

class Key < Item

	attr_accessor :unlocks_room

	def initialize(options = {})
		super
		@unlocks_room = options[:unlocks_room]
	end

end

class Ship < Item
	
end
