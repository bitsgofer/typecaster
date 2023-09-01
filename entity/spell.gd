extends Node2D

var speed:int = 200
var target_ref:WeakRef = null

func configure(position:Vector2, target:Node, speed:int):
	self.position = position
	self.speed = speed
	self.target_ref = weakref(target)
	self.add_to_group(group_key(target.name))

func group_key(targetName:String) -> String:
	return "spell/%s" % targetName

func _ready():
	print_debug("SPELL: spawned @ (%d, %d)" % [self.position.x, self.position.y])

func _process(delta):
	move_towards_target(delta)

func move_towards_target(delta:float):
	var target = self.target_ref.get_ref()
	if target == null:
		return
	var direction = target.position - self.position
	self.position += direction.normalized() * (self.speed * delta)
