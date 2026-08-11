extends Area2D

func _on_area_entered(area: Area2D) -> void:
	if area.get_tree().get_first_node_in_group("bossDano"):
		area.queue_free()
