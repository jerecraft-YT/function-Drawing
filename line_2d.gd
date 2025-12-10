extends Line2D

var numberPoints = 32
var amp = 150
var puntos:PackedVector2Array = []
@export var poligono:Polygon2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var progress = 1.0 / numberPoints
	for i in range(numberPoints):
		puntos.append(Vector2(cos(deg_to_rad(360*i*progress))*amp,sin(deg_to_rad(360*i*progress))*amp))
	points = puntos
	poligono.polygon = puntos


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
