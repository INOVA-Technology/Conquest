class Player

	attr_accessor :items, :current_room, :weapon, :time, :begining_of_time, :name, :upgrades, :real_time
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
		@begining_of_time = {year: 2000, month: 1, day: 1, hour: 6, minute: 30}
		@time = {year: 2000, month: 1, day: 1, hour: 6, minute: 30}
		@real_time = {total: 0, last_checked: DateTime.now}
		# @total[:total] is in minutes
		self
	end

	def get_time
		DateTime.new(*@time.values)
	end

	def add_minute
		@time[:minute] += 1
		if @time[:minute] == 60
			@time[:minute] = 0
			@time[:hour] += 1
		end
		if @time[:hour] == 24
			@time[:hour] = 0
			@time[:day] += 1
		end
		max_days = (Date.new(@time[:year], 12, 31) << (12-@time[:month])).day
		if @time[:day] > max_days
			@time[:day] = 1
			@time[:month] += 1
		end
		if @time[:month] > 12
			@time[:month] = 1
			@time[:year] += 1
		end
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
		# return if @items.none? { |k, v| v.is_a?(Weapon) }
		puts "Upgrades available! Plz enter the desired upgrade or cancel to do it later.".magenta
		puts "Weapon | Health "
		input = prompt.downcase
		if input == "weapon" || input == "w"
			if @items.none? { |k, v| v.is_a?(Weapon) }
				puts "You have no weapons :(".red
			else
				upgrade_weapon(nil)
			end
		elsif input == "health" || input == "h"
			@max_health += 10
			@health = @max_health
			puts "Max Health upgraded! +10".magenta
			return
		elsif input == "cancel" || input == "c"
			return
		else
			puts "Plz enter a valid input".red
			upgrade
		end
	end

	def upgrade_weapon(item_name)
		if item_name == nil
			puts "Choose a weapon to upgrade, or enter Cancel\nto save your upgrade for later"
			
			puts "Weapons available for upgrade:"
			@items.values.each do |item|
				if item.is_a?(Weapon)
					puts item.name.downcase
					puts "  Upgrades: +#{item.upgrade} damage"
				end
			end
			input = convert_input(prompt("choose a weapon: "))
			if input == "back" || input == "b"
				upgrade
			end
			item_name = input
		end

		if item = @items[item_name.to_sym]
			if item.is_a?(Weapon)
				value = 3 # this value can change
				item.upgrade += value
				puts "#{item.name} upgraded! +#{value} damage".magenta
				@upgrades -= 1

				cmd = "upgrade #{item_name}"
				add_command_to_history(cmd)
			else
				puts "That isn't a weapon."
				upgrade_weapon(nil)
			end
		else
			puts "You don't have that."
			upgrade_weapon(nil)
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
