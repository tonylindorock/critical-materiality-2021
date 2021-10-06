extends Label

signal pressed

var _hovered := false


func _ready():
	exit_hover()
	

func _input(event):
	if _hovered:
		if event is InputEventMouseButton and event.is_pressed() and !event.is_echo():
			emit_signal("pressed")
			
		if event.is_action_pressed("ui_accept"):
			emit_signal("pressed")
	

func enter_hover():
	self_modulate = Color(262626)
	$Bg.show()
	_hovered = true


func exit_hover():
	self_modulate = Color(1, 1, 1)
	$Bg.hide()
	_hovered = false
	

func _on_BtnOption_mouse_entered():
	enter_hover()
	_hovered = true


func _on_BtnOption_mouse_exited():
	exit_hover()
	_hovered = false


func _on_BtnOption_focus_entered():
	enter_hover()


func _on_BtnOption_focus_exited():
	exit_hover()
