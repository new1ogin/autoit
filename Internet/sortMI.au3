#include <array.au3>
#include <File.au3>

$dir = @ScriptDir & '\mi'
$fileRaiting = @ScriptDir & '\Raiting.txt'
local $SiteRating[1500][2]

$aFiles = _FileListToArray($dir,'MegaIndex*')
;~ $aFiles[0]=10 ; ÎÒËÀÄÊÀ !
For $i=1 to $aFiles[0]
	$sText = FileRead($dir & '\' & $aFiles[$i])
	$aText = StringSplit(StringReplace($sText,@CR,@LF),@LF)
	$summ=0
	if $aText[0] > 3 Then
		For $s=3 to $aText[0]
			$Param = StringSplit($aText[$s],';')
			$summ += $Param[UBound($Param)-2]
		Next
	EndIf
	$summ += $aText[0]
	$siteName = StringRegExp($aFiles[$i],'MegaIndex.ru-(.*?)-siteAnalyze',2)
	$SiteRating[$i][0] = $summ
	$SiteRating[$i][1] = $siteName[1]
	ConsoleWrite($siteName[1] & @CRLF)
Next

_ArraySort($SiteRating,1)

;~ ConsoleWrite(_ArrayToString($SiteRating,';')&@CRLF)

$SiteRating = _ArrayClearEmpty($SiteRating)
FileDelete($fileRaiting)
FileWrite($fileRaiting,_ArrayToString($SiteRating))
$SiteRating2 = _stringToArray(FileRead($fileRaiting))
_ArrayDisplay($SiteRating2)








Func _stringToArray($String)
	local $aReturn[1]
	$x=StringSplit($String,@CRLF,1)
	For $i=1 to $x[0]
		$y=StringSplit($x[$i],'|')
		if $i=1 Then
			dim $aReturn[$x[0]][$y[0]]
;~ 			ConsoleWrite('$i='&$i&'$j='&$i&'$i='&$i&'$j='&$i&@CRLF)
		EndIf

		For $j=1 to $y[0]
			$aReturn[$i-1][$j-1]=$y[$j]
;~ 			if $i=1 Then ConsoleWrite('$i='&$aReturn[$i-1][$j-1]&'$j='&$y[$j]&'$i='&$i&'$j='&$i&@CRLF)
		Next
	Next
;~ 	$aReturn[0][0] = UBound($aReturn)
	return $aReturn
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




