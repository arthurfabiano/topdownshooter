extends CharacterBody2D

@onready var animation_legs:AnimationTree = $Sprite/Legs/AnimationTree
@onready var animation_body:AnimationTree = $Sprite/Body/AnimationTree
@onready var animation_node:AnimationNodeStateMachinePlayback = animation_body.get("parameters/playback")
@onready var barrel:Marker2D = $Barrel

var weapon:Resource : set = _set_weapon

const BULLET = preload("res://prefabs/player/bullet.tscn")
const SPEED = 200.0

var weapon_timer = 0.0
var cooldown = 0.3
var speed_bullet = 800

func _set_weapon(value:Resource) -> void:
	weapon = value
	pass
	
func _draw() -> void:
	animation_node.travel(weapon.name)
	pass	
	
func _ready():
	print(weapon)
	#animation_node.travel(weapon.name)
	pass
	
func _physics_process(delta):
	look_at(get_global_mouse_position())
	
	# Obter a entrada de movimento do jogador
	var mov = Vector2.ZERO

	# Movimento horizontal
	if Input.is_action_pressed("ui_right"):
		mov.x += 1
	elif Input.is_action_pressed("ui_left"):
		mov.x -= 1

	# Movimento vertical
	if Input.is_action_pressed("ui_down"):
		mov.y += 1
	elif Input.is_action_pressed("ui_up"):
		mov.y -= 1
	
	weapon_timer -= delta
	if Input.is_action_pressed("ui_shoot") and weapon_timer <= 0:
		weapon_timer = cooldown
		shoot()
		pass

	# Normaliza o vetor de movimento para garantir que a velocidade seja consistente nas diagonais
	if mov != Vector2.ZERO:
		mov = mov.normalized()

	# Aplica o movimento ao personagem
	velocity = mov * SPEED
	
	animations(mov)
	move_and_slide()

func animations(mov) -> void:
	animation_legs.set("parameters/blend_position", mov)
	animation_body.set("parameters/%s/blend_position" % weapon.name, mov)
	pass

func shoot() -> void:
	var bullet = BULLET.instantiate()
	bullet.global_position = barrel.global_position
	bullet.rotation_degrees = rotation_degrees
	bullet.linear_velocity = Vector2(speed_bullet,0).rotated(bullet.rotation)
	get_parent().add_child(bullet)
	pass
