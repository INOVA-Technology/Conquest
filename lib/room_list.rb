module RoomList

	ROOMS = {
		castle_courtyard:
			Room.new("Castle Courtyard", "You are at the castle courtyard",
				paths: { n: :castle },
				items: {
					# this peach is useless, it'll confuse people 
					# a peach: 🍑
					peach: Food.new("Peach", "A delicious peach")
					}),
		castle:
			Room.new("Castle", "You are at the castle",
				paths: { s: :castle_courtyard }
				)

	}

	def self.room_list
		ROOMS
	end

end