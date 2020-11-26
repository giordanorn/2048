extends Node2D


const BASE = [[0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0]]

const BOARD_WIDTH  = 4
const BOARD_HEIGHT = 4

var board:Array


func _ready() -> void:
	board = BASE
	spawn()
	print_board()


func _process(delta) -> void:
	if Input.is_action_just_pressed("ui_left"):
		for line in board:
			slide_line(line)
		spawn()
		print_board()
	elif Input.is_action_just_pressed("ui_up"):
		var aux_board = [[],[],[],[]]
		for col in range(0, 4):
			var line = []
			for row in range(0, 4):
				line.push_back(board[row][col])
			slide_line(line)
			aux_board[col] = line
		
		for col in range(0, 4):
			for row in range(0, 4):
				board[col][row] = aux_board[row][col]
		spawn()
		print_board()
	elif Input.is_action_just_pressed("ui_right"):
		for line in board:
			line.invert()
			slide_line(line)
			line.invert()
		spawn()
		print_board()
	elif Input.is_action_just_pressed("ui_down"):
		var aux_board = [[],[],[],[]]
		for col in range(0, 4):
			var line = []
			for row in range(0, 4):
				line.push_back(board[row][col])
			line.invert()
			slide_line(line)
			line.invert()
			aux_board[col] = line
		
		for col in range(0, 4):
			for row in range(0, 4):
				board[col][row] = aux_board[row][col]
		spawn()
		print_board()
		pass


func get_element(pos:Vector2) -> int:
	return board[pos.x][pos.y]


func set_element(pos:Vector2, val:int) -> void:
	board[pos.x][pos.y] = val


#
# Realiza o slide para a esquerda no array
#
func slide_line(line:Array) -> void:
	# Exemplos:
	# [4,2,2,0] -> [4,4,0,0]
	# [2,0,2,0] -> [4,0,0,0]
	
	var base = 0
	
	
	if (line[0] > 0 && line[1] > 0 && line[2] > 0 && line[0] != line[1] + line[2]):
		base = 1
		if (line[0] == line[1]):
			base = 0
	
	for n in range(1,4):
		if line[n] == 0:
			continue
		var i    = n - 1
		while base <= i:
			if (line[i] == 0):
				line[i]     = line[i + 1]
				line[i + 1] = 0
			elif (line[i] == line[i + 1]):
				line[i]     = line[i] + line[i + 1]
				line[i + 1] = 0
				base        = base + 1
			else:
				# Caso q os elementos são diferentes, não faz nada
				pass
			i = i - 1


func is_on_border(element:Vector2, direction:Vector2) -> bool:
	if direction == Vector2.UP:
		return element.y == 0
	elif direction == Vector2.DOWN:
		return element.y == BOARD_HEIGHT - 1
	elif direction == Vector2.LEFT:
		return element.x == 0
	elif direction == Vector2.RIGHT:
		return element.x == BOARD_WIDTH - 1
	else:
		push_warning("Unknown direction")
		return false


func is_equal(el1, el2) -> bool:
	return get_element(el1) == get_element(el2)


func replace(pos:Vector2, val:int) -> void:
	set_element(pos, val)


func get_score() -> int:
	var sum:int = 0
	for line in board:
		for val in line:
			sum += val
	return sum


func spawn() -> void:
	var rng = RandomNumberGenerator.new()
	rng.randomize()
	var pos = Vector2(rng.randi_range(0,3), rng.randi_range(0,3))
	while (is_occupied(pos)):
		pos = Vector2(rng.randi_range(0,3), rng.randi_range(0,3))
	var spawned_value = 2
	replace(pos, spawned_value)


func is_occupied(pos:Vector2) -> bool:
	return get_element(pos) > 0


func print_board() -> void:
	print ("Board:")
	for line in board:
		print (line)
	print ("Score: ", get_score())

