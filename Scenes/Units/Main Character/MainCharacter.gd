extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

const RUN_SPEED = 150.0
const WALK_SPEED = 50.0
const JUMP_VELOCITY = -325.0
const DOUBLE_JUMP_VELOCITY = -275
const AIR_CHANGE_DIRECTION_SPEED = 17.0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var audioplayer = AudioStreamPlayer.new()

var health = 100

var looking_left = true
var looking_right = false

@onready var sword_hurt_area = $Area2D/CollisionShape2D

@onready var jump_sound = $Jump/AudioStreamPlayer

@onready var audio_array_footsteps = [
	$Footsteps/AudioStreamPlayer,
	$Footsteps/AudioStreamPlayer2,
	$Footsteps/AudioStreamPlayer3,
	$Footsteps/AudioStreamPlayer4,
	$Footsteps/AudioStreamPlayer5,
	$Footsteps/AudioStreamPlayer6,
	$Footsteps/AudioStreamPlayer7,
	$Footsteps/AudioStreamPlayer8,
	$Footsteps/AudioStreamPlayer9,
	$Footsteps/AudioStreamPlayer10
]

@onready var audio_array_jumping = [
	$Jump/AudioStreamPlayer,
	$Jump/AudioStreamPlayer2,
	$Jump/AudioStreamPlayer3,
	$Jump/AudioStreamPlayer4,
	$Jump/AudioStreamPlayer5,
	$Jump/AudioStreamPlayer6
]

@onready var audio_array_slashes = [
	$Slashes/AudioStreamPlayer,
	$Slashes/AudioStreamPlayer2,
	$Slashes/AudioStreamPlayer3,
	$Slashes/AudioStreamPlayer4,
	$Slashes/AudioStreamPlayer5,
	$Slashes/AudioStreamPlayer6,
	$Slashes/AudioStreamPlayer7
]

enum {
	IDLE,
	JUMPING,
	DOUBLE_JUMPING,
	FALLING,
	GLIDING,
	LANDING,
	WALKING,
	RUNNING,
	CROUTCHING,
	CROUTCH_WALKING,
	SWORD_ATTACK,
	SWORD_STAB
}

var STATE = IDLE

var can_double_jump = false
var has_sword = false
var idx = 0
var can_swing = true
var current_interactable = null

func _ready():
	anim.flip_h = true
	sword_hurt_area.position.x *= -1
	sword_hurt_area.rotation *= -1

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")
	if direction > 0.05:
		direction = 1.0
	elif direction < -0.05:
		direction = -1.0
	else:
		direction = 0.0
	var croutch = Input.is_action_pressed("croutch")
	var jump = Input.is_action_just_pressed("jump")
	var run = true
	var swing = Input.is_action_just_pressed("run")
	
	if velocity.x > 0:
		if looking_left:
			looking_right = true
			looking_left = false
			anim.flip_h = false
			sword_hurt_area.position.x *= -1
			sword_hurt_area.rotation *= -1
	elif velocity.x < 0:
		if looking_right:
			looking_right = false
			looking_left = true
			anim.flip_h = true
			sword_hurt_area.position.x *= -1
			sword_hurt_area.rotation *= -1
	
	velocity.y += gravity * delta
	
	if swing and can_swing and has_sword:
		STATE = SWORD_ATTACK
		can_swing = false
		play_random_slash_sound()
	
	if STATE != SWORD_ATTACK:
		if is_on_floor():
			if !direction and !jump and !croutch:
				STATE = IDLE
			else:
				if direction and !jump and !croutch and !run:
					STATE = WALKING
				if direction and !jump and !croutch and run:
					STATE = RUNNING
				if jump:
					STATE = JUMPING
					play_random_jump_sound()
					if direction and !run:
						velocity.x = direction * WALK_SPEED
					elif direction and run:
						velocity.x = direction * RUN_SPEED
					velocity.y = JUMP_VELOCITY
					can_double_jump = true
				if direction and croutch:
					STATE = CROUTCH_WALKING
				if !direction and croutch:
					STATE = CROUTCHING
				
		if not is_on_floor():
			velocity.x = clamp(velocity.x + direction * WALK_SPEED * delta * AIR_CHANGE_DIRECTION_SPEED, -RUN_SPEED, RUN_SPEED)
			if STATE != DOUBLE_JUMPING or (STATE == DOUBLE_JUMPING and anim.frame >= 5):
				if velocity.y > 100.0:
					STATE = FALLING
				elif velocity.y < -50.0:
					STATE = JUMPING
				else:
					STATE = GLIDING
			if jump and can_double_jump:
				play_random_jump_sound()
				STATE = DOUBLE_JUMPING
				velocity.y = DOUBLE_JUMP_VELOCITY
				can_double_jump = false
			
		if current_interactable and Input.is_action_just_pressed("use"):
			current_interactable.use(self)
		
	match STATE:
		SWORD_ATTACK:
			anim.play("sword_attack1")
			if is_on_floor():
				velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
			if anim.frame == 4:
				sword_hurt_area.disabled = false
			if anim.frame == 5:
				STATE = IDLE
				can_swing = true
				sword_hurt_area.disabled = true
			
		IDLE:
			if has_sword:
				anim.play("sword_idle")
			else:
				anim.play("idle_standing")	
			velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
		LANDING:
			anim.play("land")
			velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
		JUMPING:
			if has_sword:
				anim.play("jumping_sword")
			else:
				anim.play("jumping")	
		DOUBLE_JUMPING:
			if has_sword:
				anim.play("sword_flip")
			else:
				anim.play("flip")	
		GLIDING:
			if has_sword:
				anim.play("gliding sword")
			else:
				anim.play("gliding")	
		FALLING:
			if has_sword:
				anim.play("falling_sword")
			else:
				anim.play("falling")	
		WALKING:
			anim.play("walk")
			velocity.x = direction * WALK_SPEED
		RUNNING:
			if anim.frame == 2 or anim.frame == 6:
				play_random_footstep()
			if has_sword:
				anim.play("sword_run")
			else:
				anim.play("run")	
			velocity.x = direction * RUN_SPEED
		CROUTCHING:
			anim.play("idle_croutching")
			velocity.x = move_toward(velocity.x, 0, RUN_SPEED)
		CROUTCH_WALKING:
			anim.play("croutch_walk")
			velocity.x = direction * WALK_SPEED

	move_and_slide()

func play_random_footstep():
	randomize()
	var stream = audio_array_footsteps[randi() % audio_array_footsteps.size()]
	stream.play()

func play_random_jump_sound():
	randomize()
	var stream = audio_array_jumping[randi() % audio_array_jumping.size()]
	stream.play()
	
func play_random_slash_sound():
	randomize()
	var stream = audio_array_slashes[randi() % audio_array_slashes.size()]
	stream.play()

func _on_area_2d_use_object_area_entered(area):
	var object = area.get_parent()
	if object.has_method("interactable"):
		if object.interactable():
			current_interactable = object
	
func _on_area_2d_use_object_area_exited(area):
	var object = area.get_parent()
	if object.has_method("interactable"):
		current_interactable = null

func loot_sword():
	has_sword = true

func hurt(value):
	health = clamp(health + value, 0, 100)

func _on_area_2d_area_entered(area):
	if area.get_parent().has_method("hurt"):
		area.get_parent().hurt(-50)
	print("asdf")
