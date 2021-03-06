extends Control

var game_paused := false


# Called when the node enters the scene tree for the first time.
func _ready():
	hide()
	$Settings.hide()


func _process(_delta):
	# handle pausing
	if !Global.player_in_terminal:
		if Input.is_action_just_pressed("ui_cancel"):
			if !get_tree().paused:
				show()
				Global.pause_game()
			else:
				hide()
				Global.pause_game(false)
		

func _on_BtnBack_pressed():
	hide()
	Global.pause_game(false)


func _on_BtnQuit_pressed():
	get_tree().quit()


func _on_BtnSettings_pressed():
	$Settings.show()


func _input(event):
	if event.is_action_pressed("ui_console"):
		$Console.visible = !$Console.visible


func _on_BtnMainMenu_pressed():
	SoundManager.fade_out_ambience()
	Global.pause_game(false)
	LoadManager.goto_scene("res://common/main_menu.tscn")
