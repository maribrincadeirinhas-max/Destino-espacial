extends ProgressBar

@export var alvo : CharacterBody2D

func _ready() -> void:
	alvo.vida_do_boss.connect(atualizar_vida)
	atualizar_vida()
	
func atualizar_vida():
	value = GameSystem.bossLife
	
