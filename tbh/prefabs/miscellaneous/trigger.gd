extends Node


export(NodePath) var trigger_node = null
export(String) var function = ""
export var parameter = []


func _ready():
	check_validity()


func check_validity():		
	if !Global.node_exists(trigger_node):
		print("ERROR: " + trigger_node.get_name() + " doesn't exist!\n" + str(trigger_node))
		return false
	if !trigger_node.has_method(function):
		print("ERROR: " + trigger_node.get_name() + " doesn't have " + function + " as a function!\n" + str(trigger_node))
		return false
		
	return true


func triggered():
	return trigger_node.callv(function, parameter)
