@icon( "res://general/icons/collectable.svg" )
class_name CollectableArea extends Area2D

func _ready() -> void:
	body_entered.connect( _on_body_entered )
	area_entered.connect( _on_body_entered )
	visible = false
	monitorable = false
	monitoring = false
	pass


func _on_body_entered( body : Node2D ) -> void:
	if body is CollectableArea:
		body.take_damage( self )
		var pos : Vector2 = global_position
		pos.x = body.global_position.x
	pass
