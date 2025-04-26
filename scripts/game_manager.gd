extends Node
class_name GameManagerGlobal

enum GameState { MENU, NEW_GAME, PLAYING, GAME_OVER }

const ENEMY_ROWS = 5
const ENEMY_COLS = 11
const ENEMY_SCENE = preload("res://scenes/enemy.tscn")
const ENEMY_SPEED_STEP = 2
const ENEMY_SPEED_INIT = 200#50
const ENEMY_POSITION_STEP = 60

var enemy_speed = 50

var score = 0
var high_score = 0
var game_state: GameState:
	set(value):
		if value == game_state:
			return
			
		game_state = value
		
		match value:
			GameState.MENU, GameState.GAME_OVER:
				enemy_speed = 0
			GameState.NEW_GAME:
				new_game()
					
		on_game_state_changed.emit(value)
		
var enemies: Array[Enemy]
var changing_direction: bool

signal on_game_state_changed(state: int)
	
func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("shoot"):
		if game_state == GameState.MENU || game_state == GameState.GAME_OVER:
			game_state = GameState.NEW_GAME
	
func new_game():
	enemy_speed = ENEMY_SPEED_INIT
	setup_board(1)
	game_state = GameState.PLAYING
	
func setup_board(page: int):
	var direction = (randi() & 2) - 1
	var x = 400
	var y = 100 + ENEMY_POSITION_STEP * page
	
	for enemy in enemies:
		enemy.queue_free()
		
	for row in range(0, ENEMY_ROWS):
		for col in range(0, ENEMY_COLS):
			var enemy = ENEMY_SCENE.instantiate()
			add_child(enemy)
			enemy.direction = direction
			enemy.position = Vector2(x + ENEMY_POSITION_STEP * col, y + ENEMY_POSITION_STEP * row)
			enemy.on_hit_wall.connect(change_enemy_direction)
			enemy.on_destroyed.connect(func ():
					enemies.erase(enemy)
					enemy_speed += ENEMY_SPEED_STEP
					if enemies.is_empty():
						setup_board(page + 1)
					)
				
			enemies.append(enemy)
		
func change_enemy_direction():
	if (changing_direction):
		return
		
	changing_direction = true
	
	for enemy in enemies:
		if enemy != null:
			enemy.direction *= -1
			enemy.velocity.y += ENEMY_POSITION_STEP
		
	get_tree().create_timer(1).timeout.connect(func ():
		changing_direction = false	
		)
	
func add_score(inc: int):
	score += inc
