extends Node2D

func _ready():
	print_debug("SCENE.V(0): Ready: scene/game_over")
	$CenterContainer/VSplitContainer/PlayAgain.button_down.connect(Callable(self, "_on_play"))

func _on_play():
	get_tree().change_scene_to_file("res://scene/game.tscn")
