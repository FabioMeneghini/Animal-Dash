extends "res://Scripts/Weapons/BaseWeapon.gd"

onready var map=get_parent().get_parent()

func _ready():
	ammo_max=10.0
	ammo=10.0
	damage=4
	position_right=Vector2(15, -2)
	position_left=Vector2(15, 2)
	offset_right=Vector2(5, -1)
	offset_left=Vector2(5, 1)

func shoot():
	decrease_ammo(1)
	camera.shake(2.3, 1800.0, 4.2)
	$Fire.frame=0
	$Fire.visible=true
	var bullet=preload("res://Scenes/Weapons/Bullet.tscn").instance()
	#var map=get_parent().get_parent()
	map.add_child(bullet)
	bullet.global_position=$Fire.global_position
	bullet.rotation_degrees=self.rotation_degrees
	bullet.get_node("Sprite").flip_v=self.flip_v
	bullet.damage=damage
	#bullet.set_collision_layer_bit(2, true) #3 è il layer dei proiettili dei giocatori
	#bullet.set_collision_mask_bit(1, true) #2 è il layer dei nemici
	if(Global.mode=="vs"):
		for i in range(8, 12):
			if(i-7!=ID):
				bullet.set_collision_mask_bit(i, true)
