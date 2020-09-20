extends Area2D

export var nextLevel = ""

func _on_EndLevel_body_entered(body):
	get_tree().change_scene("res://scenes/" + nextLevel + ".tscn")
