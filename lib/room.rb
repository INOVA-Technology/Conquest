class Room

	attr_reader :items, :options, :people

	def initialize(name, description, options = {})
		@name = name
		@description = description
		@paths = options[:paths] || {}
		@items = options[:items] || {}
		@people = options[:people] || {}
		@options = options
		@visited = false
		add_info
	end

	def add_info

	end

	def [](direction)
		@paths[direction.to_sym]
	end

	def enter
		puts @name.cyan
		unless @visited
			puts @description
			list_items
		end
		@visited = true # can't hurt to set it every time, right?
		self
	end

	def remove_item(item)
		@items.delete(item.to_sym)
	end

	def look
		puts @name.cyan
		puts @description
		list_items
	end

	def list_items
		visible_items = @items.values.select { |i| (!i.hidden) && i.can_pickup }
		unless visible_items.empty?

			puts "Items that are here:".magenta
			visible_items.map do |item|
				a_or_an = %w[a e i o u].include?(item.name[0]) \
					? "an " : "a "
				a_or_an = "" if item.name[-1] == "s"
				puts "#{a_or_an}#{item.name.downcase}"
			end
		end

		visible_people = @people.values.select { |i| (!i.hidden)}
		unless visible_people.empty?

			puts "People that are here:".magenta
			visible_people.map do |people|
				puts "#{people.name}"
			end
		end

	end

end

class FightScene < Room
	# all people in a fight scene are assumed to be enemies

	def add_info
		@enemy = options[:enemy]
	end

	def enter
		puts @name.cyan
		puts @description
		# we should help them out with knowing commands to fight,
		# such as smack or flee and stuff
		list_items
		fight_loop
	end

	def fight_loop
		# this needs to check if the player dies
		while @enemy.is_alive
			process(prompt)
		end
	end

	def process(input)
		case input
		when /^smack$/
			@enemy.health -= $player.smack
			# its gotta say something
			# should give xp
		when /^\s*$/
		else
			puts "Who?"
		end
	end

end
