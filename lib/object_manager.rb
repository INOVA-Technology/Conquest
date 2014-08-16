class ObjectManager

	include Enumerable

	def initialize(objects)
		@objects = objects # an array
	end

	def each(&block)
		@objects.each(&block)
	end

	def [](name)
		index = nil
		name = name.to_s.downcase
		if name.split(" ").last =~ /^\d+$/
			index = name.split(" ").last.to_i
			name = name.split(" ")[0..-2].join(" ")
		end
		results = select { |o| o.alt_names.include?(name) }
		if results.one?
			results.first
		elsif results.empty?
			nil
		else
			if index
				results[index - 1]
			else
				puts "Which #{name}?"
			end
		end
	end

	def to_s
		@objects
	end

end

# list = [Item.new(name: "Peach", desc: "just a peach 1", alt_names: ["fruit"]),
# 		Item.new(name: "Peach", desc: "just a peach 2", alt_names: ["fruit"]),
# 		Item.new(name: "idk", desc: "idkidkdik"),
# 		Person.new(name: "Gus", desc: "im gus")]

# items = ObjectManager.new(list)
# p items["idk"]
# puts
# p items["peach"]
# puts
# p items["peach 1"]
# puts
# p items["peach 2"]
# puts
# p items["peach 3"]
# puts
# p items["gus"]

# exit
