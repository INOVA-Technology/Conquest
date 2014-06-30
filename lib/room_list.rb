module RoomList

	ROOMS = {
		courtyard:
			Room.new("Castle Courtyard", "You are at the castle courtyard",
				paths: { n: :castle },
				items: {
					# this peach is useless, it'll confuse people 
					# a peach: 🍑
					peach: Food.new("Peach", "A delicious peach")
					}),
		castle:
			Room.new("Castle", "You are at the castle",
				paths: { s: :courtyard, n: :hallway }
				),
		hallway:
			Room.new("Hallway", "This castle has a long hallway",
				paths: { s: :castle }
				)
	}

	def self.room_list
		ROOMS
	end

end