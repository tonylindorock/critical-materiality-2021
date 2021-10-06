extends Position3D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()


func appear():
	show()
	$MeshInstance.rotation_degrees.z = rand_range(-90, 90)
	$Sprite3D.rotation_degrees.z = $MeshInstance.rotation_degrees.z
	if !$Timer.is_stopped():
		$Timer.stop()
	$Timer.start()


func _on_Timer_timeout():
	hide()
