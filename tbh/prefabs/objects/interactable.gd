extends RigidBody
class_name Interactable
# base class for any object which player can interact

export var obj_name := "Object"

var _player_is_looking := false


func _process(_delta):
	if !_player_is_looking:
		$MeshInstance.set_layer_mask_bit(2, false)
	else:
		$MeshInstance.set_layer_mask_bit(2, true)
	_player_is_looking = false
	
	
func highlight():
	_player_is_looking = true
