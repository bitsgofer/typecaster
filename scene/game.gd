extends Node2D

func _ready():
	print_debug("SCENE.V(0): Ready: scene/game")
	$BackgroundMusic.connect("finished", Callable(self, "_on_background_music_finished"))

func _on_background_music_finished():
	$BackgroundMusic.play()
