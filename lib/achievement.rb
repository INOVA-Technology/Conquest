class Achievement

	attr_accessor :name, :unlocked

	def initialize(options = {})
		@name = options[:name]
		
		@unlocked = false
		@options = options
	end

	def unlock
		unless @unlocked
			@unlocked = true
			puts "#{'Achievement Unlocked!'.cyan} - #{@name}"
			$player.give_xp(15)
		end
	end

end
