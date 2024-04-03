extends Label

func _process(delta):
	text=get_parent().states_str[get_parent().state]
