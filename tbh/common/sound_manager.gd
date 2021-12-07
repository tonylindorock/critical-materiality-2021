extends Node

const LOWEST_DB = -61

var repeat_music := false

var ambience_tracks = []

onready var _ui_stream = $UIStream
onready var _sfx_stream = $SFXStream
onready var _music_stream = $MusicStream
onready var _ambience_stream = $AmbienceTrack0
onready var _ambience_stream_1 = $AmbienceTrack1


# Called when the node enters the scene tree for the first time.
func _ready():
	ambience_tracks = [_ambience_stream, _ambience_stream_1]


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


func play_ambience(id, delay:float = 0.0, track_id := 0):
	var sound = Core.find_sound(id)
	if sound:
		if delay > 0.0:
			yield(get_tree().create_timer(delay), "timeout")
		ambience_tracks[track_id].stream = load(sound["path"])
		ambience_tracks[track_id].volume_db = sound["volume"]
		ambience_tracks[track_id].play()


func fade_out_ambience(duration:float = 1.0, delay:float = 0.0):
	$TweenOut.interpolate_property(_ambience_stream, "volume_db", _ambience_stream.volume_db, LOWEST_DB, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	$TweenOut.start()
	
	$TweenOut2.interpolate_property(_ambience_stream_1, "volume_db", _ambience_stream_1.volume_db, LOWEST_DB, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	$TweenOut2.start()


func fade_out_music(duration:float = 1.0, delay:float = 0.0):
	$TweenOut.interpolate_property(_music_stream, "volume_db", _music_stream.volume_db, LOWEST_DB, duration,
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, delay)
	$TweenOut.start()
