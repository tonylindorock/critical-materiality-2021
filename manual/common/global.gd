extends Node
# This is the global

const FALL_DAMAGE_RATIO := 0.5
const MINIMUM_SIZE := Vector2(960, 540)

var _g := 0.98

var _screen_size := Vector2(960, 540)

var player_in_terminal := false

var _world_manager
var _player

var CollectableItem
var PickableItem
var StationaryItem
var ValueSlider



# Called when the node enters the scene tree for the first time.
func _ready():
	PickableItem = preload("res://prefabs/objects/pickable.gd")
	StationaryItem = preload("res://prefabs/objects/stationary.gd")
	ValueSlider = preload("res://prefabs/ui/slider.gd")
	randomize()
	
	_g /= float(ProjectSettings.get_setting("physics/common/physics_fps")) / 60.0
	
	#get_viewport().connect("size_changed", self, "window_resize")
	#window_resize()


func window_resize():
	var current_size = OS.get_window_size()

	var scale_factor = MINIMUM_SIZE.y / current_size.y
	var new_size = Vector2(current_size.x * scale_factor, MINIMUM_SIZE.y)

	if new_size.y < MINIMUM_SIZE.y:
		scale_factor = MINIMUM_SIZE.y / new_size.y
		new_size = Vector2(new_size.x * scale_factor, MINIMUM_SIZE.y)
	if new_size.x < MINIMUM_SIZE.x:
		scale_factor = MINIMUM_SIZE.x / new_size.x
		new_size = Vector2(MINIMUM_SIZE.x, new_size.y * scale_factor)

	get_viewport().set_size_override(true, new_size)
	_screen_size = get_viewport().get_visible_rect().size


func get_gravity():
	return _g


func set_world_manager(world_manager):
	_world_manager = world_manager


func get_world_manager():
	return _world_manager
	

func set_player(player):
	_player = player


func get_player():
	return _player


func pause_game(state := true):
	if state:
		get_tree().paused = true
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	else:
		get_tree().paused = false
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func map(value, input_a, input_b, output_a, output_b):
	return (value - input_a) / (input_b - input_a) * (output_b - output_a) + output_a
