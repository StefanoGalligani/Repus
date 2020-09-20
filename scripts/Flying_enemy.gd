extends KinematicBody2D

const ACCEL = 50
export var SPEED = 50
const MAXSPEED = 300

var motion = Vector2()

var dir = -1
export var distance_dir = 24000
var current_dist_dir = 0

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	motion.y = 0
	
	if current_dist_dir > distance_dir:
		current_dist_dir = 0
		dir *= -1
	
	if dir == 1:
		motion.x = min(motion.x + ACCEL, MAXSPEED)
		$Sprite.flip_h = false
	#	$Sprite.play("run")
	elif dir == -1:
		motion.x = max(motion.x - ACCEL, -MAXSPEED)
		$Sprite.flip_h = true
	#	$Sprite.play("run")
	
	current_dist_dir += abs(motion.x)
		
	motion = move_and_slide(motion)

func die(var v = false):
	if find_node_by_name(get_tree().get_root(), "Door"):
		find_node_by_name(get_tree().get_root(), "Door").enemyDead()
	queue_free()

func _on_DieArea_body_entered(body):
	if body.is_in_group("Player"):
		body.playHit()
		die()

func find_node_by_name(root, name):
    if(root.get_name() == name): return root
    for child in root.get_children():
        if(child.get_name() == name):
            return child
        var found = find_node_by_name(child, name)
        if(found): return found
    return null

func _on_KillArea_body_entered(body):
	if body.is_in_group("Player"):
		body.die()
