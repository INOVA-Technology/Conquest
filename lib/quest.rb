class Quest

	def initialize(name, options = {})
		@name = name
		@started = false
		@options = options
	end

	def start
		@started = true
		puts "#{'Quest started!'.cyan} - #{name}"
	end

end
