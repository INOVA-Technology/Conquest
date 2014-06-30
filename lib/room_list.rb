module RoomList

	ROOMS = {
		castle_entrance:
			Room.new("Castle Entrance", "You are at the castle entrance",
				paths: { n: :castle },
				items: {
					peach: Food.new("Peach", "A delicious peach")
					}),
		castle:
			Room.new("Castle", "You are at the castle",
				paths: { s: :castle_entrance }
				)
	}

	def self.room_list
		ROOMS
	end

end