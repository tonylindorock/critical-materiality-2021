tool
extends Control

const ALTER_SPEED := .5

export(String) var _text := "Name" setget set_text

# display value
export(int) var _min := 0 setget set_min
export(int) var _max := 100 setget set_max
export(int) var _value := 50 setget set_value

export(String) var _num_sign := "%" setget set_num_sign

var _sliding := false
var _mouse_entered := false

onready var _ref_value = $Margin/Container/TopContainer/Value
onready var _ref_progress = $Margin/Container/Progress

# Called when the node enters the scene tree for the first time.
func _ready():
	update_value()


func map(value, input_a, input_b, output_a, output_b):
	return (value - input_a) / (input_b - input_a) * (output_b - output_a) + output_a


func set_min(val):
	_min = val
	$Margin/Container/Progress.min_value = _min


func set_max(val):
	_max = val
	$Margin/Container/Progress.max_value = _max


func set_value(new_value):
	_value = new_value
	$Margin/Container/Progress.value = _value
	$Margin/Container/TopContainer/Value.text = str($Margin/Container/Progress.value) + _num_sign
		
	
func set_text(new_text):
	_text = new_text
	$Margin/Container/TopContainer/Des.set_text(_text)


func set_num_sign(character):
	_num_sign = character
	set_value(_value)
	

func update_value():
	_value = _ref_progress.value
	_ref_value.text = str(_ref_progress.value) + _num_sign


func get_value():
	return _value


# handle mouse sliding
func _on_TextureProgress_gui_input(event):
	if event is InputEventMouseButton:
		var change = 1
		match event.button_index:
			BUTTON_WHEEL_UP:
				if event.pressed and _mouse_entered:
					_ref_progress.value += change
			BUTTON_WHEEL_DOWN:
				if event.pressed and _mouse_entered:
					_ref_progress.value -= change
			_:
				if event.pressed:
					_sliding = true
					_ref_progress.tint_progress = Color("ff3c3c")
				else:
					_sliding = false
					_ref_progress.tint_progress = Color.white
	
	if event is InputEventPanGesture and _mouse_entered:
		var change = -event.delta.x
		_ref_progress.value += change * ALTER_SPEED * 2
		
	if _sliding and event is InputEventMouseMotion:
		var change = event.get_relative().x
		_ref_progress.value += change * ALTER_SPEED
	update_value()


func _on_TextureProgress_mouse_entered():
	_mouse_entered = true
	_ref_progress.tint_progress = Color.white
	emit_signal("mouse_entered")


func _on_TextureProgress_mouse_exited():
	_mouse_entered = false
	_ref_progress.tint_progress = Color("bbb")
	emit_signal("mouse_exited")
