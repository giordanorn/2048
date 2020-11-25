extends Node2D


const BASE = [[0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0]]

var board:Array

func _ready() -> void:
	board = BASE
	print(board)


func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_left"):
		spawn()
	elif Input.is_action_just_pressed("ui_down"):
		spawn()
	elif Input.is_action_just_pressed("ui_right"):
		spawn()
	elif Input.is_action_just_pressed("ui_up"):
		spawn()


func get_score() -> int:
	var sum:int = 0
	for line in board:
		for val in board:
			sum += val
	return sum


func spawn() -> void:
	var rng = RandomNumberGenerator.new()
	var x = rng.randi_range(0,3)
	var y = rng.randi_range(0,3)
	while (is_occupied(x,y)):
		x = rng.randi_range(0,3)
		y = rng.randi_range(0,3)
	var spawned_value = rng.randi_range(1,2) * 2
	board[x][y] = spawned_value

func is_occupied(x:int, y:int) -> bool:
	return board[x][y] > 0
