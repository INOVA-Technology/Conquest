module RoomList

	# Please update map.txt after adding any rooms. Thank you.
	
	# Also, please order paths by: N, E, S, W, NE, SE, SW, NW, its clockwise
	
	# Add a \n if the description gets too long,
	# like if it gets spit up in a terminal width of 75

	# And keep it oganized in a way


	############################################
	#                                          #
	#  And most of all, please list the exits  #
	#  in the descriptions for each room,      #
	#  and update any necessary rooms          #
	#  with exits you added.                   #
	#                                          #
	############################################

	ROOMS = {

		hallway:
			Room.new("Hallway", "This castle has a long hallway. There is a door to the west.",
				paths: { s: :castle, w: :dinning_hall }
				),
			dinning_hall:
				Room.new("Dinning hall", "The dinning hall. There is a door to the east.",
					paths: { e: :hallway }
					),
		castle:
			Room.new("Castle", "You are in the castle. There's a long hallway to the north, and\nthe courtyard is to the south.",
				paths: { n: :hallway, s: :courtyard }
				),
		courtyard:
			Room.new("Castle courtyard", "You are at the castle courtyard. There's a nice fountian in the center.\nThe castle entrance is north. There is a forest south.",
				paths: { n: :castle, s: :forest },
				items: {
					# this peach is useless, it'll confuse people 
					# a peach: 🍑
					peach: Food.new("Peach", "A delicious peach")
					}),
		forest:
			Room.new("Large forest", "This forest is very dense. There is a nice courtyard north.\nThe forest continues south.",
				paths: { n: :courtyard, s: :forest_1 }
				),
		forest_1:
			Room.new("Large forest", "There is a large, magnificent tree east. The forest continues\nnorth and south",
				paths: { n: :forest, e: :banyan_tree, s: :forest_2 }
				),
			banyan_tree:
				# http://en.wikipedia.org/wiki/Banyan
				Room.new("Large banyan tree", "There is a large banyan tree, with many twists and roots going up the tree.\nYou can go west.",
					paths: { w: :forest_1 },
					items: {
						tree: Tree.new("Banyan", "You climb up the top of the tree, and see lots of trees and a\ncastle somewhere around north. It looks like there is a small\nvillage some where south east. You climb back down.", { # 👻
							can_climb: true
						})}),
		forest_2:
			Room.new("Large forest", "Just some more forest. The forest continues north and south",
				paths: { n: :forest_1, s: :forest_3 }
				),
		forest_3:
			Room.new("Large forest", "Dang, how many trees are in this forest? You can go north and south",
				paths: { n: :forest_2, s: :forest_4 }
				),
		forest_4:
			Room.new("Large forest", "There is a lot of trees here. It's very shade in this area.\nThe forest continues north and east.", 
				paths: { n: :forest_3, e: :path_to_village }
				),
			path_to_village:
				Room.new("Large forest", "Its hard to see because of all these trees, but you think you see a small\nhut to the east. You can also go back west",
					paths: { e: :village, w: :forest_4 }
					),
				village:
					# add an item or 2 here
					Room.new("Abandon village", "There are a bunch of huts here, some people must have lived here before.\nYou can go back west into the forest.",
						paths: { w: :path_to_village }
						),
	}

	def self.room_list
		ROOMS
	end

end