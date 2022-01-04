extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var rng = RandomNumberGenerator.new()

var cross_sound
var nothing_sound
var bingo_sound
var full_bingo_sound
var dynamic_font
var card_numbers = []
var card_crosses = []
var balls = []
var current_ball
const CARD_HEIGHT = 3
const CARD_WIDTH = 5
const NUMBER_OF_BALLS = 30
const LOWER_BOUND = 0
const UPPER_BOUND = 60

const FONT_SIZE = 55
const FONT_COlOUR = Color( 0, 0, 0, 1 )

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	_create_font()
	cross_sound = preload("res://Sounds/mixkit-space-coin-win-notification-271.wav")
	bingo_sound = preload("res://Sounds/mixkit-unlock-new-item-game-notification-254.wav")
	nothing_sound = preload("res://Sounds/mixkit-losing-drums-2023.wav")
	#_generate_card(CARD_HEIGHT, CARD_WIDTH)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
func _create_font():
	dynamic_font = DynamicFont.new()
	dynamic_font.font_data = load("res://Fonts/Bodo Amat.ttf")
	dynamic_font.size = FONT_SIZE
	dynamic_font.outline_size = 5
	dynamic_font.outline_color = FONT_COlOUR
	dynamic_font.use_filter = true


func _generate_card(height, width):
	var card_generated_numbers = _generate_unique_numbers(LOWER_BOUND, UPPER_BOUND, height * width)
	card_generated_numbers.sort()
	card_numbers = []
	card_crosses = []
	for i in height:
		card_numbers.append([])
		card_crosses.append([])
		for j in width:
			card_numbers[i].append(card_generated_numbers[i * width + j])
			card_crosses[i].append(false)
	
	
	

func _generate_unique_numbers(lower_bound, upper_bound, number_of_values):
	var values_range = upper_bound - lower_bound + 1 #number of possible values to have
	if number_of_values > values_range:
		return null; #should stop here if we ask for more numbers than we are allowed to
	var unique_values = []
	var ret = []
	for i in range(lower_bound, upper_bound + 1):
		unique_values.append(i)
	for i in number_of_values:
		var index_chosen = rng.randi_range(0, values_range - 1) #chooses one index randomly
		ret.append(unique_values[index_chosen]) #adds the value chosen to the array to return
		unique_values[index_chosen] = unique_values.back() #makes elemnt at certain index be the last element
		unique_values.remove(values_range - 1) #removes last element, this two steps pretty much remove one value from the possible ones
		values_range = values_range - 1 #reduces the number of indexes to choose by one
	return ret

func _start_play():
	balls = _generate_unique_numbers(LOWER_BOUND, UPPER_BOUND, NUMBER_OF_BALLS)
	print(balls)
	_generate_card(CARD_HEIGHT, CARD_WIDTH)
	$BingoCard._update_card(CARD_HEIGHT, CARD_WIDTH, card_numbers, dynamic_font)
	_play_loop()
	
	
func _end_ball_sequence():
	_play_loop()
	
func _play_loop():
	if balls.size() == 0:
		_end_bingo()
		return
	current_ball = balls.back()#gets last element of the balls
	balls.remove(balls.size() - 1)#removes last element of the balls
	$Path2D/PathFollow2D._start_ball_sequence(current_ball, dynamic_font)
	
func _end_bingo():
	$StartPauseReload._game_finished()
	
func _evaluate_value():
	var got_number = false
	for i in card_numbers.size():
		for j in card_numbers[i].size():
			if card_numbers[i][j] == current_ball:
				card_crosses[i][j] = true
				got_number = true
				if !_test_bingo(i,j):
					$BingoCard._cross_label(i,j)
					$AudioStreamPlayer.stream = cross_sound
					$AudioStreamPlayer.play()
	if !got_number:
		$AudioStreamPlayer.stream = nothing_sound
		$AudioStreamPlayer.play()
		
func _test_bingo(x,y):
	var row_bingo = true
	var column_bingo = true
	for i in card_crosses[x].size():
		if !card_crosses[x][i]:
			row_bingo = false
	for i in card_crosses.size():
		if !card_crosses[i][y]:
			column_bingo = false
	if row_bingo:
		$BingoCard._cross_row(x)
	if column_bingo:
		$BingoCard._cross_column(y)
	if row_bingo || column_bingo:
		$AudioStreamPlayer.stream = bingo_sound
		$AudioStreamPlayer.play()
		return true
	else:
		return false
