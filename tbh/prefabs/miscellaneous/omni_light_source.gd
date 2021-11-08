extends Spatial


export(float, 0, 4096) var light_range = 5.0 setget set_range
export(float, EASE) var attenuation = 1.0 setget set_attenuation
export(Color, RGB) var light_color = Color(1, 1, 1) setget set_color
export var light_energy = 1 setget set_energy



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func set_range(r):
	light_range = r
	$OmniLight.omni_range = light_range


func set_attenuation(a):
	attenuation = a
	$OmniLight.omni_attenuation = attenuation
	

func set_color(c):
	light_color = c
	$OmniLight.light_color = light_color
	

func set_energy(e):
	light_energy = e
	$OmniLight.light_energy = light_energy
