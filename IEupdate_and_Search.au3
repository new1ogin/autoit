Opt("WinTitleMatchMode", -2)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
HotKeySet("{Esc}" , "Terminate")
Func Terminate()
;~    ProcessClose("slenfbot.exe")
    Exit 0
EndFunc

$schet=0
While 1
	$schet+=1
	$Prevhwnd = WinGetHandle("[ACTIVE]")
	$title = WinGetTitle('ние - Google Chrome')
	$hwnd = WinGetHandle($title)

	WinActivate($hwnd)
	ControlSend($hwnd,'','','^c')
	ControlSend($hwnd,'','','^с')
	ControlSend($hwnd,'','','^r')
	ControlSend($hwnd,'','','^к')
	WinActivate($Prevhwnd)
	sleep(100)
	ControlSend($hwnd,'','','^a')
	ControlSend($hwnd,'','','^ф')
		sleep(100)
	ControlSend($hwnd,'','','^a')
	ControlSend($hwnd,'','','^ф')

;~ 	sleep(500)
;~ 	ControlSend($hwnd,'','','^c')
;~ 	ControlSend($hwnd,'','','^с')
;~ 	sleep(200)

	$clip = ClipGet()
	if StringInStr($clip,"Registered") <>0 Then
		$more = "4	"
	Else
		$more = "3	"
	EndIf
	if StringInStr($clip,"2	new1ogin") <> 0 Then
		if StringInStr($clip,$more) <> 0 Then
			ConsoleWrite( ' Ќјйден третий пункт '&@CRLF)
			ConsoleWrite(ClipGet())
			For $i=1 to 8
				Beep(2000,200)
			Next
		EndIf
	Else
		if StringInStr($clip,"2") <> 0 Then
			ConsoleWrite( ' Ќјйден второй пункт ' &@CRLF)
			ConsoleWrite(ClipGet())
			For $i=1 to 8
				Beep(2000,200)
			Next
		EndIf
	Endif
	ConsoleWrite(StringLen($clip) &' ')
	IF MOD($SCHET,10)=0 THEN ConsoleWrite(@CRLF)
	sleep(60000)
Wend

;~ ConsoleWrite(ClipGet())