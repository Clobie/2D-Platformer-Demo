extends CharacterBody2D

var gravity = 0.0

@onready var anim = $AnimatedSprite2D

func _ready():
	anim.play("idle")
	scale.x = -1

func _physics_process(delta):
	move_and_slide()

func flip_right():
	scale.x = 1

func flip_left():
	scale.x = -1
