class Achievement < ConquestClass

	attr_accessor :name, :unlocked

	def setup(options = {})
		@name ||= options[:name]
		
		@unlocked ||= options[:unlocked]
		@options ||= options
	end

	def unlock
		unless @unlocked
			@unlocked = true
			puts "#{'Achievement Unlocked!'.cyan} - #{@name}"
		end
	end

end
