extends Control

# Referencias para VBoxContainer3 - Fondo de Renta Variable
@onready var cuadro_dialogo = $VBoxContainer/TextureRect
@onready var rich_text = $VBoxContainer/TextureRect/dialog_text
@onready var button_tecnologia = $VBoxContainer/TextureRect/CategoriaTecnologia
@onready var button_medicina = $VBoxContainer/TextureRect/CategoriaMedicina
@onready var button_entretenimiento = $VBoxContainer/TextureRect/CategoriaEntretenimiento
@onready var button_nuevas_empresas = $VBoxContainer/TextureRect/CategoriaNuevasEmpresas
@onready var label_estilo = $VBoxContainer/TextureRect/LabelEstilo 
@onready var input_variable = $VBoxContainer/TextureRect/Inputvariable
@onready var confirmar_button_variable = $VBoxContainer/TextureRect/Inversionvariable
@onready var label_categoria_inversion = $VBoxContainer/TextureRect/LabelCategoriaInversion  # Label para el texto de categorías

# Configuración inicial
func _ready():
	# Al inicio, ocultamos todo
	resetear_visibilidad()

	# Iniciamos el flujo al cargar la escena sin necesidad de botones
	mostrar_intro_renta_variable()

# Función para resetear la visibilidad de todos los elementos al inicio
func resetear_visibilidad():
	button_tecnologia.visible = false
	button_medicina.visible = false
	button_entretenimiento.visible = false
	button_nuevas_empresas.visible = false
	label_estilo.visible = false
	input_variable.visible = false
	confirmar_button_variable.visible = false
	label_categoria_inversion.visible = false  # Ocultar el label al inicio
	cuadro_dialogo.visible = false
	rich_text.visible = false

# Función que se ejecuta al cargar la escena de renta variable
func mostrar_intro_renta_variable():
	# Mostramos el cuadro de diálogo y el texto, pero el resto de los botones sigue oculto hasta que el usuario seleccione una categoría
	resetear_visibilidad()
	cuadro_dialogo.visible = true
	rich_text.clear()
	rich_text.text = "Selecciona una categoría para comenzar tu inversión en renta variable."
	rich_text.visible = true
	
	# Espera de 3 segundos antes de mostrar las categorías
	await get_tree().create_timer(3.0).timeout
	
	# Mostrar las opciones de categorías después del diálogo inicial
	rich_text.visible = false
	button_tecnologia.visible = true
	button_medicina.visible = true
	button_entretenimiento.visible = true
	button_nuevas_empresas.visible = true
	label_categoria_inversion.text = "¿En qué tipo de acciones o empresas deseas invertir?"  # Texto para las categorías
	label_categoria_inversion.visible = true  # Mostrar el label

# Función para mostrar input y confirmación después de seleccionar una categoría
func mostrar_input_cantidad_variable():
	resetear_visibilidad()
	label_estilo.text = "¿Cuánto deseas invertir en esta categoría?"
	label_estilo.visible = true
	input_variable.visible = true
	confirmar_button_variable.visible = true
	cuadro_dialogo.visible = true

# Función para calcular y mostrar el resultado basado en la categoría elegida
func calcular_resultado_categoria(categoria: String):
	resetear_visibilidad()
	cuadro_dialogo.visible = true
	var tasa_retorno = 0.0
	var cantidad = input_variable.text.to_int()
	
	match categoria:
		"tecnologia":
			tasa_retorno = randf_range(-0.02, 0.1)
		"medicina":
			tasa_retorno = randf_range(-0.01, 0.05)
		"entretenimiento":
			tasa_retorno = randf_range(-0.1, 0.15)
		"nuevas_empresas":
			tasa_retorno = randf_range(-0.2, 0.3)

	# Calcula y redondea la ganancia y el total
	var ganancia = round(cantidad * tasa_retorno * 100) / 100.0
	var total = round((cantidad + ganancia) * 100) / 100.0
	rich_text.text = "Inversión en " + categoria.capitalize() + " completada.\nResultado: $" + str(ganancia) + "\nTotal recibido: $" + str(total)
	rich_text.visible = true
	
	await get_tree().create_timer(3.0).timeout
	cuadro_dialogo.visible = false

# Función para manejar el botón de confirmación de la cantidad ingresada en fondos de renta variable
func _on_confirmar_inversion_buttonvariable_pressed() -> void:
	var categoria = ""
	if button_tecnologia.visible and button_tecnologia.pressed:
		categoria = "tecnologia"
	elif button_medicina.visible and button_medicina.pressed:
		categoria = "medicina"
	elif button_entretenimiento.visible and button_entretenimiento.pressed:
		categoria = "entretenimiento"
	elif button_nuevas_empresas.visible and button_nuevas_empresas.pressed:
		categoria = "nuevas_empresas"
	calcular_resultado_categoria(categoria)

# Ejecuta los botones de categoría y llama a la función para mostrar el input
func _on_categoria_tecnologia_pressed() -> void:
	mostrar_input_cantidad_variable()

func _on_categoria_medicina_pressed() -> void:
	mostrar_input_cantidad_variable()

func _on_categoria_entretenimiento_pressed() -> void:
	mostrar_input_cantidad_variable()

func _on_categoria_nuevas_empresas_pressed() -> void:
	mostrar_input_cantidad_variable()
