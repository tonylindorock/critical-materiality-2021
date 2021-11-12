extends Spatial

var time := 2

onready var _empty = $Empty

func _setup():
	set_process(false)


func _process(_delta):
	if time > 0:
		time -= 1
	if time == 0:
		hide()


func remove_all_children():
	if get_child_count() > 1:
		for element in get_children():
			if element != $Empty:
				element.queue_free()


func load_materials(map_id : int):
	remove_all_children()
	var result = Core.find_data("MAP", map_id)
	if result:
		for element in result["materials"]:
			var path = "res://resources/materials/" + element + ".tres"
			# check if exists
			var directory = Directory.new();
			if directory.file_exists(path):
				var new_empty = MeshInstance.new()
				new_empty.mesh = $Empty.mesh
				new_empty.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
				new_empty.set_surface_material(0, load(path))
				
				add_child(new_empty, true)
			else:
				print("WARNING: " + element + " material doesn't exist!")
	set_process(true)
