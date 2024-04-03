extends AnimatedSprite

func _on_TimerButton_timeout():
	get_parent().get_node("SpriteButton").frame=0

func show_button(area):
	if(area.is_in_group("area_player")):
		visible=true

func hide_button(area):
	if(area.is_in_group("area_player")):
		if(get_parent().colliders<=0):
			visible=false
