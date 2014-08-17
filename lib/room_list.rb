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

# this needs to be somewhere:
# Key.new(name: "Key", desc: "bla", unlocks_room: :armory)

# this shouldn't be in 1TBS, it's a weird variant of banner style
module RoomList

	ITEMS = ObjectManager.new([
		Weapon.new(name: "Sword", prefix: "a", desc: "It looks very sharp.",
				attacks: { attack: 7..11, slash: 9..14 },
				regex_attacks: "attack|slash"),
		Armour.new(name: "Shield", prefix: "a", desc: "blablabla", protects: 5, type: :shield),
		Food.new(name: "Apple", prefix: "an", desc: "A juicy macintosh apple.", on_eat: { health: 7 }),
		Item.new(name: "Sticks", desc: "Just a couple of sticks. They like they are cedar wood."),
		Tree.new(name: "Banyan", prefix: "a", desc: "What a nice, climable tree.", # 👻
			message: "You climb up the top of the tree, and see lots of trees and a\ncastle somewhere around north. It looks like there is a small\nvillage some where south east. You climb back down.",
			on_climb: { task: { quest: :main, task: :climb_tree }},
			alt_names: ["banyan tree", "tree"]),
		Food.new(name: "Peach", prefix: "a", desc: "A delicious peach",
			on_eat: { health: 5},
			on_pickup: { achievement: :peach }),
		Weapon.new(name: "Pickaxe", prefix: "a", desc: "Be careful, it looks sharp.",
			attacks: { chop: 5..8, attack: 5..5 },
			regex_attacks: "chop|attack",
			alt_names: ["axe"]),
		Book.new(name: "Scroll", prefix: "a", desc: "Its some kind of elvish... You can't read it.",
			title: "Parma od Osto",
			print: "hirsornë an tululyë an Mordor san polendraith kemen",
			on_pickup: { quest: :mordor, achievement: :mordor }),
		Item.new(name: str_to_hex("iphone"), prefix: str_to_hex("an"), desc: str_to_hex("The perfect smart phone"),
			alt_names: ["iphone", "phone"]),
		Weapon.new(name: "Staff", prefix: "a", desc: "This appears to be the legendary staff of confusion.  It can be used as a \ndeadly weapon in combat.",
			attacks: { attack: 22..26, jab: 20..40, demolish: 10..50 },
			regex_attacks: "attack|jab|demolish"),
		Food.new(name: "Peach", prefix: "a", desc: "A delicious peach", on_eat: { health: 5} , cost: 5),
		Food.new(name: "Ice", desc: "Just some ice", on_eat: { health: 1} , cost: 2)
	])



	PEOPLE = ObjectManager.new([
		Person.new(name: "Gus", desc: "He's a poor villager about the age of 56",
			race: "Human",
			talk: "People tell me I look like Morgan Freeman."),
		Merchant.new(name: "Merchant", desc: "He sells food and equipment.",
			race: "Human",
			talk: "Let's see what we've got in the trailer for you...",
			stock: [ITEMS["peach 2"], ITEMS["ice"]]),
		Person.new(name: "Randy", desc: "He's just an elf",
			race: "Elf",
			talk: "I can read elvish. Go figure.",
			item_wanted: "scroll",
			action: "Randy reads the scroll and gives you the gist of it: \nIt says to find the eagles to take you to Mordor so you may save the world.\nGo to the forest of mirkwood. The elves there are my kin. They will\nknow where to start.",
			health: 200,
			damage: 25..25,
			on_death: {xp: 40},
			on_action: { task: { quest: :mordor, task: :read_scroll } }),
		Person.new(name: "Rick", desc: "Oh... Oh no... Its Rick Astley",
			hidden: true,
			race: "Gosh, who knows.",
			talk: "\nWe're no strangers to love\n\nYou know the rules and so do I\n\nA full commitment's what I'm thinking of\n\nYou wouldn't get this from any other guy\n\nI just wanna tell you how I'm feeling\n\nGotta make you understand\n\nNever gonna give you up\n\nNever gonna let you down\n\nNever gonna run around and desert you\n\nNever gonna make you cry\n\nNever gonna say goodbye\n\nNever gonna tell a lie and hurt you\n\nWe've known each other for so long\n\nYour heart's been aching, but\n\nYou're too shy to say it\n\nInside, we both know what's been going on\n\nWe know the game and we're gonna play it\n\nAnd if you ask me how I'm feeling\nDon't tell me you're too blind to see\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n\nOoh, give you up\nOoh, give you up\nNever gonna give, never gonna give\nGive you up\nNever gonna give, never gonna give\nGive you up\n\nWe've known each other for so long\nYour heart's been aching, but\nYou're too shy to say it\nInside, we both know what's been going on\nWe know the game and we're gonna play it\n\nI just wanna tell you how I'm feeling\nGotta make you understand\n\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n\nNever gonna give you up\nNever gonna let you down\nNever gonna run around and desert you\nNever gonna make you cry\nNever gonna say goodbye\nNever gonna tell a lie and hurt you\n",
			on_talk: {achievement: :rickrolld},
			alt_names: ["rick astley", "astley"]),
		Person.new(name: "Hex", desc: "He doesn't look to good... Something appears to be wrong with his mental\nfunctions",
			race: "Hex-Man",
			talk: str_to_hex("You should escape... now"),
			item_wanted: "iphone",
			action: "Finally!  Now I can talk. I love this translator app.  Unfortunately, I am the only\none in Merge Conflictia that still has the brains to use it.  You must save us \nfrom the... #{str_to_hex('Great Merge Conflict')}",
			damage: 40..70,
			health: 200,
			on_death: { xp: 400 },
			on_action: { task: { quest: :hex, task: :iphone } }),
		Enemy.new(name: "Orc", desc: "Hmmm... You are no genius, but you think he wants to kill you.",
			race: "Orc",
			talk: "Give me your milk money.",
			damage: 3..7,
			health: 10,
			on_death: { xp: 10, gold: 10 })
		])

	ROOMS = {
							chamber:
								Room.new(name: "Chamber", desc: "You are underground, below the castle. It's very dark. There is a long\nhallway south, and the castle is back up stairs.",
									paths: {u: :castle_main}
									),
							armory:
								Room.new(name: "Armory", desc: "They are lots of weapons here.",
									paths: { s: :castle_main },
									locked: true,
									items: [ITEMS["sword 1"], ITEMS["shield 1"]]),
							castle_main:
								Room.new(name: "Main room", desc: "This is the main room of the castle. It needs a better description\nand name. Theres a hallway south, and a small hole going down.", 
									paths: { n: :armory, s: :hallway, d: :chamber}
									),
							hallway:
								Room.new(name: "Hallway", desc: "This castle has a long hallway. There is a door to the west and\na large room north.",
									paths: { n: :castle_main, s: :castle, w: :dinning_hall }
									),
								dinning_hall:
									Room.new(name: "Dinning hall", desc: "The dinning hall. There is a door to the east.",
										paths: { e: :hallway },
										items: [ITEMS["apple 1"]]),
							castle:
								Room.new(name: "Castle", desc: "You are in the castle. There's a long hallway to the north, and\nthe courtyard is to the south.",
									paths: { n: :hallway, s: :courtyard }
									),
							courtyard:
								Room.new(name: "Castle courtyard", desc: "You are at the castle courtyard. There's a nice fountain in the center.\nThe castle entrance is north. There is a forest south.",
									paths: { n: :castle, s: :forest
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
							items: [ITEMS["sticks"]]),
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
										items: [ITEMS["banyan"]]),
							forest_2:
								Room.new(name: "Large forest", desc: "Just some more forest. The forest continues north, east, and south.",
									paths: { n: :forest_1, e: :forest_again, s: :forest_3 }
									),
								forest_again:
									Room.new(name: "Large forest", desc: "TODO: change this description. btw, west.",
										paths: { w: :forest_2 }
										),
							forest_3:
								Room.new(name: "Large forest", desc: "Dang, how many trees are in this forest? You can go north, south, and west.",
									paths: { n: :forest_2, s: :forest_4, w: :more_trees }
									),
						more_trees:
							Room.new(name: "Large forest", desc: "You can go east and west.",
								paths: { e: :forest_3, w: :more_trees_1 },
								items: [ITEMS["peach 1"]]),
					a_path:
						Room.new(name: "Small path", desc: "You are on a small path. It looks like you can see a light over west. You can go west and south.",
							paths: { s: :more_trees_1}),

					more_trees_1:
						Room.new(name: "Large forest", desc: "You can go north, east, and south.", 
							paths: { n: :a_path, e: :more_trees, s: :more_trees_2 }
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
										items: [ITEMS["pickaxe 1"]],
										people: [PEOPLE["gus"], PEOPLE["merchant"]],
										task: { quest: :main, task: :go_to_village}),
								forest_by_village:
									Room.new(name: "Large forest", desc: "Geez more forest. The village is north, and there is a valley east",
										paths: { n: :village, e: :valley }
										),
									valley:
										Room.new(name: "Valley", desc: "It's a beautiful valley, with some gigantic mountains east, with some\nsnow on the tops. There is a forest to the west",
											paths: { e: :mountains, w: :forest_by_village },
											people: [PEOPLE["orc"]]),
										mountains:
											Room.new(name: "Mountains", desc: "There are many tall mountains with snow on the tops. It looks like some one\nis up there. You can go back west, and east to the lake.\nYou hear something in the distance.",
												paths: { u: :mountain, e: :lake, w: :valley},
												has_mountain: true
												),
											lake: 
												BodyOfWater.new(name: "Lake", desc: "A large lake. There are some mountains west, and\na beautiful waterfall northeast.",
												paths: { ne: :cove, w: :mountains }
												),
												cove: 
													Room.new(name: "Cove behind waterfall", desc: "The lake is southwest.",
													paths: { sw: :lake }
													),
											mountain:
												Mountain.new(name: "Tall mountain", desc: "This mountain is very steep. You can continue climbing or go back down.\nThe sound has gotten louder.",
													paths: { d: :mountains, u: :mountain_1 },

													# the scroll and Randy should be moved to mountain_3 once it exists
													items: [ITEMS["scroll"]],
													people: [PEOPLE["randy"]]),
											mountain_1:
												Mountain.new(name: "Tall mountain", desc: "Climbing this mountain is very tiring. You can continue climbing\nor go back down. Holy Toledo, that sound is very loud... It sounds like... Music...",
													paths: { d: :mountain },
													people: [PEOPLE["rick"]]
													),
							forest_4:
								Room.new(name: "Large forest", desc: "There is a lot of trees here. It's very shady in this area.\nThe forest continues north.", 
									paths: { n: :forest_3 }
									),



							# hidden passages below:

							abyss1:
								Room.new(name: str_to_hex("Abyss"), desc: str_to_hex("You can go south and east"),
									paths: { s: :merge_conflictia, e: :abyss2 },
									items: [ITEMS["iphone"]]
								),
								abyss2:
									Room.new(name: str_to_hex("Abyss"), desc: str_to_hex("You continue into the never ending abyss. You can go west."),
										paths: { w: :abyss1 }),
							# eventually there will be a hex translator.
							merge_conflictia:
								Room.new(name: "Merge Conflictia", desc: "Welcome to Merge Conflictia, the never ending abyss of raw anger.\nBeyond this point, all descriptions will be in hexadecimal.\nThere is a road to the north.",
									paths: { n: :abyss1 },
									items: [ITEMS["staff"]],
									people: [PEOPLE["hex"]],
									starts_quest: :hex,
									unlocks: :hex
									)
}

	def self.rooms
		ROOMS
	end

end



	

