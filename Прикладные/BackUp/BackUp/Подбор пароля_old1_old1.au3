#include <array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
HotKeySet("{F7}", "_Quit")
HotKeySet("{F6}", "_Pause")
global $Paused
global $NumberSplits = 100, $aMemoryImage, $Struct, $NumTables=0
Dim $aMemoryImage[$NumberSplits+1][10] ; массив для хранения информации для сравнения
$sleep = 500
$CmdLineN = $CmdLine
;~ Dim $CmdLineN[2]
;~ $CmdLineN[0]=1
;~ $CmdLineN[1]=@scriptdir&'\Список_Паролей.txt'

$sReportFile=@scriptdir&'\Report.txt'
if FileExists($sReportFile) then FileDelete($sReportFile)

;Получение списка паролей
if $CmdLineN[0] > 0 and FileExists($CmdLineN[1]) Then
	$aPasswords = _GetPasswords($CmdLineN[1])
Else
	$aPasswords = _GetPasswords() ; получение паролей
EndIf
;~ ;Тест
;~ local $aPasswords[3]=[2,123,1234]
;генерация чисел
;~ $aPasswords = _NumGenerator(3)
;~ _ArrayDisplay($aPasswords)
;~ exit

;~ ;вывод паролей
For $i=1 to $aPasswords[0]
	ConsoleWrite($aPasswords[$i] & @CRLF)
Next
exit
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aPasswords[0] = ' & $aPasswords[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ConsoleWrite($aPasswords[$aPasswords[0]] & @CRLF)
;~ _Arraydisplay(_Arraydisplay($array2),$aPasswords[$aPasswords[0]])

;~ Opt("SendKeyDelay", 20)             ;5 миллисекунд
;~ Opt("SendKeyDownDelay", 10)     ;1 миллисекунда
;~ sleep(3000)
;~ $aPasswords[0] = Stringreplace($aPasswords[0],'','')
;~ For $i=1 to $aPasswords[0]

;~ Next
;~ _ArrayDisplay($t)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GetPasswords() = ' & _GetPasswords() & @CRLF) ;### Debug Console

;1С Предприятие
;~ $title = '1С:Предприятие. Доступ к информационной базе'
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

$timerReWait=40 ; количество секунд ожидания появления окна ввода пароля если то исчезнет

; RDP
$title='Безопасность Windows'
;~ $titleClose=''
_CompareImageWin($title,0)
$StepSleep=5000
For $i=1 to $aPasswords[0]
	FileWriteLine($sReportFile,$aPasswords[$i])
	ConsoleWrite($aPasswords[$i] & @CRLF)
		WinActivate($title)
	_sendShiftInsRDP($aPasswords[$i])
	Sleep($StepSleep)
;~ 	if WinExists($titleClose) then WinClose($titleClose)
	if not WinExists($title) then
		$timer = TimerInit()
		WinWait($title,'',$timerReWait)
		WinWaitActive($title,'',$timerReWait)
		if not WinExists($title) then
			While Timerdiff($timer) < $timerReWait
				sleep(100)
			WEnd
			if not WinExists($title) then _Pause()
		EndIf
	EndIf
	if _CompareImageWin($title,1) <> 0 Then _Pause()
Next
Exit


Func _sendShiftInsRDP($aPasswords)
	$keysleep=10
	Clipput($aPasswords)
	Sleep($keysleep)
;~ 	Send('+{Ins}')
;~ 	Send('^{v}')
	Send('^{м}')
	Sleep($keysleep)
	sleep(1000)
	Send('{Enter}')

EndFunc

; Kaspersky
$title='Проверка пароля'
_CompareImageWin($title,0)
$StepSleep=100
For $i=1 to $aPasswords[0]
	ConsoleWrite($aPasswords[$i] & @CRLF)
	_sendShiftInsKas($aPasswords[$i])
	Sleep($StepSleep)
	if not WinExists($title) then
		WinWait($title,'',$timerReWait)
		WinWaitActive($title,'',$timerReWait)
		if not WinExists($title) then _Pause()
	EndIf
	if _CompareImageWin($title,1) <> 0 Then _Pause()
