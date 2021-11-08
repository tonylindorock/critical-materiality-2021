extends Position3D
# will spawn an item with its specific id or name


func spawn(item_id, num):
	var item = Core.find_item(item_id)
	if item and item.has("in_world"):
		if Global.get_player():
			var obj = ResourceLoader.load(item["in_world"], "", ResourceLoader.exists(item["in_world"])).instance()
			Global.get_player().get_parent().add_child(obj)
			obj.global_transform = global_transform
	else:
		print("ERROR: Spawn item id_" + str(item_id) + " unsccuessful")



