extends Node

export(Array, StreamTexture) var noise_texture = null

var noise_index := 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func enable_ca(state : bool):
	if state:
		$CanvasLayer/ChromaticAbbreviation.show()
	else:
		$CanvasLayer/ChromaticAbbreviation.hide()


func advance_noise():
	noise_index += 1
	if noise_index >= noise_texture.size():
		noise_index = 0
	$CanvasLayer/Grain.texture = noise_texture[noise_index]
