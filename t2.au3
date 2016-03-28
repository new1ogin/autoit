#include <array.au3>

Opt("WinTitleMatchMode", 1)
HotKeySet("^{F7}", "Terminate")
HotKeySet("{F7}", "_SendInf")
;~ HotKeySet("{home}", "_Pause")
$testsleep = 10
Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

While 1
	sleep(100)

WEnd


Func _SendInf()
	$clip = ClipGet()
	$aClipS = StringSplit($clip,@CRLF)
	$textClip1 = _textFromArray($aClipS, 1)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $clip = ' & StringLen($clip) & @CRLF) ;### Debug Console
	$title = "1С:Предприятие"
	$text = "Обслуживание клиента: Визит. Новый"
	$st = StringRegexp($clip,"\d{2}\.\d{2}\.2\d{3}",3)
	$st = _mass($st)
	$st2 = StringRegexp($clip,"\d{2}\.\d{2}\.1\d",3)
	$st2 = _mass($st2)
	if $st2 <> 0 and $st2[0][1] > $st[0][1] Then
		$st=$st2
		$st[0][0] = StringRegExpReplace($st[0][0],'(\d{2}\.\d{2})\.(1\d)','\1\.20\2')
	EndIf


If WinActive($title, $text) Then
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:28]')
	sleep($testsleep)
	ControlSend($title, $text, '[CLASS:V8FormElement; INSTANCE:28]', 'ООО "Профф"')
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:26]')
	sleep($testsleep)
	ControlSend($title, $text, '[CLASS:V8FormElement; INSTANCE:26]', 'Зюзин Виталий Дмитриевич')
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:16]')
	sleep($testsleep)
	ControlSend($title, $text, '[CLASS:V8FormElement; INSTANCE:16]', '1000,00')
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:15]')
	sleep($testsleep)
	Send('+{ins}')
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:30]')
	sleep($testsleep)
	if $st <> 0 Then ControlSend($title, $text, '[CLASS:V8FormElement; INSTANCE:30]', $st[0][0])
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:15]')
	sleep($testsleep)
	$pos = ControlGetPos ($title, $text, '[CLASS:V8FormElement; INSTANCE:24]')
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:24]', 'left', 2, $pos[2]-24, $pos[3]/2)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $pos[2]-24 = ' & $pos[2]-24 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	sleep($testsleep)
	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]','{Down}')
	sleep($testsleep)
	sleep(64)
	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]','{Enter}')
	sleep($testsleep)
	sleep(64)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $textClip1 = ' & $textClip1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]',StringMid($textClip1,1,1))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringMid($textClip1,1,1) = ' & StringMid($textClip1,1,1) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	sleep($testsleep)
	sleep(64)
	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]',StringMid($textClip1,2,1))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringMid($textClip1,2,1) = ' & StringMid($textClip1,2,1) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	sleep($testsleep)
	sleep(64)
	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]',StringMid($textClip1,3,1))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringMid($textClip1,3,1) = ' & StringMid($textClip1,3,1) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	sleep($testsleep)
	sleep(64)
	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]',StringMid($textClip1,4,1))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringMid($textClip1,4,1) = ' & StringMid($textClip1,4,1) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	sleep($testsleep)
	sleep(64)
	ConsoleWrite($st[0][0] & @CRLF)



EndIf
Endfunc

Func _textFromArray($array, $startLine)
	For $i=$startLine to Ubound($array) -1
		$text = StringRegExpReplace($array[$i],'[^a-zA-Zа-яёА-ЯЁ]*','')
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @extended = ' & @extended & @CRLF) ;### Debug Console
		If StringLen($text) > 2 Then
			return $text
		EndIf
	Next
EndFunc


Func _mass($array)
	if Ubound($array) = 0 Then return 0
	$uarray = UBound($array) - 1
	Dim $array2[$uarray+1][2]
	$num = 0
	For $i=0 to $uarray
		$tc = 0
		For $j=0 to $num
			if $array[$i] = $array2[$j][0] Then
				$array2[$j][1] += 1
;~ 				ConsoleWrite('@@ Debug(' & $array2[$j][1] & ') : $array2[$j][0] = ' & $array2[$j][0] & @CRLF) ;### Debug Console
				$tc = 1
			EndIf
		Next
		if $tc = 0 Then
			$array2[$num][0] = $array[$i]
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $array2[$num][0] = ' & $array2[$num][0] & @CRLF) ;### Debug Console
			$array2[$num][1] = 1
			$num += 1
		EndIf
	Next
	Redim $array2[$num][2]
	_ArraySort($array2, 1, 0, 0, 1)
	return $array2
EndFunc
