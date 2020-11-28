extends ColorRect


func _on_Start_button_up():
	get_tree().change_scene("res://Game.tscn")


func _on_Exit_button_up():
	get_tree().quit()
