#include <array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
HotKeySet("{F7}", "_Quit")
HotKeySet("{F6}", "_Pause")
Global $Paused
Global $NumberSplits = 100, $aMemoryImage, $Struct, $NumTables = 0
Dim $aMemoryImage[$NumberSplits + 1][10] ; ������ ��� �������� ���������� ��� ���������
$sleep = 500
$CmdLineN = $CmdLine
if StringRegExp(@AutoItExe,'autoit3.*?/.exe') then
	Dim $CmdLineN[2]
	$CmdLineN[0]=0
	$CmdLineN[1]=@scriptdir&'\������_�������.txt'
EndIf


$sReportFile = @ScriptDir & '\Report.txt'
If FileExists($sReportFile) Then FileDelete($sReportFile)

;��������� ������ �������
If $CmdLineN[0] > 0 And FileExists($CmdLineN[1]) Then
	$aPasswords = _GetPasswords($CmdLineN[1])
Else
	$aPasswords = _GetPasswords() ; ��������� �������
EndIf
;~ ;����
;~ local $aPasswords[3]=[2,123,1234]
;��������� �����
;~ $aPasswords = _NumGenerator(3)
;~ _ArrayDisplay($aPasswords)
;~ exit

;����� �������
For $i=1 to $aPasswords[0]
	ConsoleWrite($aPasswords[$i] & @CRLF)
Next
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aPasswords[0] = ' & $aPasswords[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite($aPasswords[$aPasswords[0]] & @CRLF)
_ArrayDisplay($aPasswords, $aPasswords[0])
exit
;~ Opt("SendKeyDelay", 20)             ;5 �����������
;~ Opt("SendKeyDownDelay", 10)     ;1 ������������
;~ sleep(3000)
;~ $aPasswords[0] = Stringreplace($aPasswords[0],'','')
;~ For $i=1 to $aPasswords[0]

;~ Next
;~ _ArrayDisplay($t)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GetPasswords() = ' & _GetPasswords() & @CRLF) ;### Debug Console

;1� �����������
;~ $title = '1�:�����������. ������ � �������������� ����'
;~ $title = WinGetHandle($title)
;~ $keysleep = 64
;~ $StepSleep = 100

;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _CompareImageWin($title,0) = ' & _CompareImageWin($title,0) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ WinActivate($title)
;~ Sleep($StepSleep)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _CompareImageWin($title,0) = ' & _CompareImageWin($title,0) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ _sendShiftIns($aPasswords[0])
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _CompareImageWin($title,0) = ' & _CompareImageWin($title,0) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ Sleep($StepSleep)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _CompareImageWin($title,0) = ' & _CompareImageWin($title,0) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ For $i=1 to $aPasswords[0]
;~ 	ConsoleWrite($aPasswords[$i] & @CRLF)
;~ 	_sendShiftIns($aPasswords[$i])
;~ 	Sleep($StepSleep)
;~ Next
;~ exit

$timerReWait = 40 ; ���������� ������ �������� ��������� ���� ����� ������ ���� �� ��������

; RDP
$title = '������������ Windows'
;~ $titleClose=''
_CompareImageWin($title, 0)
$StepSleep = 100
For $i = 1 To $aPasswords[0]
	FileWriteLine($sReportFile, $aPasswords[$i])
	ConsoleWrite($aPasswords[$i] & @CRLF)
	WinActivate($title)
	_sendShiftInsRDP($aPasswords[$i])
	Sleep($StepSleep)
;~ 	if WinExists($titleClose) then WinClose($titleClose)
	If Not WinExists($title) Then
		$timer = TimerInit()
		WinWait($title, '', $timerReWait)
		WinWaitActive($title, '', $timerReWait)
		If Not WinExists($title) Then
			While TimerDiff($timer) < $timerReWait
				Sleep(100)
			WEnd
			If Not WinExists($title) Then _Pause()
		EndIf
	EndIf
	If _CompareImageWin($title, 1) <> 0 Then _Pause()
Next
Exit


Func _sendShiftInsRDP($aPasswords)
	$keysleep = 10
	$tempClip = ClipGet()
	ClipPut($aPasswords)
	Sleep($keysleep)
;~ 	Send('+{Ins}')
;~ 	Send('^{v}')
	Send('^{�}')
	Sleep($keysleep)
	ClipPut($tempClip)
	Send('{Enter}')

EndFunc   ;==>_sendShiftInsRDP

