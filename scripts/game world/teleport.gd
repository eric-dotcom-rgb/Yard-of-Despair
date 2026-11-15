extends Area2D

@export var destination: Marker2D
@export var fade_duration: float = 0.3

var is_teleporting: bool = false   #impedisce che si bugghi il teletrasporto ripetendosi

func _ready() -> void:
	body_entered.connect(_on_body_entered)  #collega sensore dell'area alla funzione dopo

#riceve l'oggetto che attraversa l'area
func _on_body_entered(body: Node2D) -> void:
	if body.name == "player" and destination != null and not is_teleporting:
		_teleport_with_fade(body)

#gestisce dissolvenza e spostamento
func _teleport_with_fade(player: Node2D) -> void:
	is_teleporting = true
	
	var fade_screen: ColorRect = get_tree().current_scene.get_node_or_null("hud/portal transition")
	
	if fade_screen:
		#per dissolvere la scena con animazione
		var tween_out = create_tween()
		tween_out.tween_property(fade_screen, "color:a", 1.0, fade_duration)
		await tween_out.finished
		
		#teletrasporta player
		player.global_position = destination.global_position
		
		#per riaprire la visuale con animazione
		var tween_in = create_tween()
		tween_in.tween_property(fade_screen, "color:a", 0.0, fade_duration)
		await tween_in.finished
	is_teleporting = false
