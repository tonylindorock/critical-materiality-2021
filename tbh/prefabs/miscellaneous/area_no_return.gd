extends Area



func _on_AreaNoReturn_body_entered(body):
	if body == Global.get_player():
		var result = get_tree().reload_current_scene()
		print("Scene reloaded: " + String(result))
	else:
		body.queue_free()
