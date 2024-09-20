extends RigidBody2D

func _ready():
	pass

func _process(delta):
	pass

func _on_body_entered(body):
	queue_free()
	pass

func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
	pass
