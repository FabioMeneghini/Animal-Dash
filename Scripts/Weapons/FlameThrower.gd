extends "res://Scripts/Weapons/BaseWeapon.gd"

onready var map=get_parent().get_parent()
var animation_playing=false

func _ready():
	ammo_max=300.0
	ammo=300.0
	damage=0.5
	position_right=Vector2(30, -1)
	position_left=Vector2(30, 1)
	offset_right=Vector2(10, 0)
	offset_left=Vector2(10, 0)

func shoot():
	if(!animation_playing):
		frame=0
		animation_playing=true
	decrease_ammo(3)
	camera.shake(2.0, 1800.0, 4.2)
	var bullet1=preload("res://Scenes/Particles/FireParticle.tscn").instance()
	var bullet2=preload("res://Scenes/Particles/FireParticle.tscn").instance()
	var bullet3=preload("res://Scenes/Particles/FireParticle.tscn").instance()
	#var map=get_parent().get_parent()
	init_bullet(bullet1, 0)
	init_bullet(bullet2, -2)
	init_bullet(bullet3, 2)

func init_bullet(bullet, angle_offset):
	map.add_child(bullet)
	bullet.global_position=$Fire.global_position
	bullet.rotation_degrees=self.rotation_degrees+angle_offset
	bullet.damage=damage
	#bullet.set_collision_layer_bit(2, true) #3 è il layer dei proiettili dei giocatori
	#bullet.set_collision_mask_bit(1, true) #2 è il layer dei nemici
	if(Global.mode=="vs"):
		for i in range(8, 12):
			if(i-7!=ID):
				bullet.set_collision_mask_bit(i, true)

func _on_FlameThrower_animation_finished():
	animation_playing=false
