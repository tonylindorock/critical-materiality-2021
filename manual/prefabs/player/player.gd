extends KinematicBody
# this is the player class


enum InteractableItem {
	COLLECTABLE,
	PICKABLE,
	STATIONARY,
}


# outline
const OUTLINE_DEFAULT := Color(0, 1, 0, 0.8)
const OUTLINE_NO_ROOM := Color(1, 0, 0, 0.8)
const OUTLINE_INTERACTIVE := Color(0, 1, 0, 0.8)
const OUTLINE_WIDTH_DEFAULT := 2
const OUTLINE_WIDTH_THICK := 3

const HEIGHT_DEAFULT := 1.8
const HEIGHT_CROUCHING := HEIGHT_DEAFULT/2.0

const HEAD_Y_POS := 2.46
const HEAD_CROUCH_Y_POS := 2.46/1.3

const weapon_cam_fov = 33

const MAX_STAMINA := 200.0
const MAX_HEALTH := 100

# movement
export var speed := 8
export var crouch_speed := 4
export var run_speed := 14
export var acceleration := 6
export var g := 0.98
export var jump_s := 18

export var fall_height := 30

# environment
export var speed_force_ratio := 0.5
export(float, 0, 1) var push_factor = 0.1

# stats
export(int) var _health := 100
export(int) var _stamina := 200.0
var stamina_consume_amount := 30

# view
export var sway_threshold := 5
export var sway_speed := 4
export var sway_h := Vector3()
export var sway_v := Vector3()

var air_acc := 1
var normal_acc = acceleration

var current_speed := speed
var head_basis = Vector3.ZERO
var direction := Vector3.ZERO
var velocity := Vector3.ZERO
var g_velocity := Vector3.ZERO
var ground_contact := false
var snap

# view
var mouse_sensitivity := 0.3
var disable_motion := false
var _mouse_motion := Vector2()

const MAX_ANGLE := 80.0
const MIN_ANGLE := 45.0
var _looking_angle := 80.0

var camera_v_offset := 0.4
var camera_v_offset_speed := 10

var _interact_item = null
var _looking_item_id := -1

var _holding_item := false
var _cannot_pick_up_item := false

# player action
var _requesting_ammo_counter := false
var _is_running := false
var _can_run := true
var _is_crouching := false
var _head_on_ceiling := false
var _using_ads := false

var _is_going_left := true
var _is_going_right := true

onready var _collision = $CollisionShape

onready var _head = $Head
onready var _hand = $Head/Camera/Hand
onready var _flashlight = $Head/Camera/Hand/Flashlight

onready var _camera = $Head/Camera
onready var _camera_gun = $ViewportContainer/ViewportWeapon/Camera
onready var _camera_outline = $ViewportContainer2/ViewportOutline/CameraOutline

onready var _ray_ground = $RayGround
onready var _ray_weapon = $Head/Camera/RayWeapon
onready var _ray_interact = $Head/Camera/RayInteract


# Called when the node enters the scene tree for the first time.
func _ready():
	
	_camera_outline.fov = _camera.fov
	_camera_outline.far = _camera.far
	
	g /= float(ProjectSettings.get_setting("physics/common/physics_fps")) / 60.0
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	Global.set_player(self)
	

func _process(delta):
	check_for_interactive_obj()
	_handle_weapon_sway(delta)
	_handle_crouching(delta)
	
	# sync other cameras with the main camera
	_camera_gun.global_transform = _camera.global_transform
	_camera_outline.global_transform = _camera.global_transform
	
	$Head/Camera/ObjPos.rotation_degrees.x = - _camera.rotation_degrees.x


