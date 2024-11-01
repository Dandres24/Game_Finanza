extends Control

@onready var boton_invertir = $BotonInvertir  # Referencia al botón de Invertir
@onready var boton_renta_fija = $VBoxContainer/BotonRentaFija  # Referencia al botón de Renta Fija
@onready var boton_renta_variable = $VBoxContainer/BotonRentaVariable  # Referencia al botón de Renta Variable (ahora en la escena de fondos mutuos)
@onready var dialog_box = $VBoxContainer2/TextureRect  # Referencia al TextureRect (el cuadro de diálogo)
@onready var dialog_text = $VBoxContainer2/TextureRect/RichTextLabel  # Referencia al RichTextLabel dentro del TextureRect
@onready var input_cantidad = $VBoxContainer2/TextureRect/InputRentaFija  # Referencia al Input donde se escribirá la cantidad de inversión
@onready var confirmar_cantidad_button = $VBoxContainer2/TextureRect/ConfirmarInversion  # Referencia al botón para confirmar la cantidad
@onready var plazo_opciones = $VBoxContainer2/TextureRect/PlazoOptionButton  # Referencia al PlazoOptionButton
@onready var confirmar_plazo = $VBoxContainer2/TextureRect/Confirmarplazo  # Referencia al botón de confirmar plazo
@onready var label_plazo = $LabelPlazo  # Referencia al Label para mostrar "¿A qué plazo deseas hacer tu inversión?"
@onready var label_cantidad = $LabelCantidad  # Referencia al Label para mostrar "¿Cuánto deseas invertir en el fondo de renta fija?"
@onready var label_resultado = $LabelResultados  # Referencia al Label para mostrar los resultados

var escena_renta_variable  # Variable para almacenar la escena de Renta Variable
var renta_variable_cargada = false  # Variable para controlar si ya se ha cargado la escena de Renta Variable

# Función que se ejecuta al cargar la escena
func _ready():
	resetear_visibilidad()  # Aseguramos que todo esté oculto al iniciar la escena

	# Conectar la señal del botón de Renta Variable usando Callable correctamente
	boton_renta_variable.connect("pressed", Callable(self, "_on_boton_renta_variable_pressed"))  # Conectamos el botón de renta variable a la función correspondiente

# Función para resetear la visibilidad de todos los elementos
func resetear_visibilidad():
	boton_invertir.visible = false  # Ocultar el botón de invertir al inicio
	boton_renta_fija.visible = false  # Ocultar el botón de renta fija al inicio
	boton_renta_variable.visible = false  # Ocultar el botón de renta variable al inicio
	dialog_box.visible = false  # Ocultar el TextureRect al inicio
	dialog_text.visible = false  # Ocultar el RichTextLabel al inicio
	input_cantidad.visible = false  # Ocultar el input de cantidad al inicio
	confirmar_cantidad_button.visible = false  # Ocultar el botón de confirmar cantidad
	plazo_opciones.visible = false  # Ocultar el PlazoOptionButton al inicio
	confirmar_plazo.visible = false  # Ocultar el botón de confirmar al inicio
	label_plazo.visible = false  # Ocultar el texto del plazo al inicio
	label_cantidad.visible = false  # Ocultar el label de cantidad al inicio
	label_resultado.visible = false  # Ocultar el label de resultados al inicio
	if escena_renta_variable:
		escena_renta_variable.visible = false  # Asegurar que la escena de renta variable esté oculta también

# Muestra el botón Invertir cuando el personaje se acerca al Area2D
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Jugador1":  # Verifica que el jugador sea "Jugador1"
		print("El personaje se acercó al edificio de fondos, mostrando el botón 'Invertir'")
		boton_invertir.visible = true  # Mostrar el botón de invertir cuando el personaje está cerca

# Ejecuta el botón "Invertir"
func _on_boton_invertir_pressed():
	resetear_visibilidad()  # Ocultar el botón de invertir
	print("Botón 'Invertir' presionado. Mostrando botones de Renta Fija y Renta Variable.")
	boton_renta_fija.visible = true  # Mostrar el botón de renta fija
	boton_renta_variable.visible = true  # Mostrar el botón de renta variable

# Función que se ejecuta al presionar el botón de Renta Variable
func _on_boton_renta_variable_pressed():
	print("Botón 'Renta Variable' presionado. Cargando la escena de Renta Variable.")

	# Ocultar los botones de Renta Fija y Renta Variable al cargar la escena de Renta Variable
	boton_renta_fija.visible = false  # Ocultar el botón de renta fija
	boton_renta_variable.visible = false  # Ocultar el botón de renta variable

	# Cargar la escena de renta variable
	var EscenaRentaVariable = load("res://interracion_renta_variable.tscn")  # Cambia la ruta si es necesario

	# Verificamos si la escena de renta variable se carga correctamente
	if EscenaRentaVariable is PackedScene:
		escena_renta_variable = EscenaRentaVariable.instantiate()  # Instanciamos la escena
		add_child(escena_renta_variable)  # Añadimos la escena a la jerarquía actual
		escena_renta_variable.visible = true  # Asegurar que la escena de renta variable esté visible
		
		# Conectar una señal para detectar cuando la escena termine
		escena_renta_variable.connect("tree_exited", Callable(self, "_on_renta_variable_terminada"))
	else:
		print("Error al cargar la escena de Renta Variable")

