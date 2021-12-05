extends Control


var credits = [
	"Created by",
	"Yichen Wang",
	"The Bunker House",
	"",
	"A Digital Fiction",
	"",
	"20XX",
	""
]

var end = [
	"The Bunker House",
	""
]

var credit_array = []
var credit_id := 0
var index := 0

onready var _bold_text = $Center/Text/Bold
onready var _normal_text = $Center/Text/Normal
onready var bg = $Bg


# Called when the node enters the scene tree for the first time.
func _ready():
	credit_array = [credits, end]


func play_credit(id):
	if id >= 0:
		credit_id = id
		index = 0
		update_text()
	
	
func update_text():
	_bold_text.text = credit_array[credit_id][index]
	
	if credit_array[credit_id][index+1] == "":
		_normal_text.hide()
	else:
		_normal_text.show()
		_normal_text.text = credit_array[credit_id][index+1]
	
	yield(get_tree().create_timer(2), "timeout")
	$AnimationPlayer.play("fade")


func advance():
	if index + 2 < credit_array[credit_id].size() - 1:
		index += 2
		update_text()
	else:
		if credit_id == 1:
			LoadManager.goto_scene("res://common/main_menu.tscn")
		$AnimationPlayer.play("all_fade_out")

