extends Node

enum GameState { MENU, NEW_GAME, PLAYING, GAME_OVER }

const ENEMY_ROWS = 5
const ENEMY_COLS = 11
const ENEMY_SCENE = preload("res://scenes/enemy.tscn")

var enemy_speed = 50

var score = 0
var high_score = 0
var game_state: GameState
var enemies: Array[Enemy]
var changing_direction: bool

signal on_game_state_changed(GameState)

func _ready():
	new_game()
	
func new_game():
	setup_board(1)
	
func setup_board(page: int):
	var direction = (randi() & 2) - 1
	var step = 10
	var x = -100
	var y = -190 + step * page
	enemies.clear()
	for row in range(0, ENEMY_ROWS):
		for col in range(0, ENEMY_COLS):
			var enemy = ENEMY_SCENE.instantiate()
			add_child(enemy)
			enemy.direction = direction
			enemy.position = Vector3(x + 25 * col, 10, y + 25 * row)
			enemy.on_hit_wall.connect(change_enemy_direction)
			#enemy.on_destroyed.connect(func ():
					#var index = enemies.find(enemy)
					#enemies.pop_at(index)
					#)
				
			enemies.append(enemy)
		
func change_enemy_direction():
	if (changing_direction):
		return
		
	changing_direction = true
	for enemy in enemies:
		if enemy != null:
			enemy.direction *= -1
		
	get_tree().create_timer(1).timeout.connect(func ():
		changing_direction = false	
		)
	
func set_game_state(state: GameState):
	game_state = state
	on_game_state_changed.emit(game_state)
	
func add_score(inc: int):
	score += inc
