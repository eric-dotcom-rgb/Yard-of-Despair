extends CharacterBody2D

enum State {
	IDLE,
	WALK,
	FARM
}
@export_category("Stats")
@export var speed: int = 100
@export var farm_speed: float = 1.5

var state: State = State.IDLE
var move_direction: Vector2 = Vector2(0,0)

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

func _ready() -> void:           #cosi nel gioco il Tree rimane sempre acceso anche se sull editor lo spegniamo
	animation_tree.set_active(true)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		farm()

func _physics_process(_delta: float) -> void:
	if not state == State.FARM:
		movement_loop()

func movement_loop() -> void:
	move_direction.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	move_direction.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	var motion:Vector2 = move_direction.normalized() * speed
	set_velocity(motion)
	move_and_slide()
	
	#per flipparlo destra/sinistra
	if state == State.IDLE or State.WALK:
		if move_direction.x < -0.01:
			$Sprite2D.flip_h = true
		elif move_direction.x > 0.01:
			$Sprite2D.flip_h = false
	
	if motion != Vector2.ZERO and state == State.IDLE:     #per capire: vettore zero è la proprietà che dice che si premono i tasti, state idle è 'fermo'
		state = State.WALK        #quindi se si stan premendo i tasti ma il giocatore è fermo, vuol dire che deve passare ad animazione walk
		update_animation( )
	elif motion == Vector2.ZERO and state == State.WALK:
		state = State.IDLE
		update_animation( )

func update_animation() -> void:
	match state:
		State.IDLE:
			animation_playback.travel("idle")
		State.WALK:
			animation_playback.travel("walk")
		State.FARM:
			animation_playback.travel("farm")

func farm() -> void:
	if state == State.FARM:
		return
	state = State.FARM
	
	velocity = Vector2.ZERO
	var mouse_pos: Vector2 = get_global_mouse_position()
	var farm_dir: Vector2 = (mouse_pos - global_position).normalized()
	$Sprite2D.flip_h = farm_dir.x < 0.01 and abs(farm_dir.x) >= abs(farm_dir.y)
	animation_tree.set("parameters/farm/BlendSpace2D/blend_position", farm_dir)
	update_animation()
	
	var world_node = get_parent()
	var dirt_layer = world_node.get_node("tiles/dirt")
	
	var _player_grid = dirt_layer.local_to_map(global_position)
	var hit_global_position = global_position + (farm_dir * 16)
	var target_grid = dirt_layer.local_to_map(hit_global_position)
	
	var current_dirt_source = dirt_layer.get_cell_source_id(target_grid)
	var current_dirt_atlas = dirt_layer.get_cell_atlas_coords(target_grid)
	
	var inventory = world_node.get_node("hud/inventory")
	
	var harvested = world_node.try_harvest(target_grid)

	#prova a raccogliere
	if harvested != null:
		inventory.add_harvested(harvested)
		print("Hai raccolto: ", harvested.crop_name)
	
	#controlla cosa ce sul terreno se è gia farmato
	elif current_dirt_source == 2:
		var selected_crop = inventory.get_selected_crop()
		if selected_crop != null:
			world_node.plant_crop(target_grid, selected_crop)
			inventory.consume_seed(selected_crop)
			
	elif current_dirt_atlas == Vector2i(0,0):
		if world_node.has_method("change_tile"):
			world_node.change_tile(target_grid, 2, Vector2i(0,0))
		
	await get_tree().create_timer(farm_speed).timeout
	state = State.IDLE
	
