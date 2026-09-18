extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var cloud: Sprite2D = $Cloud
@onready var rhino: Sprite2D = $Cloud/Rhino
@onready var label: Label = $Cloud/Label

func _ready() -> void:
	animation_player.play( "first_slam" )
	await animation_player.animation_finished
	
	var tween = create_tween()
	tween.tween_property( cloud.material, "shader_parameter/dissolve_amount", 1.0, 1.5 )
	tween.parallel().tween_property( rhino.material, "shader_parameter/dissolve_amount", 1.0, 1.5 )
	tween.parallel().tween_property(label, "modulate:a", 0.0, 1.5)
	tween.finished.connect(queue_free)
	pass
	
