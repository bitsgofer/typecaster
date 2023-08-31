extends Node2D

func _ready():
	$PlayAgain.button_down.connect(Callable(self, "_on_press_play_again"))

func _process(delta):
	pass

func _on_press_play_again():
	get_tree().change_scene_to_file("res://scene/game.tscn")
