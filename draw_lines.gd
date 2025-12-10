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
@export var progressConsum:float = 1.0
@export var diference:float
var funcion:String
enum SpiralType {linear,easeInSine,easeOutSine,easeInOutSine,easeInCubic,easeOutCubic,easeInOutCubic,easeInQuint,easeOutQuint,easeInOutQuint,easeInCirc,easeOutCirc,
	easeInOutCirc,easeInElastic,easeOutElastic,easeInOutElastic,easeInQuad,easeOutQuad,
	easeInOutQuad,easeInBack,easeOutBack,easeInOutBack,easeInBounce,easeOutBounce,
	easeInOutBounce}

@export var spiral_type: SpiralType = SpiralType.linear

func _ready() -> void:
	funcion = SpiralType.keys()[spiral_type]
	print(funcion)
	calculateSpiral()

# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	funcion = SpiralType.keys()[spiral_type]
	calculateSpiral()
	queue_redraw()

func calculateSpiral():
	if puntos.size() != numberPoints + 1:
		puntos.resize(numberPoints + 1)
	
	var ampToGet = (finalAMP - startAMP) * progressConsum
	var angleToGet = (finalAngle - startAngle) * progressConsum
	var progresoPaso = 1.0 / numberPoints
	var sobrante = 1 - progressConsum
	for i in range(numberPoints+1):
		var progresoActual = (i * progresoPaso)
		var progresoFuncion = DataGame.call(funcion,sobrante + progresoActual)
		var angleActual = deg_to_rad(finalAngle - (angleToGet * progresoFuncion))
		var ampActual = finalAMP - (ampToGet * progresoActual)
		puntos[i] = Vector2(
			functionOffset.x + cos(angleActual) * ampActual,
			functionOffset.y - sin(angleActual) * ampActual
		)
func _draw() -> void:
	draw_polyline(puntos,colorLine,lineWidth)
