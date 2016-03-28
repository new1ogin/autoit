$hwnd = WinGetHandle("CorelDRAW Graphics Suite X6")

$ClipGetFirst = ClipGet()
$KeyInstall = ''
$KeySN = ''
ClipPut('')
WinActivate($hwnd)
ControlClick($hwnd,'','[CLASS:Internet Explorer_Server; INSTANCE:1]','left',1,1,1)
sleep(64)
ControlClick($hwnd,'','[CLASS:Internet Explorer_Server; INSTANCE:1]','left',1,1,1)
For $i=0 to 9
	ControlSend($hwnd,"","",'{Tab}')
	ControlSend($hwnd,"","",'^{Ins}')
	sleep(64)
	$ClipGet = ClipGet()
	if StringLen($ClipGet) =4 Then
		$KeyInstall &= $ClipGet
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ClipGet() = ' & $ClipGet & @CRLF) ;### Debug Console
		ClipPut('')
	EndIf
	if StringLen($ClipGet) > 15 Then
		$KeySN &= $ClipGet
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ClipGet() = ' & $ClipGet & @CRLF) ;### Debug Console
		ClipPut('')
	EndIf
	sleep(100)
next

Run(@Scriptdir & '\keygen.exe')
WinWait("COREL Products Keygen - CORE")
$Hwnd2 = WinGetHandle("COREL Products Keygen - CORE")
WinActivate($Hwnd2)
sleep(100)
ClipPut($KeyInstall)
ControlSend($hwnd2,"","",'{Del}')
sleep(100)
ControlClick($hwnd2,'','[CLASS:Edit; INSTANCE:1]','left',1)
ControlSend($hwnd2,"","",'{Del}')
ControlSend($hwnd2,"","",'+{Ins}')
;~ ControlSend($hwnd,"","",'{Tab}')
;~ ControlSend($hwnd,"","",'{Tab}')
ControlClick($hwnd2,'','[CLASS:Edit; INSTANCE:2]','left',1)
ClipPut($KeySN)
sleep(100)
ControlSend($hwnd2,"","",'{Del}')
ControlSend($hwnd2,"","",'{Home}')
ControlSend($hwnd2,"","",'+{End}')
ControlSend($hwnd2,"","",'{Del}')
ControlSend($hwnd2,"","",'+{Ins}')
;~ ControlSend($hwnd,"","",'{Tab}')
;~ ControlSend($hwnd,"","",'{Tab}')
;~ ControlSend($hwnd,"","",'{Tab}')
;~ ControlSend($hwnd,"","",'{Enter}')
ControlClick($hwnd2,'','[CLASS:Button; INSTANCE:5]','left',1)
sleep(100)
ControlClick($hwnd2,'','[CLASS:Button; INSTANCE:5]','left',1)
sleep(100)
ControlClick($hwnd2,'','[CLASS:Button; INSTANCE:5]','left',1)
sleep(100)
ControlClick($hwnd2,'','[CLASS:Edit; INSTANCE:3]','left',1)
ControlSend($hwnd2,"","",'{Home}')
ControlSend($hwnd2,"","",'+{End}')
sleep(100)
ControlSend($hwnd2,"","",'^{Ins}')
sleep(100)

;~ msgbox(0,'',$KeyInstall)
;~ ClipPut($KeyInstall)












;~ >>>> Window <<<<
;~ Title:	CorelDRAW Graphics Suite X6
;~ Class:	#32770
;~ Position:	600, 23
;~ Size:	619, 518
;~ Style:	0x96C800C4
;~ ExStyle:	0x00010101
;~ Handle:	0x00000000000E0364

;~ >>>> Control <<<<
;~ Class:	Internet Explorer_Server
;~ Instance:	1
;~ ClassnameNN:	Internet Explorer_Server1
;~ Name:
;~ Advanced (Class):	[CLASS:Internet Explorer_Server; INSTANCE:1]
;~ ID:
;~ Text:
;~ Position:	0, 0
;~ Size:	613, 490
;~ ControlClick Coords:	72, 141
;~ Style:	0x56000000
;~ ExStyle:	0x00000000
;~ Handle:	0x00000000000A011C

;~ >>>> Mouse <<<<
;~ Position:	675, 189
;~ Cursor ID:	0
;~ Color:	0xFFFFFF
