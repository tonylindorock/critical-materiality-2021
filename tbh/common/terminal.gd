extends Control
# This is the terminal

signal exited

const MAIN_PATH := "LOC://main_disk"
const MAIN_LOC := "main_disk"

var _config

var _current_path := "LOC://main_disk"
var _current_loc := "main_disk"

var last_scroll_val = 0

var _animated_txt = []

const BtnItem = preload("res://prefabs/ui/terminal_btn_item.tscn")

onready var _display = $Margin/MarginText/Container/Display
onready var _btn_item_container = $Margin/MarginText/Container/Display/BtnItemContainer
onready var _title = $Margin/MarginText/Container/Display/Title
onready var _status = $Margin/MarginText/Container/Display/Status
onready var _loc = $Margin/MarginText/Container/Display/Loc
onready var _content = $Margin/MarginText/Container/Display/Content
onready var _msg = $Margin/MarginText/Container/Display/Msg

onready var _btn_back = $Margin/MarginText/Container/BtnContainer/BtnBack

onready var _srceen_fx = $Margin/CanvasLayer/ScreenFX


# Called when the node enters the scene tree for the first time.
func _ready():
	_content.get_v_scroll().mouse_filter = MOUSE_FILTER_PASS
	
	_animated_txt = [_title, _status, _loc, _msg, _content]
	
	switch(false)


func switch(state):
	set_process_input(state)
	set_process(state)
	$Curosr.in_terminal(state)
	
	if state:
		$AnimationPlayer.play("start")
		_srceen_fx.show()
	else:
		_srceen_fx.hide()
		reset()


func _input(event):
	if !event.is_echo() and event.is_pressed():
			 
		if event is InputEventKey:
			if event.scancode == KEY_SPACE or event.scancode == KEY_ENTER:
				SoundManager.play_sfx(0)
			else:
				var r = int(rand_range(1, 4))
				SoundManager.play_sfx(r)
				
		elif event is InputEventMouseButton:	
			SoundManager.play_sfx(4)
	
	if event.is_action_pressed("ui_cancel"):
		if _current_loc == MAIN_LOC:
			exit()
		go_back()
	elif event.is_action_pressed("ui_up"):
		if _content.visible:
			_content.get_v_scroll().value -= 16
			last_scroll_val = _content.get_v_scroll().value
	elif event.is_action_pressed("ui_down"):
		if _content.visible:
			_content.get_v_scroll().value += 16
			
			if _content.get_v_scroll().value == last_scroll_val:
				_btn_back.grab_focus()
			
			last_scroll_val = _content.get_v_scroll().value


func finish_tween():
	if $Tween.is_active():
		$Tween.stop(_content)
		_content.percent_visible = 1


func load_config(id):
	var config = Core.find_terminal_config(id)
	if config:
		_config = config
		init_terminal()
	

func reset():
	_current_loc = MAIN_LOC
	_current_path = MAIN_PATH
	for node in _btn_item_container.get_children():
		node.queue_free()


func init_terminal():
	if _config:
		if _config.has("name"):
			_title.text = _config["name"]
			
		if _config.has("name") and _config.has("week") and _config.has("date"):
			update_status(_config["time"], _config["week"], _config["date"])
		
		if _config.has("msg"):
			add_msg(_config["msg"])
		else:
			_msg.hide()
		
		if _config.has("items"):
			for item in _config["items"]:
				if item.has("name"):
					add_btn(item["name"])
		
		_btn_item_container.get_child(0).grab_focus()
		_content.hide()
		animate_display()
	

func update_status(time : String, week : String, date : String):
	_status.text = "[" + time + " | " + week + " | " + date + "]"


func update_display():
	if _current_loc != MAIN_LOC:
		_current_path += "/" + _current_loc
		_loc.text = _current_path + "\n"
			
		for item in _config["items"]:
			# level 1
			if item.has("name") and item["name"] == _current_loc:
				if item.has("content"):
					add_content(item["content"])
					
					hide_main()
					_btn_item_container.hide()
					_content.show()
				animate_display()
				return
	else:
		show_main()
		_content.hide()
	
	animate_display()


func hide_main():
	_btn_item_container.hide()
	_title.hide()
	_status.hide()
	_msg.hide()


func show_main():
	_btn_item_container.show()
	_title.show()
	_status.show()
	_msg.show()
	

func add_msg(msg : String):
	_msg.text = msg.to_upper() + "\n"
	_msg.show()


func add_content(content : String):
	_content.text = content + "\n"
	_content.show()
	_content.get_v_scroll().value = 0
	
	
func add_btn(btn_name : String):
	var btn = BtnItem.instance()
	btn.text = "> " + btn_name
	
	_btn_item_container.add_child(btn, true)
	btn.set_name(btn_name)
	
	btn.connect("pressed", self, "_on_btn_item_pressed", [btn.name])


func animate_display():
	$Tween.stop_all()
	for node in _animated_txt:
		var duration = 0.02 * node.text.length()
		node.percent_visible = 0
		$Tween.interpolate_property(node, "percent_visible", 0, 1, duration)
		$Tween.start()
		
	for btn in _btn_item_container.get_children():
		var duration = 0.02 * btn.text.length()
		$Tween.interpolate_property(btn, "modulate", Color(1, 1, 1, 0), Color(1, 1, 1, 1), duration, Tween.TRANS_ELASTIC)
		$Tween.start()


func go_back():
	if _current_loc != MAIN_LOC:
		# update path
		var pos = _current_path.find("/" + _current_loc)
		_current_path.erase(pos, _current_loc.length() + 1)
		_loc.text = _current_path + "\n"
		
		# update loc
		var pos_last = _current_path.find_last("/")
		_current_loc = _current_path.substr(pos_last + 1)
		
		update_display()
		_btn_item_container.get_child(0).grab_focus()
		_btn_back.disabled = true


func _on_btn_item_pressed(btn_name):
	_current_loc = btn_name
	update_display()
	
	_content.grab_focus()
	_btn_back.disabled = false
		
		
func _on_MarginText_mouse_exited():
	$Curosr.hide()


func _on_MarginText_mouse_entered():
	$Curosr.show()


func _on_BtnExit_pressed():
	$Curosr.in_terminal(false)
	$AnimationPlayer.play("shut_down")
	

func _on_BtnBack_pressed():
	go_back()


func exit():
	$Curosr.in_terminal(false)
	$AnimationPlayer.play("shut_down")
	

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "shut_down":
		$Margin/CanvasLayer/ScreenFX.hide()
		switch(false)
		Global.pause_game(false)
		emit_signal("exited")
