
Global $_cline



;public

Func read_config()
	_FileReadToArray($space_control, $_cline)
EndFunc

read_config()

Func get_windows()
	Local $windows[1]
	For $line in $_cline
		If _get_type($line) == "w" Then
			_ArrayAdd($windows, $line)
		EndIf
	Next
	_ArrayDelete($windows, 0)
	Return $windows
EndFunc

Func get_buttons($window)
	Local $buttons[1]
	Local $linecount = UBound($_cline)
	For $i = 0 To $linecount - 1 Step 1
		If _get_type($_cline[$i]) == "w" And $_cline[$i] == $window Then
			For $bi = $i + 1 To $linecount - 1 Step 1
				If _get_type($_cline[$bi]) == "b" Then
					Local $clean_name = StringReplace($_cline[$bi], "	", "")
					_ArrayAdd($buttons, $clean_name)
				EndIf
				If _get_type($_cline[$bi]) == "w" Then ;don't proceed when next window block comes
					ExitLoop 2
				EndIf
			Next
		EndIf
	Next
	Return $buttons
EndFunc

Func get_actions($window, $button)
	$button = "	" & $button
	Local $actions[1]
	Local $linecount = UBound($_cline)
	For $i = 0 To $linecount - 1 Step 1
		If _get_type($_cline[$i]) == "w" And $_cline[$i] == $window Then
			For $bi = $i + 1 To $linecount - 1 Step 1
				If _get_type($_cline[$bi]) == "b" And $_cline[$bi] == $button Then
					For $ai = $bi + 1 To $linecount - 1 Step 1
						If _get_type($_cline[$ai]) == "a" Then
							_ArrayAdd($actions, $_cline[$ai])
						EndIf
						If _get_type($_cline[$ai]) == "b" Then ;don't proceed when next button block comes
							ExitLoop 3
						EndIf
					Next
				EndIf
			Next
		EndIf
	Next
	Return $actions
EndFunc



;private

Func _get_type($line)
	If $line <> "" Then
		If StringRegExp($line, "^\t{2,2}[^\t]") Then
			Return "a"
		ElseIf StringRegExp($line, "^\t{1,1}[^\t]") Then
			Return "b"
		ElseIf StringRegExp($line, "^\t{0,0}[^\t]") Then
			Return "w"
		EndIf
	EndIf
EndFunc


