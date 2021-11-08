extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

onready var _ammo_counter = $Margin/Container/BottomContainer/Bottom/AmmoCounter
onready var _stamina_progress = $Margin/Container/BottomContainer/Bottom/PlayerStats/ProgressStamina
onready var _health_progress = $Margin/Container/BottomContainer/Bottom/PlayerStats/ProgressHealth


# Called when the node enters the scene tree for the first time.
func _ready():
	$HurtOverlay.hide()


func show_ammo():
	_ammo_counter.show()
	$TimerAmmo.start()
	

func get_stamina_progress():
	return _stamina_progress
	

func set_stamina_visibility(state : bool):
	if state:
		_stamina_progress.show()
	else:
		_stamina_progress.hide()
	
	
func set_stamina_progress(value):
	_stamina_progress.value = value


func set_health_progress(value):
	_health_progress.value = value
	

func _on_TimerAmmo_timeout():
	_ammo_counter.hide()
