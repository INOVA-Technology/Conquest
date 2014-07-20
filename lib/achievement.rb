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
		end
	end

end
