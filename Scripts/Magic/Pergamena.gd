extends Sprite

var prev_has_weapon=false

func load_player_info(id):
	if(id==1):
		Global.p1_current_hp=get_parent().life
		Global.p1_max_hp=get_parent().life_max
		Global.p1_type=get_parent().type
	elif(id==2):
		Global.p2_current_hp=get_parent().life
		Global.p2_max_hp=get_parent().life_max
		Global.p2_type=get_parent().type

func cast(magic_name):
	if(magic_name=="Summon Bird"):
		load_player_info(get_parent().ID)
		var bird = load("res://Scenes/Characters/Bird.tscn").instance()
		bird.set_name("Bird_"+str(get_parent().ID))
		get_parent().get_parent().add_child(bird)
		bird.global_position=get_parent().global_position
		bird.init("Bird", get_parent().ID)
		if(get_parent().facing<0):
			bird.get_node("AnimatedSprite").flip_h=false
		else:
			bird.get_node("AnimatedSprite").flip_h=true
		get_parent().queue_free()

func _process(delta):
	if(get_parent().type=="Bird" || get_parent().state==get_parent().States.FLY):
		return
	if(get_parent().facing<0):
		flip_h=false
		$Particles.position=Vector2(-31, -1)
	elif(get_parent().facing>0):
		flip_h=true
		$Particles.position=Vector2(31, -1)
	
	if(Input.is_action_just_pressed("magic"+str(get_parent().ID))):
		prev_has_weapon=get_parent().has_weapon
		visible=true
		$Particles.emitting=true
		get_parent().has_weapon=true
		for node in get_parent().get_children():
			if(node.is_in_group("weapon")):
				if(Input.is_action_pressed("fire"+str(get_parent().ID))):
					visible=false
					$Particles.emitting=false
					get_parent().has_weapon=false
				else:
					node.visible=false
					node.get_node("Cooldown").stop()
					node.can_shoot=false
	elif(Input.is_action_just_released("magic"+str(get_parent().ID))):
		visible=false
		$Particles.emitting=false
		get_parent().has_weapon=prev_has_weapon
		for node in get_parent().get_children():
			if(node.is_in_group("weapon")):
				node.visible=true
				node.can_shoot=true
				#node.get_node("Cooldown").start()
	if(Input.is_action_pressed("magic"+str(get_parent().ID)) && Input.is_action_just_pressed("ui_up"+str(get_parent().ID)) && get_parent().magic_array.size()>=1):
			cast(get_parent().magic_array[0])
