extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
const ACCEL = 50
export var SPEED = 100
const MAXSPEED = 500
export var JUMP_HEIGHT = -800

var motion = Vector2()

export var dir = -1

export var distance_jump = 70000
var current_dist_jump = 0

var state = 0;
var target = Vector2(2464, 0)

var shooting_time = 5
var curr_shooting_time = 0
var shooting_interval = 1
var curr_shooting_interval = 0
var bullet_number = 1
var pause_time = 3
var curr_pause_time = 0

var platforms_restored = 0

var bullet = preload("res://scenes/Bullet.tscn")

func _ready():
	find_node_by_name(get_tree().get_root(), "End_ui").get_child(0).release_focus()

func _physics_process(delta):
	if (state == 0):
		motion.y += GRAVITY
	
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
			
		motion = move_and_slide(motion, UP)
		current_dist_jump += abs(motion.x)

	elif state == 1:
		motion = target - position
		position += motion * delta * 2
		if position.distance_to(target) < 20:
			spawn_bullets()
			state = 2
	
	elif state == 2:
		curr_shooting_time += delta
		if curr_shooting_time > shooting_time:
			state = 3
			curr_shooting_time = 0
		else:
			curr_shooting_interval += delta
			if curr_shooting_interval > shooting_interval:
				spawn_bullets()
				curr_shooting_interval = 0
			pass
	
	elif state == 3:
		curr_pause_time += delta
		if curr_pause_time > pause_time:
			state = 2
			curr_pause_time = 0
			if platforms_restored == 0:
				find_node_by_name(get_tree().get_root(), "Platform1").position.y -= 1000
				find_node_by_name(get_tree().get_root(), "Platform2").position.y -= 1000
				platforms_restored = 1
				shooting_interval = 0.6
				bullet_number += 1
				$AudioPlatforms.play()
			elif platforms_restored == 1:
				find_node_by_name(get_tree().get_root(), "Platform3").position.y -= 1000
				platforms_restored = 2
				shooting_interval = 0.4
				bullet_number += 1
				$AudioPlatforms.play()

func spawn_bullets():
	$AudioShoot.play()
	var direction = Vector2(0, 1)
	var count = 0
	while (count < bullet_number):
		var new_d = direction.rotated(deg2rad(rand_range(-45, 45)))
		var b = bullet.instance()
		add_child(b)
		b.set_direction(new_d)
		count += 1

func die(var v = false):
	if state == 0:
		state = 1
		find_node_by_name(get_tree().get_root(), "Platform1").position.y += 1000
		find_node_by_name(get_tree().get_root(), "Platform2").position.y += 1000
		find_node_by_name(get_tree().get_root(), "Platform3").position.y += 1000
		$CollisionShape2D.queue_free()
		$Sprite.texture = load("res://assets/entity_sprites/enemy3.png")
	elif state == 2 or state == 3:
		find_node_by_name(get_tree().get_root(), "End_ui").visible = true
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
		dir *= -1
		body.die()

func _on_Wall_sensor_right_area_entered(area):
#	if area.is_in_group("ChangeDir"):
	dir = -1

func _on_Wall_sensor_left_area_entered(area):
#	if area.is_in_group("ChangeDir"):
	dir = 1
