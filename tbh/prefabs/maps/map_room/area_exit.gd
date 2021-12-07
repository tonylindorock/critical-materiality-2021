extends Area


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	

func _on_AreaExitTrigger_body_entered(body):
	if body == Global.get_player():
		$CollisionShape.disabled = false
		print("Event triggered")


func _on_AreaExit_body_entered(body):
	if body == Global.get_player():
		SoundManager.fade_out_ambience()
		
		body.credits.show()
		body.credits.bg.show()
		body.credits.play_credit(1)