func _physics_process(delta):
	_get_movement()
	_handle_stamina(delta)
	
	# gravity
	if _ray_ground.is_colliding():
		# landing makes camera shift down a little (offset)
		if !ground_contact:
			if not _is_crouching and g_velocity.length() >= 10: # fixed dither camera movement when crouching
				_camera.v_offset = -camera_v_offset
				_camera_outline.v_offset = -camera_v_offset
			
			if g_velocity.length() >= fall_height:
				print(-g_velocity.length() * Global.FALL_DAMAGE_RATIO)
				change_health(-g_velocity.length() * Global.FALL_DAMAGE_RATIO)
				print("fall damage")
				
		ground_contact = true
		lerp_camera_offset(_camera, 0, 0, camera_v_offset_speed, delta)
		lerp_camera_offset(_camera_outline, 0, 0, camera_v_offset_speed, delta)
		
		# check for if a pickable obj is under player while lifting
		if _holding_item and _ray_ground.get_collider() == _interact_item:
			unpick_item()
		
		# delay after walking off edges
		if ground_contact and g_velocity.y < 0:
			$TimerOffEdgeJump.start()
	else:
		ground_contact = false
		
	if not is_on_floor():
		snap = Vector3.DOWN
		g_velocity += Vector3.DOWN * g
		acceleration = air_acc
	elif is_on_floor() and ground_contact:
		snap = - get_floor_normal()
		g_velocity = - get_floor_normal() * g
		acceleration = normal_acc
	else:
		snap = - get_floor_normal()
		g_velocity = - get_floor_normal()
		acceleration = normal_acc
	
	# jump
	if Input.is_action_just_pressed("player_jump") and (is_on_floor() or (ground_contact or !$TimerOffEdgeJump.is_stopped())):
		if !_holding_item or _interact_item.mass <= 20:
			$TimerOffEdgeJump.stop()
			snap = Vector3.ZERO
			g_velocity = Vector3.UP * jump_s
	
	# acc
	velocity = velocity.linear_interpolate(direction * current_speed, acceleration * delta)
	
	# apply g
	var movement := velocity + g_velocity
	
	movement = move_and_slide_with_snap(movement, snap, Vector3.UP, false, 4, PI/4, false)
	
	for index in get_slide_count():
		var collision = get_slide_collision(index)
		if collision.collider.is_in_group("Pickable"):
			#collision.collider.apply_force(-collision.normal * velocity.length() * speed_force_ratio * push_factor)
			collision.collider.apply_central_impulse(-collision.normal * velocity.length() * speed_force_ratio * push_factor)


func _input(event):
	if !disable_motion:
		# mouse motion
		if event is InputEventMouseMotion:
			
			_head.rotate_y(deg2rad(- event.relative.x * mouse_sensitivity))
			_camera.rotate_x(deg2rad(- event.relative.y * mouse_sensitivity))
			_camera.rotation_degrees.x = clamp(_camera.rotation_degrees.x, -_looking_angle, _looking_angle)
			
			_mouse_motion = - event.relative
		
			
		if event.is_action_pressed("player_interact"):
			if _holding_item:
				unpick_item()
			else:
				request_item_interaction()
		
			
		# run
		if event.is_action_pressed("player_run") and _can_run and is_moving() and is_on_floor():
			current_speed = run_speed
			_is_running = true
		elif event.is_action_released("player_run"):
			current_speed = speed
			_is_running = false
		
		if event.is_action_pressed("player_flashlight"):
			_flashlight.set_visible(!_flashlight.visible)
	
		
func _get_movement():
	# movement
	head_basis = _head.get_global_transform().basis
	direction = Vector3.ZERO
	if Input.is_action_pressed("player_forward"):
		direction -= head_basis.z
	if Input.is_action_pressed("player_backward"):
		direction += head_basis.z
	if Input.is_action_pressed("player_left"):
		_is_going_left = true
		direction -= head_basis.x
	else:
		_is_going_left = false
	if Input.is_action_pressed("player_right"):
		_is_going_right = true
		direction += head_basis.x
	else:
		_is_going_right = false
		
	direction = direction.normalized()


