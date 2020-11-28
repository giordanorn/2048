extends Control


func _ready():
	$Container/Content/Label.text = str(Global.score)


func _on_Board_onSlide():
	$Container/Content/Label.text = str(Global.score)
