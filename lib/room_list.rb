module RoomList

	# Please update map.txt after adding any rooms. Thank you.
	
	# Also, please order paths by: U, D, N, E, S, W, NE, SE, SW, NW, its clockwise
	# U = up, D = down

	# Add a \n if the description gets too long,
	# like if it gets spit up in a terminal width of 75

	# And keep it oganized in a way
	# Right now, the indention follows the map directions in a way


	############################################
	#                                          #
	#  And most of all, please list the exits  #
	#  in the descriptions for each room,      #
	#  and update any necessary rooms          #
	#  with exits you added.                   #
	#                                          #
	############################################

	# this shouldn't be in 1TBS, it's a weird variant of banner style
	ROOMS = {
		castle_main:
			Room.new("Main room", "This is the main room of the castle. It needs a better description\nand name. Theres a hallway south.", 
				paths: { s: :hallway}
				),
		hallway:
			Room.new("Hallway", "This castle has a long hallway. There is a door to the west and\na large room north.",
				paths: { n: :castle_main, s: :castle, w: :dinning_hall }
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
			Room.new("Castle courtyard", "You are at the castle courtyard. There's a nice fountain in the center.\nThe castle entrance is north. There is a forest south.",
				paths: { n: :castle, s: :forest },
				items: {
					# this peach is useless, it'll confuse people 
					# a peach: 🍑
					peach: Food.new("Peach", "A delicious peach")
					}),
		forest:
			Room.new("Large forest", "This forest is very dense. There is a nice courtyard north.\nThe forest continues west and south.",
				paths: { n: :courtyard, s: :forest_1, w: :forest__1 }
				),
	forest__1:
		Room.new("Large forest", "This forest is very nice. You can go north, east and west into\nsome more forest.", 
			paths: { n: :forest__2, e: :forest, w: :sticks }
			),
sticks:
	Room.new("Large forest", "This forest is getting boring, but hey, who knows what you'll find here!\nYou can go east.",
		paths: { e: :forest__1 },
		items: {
			sticks: Item.new("Sticks", "Just a couple of sticks. They like they are cedar wood.")
			}),
	forest__2:
		Room.new("Large forest",  "You are in a large forest. There looks like theres a grand building over\neast, but you can't quite get to it from here. You can go south.",
			paths: { s: :forest__1 }
			),
		forest_1:
			Room.new("Large forest", "There is a large, magnificent tree east. The forest continues\nnorth and south.",
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
			Room.new("Large forest", "Just some more forest. The forest continues north and south.",
				paths: { n: :forest_1, s: :forest_3 }
				),
		forest_3:
			Room.new("Large forest", "Dang, how many trees are in this forest? You can go north, south, and west.",
				paths: { n: :forest_2, s: :forest_4, w: :more_trees }
				),
	more_trees:
		Room.new("Large forest", "You can go east and west.",
			paths: { e: :forest_3, w: :more_trees_1 }
			),
more_trees_1:
	Room.new("Large forest", "You can go east and south.", 
		paths: { e: :more_trees, s: :more_trees_2 }
		),
more_trees_2:
	Room.new("Large forest", "You can go north and south.",
		paths: { n: :more_trees_1, s: :more_trees_3 }
		),
more_trees_3:
	Room.new("Large forest", "You can go north and east",
		paths: { n: :more_trees_2, e: :path_to_village }
		),
		path_to_village:
			Room.new("Large forest", "Its hard to see because of all these trees, but you think you see a small\nhut to the east. You can also go back west",
				paths: { e: :village, w: :more_trees_3 }
				),
			village:
				# add an item or 2 here
				Room.new("Abandoned village", "There are a bunch of huts here, some people must have lived here before.\nThere is some more forest down south. You can go back west into the forest.",
					paths: { w: :path_to_village, s: :forest_by_village },
					items: { 
						pickaxe: Item.new("Pickaxe", "Be careful, it looks sharp.")
						}),
			forest_by_village:
				Room.new("Large forest", "Geez more forest. The village is north, and there is a valley east",
					paths: { n: :village, e: :valley }
					),
				valley:
					Room.new("Valley", "It's a beautiful valley, with some gigantic mountains east, with some\nsnow of the tops. There is a forest to the west",
						paths: { e: :mountains, w: :forest_by_village }
						),
					mountains:
						Room.new("Mountains", "There are many tall mountains with snow on the tops. You can go back west.",
							paths: { u: :mountain, w: :valley },
							has_mountain: true
							),
						mountain:
							Room.new("Tall mountain", "This mountain is very steep. You can continue climbing or go back down",
								paths: { d: :mountains, u: :mountain_1 },

								# the scroll and Randy should be moved to mountain_3 once it exists
								items: {
									scroll: Item.new("Scroll", "Its some kind of elvish... You can't read it."),
									peach: Food.new("Peach", "A delicious peach") 
									},
								people: {
									# Randy will read elvish in the future
									randy: Person.new("Randy", "He's just an elf",
										race: "Elf",
										talk: "I can read elvish. Go figure.",
										item_wanted: "scroll",
										action: "Randy reads the scroll and gives you the gist of it: \n#{'It says to find the eagles to take you to Mordor so you may save the world. '.cyan}\n#{'Go to the forrest of mirkwood.  The elves there are my kin.  They will'.cyan} \n#{'know where to start.'.cyan}"
										)}),
						mountain_1:
							Room.new("Tall mountain", "Climbing this mountain is very tiring. You can continue climbing\nor go back down",
								paths: { d: :mountain }
								),
		forest_4:
			Room.new("Large forest", "There is a lot of trees here. It's very shady in this area.\nThe forest continues north.", 
				paths: { n: :forest_3 }
				)
	}

	def self.room_list
		ROOMS
	end

end