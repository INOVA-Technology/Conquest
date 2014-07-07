module QuestList

	QUESTS = {
		# this need a better name ⬇️ 
		main:   Quest.new("Questalicious", []),
		mordor: Quest.new("Onward to Mordor", [])
	}

	def self.quests
		QUESTS
	end

end