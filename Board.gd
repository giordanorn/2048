extends Node


const BASE = [[0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0],
			  [0, 0, 0, 0]]

const BOARD_WIDTH  = 4
const BOARD_HEIGHT = 4

var board:Array

const tile_scene = preload("res://Square.tscn")
var graphical_nodes:Array = []


signal onSlide()


func _ready() -> void:
	initialize_board()
	initialize_grapical_board()
	
	spawn()
	update_graphical_board()


func _process(delta) -> void:
	if Global.game_over:
		if Global.score > Global.max_score:
			Global.max_score = Global.score
		get_tree().change_scene("res://GameOver.tscn")
		return
		
	if Input.is_action_just_pressed("ui_left"):
		for line in board:
			slide_line(line)
		complete_movement()
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
		complete_movement()
	elif Input.is_action_just_pressed("ui_right"):
		for line in board:
			line.invert()
			slide_line(line)
			line.invert()
		complete_movement()
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
		complete_movement()


func complete_movement() -> void:
	spawn()
	update_graphical_board()
	update_score()
	emit_signal("onSlide")


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


func update_score() -> void:
	Global.score = get_score()


func spawn() -> void:
	if is_board_full():
		var game_over = true
			
		# Checagem vertical
		for i in range(1, BOARD_WIDTH):
			for j in range(0, BOARD_HEIGHT):
				if board[i-1][j] == board[i][j]:
					game_over = false
					break
					
		# Checagem horizontal
		for i in range(0, BOARD_WIDTH):
			for j in range(1, BOARD_HEIGHT):
				if board[i][j - 1] == board[i][j]:
					game_over = false
					break
					
		if (game_over):
			Global.game_over = true
	else:
		var rng = RandomNumberGenerator.new()
		rng.randomize()
		var pos = Vector2(rng.randi_range(0,3), rng.randi_range(0,3))
		var tries = [pos]
		while (is_occupied(pos)):
			while tries.has(pos):
				pos = Vector2(rng.randi_range(0,3), rng.randi_range(0,3))
			tries.push_back(pos)
		var spawned_value = 2
		replace(pos, spawned_value)


func is_board_full() -> bool:
	for line in board:
		for number in line:
			if number == 0:
				return false
	return true


func is_occupied(pos:Vector2) -> bool:
	return get_element(pos) > 0


#
# Inicializa o board interno
#
func initialize_board() -> void:
	board = BASE.duplicate(true)


#
# Inicializa o board a ser exibido
#
func initialize_grapical_board() -> void:
	for n in range (0, BOARD_WIDTH * BOARD_HEIGHT):
		var node = tile_scene.instance()
		node.set_value(0)
		graphical_nodes.push_front(node)
		$Container/Grid.add_child(node)


#
# Atualiza o board a ser exibido
#
func update_graphical_board() -> void:
	for i in range(0, BOARD_WIDTH * BOARD_HEIGHT):
		graphical_nodes[BOARD_WIDTH * BOARD_HEIGHT - (i + 1)].set_value(board[floor(i / BOARD_WIDTH)][i % BOARD_HEIGHT])


func _on_NewGame_button_up():
	initialize_board()
	spawn()
	update_graphical_board()
	Global.game_over = false
