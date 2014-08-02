class Achievement

	attr_accessor :name, :unlocked

	def initialize(options = {})
		@name = options[:name]
		
		@unlocked = false
		@options = options
	end

	def unlock
		xp = 0
		unless @unlocked
			@unlocked = true
			puts "#{'Achievement Unlocked!'.cyan} - #{@name}"
			xp = 15
		end
		{xp: xp}
	end

end
