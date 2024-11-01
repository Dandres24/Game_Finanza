extends Control

@onready var barra_progreso = $VBoxContainer/ProgressBar 
@onready var hbox_container = $VBoxContainer/HBoxContainer  
@onready var panel_resultados = $Panel
@onready var label_resultados = $Panel/LabelResultados  

var tasa_interes = 0.0
var tiempo_espera = 0.0
var cantidad_invertida = 0  
var temporizador = null

# Ajustar la cantidad invertida recibida de interaccion_bonos
func set_cantidad_invertida(nueva_cantidad):
	cantidad_invertida = nueva_cantidad
	print("Cantidad invertida actualizada a:", cantidad_invertida)

func _ready():
	if barra_progreso != null:
		barra_progreso.visible = false  
	else:
		print("Error: barra_progreso no se encontró.")

	if hbox_container != null:
		hbox_container.visible = true  # Aseguramos que esté visible al inicio
	else:
		print("Error: hbox_container no se encontró.")
		
	if panel_resultados != null:
		panel_resultados.visible = false  
	else:
		print("Error: panel_resultados no se encontró.")
	
	if label_resultados != null:
		label_resultados.horizontal_alignment = 1  
		label_resultados.vertical_alignment = 1  
	else:
		print("Error: label_resultados no se encontró.")

	ajustar_tamano_barra()  

func ajustar_tamano_barra():
	if barra_progreso != null:
		barra_progreso.set_custom_minimum_size(Vector2(1200, 150))  

func _on_bono_1_pressed() -> void:
	tasa_interes = 0.03
	tiempo_espera = 5.0
	iniciar_inversion()

func _on_bono_2_pressed() -> void:
	tasa_interes = 0.05
	tiempo_espera = 10.0
	iniciar_inversion()

func _on_bono_3_pressed() -> void:
	tasa_interes = 0.08
	tiempo_espera = 15.0
	iniciar_inversion()

func iniciar_inversion():
	if barra_progreso != null:
		barra_progreso.visible = true  
	else:
		print("Error: barra_progreso no se encontró.")
		
	if hbox_container != null:
		hbox_container.visible = false  
	else:
		print("Error: hbox_container no se encontró.")
		
	print("Inversión iniciada con tasa de interés: ", tasa_interes)
	
	if barra_progreso != null:
		barra_progreso.max_value = tiempo_espera
		barra_progreso.value = 0

	temporizador = Timer.new()
	add_child(temporizador)
	
	# Verificar que el temporizador y el método de llamada sean válidos antes de conectar
	if temporizador != null and has_method("_on_timer_timeout"):
		temporizador.connect("timeout", Callable(self, "_on_timer_timeout"))
		temporizador.start(1.0)
		print("Temporizador iniciado para la inversión")
	else:
		print("Error al conectar el temporizador con '_on_timer_timeout'.")

func _on_timer_timeout():
	if barra_progreso != null and barra_progreso.value < barra_progreso.max_value:
		barra_progreso.value += 1
	else:
		var ganancia = cantidad_invertida * tasa_interes
		mostrar_resultados(ganancia)
		temporizador.queue_free()

func mostrar_resultados(ganancia):
	var total = cantidad_invertida + ganancia
	print("Inversión completada. Ganancia: ", ganancia, " Total recibido: ", total)
	
	if panel_resultados != null:
		panel_resultados.visible = true
	else:
		print("Error: panel_resultados no se encontró.")
	
	if label_resultados != null:
		label_resultados.text = "Inversión: " + str(cantidad_invertida) + "\nGanancia: " + str(ganancia) + "\nTotal: " + str(total)
	else:
		print("Error: label_resultados no se encontró.")
	
	if barra_progreso != null:
		barra_progreso.visible = false  
