extends Sprite2D

@onready var tempo = $"../../Timer"
var tela = false
@onready var tela_preta = $"../Sprite2D2"

func _ready() -> void:
	tempo.start(5.5)
	tempo.start(2.0)
	tela = true

func _on_timer_timeout() -> void:
	queue_free()
	if tela:
		tela_preta.queue_free()
