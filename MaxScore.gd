extends Control


func _ready():
	$CenterContainer/VBoxContainer/Label.text = str(Global.max_score)


func _on_NewGame_button_up():
	if Global.score > Global.max_score:
		Global.max_score = Global.score
	
	$CenterContainer/VBoxContainer/Label.text = str(Global.max_score)
