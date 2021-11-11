extends Node

var loader
var wait_frames := 0
var time_max := 1 # msec
var current_scene

var is_loading := false


onready var _ui = $CanvasLayer/UI
onready var _progress = $CanvasLayer/UI/Margin/Container/Progress


func _ready():
	_ui.hide()
	update_current_scene()
	set_process(false)


func set_current_scene(scene):
	current_scene = scene
	print("Current scene is: " + current_scene.name)


func update_current_scene():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() -1)
	

func reset():
	$AnimationPlayer.play("RESET")
	_progress.value = 0


func goto_scene(path): # Game requests to switch to this scene.
	_ui.show()
	
	loader = ResourceLoader.load_interactive(path)
	if loader == null: # Check for errors.
		#show_error()
		return
	set_process(true)
	
	
	if is_instance_valid(current_scene):
		current_scene.queue_free() # Get rid of the old scene.
	else:
		loader = null
		print("ERROR: Can't delete current scene because it doesn't exist.")

	wait_frames = 1
	is_loading = true


func _process(_time):
	if loader == null:
		# no need to process anymore
		if is_loading:
			_progress.fill_progress()
		#_ui.hide()
		#set_process(false)
		return

	# Wait for frames to let the "loading" animation show up.
	if wait_frames > 0:
		wait_frames -= 1
		return

	var t = OS.get_ticks_msec()
	# Use "time_max" to control for how long we block this thread.
	while OS.get_ticks_msec() < t + time_max:
		# Poll your loader.
		var err = loader.poll()

		if err == ERR_FILE_EOF: # Finished loading.
			var resource = loader.get_resource()
			loader = null
			set_new_scene(resource)
			break
		elif err == OK:
			update_progress()
		else: # Error during loading.
			#show_error()
			loader = null
			break


func update_progress():
	var progress = float(loader.get_stage()) / loader.get_stage_count()
	_progress.set_progress(progress * 100)


func set_new_scene(scene_resource):
	current_scene = scene_resource.instance()
	get_node("/root").add_child(current_scene)
	$AnimationPlayer.play("open")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "open":
		_ui.hide()
		is_loading = false
		reset()
		set_process(false)
