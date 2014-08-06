class Quest

	attr_accessor :name, :started, :tasks, :tasks_completed

	def initialize(options = {})
		@name = options[:name]
		@tasks_completed = 0
		# tasks (the argument) should be a hash like this:
		# [[:find_ring, "My Precious"], [:melt_ring, "Idk"]]
		@tasks = options[:tasks].inject({}) do |hash, task|
			hash[task[0]] = { description: task[1], completed: false, will_complete: false}; hash
		end
		# then @tasks will be this:
		# { 
		# find_ring: {description: "My Precious", completed: false, etc...},
		# melt_ring: {description: "Idk", completed: false, etc...}
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
		xp = 0
		the_task = tasks[task]

		if the_task != current_task
			the_task[:will_complete] = true
		end

		if !the_task[:completed] && the_task == current_task[1]
			the_task[:completed] = true
			puts "Task '#{the_task[:description]}' completed!".cyan
			@tasks_completed += 1
			new_task = current_task
			xp += 15
			unless new_task.empty?
				xp += complete(new_task[0])[:xp] if new_task[1][:will_complete]
			end
		end

		{xp: xp}
	end
	
	def current_task
		result = @tasks.detect { |_, task| !task[:completed] }
		result.nil? ? {} : result
	end

	def [](task)
		@tasks[task]
	end

	def completed(task = nil)
		if task
			@tasks[task.to_sym][:completed]
		else
			@tasks.all? { |_, task| task[:completed] }			
		end
	end

	alias_method :completed?, :completed

end
