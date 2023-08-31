extends Node2D

func _ready():
	$TryAgain.button_down.connect(Callable(self, "_on_try_again"))

func _process(delta):
	pass

const root_scene:PackedScene = preload("res://scene/root.tscn")

func _on_try_again():
	var scene = root_scene.instantiate()
	get_tree().root.add_child(scene)
	get_tree().current_scene.queue_free()
	get_tree().current_scene = scene
