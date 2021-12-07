extends Spatial

export var id := -1
export var credits_id := -1

export var music_id = ""
export var music_delay := 0.0
export var ambience_id = ""
export var ambience_delay := 0.0
export var ambience_id_2 = ""
export var ambience_delay_2 := 0.0

export var weather := -1


# Called when the node enters the scene tree for the first time.
func _ready():
	Global.set_world_manager(self)
	LoadManager.set_current_scene(self)
	setup()
	

func setup():
	play_music()
	set_weath()
	
	$Player/Head/Camera/MaterialPreloader.load_materials(id)
	
	if credits_id >= 0:
		$Player/CanvasLayerMenu/GUI/Credits.show()
		$Player/CanvasLayerMenu/GUI/Credits.play_credit(credits_id)


func play_music():
	if music_id != "":
		SoundManager.play_music(music_id, music_delay)
	if ambience_id != "":
		SoundManager.play_ambience(ambience_id, ambience_delay)
	if ambience_id_2 != "":
		SoundManager.play_ambience(ambience_id_2, ambience_delay_2, 1)


func set_weath():
	if weather == 1:
		$Player/Particles.emitting = true

