extends Control


func _ready():
	$Container/Content/Label.text = str(0)


func _on_Board_onSlide():
	$Container/Content/Label.text = str(Global.score)
