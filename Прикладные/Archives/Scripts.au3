#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>

HotKeySet('{ESC}', '_Exit')
$Fileexec = @ScriptDir & '\exec.txt'
$Filepass = @ScriptDir & '\pass.txt'

If FileExists($Filepass) Then
	$Content = FileRead($Filepass)
	If StringInStr(StringLeft($Content, 20), '|') Then
		$delim = '|'
	ElseIf StringInStr(StringLeft($Content, 20), @CRLF) Then
		$delim = @CRLF
	ElseIf StringInStr(StringLeft($Content, 20), @LF) Then
		$delim = @LF
	ElseIf StringInStr(StringLeft($Content, 20), @CR) Then
		$delim = @CR
	ElseIf StringInStr(StringLeft($Content, 20), @TAB) Then
		$delim = @TAB
	Else
		$delim = ' '
	EndIf
	$aPass = StringSplit($Content, $delim, 1)
	$Content = ''
EndIf
If FileExists($Fileexec) Then
	$hf = FileOpen($Fileexec)
	While 1
		Execute(FileReadLine($hf))
		If @error = -1 Then ExitLoop
	WEnd
EndIf

$timer = TimerInit()

Local $aPass[100000], $ip = 0
$pass = 0
$pre = 2010
For $y = 2010 To 2015
	For $m = 1 To 12
		For $d = 1 To 30
			$aPass[$ip] = $y & StringRight('0' & $m, 2) & StringRight('0' & $d, 2)
			$ip += 1
		Next
	Next
Next
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF ) ;### Debug Console
$aPass = _ArrayClearEmpty($aPass)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF ) ;### Debug Console
_ArrayUnique($aPass)


ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF ) ;### Debug Console
_ArrayDisplay($aPass)
exit

_go2($aPass)
;~ _go1($aPass)


Func _exit()
	Exit
EndFunc   ;==>_exit

Func _go2(ByRef $aPass)
	$hwnd = WinGetHandle('ViPNet CSP - пароль контейнера ключей')
	If Not WinExists($hwnd) Then Exit
	WinActivate($hwnd)

	For $i = 0 To UBound($aPass) - 1
		ControlSend($hwnd, '', '[CLASS:Edit; INSTANCE:1]', $aPass[$i])
		ControlClick($hwnd, '', '[CLASS:Button; INSTANCE:2]')
		If WinWait('ViPNet CSP', 'Пароль указан неверно', 1) = 0 Then
			WinActivate($hwnd)
			Sleep(10)
			ControlClick($hwnd, '', '[CLASS:Button; INSTANCE:2]')
		EndIf
		If WinExists('ViPNet CSP', 'Пароль указан неверно') Then
			ConsoleWrite($aPass[$i] & @CRLF)
			ControlClick('ViPNet CSP', 'Пароль указан неверно', '[CLASS:Button; INSTANCE:1]')
		ElseIf WinWait('ViPNet CSP', 'Пароль указан неверно', 5) = 0 Then
			If MsgBox(2, 'пароль найден?', $aPass[$i]) = 3 Then Exit
		EndIf

	Next
EndFunc   ;==>_go2

Func _go1(ByRef $aPass)
	$hwnd = WinGetHandle('ViPNet CSP - смена пароля контейнера закрытого ключа')
	If Not WinExists($hwnd) Then Exit
	WinActivate($hwnd)
	$newpassword = '1234567890aA'

	ControlSend($hwnd, '', '[CLASS:Edit; INSTANCE:2]', $newpassword)
	ControlSend($hwnd, '', '[CLASS:Edit; INSTANCE:3]', $newpassword)

	For $i = 0 To UBound($aPass) - 1
		ControlSend($hwnd, '', '[CLASS:Edit; INSTANCE:1]', $aPass[$i])
		ControlClick($hwnd, '', '[CLASS:Button; INSTANCE:2]')
		If WinWait('ViPNet CSP', 'Пароль указан неверно', 1) = 0 Then
			WinActivate($hwnd)
			Sleep(10)
			ControlClick($hwnd, '', '[CLASS:Button; INSTANCE:2]')
		EndIf
		If WinExists('ViPNet CSP', 'Пароль указан неверно') Then
			ConsoleWrite($aPass[$i] & @CRLF)
			ControlClick('ViPNet CSP', 'Пароль указан неверно', '[CLASS:Button; INSTANCE:1]')
		ElseIf WinWait('ViPNet CSP', 'Пароль указан неверно', 5) = 0 Then
			If MsgBox(2, 'пароль найден?', $aPass[$i]) = 3 Then Exit
		EndIf

	Next
EndFunc   ;==>_go1




;~ >>>> Window <<<<
;~ Title:	Александр Михеев
;~ Class:	QWidget
;~ Position:	74, 331
;~ Size:	898, 679
;~ Style:	0x96CF0000
;~ ExStyle:	0x00000100
;~ Handle:	0x0000000000030D18

;~ >>>> Window <<<<
;~ Title:	term
;~ Class:	QWidget
;~ Position:	56, 389
;~ Size:	496, 192
;~ Style:	0x96CF0000
;~ ExStyle:	0x00000100
;~ Handle:	0x0000000000080CBC





Func _ArrayClearEmpty($a_Array, $i_SubItem = 0, $i_Start = 0)
	If Not IsArray($a_Array) Or UBound($a_Array, 0) > 2 Then Return SetError(1, 0, 0)

	Local $i_Index = -1
	Local $i_UBound_Row = UBound($a_Array, 1) - 1
	Local $i_UBound_Column = UBound($a_Array, 2) - 1

	If $i_UBound_Column = -1 Then $i_UBound_Column = 0
	If $i_SubItem > $i_UBound_Column Then $i_SubItem = 0
	If $i_Start < 0 Or $i_Start > $i_UBound_Row Then $i_Start = 0

	Switch $i_UBound_Column + 1
		Case 1
			Dim $a_TempArray[$i_UBound_Row + 1]
			If $i_Start Then
				For $i = 0 To $i_Start - 1
					$a_TempArray[$i] = $a_Array[$i]
				Next
				$i_Index = $i_Start - 1
			EndIf
			For $i = $i_Start To $i_UBound_Row
				If String($a_Array[$i]) Then
					$i_Index += 1
					$a_TempArray[$i_Index] = $a_Array[$i]
				EndIf
			Next
			If $i_Index > -1 Then
				ReDim $a_TempArray[$i_Index + 1]
			Else
				Return SetError(2, 0, 0)
			EndIf
		Case 2
			Dim $a_TempArray[$i_UBound_Row + 1][$i_UBound_Column + 1]
			If $i_Start Then
				For $i = 0 To $i_Start - 1
					For $j = 0 To $i_UBound_Column
						$a_TempArray[$i][$j] = $a_Array[$i][$j]
					Next
				Next
				$i_Index = $i_Start - 1
			EndIf
			For $i = $i_Start To $i_UBound_Row
				If String($a_Array[$i][$i_SubItem]) Then
					$i_Index += 1
					For $j = 0 To $i_UBound_Column
						$a_TempArray[$i_Index][$j] = $a_Array[$i][$j]
					Next
				EndIf
			Next
			If $i_Index > -1 Then
				ReDim $a_TempArray[$i_Index + 1][$i_UBound_Column + 1]
			Else
				Return SetError(2, 0, 0)
			EndIf
	EndSwitch
	Return SetError(0, $i_UBound_Row - $i_Index, $a_TempArray)
EndFunc   ;==>_ArrayClearEmpty
