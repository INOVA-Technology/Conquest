class Room

	attr_reader :items, :options, :people

	def initialize(options = {})
		@name = options[:name]
		@description = options[:desc]
		@paths = (options[:paths] || {})
		@items = (options[:items] || {})
		@people = (options[:people] || {})
		@task = (options[:task] || {})
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
		hash = {}
		unless @visited
			puts @description
			list_items
			@visited = true

			hash[:quest] = @options[:starts_quest]
			hash[:achievement] = @options[:unlocks]
			hash[:task] = @task if @task
		end		
		hash
	end

	def living_people(show_hidden = false)
		all = @people.select { |_, p| p.is_alive }
		{
		all: all,
		merchants: all.select { |_, p| p.is_a?(Merchant) },
		enemies: all.select { |_, p| p.is_a?(Enemy) }
		}
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
		visible_items = @items.values.select { |i| !i.hidden? && i.can_pickup? }
		unless visible_items.empty?

			puts "Items that are here:".magenta
			visible_items.map do |item|
				a_or_an = %w[a e i o u].include?(item.name[0]) \
					? "an " : "a "
				a_or_an = "" if item.name[-1] == "s"
				puts "#{a_or_an}#{item.name.downcase}"
			end
		end

		unless living_people[:all].empty?

			puts "People that are here:".magenta
			living_people[:all].map do |_, people|
				puts "#{people.name}"
			end
		end

	end

end


class Mountain < Room

	def mine
		puts "You start mining, then cause an avalanche and die. Smooth."
		{die: true}
	end

end
