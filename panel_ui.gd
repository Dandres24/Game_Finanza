extends Control

# Referencias a los nodos
@onready var imagen_producto_grande = $HBoxContainer/ImagenProductoGrande
@onready var nombre_producto_label = $HBoxContainer2/NombreProducto
@onready var precio_producto_label = $HBoxContainer2/PrecioProducto
@onready var boton_confirmar = $boton_confirmar

# Información de los productos
var productos = {
	"producto_hamburguesa": {"imagen": preload("res://icon/hamburguesa-icon.png"), "nombre": "Hamburguesa", "precio": 10000},
	"producto_hotdog": {"imagen": preload("res://icon/hotdog-icon.png"), "nombre": "Hot Dog", "precio": 5000},
	"producto_papas": {"imagen": preload("res://icon/papas-fritas-icon.png"), "nombre": "Papas Fritas", "precio": 3000},
	# Añade más productos aquí
}

# Configura los botones para cada producto
func _ready():
	for producto_id in productos.keys():
		var boton = $TextureRect/GridContainer.get_node(producto_id)
		boton.connect("pressed", Callable(self, "_on_producto_seleccionado").bind(producto_id))

# Función para cuando un producto es seleccionado
func _on_producto_seleccionado(producto_id):
	var producto = productos[producto_id]
	imagen_producto_grande.texture = producto["imagen"]
	nombre_producto_label.text = producto["nombre"]
	precio_producto_label.text = "Precio: $" + str(producto["precio"])

# Función para el botón de confirmar
func _on_boton_confirmar_pressed():
	var producto_seleccionado = nombre_producto_label.text
	var precio = precio_producto_label.text.split("$")[1].to_int()
	print("Confirmado: ", producto_seleccionado, " con precio de ", precio)
