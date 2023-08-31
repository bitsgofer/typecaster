extends Node2D

func _ready():
	$Play.button_down.connect(Callable(self, "_on_press_play"))

func _process(delta):
	pass

func _on_press_play():
	get_tree().change_scene_to_file("res://scene/game.tscn")
