extends Node

enum ItemType{
	COMSUMABLE,
	MELEE,
	GUN,
	AMMO,
	THROWABLE,
}

enum AmmoType{
	ROUNDS_9MM,
	ROUNDS_MAGNUM,
	SHELLS,
	ROUNDS_RIFLE,
	CARTRIDGES_RAILGUN,
	ROUNDS_GRENADE,
}

const THEME_COLOR := Color("ff3c3c")

var _item_data : Dictionary
var _anim_data : Dictionary
var _sound_data : Dictionary
var _map_data : Dictionary

var _terminal_configs : Dictionary


# Called when the node enters the scene tree for the first time.
func _ready():
	# load item data reference json file
	_sound_data = load_json("res://data/sound_data.json")
	_map_data = load_json("res://data/map_data.json")
	_terminal_configs = load_json("res://data/terminal_configs.json")


func load_json(path):
	var file = File.new()
	var dict := {}
	file.open(path, file.READ)
	var text = file.get_as_text()
	file.close()
	var data_parse = JSON.parse(text)
	if data_parse.error != OK:
		print("ERROR: " + path + " cannot be loaded")
		return dict
	else:
		dict = data_parse.result
		return dict
	

func find_item(id):
	if _item_data or !_item_data.empty():
		if typeof(id) == TYPE_INT and id >= 0:
			# return dict
			return _item_data[str(id)]
		elif typeof(id) == TYPE_STRING:
			for element in _item_data.keys():
				if _item_data[element]["name"] == id:
					return element
		print("WARNING: id_" + id + " Item not found.")
		return null
	else:
		print("ERROR: Item data not loaded.")
	return null


func find_sound(id):
	if _sound_data or !_sound_data.empty():
		if typeof(id) == TYPE_INT and id >= 0:
			# return dict
			return _sound_data[str(id)]
		elif typeof(id) == TYPE_STRING:
			for element in _sound_data.keys():
				if _sound_data[element]["name"] == id:
					return _sound_data[element]
		print("WARNING: id_" + id + " Sound not found.")
		return null
	else:
		print("ERROR: Sound data not loaded.")
	return null


func find_data(type: String, id):
	var dict
	match type:
		"ITEM":
			dict = _item_data
		"SOUND":
			dict = _sound_data
		"MAP":
			dict = _map_data
			
	if dict or !dict.empty():
		if typeof(id) == TYPE_INT and id >= 0:
			# return dict
			return dict[str(id)]
		elif typeof(id) == TYPE_STRING:
			for element in dict.keys():
				if dict[element]["name"] == id:
					return element
		print("WARNING: id_" + id + " " + type + " data not found.")
		return null
	else:
		print("ERROR: " + type + " data not loaded.")
	return null


func find_terminal_config(id):
	if _terminal_configs or !_terminal_configs.empty():
		if _terminal_configs.has(id):
			return _terminal_configs[id]
		else:
			print("WARNING: id_" + id + " Sound not found.")
	else:
		print("ERROR: Sound data not loaded.")
	return null
