#cs ----------------------------------------------------------------------------

 AutoIt Version: 3.3.6.1
 Script Version: 2.0
 Author:         Claude Hohl
 E-Mail:		 longneck@scratchbook.ch

 Script Function:
	Automate _everything_ with one hotkey-combination: Ctrl-Space
	Define commands for every window individually in the configuration file "space.control".
	ControlSpace will display buttons for each command.

 History:
	05.09.2007 - Beta test & personal use
	24.10.2007 - Fading buttons at startup, documentation, testing
	25.10.2007 - Release
	26.10.2007 - Added timeout option to wwa, made GUI "bullet-proof"
	25.11.2007 - Added numbers to the hotkeys for notebook-users
	15.02.2011 - Refactored code, new AutoIt version, internal testing
	17.02.2011 - Release 2.0

#ce ----------------------------------------------------------------------------

Opt("WinTitleMatchMode", 2)
Opt("SendKeyDelay", 1)

Global $space_control = @AppDataDir & "\ControlSpace\space.control"
If Not FileExists($space_control) Then
	DirCreate(@AppDataDir & "\ControlSpace")
	FileInstall("space.control", $space_control, 0)
	TrayTip("ControlSpace", "Press Ctrl-Space!", 0, 0)
Else
	TrayTip("ControlSpace", "Version 2.0", 0, 0)
EndIf

#include <Array.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <File.au3>
#include <lib/Controlparser.au3>
#include <lib/Buttons.au3>

HotKeySet("^{SPACE}", "controlspace")
HotKeySet("^!{SPACE}", "spacecontrol")
HotKeySet("{ESC}", "clear_buttons")

Func controlspace()
	HotKeySet("^{SPACE}")
	Local $windows = get_windows()
	Local $win_count = UBound($windows)
	For $w in $windows
		If WinActive($w) OR $w == "_All" Then
			Local $buttons = get_buttons($w)
			Local $btn_count = UBound($buttons)
			For $b = 1 To $btn_count - 1 Step 1
				add_button($w, $buttons[$b])
			Next
		EndIf
	Next
	display_buttons()
EndFunc

Func spacecontrol()
	Run(@WindowsDir & "\NOTEPAD.EXE " & $space_control)
	WinWaitActive("space.control")
	WinWaitClose("space.control")
	read_config()
	TrayTip("ControlSpace", "Config file changed, reload complete", 5, 1)
EndFunc

While 1
	Sleep(10000)
WEnd


