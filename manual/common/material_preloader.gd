extends Spatial

var time := 2


func _process(delta):
	if time > 0:
		time -= 1
	if time == 0:
		hide()
