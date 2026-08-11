extends ProgressBar

@export var alvo : RigidBody2D 

func _ready() -> void:
	alvo.vida_alterada.connect(atualizar_vida)
	atualizar_vida()
	
func atualizar_vida():
	value = alvo.life
