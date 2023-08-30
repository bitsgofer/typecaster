extends Node2D

@export var Speed:int = 100
@export var Target:Node

func _ready():
	pass

func _process(delta):
	move_towards_target(self.Speed * delta)

func move_towards_target(distance:float):
	var direction = self.Target.position - self.position
	direction = direction.normalized()
	position += direction * distance
