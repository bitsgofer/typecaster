extends Node2D

func _ready():
	print_debug("SCENE.V(0): Ready: scene/root")
	get_tree().change_scene_to_file("res://scene/intro.tscn")
