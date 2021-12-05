extends Node


var _quit_click_time := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Settings.hide()
	
	SoundManager.play_music("music_hill", 0, true)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _input(event):
	if event is InputEventKey or event is InputEventMouseButton:
		if event.pressed:
			$Margin/UI/Label.hide()
			$Margin/UI/LabelVersion.show()
			$Margin/UI/Container.show()


func _on_BtnStart_pressed():
	SoundManager.fade_out_music()
	LoadManager.goto_scene("res://prefabs/maps/test_surface.tscn")


func _on_BtnSettings_pressed():
	$Settings.show()


func _on_BtnQuit_pressed():
	if _quit_click_time == 1:
		get_tree().quit()
	_quit_click_time = 1
	$Margin/UI/Container/BtnContainer/BtnQuit.set_text("CONFIRM")


func _on_BtnQuit_mouse_exited():
	_quit_click_time = 0
	$Margin/UI/Container/BtnContainer/BtnQuit.set_text("QUIT")
