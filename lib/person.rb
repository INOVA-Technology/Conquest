class Person

	attr_reader :name, :description, :race, :hidden, :can_pickup

		def initialize(name, description, options = {})
			@name = name
			@description = description
			@options = options
			@hidden = options[:hidden] || false
			@race = options[:race]
			# This was left in because some characters will be able to be picked up
			@can_pickup = options[:hidden] || true 
			add_info
		end

		def add_info
		end

end

