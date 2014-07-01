class Delegate

	def initialize
		@rooms = RoomList.room_list
		@player = Player.new
		@current_room = @rooms[:courtyard].enter
	end

	def parse(input)
		# input will always be converted to lower case before getting here
		case input
		when /^(?<direction>(up|down|north|east|south|west|u|d|n|e|s|w))$/
			direction = $~[:direction]
			walk(direction)
		when /^(go|walk) (?<direction>(up|down|north|east|south|west|to mordor))$/
			direction = $~[:direction]
			walk(direction)
		when /^(get|take|pickup|pick up) (?<item>[a-z ]+)$/
			item = $~[:item]
			pickup(item)
		when "look"
			look
		when /^(i|inv|inventory)$/
			inventory
		when /^climb( (?<tree_name>[a-z]+))?( tree)?$/
			🌳 = $~[:tree_name]
			climb(🌳)
		when /^(quit|exit)$/
			quit
		when /^\s?$/
		else
			puts "What?"
		end
	end

	def walk(direction)
		if direction != "to mordor"
			if new_room = @rooms[@current_room[direction]]
				@current_room = new_room.enter
			else
				puts "You can't go that way."
			end
		else
			puts "One does not simply walk to Mordor."
		end
	end

	def pickup(item)
		le_item = @current_room.remove_item(item)
		@player.pickup(le_item)
	end

	def inventory
		@player.inventory
	end

	def look
		@current_room.look
	end

	def climb(tree_name)
		if 🌳 = @current_room.items[:tree]
			name = 🌳.name.downcase
			if tree_name.nil? || tree_name == "tree" || tree_name == name
				🌳.climb
			else
				puts "You can't climb that."
			end
		else
			puts "You can't climb that."
		end
	end

	def quit
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