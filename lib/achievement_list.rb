$achievements = {
	peach:   Achievement.new(name: "Have a Peach!", unlocked: false),
	mordor: Achievement.new(name: "From Mordor with Love", unlocked: false),
	hex: Achievement.new(name: "Confused", unlocked: false),
	five_minutes: Achievement.new(name: "Player for 5 minutes!", unlocked: false)
}.each { |_, a| a.setup }
