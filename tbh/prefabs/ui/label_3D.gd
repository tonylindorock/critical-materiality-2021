tool
extends Viewport

export var text := "Text" setget set_text, get_text

var update := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	size = $Viewport/Label.rect_size
	
	if update:
		force_update()


func force_update():
	update = false
	$Sprite.flip_h = true
	$Sprite.flip_h = false
	

func set_text(txt):
	text = txt
	$Viewport/Label.text = text
	update = true
	

func get_text():
	return text
