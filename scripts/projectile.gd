extends Area2D
class_name Projectile

@export var direction: Vector2
@export var speed: int

signal on_projectile_destroyed


func _physics_process(delta: float) -> void:
	position -= speed * direction * delta
	
func hit():
	if is_queued_for_deletion():
		return
		
	queue_free()
	on_projectile_destroyed.emit()

func _on_visible_on_screen_enabler_3d_screen_exited():
	hit()

func _on_destructable_3d_destroyed(area):
	hit() # Replace with function body.
