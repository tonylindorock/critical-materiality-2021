extends Spatial
# bullet hole
# to spawn on the surface of objects and bodies


func _on_TimerLife_timeout():
	queue_free()
