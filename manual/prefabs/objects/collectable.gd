extends Interactable
# class Collectable
# extends from Interactable
# for any items that can be collected by the player

export(int) var _item_id := -1
export(int) var _quantity := 1

var direction := Vector3.DOWN
var g := 0.98
var snap := Vector3.ZERO
var g_velocity := Vector3.ZERO
var velocity := Vector3.ZERO
var normal_acc := 6
var acceleration := normal_acc
var air_acc := 1


# Called when the node enters the scene tree for the first time.
func _ready():
	g /= float(ProjectSettings.get_setting("physics/common/physics_fps")) / 60.0


func get_item_id():
	return _item_id


func get_quantity():
	return _quantity


func set_quantity(remain):
	if remain <= 0:
		queue_free()
	else:
		_quantity = remain
