extends Area2D

# Declarar la variable aquí al principio
var player_cerca_del_estante = false
var contador_node = null  # Referencia al nodo del contador (jugador)
var portal_scene = null  # Referencia a la escena del portal
var portal_instance = null  # Instancia del portal cargada
var portal_visible = false  # Indica si el portal es visible
var timer = null  # Referencia al temporizador

# Detecta cuando el personaje entra en el área del estante
func _on_Area2D_body_entered(body):
	if body == contador_node:  # Verifica si el cuerpo detectado es el contador
		print("El contador ha entrado en el área del estante")
		player_cerca_del_estante = true
		mostrar_estante()

# Detecta cuando el personaje sale del área del estante
func _on_Area2D_body_exited(body):
	if body == contador_node:  # Verifica si el cuerpo detectado es el contador
		print("El contador ha salido del área del estante")
		player_cerca_del_estante = false
		ocultar_estante()

# Procesa la entrada del jugador cuando está cerca del estante
func _process(_delta):
	if player_cerca_del_estante and Input.is_action_just_pressed("ui_accept"):
		abrir_menu_de_opciones()  # Mostrar opciones al interactuar

# Función para abrir el menú de opciones utilizando un Panel
func abrir_menu_de_opciones():
	$Panel.visible = true  # Hace visible el Panel cuando el jugador interactúa
	print("Panel visible")

# Función que resalta el estante cuando el jugador está cerca
func mostrar_estante():
	$EstanteSprite.modulate = Color(1, 1, 1, 1)  # Cambia el color para resaltar
	print("Estante resaltado")

# Función que oculta el estante cuando el jugador se aleja
func ocultar_estante():
	$EstanteSprite.modulate = Color(0.5, 0.5, 0.5, 1)  # Cambia el color para desactivar el estante
	$Panel.visible = false  # Asegura que el Panel esté oculto cuando no se interactúa
	print("Panel oculto")

# Función para mostrar el portal y activar la animación, además de activar el temporizador
func mostrar_portal():
	if portal_instance != null:  # Verifica si la instancia del portal ha sido cargada
		add_child(portal_instance)  # Agrega el portal a la escena actual
		portal_instance.position = Vector2(400, 300)  # Ajusta la posición según tu escena

		# Obtener el nodo AnimatedSprite2D en la instancia del portal
		var animated_sprite = portal_instance.get_node("AnimatedSprite2D")
		if animated_sprite != null:
			animated_sprite.play("ir")  # Inicia la animación 'ir'
			portal_visible = true
			print("Portal visible y animación 'ir' iniciada")

			# Inicia el temporizador para cambiar de escena después de 2 segundos
			timer.start(4.0)
		else:
			print("Error: AnimatedSprite2D no encontrado en la instancia del portal")
	else:
		print("Error: La instancia del portal no fue cargada")

# Función que carga la escena del portal
func cargar_portal_scene():
	var portal_scene_path = "res://portal.tscn"  # Ajusta la ruta de la escena del portal
	portal_scene = load(portal_scene_path)
	if portal_scene != null:
		portal_instance = portal_scene.instantiate()  # Cambiado a instantiate() en Godot 4.x
	else:
		print("Error: No se pudo cargar la escena del portal")

# Función que cambia a la escena 'escena_inversion'
func cambiar_a_escena_inversion():
	print("Cambiando a la escena 'escena_inversion'...")
	get_tree().change_scene_to_file("res://escena_inversion.tscn")  # Cambiar a la escena de inversión

# Función que se llama cuando el temporizador termina (cambia de escena)
func _on_Timer_timeout():
	# Cambia a la escena interior del edificio cuando se complete el temporizador
	print("Tiempo agotado, cambiando de escena...")
	cambiar_a_escena_inversion()

# Conexión de la señal 'body_entered' al iniciar la escena
func _ready():
	# Conectar la señal 'body_entered' del Area2D al método _on_Area2D_body_entered
	connect("body_entered", Callable(self, "_on_Area2D_body_entered"))
	connect("body_exited", Callable(self, "_on_Area2D_body_exited"))
	
	# Buscar el nodo del contador en la escena (ajusta el path al nodo de tu jugador)
	contador_node = get_node("../.")  # Ajusta la ruta según el nodo del jugador

	# Cargar la escena del portal
	cargar_portal_scene()

	# Crear el temporizador y conectarlo
	timer = Timer.new()
	add_child(timer)
	timer.connect("timeout", Callable(self, "_on_Timer_timeout"))  # Conectar la señal de timeout del temporizador

# Funciones para los botones del menú (como ejemplo)
func _on_invest_pressed() -> void:
	print("Opción Inversión seleccionada")
	mostrar_portal()

func _on_business_pressed() -> void:
	print("Opción Crear Negocio seleccionada")
	mostrar_portal()

func _on_education_pressed() -> void:
	print("Opción Educación seleccionada")
	mostrar_portal()

func _on_advisor_pressed() -> void:
	print("Opción Asesor seleccionada")
	# Aquí puedes implementar una acción diferente
