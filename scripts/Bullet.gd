extends KinematicBody2D
class_name Bullet

var direction = Vector2(0, 1)
var lifetime = 5

func _physics_process(delta):
	position += direction * delta * 200
	lifetime -= delta
	if lifetime <= 0:
		queue_free()

func set_direction(var d):
	direction = d

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
		queue_free()
