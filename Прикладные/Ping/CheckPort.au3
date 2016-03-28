#include <string.au3>
#include <array.au3>

$sPathTo = @TempDir & '\chkport.exe'
FileInstall('chkport.exe', $sPathTo, 1)

; Получаем адреса
$TestAddress = "8.8.8.8"
$TestPort = 53
$input = InputBox (" ввод", ' Введите Адрес и порт в формате 8.8.8.8:53 , для списка адресов вводите их через точку с запятой 192.168.0.1;192.168.0.100, а для диапазона через знак "-" 192.168.0.1-192.168.0.254','8.8.8.8:53')
if @error then exit
$input = StringReplace($input," ", "") ; отчистка от пробелов

global $aAddress[0]
global $UboundaAddress = Ubound($aAddress)
_GetCommaAddress($input)
;~ if StringInStr($input,',') Then _GetCommaAddress($input)
;~ if StringInStr($input,',') Then _GetCommaAddress($input)

Func _GetCommaAddress($input)
	$aSplitComma = StringSplit($input,';')
	For $i=1 to $aSplitComma[0]
		if StringInStr($aSplitComma[$i],'-') Then
			_GetDashAddress($input)
		Else
			;Добавляем найденный адресс в массив
			Redim $aAddress[$UboundaAddress+1]
			$aAddress[$UboundaAddress] = $aSplitComma[$i]
			$UboundaAddress += 1
		EndIf
	Next
EndFunc

Func _GetDashAddress($input)
	$aSplitDash = StringSplit($input,'-')
	For $i=1 to $aSplitDash[0]
		;Добавляем найденный адресс в массив
		Redim $aAddress[$UboundaAddress+1]
		$aAddress[$UboundaAddress] = $aSplitDash[$i]
		$UboundaAddress += 1
	Next
EndFunc

Func _CorrectAddress($Address)
	$return =  True
	if StringRegExp("$Address","\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}:\d{1,5}") and StringRegExp("$Address","\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}") Then
		Msgbox(0," Внимание "," Адрес - " & $Address & " введён некорректно!",20)
		$return =  True
	Else
		$aSplit = StringSplit($Address,':')
		if Ping($aSplit[1]) Then
			$return =  True
		Else
			$return = False
			Msgbox(0," Внимание "," Адрес - " & $Address & " введён некорректно! Или недоступен",20)
		EndIf
	EndIf
	return
EndFunc


$aAddress = _ArrayClearEmpty($aAddress)
;~ _arraydisplay($aAddress)
		$address = StringRegExp($aAddress[0], "(.*?):(.*)", 2)
		$port = $address[2]
		$address = $address[1]
$TestTime =500
For $i=0 to UBound($aAddress)-1
	$t = TimerInit()
	$address = StringRegExp($aAddress[$i], "(.*?):(.*)", 2)
	$port = $address[2]
	$address = $address[1]
	$sServer = _CheckPort($address,$port,$TestTime)
	MsgBox(64, "Проверка сервера", "Адрес "&$aAddress[$i]&' вернул результат: '& @CRLF & $sServer)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($t) = ' & TimerDiff($t) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
Next

Exit
$TestTime =300
$t = TimerInit()
While 1
	$sServer = _CheckPort($address,$port,$TestTime)
	if not stringInStr($sServer,"not") Then ExitLoop
	sleep(1000)
Wend
MsgBox(64, "Проверка сервера", $sServer)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($t) = ' & TimerDiff($t) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Func _CheckPort($IPAddress,$PortAddress, $WaitTime)
Local $pid = Run($sPathTo&' ' & $IPAddress & ' ' & $PortAddress & ' ' & $WaitTime , @ScriptDir, @SW_HIDE, 0x8)
ProcessWaitClose($pid)
Local $stdout = StdoutRead($pid)
;~ $stdout=''
;~ While 1
;~     $stdout &= StdoutRead($pid, False, True)
;~     If @error Then ExitLoop
;~ WEnd
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $stdout = ' & _HexToString($stdout) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Return $stdout
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