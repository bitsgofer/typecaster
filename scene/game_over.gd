extends Node2D



func _ready():
	print_debug("SCENE.V(0): Ready: scene/game_over")
	$CenterContainer/GridContainer/PlayAgain.button_down.connect(Callable(self, "_on_play"))
	$CenterContainer/GridContainer/Score.text = "Killed: %d" % Global.shared_data["killed"]


func _on_play():
	get_tree().change_scene_to_file("res://scene/game.tscn")
