class Quest

	attr_accessor :name, :started, :tasks

	def initialize(name, tasks, options = {})
		@name = name
		
		# tasks (the argument) should be a hash like this:
		# [[:find_ring, "My Precious"], [:melt_ring, "Idk"]]
		@tasks = tasks.inject({}) { |hash, task| hash[task[0]] = { description: task[1], completed: false}; hash }
		# then @task will be this:
		# { 
		# find_ring: {description: "My Precious", completed: false},
		# melt_ring: {description: "Idk", completed: false}
		# }
		@started = options[:started]
		@options = options
	end

	def start
		@started = true
		puts "#{'Quest started!'.cyan} - #{@name}"
	end

	def complete(task)
		the_task = tasks[task]
		the_task[:completed] = true
		puts "Task '#{the_task[:name]}' completed!".cyan
	end

	def [](task)
		@tasks[task]
	end

end
