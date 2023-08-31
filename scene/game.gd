extends Node2D

func _ready():
	$EndGame.button_down.connect(Callable(self, "_on_press_end"))

func _process(delta):
	pass

func _on_press_end():
	get_tree().change_scene_to_file("res://scene/game_over.tscn")
