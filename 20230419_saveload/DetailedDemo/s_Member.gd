class_name MemberSave
extends Resource

const ManaSave = preload("res://20230419_saveload/DetailedDemo/s_Mana.gd")
const HealthSave = preload("res://20230419_saveload/DetailedDemo/s_Health.gd")

var name = "Mario"
var mana = ManaSave.new()
var health = HealthSave.new()

var position:Vector2 = Vector2.ZERO