; Kaspersky
$title = '�������� ������'
_CompareImageWin($title, 0)
$StepSleep = 100
For $i = 1 To $aPasswords[0]
	ConsoleWrite($aPasswords[$i] & @CRLF)
	_sendShiftInsKas($aPasswords[$i])
	Sleep($StepSleep)
	If Not WinExists($title) Then
		WinWait($title, '', $timerReWait)
		WinWaitActive($title, '', $timerReWait)
		If Not WinExists($title) Then _Pause()
	EndIf
	If _CompareImageWin($title, 1) <> 0 Then _Pause()
Next
Exit

Func _NumGenerator($num)
	Local $return[(10 ^ $num) + 1]
	$nulls = ''
	For $i = 2 To $num
		$nulls &= '0'
	Next
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $nulls = ' & $nulls & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	For $i = 1 To (10 ^ $num)
		$return[$i] = StringRight($nulls & $i, $num)
	Next
	$return[0] = (10 ^ $num)
	Return $return
EndFunc   ;==>_NumGenerator


Func _sendShiftInsKas($aPasswords)
	$keysleep = 10
	WinActivate($title)
	$tempClip = ClipGet()
	ClipPut($aPasswords)
	Send('+{Ins}')
	Sleep($keysleep)
	ClipPut($tempClip)
	Send('{Enter}')
	Sleep($keysleep)
	Send('{Enter}')
	Sleep($keysleep)

	Send('{end}')
	Sleep($keysleep)
	Send('+{home}')
	Sleep($keysleep)

	Send('{Del}')
EndFunc   ;==>_sendShiftInsKas


Func _CompareImageWin($hWnd, $mod = -1)
	If Not WinExists($hWnd) Then Return -1
	$IndexCompare = 0
	$posWin = WinGetPos($hWnd)

	;���������� ������ ��� �������� ���������
	If Not $Struct Then
		$Struct = ''
		For $i = 1 To $NumberSplits
			$Struct &= 'byte[' & Ceiling(($posWin[2] * $posWin[3] * 4) / $NumberSplits) & '];'
		Next
		$Struct &= 'byte[' & ($posWin[2] * $posWin[3] * 4) - Ceiling(($posWin[2] * $posWin[3] * 4) / $NumberSplits) * ($NumberSplits - 1) & ']'
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($Struct) = ' & StringLen($Struct) & @CRLF) ;### Debug Console
	EndIf

	;���� ������/���������
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd, $posWin[2], $posWin[3]))
	$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $posWin[2], $posWin[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$tData = DllStructCreate($Struct, DllStructGetData($tMap, 'Scan0'))
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : DllStructGetData($tData, $i) = ' & StringLeft(DllStructGetData($tData, 2),1000) & @CRLF) ;### Debug Console

	; �������� �� ������ �����������
;~ 	For $i = 1 To $NumberSplits
;~ 		$timer = Timerinit()
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen(DllStructGetData($tData, $i)) = ' & StringLen(DllStructGetData($tData, $i)) & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : TimerDiff($timer)1 = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
;~ 		$timer = Timerinit()
;~ 		StringReplace(DllStructGetData($tData, $i),'000000',"")
;~ 		ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : TimerDiff($timer)1 = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen(DllStructGetData($tData, $i)) = ' & StringLen(DllStructGetData($tData, $i)) & @CRLF) ;### Debug Console
;~ 		exit
;~ 	Next
	If $mod = 0 Then
		$test = 0
		For $i = 1 To $NumberSplits ; ��������� ������� ����������� �������
			$tempData = DllStructGetData($tData, $i)
			If $aMemoryImage[$i][0] <> $tempData Then
				$aMemoryImage[$i][$NumTables] = $tempData
				$test += 1
			EndIf
		Next
		If $test <> 0 Then $NumTables += 1
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $test = ' & $test & @CRLF) ;### Debug Console
	Else
		For $i = 1 To $NumberSplits
			$test = 0
			For $j = 0 To $NumTables
				If $aMemoryImage[$i][$j] Then ;���� ������ ���������, �� ����������
					If $aMemoryImage[$i][$j] <> DllStructGetData($tData, $i) Then $test += 1
					$test -= 1
				EndIf
			Next
			If $test = 0 Then $IndexCompare += 1
		Next
;~ 		_ArrayDisplay($aMemoryImage)
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tMap)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()

	$IndexCompare = 100 * $IndexCompare / $NumberSplits
	Return $IndexCompare
EndFunc   ;==>_CompareImageWin

Func _WinCapture($hWnd, $iWidth = -1, $iHeight = -1)
	Local $iH, $iW, $hDDC, $hCDC, $hBMP
	If $iWidth = -1 Then $iWidth = _WinAPI_GetWindowWidth($hWnd)
	If $iHeight = -1 Then $iHeight = _WinAPI_GetWindowHeight($hWnd)
	$hDDC = _WinAPI_GetDC($hWnd)
	$hCDC = _WinAPI_CreateCompatibleDC($hDDC)
	$hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iWidth, $iHeight)
	_WinAPI_SelectObject($hCDC, $hBMP)
	DllCall("User32.dll", "int", "PrintWindow", "hwnd", $hWnd, "hwnd", $hCDC, "int", 0)
	_WinAPI_ReleaseDC($hWnd, $hDDC)
	_WinAPI_DeleteDC($hCDC)
	Return $hBMP
