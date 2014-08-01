class Quest

	attr_accessor :name, :started, :tasks, :tasks_completed

	def initialize(options = {})
		@name = options[:name]
		@tasks_completed = 0
		# tasks (the argument) should be a hash like this:
		# [[:find_ring, "My Precious"], [:melt_ring, "Idk"]]
		@tasks = options[:tasks].inject({}) do |hash, task|
			hash[task[0]] = { description: task[1], completed: false}; hash
		end
		# then @tasks will be this:
		# { 
		# find_ring: {description: "My Precious", completed: false},
		# melt_ring: {description: "Idk", completed: false}
		# }
		@started = false
		@options = options
	end

	def start(message = true)
		unless @started
			puts "#{'Quest started!'.cyan} - #{@name}" if message
			@started = true
		end
	end

	def complete(task)
		the_task = tasks[task]
		unless the_task[:completed]
			the_task[:completed] = true
			puts "Task '#{the_task[:description]}' completed!".cyan
			@tasks_completed += 1
			$player.give_xp(15)
		end
	end

	def current_task
		@tasks.detect { |_, task| !task[:completed] }[1] || {}
	end

	def [](task)
		@tasks[task]
	end

	def completed
		@tasks.all? { |_, task| task[:completed] }
	end

end
