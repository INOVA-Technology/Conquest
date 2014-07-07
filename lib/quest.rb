class Quest

	attr_accessor :steps
	attr_reader :name, :started

	def initialize(name, steps, options = {})
		@name = name
		
		# steps (the argument) should be a hash like this:
		# [:found_ring, :melted_ring]
		@steps = steps.inject({}) { |hash, step| hash[step] = false; hash }
		# then @step will be this:
		# { found_ring: false, melted_ring: false }
		
		@started = options[:started]
		@options = options
	end

	def start
		@started = true
		puts "#{'Quest started!'.cyan} - #{@name}"
	end

end
