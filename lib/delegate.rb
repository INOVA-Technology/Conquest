class Delegate

	attr_accessor :current_room

	def initialize(options = {})
		@options = options
		@save_file = "#{Dir.home}/.conquest_save"
		load_game(@save_file)
	end

	def parse(input)
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
			if item = $~[:item]
				pickup(item)
			else
				puts "Please supply an object to #{input}."
			end
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
		when /^quests?$/
			list_quests
		when /^(i|inv|inventory)$/
			inventory
		when /^climb( (?<tree_name>[a-z]+))?( tree)?$/
			# this regex needs to be cleaned up, just the tree part really
			# nvm, the whole regex sucks
			🌳 = $~[:tree_name]
			climb(🌳)
			# doesn't have to be a tree...
		when /^(fight|attack)( (?<enemy>[a-z]+)?)?$/
			if enemy = $~[:enemy]
				if e = $player.current_room.people[enemy.to_sym]
					if e.is_a?(Enemy)
						$player.fight(e)
					else
						# we'll change this part eventualy
						puts "Why would you want to hurt #{enemy}?"
					end
				else
					puts "Person isn't here"
				end
			else
				puts "Who?"
			end
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
		when /^\s?$/
		else
			😱 = ["I don't speak jibberish.","Speak up. Ur not making any sense.","R u trying to confuse me? Cuz dats not gonna work","What the heck is that supposed to mean?"]
			puts 😱.sample
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

	def walk(direction)
		if direction != "to mordor" && direction != "to merge conflictia"
			key = $player.current_room[direction]
			if new_room = $rooms[key]
				$player.current_room = new_room.enter
			else
				puts "You can't go that way."
			end
		elsif direction == "to mordor"
			puts "One does not simply walk to Mordor... You need to find the eagles. They will \ntake you to Mordor."
		elsif direction == "to merge conflictia"
			$player.current_room = $rooms[:merge_conflictia].enter
		end
	end

	def pickup(item)
		if _item = $player.current_room.items[item.to_sym]
			if _item.can_pickup
				_item = $player.current_room.remove_item(item)
				$player.pickup(item, _item)
			else
				puts "You can't pick that up."
			end
		else
			puts "That item isn't in here."
		end
	end

	def inventory
		$player.inventory
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

	def inspect(item)
		# this could be refactored
		if the_item = $player.items[item.to_sym]
			puts the_item.description
		elsif the_item = $player.current_room.items[item.to_sym]
			puts the_item.description
		elsif the_item = $player.current_room.people[item.to_sym]
			puts the_item.description
			puts "Race: #{the_item.race}"
		else
			puts "This item is not here or your inventory."
		end
	end

	def talk(guy)
		if $player.current_room.people[guy.to_sym]
			puts puts $player.current_room.people[guy.to_sym].talk.cyan
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
		begin
			raise TypeError if @options[:reset] # this is bad, I know :(
			data = nil
			File.open(file, 'r') { |file| data = Marshal.load(file) }
			$rooms  = $rooms.merge(data[:rooms])
			$quests = $quests.merge(data[:quests])
			$player = data[:player].setup
		rescue TypeError, Errno::ENOENT
			room = :courtyard
			$player = Player.new
			$player.current_room = $rooms[room]
			$quests[:main].start(false)
		end
	end

	def save
		File.open(@save_file, 'w') do |file|
			data = { rooms: $rooms, player: $player, quests: $quests }
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