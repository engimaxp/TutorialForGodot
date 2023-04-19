tool
extends Node2D

onready var sprite = $Sprite
onready var sprite_2 = $Sprite2
var top_slice_position = Vector2.ZERO
signal top_slice_position_changed(val)
const sp_material = preload("res://20230410_stacksprite/tint_material.tres")
enum FACEDIRECTION {UP = 0,DOWN = 1,RIGHT = 2,LEFT = 3}
export var texture : Texture = null setget set_texture
export var num_slices : int = 1 setget set_num_slices
export var factor_offset: float = 1 setget set_factor_offset
export var factor_camera_offset:float = 1
export var is_vertical:bool = true
export var is_reverse_order:bool = false
export var scale_x = 1.0 setget set_scale_x
export var scale_y = 1.0 setget set_scale_y
export var current_face_angle = 0
export(int) var z_index_shifted = 0
export var print_debug_flag = false
var child_sprites = []
export(FACEDIRECTION) var face_direction = FACEDIRECTION.RIGHT
signal is_end_signal
var rot = 0 setget set_rot

var is_end = false setget set_is_end

export(Color) var color = Color.white setget set_color

func set_color(val):
	if val == null:
		return
	color = val
	refresh_color()
	
func refresh_color():
	if color == Color.white:
		return
	if is_instance_valid(sprite):
		sprite.material = sp_material.duplicate()
		sprite.material.set_shader_param("tint_color",color)

func set_scale_x(val):
	scale_x = val
	_refresh_scale()
	
func set_factor_offset(val):
	factor_offset = val
	refresh_voxel()
	
func set_scale_y(val):
	scale_y = val
	_refresh_scale()
	
func _refresh_scale():
	if not child_sprites.empty():
		for c in child_sprites:
			c.scale = Vector2(scale_x,scale_y)
		_regest_custom_position()
	if is_instance_valid(sprite_2):
		sprite_2.scale = Vector2(scale_x,scale_y)

func set_is_end(val):
	is_end = val
	emit_signal("is_end_signal")
	_set_is_end(is_end)
	
func _set_is_end(val):
	pass

func set_texture(val):
	texture = val
	refresh_voxel()

func set_num_slices(val):
	num_slices = val
	refresh_voxel()
	
func _ready():
	self.add_to_group("SpriteControl")
	sprite_2.visible = false
	self.texture = texture
	self.num_slices = num_slices
	self.color = color

func refresh_voxel():
	if print_debug_flag:
		print_debug("refresh")
		print_stack()
	if not is_instance_valid(sprite):
		return
	if texture == null or num_slices <= 1:
		return

	if sprite.get_child_count() > 0:
		for c in sprite.get_children():
			c.queue_free()
		child_sprites.clear()

	# For each slice, create a new sprite, set it up so it senders the correct slice,
	# and add it as a child of this node
	if child_sprites.size() == 0:
		for i in range(num_slices):
			child_sprites.append(null)
	if is_reverse_order:
		for i in range(num_slices-1,-1,-1):
			rearange_slice(i)
	else:
		for i in range(num_slices):
			rearange_slice(i)
	_regest_custom_position()
	top_slice_position = child_sprites[child_sprites.size() - 1].position
	emit_signal("top_slice_position_changed",top_slice_position)
	
func rearange_slice(i):
	var slice = Sprite.new()
	slice.texture = texture
	slice.use_parent_material = true
	if is_vertical:
		slice.vframes = num_slices
	else:
		slice.hframes = num_slices
	slice.frame = i
	# This is the magical offset that makes the whole thing look 3D
	slice.position = Vector2(0, -i * factor_offset)
	slice.scale = Vector2(scale_x,scale_y)
	slice.rotation = rot
	sprite.add_child(slice)
	_rearange_slice(slice)
	child_sprites[i] = slice

func _rearange_slice(slice):
	pass

func set_rot(val):
	rot = val
	if is_instance_valid(sprite):
		for c in sprite.get_children():
			c.rotation = rot

func _process(delta):
	if not is_instance_valid(sprite):
		return
	var children = sprite.get_children();
	for i in children.size():
		children[i].rotation = rot
	
	var crot = 0
	if not Engine.editor_hint and is_instance_valid(Game.current_camera):
		crot = Game.current_camera.rotation
	
	if not Engine.editor_hint and is_end:
		var arriba = Vector2(cos(crot - PI/2),sin(crot - PI/2))
		var pos = Game.current_camera.global_position - self.global_position
		var target_z = pos.dot(arriba) + z_index_shifted
		target_z = clamp(target_z,VisualServer.CANVAS_ITEM_Z_MIN,VisualServer.CANVAS_ITEM_Z_MAX)
		z_index = target_z
		var spr = get_children()
		for i in child_sprites.size():
			var slice = child_sprites[i]
			slice.position = arriba * i * factor_offset
			_regest_custom_position()
			top_slice_position = child_sprites[child_sprites.size() - 1].position
			emit_signal("top_slice_position_changed",top_slice_position)
	else:
		match face_direction:
			FACEDIRECTION.RIGHT:
				rot = current_face_angle
			FACEDIRECTION.DOWN:
				rot = current_face_angle - PI/2
			FACEDIRECTION.UP:
				rot = current_face_angle + PI/2
			FACEDIRECTION.LEFT:
				rot = current_face_angle - PI

func _regest_custom_position():
	pass
