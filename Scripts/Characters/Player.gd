extends KinematicBody2D

onready var life_bar=get_node("UI/LifeBar")
onready var life_node=get_node("UI/LifeBar/Life")
onready var map=get_parent()

var life_max=30.0
var life=30.0
var magic_array=["Summon Bird"]
var is_life_bar_shaking=false
var jump_power=-550
var speed=200
var ID=0
var type

#var weapon_pos_left=Vector2()
#var weapon_pos_right=Vector2()
enum States {IDLE, RUN, JUMP, FALL, FLY}
const states_str=["IDLE", "RUN", "JUMP", "FALL", "FLY"]
var state=States.FALL
const GRAVITY_LIMIT=500
const GRAVITY_LIMIT_FLYING=300
var gravity=2300
var velocity=Vector2()
var impulse_velocity=Vector2(0, 0)
var has_weapon=false
var can_fly=false
var selected_weapon=[]
var facing=-1
var prev_facing=-1


func _physics_process(delta):
	get_velocity_x()
	get_impulse_velocity_x(delta)
	velocity.x+=impulse_velocity.x
	
	if(!can_fly):
		gravity=2300
		if(!selected_weapon.empty() && Input.is_action_just_pressed("collect"+str(ID))):
			collect_weapon()
		
		if(has_weapon):
			facing=Input.get_action_strength("aim_right"+str(ID))-Input.get_action_strength("aim_left"+str(ID))
			if(facing<0):
				$AnimatedSprite.flip_h=false
			elif(facing>0):
				$AnimatedSprite.flip_h=true
			else:
				facing=prev_facing
			prev_facing=facing
		
		if(state==States.FALL):
			fall(delta)
		elif(state==States.JUMP):
			jump(1.0)
		elif(state==States.RUN):
			run()
		else:
			idle()
	else:
		if(state==States.FLY):
			fly(delta)
		elif(state==States.JUMP):
			if(type=="Bird"):
				jump(0.6)
			else:
				jump(1.0)
		elif(state==States.RUN):
			run()
		else:
			idle()
		if((Input.is_action_just_pressed("jump"+str(ID)) && gravity>0) || (Input.is_action_just_released("jump"+str(ID)) && gravity<0)):
			gravity=gravity*-1
		
	move_and_slide(velocity, Vector2(0, -1))

func init(type, id): #se id==-1 allora (ri)calcola l'id con il for sotto, altrimenti tieni quello passato come parametro
	if(id==-1):
		for node in map.get_children():
			if(node.is_in_group("player")):
				ID+=1
	else:
		ID=id
	if(type=="Bird"):
		can_fly=true
		state=States.FLY
		gravity=1900
	else:
		$AnimatedSprite.frames=load("res://SpriteFrames/"+str(type)+str(ID)+".tres")
	for i in range(1, 32):
		set_collision_layer_bit(i, false)
	set_collision_layer_bit(ID+7, true) #9, 10, 11, 12 sono i layer dei giocatori in vs mode
	$TweenSize.interpolate_property($AnimatedSprite, "scale", Vector2(0.3, 0.3), Vector2(1, 1), 0.5, Tween.TRANS_ELASTIC)
	$TweenSize.start()

func idle():
	$AnimatedSprite.animation="idle"
	if(can_fly):
		if(type=="Bird"):
			$Particles2D.emitting=false
		if(!($RayCastDownLeft.is_colliding() || $RayCastDownRight.is_colliding())):
			state=States.FLY
		elif(Input.is_action_pressed("jump"+str(ID))):
			state=States.JUMP
		elif(Input.is_action_pressed("move_left"+str(ID)) || Input.is_action_pressed("move_right"+str(ID))):
			state=States.RUN
	else:
		if(!($RayCastDownLeft.is_colliding() || $RayCastDownRight.is_colliding())):
			state=States.FALL
		elif(Input.is_action_pressed("jump"+str(ID))):
			state=States.JUMP
		elif(Input.is_action_pressed("move_left"+str(ID)) || Input.is_action_pressed("move_right"+str(ID))):
			state=States.RUN

func run():
	$AnimatedSprite.animation="run"
	if(velocity.x==0):
		state=States.IDLE
	elif(Input.is_action_pressed("jump"+str(ID))):
		state=States.JUMP
	if(!($RayCastDownLeft.is_colliding() || $RayCastDownRight.is_colliding())):
		state=States.FALL

func jump(multiplier):
	$AnimatedSprite.animation="jump"
	velocity.y=float(jump_power)*multiplier
	state=States.FALL

