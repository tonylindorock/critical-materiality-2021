extends Stationary

export var _config = "empty"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func interact():
	._interact()
	var player = Global.get_player()
	if player:
		player.open_terminal(_config)
