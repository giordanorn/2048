extends Control

export var empty_color:Color = Color(0,0,0)

export var fst_color:Color = Color(0,0,1)
export var snd_color:Color = Color(0,1,0)
export var trd_color:Color = Color(1,1,0)
export var fth_color:Color = Color(1,0,0)


func _ready():
	$Content/Label.text = ""
	$Background.color = empty_color


func set_value(new_value:int) -> void:
	if (new_value == 0):
		$Content/Label.text = ""
		$Background.color = empty_color
	else:
		$Content/Label.text = str(new_value)
		var n:int = floor(log(new_value) / log(2))
		
		var tones = 3
		var tone:float = (n - 1) % tones
		var tone_intensity = 0.2
		
		# Define a variante
		var variant = floor((n - 1) / tones)
		var color = get_color_by_variant(variant)
		
		# Define a entonação
		color.r = color.r / (tone + 1)
		color.g = color.g / (tone + 1)
		color.b = color.b / (tone + 1)
		
		$Background.color = color


func get_color_by_variant(variant:int) -> Color:
	if variant == 0:
		return fst_color
	elif variant == 1:
		return snd_color
	elif variant == 2:
		return trd_color
	elif variant == 3:
		return fth_color
	else:
		push_warning("variant > 4 or variant < 0")
		return empty_color