Next
exit

Func _NumGenerator($num)
	local $return[(10^$num)+1]
	$nulls=''
	For $i=2 to $num
		$nulls&='0'
	Next
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $nulls = ' & $nulls & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	For $i=1 to (10^$num)
		$return[$i]=StringRight($nulls&$i,$num)
	Next
	$return[0]=(10^$num)
	return $return
EndFunc


Func _sendShiftInsKas($aPasswords)
	$keysleep=10
	WinActivate($title)
	Clipput($aPasswords)
	Send('+{Ins}')
	Sleep($keysleep)
	Send('{Enter}')
	Sleep($keysleep)
	Send('{Enter}')
	Sleep($keysleep)

	Send('{end}')
	Sleep($keysleep)
	Send('+{home}')
	Sleep($keysleep)

	Send('{Del}')
EndFunc


Func _CompareImageWin($hWnd,$mod=-1)
	if not WinExists($hWnd) then return -1
	$IndexCompare=0
	$posWin = WinGetPos($hwnd)

	;генерируем строку для создание структуры
	if not $Struct Then
		$Struct = ''
		For $i=1 to $NumberSplits
			$Struct &= 'byte[' & Ceiling(($posWin[2] * $posWin[3] * 4)/$NumberSplits) & '];'
		Next
		$Struct &= 'byte[' & ($posWin[2] * $posWin[3] * 4)-Ceiling(($posWin[2] * $posWin[3] * 4)/$NumberSplits)*($NumberSplits-1) & ']'
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($Struct) = ' & StringLen($Struct) & @CRLF) ;### Debug Console
	EndIf

	;цикл поиска/сравнения
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd, $posWin[2], $posWin[3]))
	$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $posWin[2], $posWin[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$tData = DllStructCreate($Struct, DllStructGetData($tMap, 'Scan0'))
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : DllStructGetData($tData, $i) = ' & StringLeft(DllStructGetData($tData, 2),1000) & @CRLF) ;### Debug Console

	; проверка на пустое возвращение
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
	if $mod = 0 then
		$test=0
		For $i = 1 To $NumberSplits ; Заполняем таблицу уникальными данными
			$tempData = DllStructGetData($tData, $i)
			if $aMemoryImage[$i][0] <> $tempData Then
				$aMemoryImage[$i][$NumTables] = $tempData
				$test+=1
			EndIf
		Next
		if $test<>0 Then $NumTables +=1
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $test = ' & $test & @CRLF) ;### Debug Console
	Else
		For $i = 1 To $NumberSplits
			$test=0
			For $j = 0 to $NumTables
				if $aMemoryImage[$i][$j] Then ;Если ячейка заполнена, то сравниваем
					if $aMemoryImage[$i][$j] <> DllStructGetData($tData, $i) Then $test += 1
					$test-=1
				EndIf
			Next
			if $test=0 Then $IndexCompare += 1
		Next
;~ 		_ArrayDisplay($aMemoryImage)
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tMap)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()

	$IndexCompare = 100*$IndexCompare/$NumberSplits
	return $IndexCompare
EndFunc

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
	$astring = StringSplit($text,"")
	For $i=1 to $astring[0]
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
EndFunc

Func _GetPasswords($file='')
	if FileExists($file) Then
		$List = FileRead($file)
	Else


	$List = ClipGet()
;~ $List = 'WhiteHorse15'& @crlf & _
;~ $List = '1qazXSW2'& @crlf & _
;~ 'proff123';& @crlf & _
;~ 'proff'& @crlf & _
;~ 'rfnfhcbc'& @crlf & _
;~ 'Zydfhm12'& @crlf & _
;~ 'Bhrencrbq'& @crlf & _
;~ 'Admin1'& @crlf & _
;~ 'Vevei9shoosh'& @crlf & _
;~ 'smaik123'& @crlf & _
;~ 'proff#00'& @crlf & _
;~ ',tpjgfcyjcnm'& @crlf & _
;~ '<tpjgfcyjcnm'& @crlf & _
;~ '9521594231'& @crlf & _
;~ 'HATOgo15'& @crlf & _
;~ '4ern@yaK0wka'& @crlf & _
;~ 'A1s2D3f4'& @crlf & _
;~ 'En{ 1с'& @crlf & _
;~ '1'& @crlf & _
;~ '12'& @crlf & _
;~ '123'& @crlf & _
;~ '1234'& @crlf & _
;~ '315'& @crlf & _
;~ '2113'
EndIf


;обработка - добовление написанного с большой буквы, в нижнем регистре, а затем ещё и в другой раскладке
$array = StringSplit(StringReplace($List,@CR,''),@lf)
;~ _ArrayDisplay($array)
local $array2[$array[0]*5]
$index2 = 1
$count = $array[0]
For $i=1 to $count ; Обработка оригинальных паролей
	$array2[$index2] = $array[$i]
	$index2 += 1
	$aTempElement = _GetExtPassword($array[$i])
	For $t=1 to $aTempElement[0]
		$array2[$index2] = $aTempElement[$t]
		$index2 += 1
	Next
Next
For $i=1 to $count ; Добовление транслитерации
	$element = _Tras($array[$i])
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $element = ' & $element & @CRLF) ;### Debug Console
	if $element == $array[$i] Then
	Else
		$array2[$index2] = $element
		$index2 += 1
		$aTempElement = _GetExtPassword($element)
		For $t=1 to $aTempElement[0]
			$array2[$index2] = $aTempElement[$t]
			$index2 += 1
		Next
	EndIf
Next
;~ _arraydisplay($array2)
	_UniqueArrayNear($array2,0,1)
	$array2 = _ArrayClearEmpty($array2)
	$array2[0] = Ubound($array2)-1
;~ 	return $array2

;Добовление к концу годов (с 2010 по 2016)
local $add[12] = ['15','12','13','11','10','14','16','2015','2012','2013','2011','2010','2014','2016']
local $array3[($array2[0]+1)*(UBound($add)+1)]
For $a = 1 to $array2[0] ;добовляем сами обработанные пароли
	$array3[$a] = $array2[$a]
Next

For $i=0 to UBound($add)-1
	For $a = 1 to $array2[0]
		$t = StringRegExpReplace($array2[$a],'(.*?[^0-9])[0-9]{2,4}$','$1') ; отчищяем пароль от тех годов которые уже были
		$t = $t&$add[$i]
		if $t <> $array2[$a] Then
			$array3[$array2[0]*($i+1)+$a] = $t
		EndIf
	Next
Next


	$array3 = _ArrayClearEmpty($array2)
	$array3[0] = Ubound($array2)-1
	return $array3
EndFunc

Func _GetExtPassword($pass)
	dim $aReturn[10]
	$index2=1
	;регистр первой буквы
	if not StringIsUpper(StringLeft($pass,2)) Then ; Не играться с первой буквой если слово в верхнем регистре, например WAIO, WIAgra
		$TempElement = _SwitchCaseFirstLetter($pass)
		if $TempElement Then
			$aReturn[$index2] = $TempElement
			$index2 += 1
		EndIf
	EndIf
	; если все буквы в нижнем регистре
	if StringLower(StringMid($pass,2)) == StringMid($pass,2) Then
	Else
		$aReturn[$index2] = StringLower($pass)
		$index2 += 1
		if not StringIsUpper(StringLeft($pass,2)) Then
			$TempElement = _SwitchCaseFirstLetter($aReturn[$index2-1])
			if $TempElement Then
				$aReturn[$index2] = $TempElement
				$index2 += 1
			EndIf
		EndIf
	EndIf
	; если имеются пробелы
	if Stringinstr($pass, " ") Then
		$aTempElement = _GetExtPassword(StringReplace($pass," ",""))
		For $t=1 to $aTempElement[0]
			$aReturn[$index2] = $aTempElement[$t]
			$index2 += 1
		Next
	EndIf
	Redim $aReturn[$index2]
	$aReturn[0] = $index2-1

