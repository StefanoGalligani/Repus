extends StaticBody2D
class_name Door

export var total = 1

func enemyDead():
	total -= 1
	if total == 0:
		queue_free()