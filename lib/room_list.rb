module RoomList

	# Please update map.txt after adding any rooms. Thank you.
	# Also, please order paths by: N, E, S, W, NE, SE, SW, NW, its clockwise

	ROOMS = {

		courtyard:
			Room.new("Castle Courtyard", "You are at the castle courtyard",
				paths: { n: :castle, s: :forest },
				items: {
					# this peach is useless, it'll confuse people 
					# a peach: 🍑
					peach: Food.new("Peach", "A delicious peach")
					}),
		castle:
			Room.new("Castle", "You are at the castle",
				paths: { n: :hallway, s: :courtyard }
				),
		hallway:
			Room.new("Hallway", "This castle has a long hallway",
				paths: { s: :castle, w: :dinning_hall }
				),
		dinning_hall:
			Room.new("Dinning hall", "The dinning hall",
				paths: { e: :hallway }
				),
		forest:
			Room.new("Forest", "This forest is very dense. There is a nice courtyard north",
				paths: { n: :courtyard }
				) 
	}

	def self.room_list
		ROOMS
	end

end