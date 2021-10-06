extends Interactable
class_name Stationary
# class stationary
# extends from Interactable
# for any obj which player can interact


# any events will happen here if player chooses to interact this obj
# inherited obj will override this func
func _interact():
	print("Player interacts with " + obj_name)
