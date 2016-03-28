#Include <WinAPIEx.au3>

HotKeySet("{End}", "Terminate") ;забиваем клавиши для функций
HotKeySet("{Ins}", "_Pause")
Func Terminate() ;функция выхода
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
;~ 	_EndWindow()
	Exit 0
EndFunc   ;==>Terminate
global $Paused
Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		If $trayP = 1 Then
			TrayTip("Подсказка", "Пауза", 1000)
		EndIf
		Sleep(100)
	WEnd
EndFunc   ;==>_Pause

Run('"D:\Distrib\netsph\NetSph.exe" pause 10')

While 1
do
  Sleep(600)
;~   MouseMove(Random(0,500),Random(0,500))
until _WinAPI_GetIdleTime() >= 1000

;~ Run("notepad.exe")
ToolTip('Idle time (ms): ' & _WinAPI_GetIdleTime())
sleep(1000)
Wend


