extends Spatial

export var id := -1

export var music_id = ""
export var ambience_id = ""

export var weather := -1


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_world_manager(self)
	LoadingScreen.set_current_scene(self)
	setup()
	

func setup():
	play_music()
	set_weath()
	
	$Player/Head/Camera/MaterialPreloader.load_materials(id)


func play_music():
	if music_id != "":
		SoundManager.play_music(music_id)
	if ambience_id != "":
		SoundManager.play_ambience(ambience_id)


func set_weath():
	if weather == 1:
		$Player/Particles.emitting = true
