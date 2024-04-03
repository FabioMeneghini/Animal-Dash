extends Particles2D

#onready var raycast=get_parent().get_node("RayCast2D")
#onready var ID=get_parent().get_parent().ID

#func _process(delta):
#	if(Input.is_action_pressed("fire"+str(ID))):
#		emitting=true
#		global_position.y=raycast.global_position.y
#		if(raycast.is_colliding()):
#			global_position.x=raycast.global_position.x+(raycast.get_collision_point().x-raycast.global_position.x)/2
#		else:
#			global_position.x=raycast.global_position.x+200
#	else:
#		emitting=false
