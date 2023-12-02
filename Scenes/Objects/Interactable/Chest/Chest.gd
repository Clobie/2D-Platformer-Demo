extends StaticBody2D

@onready var anim = $AnimatedSprite2D
@onready var sound = $AudioStreamPlayer

var used = false

func _ready():
	anim.play("closed")
	
func interactable():
	return !used

func use(user: CharacterBody2D):
	used = true
	sound.play()
	anim.play("open")
	if user.has_method("loot_sword"):
		user.loot_sword()
