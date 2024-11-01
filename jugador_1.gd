extends CharacterBody2D

var puede_moverse := true  # Variable para habilitar o deshabilitar el movimiento
var speed := 120
@onready var animated_sprite_horizontal = $AnimatedSprite2D
@onready var animated_sprite_up = $AnimatedSprite2D_Up

func _ready():
	if animated_sprite_horizontal != null:
		animated_sprite_horizontal.visible = true
	if animated_sprite_up != null:
		animated_sprite_up.visible = false

func _physics_process(_delta):
	if !puede_moverse:
		velocity = Vector2.ZERO  # Detener el movimiento si está deshabilitado
		if animated_sprite_horizontal != null:
			animated_sprite_horizontal.play("idle")
		return

	var inputVelX = Input.get_axis("ui_left", "ui_right")
	var inputVelY = Input.get_axis("ui_up", "ui_down")

	velocity.x = inputVelX * speed
	velocity.y = inputVelY * speed
	move_and_slide()

	if velocity.y < 0:
		animated_sprite_horizontal.visible = false
		animated_sprite_up.visible = true
		animated_sprite_up.play("up")
	else:
		animated_sprite_horizontal.visible = true
		animated_sprite_up.visible = false
		if velocity.x != 0:
			animated_sprite_horizontal.play("run")
		else:
			animated_sprite_horizontal.play("idle")
	
	if animated_sprite_horizontal != null:
		animated_sprite_horizontal.flip_h = inputVelX < 0
