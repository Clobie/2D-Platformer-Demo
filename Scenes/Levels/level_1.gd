extends Node2D

@onready var character = $MainCharacter
@onready var music_level = $LevelMusic
@onready var music_boss = $BossMusic

var music_toggle = 1

var checkpoint = 0

func _ready():
	pass

func _process(_delta):
	if music_toggle == 1 and character.position.y >= 680:
		music_toggle = 2
		music_boss.volume_db = -15.0
		music_boss.play()

	if music_toggle == 2 and character.position.y <= 625:
		music_toggle = 1
		music_level.volume_db = -10.0
		music_level.play()

	if music_toggle == 2 and music_level.playing:
		music_level.volume_db -= 0.15
		if music_level.volume_db <= -50:
			music_level.stop()

	if music_toggle == 1 and music_boss.playing:
		music_boss.volume_db -= 0.15
		if music_boss.volume_db <= -50:
			music_boss.stop()
