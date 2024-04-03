extends "res://Scripts/Weapons/BaseWeapon.gd"

onready var line=$RayCast2D.get_node("Line2D")
onready var tween_width=$RayCast2D.get_node("TweenWidth")
onready var tween_length=$RayCast2D.get_node("TweenLength")

func _ready():
	ammo_max=3.0
	ammo=3.0
	damage=15
	position_right=Vector2(25, -2)
	position_left=Vector2(25, 2)
	offset_right=Vector2(10, 0)
	offset_left=Vector2(10, 0)
	if(Global.mode=="vs"):
		for i in range(8, 12):
			if(i-7!=ID):
				$RayCast2D.set_collision_mask_bit(i, true)

func shoot():
	decrease_ammo(1)
	camera.shake(5.0, 1800.0, 4.7)
	if($RayCast2D.is_colliding()):
		var collider=$RayCast2D.get_collider()
		if(collider.is_in_group("enemy")):
			collider.get_damage(damage, direction)
		elif(Global.mode=="vs" && collider.is_in_group("player")):
			collider.get_damage(damage, direction)
	$RayCast2D.appear_shoot()
