module QuestList

	QUESTS = {
		main:   Quest.new("Questalicious", [], started: true),
		mordor: Quest.new("Onward to Mordor", [], started: false)
	}

	def self.quests
		QUESTS
	end

end