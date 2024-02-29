class_name State
extends Node

@export var animation_name: String

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")

var parent: CharacterBody2D

func enter() -> void:
	parent.animations.play(animation_name)

func exit() -> void:
	pass

func process_physics(delta: float) -> State:
	return null

func process_input(event: InputEvent) -> State:
	return null

func process_frame(delta: float) -> State:
	return null

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass
