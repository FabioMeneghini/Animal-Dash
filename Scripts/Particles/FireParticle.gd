extends RigidBody2D

var damage
var speed=120
var angle_vector=Vector2()
var direction=0
var can_damage=true
var rng = RandomNumberGenerator.new()
var rand
onready var color=$AnimatedSprite.modulate

func _ready():
	$AnimatedSprite.playing=true
	rng.randomize()
	rand=rng.randf_range(-3.0, 3.0)
	$TweenScale.interpolate_property($AnimatedSprite, "scale", Vector2(1.0, 1.0), Vector2(2.0, 2.0), 1.5)
	$TweenScale.start()

func _physics_process(delta):
	#move_and_slide(Vector2(cos(deg2rad(rotation_degrees))*speed, sin(deg2rad(rotation_degrees))*speed))
	rotation_degrees+=rand
	angle_vector=Vector2(cos(deg2rad(rotation_degrees))*speed, sin(deg2rad(rotation_degrees))*speed)
	apply_central_impulse(angle_vector)
	
func _on_Timer_timeout():
	queue_free()

func _on_FireParticle_body_entered(body):
	if(can_damage):
		if((Global.mode=="vs" && body.is_in_group("player")) || body.is_in_group("enemy")):
			body.get_damage(damage, direction)
			can_damage=false
			$Cooldown.start()

func _on_Cooldown_timeout():
	can_damage=true

func _on_Vanish_timeout():
	$TweenColor.interpolate_property($AnimatedSprite, "modulate", color, Color(10, 0, 0, 0), 0.5)
	$TweenColor.start()
