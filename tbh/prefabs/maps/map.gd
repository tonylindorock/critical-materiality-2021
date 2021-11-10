extends Spatial


export var music_id = ""
export var ambience_id = ""


# Called when the node enters the scene tree for the first time.
func _ready():
	play_music()


func play_music():
	if music_id != "":
		SoundManager.play_music(music_id)
	if ambience_id != "":
		SoundManager.play_ambience(ambience_id)
