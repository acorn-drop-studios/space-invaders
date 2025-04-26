extends CharacterBody2D
class_name Player

var _laser = preload("res://scenes/projectile.tscn")
var should_process: bool

const SPEED = 300.0
const LASER_SPEED = 400

var lasers_active = 0

func _ready():
	GameManager.on_game_state_changed.connect(func (game_state):
		should_process = game_state == GameManager.GameState.PLAYING
		)
		
func _process(delta: float) -> void:
	if GameManager.game_state != GameManager.GameState.PLAYING:
		return
		
	if Input.is_action_pressed("shoot"):
		if (lasers_active == 0):
			var laser_instance = _laser.instantiate()
			owner.add_child(laser_instance)
			
			laser_instance.collision_layer = 1
			laser_instance.collision_mask = 2
			laser_instance.position = position
			laser_instance.position.y -= 30
			laser_instance.direction = Vector2(0,1)
			laser_instance.speed = LASER_SPEED
			lasers_active += 1
			laser_instance.on_projectile_destroyed.connect(on_projectile_destroyed)
		
func _physics_process(delta: float) -> void:
	if GameManager.game_state != GameManager.GameState.PLAYING:
		return
		
		# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "ui_up", "ui_down")
	var direction := (Vector2(input_dir.x, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func on_projectile_destroyed():
	lasers_active -= 1

func _on_destructable_2d_destroyed(area: Variant):
	GameManager.set_game_state(GameManager.GameState.GAME_OVER)
