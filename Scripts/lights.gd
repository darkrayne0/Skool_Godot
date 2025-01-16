extends Area3D

var toggle = false

@export var lights: SpotLight3D
@onready var sound: AudioStreamPlayer = $"../../../../Audio/Lights"
#temp - not sure what lights I want of where but here is a place holder :)
#opt - probably make each switch a seperate set of lights as is 2 switches in the same room activate weirdly
#otherwise could prolly do something like get_node("SpotLight3D path").visable and do some rewriting...
func interact():
	lights_toggle()
	toggle = !toggle


func lights_toggle():
		if toggle:
			lights.hide()
			sound.play(0.1)
			print("off")
		else:
			lights.show()
			sound.play(0.1)
			print("on")
