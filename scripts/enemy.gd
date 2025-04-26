extends CharacterBody3D
class_name Enemy

var direction = 1

signal on_hit_wall
signal on_destroyed

func _physics_process(delta: float):
	if is_on_wall():
		on_hit_wall.emit()
		
	#for index in range(get_slide_collision_count()):
		#var collision = get_slide_collision(index)
		#
		#if collision.get_collider() == null:
			#continue
		#var c = collision.get_collider().get_class()
		#if collision.get_collider().is_class("Projectile"):
			#queue_free() 

	velocity.x = GameManager.enemy_speed * direction
	
	move_and_slide()

func _on_destructable_3d_destroyed():
	GameManager.add_score(1)
	on_destroyed.emit()
	queue_free()