func _handle_crouching(delta):
	var crouch_s = 8
	
	_head_on_ceiling = false
	if $RayCeiling.is_colliding():
		_head_on_ceiling = true
		
	if Input.is_action_pressed("player_crouch"):
		_can_run = false
		_is_crouching = true
		
		current_speed = crouch_speed
		# decrease collision height
		_collision.shape.height -= crouch_s * delta
		# lower head
		_head.translation.y = lerp(_head.translation.y, HEAD_CROUCH_Y_POS, crouch_s * delta)
		# shorten raycast range so that it still can register ground
		_ray_ground.cast_to.y = -0.5
	elif not _head_on_ceiling:
		# reset
		_collision.shape.height += crouch_s/1.5 * delta
		_head.translation.y = lerp(_head.translation.y, HEAD_Y_POS, crouch_s/1.5 * delta)
		_ray_ground.cast_to.y = -1
	
	_collision.shape.height = clamp(_collision.shape.height, HEIGHT_CROUCHING, HEIGHT_DEAFULT)
	
	# if collision height restored, crouching state ends
	if abs(_collision.shape.height -  HEIGHT_DEAFULT) < 0.0001:
		if _is_crouching:
			current_speed = speed
			_can_run = true
		_is_crouching = false
		

# handling hand sway when equipping a weapon or an item
# View: mouse movement
# Moving: horizontal
# Running: vertical
# Falling and jumping: vertical
func _handle_weapon_sway(delta):
	# looking 
	var mouse_h_movement = Vector3()
	# horizontal
	if _mouse_motion.x > sway_threshold:
		mouse_h_movement.y = lerp(mouse_h_movement.y, sway_h.y, sway_speed * delta * 0.5)
		mouse_h_movement.z = lerp(mouse_h_movement.z, sway_h.z, sway_speed * delta * 0.5)
	elif _mouse_motion.x < - sway_threshold:
		mouse_h_movement.y = lerp(mouse_h_movement.y, - sway_h.y, sway_speed * delta * 0.5)
		mouse_h_movement.z = lerp(mouse_h_movement.z, - sway_h.z, sway_speed * delta * 0.5)
	_hand.rotation += mouse_h_movement # add sway
	
	var mouse_v_movement = Vector3()
	# vertical
	if _mouse_motion.y > sway_threshold:
		mouse_v_movement.x = lerp(mouse_v_movement.x, sway_v.x, sway_speed * delta * 0.5)
	elif _mouse_motion.y < - sway_threshold:
		mouse_v_movement.x = lerp(mouse_v_movement.x, - sway_v.x, sway_speed * delta * 0.5)
	_hand.rotation += mouse_v_movement
	
	# running
	var running_movement = Vector3()
	if _is_running and direction != Vector3.ZERO and _can_run:
		running_movement.x = lerp(running_movement.x, - 0.1, sway_speed * delta)
	else:
		running_movement.x = lerp(running_movement.x, 0, sway_speed * delta)
	_hand.rotation += running_movement
	
	# moving left or right
	if ! _using_ads:
		var moving_movement = Vector3()
		if is_moving():
			# moving left
			if _is_going_left:
				moving_movement.z = lerp(moving_movement.z, 0.1, sway_speed * delta)
			# moving right
			elif _is_going_right:
				moving_movement.z = lerp(moving_movement.z, - 0.1, sway_speed * delta)
		_hand.rotation += moving_movement
	
	# if falling or jumping, sway weapon vertically
	if !_ray_ground.is_colliding():
		var fall_movement = Vector3()
		if g_velocity.y < 0:
			fall_movement.x = lerp(fall_movement.x, 0.1, delta * g_velocity.length() * 0.5)
		elif g_velocity.y > 0:
			fall_movement.x = lerp(fall_movement.x, - 0.1, sway_speed * delta * g_velocity.length() * 0.25)
		_hand.rotation += fall_movement
	
	_hand.rotation.x = clamp(_hand.rotation.x, -0.4, 0.4)
	# reset
	_hand.rotation = _hand.rotation.linear_interpolate(Vector3.ZERO, sway_speed * delta)
	_mouse_motion = Vector2.ZERO


