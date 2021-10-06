extends RigidBody

export var _speed := 25
export var _damage := 100
export var _radius := 10
export var _wait_frame := 2

var velocity = Vector3.ZERO
var in_motion := false


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _on_AreaHit_body_entered(body):
	if body != self:
		print(body.name + " is hit by the grenade")
		$AreaHit/CollisionShape.disabled = true
		#queue_free()


func fire():
	linear_velocity = -transform.basis.z * _speed
