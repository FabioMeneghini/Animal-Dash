extends Particles2D

func _process(delta):
	if(Input.is_action_pressed("fire"+str(get_parent().ID))):
		emitting=true
	else:
		emitting=false
