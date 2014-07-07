module QuestList

	QUESTS = {
		# main: 
		mordor: Quest.new("Onward to Mordor")
	}

	def self.quests
		QUESTS
	end

end