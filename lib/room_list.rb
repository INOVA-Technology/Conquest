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

# helps with the merge conflictia area
def str_to_hex(str)
	str.chars.map { |c| c.ord.to_s(16) } * " "
end

def hex_to_str(hex)
	hex.split(" ").each {|n| print n.to_i(16).chr }; puts
end

# this shouldn't be in 1TBS, it's a weird variant of banner style
$rooms = {
	castle_main:
		Room.new(name: "Main room", desc: "This is the main room of the castle. It needs a better description\nand name. Theres a hallway south.", 
			paths: { s: :hallway}
			),
	hallway:
		Room.new(name: "Hallway", desc: "This castle has a long hallway. There is a door to the west and\na large room north.",
			paths: { n: :castle_main, s: :castle, w: :dinning_hall }
			),
		dinning_hall:
			Room.new(name: "Dinning hall", desc: "The dinning hall. There is a door to the east.",
				paths: { e: :hallway }
				),
	castle:
		Room.new(name: "Castle", desc: "You are in the castle. There's a long hallway to the north, and\nthe courtyard is to the south.",
			paths: { n: :hallway, s: :courtyard }
			),
	courtyard:
		Room.new(name: "Castle courtyard", desc: "You are at the castle courtyard. There's a nice fountain in the center.\nThe castle entrance is north. There is a forest south.",
			paths: { n: :castle, s: :forest },
			items: {
				# this peach is useless, it'll confuse people 
				# a peach: 🍑
				peach: Food.new(name: "Peach", desc: "A delicious peach")
				}),
	forest:
		Room.new(name: "Large forest", desc: "This forest is very dense. There is a nice courtyard north.\nThe forest continues west and south.",
			paths: { n: :courtyard, s: :forest_1, w: :forest__1 }
			),
forest__1:
	Room.new(name: "Large forest", desc: "This forest is very nice. You can go north, east and west into\nsome more forest.", 
		paths: { n: :forest__2, e: :forest, w: :sticks }
		),
sticks:
Room.new(name: "Large forest", desc: "This forest is getting boring, but hey, who knows what you'll find here!\nYou can go east.",
	paths: { e: :forest__1 },
	items: {
		sticks: Item.new(name: "Sticks", desc: "Just a couple of sticks. They like they are cedar wood.")
		}),
forest__2:
	Room.new(name: "Large forest", desc: "You are in a large forest. There looks like theres a grand building over\neast, but you can't quite get to it from here. You can go south.",
		paths: { s: :forest__1 }
		),
	forest_1:
		Room.new(name: "Large forest", desc: "There is a large, magnificent tree east. The forest continues\nnorth and south.",
			paths: { n: :forest, e: :banyan_tree, s: :forest_2 }
			),
		banyan_tree:
			# http://en.wikipedia.org/wiki/Banyan
			Room.new(name: "Large banyan tree", desc: "There is a large banyan tree, with many twists and roots going up the tree.\nYou can go west.",
				paths: { w: :forest_1 },
				items: {
					tree: Tree.new(name: "Banyan", desc: "You climb up the top of the tree, and see lots of trees and a\ncastle somewhere around north. It looks like there is a small\nvillage some where south east. You climb back down.", # 👻
						can_climb: true,
						task: { quest: :main, task: :climb_tree}
						)}),
	forest_2:
		Room.new(name: "Large forest", desc: "Just some more forest. The forest continues north and south.",
			paths: { n: :forest_1, s: :forest_3 }
			),
	forest_3:
		Room.new(name: "Large forest", desc: "Dang, how many trees are in this forest? You can go north, south, and west.",
			paths: { n: :forest_2, s: :forest_4, w: :more_trees }
			),
more_trees:
	Room.new(name: "Large forest", desc: "You can go east and west.",
		paths: { e: :forest_3, w: :more_trees_1 }
		),
more_trees_1:
Room.new(name: "Large forest", desc: "You can go east and south.", 
	paths: { e: :more_trees, s: :more_trees_2 }
	),
more_trees_2:
Room.new(name: "Large forest", desc: "You can go north and south.",
	paths: { n: :more_trees_1, s: :more_trees_3 }
	),
more_trees_3:
Room.new(name: "Large forest", desc: "You can go north and east",
	paths: { n: :more_trees_2, e: :path_to_village }
	),
	path_to_village:
		Room.new(name: "Large forest", desc: "Its hard to see because of all these trees, but you think you see a small\nhut to the east. You can also go back west",
			paths: { e: :village, w: :more_trees_3 }
			),
		village:
			# add an item or 2 here
			Room.new(name: "Abandoned village", desc: "There are a bunch of huts here, some people must have lived here before.\nThere is some more forest down south. You can go back west into the forest.",
				paths: { w: :path_to_village, s: :forest_by_village },
				items: { 
					pickaxe: Item.new(name: "Pickaxe", desc: "Be careful, it looks sharp.")
					},
				people: {
					gus: Person.new(name: "gus", desc: "He's a poor villager about the age of 56",
						race: "Human",
						talk: "People tell me I look like Morgan Freeman."
						#item_wanted: "",
						#action: ""
						)}),
		forest_by_village:
			Room.new(name: "Large forest", desc: "Geez more forest. The village is north, and there is a valley east",
				paths: { n: :village, e: :valley }
				),
			valley:
				Room.new(name: "Valley", desc: "It's a beautiful valley, with some gigantic mountains east, with some\nsnow of the tops. There is a forest to the west",
					paths: { e: :mountains, w: :forest_by_village },
					people: {
						orc: Enemy.new(name: "Orc", desc: "Hmmm... You are no genius, but you think he wants to kill you.",
							race: "Orc",
							talk: "Give me your milk money.",
							damage: rand(1..3),
							health: 10,
							xp: 3
					)}),
				mountains:
					Room.new(name: "Mountains", desc: "There are many tall mountains with snow on the tops. You can go back west. You hear something in the distance.",
						paths: { u: :mountain, w: :valley },
						has_mountain: true
						),
					mountain:
						Room.new(name: "Tall mountain", desc: "This mountain is very steep. You can continue climbing or go back down. The sound has gotten louder.",
							paths: { d: :mountains, u: :mountain_1 },

							# the scroll and Randy should be moved to mountain_3 once it exists
							items: {
								scroll: Item.new(name: "Scroll", desc: "Its some kind of elvish... You can't read it.")},
							people: {
								randy: Person.new(name: "Randy", desc: "He's just an elf",
									race: "Elf",
									talk: "I can read elvish. Go figure.",
									item_wanted: "scroll",
									action: "Randy reads the scroll and gives you the gist of it: \n#{'It says to find the eagles to take you to Mordor so you may save the world.'.cyan}\n#{'Go to the forest of mirkwood.  The elves there are my kin.  They will'.cyan} \n#{'know where to start.'.cyan}"
									)}),
					mountain_1:
						Room.new(name: "Tall mountain", desc: "Climbing this mountain is very tiring. You can continue climbing\nor go back down. Holy Toledo, that sound is very loud... It sounds like... Music...",
							paths: { d: :mountain },
							people: {
								rick: Person.new(name: "Rick", desc: "Oh... Oh no... Its Rick Astley",
									hidden: true,
									race: "Gosh, who knows.",
									talk: "\nWe're no strangers to love\n\nYou know the rules and so do I\n\nA full commitment'?s what I'?m thinking of\n\nYou wouldn'?t get this from any other guy\n\nI just wanna tell you how I'?m feeling\n\nGotta make you understand\n\nNever gonna give you up\n\nNever gonna let you down\n\nNever gonna run around and desert you\n\nNever gonna make you cry\n\nNever gonna say goodbye\n\nNever gonna tell a lie and hurt you\n\nWe'?ve known each other for so long\n\nYour heart'?s been aching, but\n\nYou'?re too shy to say it\n\nInside,? we both know what'?s been going on\n\nWe know the game and we'?re gonna play it\n\nAnd if you ask me how I'?m feeling\nDon'?t tell me you'?re too blind to see\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n\nOoh, give you up\nOoh, give you up\nNever gonna give,? never gonna give\nGive you up\nNever gonna give,? never gonna give\nGive you up\n\nWe'?ve known each other for so long\nYour heart'?s been aching, but\nYou'?re too shy to say it\nInside,? we both know what'?s been going on\nWe know the game and we'?re gonna play it\n\nI just wanna tell you how I'?m feeling\nGotta make you understand\n\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n"
									)}
							),
	forest_4:
		Room.new(name: "Large forest", desc: "There is a lot of trees here. It's very shady in this area.\nThe forest continues north.", 
			paths: { n: :forest_3 }
			),



	# hidden passages below:

	abyss1:
		Room.new(name: str_to_hex("Abyss"), desc: str_to_hex("You can go south and east"),
			paths: { s: :merge_conflictia },
			items: {
				iphone: Item.new(name: str_to_hex("iphone"), desc: str_to_hex("The perfect smart phone"))
			}
		),
	# eventually there will be a hex translator.
	merge_conflictia:
		Room.new(name: "Merge Conflictia", desc: "Welcome to Merge Conflictia, the never ending abyss of raw anger.\nBeyond this point, all descriptions will be in hexadecimal.\nThere is a road to the north.",
			paths: { n: :abyss1 },
			items: {
				staff: Item.new(name: "Staff", desc: "This appears to be the legendary staff of confusion.  It can be used as a \ndeadly weapon in combat.")
			},
			people: {
				hex: Person.new(name: "Hex", desc: "He doesn't look to good... Something appears to be wrong with his mental\nfunctions",
					race: "Hex-Man",
					talk: str_to_hex("You should escape... now"),
					item_wanted: "iphone",
					action: "Finally!  Now I can talk. I love this translator app.  Unfortunately, I am the only\none in Merge Conflictia that still has the brains to use it.  You must save us \nfrom the... #{str_to_hex('Great Merge Conflict')}"
				)
			},
			starts_quest: :hex,
			unlocks: :hex
		)
}.each do |_, r|
	[:items, :people].map do |sym|
		r[sym].map { |i| i.setup } if r[sym]
	end
	r.setup
end



	

