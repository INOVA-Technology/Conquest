$quests = {
	# consider whether you want the task name
	# to give away what you have to do or not
	main:   Quest.new(name: "Questalicious", tasks: [[:climb_tree, "Banyan"], [:go_to_village, "Go to the village"]]),
	mordor: Quest.new(name: "Onward to Mordor", tasks: [[:read_scroll, "Figure out what the scroll says"]]),
	hex:    Quest.new(name: "Escape from Merge Conflictia", tasks: [[:iphone, "69 70 68 6f 6e 65"], [:escape, "Escape from Merge Conflicia"]])
}
