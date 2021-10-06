tool
extends Control


export(String) var _name := "Name" setget set_name
export(Array, String) var _options := ["Option 0"] setget set_options
export(int) var _current_id := 0 setget set_id


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_name(s):
	_name = s
	$MainContainer/Des.text = _name
	

func set_options(options):
	_options = options
	_update_option()


func set_id(id):
	_current_id = id
	_update_option()


func _update_option():
	if _current_id < _options.size():
		$MainContainer/BottomContainer/DesOption.text = _options[_current_id]
	else:
		print("ERROR: " + _name + " OptionSelector array out of bound.")
	

func _on_BtnUp_pressed():
	_current_id -= 1
	if _current_id < 0:
		_current_id = _options.size() - 1
	_update_option()


func _on_BtnBottom_pressed():
	_current_id += 1
	if _current_id >= _options.size():
		_current_id = 0
	_update_option()
