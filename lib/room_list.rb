module RoomList

	# Please update map.txt after adding any rooms. Thank you.
	# Also, please order paths by: N, E, S, W, NE, SE, SW, NW, its clockwise

	############################################
	#                                          #
	#  And most of all, please list the exits  #
	#  in the descriptions for each room,      #
	#  and update any necessary rooms          #
	#  with exits you added.                   #
	#                                          #
	############################################

	ROOMS = {

		courtyard:
			Room.new("Castle courtyard", "You are at the castle courtyard",
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
				paths: { n: :courtyard, s: :more_forest }
				),
		more_forest:
			Room.new("More forest", "This forest looks very large. There is a large, magnificent tree east.",
				paths: { n: :forest, e: :banyan_tree }
				),
		banyan_tree:
			# http://en.wikipedia.org/wiki/Banyan
			Room.new("Large banyan tree", "There is a large banyan tree, with many twists and roots going up the tree. You can go west.",
				paths: { w: :more_forest }
				)
	}

	def self.room_list
		ROOMS
	end

end