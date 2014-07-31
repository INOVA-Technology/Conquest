class Player

	attr_accessor :items, :current_room, :weapon, :time, :start_time, :name, :upgrades
	attr_reader :xp, :health, :weapon

	def initialize
		@upgrades = 0
		@items = {}
		@xp = 10
		@max_xp = 100
		@rank = 0
		@health = 45
		@max_health = 45
		@weapon = nil
		# its year, month, day, hour, minute
		# the year, month, and day should be changed. Probably to the past
		@start_time = [2000, 1, 1, 6, 30]
		@time = { virtual: DateTime.new(*@start_time) }
		@time[:real] = DateTime.now
		self
	end

	def get_time
		@time[:virtual] + time_since_start
	end

	def time_since_start
		DateTime.now - @time[:real]
	end

	def give_xp(amount)
		@xp += amount
		puts "+#{amount}xp!"
		$achievements[:over_9000].unlock if @xp > 9000
		rank_up if @xp >= @max_xp
	end

	def rank_up
		@rank += 1
		puts "Rank up!".magenta
		puts "Rank #{@rank}"
		@xp -= @max_xp 
		@max_xp += 50*(@rank*1)
		@max_health += 10*@rank
		puts "New upgrade available!".magenta
		@upgrades += 1
		upgrade unless $options[:loading]
		rank_up if @xp >= @max_xp
	end

	def upgrade
		if @upgrades.zero?
			puts "You have no upgrades available."
			return
		end
		return if @items.none? { |k, v| v.is_a?(Weapon) }

		puts "Choose a weapon to upgrade, or enter Cancel\nto save your upgrade for later"
		
		puts "Weapons available for upgrade:"
		@items.values.each do |item|
			if item.is_a?(Weapon)
				puts item.name.downcase
				puts "  Upgrades: +#{item.upgrade} damage"
			end
		end
		input = convert_input(prompt("choose a weapon: "))
		upgrade_weapon(input) unless /^c(ancel)?$/ === input
	end

	def upgrade_weapon(item_name)
		if item = @items[item_name.to_sym]
			if item.is_a?(Weapon)
				value = 3 # this value can change
				item.upgrade += value
				puts "#{item.name} upgraded! +#{value} damage"
				@upgrades -= 1

				cmd = "upgrade #{item_name}"
				add_command_to_history(cmd)
			else
				puts "That isn't a weapon."
				upgrade
			end
		else
			puts "You don't have that."
			upgrade
		end
	end

	def die(message = "What a disapointment...")
		puts message.red
		File.delete("#{Dir.home}/.conquest_save")
		exit
	end

	def is_alive
		@health > 0
	end

	def heal(amount)
		old_health = @health
		@health += amount
		@health = @max_health if @health > @max_health
		diff = @health - old_health
		puts "+#{diff} health!" if diff > 0
	end

	def take_damage(amount)
		@health -= amount
		die unless is_alive
	end

	def eat(food)
		if the_food = @items[food.to_sym]
			old_health = @health
			heal(the_food.restores)

			the_food.restores -= (@health - old_health)
			@items.delete(food.to_sym) if the_food.restores == 0
		else
			puts "You don't have that food."
		end
	end

	def pickup(key)
		if item = item_in_room(key)
			if item.can_pickup
				@current_room.pickup_item(key)
				@items[key.to_sym] = item
				if item.item_xp != 0 # 👻
					give_xp(item.item_xp)
					puts "xp +#{item.item_xp}".cyan
				end
			else
				puts "You can't pick that up."
			end
		else
			puts "That item isn't here."
		end
	end

	def inventory
		@items.values.each do |item|
			a_or_an = %w[a e i o u].include?(item.name[0]) \
				? "an " : "a "
			a_or_an = "" if item.name[-1] == "s"
			if item.is_a?(Weapon)
				puts "#{a_or_an}#{item.name.downcase}"
				# puts "  " + (@weapon == item ? "Equiped" : "Not equiped")
				puts "  Upgrades: +#{item.upgrade} damage"
			else
				puts "#{a_or_an}#{item.name.downcase}"
			end
		end
	end

	def smack
		rand(2..4)
	end

	def info
		puts "Health: #@health/#@max_health"
		puts "XP: #{@xp}/#{@max_xp} "
		puts "Rank: #{@rank}"
		puts "Equiped Weapon: #{(@weapon ? @weapon.name : "none")}"
		puts "Inventory:"
		inventory
	end

	def walk(place)
		if place == "to mordor"
			puts "One does not simply walk to Mordor... You need to find the eagles.\nThey will take you to Mordor."
			false
		elsif place == "to merge conflictia"
			:merge_conflictia
		else
			@current_room[place.to_sym]
		end
	end

	def item_in_room(item)
		@current_room.items[item.to_sym]
	end

end