EndFunc   ;==>_WinCapture


Func _SendSend($text)
	$string = ''
	$astring = StringSplit($text, "")
	For $i = 1 To $astring[0]
		Switch $astring[$i]
			Case ' '
				$string &= '{SPACE}'
			Case '.'
				$string &= '{NUMPADDOT}'
			Case '/'
				$string &= '{NUMPADDIV}'
			Case ':'
				$string &= '{ASC 058}'
			Case Else
				$string &= '{' & $astring[$i] & '}'
		EndSwitch
	Next
	Send($string)
EndFunc   ;==>_SendSend

Func _GetPasswords($file = '')
	If FileExists($file) Then
		$List = FileRead($file)
	Else

;~ $List = 'WhiteHorse15'& @crlf & _
		$List = 'WhiteHorse15' & @CRLF & _
		'Rfnfhcbc2015' & @CRLF & _
		'Rfnfhcbc15' & @CRLF & _
		'Rfnfhcbc' & @CRLF & _
		'135790' & @CRLF & _
				'1213'
	EndIf


	;��������� - ���������� ����������� � ������� �����, � ������ ��������, � ����� ��� � � ������ ���������
	$array = StringSplit(StringReplace($List, @CR, ''), @LF)
;~ _ArrayDisplay($array)
	Dim $array2[$array[0] * 5]
	$index2 = 1
	$count = $array[0]
	For $i = 1 To $count ; ��������� ������������ �������
		$array2[$index2] = $array[$i]
		$index2 += 1
		; ����� ������� �� ����������� � ��������������
		if StringRegExpReplace($array[$i],"[0-9]",'')='' Then
		Else
			$aTempElement = _GetExtPassword($array[$i])
			For $t = 1 To $aTempElement[0]
				$array2[$index2] = $aTempElement[$t]
				$index2 += 1
			Next
		EndIf
	Next
	For $i = 1 To $count ; ���������� ��������������
		; ����� ������� �� ����������� � ��������������
		if StringRegExpReplace($array[$i],"[0-9]",'')='' Then
		Else
			$element = _Tras($array[$i])
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $element = ' & $element & @CRLF) ;### Debug Console
			If $element == $array[$i] Then
			Else
				$array2[$index2] = $element
				$index2 += 1
				$aTempElement = _GetExtPassword($element)
				For $t = 1 To $aTempElement[0]
					$array2[$index2] = $aTempElement[$t]
					$index2 += 1
				Next
			EndIf
		EndIf
	Next
;~ _arraydisplay($array2)
	_UniqueArrayNear($array2, 10, 1)
	$array2 = _ArrayClearEmpty($array2)
;~ 	$array2=_ArrayUnique($array2,0,Default,1)
	$array2[0] = UBound($array2) - 1
;~ 	_Arraydisplay($array2)
	Return $array2
EndFunc   ;==>_GetPasswords

Func _GetExtPassword($pass)
	Dim $aReturn[10]
	$index2 = 1
	;������� ������ �����
	If Not StringIsUpper(StringLeft($pass, 2)) Then ; �� �������� � ������ ������ ���� ����� � ������� ��������, �������� WAIO, WIAgra
		$TempElement = _SwitchCaseFirstLetter($pass)
		If $TempElement Then
			$aReturn[$index2] = $TempElement
			$index2 += 1
		EndIf
	EndIf
	; ���� ��� ����� � ������ ��������
	If StringLower(StringMid($pass, 2)) == StringMid($pass, 2) Then
	Else
		$aReturn[$index2] = StringLower($pass)
		$index2 += 1
		If Not StringIsUpper(StringLeft($pass, 2)) Then
			$TempElement = _SwitchCaseFirstLetter($aReturn[$index2 - 1])
			If $TempElement Then
				$aReturn[$index2] = $TempElement
				$index2 += 1
			EndIf
		EndIf
	EndIf
	; ���� ������� �������
	If StringInStr($pass, " ") Then
		$aTempElement = _GetExtPassword(StringReplace($pass, " ", ""))
		For $t = 1 To $aTempElement[0]
			$aReturn[$index2] = $aTempElement[$t]
			$index2 += 1
		Next
	EndIf
	ReDim $aReturn[$index2]
	$aReturn[0] = $index2 - 1

