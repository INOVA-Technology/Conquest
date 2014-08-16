class ObjectManager

	include Enumerable

	def initialize(objects)
		@objects = objects
	end

	def each(&block)
		@objects.each(&block)
	end

	def [](name)
		results = select { |o| o.alt_names.include?(name) }
		if results.one?
			results.first
		else
			puts "Which #{name}?"
		end
	end

end

# list = [Item.new(name: "Peach", desc: "just a peach", alt_names: ["fruit"]),
# 		Item.new(name: "Peach", desc: "just a peach", alt_names: ["fruit"]),
# 		Item.new(name: "idk", desc: "idkidkdik")]

# items = ObjectManager.new(list)
# p items["idk"]
# exit