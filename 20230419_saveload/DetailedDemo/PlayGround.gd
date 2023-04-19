extends Node2D

const CHARACTER = preload("res://20230419_saveload/DetailedDemo/Character.tscn")
const is_debug = true
const enc_key = "V#AY{wH3BjDmL[-<"
const SAVE_GAME_PATH := "user://test_save.json"
onready var line_2d = $Line2D
onready var panel_container = $PanelContainer

var positions = []
var current_index = 0
var last_added
var list = []

var tribe_save:TribeSave = TribeSave.new() setget set_tribe_save

func clear_board():
	for x in get_tree().get_nodes_in_group("Member"):
		x.queue_free()
	current_index = 0
	list.clear()
	last_added = null
	target_detail = null
	panel_container.hide()

func set_tribe_save(val):
	tribe_save = val
	if is_inside_tree():
		clear_board()
		for m in tribe_save.members:
			var character = CHARACTER.instance()
			character.member_save = m
			character.position = m.position
			add_child(character)
			list.append(character)
			character.connect("health_info_clicked",self,"health_info_clicked")
			character.connect("mana_info_clicked",self,"mana_info_clicked")
			last_added = character
			current_index += 1
			
func _ready():
	panel_container.hide()
	positions = line_2d.points

func _on_Add_pressed():
	if current_index > positions.size() - 1:
		return
	var character = CHARACTER.instance()
	character.position = positions[current_index]
	add_child(character)
	list.append(character)
	character.connect("health_info_clicked",self,"health_info_clicked")
	character.connect("mana_info_clicked",self,"mana_info_clicked")
	character.member_save.position = character.position
	tribe_save.add_member(character.member_save)
	current_index += 1
	last_added = character

func _on_Minus_pressed():
	if current_index == 0:
		return
	current_index -= 1
	list.pop_back()
	tribe_save.remove_member()
	last_added.queue_free()
	if list.size() > 0:
		last_added = list[list.size() - 1]

func _on_Save_pressed():
	write_savegame()


func _on_Load_pressed():
	load_savegame()

var _file := File.new()


func save_exists() -> bool:
	return _file.file_exists(SAVE_GAME_PATH)


func write_savegame() -> void:
	var error
	if is_debug:
		error = _file.open(SAVE_GAME_PATH, File.WRITE)
	else:
		error = _file.open_encrypted_with_pass(SAVE_GAME_PATH, File.WRITE, enc_key)
	if error != OK:
		print("Could not open the file %s. Aborting save operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return
	var json_string := var2str(tribe_save)
	_file.store_string(json_string)
	_file.close()


func load_savegame() -> void:
	var error
	if is_debug:
		error = _file.open(SAVE_GAME_PATH, File.READ)
	else:
		error = _file.open_encrypted_with_pass(SAVE_GAME_PATH, File.READ, enc_key)
	if error != OK:
		print("Could not open the file %s. Aborting load operation. Error code: %s" % [SAVE_GAME_PATH, error])
		return

	var content := _file.get_as_text()
	_file.close()
	if content.length() == 0:
		return
	var data = str2var(content)
	self.tribe_save = data
	
func _on_Clear_pressed():
	clear_board()
	
onready var name_label = $PanelContainer/VBoxContainer/HBoxContainer/Name
onready var label_1 = $PanelContainer/VBoxContainer/HBoxContainer2/Label1
onready var val_1_check_box = $PanelContainer/VBoxContainer/HBoxContainer2/V1
onready var label_2 = $PanelContainer/VBoxContainer/HBoxContainer3/Label2
onready var val_line_edit = $PanelContainer/VBoxContainer/HBoxContainer3/LineEdit
var target_detail

func health_info_clicked(detail:HealthSave):
	name_label.text = "health"
	panel_container.show()
	target_detail = detail
	label_2.text = "detail:"
	label_1.text = "dead:"
	val_line_edit.text = target_detail.detail
	val_1_check_box.pressed = target_detail.dead
	
func mana_info_clicked(detail:ManaSave):
	name_label.text = "mana"
	panel_container.show()
	target_detail = detail
	label_2.text = "detail:"
	label_1.text = "silence:"
	val_line_edit.text = target_detail.detail
	val_1_check_box.pressed = target_detail.silence

func _on_LineEdit_text_changed(new_text):
	if is_instance_valid(target_detail):
		target_detail.detail = new_text

func _on_V1_toggled(button_pressed):
	if is_instance_valid(target_detail):
		if target_detail is ManaSave:
			target_detail.silence = button_pressed
		elif target_detail is HealthSave:
			target_detail.dead = button_pressed
