extends Area2D

signal ButtonPressed()

func _ready():
	pass

func press():
	$active.visible = true
	$inactive.visible = false
	print("signaled")
	emit_signal("ButtonPressed")

func _on_Button_body_entered(body):
	if body.name == "Player":
		body.button_enter(self)


func _on_Button_body_exited(body):
	if body.name == "Player":
		body.button_exit(self)
