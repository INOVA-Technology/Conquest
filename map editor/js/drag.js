var x = y = 0

interact(".draggable").draggable({
	onmove: function(event) {
		x += event.dx;
		y += event.dy;

		event.target.style.webkitTransform =
		event.target.style.transform =
			'translate(' + x + 'px, ' + y + 'px)';
	}
})
.restrict({
    drag: "parent",
    endOnly: true
});

$('.add-room').on('click', function(event) {
	var e = '<div class="draggable"><h1 class="name" contenteditable>name</h1></div>';
	$('.container').append(e);
});