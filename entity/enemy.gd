extends Node2D

@export var target_name = "CHANGE_ME"

func _ready():
	self.add_to_group("enemy")
	$Enemy.area_entered.connect(Callable(self, "_on_spell_hit"))

func _process(delta):
	pass

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
