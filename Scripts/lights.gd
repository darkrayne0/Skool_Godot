extends Area3D

var toggle = false #todo - put this variable into the lights and toggle from there it should work for any lights this switch is attched to... maybe

@export var lights: SpotLight3D
@export var sound: AudioStreamPlayer
#temp - not sure what lights I want of where but here is a place holder :)
#opt - probably make each switch a seperate set of lights as is 2 switches in the same room activate weirdly
#otherwise could prolly do something like get_node("SpotLight3D path").visable and do some rewriting...
func interact():
	if toggle:
		lights.hide()
		sound.play(0.1)
	else:
		lights.show()
		sound.play(0.1)
	toggle = !toggle
