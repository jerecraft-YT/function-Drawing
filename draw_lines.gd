class_name CurveDrawing
extends Node2D

var puntos: PackedVector2Array = []

@export var easing_func: Callable
@export var colorLine: Color
@export var functionOffset: Vector2

@export var baseStartAMP: float = 50
@export var baseFinalAMP: float = 200
@export var actualStartAMP: float = 50
@export var actualFinalAMP: float = 200

@export var startAngle: float = 0
@export var finalAngle: float = 180

@export var lineWidth: int = 10
@export var numberPoints: int = 64
@export var progressConsum: float = 1.0
@export var updateLines: bool = true
@export var lowDefinition: float = 4

@export var ripple_amplitude: float = 0.0
@export var ripple_frequency: float = 10.0
@export var ripple_start_smooth: float = 0.01
@export var ripple_end_smooth: float = 0.99
var funcion: String
var prevFuncion: String

enum SpiralType {
	linear, easeInSine, easeOutSine, easeInOutSine,
	easeInCubic, easeOutCubic, easeInOutCubic,
	easeInQuint, easeOutQuint, easeInOutQuint,
	easeInCirc, easeOutCirc, easeInOutCirc,
	easeInElastic, easeOutElastic, easeInOutElastic,
	easeInQuad, easeOutQuad, easeInOutQuad,
	easeInBack, easeOutBack, easeInOutBack,
	easeInBounce, easeOutBounce, easeInOutBounce
}

@export var spiral_type: SpiralType = SpiralType.linear

func _ready() -> void:
	funcion = SpiralType.keys()[spiral_type]
	calculateSpiral()

@warning_ignore("unused_parameter")
func _physics_process(delta: float) -> void:
	if updateLines:
		funcion = SpiralType.keys()[spiral_type]
		calculateSpiral()
		queue_redraw()

	if Input.is_action_pressed("ui_down"):
		actualStartAMP -= 1
		actualFinalAMP -= 1

	if Input.is_action_pressed("ui_up"):
		actualStartAMP += 1
		actualFinalAMP += 1

func calculateSpiral() -> void:
	if prevFuncion != funcion:
		easing_func = DataGame.get(funcion)
		prevFuncion = funcion
	
	# --- AMPLITUD BASE Y ACTUAL ---
	var ampToGetBase := baseFinalAMP - baseStartAMP
	var ampToGet := actualFinalAMP - actualStartAMP

	# --- PROGRESO DE CONSUMO (CORTE) ---
	progressConsum = clamp(ampToGet / ampToGetBase, 0.0, 1.0)
	#var sobrante :float= 1.0 - progressConsum

	# --- START ANGLE DINÁMICO (FINAL ANGLE FIJO) ---
	var dynamicStartAngle :float= lerp(finalAngle, startAngle, progressConsum)

	# --- CANTIDAD DE PUNTOS ---
	var angleToGet :float= abs(finalAngle - dynamicStartAngle)
	numberPoints = max(ceil(angleToGet / max(lowDefinition, 0.1)), 2)

	if ripple_amplitude != 0:
		numberPoints += int(ripple_amplitude * (ripple_frequency / 10.0))

	var progresoPaso := 1.0 / numberPoints

	if puntos.size() != numberPoints + 1:
		puntos.resize(numberPoints + 1)

	# --- CONSTRUCCIÓN DE LA CURVA ---
	for i in range(numberPoints + 1):

		var progresoActual := i * progresoPaso
		var progresoFuncion :float= easing_func.call(progresoActual)

		# --- AMPLITUD ACTUAL ---
		var ampActual := actualFinalAMP - (ampToGet * progresoActual)

		# --- ÁNGULO BASE (FINAL FIJO) ---
		var baseAngle :float= lerp(finalAngle, dynamicStartAngle, progresoFuncion)

		# --- SUAVIZADO DEL RIPPLE ---
		var smooth_factor := 0.0
		if progresoActual >= ripple_start_smooth and progresoActual <= ripple_end_smooth:
			var normalized_progress := (progresoActual - ripple_start_smooth) / (ripple_end_smooth - ripple_start_smooth)
			smooth_factor = sin(normalized_progress * PI)

		var ripple := cos(progresoActual * ripple_frequency) * ripple_amplitude * smooth_factor
		var angleActual := deg_to_rad(baseAngle + ripple)

		puntos[i] = Vector2(
			functionOffset.x + cos(angleActual) * ampActual,
			functionOffset.y - sin(angleActual) * ampActual
		)

func _draw() -> void:
	draw_polyline(puntos, colorLine, lineWidth)
