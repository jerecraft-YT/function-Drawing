extends Node2D

var puntos:PackedVector2Array = []
@export var colorLine:Color
@export var functionOffset:Vector2
@export var startAMP:float = 50
@export var finalAMP:float = 200
@export var startAngle:float = 0
@export var finalAngle:float = 180
@export var lineWidth:int
@export var numberPoints:int = 64

enum SpiralType {ARCHIMEDEAN, LOGARITHMIC, FERMAT, HYPERBOLIC}

@export var spiral_type: SpiralType = SpiralType.ARCHIMEDEAN

func _ready() -> void:
	calculateSpiral()

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	calculateSpiral()
	queue_redraw()

func calculateSpiral():
	if puntos.size() != numberPoints + 1:
		puntos.resize(numberPoints + 1)
	
	var ampToGet = finalAMP - startAMP
	var angleToGet = finalAngle - startAngle
	var progresoPaso = 1.0 / numberPoints
	
	for i in range(numberPoints+1):
		var progresoActual = (i * progresoPaso)
		var angleActual = deg_to_rad(startAngle + (angleToGet * progresoActual))
		var ampActual = startAMP + (ampToGet * progresoActual)
		puntos[i] = Vector2(
			functionOffset.x + cos(angleActual) * ampActual,
			functionOffset.y - sin(angleActual) * ampActual
		)
func _draw() -> void:
	draw_polyline(puntos,colorLine,lineWidth)
