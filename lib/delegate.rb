class Delegate

	attr_accessor :current_room

	def initialize(options = {})
		@options = options
		@save_file = "#{Dir.home}/.conquest_save"
		load_game(@save_file)
	end

	def parse(input)
		check_time
		directions = "up|down|north|east|south|west|u|d|n|e|s|w"
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
		when /^quests?$/
			list_quests
		when /^achievements?$/
			list_achievements
		when /^(i|inv|inventory)$/
			inventory
		when /^climb( (?<tree_name>[a-z]+))?( tree)?$/
			# this regex needs to be cleaned up, just the tree part really
			# nvm, the whole regex sucks
			🌳 = $~[:tree_name]
			climb(🌳)
			# doesn't have to be a tree...
		when /^attack( (?<enemy>[a-z]+)?)?$/
			if enemy = $~[:enemy]
				attack(enemy)
			else
				puts "Who?"
			end
		when /^info$/
			info
		when /^eat( (?<food>[a-z]+)?)?$/
			if food = $~[:food]
				eat(food)
			else
				puts "Who?"
			end
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
		# 	useful for debugging, ALWAYS RE-COMMENT BEFORE A COMMIT
		# 	eval($~[:code])
		when /^\s?$/
		else
			😱 = ["I don't speak jibberish.","Speak up. Ur not making any sense.","R u trying to confuse me? Cuz dats not gonna work","What the heck is that supposed to mean?"]
			puts 😱.sample
		end
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
				puts "#{quest.name}#{' - Completed!' if done}"
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
	end

	def eat(food)
		$player.eat(food)
	end

	def attack(enemy)
		victim = $player.current_room.people[enemy.to_sym]
		if victim
			@enemy = victim
		else
			puts "Who?"
		end
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

	def climb(thing_name)
		if 🌳 = $player.current_room.items[:tree]
			name = 🌳.name.downcase
			if thing_name.nil? || thing_name == "tree" || thing_name == name
				🌳.climb
			else
				puts "You can't climb that."
			end

		# I don't like how this works :(
		elsif $player.current_room.options[:has_mountain]
			if ["up", "mountain", nil].include? thing_name
				walk("u")
			end
		else
			puts "You can't climb that."
		end
	end

	def load_game(file)
		File.delete(@save_file) if @options[:reset] && File.file?(@save_file)
		begin
			data = nil
			File.open(file, 'r') { |file| data = Marshal.load(file) }
			$rooms  = $rooms.merge(data[:rooms])
			$quests = $quests.merge(data[:quests])
			$player = data[:player].setup
			$achievements = data[:achievements]
			@enemy = data[:enemy]
		rescue TypeError, Errno::ENOENT
			room = :courtyard
			$player = Player.new
			$player.current_room = $rooms[room]
			$quests[:main].start(false)
			@enemy = nil
			get_name
		end
	end

	def get_name
		puts "Wut b ur namez?"
		$player_name = gets.chomp.downcase
	end

	def save
		$player.time[:virtual] += $player.time_since_start
		File.open(@save_file, 'w') do |file|
			data = { rooms: $rooms, player: $player, quests: $quests,
				achievements: $achievements, enemy: @enemy }
			file.puts(Marshal.dump(data))
		end
	end

	def quit
		save unless @options[:no_save]
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