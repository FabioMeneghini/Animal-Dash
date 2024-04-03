extends AnimatedSprite

var ammo_max
var ammo
var damage

onready var ammo_bar=get_parent().get_node("UI/AmmoBar")
onready var ammo_node=get_parent().get_node("UI/AmmoBar/Ammo")
onready var camera=get_parent().get_parent().get_node("Camera2D")
onready var ID=get_parent().ID
var is_shooting=false
var can_shoot=true
var can_play_out_of_ammo=true
var dir_x
var dir_y
var prev_flip=false
var first_time=true
var position_right=Vector2(15, -2)
var position_left=Vector2(15, 2)
var offset_right=Vector2(5, -1)
var offset_left=Vector2(5, 1)
var direction=1

func _ready():
	var player=get_parent()
	dir_x=player.facing
	ammo_node.scale.x=32

func _process(delta):
	if(Input.is_action_pressed("fire"+str(ID)) && can_shoot):
		if(ammo>0):
			is_shooting=true
			shoot()
			$Sound.play()
			can_shoot=false
			$Cooldown.start()
		elif(can_play_out_of_ammo):
			is_shooting=false
			can_play_out_of_ammo=false
			ammo_bar.shake(2.3, 1800.0, 4.2)
			$OutOfAmmo.play()
			$CooldownOutOfAmmo.start()
	else:
		is_shooting=false
	
	if(!first_time):
		dir_x=Input.get_action_strength("aim_right"+str(ID))-Input.get_action_strength("aim_left"+str(ID))
	else:
		first_time=false
	dir_y=Input.get_action_strength("aim_down"+str(ID))-Input.get_action_strength("aim_up"+str(ID))
	
	if(dir_x>0):
		direction=1
		flip_v=false
		$Fire.flip_v=false
		$Fire.position=position_right
		$Particles.position=position_right
		$Fire.offset=offset_right
		$RayCast2D.position=position_right
	elif(dir_x<0):
		direction=-1
		flip_v=true
		$Fire.flip_v=true
		$Fire.position=position_left
		$Particles.position=position_left
		$Fire.offset=offset_left
		$RayCast2D.position=position_left
	else:
		flip_v=prev_flip
	prev_flip=flip_v
	
	if(dir_x!=0 || dir_y!=0):
		rotation_degrees=rad2deg(atan2(dir_y, dir_x))

func shoot():
	pass

func decrease_ammo(amount):
	ammo-=amount
	if(ammo<=0):
		ammo_node.scale.x=0
		discard_weapon()
	else:
		ammo_node.scale.x=ammo/ammo_max*32

func discard_weapon():
	pass

func _on_Fire_animation_finished():
	$Fire.visible=false

func _on_Cooldown_timeout():
	can_shoot=true

func _on_CooldownOutOfAmmo_timeout():
	can_play_out_of_ammo=true
