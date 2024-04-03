extends Node2D

onready var player=preload("res://Scenes/Characters/Shark.tscn").instance()

func _process(delta):
	if(Input.is_action_just_pressed("start2")):
		add_child(player)
