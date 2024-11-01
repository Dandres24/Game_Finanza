extends Node2D

var nivel = 1  # Nivel inicial del jugador
var max_nivel = 5  # El nivel máximo que puede alcanzar el jugador
var portal_instance = null  # Referencia al nodo del portal
var contador = null  # Referencia al nodo del contador
var timer = null  # Temporizador para retrasar la aparición del contador

@onready var interaccion_bonos = $InteraccionBonos
@onready var escenabonos = $Escenabonos

func _ready():
	# Ajusta el portal
	portal_instance = $portal  # Ajusta esta ruta según la estructura de tu escena
	if portal_instance == null:
		print("Error: No se encontró el nodo 'Portal'. Verifica la ruta.")
	else:
		mostrar_portal()

	# Ajustar el contador
	contador = $Jugador1  # Ajusta esta ruta según la estructura de tu escena
	if contador == null:
		print("Error: No se encontró el nodo 'Contador'. Verifica la ruta.")
	else:
		contador.visible = false
		# Temporizador para mostrar el contador después de unos segundos
		timer = Timer.new()
		add_child(timer)
		timer.connect("timeout", Callable(self, "_mostrar_contador"))
		timer.start(3.0)

	# Ocultar escenas de interacción al inicio
	interaccion_bonos.visible = false
	escenabonos.visible = false

	# Conectar señal de finalización de interaccion_bonos para activar escenabonos
	interaccion_bonos.connect("finalizado", Callable(self, "_activar_escena_bonos"))

	# Configuración inicial de edificios
	bloquear_edificios()  
	desbloquear_edificios_iniciales()  
	desbloquear_edificios()  

# Funciones de bloqueo y desbloqueo de edificios
func bloquear_edificios():
	$EdificioAcciones.modulate = Color(0.5, 0.5, 0.5, 1)
	$EdificioCriptomonedas.modulate = Color(0.5, 0.5, 0.5, 1)
	$EdificioInmobiliaria.modulate = Color(0.5, 0.5, 0.5, 1)
	$EdificioAcciones/Area2D.set_deferred("monitoring", false)
	$EdificioCriptomonedas/Area2D.set_deferred("monitoring", false)
	$EdificioInmobiliaria/Area2D.set_deferred("monitoring", false)

func desbloquear_edificios_iniciales():
	$EdificioBonos.modulate = Color(1, 1, 1, 1)
	$EdificioMutuos.modulate = Color(1, 1, 1, 1)

func desbloquear_edificios():
	if nivel >= 2:
		$EdificioAcciones.modulate = Color(1, 1, 1, 1)
		$EdificioAcciones/Area2D.set_deferred("monitoring", true)
	if nivel >= 3:
		$EdificioCriptomonedas.modulate = Color(1, 1, 1, 1)
		$EdificioCriptomonedas/Area2D.set_deferred("monitoring", true)
	if nivel >= 4:
		$EdificioInmobiliaria.modulate = Color(1, 1, 1, 1)
		$EdificioInmobiliaria/Area2D.set_deferred("monitoring", true)

# Manejar el desbloqueo de la escena de bonos
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Jugador1":
		abrir_interaccion_bonos()

func abrir_interaccion_bonos():
	interaccion_bonos.visible = true
	print("Escena de interacción de bonos cargada")

# Función modificada para activar la escena de bonos y pasar el valor ingresado
func _activar_escena_bonos(cantidad: int):
	interaccion_bonos.visible = false
	escenabonos.visible = true
	escenabonos.cantidad_invertida = cantidad  # Actualiza la cantidad invertida en escenabonos
	print("Escena de bonos activada con cantidad invertida:", cantidad)

# Funciones de portal y contador
func mostrar_portal():
	if portal_instance != null:
		portal_instance.visible = true
		var animated_sprite = portal_instance.get_node("AnimatedSprite2D")
		if animated_sprite != null:
			animated_sprite.play("ir")
			print("Animación del portal iniciada")
		else:
			print("Error: No se encontró el AnimatedSprite2D en el portal")

func _mostrar_contador():
	if contador != null:
		contador.visible = true
		print("El contador ahora es visible")
	else:
		print("Error: Nodo 'Contador' no encontrado")
