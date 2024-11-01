extends Control

@onready var boton_invertir = $BotonInvertir
@onready var dialogo_fondo = $VBoxContainer/DialogoFondo
@onready var dialogo_label = $VBoxContainer/DialogoFondo/DialogoLabel
@onready var label_pregunta = $LabelPregunta
@onready var input_cantidad = $InputCantidad
@onready var confirm_button = $ConfirmButton

var cantidad_invertir = 0
var texto_completo = ""
var indice_letra = 0

signal finalizado

func _ready():
	dialogo_fondo.visible = false   # Esconder el cuadro de diálogo al inicio
	label_pregunta.visible = false  # Esconder el Label de pregunta al inicio
	input_cantidad.visible = false  # Esconder el input de cantidad al inicio
	confirm_button.visible = false  # Esconder el botón de confirmación al inicio

	# Conectar la señal desde escenabonos para reiniciar el botón de invertir
	var escenabonos = get_parent().get_node("Escenabonos")
	if escenabonos != null:
		escenabonos.connect("reactivar_invertir", self, "_reactivar_boton_invertir")
	else:
		print("Error: escenabonos no se encontró.")

# Función para iniciar el diálogo con el texto deseado
func mostrar_dialogo(texto: String):
	dialogo_fondo.visible = true
	texto_completo = texto
	indice_letra = 0
	dialogo_label.visible = true
	dialogo_label.text = ""
	empezar_escritura()

# Función para desplegar texto gradualmente
func empezar_escritura():
	if indice_letra < texto_completo.length():
		dialogo_label.text += texto_completo[indice_letra]
		indice_letra += 1
		await get_tree().create_timer(0.05).timeout  # Controla la velocidad de aparición de cada letra
		empezar_escritura()
	else:
		await get_tree().create_timer(2.0).timeout  # Tiempo para que el jugador lea
		mostrar_input()  # Mostrar el input y botón de confirmación

# Al presionar el botón de invertir, se muestra el diálogo explicativo o se vuelve a permitir invertir
func _on_boton_invertir_pressed() -> void:
	boton_invertir.visible = false
	if get_parent().get_node("Escenabonos").panel_resultados.visible:
		get_parent().get_node("Escenabonos").panel_resultados.visible = false  # Oculta el panel de resultados para la siguiente inversión
		mostrar_input()
	else:
		mostrar_dialogo("Este es el Edificio de Bonos. Aquí puedes invertir en bonos, que son una forma de préstamo donde tú le prestas dinero a una empresa o gobierno. A cambio, recibes intereses, es decir, ganancias adicionales con el tiempo. ¡Es una manera segura de hacer crecer tu dinero mientras apoyas proyectos importantes!")

# Función para mostrar el input y el botón de confirmación después del diálogo
func mostrar_input():
	dialogo_label.visible = false  # Ocultar el texto cuando aparecen el input y el botón
	label_pregunta.text = "¿Qué cantidad de dinero deseas invertir?"  # Texto de la pregunta
	label_pregunta.visible = true  # Mostrar el Label de pregunta
	input_cantidad.visible = true
	confirm_button.visible = true

# Al confirmar, se captura la cantidad y se emite la señal para cambiar de escena
func _on_confirm_button_pressed() -> void:
	cantidad_invertir = input_cantidad.text.to_int()
	print("Cantidad a invertir: ", cantidad_invertir)
	emit_signal("finalizado", cantidad_invertir)  # Emite la señal con la cantidad de inversión
	queue_free()  # Elimina la escena de interacción

# Función para reactivar el botón de invertir cuando se permite una nueva inversión
func _reactivar_boton_invertir():
	boton_invertir.visible = true
