Opt("WinTitleMatchMode", -2)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
HotKeySet("{Esc}" , "Terminate")
Func Terminate()
;~    ProcessClose("slenfbot.exe")
    Exit 0
EndFunc

$schet=0
While 1
	$schet+=1
	$Prevhwnd = WinGetHandle("[ACTIVE]")
	$title = WinGetTitle('��� - Google Chrome')
	$hwnd = WinGetHandle($title)

	WinActivate($hwnd)
	ControlSend($hwnd,'','','^c')
	ControlSend($hwnd,'','','^�')
	ControlSend($hwnd,'','','^r')
	ControlSend($hwnd,'','','^�')
	WinActivate($Prevhwnd)
	sleep(100)
	ControlSend($hwnd,'','','^a')
	ControlSend($hwnd,'','','^�')
		sleep(100)
	ControlSend($hwnd,'','','^a')
	ControlSend($hwnd,'','','^�')

;~ 	sleep(500)
;~ 	ControlSend($hwnd,'','','^c')
;~ 	ControlSend($hwnd,'','','^�')
;~ 	sleep(200)

	$clip = ClipGet()
	if StringInStr($clip,"Registered") <>0 Then
		$more = "4	"
	Else
		$more = "3	"
	EndIf
	if StringInStr($clip,"2	new1ogin") <> 0 Then
		if StringInStr($clip,$more) <> 0 Then
			ConsoleWrite( ' ������ ������ ����� '&@CRLF)
			ConsoleWrite(ClipGet())
			For $i=1 to 8
				Beep(2000,200)
			Next
		EndIf
	Else
		if StringInStr($clip,"2") <> 0 Then
			ConsoleWrite( ' ������ ������ ����� ' &@CRLF)
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