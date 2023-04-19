extends Sprite

signal health_info_clicked(healthsave)
signal mana_info_clicked(manasave)

var member_save:MemberSave = MemberSave.new() setget set_member_save
onready var health_label = $VBoxContainer/Infos/Health
onready var mana_label = $VBoxContainer/Infos2/Mana
onready var h_add = $VBoxContainer/Infos/Add
onready var h_minus = $VBoxContainer/Infos/Minus
onready var h_detail = $VBoxContainer/Infos/Detail
onready var m_add = $VBoxContainer/Infos2/Add
onready var m_minus = $VBoxContainer/Infos2/Minus
onready var m_detail = $VBoxContainer/Infos2/Detail

const h_template = "Health: %d"
const m_template = "Mana: %d"

var health = 100 setget set_health
var mana = 100 setget set_mana

func _ready():
	self.member_save = member_save
	for button in [h_add,h_minus,h_detail,m_add,m_minus,m_detail]:
		button.connect("pressed",self,"press_button",[button])

func set_health(val):
	health = val
	member_save.health.val = health
	if is_instance_valid(health_label):
		health_label.text = h_template % health

func set_mana(val):
	mana = val
	member_save.mana.val = mana
	if is_instance_valid(mana_label):
		mana_label.text = m_template % mana

func set_member_save(val):
	member_save = val
	self.health = member_save.health.val
	self.mana = member_save.mana.val

func press_button(button):
	if button.name == "Add":
		if button == h_add:
			self.health += 10
		elif button == m_add:
			self.mana += 10
	elif button.name == "Minus":
		if button == h_minus:
			self.health -= 10
		elif button == m_minus:
			self.mana -= 10
	elif button.name == "Detail":
		if button == h_detail:
			emit_signal("health_info_clicked",member_save.health)
		elif button == m_detail:
			emit_signal("mana_info_clicked",member_save.mana)
