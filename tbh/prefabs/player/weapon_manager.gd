extends Node
# Manage weapon (equip, firing)

signal fired

const ACCURACY_SPREAD_DIVIDER := 8

export(Resource) var _weapon_script = null

var _NAME := ""
var _CLIP_SIZE := 8
var _PELLET_NUM := 1

var FIRE_MODE := 0
var _FIRE_RATE := 0.5
var _RELOAD_TIME := 2

var _DAMAGE := 20
var _RANGE := 100
var _SPREAD := 3.0
var _FORCE := 10

var _ATTACHMENT := 0

var _PROJECTILE = null
var _PROJECTILE_SPEED := 10

var _IS_MELEE := false

var _ADS_OFFSET := Vector2.ZERO

var id := -1

var _ammo : int = 8
var can_fire := true
var is_reloading := false


const BulletHole = preload("res://prefabs/environment/bullet_hole.tscn")


# Called when the node enters the scene tree for the first time.
func _ready():
	setup()
	
		
func setup():
	if has_weapon():
		_NAME = _weapon_script.NAME
		
		_CLIP_SIZE = _weapon_script.CLIP_SIZE
		_PELLET_NUM = _weapon_script.PELLET_NUM
		
		FIRE_MODE = _weapon_script.FIRE_MODE
		_FIRE_RATE = _weapon_script.FIRE_RATE
		_RELOAD_TIME = _weapon_script.RELOAD_TIME
		
		_DAMAGE = _weapon_script.DAMAGE
		_RANGE = _weapon_script.RANGE
		# calcualte spread
		_SPREAD = ((1 - _weapon_script.HIP_FIRE_ACCURCY) * 100) / ACCURACY_SPREAD_DIVIDER
		_FORCE = _weapon_script.FORCE
		
		_ATTACHMENT = _weapon_script.ATTACHMENT
		
		_PROJECTILE = _weapon_script.PROJECTILE
		
		_IS_MELEE = _weapon_script.IS_MELEE
		
		_ADS_OFFSET = _weapon_script.ADS_OFFSET
		
		_ammo = _CLIP_SIZE
		
		return true
	else:
		return false
	

func set_ammo(ammo):
	_ammo = ammo


func get_ammo():
	return _ammo
	

func get_ads():
	return _ADS_OFFSET


func equip_weapon(weapon_id : int, loaded_ammo : int):
	var weapon = Core.find_item(weapon_id)
	if weapon and weapon.has("weapon_path"):
		_weapon_script = load(weapon["weapon_path"])
		self.id = weapon_id
		if setup():
			_ammo = loaded_ammo
			print("Weapon id_" + str(weapon_id) + " equipped")
	else:
		print("ERROR: Cannot equip weapon id_" + str(weapon_id))
		

func has_weapon():
	if _weapon_script:
		if _weapon_script is Weapon:
			return true
		else:
			print("ERROR: Weapon script is of wrong type.")
			return false
	else:
		print("ERROR: Weapon script is null.")
		return false
	
	
func get_range():
	return _RANGE


func get_spread():
	return rand_range(-_SPREAD, _SPREAD)


func get_force():
	return _FORCE


func fire():
	if _ammo > 0 and not is_reloading:
		if can_fire:
			_ammo -= 1
			can_fire = false
			
			# if multiple pellets (shotguns)
			for _i in range(_PELLET_NUM):
				emit_signal("fired")
				
			print("Fire")
			yield(get_tree().create_timer(_FIRE_RATE), "timeout")
			can_fire = true
	else:
		if not is_reloading:
			reload()
		

func reload():
	if _ammo < _CLIP_SIZE:
		print("Reloading")
		is_reloading = true
		yield(get_tree().create_timer(_RELOAD_TIME), "timeout")
		_ammo = _CLIP_SIZE
		is_reloading = false
