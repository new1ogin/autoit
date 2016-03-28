#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
HotKeySet("{F1}", "_Del")
HotKeySet("{F2}", "_ShiftDel")
HotKeySet("{F3}", "_Combo")
HotKeySet("{F5}", "_Wait")

global $shetchik=0

$sleep = InputBox('Справка','Введите задержку между нажатиями в мс' & @CRLF & _
	'бесконечные скрипты по кнопкам:' & @CRLF & _
	'F1 - Del, Enter, Down' & @CRLF & _
	'F2 - Shift+Del, Enter, Down' & @CRLF & _
	'F3 - Del, Enter, Shift+Del, Enter' & @CRLF & _
	'F5 - Остановка выполнения' & @CRLF &'',100)
if $sleep < 10 then exit

_Wait()

Func _Wait()
	if $shetchik<>0 then MsgBox(0,'',' Количество циклов = '&$shetchik)
	while 1
		sleep(100)
	WEnd
EndFunc

Func _Del()
	$shetchik=0
	while 1
		Send('{Del}')
		sleep($sleep)
		Send('{Enter}')
		sleep($sleep)
		Send('{Down}')
		sleep($sleep*2)
		$shetchik+=1
	WEnd
EndFunc

Func _ShiftDel()
	$shetchik=0
	while 1
		Send('+{Del}')
		sleep($sleep)
		Send('{Enter}')
		sleep($sleep)
		Send('{Down}')
		sleep($sleep*2)
		$shetchik+=1
	WEnd
EndFunc

Func _Combo()
	$shetchik=0
	while 1
		Send('{Del}')
		sleep($sleep)
		Send('{Enter}')
		sleep($sleep)
		Send('+{Del}')
		sleep($sleep)
		Send('{Enter}')
;~ 		sleep($sleep)
;~ 		Send('{Down}')
		sleep($sleep*2)
		$shetchik+=1
	WEnd
EndFunc
