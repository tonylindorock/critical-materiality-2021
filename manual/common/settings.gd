extends Control

var _btns = []
var _controls = [] # scroll containers

onready var _side_btn_container = $Margin/MainContainer/TopContainer/LeftContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	setup()
	

func setup():
	for btn in _side_btn_container.get_children():
		if btn is Button:
			_btns.push_back(btn)
			btn.connect("pressed", self, "_on_side_btn_pressed", [btn.get_index()])
	
	for item in $Margin/MainContainer/TopContainer/RightContainer/Controls.get_children():
		_controls.push_back(item)
	
	for container in _controls:
		var c = container.get_child(2).get_children()
		for item in c:
			if item is Global.ValueSlider:
				item.connect("mouse_entered", self, "_on_slider_mouse_entered")
				item.connect("mouse_exited", self, "_on_slider_mouse_exited")
	
	hide_all_controls()
	show_control(0)
	

func hide_all_controls():
	for item in _controls:
		item.hide()
	for btn in _btns:
		btn.pressed = false


func show_control(id):
	hide_all_controls()
	_btns[id].pressed = true
	_controls[id].show()


func _on_side_btn_pressed(id):
	hide_all_controls()
	show_control(id)


func _on_BtnCancel_pressed():
	hide()


func _on_BtnOk_pressed():
	hide()
	

func _on_slider_mouse_entered():
	# so that the scroll will not steal mouse scroll events
	for container in _controls:
		container.mouse_filter = MOUSE_FILTER_IGNORE


func _on_slider_mouse_exited():
	for container in _controls:
		container.mouse_filter = MOUSE_FILTER_STOP
