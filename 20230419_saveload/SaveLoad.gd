extends Node2D

const A = preload("res://20230419_saveload/s_a.gd")
const B = preload("res://20230419_saveload/s_b.gd")
const C = preload("res://20230419_saveload/s_c.gd")

func _ready():
	var a = A.new()
	a.a_B.b_C.c_string = "hello_world"
	var astr = var2str(a)
	print(astr)
	var k = str2var(astr)
	print(k)
