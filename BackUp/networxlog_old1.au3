#include <array.au3>

$IgnoreList = '|TeamViewer|TeamViewer.exe|uTorrent.exe|skype.exe|'
$aIgnoreList = StringSplit($IgnoreList,'|')

$schet = 0
While 1
$hwnd = WinGetHandle('[CLASS:TNetStatForm]')
ClipPut('')
ControlClick($hwnd,'','[CLASS:TToolBar; INSTANCE:1]','left',1,136, 18)
sleep(64)
$clip = ClipGet()
;~ ConsoleWrite(StringLen($clip)&@CRLF)
;~ $t = StringRegExp($clip,'(?m)(?s)(^[^\t]+)\t+(\R+\t([^\t]+)?\t([^\t]+)?\t([^\t]+)?\t([^\t]+)?\t([^\t]+)?\t([^\t]+)?\t){2}',2)
;~ ConsoleWrite($clip&@CRLF)
;~ _ArrayDisplay($t)

$aConnections = StringSplit($clip,@CRLF,1)
;~ $aConnections = StringRegExp($clip,'(?m)(?s)(^[^\t]+.*?^[^\t])+',3)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aConnections[0] = ' & $aConnections[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ _ArrayDisplay($aConnections)
$name=''
local $ta[100]
local $taOld[100]
For $c=1 to $aConnections[0]
	if StringInStr($aConnections[$c],@TAB) > 1 then
		$name = Stringleft($aConnections[$c],StringInStr($aConnections[$c],@TAB)-1)
		ConsoleWrite('name = '&$name & @CRLF)
		ContinueLoop
	EndIf

	if not StringInStr($IgnoreList,'|'&$name&'|') Then
		;обработка данных для name не входящих в $IgnoreList
		ConsoleWrite($aConnections[$c] & @CRLF)
		$ta[$c] = $aConnections[$c]
	EndIf
	if $schet > 0 Then
		if $ta<>$taOld Then
			FileWriteLine(

Next

$schet+=1
wend

Func _ClearDataConnections($array)
	$array = _ArrayClearEmpty($array)
	For $i=0 to UBound($array)-1
		if StringInStr($array[$i],'127.0.0.1') or StringInStr($array[$i],'localhost:') then ContinueLoop
		$array[$i] = StringReplace($array[$i],'10.0.0.10: ','')
		$array[$i] = StringReplace($array[$i],@TAB,' ')
EndFunc

Func _CsvWriteArrau($name,$array)
	For $i=0 to UBound($array)-1

Endfunc

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
