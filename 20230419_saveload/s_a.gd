extends Resource

const B = preload("res://20230419_saveload/s_b.gd")

export(int) var a_int = 1
export(float) var a_float = 1.1
export(String) var a_string = "string1"
var a_B = B.new()

var a_p_int:int = 1
var a_p_float:float = 1.1
var a_p_string:String = "string1"

var diction_p_a = {"b":B.new()}
var array_p_a = ["ap",B.new()]

var diction_a = {"b":"B"}
var array_a = ["a",1]
