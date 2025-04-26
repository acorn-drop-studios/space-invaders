extends Area3D
class_name Destructable3D

@export var health: int

signal destroyed
signal damage_taken

func _ready():
	area_entered.connect(func(area: Area3D):
		#if area is Destructable3D:
		health -= 1
		if health <= 0:
			destroyed.emit()
		else:
			damage_taken.emit()
		)
