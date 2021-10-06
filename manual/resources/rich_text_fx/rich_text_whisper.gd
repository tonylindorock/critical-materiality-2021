tool
extends RichTextEffect
class_name RichTextWhisper

# Syntax: [whisper waitTime=0.5][/whisper]

var bbcode = "whisper"

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
	var speed = char_fx.env.get("speed", 4.0)
	var freq = char_fx.env.get("freq", 4.0)
	
	var alpha = sin(char_fx.elapsed_time * speed) * 0.2 + 0.8
	char_fx.color.a = alpha
	
	var sined_time = (sin(char_fx.elapsed_time * freq) + 1.0) / 2.0
	var y_off = sined_time * 1.0
	char_fx.offset = Vector2(0, -1) * y_off
	
	return true
