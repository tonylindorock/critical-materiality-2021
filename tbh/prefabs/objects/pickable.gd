extends Interactable
# class Pickable
# extents from Interactable
# for any objects and items that can be lifted by the player

var _external_force := Vector3.ZERO

var _player
var speed := 20

var snap := Vector3.ZERO
var g_vel := Vector3.ZERO
var velocity := Vector3.ZERO
var acceleration := 1

var is_picked_up := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


func apply_force(vel):
	_external_force = vel
	

func _integrate_forces(state):
	if is_picked_up and _player:
		var dir = (_player.global_transform.origin - global_transform.origin)
		state.set_linear_velocity(dir * speed)


func _physics_process(_delta):
	apply_central_impulse(Vector3.DOWN * .98/2)
		
	
func lift(player):
	_player = player
	is_picked_up = true
	sleeping = false
	lock_angle(true)


func back_to_world():
	is_picked_up = false
	lock_angle(false)


func lock_angle(state):
	axis_lock_angular_x = state
	axis_lock_angular_y = state
	axis_lock_angular_z = state
