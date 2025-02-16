extends Node3D

var rotation_index = 1.0

@export var carousel: CSGCylinder3D

@onready var current_rotation = carousel.rotation.y


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func rotate_carousel(degrees: float):
	var tween = create_tween()
	var target_rotation = current_rotation + deg_to_rad(degrees)

	tween.tween_property($Carousel, "rotation:y", target_rotation, 0.5)

	await tween.finished

	current_rotation = carousel.rotation.y
	#else:
		#await tween.tween_property($Carousel, "rotation:y", -target_rotation, 0.5)
		#current_rotation = carousel.rotation.y
	rotation_index += 1
