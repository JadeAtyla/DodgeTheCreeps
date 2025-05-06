extends Node

@export var mob_scene: PackedScene
var score
# Called when the node enters the scene tree for the first time.
#func _ready() -> void:
	#new_game()
var maximum_spd = 350.0 # initial max_spd
var partition = 10 # every 10 scores up
var multiplier

func game_over() -> void:
	$ScoreTimer.stop()
	$MobTimer.stop()
	$StartTimer.stop()
	$HUD.show_game_over()
	
	$Music.stop()
	$DeathSound.play()

func new_game():
	score = 0
	multiplier = 1
	$Player.start($StartMarker.position)
	$StartTimer.start()
	$HUD.update_score(score)
	$HUD.update_multiplier(multiplier)
	$HUD.show_message("Get Ready")
	get_tree().call_group("mobs", "queue_free")
	
	$Music.play()

func _on_mob_timer_timeout() -> void:
	# Create a new instance of the Mob scene.
	var mob = mob_scene.instantiate()

	# Choose a random location on Path2D.
	var mob_spawn_location = $MobPath/MobSpawnLocation
	mob_spawn_location.progress_ratio = randf()

	# Set the mob's position to the random location.
	mob.position = mob_spawn_location.position

	# Set the mob's direction perpendicular to the path direction.
	var direction = mob_spawn_location.rotation + PI / 2

	# Add some randomness to the direction.
	direction += randf_range(-PI / 4, PI / 4)
	mob.rotation = direction
	
	# Choose the velocity for the mob.
	var velocity = Vector2(randf_range(250.0, maximum_spd*multiplier), 0.0)
	mob.linear_velocity = velocity.rotated(direction)
	
	add_child(mob)
	
	multiplier = (score/partition) if score/partition > 1 else 1 # sets the multiplier
	
	$HUD.update_score(score)
	$HUD.update_multiplier(multiplier)


func _on_score_timer_timeout() -> void:
	score+=1


func _on_start_timer_timeout() -> void:
	$ScoreTimer.start()
	$MobTimer.start()
