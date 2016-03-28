HotKeySet("{Esc}", "Terminate")
Func Terminate()
	 TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

HotKeySet("{Ins}", "_GO")
HotKeySet("{PgUp}", "Plus")
HotKeySet("{PgDn}", "min")
$Cor = 350/20
$name=1
$keydelay=12
Opt("SendKeyDelay", 20)
while 1
	sleep(100)
WEnd
Func min()
	$keydelay=$keydelay-1
EndFunc
func plus()
	$keydelay=$keydelay+1
EndFunc

Func _GO()

	$t1=send('{right down}')
	sleep($keydelay)
	$t1=send('{right up}')

	Sleep(800)
	send('+^ы')
	Sleep(500)
	Send($name)
	Send('{TAB}')
	For $i=1 to 17
		send('{down}')
	Next
	Send('{Enter}')
	Send('{Enter}')
$name=$name+1

;~ 	$t1=send('{right down}')
;~ 	sleep(64)
;~ 	$t1=send('{right up}')
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF ) ;### Debug Console

EndFunc


Func _GO2()
$x1=MouseGetPos(0)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $x1 = ' & $x1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$y1=MouseGetPos(1)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $y1 = ' & $y1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ mouseMove($x1-350,$y1)
MouseClickDrag('left',$x1,$y1,$x1-$Cor,$y1,100)
EndFunc

$x1=MouseGetPos(0)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $x1 = ' & $x1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$y1=MouseGetPos(1)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $y1 = ' & $y1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
