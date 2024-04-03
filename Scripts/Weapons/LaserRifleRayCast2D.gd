extends RayCast2D

onready var cast_point=Vector2.ZERO
var particles_amount_reduced=false
var is_shooting=false

func _physics_process(delta):
	force_raycast_update()
	
	if(Input.is_action_just_pressed("secondary_fire"+str(get_parent().ID))):
		appear()
	
	if(Input.is_action_pressed("secondary_fire"+str(get_parent().ID)) || is_shooting):
		if(get_parent().ammo>0):
			if(cast_point.length()<=120 && !particles_amount_reduced):
				particles_amount_reduced=true
				$BeamParticles.amount=40
			elif(cast_point.length()>120 && particles_amount_reduced):
				particles_amount_reduced=false
				$BeamParticles.amount=160
		elif(!is_shooting):
			$BeamParticles.emitting=false
		
		if(is_colliding()):
			$CollisionParticles.emitting=true
			cast_point=to_local(get_collision_point())
			$CollisionParticles.global_rotation=get_collision_normal().angle()
			$CollisionParticles.position=cast_point
			if(is_shooting && !$ShootCollisionParticles.emitting):
				$ShootCollisionParticles.position=cast_point
				$ShootCollisionParticles.emitting=true
		else:
			$CollisionParticles.emitting=false
			cast_point=Vector2(400, 0)
	else:
		$CollisionParticles.emitting=false
		if(Input.is_action_just_released("secondary_fire"+str(get_parent().ID))):
			disappear()
	
	$Line2D.points[1]=cast_point
	$BeamParticles.position=cast_point*0.5
	$BeamParticles.process_material.emission_box_extents.x=cast_point.length()*0.5

func appear():
	$CastingParticles.emitting=true
	if(get_parent().ammo>0):
		$BeamParticles.emitting=true
	$TweenWidth.interpolate_property($Line2D, "width", 0.0, 2.5, 0.1)
	$TweenWidth.start()

func appear_shoot():
	var is_aiming=false
	is_shooting=true
	$CastingParticles.emitting=true
	$BeamParticles.emitting=true
	
	$TweenWidth.interpolate_property($Line2D, "width", 0.0, 15.0, 0.04)
	$TweenWidth.start()
	yield(get_tree().create_timer(0.04), "timeout")
	if(Input.is_action_pressed("secondary_fire"+str(get_parent().ID))):
		is_aiming=true
		$TweenWidth.interpolate_property($Line2D, "width", 15.0, 2.0, 0.3)
	else:
		$TweenWidth.interpolate_property($Line2D, "width", 15.0, 0.0, 0.3)
		is_aiming=false
	$TweenWidth.start()
	yield(get_tree().create_timer(0.3), "timeout")
	
	if(!is_aiming):
		$CastingParticles.emitting=false
		$BeamParticles.emitting=false
	is_shooting=false

func disappear():
	$CastingParticles.emitting=false
	$BeamParticles.emitting=false
	$CollisionParticles.emitting=false
	$TweenWidth.interpolate_property($Line2D, "width", 2.5, 0.0, 0.1)
	$TweenWidth.start()
	yield(get_tree().create_timer(0.1), "timeout")
	cast_point=Vector2.ZERO
