extends Resource


const C = preload("res://20230419_saveload/s_c.gd")

export(int) var b_int = 2
export(float) var b_float = 2.2
export(String) var b_string = "string2"

var b_C = C.new()

var dic = {"C":b_C}

var array = [b_C,C.new()]
