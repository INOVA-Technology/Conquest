class Delegate

	attr_accessor :current_room

	def initialize
		@rooms = RoomList.room_list
		@player = Player.new
		@current_room = @rooms[:courtyard]
		@help = 0
	end

	def parse(input)
		directions = "up|down|north|east|south|west|u|d|n|e|s|w"
		# input will always be converted to lower case before getting here
		case input
		when /^(?<direction>(#{directions}))$/
			direction = $~[:direction]
			walk(direction)
		when /^(go|walk)( (?<direction>#{directions}|to mordor))?$/
			direction = $~[:direction]
			if direction
				walk(direction)
			else
				puts "#{input.capitalize} where?"
			end
		when /^(get|take|pickup|pick up)( (?<item>[a-z ]+))?$/
			item = $~[:item]
			if item
				pickup(item)
			else
				puts "Please supply an object to #{input}."
			end
		when /^look( (?<item>[a-z]+))?$/
			item = $~[:item]
			item.nil? ? look : inspect(item)
		when /^inspect( (?<item>[a-z]+))?$/
			item = $~[:item]
			if item
				inspect(item)
			else
				puts "Please supply an object to inspect."
			end
		when /^rub sticks( together)?$/
			rub_sticks
		when /^(i|inv|inventory)$/
			inventory
		when /^climb( (?<tree_name>[a-z]+))?( tree)?$/
			# this regex needs to be cleaned up, just the tree part really
			🌳 = $~[:tree_name]
			climb(🌳)
			# doesn't have to be a tree...
		when /^(help|h)$/
			smart_aleck = ["Why?","No.","Stop asking plz.","seriously, shut up.","...","...","...","Ok, seriously.","Do u not understand the meaning of \"be quiet\"?","ug"]
			puts smart_aleck[@help]
			@help = @help + 1
			if @help > smart_aleck.length
				@help = 0
			end

		when /^(quit|exit)$/
			quit
		when /^\s?$/
		else
			😱 = ["I don't speak jibberish.","Speak up. Ur not making any sense.","R u trying to confuse me? Cuz dats not gonna work","What the heck is that supposed to mean?"]
			puts 😱.sample
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
		if _item = @current_room.items[item.to_sym]
			if _item.can_pickup
				_item = @current_room.remove_item(item)
				@player.pickup(item, _item)
			else
				puts "You can't pick that up."
			end
		else
			puts "That item isn't in here."
		end
	end

	def inventory
		@player.inventory
	end

	def look
		@current_room.look
	end

	def inspect(item)
		# this could be refactored
		if the_item = @player.items[item.to_sym]
			puts the_item.description
		elsif the_item = @current_room.items[item.to_sym]
			puts the_item.description
		else
			puts "This item is not here or your inventory."
		end
	end

	def rub_sticks
		if @player.items[:sticks]
			# do something involving fire
			puts "I need to implement this."
		end
	end

	def climb(thing_name)
		if 🌳 = @current_room.items[:tree]
			name = 🌳.name.downcase
			if thing_name.nil? || thing_name == "tree" || thing_name == name
				🌳.climb
			else
				puts "You can't climb that."
			end

		# I don't like how this works :(
		elsif @current_room.options[:has_mountain]
			if ["up", "mountain", nil].include? thing_name
				walk("u")
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