HotKeySet("{Esc}", "Terminate")
Func Terminate()
	 TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

HotKeySet("{Ins}", "_Buffer_edit") ;собирает вещи на первой локации
HotKeySet("{ScrollLock}", "_Buffer_edit2") ;собирает вещи на первой локации
global $Paused


Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		Sleep(100)
		 TrayTip("Подсказка", "Пауза", 1000)
	WEnd
	ToolTip("")
EndFunc   ;==>_Pause

While 1
   sleep(100)
WEnd

Func _Buffer_edit()
   $buffer = ClipGet()
   $buffer2 = "'"&$buffer&"' & '|' & _"&@CRLF
   ClipPut($buffer2)
   if StringInStr(WinGetTitle('[ACTIVE]'),'SciTE')<>0 then Send('+{INS}')
EndFunc

Func _Buffer_edit2()
   $buffer = ClipGet()
   $buffer2 = "['"&$buffer&"',  ], _"&@CRLF
   ClipPut($buffer2)
   if StringInStr(WinGetTitle('[ACTIVE]'),'SciTE')<>0 then
		Send('+{INS}')
		Send("{Left " & 6 & "}")
	EndIf
EndFunc