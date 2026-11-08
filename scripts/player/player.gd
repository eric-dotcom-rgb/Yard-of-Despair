extends CharacterBody2D

enum State {
	IDLE,
	WALK,
	FARM,
	SEED
}
@export_category("Stats")
@export var speed: int = 100
@export var farm_speed: float = 1.5
var seed_speed: float = 2.7

var state: State = State.IDLE
var move_direction: Vector2 = Vector2(0,0)

@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_playback: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

func _ready() -> void:           #cosi nel gioco il Tree rimane sempre acceso anche se sull editor lo spegniamo
	animation_tree.set_active(true)
	
func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.keycode == KEY_F and event.pressed and not event.echo:
		farm()
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		pick_up()

func _physics_process(_delta: float) -> void:
	if not state == State.FARM and not state ==State.SEED:
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
		State.SEED:
			animation_playback.travel("seed")
			
func _get_target_grid() -> Array:
	var mouse_pos: Vector2 = get_global_mouse_position()
	var dir: Vector2 = (mouse_pos - global_position).normalized()
	var dirt_layer = get_parent().get_node("tiles/dirt")
	var hit_pos = global_position + (dir * 16)
	return [dirt_layer.local_to_map(hit_pos), dir, dirt_layer]

#zappare
func farm() -> void:
	if state == State.FARM:
		return
	var target_info = _get_target_grid()
	var target_grid: Vector2i = target_info[0]
	var farm_dir: Vector2 = target_info[1]
	var dirt_layer: TileMapLayer = target_info[2]
	
	var world_node = get_parent()
	var current_dirt_source = dirt_layer.get_cell_source_id(target_grid)
	var current_dirt_atlas = dirt_layer.get_cell_atlas_coords(target_grid)
	var hotbar = world_node.get_node("hud/hotbar")
	
	#controlla cella
	var is_dirt: bool = (current_dirt_source == 0 or current_dirt_source == 1 and current_dirt_atlas == Vector2i(0,0))
	var is_plant: bool = (world_node.active_crops.has(target_grid) and world_node.active_crops[target_grid]["stage"] < 2)
	
	#se non è niente, non fare l'animazione
	if not is_dirt and not is_plant:
		return
	
	#animazione
	state = State.FARM
	velocity = Vector2.ZERO
	$Sprite2D.flip_h = farm_dir.x < 0.01 and abs(farm_dir.x) >= abs(farm_dir.y)
	animation_tree.set("parameters/farm/BlendSpace2D/blend_position", farm_dir)
	update_animation()

	#toglie pianta e ti da il seme o zappa la dirt normalmente
	if is_plant:
		var returned_crop = world_node.farm(target_grid)
		if returned_crop != null:
			hotbar.add_seed(returned_crop)
	elif is_dirt:
		if world_node.has_method("change_tile"):
			world_node.change_tile(target_grid, 2, Vector2i(0,0))
		
	await get_tree().create_timer(farm_speed).timeout
	state = State.IDLE

func pick_up() -> void:
	if state == State.FARM:
		return
		
	var target_info = _get_target_grid()
	var target_grid: Vector2i = target_info[0]
	var seed_dir: Vector2 = target_info[1]
	var dirt_layer: TileMapLayer = target_info[2]
	
	var world_node = get_parent()
	var current_dirt_source = dirt_layer.get_cell_source_id(target_grid)
	var hotbar = world_node.get_node("hud/hotbar")
	
	var harvested = world_node.try_harvest(target_grid)
	
	#prova a raccogliere il crop
	if harvested !=null:
		hotbar.add_harvested(harvested)
		return
	
	#controlla cosa ce sul terreno e se è gia farmato cosi può piantare
	if current_dirt_source == 2 and not world_node.active_crops.has(target_grid):
		var selected_crop = hotbar.get_selected_crop()
		if selected_crop != null:
			state = State.SEED
			velocity = Vector2.ZERO
			$Sprite2D.flip_h = seed_dir.x < 0.01 and abs(seed_dir.x) >= abs(seed_dir.y)
			animation_tree.set("parameters/seed/BlendSpace2D/blend_position", seed_dir)
			update_animation()
			
			world_node.plant_crop(target_grid, selected_crop)
			hotbar.consume_seed(selected_crop)
			
			await get_tree().create_timer(seed_speed).timeout
			state = State.IDLE
