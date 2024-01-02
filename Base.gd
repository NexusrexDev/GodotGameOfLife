extends Node2D

# Constants
const WIDTH: int = 80
const HEIGHT: int = 60
const RULES: Array = [
	[0, 0, 0, 1, 0, 0, 0, 0, 0], 
	[0, 0, 1, 1, 0, 0, 0, 0, 0]
]

# Variables
var cells: Array
var playing: bool = false
onready var tilemap: TileMap = $TileMap

# Functions
func _ready():
	randomize()
	cells = []
	for i in range(WIDTH):
		cells.append([])
		for _j in range(HEIGHT):
			cells[i].append(0)

func _process(_delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !playing:
			start()

	if Input.is_action_just_pressed("ui_reset"):
		if playing:
			reset()

# Starts the game
func start() -> void:
	randomizeCells()
	playing = true
	while(playing):
		play()
		yield(get_tree().create_timer(0.1), "timeout")

# Randomizes the cells and sets the tilemap
func reset() -> void:
	playing = false
	for i in range(WIDTH):
		for j in range(HEIGHT):
			cells[i][j] = 0
	setCells()

# Randomizes the cells
func randomizeCells() -> void:
	for i in range(WIDTH):
		for j in range(HEIGHT):
			cells[i][j] = randi() % 2

# Sets the cells in the tilemap
func setCells() -> void:
	for x in range(WIDTH):
		for y in range(HEIGHT):
			tilemap.set_cell(x, y, cells[x][y] - 1)

# Returns the number of neighbors of a cell
func countNeighbors(x: int, y: int) -> int:
	var count: int = 0
	var x1: int = x - 1 if (x > 0) else 0
	var x2: int = x + 2 if (x < WIDTH - 1) else WIDTH
	var y1: int = y - 1 if (y > 0) else 0
	var y2: int = y + 2 if (y < HEIGHT - 1) else HEIGHT

	for i in range(x1, x2):
		for j in range(y1, y2):
			if (i == x and j == y):
				continue
			count += 1 if cells[i][j] == 1 else 0
	
	return count

# Plays the game/simulation
func play() -> void:
	var newCells: Array = []
	for i in range(WIDTH):
		newCells.append([])
		for _j in range(HEIGHT):
			newCells[i].append(0)
	for i in range(WIDTH):
		for j in range(HEIGHT):
			newCells[i][j] = RULES[cells[i][j]][countNeighbors(i, j)]
	cells = newCells
	setCells()
