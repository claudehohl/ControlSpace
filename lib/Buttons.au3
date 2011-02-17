
Global $_buttons[1]
Global $_buttons_guiref[1]



;public

Func add_button($win_title, $button_name)
	Local $button_counter = UBound($_buttons)
	_ArrayAdd($_buttons, $win_title & "|||" & $button_name)
EndFunc

Func clear_buttons()
	Global $_buttons[1]
	Global $_buttons_guiref[1]
	GUIDelete()
	HotKeySet("^{SPACE}", "controlspace")
EndFunc

Func display_buttons()
	Local $button_count = UBound($_buttons)
	If $button_count < 2 Then
		clear_buttons()
		Return
	EndIf
	Local $pos = MouseGetPos()
	GUICreate("HUD", 300, 30 * ($button_count - 1), $pos[0], $pos[1], $WS_POPUP, $WS_EX_TOOLWINDOW + $WS_EX_TOPMOST)
	For $i = 1 To $button_count - 1 Step 1
		Local $button_displayname = $_buttons[$i]
		$button_displayname = StringSplit($button_displayname, "|||", 1)
		$button_displayname = $button_displayname[2]
		Local $guiref = GUICtrlCreateButton($button_displayname, 0, 30 * ($i - 1), 300, 30)
		_ArrayInsert($_buttons_guiref, $i, $guiref)
	Next
	
    GUISetState()

    While 1
        Local $msg = GUIGetMsg()
		If $msg > 0 Then
			GUIDelete()
			Local $button = _get_button_by_guiref($msg)
			Local $bsp = StringSplit($button, "|||", 1)
			Local $win = $bsp[1]
			Local $btn = $bsp[2]
			Local $actions = get_actions($win, $btn)
			Local $actions_count = UBound($actions)
			For $i = 1 To $actions_count - 1 Step 1
				_interpret($actions[$i])
			Next
			clear_buttons()
		EndIf
    WEnd
EndFunc



;private

Func _get_button_by_guiref($guiref)
	$r = _ArraySearch($_buttons_guiref, $guiref)
	Return $_buttons[$r]
EndFunc

Func _interpret($command)
	$command = StringRegExpReplace($command, "^\t+", "")
	$c = StringSplit($command, "	")
	If $c[0] < 3 Then
		_ArrayAdd($c, 0)
	EndIf
	
	Select
		Case $c[1] == "send"
			Send($c[2])
		Case $c[1] == "sleep"
			Sleep($c[2])
		Case $c[1] == "wa"
			WinSetState($c[2], "", @SW_MAXIMIZE)
			WinActivate($c[2])
		Case $c[1] == "rxr"
			$clip = ClipGet()
			$clip = StringRegExpReplace($clip, $c[2], $c[3])
			ClipPut($clip)
		Case $c[1] == "run"
			Run($c[2])
		Case $c[1] == "wwa"
			WinWaitActive($c[2], "", $c[3])
		Case $c[1] == "trans"
			$trans = 255 / 100 * $c[2]
			WinSetTrans("", "", $trans)
		Case $c[1] == "ontop"
			WinSetOnTop("", "", 1)
		Case $c[1] == "notop"
			WinSetOnTop("", "", 0)
	EndSelect
EndFunc


