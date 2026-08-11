extends HSlider

@export var audio_nome : String  
var audio_id 

func _ready() -> void:
	audio_id = AudioServer.get_bus_index(audio_nome)

func _on_value_changed(value: float) -> void:
	var db = linear_to_db(value)
	AudioServer.set_bus_volume_db(audio_id, db)
