module AchievementList

	ACHIEVEMENTS = {
		peach:   Achievement.new(name: "Have a Peach!"),
		mordor: Achievement.new(name: "From Mordor with Love"),
		hex: Achievement.new(name: "Confused"),
		ten_minutes: Achievement.new(name: "Play for 10 minutes!"),
		over_9000: Achievement.new(name: "It's over 9000"),
		lucky: Achievement.new(name: "Lucky"),
		banker: Achievement.new(name: "Banker"),
		rickrolld: Achievement.new(name: "Rick Roll'd"),
		commitment: Achievement.new(name: "Commitment")
	}

	def self.achievements
		ACHIEVEMENTS
	end
end