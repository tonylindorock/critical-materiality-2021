extends Node


onready var _ui_stream = $UIStream
onready var _sfx_stream = $SFXStream
onready var _music_stream = $MusicStream
onready var _ambience_stream = $AmbienceStream


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func play_sfx(id):
	var sound = Core.find_sound(id)
	if sound:
		_sfx_stream.stream = load(sound["path"])
		_sfx_stream.volume_db = sound["volume"]
		_sfx_stream.play()
