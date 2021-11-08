extends Node


var _quit_click_time := 0


# Called when the node enters the scene tree for the first time.
func _ready():
	$Settings.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_BtnStart_pressed():
	LoadingScreen.goto_scene("res://common/run.tscn")


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
