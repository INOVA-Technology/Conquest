class Person
	# this would make more sence if it were "class Person < Item"
	# its a lot like an item, but I like that it's in a separate file
	# I'll probably add that in or you can idc

	attr_reader :name, :description, :race, :hidden, :can_pickup, :talk, :action, :item_wanted, :bad_guy

		def initialize(name, description, options = {})
			@name = name
			@description = description
			@options = options
			@hidden = options[:hidden] || false
			@race = options[:race]
			@talk = options[:talk]
			@action = options[:action]
			@item_wanted = options[:item_wanted]
			@bad_guy = options[:bad_guy]
			# This was left in because some characters will be able to be picked up
			@can_pickup = options[:hidden] || true 
			add_info
		end

		def add_info
		end



end

