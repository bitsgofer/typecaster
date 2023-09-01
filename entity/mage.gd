extends Node2D

func _ready():
	self.add_to_group("player")
	$Mage.area_entered.connect(Callable(self, "_on_hit"))

func _process(delta):
	pass

func _on_hit(area):
	print_debug("MAGE COLLISION: collied with %s" % area.name)
	get_tree().change_scene_to_file("res://scene/game_over.tscn")
