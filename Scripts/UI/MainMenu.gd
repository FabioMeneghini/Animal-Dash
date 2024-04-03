extends Control

onready var outline=preload("res://Shaders/Outline.gdshader")
const entries=["Adventure", "Versus", "Settings", "Exit"]
var i=0
var prev_i=0

func _process(delta):
	if(Input.is_action_just_pressed("ui_up1")):
		prev_i=i
		i=(i-1)%4
		update_outline()
	elif(Input.is_action_just_pressed("ui_down1")):
		prev_i=i
		i=(i+1)%4
		update_outline()

func update_outline():
	get_node("VBoxContainer/"+entries[prev_i]).material.shader=null
	get_node("VBoxContainer/"+entries[i]).material.shader=outline
