extends "res://Scripts/Weapons/BaseWeapon.gd"

#onready var shoot_particles=preload("res://Scenes/Particles/AssaultRIfleShootParticles.tscn").instance()
var shoot_particles

func _ready():
	ammo_max=25.0
	ammo=25.0
	damage=2
	position_right=Vector2(25, -1)
	position_left=Vector2(25, 1)
	offset_right=Vector2(5, -1)
	offset_left=Vector2(5, 1)
	if(Global.mode=="vs"):
		for i in range(8, 12):
			if(i-7!=ID):
				$RayCast2D.set_collision_mask_bit(i, true)

func shoot():
	decrease_ammo(1)
	camera.shake(1.9, 1800.0, 4.7)
	$Fire.frame=0
	$Fire.visible=true
	if($RayCast2D.is_colliding()):
		var collider=$RayCast2D.get_collider()
		shoot_particles=load("res://Scenes/Particles/AssaultRIfleShootParticles.tscn").instance()
		add_child(shoot_particles)
		shoot_particles.global_position=$RayCast2D.get_collision_point()
		if(collider.is_in_group("enemy")):
			collider.get_damage(damage, direction)
		elif(Global.mode=="vs" && collider.is_in_group("player")):
			collider.get_damage(damage, direction)
