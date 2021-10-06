extends Panel


onready var _icon = $Margin/Ammo/Icon
onready var _clip = $Margin/Ammo/Numbers/Clip
onready var _total = $Margin/Ammo/Numbers/Total
	
	
func update_num(clip, total):
	set_clip(clip)
	set_total(total)


func set_ammo_icon(image):
	_icon.set_texture(image)


func set_clip(val):
	_clip.set_text(val)


func set_total(val):
	_total.set_text(val)
