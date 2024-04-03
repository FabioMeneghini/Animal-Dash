extends Sprite

onready var outline=preload("res://Shaders/Outline.gdshader")

func show_outline(area):
	if(area.is_in_group("area_player")):
		get_parent().colliders+=1
		material.shader=outline
		#print(get_parent().colliders)

func remove_outline(area):
	if(area.is_in_group("area_player")):
		get_parent().colliders-=1
		if(get_parent().colliders<=0):
			material.shader=null
		#print(get_parent().colliders)
