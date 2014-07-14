class Person < ConquestClass
	# this would make more sence if it were "class Person < Item"
	# its a lot like an item, but I like that it's in a separate file
	# I'll probably add that in or you can idc

	attr_reader :name, :description, :race, :hidden, :can_pickup, :talk, :action, :item_wanted, :health

		def setup(options = {})
			# this seems to be getting cluttered
			@name ||= options[:name]
			@description ||= options[:desc]
			@options ||= options
			@hidden ||= (options[:hidden] || false)
			@race ||= options[:race]
			@talk ||= options[:talk]
			@talk = @talk.yellow if @talk
			@action ||= options[:action]
			@item_wanted ||= options[:item_wanted]
			# This was left in because some characters will be able to be picked up
			@can_pickup ||= (options[:hidden] || true)
			@is_alive ||= true
			@health ||= (options[:health] || 50)
			add_info
		end

		def is_alive
			health > 0
		end

		def add_info
		end



end

class Enemy < Person

	attr_reader :damage, :xp
	# add :reward to attr_reader, it'll be an items(s)
	
	def add_info
		@health ||= @options[:health]
		@damage ||= @options[:damage] # should be a range
		@name ||= @name.red
		@xp ||= (@options[:xp] || 0)
		@items ||= (@options[:items] || {})
	end

	def health=(new_health)
		@health = new_health
		die unless is_alive
	end

	def is_alive
		@health > 0
	end

	def die
		puts "You have slain the #{name}!"
		$player.xp += @xp
		$player.current_room.items.merge(@items)
	end

	def attack
		rand(damage)
	end

end