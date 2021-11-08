extends ProgressBar

signal done

var _value := 0
var _speed := 0.1


# Called when the node enters the scene tree for the first time.
func _ready():
	value = 0
	_value = int(value)


func set_progress(new_value):
	_value = new_value
	value = lerp(value, new_value, _speed)


func fill_progress():
	_value = int(max_value)
	value = lerp(value, max_value, _speed)


func _on_Progress_value_changed(value):
	if int(value) >= 100:
		emit_signal("done")
