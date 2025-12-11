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
@export var updateLines:bool = true
@export var baseStartAMP:float = 50
@export var baseFinalAMP:float = 200
@export var lowDefinition:float = 4
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
	if updateLines == true:
		funcion = SpiralType.keys()[spiral_type]
		calculateSpiral()
		queue_redraw()
	
	if Input.is_action_pressed("ui_down"):
		startAMP -= 1
		finalAMP -= 1
	if Input.is_action_pressed("ui_up"):
		startAMP += 1
		finalAMP += 1
	#startAMP = max(startAMP,50)
	#finalAMP = max(finalAMP,50)
func calculateSpiral():
	var ampToGetBase = (baseFinalAMP - baseStartAMP)
	var ampToGet = finalAMP - startAMP
	var angleToGet = (finalAngle - startAngle) * progressConsum
	var sobrante = 1 - progressConsum
	
	numberPoints = ceil(angleToGet / max(lowDefinition,0.1))
	progressConsum = ampToGet / ampToGetBase
	
	var progresoPaso = 1.0 / numberPoints
	
	if puntos.size() != numberPoints + 1:
		puntos.resize(numberPoints + 1)
	for i in range(numberPoints+1):
		var progresoActual = (i * progresoPaso)
		var progresoFuncion = DataGame.call(funcion,sobrante + progresoActual * progressConsum)
		var angleActual = deg_to_rad(finalAngle - (angleToGet * progresoFuncion))
		var ampActual = finalAMP - (ampToGet * progresoActual)
		puntos[i] = Vector2(
			functionOffset.x + cos(angleActual) * ampActual,
			functionOffset.y - sin(angleActual) * ampActual
		)
func _draw() -> void:
	draw_polyline(puntos,colorLine,lineWidth)
