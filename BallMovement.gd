extends PathFollow2D

var time_elapsed
var sequence_ocurring
var already_evaluated

const TIME_TO_REACH_BREAKPOINT = 0.5
const TIME_ON_BREAKPOINT = 0.3
const TIME_LEAVE_BREAKPOINT = 0.2

const COLOURS = [Color.red, Color.green, Color.greenyellow, Color.aquamarine, Color.purple, Color.darkblue, Color.bisque, Color.magenta, Color.maroon, Color.darkkhaki]
const NUMBER_COLOUR = Color.white
const BALL_STOP_OFFSET = 0.5556

# Called when the node enters the scene tree for the first time.
func _ready():
	sequence_ocurring = false
	already_evaluated = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !sequence_ocurring:
		return
	time_elapsed += delta
	if time_elapsed < TIME_TO_REACH_BREAKPOINT:
		unit_offset = (time_elapsed * BALL_STOP_OFFSET) / TIME_TO_REACH_BREAKPOINT
	elif time_elapsed < (TIME_TO_REACH_BREAKPOINT + TIME_ON_BREAKPOINT):
		if !already_evaluated:
			get_parent().get_parent()._evaluate_value()
			already_evaluated = true
		unit_offset = BALL_STOP_OFFSET
	elif time_elapsed < TIME_TO_REACH_BREAKPOINT + TIME_ON_BREAKPOINT + TIME_LEAVE_BREAKPOINT:
		unit_offset = BALL_STOP_OFFSET + (((time_elapsed - (TIME_TO_REACH_BREAKPOINT + TIME_ON_BREAKPOINT)) * (1 - BALL_STOP_OFFSET))/TIME_LEAVE_BREAKPOINT)
	else:
		_stop_sequence()
		
func _start_ball_sequence(ball_number, font):
	if(sequence_ocurring):
		print_debug("Should not happen")
	$Position2D/Ball.modulate = _colour_from_number(ball_number)
	$Position2D/NumberText.text = str(ball_number)
	$Position2D/NumberText.add_font_override("font", font)
	$Position2D/NumberText.add_color_override("font_color", Color.white)
	time_elapsed = 0
	sequence_ocurring = true
	already_evaluated = false
	
func _colour_from_number(ball_number):
	return COLOURS[(ball_number / 10) % 10]
	
func _stop_sequence():
	sequence_ocurring = false
	get_parent().get_parent()._play_loop() #should be singleton, but the way godot does it is weird
