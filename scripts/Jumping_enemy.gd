extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCEL = 50
export var SPEED = 100
const MAXSPEED = 400
export var JUMP_HEIGHT = -700

var motion = Vector2()

export var dir = -1
export var distance_dir = 24000
var current_dist_dir = 0

export var distance_jump = 30000
var current_dist_jump = 0

func _ready():
	pass # Replace with function body.

func _physics_process(delta):
	motion.y += GRAVITY
	
	if current_dist_dir > distance_dir and is_on_floor():
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

	if is_on_floor():
		if current_dist_jump > distance_jump:
			current_dist_jump = 0
			motion.y = JUMP_HEIGHT
	#else:
	#	$Sprite.play("jump")
	
	current_dist_dir += abs(motion.x)
		
	motion = move_and_slide(motion, UP)
	current_dist_jump += abs(motion.x)

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
