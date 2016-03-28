#include <log.au3>
$hLog = _Log_Open(@ScriptDir & '\avtobest-18.09.log', '### Лог программы  ###')
HotKeySet("{Scrolllock}", "Terminate") ;забиваем клавиши для функций
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


For $i=1 to 120
	$timer = TimerInit()
	WinActivate("[CLASS:Chrome_WidgetWin_1]")
	sleep(300)
	Send("^a")
	sleep(300)
	Send("^c")
	sleep(500)
	$Buffer = ClipGet()
	if Stringinstr($Buffer,"strong")<>0 or Stringinstr($Buffer,"<b>")<>0 Then
		ConsoleWrite("ВНИМАНИЕ НАЙДЕННЫ ОШИБКИ!!!!"&@CRLF)
;~ 		exit
	EndIf
	if Stringinstr($Buffer,"Возвращаемся")<>0 Then
		ConsoleWrite("ВНИМАНИЕ!!"&@CRLF)
		exit
	EndIf
	if Stringinstr($Buffer,"Список всех товаров составлен")<>0 Then
		ConsoleWrite("ВНИМАНИЕ!! Список всех товаров составлен"&@CRLF)
		exit
	EndIf
	$Buffer = StringReplace($Buffer,"</br>","")
	$Buffer = StringRegExpReplace($Buffer,@CRLF&@CRLF,@CRLF)
	$Buffer = StringRegExpReplace($Buffer,@CR&@CR,@CRLF)
	$Buffer = StringRegExpReplace($Buffer,@LF&@LF,@CRLF)
	$Buffer = StringRegExpReplace($Buffer,@CRLF&" "&@CRLF,@CRLF)
	$Buffer = StringRegExpReplace($Buffer,@CRLF&"  "&@CRLF,@CRLF)
	;~ ConsoleWrite($Buffer)
	 _Log_Report($hLog, $Buffer & @CRLF)

	 Send("^r")
	while  TimerDiff($timer)<(65*1000)
		sleep(1000)
;~ 		$color = PixelGetColor(17,5)
		Opt("PixelCoordMode", 0)            ;1=абсолютные, 0=относительные, 2=клиентские
		$color = PixelGetColor(21,21)
;~ 		$color = PixelGetColor(67,21) ; инкогнито
		$color = hex($color,6)
		if $color = '1A2349' then exitloop
	wend
;~ 	if TimerDiff($timer)<(3*1000) Then
;~ 		ConsoleWrite("КРИТИЧЕСКАЯ ОШИБКА. ВНИМАНИЕ НАЙДЕННЫ ОШИБКИ!!!!"&@CRLF)
;~ 		_Pause()
;~ 	Endif

next