# Función que se ejecuta cuando termina la escena de renta variable
func _on_renta_variable_terminada():
	print("Escena de Renta Variable terminada.")
	resetear_visibilidad()  # Aseguramos que todo lo demás esté oculto
	boton_invertir.visible = true  # Mostrar el botón de invertir de nuevo

# Ejecuta el botón de Renta Fija
func _on_boton_renta_fija_pressed() -> void:
	resetear_visibilidad()  # Ocultar el botón de renta fija y otros elementos
	print("Botón 'Renta Fija' presionado. Mostrando cuadro de diálogo y texto.")

	# Mostrar el TextureRect y el RichTextLabel con la información
	dialog_box.visible = true
	dialog_text.visible = true
	dialog_text.text = "Los fondos de renta fija invierten en bonos.\nGanancia baja pero estable.\nIngrese la cantidad a invertir."  # Texto informativo sobre fondos de renta fija

	# Espera de 3 segundos antes de mostrar el input de cantidad
	await get_tree().create_timer(3.0).timeout
	
	# Ocultar el texto y mostrar el input para ingresar la cantidad y el botón de confirmar cantidad
	dialog_text.visible = false
	label_cantidad.text = "¿Cuánto deseas invertir en el fondo de renta fija?"
	label_cantidad.visible = true  # Mostrar el label de cantidad
	input_cantidad.visible = true  # Mostrar el input para la cantidad de inversión
	confirmar_cantidad_button.visible = true  # Mostrar el botón de confirmar cantidad

# Función que se ejecuta cuando se presiona el botón de confirmar cantidad
func _on_confirmar_inversion_pressed() -> void:
	# Verificar si se ha ingresado una cantidad válida
	var cantidad_text = input_cantidad.text.strip_edges()
	if cantidad_text == "":
		print("Por favor, ingrese una cantidad válida.")
		return
	
	# Si la cantidad es válida, continuar con el flujo de inversión
	resetear_visibilidad()  # Ocultar el input de cantidad y el botón de confirmación de cantidad
	print("Cantidad ingresada: " + cantidad_text)
	
	# Mostrar las opciones de plazo y el texto de plazo
	label_plazo.text = "¿A qué plazo deseas hacer tu inversión?"
	label_plazo.visible = true  # Mostrar el label de plazo
	plazo_opciones.visible = true  # Mostrar las opciones de inversión
	confirmar_plazo.visible = true  # Mostrar el botón de confirmar plazo
	dialog_box.visible = true

# Función que se ejecuta cuando se presiona el botón de confirmar plazo
func _on_confirmarplazo_pressed() -> void:
	print("Plazo confirmado. Calculando resultados...")
	
	# Ocultar opciones de plazo y botón de confirmar
	plazo_opciones.visible = false  # Ocultar las opciones de inversión
	confirmar_plazo.visible = false  # Ocultar el botón de confirmar plazo
	label_plazo.visible = false
	
	# Obtenemos el plazo seleccionado
	var plazo_seleccionado = plazo_opciones.selected
	
	# Variables para gestionar la probabilidad de ganancia/pérdida
	var tasa_retorno = 0.0
	var ganancia = 0.0
	var cantidad = input_cantidad.text.to_int()
	
	match plazo_seleccionado:
		0:  # Corto plazo: Mayor probabilidad de ganancia, pero bajas ganancias
			tasa_retorno = randf_range(0.001, 0.05)
			if randi() % 10 == 0:  # 10% probabilidad de pérdida
				tasa_retorno *= -1
			print("Corto plazo seleccionado")
		1:  # Mediano plazo: 50% probabilidad de ganancia o pérdida, ganancias moderadas
			tasa_retorno = randf_range(-0.05, 0.1)
			print("Mediano plazo seleccionado")
		2:  # Largo plazo: Mayor probabilidad de pérdida, pero si hay ganancia es pequeña
			tasa_retorno = randf_range(-0.1, 0.05)
			print("Largo plazo seleccionado")
	
	# Calcula y muestra los resultados
	ganancia = round(cantidad * tasa_retorno * 100) / 100.0
	var total = round((cantidad + ganancia) * 100) / 100.0
	label_resultado.text = "Inversión completada.\nResultado: $" + str(ganancia) + "\nTotal recibido: $" + str(total)
	label_resultado.visible = true  # Mostrar los resultados en el LabelResultado
	
	# Espera de 3 segundos antes de volver a mostrar el botón de invertir
	await get_tree().create_timer(3.0).timeout
	resetear_visibilidad()  # Asegurar que todo esté oculto nuevamente
	boton_invertir.visible = true  # Mostrar el botón de invertir de nuevo
