extends ColorRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var labels
var cell_size_x
var cell_size_y

const FONT_SIZE = 55
const FONT_COlOUR = Color( 0, 0, 0, 1 )
const NUMBER_NORMAL_COLOUR = Color.white
const NUMBER_CROSSED_COLOUR = Color.yellow
const NUMBER_BINGO_COLOUR = Color.blue
const CELL_MARGIN = 0.2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func _update_card(height, width, numbers, font):
	cell_size_x = self.rect_size.x / width
	cell_size_y = self.rect_size.y / height
	if !(labels == null):
		for i in height:
			for j in width:
				labels[i][j].queue_free()
	_generate_labels(height, width, numbers, font)
	

	
func _generate_labels(height, width, numbers, font):
	labels = []
	for i in height:
		labels.append([])
		for j in width:
			labels[i].append(Label.new())
			labels[i][j].text = String(numbers[i][j])
			labels[i][j].rect_size.x = cell_size_x * (1 - 2*CELL_MARGIN)
			labels[i][j].rect_size.y = cell_size_y * (1 - 2*CELL_MARGIN)
			labels[i][j].margin_left = cell_size_x * j + cell_size_x * CELL_MARGIN
			labels[i][j].margin_top = cell_size_y * i + cell_size_y * CELL_MARGIN
			labels[i][j].align = HALIGN_CENTER
			labels[i][j].valign = VALIGN_CENTER
			labels[i][j].add_font_override("font", font)
			labels[i][j].add_color_override("font_color", NUMBER_NORMAL_COLOUR)
			add_child(labels[i][j])

func _cross_label(x, y):
	labels[x][y].add_color_override("font_color", NUMBER_CROSSED_COLOUR)
	
func _cross_row(x):
	for i in labels[x].size():
		labels[x][i].add_color_override("font_color", NUMBER_BINGO_COLOUR)
		
func _cross_column(y):
	for i in labels.size():
		labels[i][y].add_color_override("font_color", NUMBER_BINGO_COLOUR)	
