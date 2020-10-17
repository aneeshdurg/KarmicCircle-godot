extends Area2D

signal ButtonPressed()

func _ready():
	pass

var locked = false

func press():
	if locked:
		return
	locked = true
	$active.visible = !$active.visible
	$inactive.visible = !$inactive.visible
	emit_signal("ButtonPressed")
	
	yield(get_tree().create_timer(0.25), "timeout")
	locked = false

func _on_Button_body_entered(body):
	if body.name == "Player":
		body.button_enter(self)


func _on_Button_body_exited(body):
	if body.name == "Player":
		body.button_exit(self)
