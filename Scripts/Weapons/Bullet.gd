extends RigidBody2D

var damage
var speed=500
var angle_vector=Vector2()
var direction=1

func _physics_process(delta):
	#move_and_slide(Vector2(cos(deg2rad(rotation_degrees))*speed, sin(deg2rad(rotation_degrees))*speed))
	angle_vector=Vector2(cos(deg2rad(rotation_degrees))*speed, sin(deg2rad(rotation_degrees))*speed)
	if(atan2(angle_vector.x, angle_vector.y)>0):
		direction=1
	else:
		direction=-1
	apply_central_impulse(angle_vector)
	
func _on_Timer_timeout():
	queue_free()

func _on_Bullet_body_entered(body):
	if((Global.mode=="vs" && body.is_in_group("player")) || body.is_in_group("enemy")):
		body.get_damage(damage, direction)
	queue_free()
