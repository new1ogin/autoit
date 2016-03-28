#include <array.au3>
#Include <INet.au3> ;Подключаем библиотеку
$site = Clipget() ;'http://allbest.ru/union/';
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $site = ' & $site & @CRLF ) ;### Debug Console
$text = Clipget();_INetGetSource($site)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($text) = ' & StringLen($text) & @CRLF ) ;### Debug Console
$link = StringRegExp($text,'(htt[p|ps]://[\w|\d|\-|\.|/|\?|=|_|@|&|,|:]*)',3)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $text = ' & $text & @CRLF ) ;### Debug Console
$link2=_ArrayUnique($link)

$sitedomain = Stringreplace($site,'//www.','//')
$sitedomain = StringRegExp($site,'htt[p|ps]://([\w|\d|\-|\.|\?|=|_|@|&|,|:]*)/',2)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sitedomain[1] = ' & $sitedomain[1] & @CRLF ) ;### Debug Console
$maxarray = Ubound($link2)-1
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($link2) = ' & Ubound($link2) & @CRLF ) ;### Debug Console
dim $link3[1][2]
For $i=1 to $maxarray
	if Ubound($link2)<$i+1 then exitloop
	if StringInStr($link2[$i],$sitedomain[1])=0 then
		$link3[Ubound($link3)-1][0] = $link2[$i]
		ReDim $link3[Ubound($link3)+1][2]
	EndIf
Next
$link3[Ubound($link3)-1][0] = $sitedomain[1]
$link3 = _ArrayClearEmpty($link3)

TCPStartup() ; Запуск TCP служб.
for $i=0 to Ubound($link3)-1
	$testip = StringRegExp($link3[$i][0],'htt[p|ps]://([\w|\d|\-|\.|\?|=|_|@|&|,|:а-яёА-ЯЁ]*)/',2)
	if @error then
		$testip = StringRegExp($link3[$i][0],'htt[p|ps]://([\w|\d|\-|\.|\?|=|_|@|&|,|:а-яёА-ЯЁ]*)',2)
	EndIf
	if not @error then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $testip[1] = ' & $testip[1] ) ;### Debug Console
		$sIP = TCPNameToIP($testip[1])
		ConsoleWrite('  IP = ' & $sIP & @CRLF ) ;### Debug Console
		if $sIP = '62.152.60.42' then $link3[$i][1] = 'bloked'
	Else
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $link3[$i][0] = ' & $link3[$i][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$link3[$i][1] = 'url error'
	EndIf
	if StringLen($sIP)<8 then $link3[$i][1] = 'no '&$sIP
Next

	TCPShutdown() ; Останавливает TCP службу.

_ArrayDisplay($link3)


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
