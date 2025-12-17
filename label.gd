extends Label

var updateText:float = 0
@export var drawLines:CurveDrawing
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	updateText += delta
	if updateText > 0.5:
		updateText = 0
		text = str("fps:" ,Engine.get_frames_per_second(),"\n")
		if drawLines != null:
			text += str("Point: " , drawLines.numberPoints)
	
