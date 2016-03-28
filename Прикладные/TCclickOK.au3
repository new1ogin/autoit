WinActivate('[STYLE:0x94C801C4]')
;~ Wingettext($hwnd )
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Wingettext("Windows") = ' & Wingettext("Windows") & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


while 1
	$hwnd = WinGetHandle("Windows")
	If StringInStr(Wingettext($hwnd ),'Все разрешения будут заменены, если нажать кнопку "Да"') <>0 then
		ControlClick($hwnd,'','[CLASS:Button; INSTANCE:2]')
	EndIf
;~ 	ConsoleWrite('1')
	sleep(100)
WEnd