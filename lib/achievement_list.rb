module AchievementList

	ACHIEVEMENTS = {
		peach:   Achievement.new("Have a Peach!", unlocked: false)
	}

	def self.achievements
		ACHIEVEMENTS
	end

end