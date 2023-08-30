extends Node2D

var speed:int = 0
var target_ref

func _ready():
	$SpellArea.area_entered.connect(Callable(self, "_on_spell_hit"))

func _process(delta):
	move_towards_target(self.speed * delta)

func move_towards_target(distance:float):
	var target = self.target_ref.get_ref()
	if target == null:
		return

	var direction = target.position - self.position
	direction = direction.normalized()
	position += direction * distance

func init(position:Vector2, speed:int, target:Node, group_key:String):
	self.position = position
	self.speed = speed
	self.target_ref = weakref(target)
	self.add_to_group("spell/%s" % group_key)

func _on_spell_hit(area:Area2D):
	if area.name != "EnemyArea":
		return

	self.queue_free()
