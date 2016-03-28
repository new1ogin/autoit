#include <Array.au3>

Dim $aArray[10000]
For $i = 0 To 9999
    If Not Mod($i, 100) Then
        $aArray[$i] = ''
    Else
        $aArray[$i] = $i
    EndIf
Next
;~ _ArrayDisplay($aArray, 'До')

$iStart = TimerInit()
$aArray_Cl = _ArrayClearEmpty($aArray)
$iCount = @extended
$iTime_1 = TimerDiff($iStart)
$iTime = StringFormat('Time: %.2f msec', $iTime_1)
If Not @error Then
;~     _ArrayDisplay($aArray_Cl, 'После, пустых: ' & $iCount)
    MsgBox(64, 'Info', $iTime)
Else
    MsgBox(16, 'Error', @error)
EndIf
;==================
;автор XpycT: http://autoit-script.ru/index.php?topic=4496.msg32648#msg32648
$iStart_1 = TimerInit()
For $i = UBound($aArray, 1) - 1 To 0 Step -1
    If $aArray[$i] = "" Then _ArrayDelete($aArray, $i)
Next
$iTime_2 = TimerDiff($iStart_1)
$iTime = StringFormat('Time: %.2f msec', $iTime_2)
If Not @error Then
;~     _ArrayDisplay($aArray_Cl, 'После, пустых: ' & $iCount)
    MsgBox(64, 'Info', $iTime)
Else
    MsgBox(16, 'Error', @error)
EndIf
;~ _ArrayDisplay($aArray, $iTime)
;===================

MsgBox(64, 'Info', 'Разница: ' & StringFormat('%.2f msec', $iTime_2 - $iTime_1) & @LF & _
        'Или в : ' & StringFormat('~%02d раз', $iTime_2 / $iTime_1))
;===================

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