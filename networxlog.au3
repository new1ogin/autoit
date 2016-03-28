#include <array.au3>

$IgnoreList = '|TeamViewer|TeamViewer.exe|uTorrent.exe|skype.exe|'
$aIgnoreList = StringSplit($IgnoreList, '|')
$sleep = 100
$schet = 0
While 1
	$hwnd = WinGetHandle('[CLASS:TNetStatForm]')
	ClipPut('')
	ControlClick($hwnd, '', '[CLASS:TToolBar; INSTANCE:1]', 'left', 1, 136, 18)
	Sleep(64)
	$clip = ClipGet()
;~ ConsoleWrite(StringLen($clip)&@CRLF)
;~ $t = StringRegExp($clip,'(?m)(?s)(^[^\t]+)\t+(\R+\t([^\t]+)?\t([^\t]+)?\t([^\t]+)?\t([^\t]+)?\t([^\t]+)?\t([^\t]+)?\t){2}',2)
;~ ConsoleWrite($clip&@CRLF)
;~ _ArrayDisplay($t)

	$aConnections = StringSplit($clip, @CRLF, 1)
;~ $aConnections = StringRegExp($clip,'(?m)(?s)(^[^\t]+.*?^[^\t])+',3)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aConnections[0] = ' & $aConnections[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ _ArrayDisplay($aConnections)
	$name = ''
	Local $ta[100]
	Local $taOld[100]
	For $c = 1 To $aConnections[0]
		If StringInStr($aConnections[$c], @TAB) > 1 Then
			$name = StringLeft($aConnections[$c], StringInStr($aConnections[$c], @TAB) - 1)
			ConsoleWrite('name = ' & $name & @CRLF)
			ContinueLoop
		EndIf

		If Not StringInStr($IgnoreList, '|' & $name & '|') Then
			;обработка данных для name не входящих в $IgnoreList
			ConsoleWrite($aConnections[$c] & @CRLF)
			$ta[$c] = $aConnections[$c]
		EndIf
		If $schet > 0 Then
			If $ta <> $taOld Then
				$taOld = _ClearDataConnections($taOld)
				ConsoleWrite($taOld[0] & @CRLF)
;~ 				_CsvWriteArrau($name, $taOld)
			EndIf
		EndIf

	Next

	$schet += 1
	Sleep($sleep)
WEnd

Func _ClearDataConnections($array)
	$array = _ArrayClearEmpty($array)
	Local $array2[UBound($array)]
	For $i = 0 To UBound($array) - 1
		If StringInStr($array[$i], '127.0.0.1') Or StringInStr($array[$i], 'localhost:') Then ContinueLoop
		$array[$i] = StringReplace($array[$i], '10.0.0.10: ', ' - ')
		$array[$i] = StringReplace($array[$i], @ComputerName & ': ', ' - ')
		$array[$i] = StringReplace($array[$i], 'TCP' & @TAB, 'TCP:')
		$array[$i] = StringReplace($array[$i], 'UDP' & @TAB, 'UDP:')
		$array[$i] = StringReplace($array[$i], 'ESTABLISHED', '')
		$array[$i] = StringReplace($array[$i], @TAB, ' ')
		$array[$i] = StringRegExpReplace($array[$i], '( ){2}', ' ')
		$array2[$i] = $array[$i]
	Next
	$array2 = _ArrayClearEmpty($array2)
	_ArraySort($array2)
	Return $array2
EndFunc   ;==>_ClearDataConnections

Func _CsvWriteArrau($name, $array)
	$text = ''
	For $i = 0 To UBound($array) - 1
		$text &= $array[$i] & ';'
	Next
	FileWriteLine(@ScriptDir & '\' & $name & '.csv', $text)
EndFunc   ;==>_CsvWriteArrau

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
		Case 2 Or 3 Or 4 Or 5 Or 6 Or 7
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
	Return $a_TempArray
EndFunc   ;==>_ArrayClearEmpty

