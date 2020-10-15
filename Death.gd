extends CanvasLayer

signal DeathAnimationDone()

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var animation = $AnimationPlayer
onready var label = $PopupDialog/Label
onready var dialog = $PopupDialog

func animate(text):
	label.text = text
	
	dialog.popup()
	yield(get_tree().create_timer(0.5), "timeout")
	
	animation.play("Fade")
	yield(animation, "animation_finished")
	
	yield(get_tree().create_timer(0.5), "timeout")
	dialog.hide()
	
	animation.play_backwards("Fade")
	yield(animation, "animation_finished")
	emit_signal("DeathAnimationDone")
