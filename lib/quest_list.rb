module QuestList

	QUESTS = {
		main:   Quest.new("Questalicious", [[:climb_tree, "Banyan"]], started: true),
		mordor: Quest.new("Onward to Mordor", [], started: false)
	}

	def self.quests
		QUESTS
	end

end