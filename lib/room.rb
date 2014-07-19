class Room < ConquestClass

	attr_reader :items, :options, :people

	def setup(options = {})
		@name ||= options[:name]
		@description ||= options[:desc]
		@paths ||= (options[:paths] || {})
		@items ||= (options[:items] || {})
		@people ||= (options[:people] || {})
		@options ||= options
		@visited ||= false
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
			quest = options[:starts_quest]
			$quests[quest].start if quest
			achievement = options[:unlocks]
			$achievements[achievement].unlock if achievement
			@visited = true
		end
		self
	end

	def pickup_item(item)
		@items.delete(item.to_sym).pickup
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

		visible_people = @people.values.select { |i| !i.hidden && i.is_alive }
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
			# then @enemy attacks the $player 
		end
	end

	def attack_player
		damage = @enemy.attack
		$player.health -= damage
		puts "The #{@enemy.name} attacked you! -#{damage}"
	end

	def process(input)
		case input
		when /^smack$/
			damage = $player.smack
			puts "You smacked the #{@enemy.name} -#{damage}"
			@enemy.health -= damage
			attack_player if @enemy.is_alive
		when /^\s*$/
		else
			puts "Who?"
		end
	end

end
