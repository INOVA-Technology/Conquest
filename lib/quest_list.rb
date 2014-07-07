module QuestList

	QUESTS = {
		# this need a better name ⬇️ 
		main:   Quest.new("The main mission", []),
		mordor: Quest.new("Onward to Mordor", [])
	}

	def self.quests
		QUESTS
	end

end