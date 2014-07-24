class Room

	attr_reader :items, :options, :people

	def initialize(options = {})
		@name = options[:name]
		@description = options[:desc]
		@paths = (options[:paths] || {})
		@items = (options[:items] || {})
		@people = (options[:people] || {})
		@task = (options[:tasks] || {})
		@options = options
		@visited = false
		add_info
	end

	def add_info

	end

	def [](direction)
		@paths[direction.to_sym]
	end

	def enter
		puts @name.cyan
		unless @visited
			puts @description
			list_items
			@visited = true

			quest = options[:starts_quest]
			$quests[quest].start if quest

			achievement = options[:unlocks]
			$achievements[achievement].unlock if achievement

			quest, task = options[:completes_task]
			$quests[quest].complete(task) if quest && task
		end
		self
	end

	def pickup_item(item)
		@items.delete(item.to_sym).pickup
	end

	def look
		puts @name.cyan
		puts @description
		list_items
	end

	def list_items
		visible_items = @items.values.select { |i| (!i.hidden) && i.can_pickup }
		unless visible_items.empty?

			puts "Items that are here:".magenta
			visible_items.map do |item|
				a_or_an = %w[a e i o u].include?(item.name[0]) \
					? "an " : "a "
				a_or_an = "" if item.name[-1] == "s"
				puts "#{a_or_an}#{item.name.downcase}"
			end
		end

		visible_people = @people.values.select { |i| !i.hidden && i.is_alive }
		unless visible_people.empty?

			puts "People that are here:".magenta
			visible_people.map do |people|
				puts "#{people.name}"
			end
		end

	end

end
