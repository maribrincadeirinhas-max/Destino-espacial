extends CharacterBody2D

#--------------Variáveis de posicão-------------------
@onready var SpawnEsq1 : Marker2D = $teleguiados/esquerda1
@onready var SpawnEsq2 : Marker2D = $teleguiados/esquerda2
@onready var SpawnDir1 : Marker2D = $teleguiados/direita1
@onready var SpawnDir2 : Marker2D = $teleguiados/direita2
@onready var SpawnCentral : Marker2D = $central/localEspecial

#-----------------Variáveis de cena/sprites---------------------
@onready var teleguiado_scene = preload("res://scenes/tiro_guiado.tscn")
@onready var especial_central_scene = preload("res://scenes/especial_central.tscn")
@onready var boss = $boss
@onready var especial_ida = $especial_ida

#--------------Variáveis de audio-------------------
@onready var explosao: AudioStreamPlayer2D = $explosao

#--------------Variáveis auxiliares------------------
var atirou : bool = false

#-----------------------Sinal-------------------------
signal vida_do_boss()

enum Estado{
	PARADO,
	ATAQUE_BASICO,
	ATAQUE_ESPECIAL,
}
var estado = Estado.PARADO

#-----------Principal---------------
func _ready():
	mudanca_de_estado(Estado.PARADO)

#-----------Estados----------------
func mudanca_de_estado(novo_estado):
	
	estado = novo_estado
	
	match estado:
		
		Estado.PARADO:
			especial_ida.visible = false
			boss.play("estatico")
			await boss.animation_finished
			$Timer.start(5.0)
			mudanca_de_estado(Estado.ATAQUE_BASICO)
			
		Estado.ATAQUE_BASICO:
			especial_ida.visible = false
			boss.play("ataque_basico_abrir")
			await boss.animation_finished
			
			atirou = false
			ataque_basico()
			
		Estado.ATAQUE_ESPECIAL:
			boss.play("especial _ida")
			await boss.animation_finished
			
			especial_ida.visible = true
			especial_ida.play("ida_central")
			await boss.animation_finished
			
			atirou = false
			ataque_especial_central()

#--------------Funções----------------
#Algoritmo que gera o ataque básico. Verifica se já atirou, se não,
#instancia 4 balas do "tiro_guiado" que se o jogador estiver perto, irá segui-lo, 
#avisa que já atirou e fecha a animação evitando atirar diversas vezes.
#Se sim, não faz nada.
func ataque_basico():
	if not atirou:
		gerar_ataque_teleguiado(SpawnEsq1)
		gerar_ataque_teleguiado(SpawnEsq2)
		gerar_ataque_teleguiado(SpawnDir1)
		gerar_ataque_teleguiado(SpawnDir2)
		
		atirou = true
		boss.play("ataque_basico_fechar")
		await boss.animation_finished
		
		mudanca_de_estado(Estado.PARADO)

#Algoritmo que gera o "tiro_guiado".
func gerar_ataque_teleguiado(Spawn: Marker2D):
	var bolinhaGuia = teleguiado_scene.instantiate()
	get_parent().add_child(bolinhaGuia)
	bolinhaGuia.name = "boss_bullet"
	bolinhaGuia.global_position = Spawn.global_position

#Algoritmo que faz o ataque especial do boss.
#Mesmo estando presente no código, não é executado no jogo.
#Porque devido ao curto tempo e problemas de implementar eu optei
#por consertar os principais bugs, na tentativa de fazer essa parte 
#funcionar, me tomou muito tempo, mas se você quiser testar, apenas
#coloque "mudanca_de_estado(Estado.ATAQUE_ESPECIAL)" no final na função 
#"ataque_basico", o boss acaba travando.
func ataque_especial_central():
	if not atirou:
		gerar_ataque_especial(SpawnCentral)
		
		atirou = true
		boss.play("especial_volta")
		await boss.animation_finished
		
		mudanca_de_estado(Estado.PARADO)

#Algoritmo que gera o "especial_central".
func gerar_ataque_especial(Spawn: Marker2D):
	var especial_central = especial_central_scene.instantiate()
	get_parent().add_child(especial_central)
	especial_central.name = "boss_bullet"
	especial_central.global_position = Spawn.global_position

#Algoritmo que recebe dano, se a vida estiver menor ou igual a 0,
#apresenta a animação de derrota e vai para a cena de vitória.
func receberDano_boss(val):
	GameSystem.bossLife -= val
	
	if GameSystem.bossLife <= 0:
		explosao.play()
		boss.play("derrotado")
		await boss.animation_finished
		
		#Se este objeto ainda existir na memória E estiver conectado na cena ativa, 
		#então vai para a tela de vitória.
		if is_instance_valid(self) and is_inside_tree():
			resetar_boss()
			get_tree().change_scene_to_file("res://scenes/tela_de_vitoria.tscn")

func resetar_boss():
	GameSystem.bossLife = 750
	vida_do_boss.emit()

#Area para dar dano no boss. Se for o tiro do jogador, toma dano, 
#emite o sinal, atualiza a barra de vida e some com o tiro.
func _on_bosshitbox_area_entered(area: Area2D) -> void:
	if area.name.begins_with("player_bullet"):
		receberDano_boss(2)
		vida_do_boss.emit()
		area.queue_free()
