extends Label

var sec=10
var dec=0

func _on_Timer_timeout():
	if(dec==0):
		dec=9
		sec-=1
	else:
		dec-=1
	if(sec<0):
		get_parent().end()
	elif(sec<3):
		set("custom_colors/font_color", Color(1.0, 0.25, 0.0, 1.0))
	text=str(sec)+","+str(dec)
