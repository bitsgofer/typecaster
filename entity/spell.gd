extends Node2D

@export var Speed:int = 100

var direction:Vector2 = Vector2(0, 0)

func _ready():
	pass

func _process(delta):
	move(self.Speed * delta)

func move(distance:float):
	position += direction * distance

func set_direction(target:Node):
	print_debug("spell.set_direction= ", target.name)
	var direction = target.position - self.position
	self.direction = direction.normalized()
