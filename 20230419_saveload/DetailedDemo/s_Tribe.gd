class_name TribeSave
extends Resource

const MemberSave = preload("res://20230419_saveload/DetailedDemo/s_Member.gd")

var name = "Mario Tribe"
var members = []

func add_member(m:MemberSave):
	members.append(m)

func remove_member():
	members.pop_back()
