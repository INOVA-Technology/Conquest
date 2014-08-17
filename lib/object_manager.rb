class ObjectManager

	attr_accessor :objects

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

	def +(other)
		ObjectManager.new(@objects + other.objects)
	end

	def <<(other)
		@objects << other
	end

	def delete(key)
		@objects.delete(self[key])
	end

end

# an_object_manager["peach"] would get a peach
# if there were two peaches, it'd return nil and ask "Which peach?"
# if there were two, the following lines would pick one:
#   an_object_manager["peach 1"]
#   and an_object_manager["peach 2"]
# 
# thats pretty much it. It "includes" enumerable to you can use any
# "reject", "select", "reduce", or other enum methods on it
#

