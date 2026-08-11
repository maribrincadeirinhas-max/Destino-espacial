extends RigidBody2D

class_name Jogador

const NITRO = -50
@onready var spawn = $SpawnBullet
@onready var bullet_scene = preload("res://scenes/bulletNave.tscn")
@onready var relogio : float = 0.09
@onready var tempo_tiro =  $cadencia
@onready var som_tiro = $tiro_player
@onready var som_nitro = $nitro_audio
@onready var animNave = $nave
@onready var escudo_scene = preload("res://scenes/escudo.tscn")
var escudo_ativo = null
@onready var tempo_escudo = $Timer_escudo
signal vida_alterada()
@export var life : int = 100:
	set(value):
		life = value

func _ready() -> void:
	tempo_tiro.wait_time = relogio

func _physics_process(delta: float) -> void:
	if (life <= 0):
		if animNave:
			animNave.play("derrota")
			await animNave.animation_finished
		if is_instance_valid(self) and is_inside_tree():
			get_tree().change_scene_to_file("res://scenes/tela_derrota.tscn")

	if not is_inside_tree(): 
		return
	
	# Obtém a posição global do mouse na tela
	var mouse_pos = get_global_mouse_position() 
	global_position.x = mouse_pos.x
	animNave.play("idle")
	
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
		apply_impulse(Vector2(0,NITRO))
		
		if animNave.animation != "nitro":
			animNave.play("nitro")
			
		if not som_nitro.playing:
			som_nitro.play()
	else:
		som_nitro.stop()
		
	if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT) and tempo_tiro.is_stopped():
		som_tiro.play()
		atirar()
		tempo_tiro.start()

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			if event.is_pressed and escudo_ativo == null:
				ativar_escudo()
			
func atirar():
	# is_stopped() significa (cooldown acabou)
	if tempo_tiro.is_stopped():
		var bullet = bullet_scene.instantiate()
		get_parent().add_child(bullet)
		bullet.name = "player_bullet"
		bullet.global_position = spawn.global_position

func ativar_escudo():
	escudo_ativo = escudo_scene.instantiate()
	add_child(escudo_ativo)
	escudo_ativo.position = Vector2.ZERO
	tempo_escudo.start()

func desativar_escudo():
	if escudo_ativo != null:
		escudo_ativo.queue_free()
		escudo_ativo = null


func _on_timer_escudo_timeout() -> void:
	desativar_escudo()

func _on_area_area_entered(area: Area2D) -> void:
	if area.name.begins_with("boss_bullet"):
		life -= area.dano
		vida_alterada.emit()
		area.queue_free()
