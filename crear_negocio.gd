extends Node2D

# Referencias a las capas de TileMap en la escena para la heladería
@onready var estructura_principal_tilemap = $Cream
@onready var ventanas_tilemap = $ventanas
@onready var puerta_tilemap = $techo
@onready var techo_tilemap = $tejado
@onready var heladeria_button = $heladeria  # Botón para activar la construcción de heladería
@onready var jefe = $jefe  # Primer obrero, supervisor para heladería
@onready var obrero1 = $obreroP  # Segundo obrero para heladería
@onready var obrero2 = $obreroM  # Tercer obrero para heladería

# Referencias para el mercado
@onready var marker_tilemap = $Marker
@onready var puertaM_tilemap = $puertaM
@onready var techoM_tilemap = $techoM
@onready var mercado_button = $mercado  # Botón para activar la construcción de mercado
@onready var jefe2 = $jefe2  # Primer obrero, supervisor para mercado
@onready var obrero3 = $obrero3  # Segundo obrero para mercado
@onready var obrero4 = $obrero4  # Tercer obrero para mercado

# Referencias para el McDonald's
@onready var mac_tilemap = $Mac
@onready var pisomac_tilemap = $pisomac
@onready var techomac_tilemap = $techomac
@onready var Mac_button = $Macdonal  # Botón para activar la construcción de McDonald's
@onready var jefe3 = $jefe3  # Primer obrero, supervisor para McDonald's
@onready var obrero5 = $obrero5  # Segundo obrero para McDonald's
@onready var obrero6 = $obrero6  # Tercer obrero para McDonald's
@onready var panel_ui = $PanelUI  # Referencia al panel UI
@onready var colorclick = $ColorRect


func _ready():
	# Ocultar todas las capas de la construcción y los obreros al inicio para heladería
	estructura_principal_tilemap.visible = false
	ventanas_tilemap.visible = false
	puerta_tilemap.visible = false
	techo_tilemap.visible = false
	jefe.visible = false
	obrero1.visible = false
	obrero2.visible = false
	
	# Ocultar todas las capas de construcción y los obreros al inicio para mercado
	marker_tilemap.visible = false
	puertaM_tilemap.visible = false
	techoM_tilemap.visible = false
	jefe2.visible = false
	obrero3.visible = false
	obrero4.visible = false
	
	# Ocultar todas las capas de construcción y los obreros al inicio para McDonald's
	mac_tilemap.visible = false
	pisomac_tilemap.visible = false
	techomac_tilemap.visible = false
	jefe3.visible = false
	obrero5.visible = false
	obrero6.visible = false
	panel_ui.visible = false
	
	# Conectar los botones de construcción para heladería, mercado y McDonald's
	heladeria_button.connect("pressed", Callable(self, "_on_heladeria_pressed"))
	mercado_button.connect("pressed", Callable(self, "_on_mercado_pressed"))
	Mac_button.connect("pressed", Callable(self, "_on_macdonals_pressed"))



# Función para ocultar las capas de heladería y mostrar cada capa de construcción
func mostrar_capas_heladeria_progresivamente():
	await get_tree().create_timer(1.0).timeout  # Espera inicial antes de comenzar
	estructura_principal_tilemap.visible = false  # Muestra la estructura principal

	await get_tree().create_timer(1.0).timeout
	ventanas_tilemap.visible = true  # Muestra las ventanas

	await get_tree().create_timer(1.0).timeout
	puerta_tilemap.visible = true  # Muestra la puerta

	await get_tree().create_timer(1.0).timeout
	techo_tilemap.visible = true  # Muestra el techo

	await get_tree().create_timer(1.0).timeout
	# Heladería completa al final
	# Puedes agregar más pasos si es necesario

	# Ocultar los obreros y volver a mostrar el botón de heladería
	await get_tree().create_timer(1.0).timeout
	jefe.visible = false
	obrero1.visible = false
	obrero2.visible = false
	heladeria_button.visible = false
	estructura_principal_tilemap.visible = true # Muestra la estructura principal

