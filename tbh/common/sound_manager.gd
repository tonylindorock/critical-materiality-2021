extends Node

const LOWEST_DB = -61

var repeat_music := false

onready var _ui_stream = $UIStream
onready var _sfx_stream = $SFXStream
onready var _music_stream = $MusicStream
onready var _ambience_stream = $AmbienceStream


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(_delta):
	if repeat_music:
		if _music_stream.stream != null and !_music_stream.playing:
			_music_stream.play()


func play_sfx(id):
	var sound = Core.find_sound(id)
	if sound:
		_sfx_stream.stream = load(sound["path"])
		_sfx_stream.volume_db = sound["volume"]
		_sfx_stream.play()


func play_music(id, delay:float = 0.0, repeat:bool = false):
	var sound = Core.find_sound(id)
	if sound:
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
		_music_stream.stream = load(sound["path"])
		_music_stream.volume_db = sound["volume"]
		_music_stream.play()
		
		repeat_music = repeat


func play_ambience(id, delay:float = 0.0):
	var sound = Core.find_sound(id)
	if sound:
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
		_ambience_stream.stream = load(sound["path"])
		_ambience_stream.volume_db = sound["volume"]
		_ambience_stream.play()


func fade_out_ambience(duration:float = 1.0, delay:float = 0.0):
	$TweenOut.interpolate_property(_ambience_stream, "volume_db", _ambience_stream.volume_db, LOWEST_DB, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	$TweenOut.start()


func fade_out_music(duration:float = 1.0, delay:float = 0.0):
	$TweenOut.interpolate_property(_music_stream, "volume_db", _music_stream.volume_db, LOWEST_DB, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	$TweenOut.start()
