class Achievement

	attr_accessor :name, :unlocked

	def initialize(name, options = {})
		@name = name
		
		@unlocked = options[:unlocked]
		@options = options
	end

	def unlock
		unless @unlocked
			@unlocked = true
			puts "#{'Achievement Unlocked!'.cyan} - #{@name}"
		end
	end

end
