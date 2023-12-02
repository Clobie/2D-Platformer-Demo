extends CharacterBody2D

@onready var anim = $AnimatedSprite2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 100

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	anim.play("idle")

func _physics_process(delta):
	if health <= 0:
		if anim.animation == "death":
			if anim.frame == 7:
				self.call_deferred("queue_free")
		else:
			anim.play("death")
	if not is_on_floor():
		velocity.y += gravity * delta
	move_and_slide()
	
func hurt(value):
	health = clamp(health + value, 0, 100)
	print(health)

