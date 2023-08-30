extends Node2D

@export var Speed:int = 10
@export var TargetLabel:String = "CHANGE_ME"

var target_ref

func _ready():
	$EnemyArea.area_entered.connect(Callable(self, "_on_spell_hit"))

func _process(delta):
	move_towards_target(self.Speed * delta)

func move_towards_target(distance:float):
	var target = self.target_ref.get_ref()
	if target == null:
		return

	var direction = target.position - self.position
	direction = direction.normalized()
	position += direction * distance

func init(name:String, target:Node, position:Vector2i):
	self.TargetLabel = name
	$TargetLabel.text = name

	self.target_ref = weakref(target)

	self.position = position

func _on_spell_hit(area:Area2D):
	if area.name != "SpellArea":
		return

	get_tree().call_group("spell/%s" % self.TargetLabel, "queue_free")
	self.queue_free()
