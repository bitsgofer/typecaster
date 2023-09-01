extends Node2D

@export var target_name = "CHANGE_ME"
var target_ref:WeakRef = null
var speed:int = 100

func configure(p_position:Vector2, p_target_name:String, p_target:Node):
	self.position = p_position
	self.target_name = p_target_name
	self.target_ref = weakref(p_target)

func _ready():
	$CenterContainer/TargetName.text = self.target_name
	self.add_to_group(group_key())
	$Enemy.area_entered.connect(Callable(self, "_on_spell_hit"))

func group_key() -> String:
	return "enemy"

func _process(delta):
	move_towards_target(delta)

func move_towards_target(delta:float):
	if self.target_ref == null:
		return
	var target = self.target_ref.get_ref()
	if target == null:
		return
	var direction = target.position - self.position
	self.position += direction.normalized() * (self.speed * delta)

func _on_spell_hit(area:Area2D):
	print_debug("ENEMY COLLISION: collied with %s" % area.name)
	match (area.name):
		"Spell":
			collide_with_spell()
		_:
			print_debug("ENEMY COLLISION: collied with unhandled area")
			return

func collide_with_spell():
	print_debug("ENEMY COLLISION: enemy/%s && groupped spell => destroyed" % self.get_instance_id())
	get_tree().call_group("spell/%s" % self.target_name, "queue_free")
	self.queue_free()
