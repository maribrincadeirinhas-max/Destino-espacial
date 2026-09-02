extends Control

@onready var ensinando_1: PanelContainer = $ensinando_1
@onready var ensinando_2: PanelContainer = $ensinando_2
@onready var ensinando_3: PanelContainer = $ensinando_3
@onready var pronto: PanelContainer = $pronto
@onready var som: AudioStreamPlayer2D = $som_button

func _ready() -> void:
	ensinando_1.visible = true
	ensinando_2.visible = false
	ensinando_3.visible = false
	pronto.visible = false

func _on_ok_1_button_down() -> void:
	ensinando_1.visible = false
	ensinando_2.visible = true

func _on_ok_2_button_down() -> void:
	ensinando_2.visible = false
	ensinando_3.visible = true

func _on_ok_3_button_down() -> void:
	ensinando_3.visible = false
	pronto.visible = true

func _on_pronto_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/fight1.tscn")


#---------------Som nos botões-------------------
func _on_pronto_mouse_entered() -> void:
	som.play()

func _on_ok_3_mouse_entered() -> void:
	som.play()

func _on_ok_2_mouse_entered() -> void:
	som.play()

func _on_ok_1_mouse_entered() -> void:
	som.play()
