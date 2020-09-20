extends KinematicBody2D

const UP = Vector2(0, -1)
const GRAVITY = 20
export var ACCEL = 50
export var SPEED = 200
export var MAXSPEED = 500
export var JUMP_HEIGHT = -700

var motion = Vector2()
var hp = 3
export var inv_time = 1

func _ready():
	if get_tree().current_scene.name == "Level3" or get_tree().current_scene.name == "LevelBoss":
		$ParallaxBackground/Sprite.texture = load("res://assets/Backgrounds/dark.png")

func _physics_process(delta):
	if Input.is_action_pressed("ui_cancel"):
		get_tree().change_scene("res://scenes/Menu.tscn")
	motion.y += GRAVITY
	
	if Input.is_action_pressed("move_right"):
		motion.x = min(motion.x + ACCEL, MAXSPEED)
		$Sprite.flip_h = false
		$AnimationPlayer.play("run")
	elif Input.is_action_pressed("move_left"):
		motion.x = max(motion.x - ACCEL, -MAXSPEED)
		$Sprite.flip_h = true
		$AnimationPlayer.play("run")
	else:
		if is_on_floor():
			$AnimationPlayer.play("idle")
			motion.x = lerp(motion.x, 0, .2)
		else:
			motion.x = lerp(motion.x, 0, .15)
	
	if is_on_floor():
		if Input.is_action_pressed("jump"):
			$AudioJump.play()
			jump()
	else:
		$AnimationPlayer.play("jump")
	
	motion = move_and_slide(motion, UP)
	
	if inv_time > 0:
		inv_time -= delta

func jump():
	motion.y = JUMP_HEIGHT
	
func playHit():
	$AudioKill.play()

func playBreak():
	$AudioBlock.play()

func disableCamera():
	$Camera2D.current = false

func die(var def = false):
	if def:
		get_tree().reload_current_scene()
	elif inv_time <= 0:
		hp -= 1
		if hp == 0:
			get_tree().reload_current_scene()
		else:
			inv_time = 1
			$AudioHit.play()
			$Hearts.get_child($Hearts.get_child_count()-1).queue_free()