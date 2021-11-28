extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func push_command(com):
	$Margin/UI/RichTextLabel.text += "\n" + com


func push_command_and_output(com):
	push_command(com)
	print(com)
	

func prase_command(com):
	var words = com.split(" ", false, 3)
	if words.size() >= 3:
		run(words[0], words[1], words[2])
	elif words.size() == 2:
		run(words[0], words[1], null)
	else:
		push_command_and_output("FAILED: Invalid command!")


func run(script: String, function: String, arg):
	var exist = has_node("/root/" + script)
	if exist:
		var node = get_node("/root/" + script)
		if node.has_method(function):
			if typeof(arg) == TYPE_ARRAY:
				node.callv(function, arg)
			elif arg != null:
				node.call_deferred(function, arg)
			else:
				node.call_deferred(function)
		else:
			var result = "FAILED: " + script + " doesn't have " + function + " as a function!"
			push_command_and_output(result)
	else:
		var result = "FAILED: " + script + " doesn't exist as a script!"
		push_command_and_output(result)


func _input(event):
	if event.is_action_pressed("ui_push"):
		var com = $Margin/UI/Command.text
		push_command(com)
		prase_command(com)
		$Margin/UI/Command.clear()
