class Room

	attr_reader :items, :options, :people, :locked_paths

	def initialize(options = {})
		@name = options[:name]
		@description = options[:desc]
		@paths = (options[:paths] || {})
		@items = (options[:items] || {})
		@people = (options[:people] || {})
		@task = (options[:task] || {})
		@locked_paths = (options[:locked_paths] || [])
		@options = options
		@visited = false
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

	def path_locked(path)
		@locked_paths.include?(path.to_sym)
	end

	alias_method :path_locked?, :path_locked

	def unlock_path(path)
		@locked_paths.delete(path.to_sym)
	end

	def get_item(item)
		@items[item.to_sym]
	end

	def get_person(name)
		person = @people[name.to_sym]
		if person
			(person.is_alive? ? person : nil)
		else
			nil
		end
	end

	def living_people(show_hidden = false)
		all = @people.select { |_, p| p.is_alive }
		all = all.reject { |_, p| p.hidden }
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
				puts item.name_with_prefix
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

# add way for player to drown in here if they dont have a boat or something
class BodyOfWater < Room

end
