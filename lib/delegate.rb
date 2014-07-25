class Delegate

	attr_accessor :current_room

	def initialize(options = {})
		@options = options
		@save_file = options[:save_file] || "#{Dir.home}/.conquest_save"
		load_game(@save_file)
	end

	def parse(input, write_to_history = true, secrets_allowed = false)
		check_time
		save_command = true
		directions = "up|down|north|east|south|west|u|d|n|e|s|w"

		# this would be part of a regex, like directions. ex. "uppercut|slash|attack"
		special_attacks = ($player.weapon.nil? ? "" : $player.weapon.regex_attacks)
		# input will always be converted to lower case before getting here
		case input
		when /^(?<direction>(#{directions}))$/
			direction = $~[:direction]
			walk(direction)
		when /^(go|walk)( (?<direction>#{directions}|to mordor|to merge conflictia))?$/
			if direction = $~[:direction]
				walk(direction)
			else
				puts "#{input.capitalize} where?"
			end
		when /^(get|take|pickup|pick up)( (?<item>[a-z ]+))?$/
			item = $~[:item]
			pickup(item)
		when /^look( (?<item>[a-z]+))?$/
			item = $~[:item]
			item.nil? ? look : inspect(item)
		when /^(talk|speak) to( (?<guy>[a-z]+))?$/
			if guy = $~[:guy]
				talk(guy)
			else
				puts "Who?"
			end
		when /^give( (?<item>[a-z]+)) to( (?<guy>[a-z]+))?$/
			item = $~[:item]
			guy = $~[:guy]
			give(item, guy)
		when /^inspect( (?<item>[a-z]+))?$/
			if item = $~[:item]
				inspect(item)
			else
				puts "Please supply an object to inspect."
			end
		when /^rub sticks( together)?$/
			rub_sticks
		when /^equip( (?<weapon>[a-z]+))?$/
			if weapon = $~[:weapon]
				equip(weapon)
			else
				puts "Please supply an weapon to equip."
			end
		when /^unequip?$/
			unequip
		when /^quests?$/
			list_quests
		when /^achievements?$/
			list_achievements
		when /^(i|inv|inventory)$/
			inventory
		when /^climb( (?<tree_name>[a-z ]+))?$/
			# this regex needs to be cleaned up, just the tree part really
			# nvm, the whole regex sucks
			🌳 = $~[:tree_name]
			climb(🌳)
			# doesn't have to be a tree...
		when /^(?<attack>(#{special_attacks}))( (?<enemy>[a-z]+)?)?$/
			attack = $~[:attack]
			enemy = $~[:enemy]
			fight(enemy, $player.weapon.attacks[:attack])
			save_command = false

		# this'll run if they don't have a weapon or their weapon doesn't 
		# have both an attack method and "attack" in the attacks variable
		when /^attack( (?<enemy>[a-z]+)?)?$/
			enemy = $~[:enemy]
			fight(enemy, $player.smack)
			save_command = false
		when /^info$/
			info
		when /^eat( (?<food>[a-z]+)?)?$/
			if food = $~[:food]
				eat(food)
			else
				puts "Who?"
			end
		when /^mine$/
			mine
		when /^time$/
			time
		when /^(help|h)$/
			@smart_aleck ||= ["Why?","No.","Stop asking plz.","seriously, shut up.","...","...","...","Ok, seriously.","Do u not understand the meaning of \"be quiet\"?","ug"].to_enum
			begin
				puts @smart_aleck.next
			rescue StopIteration
				@smart_aleck.rewind
				puts @smart_aleck.next
			end
		when /^(quit|exit)$/
			quit
		when /^save( game)?$/
			save
		# when /^- (?<code>.+)$/
		# 	eval($~[:code])
		# 	save_command = false
			# useful for debugging, ALWAYS RE-COMMENT BEFORE A COMMIT
		when /^\s?$/
		else
			😱 = ["I don't speak jibberish.","Speak up. Ur not making any sense.","R u trying to confuse me? Cuz dats not gonna work","What the heck is that supposed to mean?"]
			puts 😱.sample
			save_command = false
			if secrets_allowed # for saving purposes only
				case input
				when /^damage (?<player_damage>\d+) (?<enemy_damage>\d+)\s?$/
					player_damage = $~[:player_damage].to_i
					enemy_damage = $~[:enemy_damage].to_i
					$player.health -= player_damage if @enemy
					@enemy.health -= enemy_damage if @enemy
					@enemy = nil unless @enemy.nil?
				when /^enemy (?<enemy>[a-z]+)\s?$/
					enemy = $~[:enemy]
					@enemy = $player.current_room.people[enemy.to_sym]
				when /^name (?<name>.+)\s?$/
					name = $~[:name]
					$player.name = name
				end
			end
		end
		open(@save_file, "a") { |file| file.puts input } if write_to_history && save_command
	end

	def check_time
		counter = Thread.new do
			the_time = $player.start_time
			the_time[4] += 10
			if DateTime.new(*the_time) <= $player.get_time
				$achievements[:ten_minutes].unlock
			end
			sleep(60)
		end
	end

	def list_quests
		started_quests = $quests.values.select { |i| (i.started) }
		unless started_quests.empty?
			puts "Started Quests:".magenta
			started_quests.map do |quest|
				done = quest.completed
				puts quest.tasks_completed
				puts "#{quest.name}#{' - Completed!' if done} #{(quest.tasks_completed.to_f/quest.tasks.length.to_f)*100}%"
				puts "  Current Task: #{quest.current_task[:description]}" \
					unless done
			end
		end
	end

	def list_achievements
		$achievements.each do |_, a|
			puts a.name if a.unlocked
		end
	end

	def time
		# this message seems awkwardly worded
		puts $player.get_time.strftime("It's the year of %Y, %b %d, %I:%M %p")
	end

	def walk(direction)
		key = $player.walk(direction)
		if key.nil?
			puts "You can't go that way"
		elsif key
			$player.current_room = $rooms[key].enter
		end
	end

	def pickup(item_name)
		if item_name.nil?
			puts "Please supply an object to #{input}."
		else
			$player.pickup(item_name)
		end
	end

	def inventory
		$player.inventory
	end

	def info
		$player.info
		@enemy.info if @enemy
	end

	def eat(food)
		$player.eat(food)
	end

	def fight(enemy, damage)
		# refactor this
		if enemy.nil?
			if @enemy
				attack(damage)
			else
				puts "You aren't fighting anyone."
			end
		else
			victim = $player.current_room.people[enemy.to_sym]
			if victim
				if @enemy
					if victim.name.downcase != @enemy.name.downcase
						puts "You are already fighting someone else."
						return
					end
				end
				if victim.is_alive
					@enemy = victim
					input = "enemy #{enemy}"
					open(@save_file, "a") { |file| file.puts input }
					attack(damage)
				else
					puts "#{enemy} is dead."
				end
			else
				puts "#{enemy} isn't here."
			end
		end
	end

	def attack(damage_range)
		damage = rand(damage_range)
		puts "You smacked the #{@enemy.name} -#{damage}"
		@enemy.health -= damage

		_damage = 0
		if @enemy.is_alive
			_damage = @enemy.attack
			puts "The #{@enemy.name} attacked you! -#{_damage}"
			$player.health -= _damage
		else
			@enemy = nil
		end
		input = "damage #{_damage} #{damage}"
		open(@save_file, "a") { |file| file.puts input }
	end

	def give(item, guy)
		# Do I have this item?
		if the_item = $player.items[item.to_sym]
			# Does this guy even exist?
			if $player.current_room.people[guy.to_sym]
				# awesome, we r not crazy... But does guy want this item?
				if $player.current_room.people[guy.to_sym].item_wanted == item
					puts $player.current_room.people[guy.to_sym].action
				else
					puts "hmmm... it seems #{guy} doesn't know what to do with that..."
				end
			else
				puts "Ummmm... That person doesn't seem to be here."
			end
		else
			puts "Ummmm... You don't have that item..."
		end

	end

	def look
		$player.current_room.look
	end

	def equip(weapon_name)
		if weapon = $player.items[weapon_name.to_sym]
			if weapon.is_a?(Weapon)
				$player.weapon = weapon
				puts "#{weapon_name} has been equipped!".cyan
			else
				puts "That's not a weapon, stupid.".red
			end
		else
			puts "you do not own that item...".red
		end
	end

	def unequip
		$player.weapon = nil
	end

	def inspect(item)
		# this could be refactored
		if the_item = $player.items[item.to_sym]
			puts the_item.description
			if the_item.is_a?(Weapon)
				puts "Damage: #{the_item.damage}"
			end
		elsif the_item = $player.current_room.items[item.to_sym]
			puts the_item.description
			if the_item.is_a?(Weapon)
				puts "Damage: #{the_item.damage}"
			end
		elsif the_item = $player.current_room.people[item.to_sym]
			puts the_item.description
			puts "Race: #{the_item.race}"
		else
			puts "This item is not here or your inventory."
		end
	end

	def talk(guy)
		if $player.current_room.people[guy.to_sym]
			puts $player.current_room.people[guy.to_sym].talk.cyan
		else
			puts "#{guy} isn't in this room.".cyan
		end
	end

	def rub_sticks
		if $player.items[:sticks]
			# do something involving fire
			puts "I need to implement this."
		end
	end

	def mine
		if $player.current_room.is_a?(Mountain)
			if $player.items[:pickaxe]
				$player.current_room.mine
			else
				puts "You have nothing to mine with."
			end
		else
			puts "There's nothing here to mine."
		end
	end

	def climb(thing_name)
		thing_name = convert_input(thing_name)
		if 🌳 = $player.current_room.items[:tree]
			name = 🌳.name.downcase
			if [nil, "tree"].include?(thing_name)
				🌳.climb
			else
				puts "You can't climb that."
			end
		elsif $rooms[$player.current_room[:u]].is_a?(Mountain)
			if [nil, "mountain"].include?(thing_name)
				walk("u")
			end
		else
			puts "There's nothing here to climb."
		end
	end

	def load_game(file)
		File.delete(@save_file) if File.file?(@save_file) && @options[:reset]
		room = :courtyard
		$player = Player.new
		$player.current_room = $rooms[room]
		$quests[:main].start(false)
		@enemy = nil
		if File.file?(file)
			old_stdout = $stdout
			$stdout = StringIO.new
			File.foreach(file) do |line|
				parse(line, false, true)
			end
			$stdout = old_stdout
		else
			get_name
		end
	end

	def get_name
		puts "Wut b ur namez?"
		$player.name = prompt
		input = "name #{$player.name}"
		open(@save_file, "a") { |file| file.puts input }
	end

	def quit
		puts "Come back when you can't stay so long!"
		exit
	end

	#     _   __                   
	#    / | / /__ _   _____  _____
	#   /  |/ / _ \ | / / _ \/ ___/
	#  / /|  /  __/ |/ /  __/ /    
	# /_/ |_/\___/|___/\___/_/     

	#    ______                       
	#   / ____/___  ____  ____  ____ _
	#  / / __/ __ \/ __ \/ __ \/ __ `/
	# / /_/ / /_/ / / / / / / / /_/ / 
	# \____/\____/_/ /_/_/ /_/\__,_/  

	#    _______          
	#   / ____(_)   _____ 
	#  / / __/ / | / / _ \
	# / /_/ / /| |/ /  __/
	# \____/_/ |___/\___/ 

	# __  __           
	# \ \/ /___  __  __
	#  \  / __ \/ / / /
	#  / / /_/ / /_/ / 
	# /_/\____/\__,_/  

	#    __  __    
	#   / / / /___ 
	#  / / / / __ \
	# / /_/ / /_/ /
	# \____/ .___/ 
	#     /_/      

	# do something with this
	lyrics = [
	/^We(')?re no strangers to love[\.,]?$/i,
	/^You know the rules and so do I[\.,]?$/i,
	/^A full commitment(')?s what I(')?m thinking of[\.,]?$/i,
	/^You wouldn(')?t get this from any other guy[\.,]?$/i,

	/^I just wanna tell you how I(')?m feeling[\.,]?$/i,
	/^Gotta make you understand[\.,]?$/i,

	/^Never gonna give you up[\.,]?$/i,
	/^Never gonna let you down[\.,]?$/i,
	/^Never gonna run around and desert you[\.,]?$/i,
	/^Never gonna make you cry[\.,]?$/i,
	/^Never gonna say goodbye[\.,]?$/i,
	/^Never gonna tell a lie and hurt you[\.,]?$/i,

	/^We(')?ve known each other for so long[\.,]?$/i,
	/^Your heart(')?s been aching, but[\.,]?$/i,
	/^You(')?re too shy to say it[\.,]?$/i,
	/^Inside,? we both know what(')?s been going on[\.,]?$/i,
	/^We know the game and we(')?re gonna play it[\.,]?$/i,

	/^And if you ask me how I(')?m feeling[\.,]?$/i,
	/^Don(')?t tell me you(')?re too blind to see[\.,]?$/i,
	# 👻
	/^Never gonna give you up[\.,]?$/i,
	/^Never gonna let you down[\.,]?$/i,
	/^Never gonna run around and desert you[\.,]?$/i,
	/^Never gonna make you cry[\.,]?$/i,
	/^Never gonna say goodbye[\.,]?$/i,
	/^Never gonna tell a lie and hurt you[\.,]?$/i,

	/^Never gonna give you up[\.,]?$/i,
	/^Never gonna let you down[\.,]?$/i,
	/^Never gonna run around and desert you[\.,]?$/i,
	/^Never gonna make you cry[\.,]?$/i,
	/^Never gonna say goodbye[\.,]?$/i,
	/^Never gonna tell a lie and hurt you[\.,]?$/i,

	/^Ooh, give you up[\.,]?$/i,
	/^Ooh, give you up[\.,]?$/i,
	/^Never gonna give,? never gonna give[\.,]?$/i,
	/^Give you up[\.,]?$/i,
	/^Never gonna give,? never gonna give[\.,]?$/i,
	/^Give you up[\.,]?$/i,

	/^We(')?ve known each other for so long[\.,]?$/i,
	/^Your heart(')?s been aching, but[\.,]?$/i,
	/^You(')?re too shy to say it[\.,]?$/i,
	/^Inside,? we both know what(')?s been going on[\.,]?$/i,
	/^We know the game and we(')?re gonna play it[\.,]?$/i,

	/^I just wanna tell you how I(')?m feeling[\.,]?$/i,
	/^Gotta make you understand[\.,]?$/i,

	/^Never gonna give you up[\.,]?$/i,
	/^Never gonna let you down[\.,]?$/i,
	/^Never gonna run around and desert you[\.,]?$/i,
	/^Never gonna make you cry[\.,]?$/i,
	/^Never gonna say goodbye[\.,]?$/i,
	/^Never gonna tell a lie and hurt you[\.,]?$/i,

	/^Never gonna give you up[\.,]?$/i,
	/^Never gonna let you down[\.,]?$/i,
	/^Never gonna run around and desert you[\.,]?$/i,
	/^Never gonna make you cry[\.,]?$/i,
	/^Never gonna say goodbye[\.,]?$/i,
	/^Never gonna tell a lie and hurt you[\.,]?$/i,

	/^Never gonna give you up[\.,]?$/i,
	/^Never gonna let you down[\.,]?$/i,
	/^Never gonna run around and desert you[\.,]?$/i,
	/^Never gonna make you cry[\.,]?$/i,
	/^Never gonna say goodbye[\.,]?$/i,
	/^Never gonna tell a lie and hurt you[\.,]?$/i
	]

end