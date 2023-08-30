extends Node2D

@export var Speed:int = 10
@export var TargetLabel:String = "CHANGE_ME"

var target:Node

func _ready():
	pass

func _process(delta):
	move_towards_target(self.Speed * delta)

func move_towards_target(distance:float):
	var direction = self.target.position - self.position

	direction = direction.normalized()
	position += direction * distance

func set_target(target):
	self.target = target.position

func init(name:String, target:Node, position:Vector2i):
	self.TargetLabel = name
	$TargetLabel.text = name

	self.target = target

	self.position = position
