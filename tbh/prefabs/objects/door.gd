extends StaticBody

# path to a scene
export var portal_to = ""
export var fade_out_ambience := false
export var fade_out_music := false

var is_opened := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Area_body_entered(body):
	if body == Global.get_player() and !is_opened:
		open()


func open():
	is_opened = true
	print("door opened")
	
	if fade_out_ambience:
		SoundManager.fade_out_ambience()
	
	if portal_to != "":
		LoadingScreen.goto_scene(portal_to)
	
	
