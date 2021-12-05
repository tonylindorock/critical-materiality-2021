extends Button
# this is the script to attach to any ui button
# which will play sfx when hovered or clicked


func _ready():
	var _err = connect("mouse_entered", self, "play_hover_sfx")
	var _err_1 = connect("pressed", self, "play_press_sfx")


func play_hover_sfx():
	if !disabled:
		SoundManager.play_sfx(5)


func play_press_sfx():
	SoundManager.play_sfx(6)
