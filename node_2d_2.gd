extends Node2D

@onready var spiral = $OptimizedRadialSpiral

func _ready() -> void:
	# Configurar espiral similar a CupiSpiral
	# Igual que CupiSpiral
	spiral.set_angles(0, 360)
	spiral.set_amplitudes(100, 300)
	spiral.set_easing_by_name("easeInOutBack")
	spiral.update_progress(0.75)  # 75% completado
	
	# Configurar apariencia
	spiral.line_color = Color(0.2, 0.8, 1.0)  # Azul claro
	spiral.line_width = 3.0

func _process(delta: float) -> void:
	# Control manual del progreso con teclas
	if Input.is_action_pressed("ui_right"):
		spiral.update_progress(spiral.progreso_spiral + delta * 0.5)
	if Input.is_action_pressed("ui_left"):
		spiral.update_progress(spiral.progreso_spiral - delta * 0.5)
	
	# Cambiar easing con teclas numéricas
	if Input.is_action_just_pressed("key_1"):
		spiral.set_easing_by_name("linear")
		print("Easing: Linear")
	if Input.is_action_just_pressed("key_2"):
		spiral.set_easing_by_name("easeInOutSine")
		print("Easing: Sine")
	if Input.is_action_just_pressed("key_3"):
		spiral.set_easing_by_name("easeInOutCubic")
		print("Easing: Cubic")
	
	# Alternar relleno
	if Input.is_action_just_pressed("ui_select"):
		spiral.use_filled = !spiral.use_filled
		print("Relleno: ", spiral.use_filled)
