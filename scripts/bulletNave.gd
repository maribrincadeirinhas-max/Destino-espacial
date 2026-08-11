extends Area2D
var speed = 400
var direcao = Vector2.UP

func _process(delta: float) -> void:
	position += direcao * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