# Función para mostrar cada capa del edificio de mercado gradualmente, ocultando la anterior
func mostrar_capas_mercado_progresivamente():
	await get_tree().create_timer(1.0).timeout  # Espera inicial antes de comenzar
	marker_tilemap.visible = false  # Muestra la estructura principal de mercado

	await get_tree().create_timer(1.0).timeout
	puertaM_tilemap.visible = true  # Muestra la puerta de mercado

	await get_tree().create_timer(1.0).timeout
	techoM_tilemap.visible = true  # Muestra el techo de mercado

	await get_tree().create_timer(1.0).timeout
	# Mercado completo al final
	# Puedes agregar más pasos si es necesario

	# Ocultar los obreros y volver a mostrar el botón de mercado
	await get_tree().create_timer(1.0).timeout
	jefe2.visible = false
	obrero3.visible = false
	obrero4.visible = false
	mercado_button.visible = false
	marker_tilemap.visible = true

# Función para mostrar cada capa del edificio de McDonald's gradualmente, ocultando la anterior
func mostrar_capas_macdonals_progresivamente():
	await get_tree().create_timer(1.0).timeout  # Espera inicial antes de comenzar
	mac_tilemap.visible = false  # Muestra la estructura principal de McDonald's

	await get_tree().create_timer(1.0).timeout
	pisomac_tilemap.visible = true  # Muestra el piso de McDonald's

	await get_tree().create_timer(1.0).timeout
	techomac_tilemap.visible = true  # Muestra el techo de McDonald's

	await get_tree().create_timer(1.0).timeout
	# McDonald's completo al final
	# Puedes agregar más pasos si es necesario

	# Ocultar los obreros y volver a mostrar el botón de McDonald's
	await get_tree().create_timer(1.0).timeout
	jefe3.visible = false
	obrero5.visible = false
	obrero6.visible = false
	Mac_button.visible = false
	mac_tilemap.visible = true

# Función que se llama cuando se presiona el botón de heladería
func _on_heladeria_pressed():
	# Ocultar el botón de heladería y mostrar los obreros
	heladeria_button.visible = false
	jefe.visible = true
	obrero1.visible = true
	obrero2.visible = true

	# Reproducir las animaciones de los obreros
	jefe.play("default")
	obrero1.play("default")
	obrero2.play("default")

	# Iniciar el proceso de construcción gradual para heladería
	mostrar_capas_heladeria_progresivamente()

# Función que se llama cuando se presiona el botón de mercado
func _on_mercado_pressed():
	# Ocultar el botón de mercado y mostrar los obreros
	mercado_button.visible = false
	jefe2.visible = true
	obrero3.visible = true
	obrero4.visible = true

	# Reproducir las animaciones de los obreros para el mercado
	jefe2.play("default")
	obrero3.play("default")
	obrero4.play("default")

	# Iniciar el proceso de construcción gradual para mercado
	mostrar_capas_mercado_progresivamente()

# Función que se llama cuando se presiona el botón de McDonald's
func _on_macdonals_pressed():
	# Ocultar el botón de McDonald's y mostrar los obreros
	Mac_button.visible = false
	jefe3.visible = true
	obrero5.visible = true
	obrero6.visible = true

	# Reproducir las animaciones de los obreros para McDonald's
	jefe3.play("default")
	obrero5.play("default")
	obrero6.play("default")

	# Iniciar el proceso de construcción gradual para McDonald's
	mostrar_capas_macdonals_progresivamente()


func _on_color_rect_gui_input(event: InputEvent) -> void:
	# Verifica si el evento es un clic del botón izquierdo del mouse
	if event is InputEventMouseButton and event.button_index == MouseButton.LEFT_BUTTON and event.pressed:
		panel_ui.visible = true  # Muestra el panel UI
		print("Panel mostrado: ", panel_ui.visible)  # Debug opcional para verificar que el panel se muestra
