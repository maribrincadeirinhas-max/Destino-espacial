extends Area2D

@export var speed := 170.0
@export var parar := 300
@export var dano : int = 10

var jogador: RigidBody2D

func _ready() -> void:
	jogador = get_tree().get_first_node_in_group("player")
	add_to_group("bossDano")

func _process(delta: float) -> void:
	if jogador == null:
		position += Vector2.DOWN * speed * delta
		return
	
	var direction = jogador.global_position - global_position 
	direction = direction.normalized()
	var distancia = global_position.distance_to(jogador.global_position) 
		
	if distancia > parar:
		position += Vector2.DOWN * speed * delta
	else:
		position += direction * speed * delta

func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	queue_free()
