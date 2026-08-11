extends Control

@onready var botao = $som_button
@onready var opcoes: PanelContainer = $opcoes
@onready var botoes_principais: VBoxContainer = $botoes_principais

func _ready() -> void:
	botoes_principais.visible = true
	opcoes.visible = false

func _on_play_button_down() -> void:
	get_tree().change_scene_to_file("res://scenes/fight1.tscn")

func _on_sair_button_down() -> void:
	get_tree().quit()
	
func _on_opcoes_button_down() -> void:
	botoes_principais.visible = false
	opcoes.visible = true
	
func _on_sair_das_opcoes_button_down() -> void:
	botoes_principais.visible = true
	opcoes.visible = false
	
#------------Som nos botões--------------
func _on_play_mouse_entered() -> void:
	botao.play()

func _on_opcoes_mouse_entered() -> void:
	botao.play()

func _on_sair_mouse_entered() -> void:
	botao.play()

func _on_sair_das_opcoes_mouse_entered() -> void:
	botao.play()
