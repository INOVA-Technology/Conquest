var x = y = 0

interact(".draggable").draggable({
	onmove: function (event) {
		x += event.dx;
		y += event.dy;

		event.target.style.webkitTransform =
		event.target.style.transform =
			'translate(' + x + 'px, ' + y + 'px)';
	}
})
.inertia(true)
.restrict({
    drag: "parent",
    endOnly: true
});