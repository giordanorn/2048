extends Node2D


const BASE = [[0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0]]

var board:Array

func _ready() -> void:
	board = BASE
	spawn()
	print_board()


func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_left"):
		for y in range(0,4):
			for x in range(1,4):
				if board[y][x] > 0:
					calculate_and_move(x,y)
		spawn()
		print_board()
	elif Input.is_action_just_pressed("ui_down"):
		spawn()
		print_board()
	elif Input.is_action_just_pressed("ui_right"):
		spawn()
		print_board()
	elif Input.is_action_just_pressed("ui_up"):
		print_board()
		spawn()


func calculate_and_move(x:int, y:int) -> void:
	var distance = 0
	for offset in range(1, x + 1):
		if (board[y][x - offset] == 0):
			distance += 1
			if (distance == x):
				board[y][x-distance] = board[y][x]
				board[y][x] = 0
				break
			continue
		elif board[y][x - offset] == board[y][x]:
			distance += 1
			board[y][x-distance] = board[y][x] * 2
			board[y][x] = 0
			break
		elif distance > 0:
			board[y][x-distance] = board[y][x]
			board[y][x] = 0
			break
		else:
			break


func get_score() -> int:
	var sum:int = 0
	for line in board:
		for val in line:
			sum += val
	return sum


func spawn() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var x = rng.randi_range(0,3)
	var y = rng.randi_range(0,3)
	while (is_occupied(x,y)):
		x = rng.randi_range(0,3)
		y = rng.randi_range(0,3)
	var spawned_value = 2
	board[y][x] = spawned_value
	print ("Spawn: ", x, ",", y)


func is_occupied(x:int, y:int) -> bool:
	return board[y][x] > 0


func print_board() -> void:
	for line in board:
		print (line)
	print ("Score: ", get_score())