;~ 	_arraydisplay($aReturn)
	Return $aReturn
EndFunc   ;==>_GetExtPassword

Func _UniqueArrayNear(ByRef $array, $near, $iStart = 0, $iColumn = 1)
	$Ubound = UBound($array, $iColumn) - 1
	For $i = $iStart To $Ubound
		If $near = 0 Or $near > $Ubound - $i Then
			$Qnear = $Ubound - $i
		Else
			$Qnear = $near
		EndIf

		For $j = 1 To $Qnear
			If $array[$i] == $array[$i + $j] Then
				$array[$i + $j] = ''
			EndIf
		Next
	Next
;~ 	return $array
EndFunc   ;==>_UniqueArrayNear



Func _SwitchCaseFirstLetter($element)
	$FirstLetter = StringLeft($element, 1)
	If StringUpper($FirstLetter) == $FirstLetter Then
		If StringLower($FirstLetter) == $FirstLetter Then
		Else
			Return StringLower($FirstLetter) & StringMid($element, 2)
		EndIf
	Else
		Return StringUpper($FirstLetter) & StringMid($element, 2)
	EndIf
	Return False
EndFunc   ;==>_SwitchCaseFirstLetter

Func _Pause()
	ConsoleWrite('_Pause')
	FileWriteLine($sReportFile, '_Pause')
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		If $trayP = 1 Then
			TrayTip("���������", "�����", 1000)
		EndIf
		Sleep(100)
	WEnd
EndFunc   ;==>_Pause

Func _Quit()
	Exit
EndFunc   ;==>_Quit

;��������� ������, ��������� � ������....
Func _Tras($iText)

	Dim $aLetters[74][2] = [['`', '�'], ['~', '�'], ['@', '"'], ['#', '�'], ['$', ';'], ['^', ':'], ['&', '?'], ['|', '/'], ['q', '�'], ['w', '�'], ['e', '�'], ['r', '�'], ['t', '�'], ['y', '�'], ['u', '�'], ['i', '�'], ['o', '�'], ['p', '�'], ['[', '�'], [']', '�'], ['a', '�'], ['s', '�'], ['d', '�'], ['f', '�'], ['g', '�'], ['h', '�'], ['j', '�'], ['k', '�'], ['l', '�'], [';', '�'], ["'", '�'], ['z', '�'], ['x', '�'], ['c', '�'], ['v', '�'], ['b', '�'], ['n', '�'], ['m', '�'], [',', '�'], ['.', '�'], ['/', '.'], ['Q', '�'], ['W', '�'], ['E', '�'], ['R', '�'], ['T', '�'], ['Y', '�'], ['U', '�'], ['I', '�'], ['O', '�'], ['P', '�'], ['{', '�'], ['}', '�'], ['A', '�'], ['S', '�'], ['D', '�'], ['F', '�'], ['G', '�'], ['H', '�'], ['J', '�'], ['K', '�'], ['L', '�'], [':', '�'], ['"', '�'], ['Z', '�'], ['X', '�'], ['C', '�'], ['V', '�'], ['B', '�'], ['N', '�'], ['M', '�'], ['<', '�'], ['>', '�'], ['?', ',']]
	$iText2 = $iText
	$iText3 = $iText
	For $i = 0 To UBound($aLetters) - 1
		$iText2 = StringRegExpReplace($iText2, '\Q' & $aLetters[$i][0] & '\E', $aLetters[$i][1])
		$iText3 = StringRegExpReplace($iText3, '\Q' & $aLetters[$i][1] & '\E', $aLetters[$i][0])
;~     $iText2 = StringReplace($iText, $aLetters[$i][0], $aLetters[$i][1])
;~ 	$iText3 = StringReplace($iText, $aLetters[$i][1], $aLetters[$i][0])
	Next
	$aText = StringSplit($iText, '')
	$aText2 = StringSplit($iText2, '')
	$aText3 = StringSplit($iText3, '')
	$2 = 0
	$3 = 0
	If UBound($aText) <> UBound($aText2) Or UBound($aText) <> UBound($aText3) Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iText = ' & $iText & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iText2 = ' & $iText2 & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iText3 = ' & $iText3 & @CRLF) ;### Debug Console

		_ArrayDisplay($aText)
		_ArrayDisplay($aText2)
		_ArrayDisplay($aText3)
	EndIf

	For $i = 1 To $aText[0]
		If $aText[$i] = $aText2[$i] Then $2 += 1
		If $aText[$i] = $aText3[$i] Then $3 += 1
	Next
	If $2 < $3 Then
		$iText = $iText2
	Else
		$iText = $iText3
	EndIf

	Return $iText
EndFunc   ;==>_Tras

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