func _handle_stamina(delta):
	if _is_running and _can_run:
		if _stamina > 0:
			_stamina -= stamina_consume_amount * 1.2 * delta
	
	if _stamina <= 0 and _can_run:
		_can_run = false
		_is_running = false
		current_speed = speed
	
	if !_is_running:
		_stamina += stamina_consume_amount * delta
		_stamina = clamp(_stamina, 0, MAX_STAMINA)
		# should including all the conditions cannot allow player run
		if _stamina == MAX_STAMINA and !_can_run and !_is_crouching:
			_can_run = true
	

func change_health(amount):
	if typeof(amount) == TYPE_INT or typeof(amount) == TYPE_REAL:
		_health += int(amount)
		_health = int(clamp(_health, 0, MAX_HEALTH))
		print("Player health changed: " + str(_health))
	else:
		print("ERROR: " + str(amount) + " is not a number!")


func _handle_ads(delta):
	pass
		

func is_moving():
	return direction.z != 0 or direction.x != 0


func lerp_camera_fov(camera, new_value, lerp_speed, delta):
	camera.fov = lerp(camera.fov, new_value, lerp_speed * delta)
	

func lerp_camera_offset(camera, h, v, lerp_speed, delta):
	camera.h_offset = lerp(camera.h_offset, h, lerp_speed * delta)
	camera.v_offset = lerp(camera.v_offset, v, lerp_speed * delta)
	

func check_for_interactive_obj():
	# reset
	_looking_item_id = -1
	_interact_item = null
	
	if _ray_interact.is_colliding():
		var obj = _ray_interact.get_collider()
		if obj:
			if obj.is_in_group("Collectable"):
				obj.highlight()
				_looking_item_id = InteractableItem.COLLECTABLE
				_interact_item = obj
				set_outline()
			elif obj.is_in_group("Pickable"):
				obj.highlight()
				_looking_item_id = InteractableItem.PICKABLE
				_interact_item = obj
				set_outline(OUTLINE_INTERACTIVE, OUTLINE_WIDTH_THICK)
			elif obj.is_in_group("Stationary"):
				obj.highlight()
				_looking_item_id = InteractableItem.STATIONARY
				_interact_item = obj
				set_outline(OUTLINE_INTERACTIVE, OUTLINE_WIDTH_THICK)
				

func set_outline(color : Color = OUTLINE_DEFAULT, width : float = OUTLINE_WIDTH_DEFAULT):
	$ViewportContainer2.material.set_shader_param("width", width)
	$ViewportContainer2.material.set_shader_param("color", color)
	

func request_item_interaction():
	match _looking_item_id:			
		InteractableItem.PICKABLE:
			if check_item_exitence(_interact_item, Global.PickableItem):
				if _ray_ground.get_collider() != _interact_item and !_cannot_pick_up_item:
					_interact_item.lift($Head/Camera/ObjPos)
					
					_holding_item = true
					_looking_angle = MIN_ANGLE
		
		InteractableItem.STATIONARY:
			if check_item_exitence(_interact_item, Global.StationaryItem):
				_interact_item.interact()
				

func check_item_exitence(item, base_class):
	return item and item.is_inside_tree() and item is base_class
		

func unpick_item():
	if check_item_exitence(_interact_item, Global.PickableItem):
		_interact_item.back_to_world()
		_interact_item = null
		_holding_item = false
		
		_looking_angle = MAX_ANGLE


func open_terminal(config):
	disable_motion = true
	Global.pause_game()
	Global.player_in_terminal = true
	$CanvasLayerHUD/PlayerUI/Terminal.show()
	$CanvasLayerHUD/PlayerUI/Terminal.switch(true)
	$CanvasLayerHUD/PlayerUI/Terminal.load_config(config)


func _on_AreaGround_body_entered(body):
	if body is Global.PickableItem:
		if _interact_item == body:
			_cannot_pick_up_item = true


func _on_AreaGround_body_exited(body):
	if body is Global.PickableItem:
		if _interact_item == body:
			_cannot_pick_up_item = false


func _on_Terminal_exited():
	disable_motion = false
	Global.player_in_terminal = false
	$CanvasLayerHUD/PlayerUI/Terminal.hide()
