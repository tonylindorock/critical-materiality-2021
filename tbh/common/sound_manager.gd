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


func play_music(id, delay:float = 0.0):
	var sound = Core.find_sound(id)
	if sound:
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
		_music_stream.stream = load(sound["path"])
		_music_stream.volume_db = sound["volume"]
		_music_stream.play()


func play_ambience(id, delay:float = 0.0):
	var sound = Core.find_sound(id)
	if sound:
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
		_ambience_stream.stream = load(sound["path"])
		_ambience_stream.volume_db = sound["volume"]
		_ambience_stream.play()