;~ 	_arraydisplay($aReturn)
	return $aReturn
EndFunc

Func _UniqueArrayNear(Byref $array,$near,$iStart=0,$iColumn=1)
	$Ubound=UBound($array,$iColumn)-1
	For $i=$iStart to $Ubound
		if $near=0 or $near > $Ubound-$i then
			$Qnear=$Ubound-$i
		Else
			$Qnear=$near
		EndIf

		For $j=1 to $Qnear
			if $array[$i] == $array[$i+$j] Then
				$array[$i+$j]=''
			EndIf
		Next
	Next
;~ 	return $array
EndFunc



Func _SwitchCaseFirstLetter($element)
		$FirstLetter = StringLeft($element,1)
		if StringUpper($FirstLetter) == $FirstLetter Then
			if StringLower($FirstLetter) == $FirstLetter Then
			Else
				return StringLower($FirstLetter) & StringMid($element,2)
			EndIf
		Else
			return StringUpper($FirstLetter) & StringMid($element,2)
		EndIf
	Return false
EndFunc

Func _Pause()
	ConsoleWrite('_Pause')
	FileWriteLine($sReportFile,'_Pause')
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

Func _Quit()
	Exit
EndFunc

;галиматья жуткая, неудобная и долгая....
Func _Tras($iText)

Dim $aLetters[74][2] = [['`','ё'],['~','Ё'],['@','"'],['#','№'],['$',';'],['^',':'],['&','?'],['|','/'],['q','й'],['w','ц'],['e','у'],['r','к'],['t','е'],['y','н'],['u','г'],['i','ш'],['o','щ'],['p','з'],['[','х'],[']','ъ'],['a','ф'],['s','ы'],['d','в'],['f','а'],['g','п'],['h','р'],['j','о'],['k','л'],['l','д'],[';','ж'],["'",'э'],['z','я'],['x','ч'],['c','с'],['v','м'],['b','и'],['n','т'],['m','ь'],[',','б'],['.','ю'],['/','.'],['Q','Й'],['W','Ц'],['E','У'],['R','К'],['T','Е'],['Y','Н'],['U','Г'],['I','Ш'],['O','Щ'],['P','З'],['{','Х'],['}','Ъ'],['A','Ф'],['S','Ы'],['D','В'],['F','А'],['G','П'],['H','Р'],['J','О'],['K','Л'],['L','Д'],[':','Ж'],['"','Э'],['Z','Я'],['X','Ч'],['C','С'],['V','М'],['B','И'],['N','Т'],['M','Ь'],['<','Б'],['>','Ю'],['?',',']]
$iText2 = $iText
$iText3 = $iText
For $i = 0 To UBound($aLetters)-1
    $iText2 = StringRegExpReplace($iText2, '\Q'&$aLetters[$i][0]&'\E', $aLetters[$i][1])
	$iText3 = StringRegExpReplace($iText3, '\Q'&$aLetters[$i][1]&'\E', $aLetters[$i][0])
;~     $iText2 = StringReplace($iText, $aLetters[$i][0], $aLetters[$i][1])
;~ 	$iText3 = StringReplace($iText, $aLetters[$i][1], $aLetters[$i][0])
Next
$aText = StringSplit($iText,'')
$aText2 = StringSplit($iText2,'')
$aText3 = StringSplit($iText3,'')
$2=0
$3=0
if Ubound($aText)<>Ubound($aText2) Or Ubound($aText)<>Ubound($aText3) Then
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iText = ' & $iText & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iText2 = ' & $iText2 & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iText3 = ' & $iText3 & @CRLF) ;### Debug Console

	_ArrayDisplay($aText)
	_ArrayDisplay($aText2)
	_ArrayDisplay($aText3)
EndIf

For $i=1 to $aText[0]
	if $aText[$i] = $aText2[$i] Then $2+=1
	if $aText[$i] = $aText3[$i] Then $3+=1
Next
If $2 < $3 Then
	$iText=$iText2
Else
	$iText=$iText3
EndIf

Return $iText
EndFunc

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