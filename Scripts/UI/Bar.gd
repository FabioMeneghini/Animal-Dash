extends Sprite

var NOISE_SHAKE_STRENGTH=0
var NOISE_SHAKE_SPEED=0
var SHAKE_DECAY_RATE=0
var noise=OpenSimplexNoise.new()
var noise_i=0.0

func _process(delta):
	NOISE_SHAKE_STRENGTH=lerp(NOISE_SHAKE_STRENGTH, 0, SHAKE_DECAY_RATE*delta)
	offset=get_noise_offset(delta)
	get_child(0).offset.x=get_noise_offset(delta).x+0.5
	get_child(0).offset.y=get_noise_offset(delta).y

func get_noise_offset(delta):
	noise_i+=delta*NOISE_SHAKE_SPEED
	return Vector2(
		noise.get_noise_2d(1, noise_i)*NOISE_SHAKE_STRENGTH,
		noise.get_noise_2d(100, noise_i)*NOISE_SHAKE_STRENGTH
	)

func shake(strength, speed, decay_rate):
	NOISE_SHAKE_STRENGTH=strength
	NOISE_SHAKE_SPEED=speed
	SHAKE_DECAY_RATE=decay_rate
