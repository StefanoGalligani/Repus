extends StaticBody2D

func _on_Area2D_body_entered(body):
	if body.is_in_group("Player"):
		$Sprite.region_enabled = false
		$DoorCollision.position.y = -80
		$Area2D.queue_free()
		get_tree().current_scene.get_child(0).disableCamera()
		get_tree().current_scene.get_child(2).current = true