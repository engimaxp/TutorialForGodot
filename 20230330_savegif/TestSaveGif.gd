extends Node2D

onready var sprite = $Sprite
onready var stack_sprite = $Viewport/StackSprite

var current_time = 0
var last_shoot_time = 0
const duration = 0.1
const delay = 0.02

#var image_frames = ImageFrames.new()
var file_saved = false
var is_shooted = false
var current_index = 0

func _physics_process(delta):
	if current_time < 2:
		current_time += delta
		return
	if current_time > 8 and not file_saved:
		file_saved = true
#		image_frames.save_gif("res://goost.gif")
		return
	if is_shooted:
		return
	var take_shoot = false
	if current_time + delta > last_shoot_time + duration:
		take_shoot = true
		last_shoot_time = current_time + delta
	current_time += delta
	if take_shoot:
		var image:Image = sprite.get_texture().get_data()
		image.convert(Image.FORMAT_RGBA8)
#		image.flip_y()
		print("shoot")
		image.save_png("res://20230330_savegif/result/r_%d.png" % current_index)
		current_index += 1
		is_shooted = true
#		image_frames.add_frame(image, delay)

func charge():
	$AnimationPlayer.play("Charge")

func _ready():
	get_tree().get_root().set_transparent_background(true)
	stack_sprite.current_face_angle = PI / 4.0
#	charge()
