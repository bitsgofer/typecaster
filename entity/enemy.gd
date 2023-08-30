extends Node2D

@export var Speed:int = 100
@export var TargetLabel:String = "CHANGE_ME"

var target:Vector2 = self.position

var name_list = [
	"chicken",
	"egg",
	"foo",
	"bar",
	"hello world",
	"random",
]

func _ready():
	var mage = get_node("/root/root/Mage")

	set_random_target_label()
	set_target(mage)

func _process(delta):
	move_towards(self.target, self.Speed * delta)

func move_towards(target:Vector2, distance:float):
	var direction = target - position

	direction = direction.normalized()
	position += direction * distance

func set_target(target):
	self.target = target.position

func set_random_target_label():
	var name = name_list[randi() % name_list.size()]
	self.TargetLabel = name
	$TargetLabel.text = name
