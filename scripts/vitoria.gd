extends Control

@onready var som_button: AudioStreamPlayer2D = $som_button

func _on_jogar_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/fight1.tscn")

func _on_menu_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/menu_principal.tscn")

func _on_jogar_mouse_entered() -> void:
	som_button.play()

func _on_menu_mouse_entered() -> void:
	som_button.play()
