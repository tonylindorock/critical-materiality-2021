extends Node2D

var _in_terminal := false


# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(false)


func _process(_delta):
	if _in_terminal:
		var screen_size = get_viewport().get_visible_rect().size
		
		var mouse_pos = get_global_mouse_position()
		if (mouse_pos.y <= 0 or mouse_pos.y >= screen_size.y or mouse_pos.x <= 0 or mouse_pos.x >= screen_size.x):
			$Texture.hide()
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
			display_cursor()
			
		position = get_global_mouse_position()


func in_terminal(state : bool):
	set_process(state)
	_in_terminal = state
	
	if !state:
		$Texture.hide()
	

func display_cursor():
	$Texture.show()
