extends CharacterBody2D
class_name Enemy

var direction = 1
var should_process: bool

signal on_hit_wall
signal on_destroyed

func _physics_process(delta: float):
	if GameManager.game_state != GameManager.GameState.PLAYING:
		return
		
	if is_on_wall():
		on_hit_wall.emit()
		
	if is_on_floor():
		GameManager.game_state = GameManager.GameState.GAME_OVER
		
	for index in range(get_slide_collision_count()):
		var collision = get_slide_collision(index)
		
		if collision.get_collider() == null:
			continue
		var c = collision.get_collider().get_class()
		if collision.get_collider().is_class("Player"):
			queue_free() 

	velocity.x = GameManager.enemy_speed * direction
	velocity.y = lerp(velocity.y, 0.0, .1)
	
	move_and_slide()

func _on_destructable_3d_destroyed(source):	
	GameManager.add_score(1)
	on_destroyed.emit()
	queue_free()
