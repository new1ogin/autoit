#include <array.au3>
#include <File.au3>

local $aAnalizWords[1][18], $iAW=0
$dir = @ScriptDir & '\mi\'
$fileRaiting = @ScriptDir & '\Raiting.txt'
$fileAnalizWords = @ScriptDir & '\AnalizWords.csv'
$MinQSites = 10 ; минимальное количество сайтов в которых присутствует данный запрос
$fileAnalizWords2 = @ScriptDir & '\PartAnalizWords.csv' ;Имя файла для сохранения части запросов соответствующих минимальному количеству
$SiteRating = _stringToArray(FileRead($fileRaiting))

$aFiles = _FileListToArray($dir,'MegaIndex*')
ConsoleWrite('$aFiles[0]='&$aFiles[0] & @CRLF)

;~ $aFiles[0]=100
For $fmi=1 to $aFiles[0]
	$siteName = StringRegExp($aFiles[$fmi],'MegaIndex.ru-(.*?)-siteAnalyze',2) ; $siteName[1]

	$fileContent = FileRead($dir&$aFiles[$fmi])

	$aWords = StringSplit(StringReplace(StringReplace($fileContent,@CRLF,@LF),@CR,@LF),@LF)
	ConsoleWrite($aWords[0]&' $siteName[1]='&$siteName[1]&@CRLF)
	if $aWords[0] > 1 Then
;~ 	ConsoleWrite('$aWords[0]='&$aWords[0]&@CRLF)
		For $wrd=2 to $aWords[0]
			$aWords[$wrd] = StringStripWS($aWords[$wrd],3)
			$Param = StringSplit($aWords[$wrd],';')
			if $Param[0] < 2 then ContinueLoop ; не обробатывать если строка параметров слишком маленькая
;~ 			ConsoleWrite('$Param[2]='&$Param[2]&@CRLF)
;~ 			ConsoleWrite('$Param[8]='&$Param[8]&@CRLF)
			if $Param[8] = 'n/a' then $Param[8] = 0
			$ind = __MyArraySearch($aAnalizWords,$Param[2])
			if not @error and $ind<>-1 Then
;~ 				ConsoleWrite($aAnalizWords[$ind][1] & ' <> ' & $Param[8] & '; $siteName=' & $siteName[1] & '; $Param[2]=' & $Param[2] & ' ' & '' & @CRLF)
				$aAnalizWords[$ind][2] &= $siteName[1] & ', '
				if $aAnalizWords[$ind][1] > Number($Param[8]) then
					if $aAnalizWords[$ind][1] > 1 then ConsoleWrite($aAnalizWords[$ind][1] & ' <> ' & $Param[8] & '; $siteName=' & $siteName[1] & '; $Param[2]=' & $Param[2] & ' ' & '' & @CRLF)
;~ 					$aAnalizWords[$ind][1] = Number($Param[8])
				EndIf
			Else
				$aAnalizWords[$iAW][0] = $Param[2]
				$aAnalizWords[$iAW][1] = Number($Param[8])
				$aAnalizWords[$iAW][2] &= $siteName[1] & ', '
				$corrnum=-1
				For $i2 = 4 to 10 ; копирование остальных ячеек
					if $i2 = 8 then $corrnum+=1
					$aAnalizWords[$iAW][$i2] = $Param[$i2+$corrnum]
				Next
				Redim $aAnalizWords[$iAW+2][17]
				$iAW +=1
			EndIf
		Next
	Else
	EndIf


Next
_ArraySort($aAnalizWords,1,0,0,1)

;~ ;упорядычивание сайтов по рейтингу
For $awi=0 to Ubound($aAnalizWords)-1
	$sSitesOnReit=''
	; подсчет количества сайтов
	$t3 = StringSplit($aAnalizWords[$awi][2], ', ', 1)
	$aAnalizWords[$awi][3] = $t3[0]
	For $reit=0 to Ubound($SiteRating)-1
		$aAnalizWords[$awi][2]=StringReplace($aAnalizWords[$awi][2], $SiteRating[$reit][1] & ', ', '')
		if @extended>0 Then
			$sSitesOnReit &= $SiteRating[$reit][1] & ', '
		EndIf
	Next
	$aAnalizWords[$awi][2] = $sSitesOnReit ;& $aAnalizWords[$awi][2]

Next

FileDelete($fileAnalizWords)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileDelete($fileAnalizWords) = ' & FileDelete($fileAnalizWords) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$Header = 'Запрос;Запросов в месяц;Сайты на которые попадают по запросу;Популярность на сайтах этой группы;Яndex;Google;Яndex Директ;Google Adwords;Видимость;' & _
'Запросов в месяц;показы !wordstat;показы wordstat;Стоимость;Эфф. cтоимость;Эфф. cтоимость 1 показа;Эфф. показов;Коммерческая cтоимость;' & @CRLF
FileWrite($fileAnalizWords,$Header)
FileWrite($fileAnalizWords,_ArrayToString($aAnalizWords,';'))

;~ _ArrayDisplay($aAnalizWords)


$count1Dim = Ubound($aAnalizWords,1)
$count2Dim = Ubound($aAnalizWords,2)
local $aAnalizWords2[1][$count2Dim], $ind2=0
For $i=0 to $count1Dim-1
	if $aAnalizWords[$i][3] >= $MinQSites then
		For $i2=0 to $count2Dim-1
			$aAnalizWords2[$ind2][$i2] = $aAnalizWords[$i][$i2]
		Next
		$ind2+=1
		redim $aAnalizWords2[$ind2+1][$count2Dim]
	EndIf

Next

FileDelete($fileAnalizWords2)
FileWrite($fileAnalizWords2,$Header)
FileWrite($fileAnalizWords2,_ArrayToString($aAnalizWords2,';'))

















Func __MyArraySearch(ByRef $array,$search)
	For $i=0 to UBound($array)-1
		if $array[$i][0] == $search then
			return $i
		EndIf
	Next
	return -1
EndFunc



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





