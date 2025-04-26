extends Area2D
class_name Destructable2D

@export var health: int

signal destroyed(area)
signal damage_taken(area)

func _ready():
	area_entered.connect(func(area: Area2D):
		#if area is Destructable2D:
		health -= 1
		if health <= 0:
			destroyed.emit(area.get_parent())
		else:
			damage_taken.emit(area.get_parent())
		)
