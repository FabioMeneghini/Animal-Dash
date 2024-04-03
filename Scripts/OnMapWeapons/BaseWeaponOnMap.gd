extends Area2D

var c=0
var pos=Vector2()
var type
var colliders=0

func _ready():
	pos=$SpriteGunOnMap.position

func _on_TimerFloat_timeout():
	c=(c+1)%2
	if(c==1):
		$TweenFloat.interpolate_property($SpriteGunOnMap, "position", pos, Vector2(pos.x, pos.y-5), 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$TweenFloat.start()
	else:
		$TweenFloat.interpolate_property($SpriteGunOnMap, "position", Vector2(pos.x, pos.y-5), pos, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$TweenFloat.start()
