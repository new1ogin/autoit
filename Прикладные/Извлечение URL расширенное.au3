#Include <INet.au3> ;Подключаем библиотеку
#include <Encoding.au3>
#include <array.au3>
$Unnecessary = 'Стать' & '|' & _
'Книг' & '|' & _
'Листовк' & '|' & _
'Брошюра' & '|' & _
'Публикаци' & '|' & _
'газет' & '|' & _
'Журнал'
$Necessary = 'Видеоролик' & '|' & _
'Аудиофайл' & '|' & _
'Информационный материал' & '|' & _
'Сайт' & '|' & _
'ресурс' & '|' & _
'Выступлен' & '|' & _
'Текст аудиозаписи' & '|' & _
'Интернет-страница' & '|' & _
'Интернет' & '|' & _
'страниц' & '|' & _
'Материал' & '|' & _
'Текстовая информация' & '|' & _
'видеофайл' & '|' & _
'файл' & '|' & _
'http' & '|' & _
'httр' & '|' & _
'Статусы' & '|' & _
'Видеозапис'

$aUnnecessary = StringSplit($Unnecessary, '|')
$aNecessary = StringSplit($Necessary, '|')

$pagenumber = 8
$HTML = _INetGetSource('http://minjust.ru/ru/extremist-materials?field_extremist_content_value=&page='&$pagenumber)
$HTML = _Encoding_UTF8ToANSI($HTML)
$aNumbers = StringRegExp($HTML,'(?s)<td class="views-field views-field-field-extremist-id" >(.*?)</td>',3)
$aTexts = StringRegExp($HTML,'(?s)<td class="views-field views-field-field-extremist-content" >(.*?)</td>',3)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Stringlen($HTML) = ' & Stringlen(StringMid($HTML,10,1000)) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Stringmid($HTML,0,900) = ' & StringMid($HTML,15000,20000) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

For $i = 0 to Ubound($aNumbers)-1
	$aNumbers[$i] = StringStripWS ( $aNumbers[$i], 3 )
	if StringRight($aNumbers[$i],1) = '.' then $aNumbers[$i] = StringTrimRight($aNumbers[$i],1)
Next
dim $aTextNum[Ubound($aNumbers)][3]
For $i = 0 to Ubound($aTexts)-1
	$aTextNum[$i][1] = StringStripWS ( $aTexts[$i], 3 )
	$aTextNum[$i][0] = $aNumbers[$i]
Next

dim $aRightTextNum[Ubound($aNumbers)][2]
For $i = 0 to Ubound($aTextNum)-1
	For $t=1 to $aNecessary[0]
		If StringRegExp ( $aTextNum[$i][1], '(?i)\Q'& $aNecessary[$t] &'\E') <>0 Then
			$aTextNum[$i][2]=1
			if Ubound($aRightTextNum) > 1 then Redim $aRightTextNum[Ubound($aRightTextNum)+1][2]
			$aRightTextNum[Ubound($aRightTextNum)-1][1] = $aTextNum[$i][1]
			$aRightTextNum[Ubound($aRightTextNum)-1][0] = $aTextNum[$i][0]
			ConsoleWrite(' Найденно совпадение '&$i&' '&$aTextNum[$i][1]&@CRLF)
		EndIf
	Next
	if $aTextNum[$i][2]<>1 then
		For $t=1 to $aUnnecessary[0]
			If StringRegExp ( $aTextNum[$i][1], '(?i)\Q'& $aUnnecessary[$t] &'\E') <>0 Then
				$aTextNum[$i][2]=0
				; Но если, все же есть совпадение с нужным списком, то
				For $t=1 to $aNecessary[0]
					If StringRegExp ( $aTextNum[$i][1], '(?i)\Q'& $aNecessary[$t] &'\E') <>0 Then
						$aTextNum[$i][2]=1
						if Ubound($aRightTextNum) > 1 then Redim $aRightTextNum[Ubound($aRightTextNum)+1][2]
						$aRightTextNum[Ubound($aRightTextNum)-1][1] = $aTextNum[$i][1]
						$aRightTextNum[Ubound($aRightTextNum)-1][0] = $aTextNum[$i][0]
						ConsoleWrite(' Найденно совпадение '&$i&' '&$aTextNum[$i][1]&@CRLF)
					EndIf
				Next
			EndIf
		Next
	EndIf

Next
$aRightTextNum = _ArrayClearEmpty($aRightTextNum)


_ArrayDisplay($aRightTextNum)



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
