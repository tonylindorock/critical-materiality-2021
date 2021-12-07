tool
extends Spatial


export(bool) var on := true setget set_on


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_on(state):
	on = state
	if on:
		$OmniLight.show()
	else:
		$OmniLight.hide()
