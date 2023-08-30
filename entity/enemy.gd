extends Node2D

@export var Speed:int = 100

var target:Vector2 = self.position

func _ready():
	var mage = get_node("/root/root/Mage")
	set_target(mage)

func _process(delta):
	move_towards(self.target, self.Speed * delta)

func move_towards(target:Vector2, distance:float):
	var direction = target - position

	direction = direction.normalized()
	position += direction * distance

func set_target(target):
	self.target = target.position