func fly(delta):
	if(!can_fly):
		return
	$AnimatedSprite.animation="fly"
	if(type=="Bird"):
		$Particles2D.emitting=true
	if(gravity>0 && ($RayCastDownLeft.is_colliding() || $RayCastDownRight.is_colliding()) && !Input.is_action_pressed("jump"+str(ID))):
		velocity.y=0
		state=States.IDLE
	elif(gravity<0 && ($RayCastUpLeft.is_colliding() || $RayCastUpRight.is_colliding()) && Input.is_action_pressed("jump"+str(ID))):
		velocity.y=0
	elif((gravity>0 && velocity.y<GRAVITY_LIMIT_FLYING) || gravity<0 && velocity.y>GRAVITY_LIMIT_FLYING*-1):
		velocity.y+=gravity*delta

func fall(delta):
	if(can_fly):
		state=States.FLY
	$AnimatedSprite.animation="jump"
	if(velocity.y<GRAVITY_LIMIT):
		velocity.y+=gravity*delta
	if($RayCastDownLeft.is_colliding() || $RayCastDownRight.is_colliding()):
		velocity.y=0
		state=States.IDLE

func get_velocity_x():
	velocity.x=(Input.get_action_strength("move_right"+str(ID))-Input.get_action_strength("move_left"+str(ID)))*speed
	if(!has_weapon):
		facing=velocity.x
		if(facing==0):
			facing=prev_facing
		prev_facing=facing
		if(velocity.x>0):
			$AnimatedSprite.flip_h=true
		elif(velocity.x<0):
			$AnimatedSprite.flip_h=false

func get_impulse_velocity_x(delta):
	if(impulse_velocity.x==0):
		return
	elif(impulse_velocity.x>0):
		if(impulse_velocity.x<gravity*delta):
			impulse_velocity.x=0
		else:
			impulse_velocity.x-=gravity*delta
	else:
		if(impulse_velocity.x>-1*gravity*delta):
			impulse_velocity.x=0
		else:
			impulse_velocity.x+=gravity*delta

func collect_weapon():
	if(Input.is_action_pressed("magic"+str(ID))):
		return
	if(has_weapon):
		for child in get_children():
			if(child.is_in_group("weapon")):
				child.queue_free()
				break
	has_weapon=true
	#var weapon=selected_weapon.pop_back()
	var weapon=selected_weapon[0]
	var weapon_type=get_parent().get_node(weapon).type
	var weapon_instance=load("res://Scenes/Weapons/"+str(weapon_type)+".tscn").instance()
	add_child(weapon_instance)
	weapon_instance.position=$WeaponPosition.position
	get_parent().get_node(weapon).queue_free()

func get_damage(damage, direction):
	if(type=="Bird"):
		end()
	else:
		life-=damage
		$TweenColor.interpolate_property($AnimatedSprite, "modulate", Color.red, Color.white, 0.12, Tween.TRANS_LINEAR, Tween.EASE_OUT)
		$TweenColor.start()
		if(direction!=0):
			apply_impulse(damage, direction)
		if(life<=0):
			life_node.scale.x=0
			die()
		else:
			life_node.scale.x=life/life_max*32
			if(!is_life_bar_shaking && life/life_max<=0.1):
				life_bar.shake(1.5, 500.0, 0.0)
				is_life_bar_shaking=true

func die():
	life_bar.shake(0.0, 0.0, 0.0)
	is_life_bar_shaking=false
	print("MORTO") #TODO: animazione morte

func heal(_amount):
	pass

func end():
	var player
	var type
	if(ID==1):
		player = load("res://Scenes/Characters/"+Global.p1_type+".tscn").instance()
		player.set_name(Global.p1_type+"_"+str(ID))
		player.life=Global.p1_current_hp
		player.life_max=Global.p1_max_hp
		get_parent().add_child(player)
		type=Global.p1_type
	elif(ID==2):
		player = load("res://Scenes/Characters/"+Global.p2_type+".tscn").instance()
		player.set_name(Global.p2_type+"_"+str(ID))
		player.life=Global.p2_current_hp
		player.life_max=Global.p2_max_hp
		get_parent().add_child(player)
		type=Global.p2_type
	player.global_position=global_position
	player.init(type, ID)
	if(facing<0):
		player.get_node("AnimatedSprite").flip_h=false
	else:
		player.get_node("AnimatedSprite").flip_h=true
	queue_free()

func apply_impulse(damage, direction):
	impulse_velocity.x+=damage*40*direction
	velocity.y+=(float(damage)/16.0)*float(jump_power)

func _on_Area2D_area_entered(area):
	if(area.is_in_group("weapon")):
		selected_weapon.push_back(area.name)
		#print(selected_weapon)
	elif(area.is_in_group("power_up")):
		pass

func _on_Area2D_area_exited(area):
	var at=-1
	if(area.is_in_group("weapon")):
		for weapon in selected_weapon:
			at+=1
			if(weapon==area.name):
				break
		selected_weapon.remove(at)
		#print(selected_weapon)
