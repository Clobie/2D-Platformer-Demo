extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@onready var sound_opening = $AudioStreamPlayer
@onready var sound_closing = $AudioStreamPlayer2

@export var destination : StaticBody2D

var open = false

func _ready():
	anim.play("closed")
	
func interactable():
	return true

func use(who: CharacterBody2D):
	if open:
		open = false
		sound_closing.play()
		anim.play("closed")
		who.position = destination.position
	if !open:
		open = true
		sound_opening.play()
		anim.play("open")
