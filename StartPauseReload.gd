extends Button


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var play_icon = load("res://images/buttons/play.png")
var restart_icon =load("res://images/buttons/restart.png")
var pause_icon =load("res://images/buttons/pause.png")
var curr_button = "start"

# Called when the node enters the scene tree for the first time.
func _ready():
	self.icon = play_icon


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _start():
	get_parent()._start_play()
	self.icon = pause_icon
	curr_button = "pause"
	
func _restart():
	_start()
	
func _pause():
	self.icon = play_icon
	curr_button = "continue"
	get_tree().paused = true
	
func _play_continue():
	self.icon = pause_icon
	curr_button = "pause"
	get_tree().paused = false


func _on_StartPauseReload_pressed():
	if curr_button == "start":
		_start()
	elif curr_button == "pause":
		_pause()
	elif curr_button == "restart":
		_restart()
	elif curr_button == "continue":
		_play_continue()
	else:
		pass
		
func _game_finished():
	self.icon = restart_icon
	curr_button = "restart"
