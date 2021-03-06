class Delegate

	attr_accessor :player, :timer, :rooms

	def initialize
		load_game
		keep_time
	end

	def parse(input)
		check_time unless $options[:loading]
		save_command = true
		directions = "up|down|north|east|south|west|u|d|n|e|s|w|ne|nw|se|sw|north ?(east|west)|south ?(east|west)"

		# this would be part of a regex, like directions. ex. "uppercut|slash|attack"
		special_attacks = (@player.weapon.nil? ? "dontMakeAnAttackNamedThis" : @player.weapon.regex_attacks)
		# input will always be converted to lower case before getting here
		case input
		when /^(?<direction>(#{directions}))$/
			direction = shorten_path($~[:direction])
			walk(direction)
		when /^(go|walk)( (?<direction>#{directions}|to mordor|to merge conflictia))?$/
			if direction = shorten_path($~[:direction])
				walk(direction)
			else
				puts "#{input.capitalize} where?"
			end
		when /^(get|take|pick ?up)( (?<item>[a-z ]+))?$/
			item = $~[:item]
			pickup(item)
		when /^look( (at )?(?<item>[a-z]+))?$/
			item = $~[:item]
			item.nil? ? look : inspect(item)
		when /^(talk|speak)( to)?( (?<guy>[a-z ]+))?$/
			if guy = $~[:guy]
				talk(guy)
			else
				puts "Who?"
			end
		when /^buy( (?<item>[a-z ]+)?)?$/
			item = $~[:item]
			if item
				buy(item)
			else
				puts "Buy what?"
			end
		when /^(give (?<item>[a-z]+) to (?<guy>[a-z ]+)|give( (?<guy>[a-z]+)?( (?<item>[a-z]+)?)?)?)$/
			item = $~[:item]
			guy = $~[:guy]
			give(item, guy)
		when /^inspect( (?<item>[a-z ]+))?$/
			if item = $~[:item]
				inspect(item)
			else
				puts "Please supply an object to inspect."
			end
		when /^rub sticks( together)?$/
			rub_sticks
		when /^read( (?<book>[a-z ]+))?$/
			if book = $~[:book]
				read(book)
			else
				puts "Please supply an book to read."
			end
		when /^equip( (?<weapon>[a-z ]+))?$/
			if weapon = $~[:weapon]
				equip(weapon)
			else
				puts "Please supply an item to equip."
			end
		when /^drop( (?<item>[a-z ]+))?$/
			item = $~[:item]
			drop(item)
		when /^unequip( (?<item>[a-z ]+))??$/
			if item = $~[:item]
				unequip(item)
			else
				puts "Please supply an item to unequip."
			end
		when /^quests$/
			list_quests
		when /^achievements$/
			list_achievements
		when /^unlock( (?<path>#{directions}))?$/
			path = shorten_path($~[:path])
			if path
				unlock_path(path)
			else
				puts "usage: unlock direction"
			end
		when /^climb( (?<tree_name>[a-z ]+))?$/
			# this regex needs to be cleaned up, just the tree part really
			# nvm, the whole regex sucks
			🌳 = $~[:tree_name]
			climb(🌳)
			# doesn't have to be a tree...
		when /^(?<attack>(#{special_attacks}))( (?<enemy>[a-z ]+)?)?$/
			attack = $~[:attack].to_sym
			enemy = $~[:enemy]
			fight(enemy, attack)
			save_command = false

		# this'll run if they don't have a weapon or their weapon doesn't 
		# have both an attack method and "attack" in the attacks variable
		when /^attack( (?<enemy>[a-z ]+)?)?$/
			enemy = $~[:enemy]
			fight(enemy, @player.smack)
			save_command = false
		when /^(i|inv|inventory|info)$/
			info
		when /^eat( (?<food>[a-z ]+)?)?$/
			if food = $~[:food]
				eat(food)
			else
				puts "Who?"
			end
		when /^upgrade( weapon)?$/
			@player.upgrade
			save_command = false
		when /^mine$/
			mine
		when /^time$/
			time
		when /^supercalifragilisticexpialidocious$/
			@player.give_stuff(@player.achievements[:commitment].unlock)
		when /^(h|help|\?)$/
			help
		when /^(quit|exit)$/
			quit
		when /^- (?<code>.+)$/
			eval($~[:code])
			save_command = false
			# useful for debugging, ALWAYS RE-COMMENT BEFORE A COMMIT
		when /^\s?$/
		else
			😱 = ["I don't speak jibberish.","Speak up. Ur not making any sense.","R u trying to confuse me? Cuz dats not gonna work","What the heck is that supposed to mean?", "Ur about the biggest idiot I've ever seen.", "What the crap are u trying to say?", "Ya, sure.", "Ur face", "Why? Why me?", "I'm about ready to quit, this job is to stressful"]
			puts 😱.rand_choice
			save_command = false
			if $options[:loading] # for saving purposes only
				case input
				when /^damage (?<player_damage>\d+) (?<enemy_damage>\d+)\s?$/
					player_damage = $~[:player_damage].to_i
					enemy_damage = $~[:enemy_damage].to_i
					@player.take_damage(player_damage)
					stuff = @enemy.take_damage(enemy_damage)
					@player.give_stuff(stuff) unless @enemy.is_alive?
					@enemy = nil unless @enemy.is_alive?
				when /^enemy (?<enemy>[a-z_]+)\s?$/
					enemy = $~[:enemy]
					@enemy = @player.room.people[enemy.to_sym]
				when /^name (?<name>.+)\s?$/
					name = $~[:name]
					@player.name = name
				when /^unlock (?<achievement>[a-z_]+)\s?$/
					achievement = $~[:achievement]
					@player.give_stuff(@player.achievements[achievement.to_sym].unlock)
				when /^time (?<year>\d+) (?<month>\d+) (?<day>\d+) (?<hour>\d+) (?<minute>\d+)\s?$/
					t = [$~[:year], $~[:month], $~[:day], $~[:hour], $~[:minute]].map(&:to_i)
					@player.time = Hash[[:year, :month, :day, :hour, :minute].zip(t)]
				when /^total_seconds (?<seconds>\d+)\s?$/
					seconds = $~[:seconds].to_i
					@player.total_seconds = seconds
				when /^upgrade (?<weapon>[a-z_ ]+)\s?$/
					weapon = $~[:weapon]
					@player.upgrade_weapon(weapon)
				when /^add_upgrade\s?$/
					@player.upgrades += 1
				end
			end
		end
		add_command_to_history(input) if !$options[:loading] && save_command

		# remove lines in readline history containing only white space
		Readline::HISTORY.pop if Readline::HISTORY.to_a[-1].to_s.match(/^\s*$/)
	end

	def keep_time
		@timer = Thread.new do
			loop do
				sleep 2
				@player.total_seconds += 2
				@player.add_minute
			end
		end
	end

	def check_time
		if @player.total_seconds >= 600
			@player.give_stuff(@player.achievements[:ten_minutes].unlock)
			add_command_to_history("unlock ten_minutes")
		end
	end

	def list_quests
		started_quests = @player.started_quests.values

		unless started_quests.empty?
			puts "Started Quests:".magenta
			started_quests.map do |quest|
				percent = quest.tasks_completed.to_f/quest.tasks.length.to_f*100
				puts "#{quest.name}: #{percent.round}%"
				puts "  Current Task: #{quest.current_task[1][:description]}" \
					unless quest.completed
				puts
			end
		end
	end

	def list_achievements
		@player.achievements.each do |_, a|
			puts a.name if a.unlocked?
		end
	end

	def help
		puts <<-EOT
Here are some basic commands to help you out: n, e, s, w, ne, nw, ...
You get the point.
You can also type stuff like "go north", "north", and "go n", "walk north"

Also, "achievements" views your unlocks achievements
and "quests" views the status on your started quests,
but there are more quest to start. But remember, have fun, and explore.
Of course, there are more commands, but you'll have to figure those out.
		EOT
	end

	def time
		# this message seems awkwardly worded
		puts @player.get_time.strftime("It's the year of %Y, %b %d, %I:%M %p")
	end

	def walk(direction)
		key = @player.walk(direction)
		if key.nil?
			puts "You can't go that way"
		elsif key
			room = @rooms[key]
			if room.locked?
				puts "That room is locked"
			else
				@player.room = room
				@player.give_stuff(@player.room.enter)
			end
		end
	end

	def pickup(item_name)
		if item_name.nil?
			puts "Please supply an object to pickup."
		elsif @player.get_item(item_name)
			puts "You already have this."
		else
			item = @player.pickup(item_name)
			equip(item_name) if item.is_a?(Weapon)
		end
	end

	def info
		@player.info
		if @enemy
			puts
			@enemy.info
		end
	end

	def eat(food)
		@player.eat(food)
	end

	def drop(item)
		@player.drop_item(item)
	end

	def read(title)
		if book = @player.get_item(title)
			if book.is_a?(Book)
				@player.give_stuff(book.read)
			else
				puts "You can't read that."
			end
		else
			puts "You can't read that."
		end
	end

	def fight(enemy, attack)
		# refactor this
		if enemy.nil?
			if @enemy
				attack_enemy(attack)
			else
				puts "You aren't fighting anyone."
			end
		else
			if victim = @player.room.get_person(enemy)
				if @enemy
					if victim.name.downcase != @enemy.name.downcase
						puts "You are already fighting someone else."
						return
					end
				end
				if victim.is_alive?
					@enemy = victim
					add_command_to_history("enemy #{enemy}")
					attack_enemy(attack)
				else
					puts "#{enemy} is dead."
				end
			else
				puts "#{enemy} isn't here."
			end
		end
	end

	# this needs refactoring
	def attack_enemy(attack)
		weapon = @player.weapon
		damage = if weapon
					rand(weapon.attacks[attack]) + weapon.upgrade
				else
					@player.smack
				end
		attack_phrases = [ "You just ultimately destroyed the #{@enemy.name} #{"-".red + damage.to_s.red}", "My goodness gracious, that was impressive #{"-".red + damage.to_s.red}", "#{@enemy.name} just ate dirt #{"-".red + damage.to_s.red}" ]
		puts attack_phrases.rand_choice
		stuff = @enemy.take_damage(damage)

		_damage = 0
		if @enemy.is_alive?
			_damage = @enemy.attack
			protection = @player.armour.values.reject(&:nil?).map(&:protects).inject(&:+)
			_damage -= protection if protection
			_damage = 0 if _damage < 0

			badguy_says = [ "The #{@enemy.name} attacked you! #{"-".red + _damage.to_s.red}", "#{@enemy.name} is on fire  #{"-".red + _damage.to_s.red}", "POW! That hurt.  #{"-".red + _damage.to_s.red}" ]
			puts badguy_says.rand_choice
			@player.take_damage(_damage)
		else
			@player.give_stuff(stuff)
			@enemy = nil
		end
		add_command_to_history("damage #{_damage} #{damage}")
	end

	def give(item, guy)
		unless item && guy
			puts "Give who what?"
			return
		end

		# Do I have this item?
		if the_item = @player.get_item(item)
			if person = @player.room.get_person(guy)
				if person.item_wanted == item
					stuff = person.do_action
					@player.give_stuff(stuff)
				else
					puts "Hmmm... it seems #{guy} doesn't know what to do with that..." # 👻
				end
			else
				puts "Ummmm... That person doesn't seem to be here."
			end
		else
			puts "Ummmm... You don't have that item..."
		end

	end

	def look
		@player.room.look
	end

	# move this to lib/player.rb
	def equip(item_name)
		if item = @player.get_item(item_name)
			if item.is_a?(Weapon)
				@player.weapon = item
				puts "#{item_name} has been equipped!".cyan
			elsif item.is_a?(Armour)
				armour = item_name
				@player.armour[item.type] = item
				puts "#{item_name} has been equipped!".cyan
			else
				puts "That's not a weapon, stupid.".red
			end
		else
			puts "you do not own that item...".red
		end
	end

	# move this to lib/player.rb
	def unequip(item_name)
		if item_name == "weapon"
			@player.weapon = nil
		elsif @player.weapon && item_name.downcase == @player.weapon.name.downcase
			@player.weapon = nil
		elsif @player.armour.keys.include?(item_name.to_sym)
			@player.armour[item_name.to_sym] = nil
		else
			puts "usage: unequip (weapon or piece of armour)"
		end
	end

	def unlock_path(path)
		room = @rooms[@player.room[path.to_sym]]
		if room.locked?
			if key = @player.get_items[:keys].select { |k| k.unlocks_room == @player.room[path.to_sym] }.first
				@player.remove_item(key)
				room.unlock
				puts "Unlocked!"
			else
				puts "You need a key that fits the lock."
			end
		else
			puts "Its not locked."
		end
	end

	def inspect(item)
		# this could be refactored
		if the_item = @player.get_item(item)
			the_item.info
		elsif the_item = @player.room.get_item(item)
			the_item.info
		elsif person = @player.room.get_person(item)
			person.info
		else
			puts "#{item} is not here or your inventory."
		end
	end

	def talk(guy)
		if dude = @player.room.get_person(guy)
			if dude.is_a?(Merchant)
				dude.store(@player.gold)
			else
				@player.give_stuff(dude.speak)
			end
		else
			puts "#{guy} isn't in this room."
		end
	end

	def buy(item)
		merchant = @player.room.living_people[:merchants].first
		if merchant
			@player.give_stuff(merchant.sell(item, @player.gold))
		else
			puts "There is no one to buy from here."
		end
	end

	def rub_sticks
		if @player.items[:sticks]
			# do something involving fire
			puts "I need to implement this."
		end
	end

	def mine
		if @player.room.is_a?(Mountain)
			if @player.items[:pickaxe]
				@player.give_stuff(@player.room.mine)
			else
				puts "You have nothing to mine with."
			end
		else
			puts "There's nothing here to mine."
		end
	end

	def climb(thing_name)
		thing_name = thing_name
		if 🌳 = @player.room.items[:tree]
			name = 🌳.name.downcase
			if [nil, "tree"].include?(thing_name)
				res = 🌳.climb
				@player.give_stuff(res)
			else
				puts "You can't climb that."
			end
		elsif @rooms[@player.room[:u]].is_a?(Mountain)
			if [nil, "mountain"].include?(thing_name)
				walk("u")
			end
		else
			puts "There's nothing here to climb."
		end
	end

	def load_game
		File.delete($options[:save_file]) if File.file?($options[:save_file]) && $options[:reset]
		room = :courtyard
		@player = Player.new
		@rooms = RoomList.rooms
		@player.room = @rooms[room]
		@player.quests[:main].start(false)
		@enemy = nil
		if File.file?($options[:save_file])
			old_stdout = $stdout
			$stdout = StringIO.new
			$options[:loading] = true
			File.foreach($options[:save_file]) do |line|
				parse(line)
			end
			check_time
			$options[:loading] = nil
			$stdout = old_stdout
			look
		else
			get_name
			@player.room.enter
		end
	end

	def get_name
		puts "Wut b ur namez?"
		@player.name = prompt
		add_command_to_history("name #{@player.name}")
	end

	def quit
		puts "Come back when you can't stay so long!"
		
		t = @player.time.values * " "
		add_command_to_history("time #{t}")
		add_command_to_history("total_seconds #{@player.total_seconds}")
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

class Array
	def rand_choice
		if RUBY_VERSION.to_f > 1.8
			self.sample
		else
			self[rand(self.length)]
		end
	end
end