#include <Array.au3>

$NewLine='INSERT INTO #__abbook (id,asset_id,title,subtitle,alias,ideditor,price,pag,user_id,created_by_alias,description,image,file,year,idlocation,idlibrary,vote,numvote,hits,published,catid,qty,isbn,approved,userid,url,url_label,dateinsert,catalogo,checked_out,checked_out_time,access,metakey,metadesc,language,ordering,params,note,editedby) VALUES ('','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','','');'

;~ $file = FileOpen(@ScriptDir&'\abook2_0_4-export-02-02-2014-13-20.sql')
$file = FileOpen(@ScriptDir&'\Копия abook1_1_2-export-02-02-2014-12-19.sql')
;~ $file = FileOpen('D:\Vitaliy\PROGRAMS\autoitv3.3.8.1\abook1_1_2-export-02-02-2014-12-19.sql')
$fileRead=FileRead($file)
$stringSplitFile=Stringsplit($fileRead,@CRLF)

;Отчистка массива от ненужных видов
For $i=1 to Ubound($stringSplitFile)-1
	if StringInStr($stringSplitFile[$i],'INSERT INTO #__abbook')=0 then
	$stringSplitFile[$i]=''
	Else
	Endif
Next



$stringSplitFile=_ArrayClearEmpty($stringSplitFile, 0, 1)
;~ ConsoleWrite($fileRead&@CRLF)
Global $OriginalLine[Ubound($stringSplitFile)][2]


;Создание массивов параметорв строк
For $i=1 to Ubound($stringSplitFile)-1

	$StringRegExpFile=StringRegExp ( $stringSplitFile[$i], '\((.+)\).*?\((.+)\)' ,2)

		;Удаление апострофов параметров
		$StringRegExpFile[2]=StringTrimLeft ( $StringRegExpFile[2], 1)
		$StringRegExpFile[2]=StringTrimRight ( $StringRegExpFile[2], 1)
		$StringRegExpFile[2]=StringReplace($StringRegExpFile[2],"','",',')

		$OriginalLine[$i][0]=StringSplit($StringRegExpFile[1],',')
		$OriginalLine[$i][1]=StringSplit($StringRegExpFile[2],',')
_arrayDisplay($OriginalLine[$i][0])
		;удаление пустых (незаполненных) параметров
;~ 		$OriginalLine[$i][0]=_ArrayClearEmpty($OriginalLine[$i][0], 2)
;~ 		$OriginalLine[$i][1]=_ArrayClearEmpty($OriginalLine[$i][1], 2)
		$array=$OriginalLine[$i][0] ;отладка
;~ 		_ArrayDisplay($array)
Next

ConsoleWrite($stringSplitFile[0]&@CRLF)
;~ ConsoleWrite($OriginalLine[1]&@CRLF)
ConsoleWrite(Ubound( $array )&@CRLF)
_ArrayDisplay($stringSplitFile)


;получение формата новой строки
$StringRegExpFile2=StringRegExp ( $NewLine, '\((.+)\).*?\((.+)\)' ,2)
$NewLine2=StringSplit($StringRegExpFile2[1],',')
_arrayDisplay($NewLine2)

Local $NewData
;Создание Новых данных
For $i=1 to Ubound($stringSplitFile)-1
	$NewData&='INSERT INTO #__abbook (id,asset_id,title,subtitle,alias,ideditor,price,pag,user_id,created_by_alias,description,image,file,year,idlocation,idlibrary,vote,numvote,hits,published,catid,qty,isbn,approved,userid,url,url_label,dateinsert,catalogo,checked_out,checked_out_time,access,metakey,metadesc,language,ordering,params,note,editedby) VALUES ('
	local $array0,$array1
	$array0=$OriginalLine[$i][0]
	$array1=$OriginalLine[$i][1]
	Dim $Test[Ubound($array0)]
	For $t=1 to Ubound($NewLine2)-1
		$no=1
		For $s=1 to Ubound($array0)-1
			if $array0[$s]=$NewLine2[$t] and $array1[$s]<>'' then
				$NewData&="'"&$array1[$s]&"',"
				$no=0
				$Test[$s]=1
			Else

			EndIf
		Next
		if $no=1 then $NewData&="'"&"',"
;~ 		ConsoleWrite($NewData&@CRLF)
	Next
	$NewData=StringTrimRight ( $NewData, 1) ;Удаление последней запятой
	$NewData&=');'&@CRLF
;~ 	ConsoleWrite(' Вывод промежуточной информации '&@CRLF)
;~ ConsoleWrite($NewData&@CRLF)
Next
ConsoleWrite(' Вывод основной информации '&@CRLF)
ConsoleWrite($NewData&@CRLF)

;получение формата проверки
$StringRegExpFile2=StringRegExp ( $NewData, '\((.+)\).*?\((.+)\)' ,2)
$testLine2=StringSplit($StringRegExpFile2[1],',')
$testLine22=StringSplit($StringRegExpFile2[2],',')
_arrayDisplay($testLine2)
_arrayDisplay($testLine22)

;Удаление пустых значений в массиве
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