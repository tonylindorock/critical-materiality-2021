tool
extends RichTextEffect
class_name RichTextAngry

# Syntax: [angry freq=0.5][/whisper]

var bbcode = "angry"

func _process_custom_fx(char_fx):
	# Get parameters, or use the provided default value if missing.
	var freq_color = char_fx.env.get("freqColor", 16.0)
	var freq_shake = char_fx.env.get("freqShake", 2.0)
	var scale = char_fx.env.get("scale", 1.0)
	
	char_fx.color = lerp(char_fx.color, Color.red, sin(char_fx.elapsed_time * freq_color) * 0.5 + 0.5)
	
	var new_random_pos = Vector2(rand_range(-1, 1), rand_range(-1, 1)) * scale
	var offset = lerp(char_fx.offset, new_random_pos, freq_shake)
	char_fx.offset = offset
	
	return true
