#include <array.au3>
#include <File.au3>
$testsleep = 100
HotKeySet("{Esc}", "Terminate")
Func Terminate()
	Exit
EndFunc   ;==>Terminate
;~ Opt('MustDeclareVars', 1)

Global $aReturn[2][3], $iReturn = 1 ;массив со значениями -  Имя файла | Размер заголовка | Размер записи

$pathZahifrovannye = 'd:\Temp\test\Trio\Zashifrovannye\'
_CompareStartFiles('D:\Temp\test\Trio\Kopiia predprinimatelVadia\1SBMDB\SC3616.CDX','D:\Temp\test\Trio\Kopiia predprinimatelVadia\1SBMDB\SC5237.CDX')
exit
$path = 'd:\Temp\test\Trio\predprinimatelVadia\1SBMDemo\'
_GetNumNameDBFFiles($path)
$path = 'd:\Temp\test\Trio\predprinimatelVadia\1SBMDB\'
_GetNumNameDBFFiles($path)
$path = 'd:\Temp\test\Trio\Kopiia predprinimatelVadia\1SBMDemo\'
_GetNumNameDBFFiles($path)
$path = 'd:\Temp\test\Trio\Kopiia predprinimatelVadia\1SBMDB\'
_GetNumNameDBFFiles($path)
$path = '\\server01\общее\Клиенты\Полуянова\2\'
_GetNumNameDBFFiles($path)
$path = '\\server01\общее\Клиенты\Полуянова\'
_GetNumNameDBFFiles($path)
$path = 'd:\Temp\test\Trio\predprinimatelVadia\1SBMDemo\'
_GetNumNameDBFFiles($path)

_ArrayDisplay($aReturn)
_Array2DUnique($aReturn, 1)
;~ _FileWriteFromArray(@ScriptDir&'\'&'testarray.txt', $aReturn)
;~ _FileReadToArray(@ScriptDir & '\' & 'testarray.txt', $aReturn, 161, '|')
_ArrayDisplay($aReturn)
ScanNewFiles($pathZahifrovannye, '*.cbf')
;~ 			$Findall = _ArrayFindAll($aReturn, 97, 0, 0, 0, 0, 1)
;~ 			_ArrayDisplay($Findall)

Func _CompareStartFiles($file1,$file2,$mindif = 5) ; $mindif минемальное количество разных символов подряд
	$stepRead = 100
	;определяем какой файл меньше, он и будет первым
	$filesize = FileGetSize($file1)
	$filesize2 = FileGetSize($file2)
	if $filesize2 < $filesize Then
		$t = $file1
		$file1 = $file2
		$file2 = $t
		$filesize = $filesize2
	EndIf

	$hf1 = FileOpen($file1,16)
	$hf2 = FileOpen($file2,16)
	$mindif=$mindif*2
	$steps = Floor($filesize/$stepRead)
	$lastread = FileGetSize($file1)-$stepRead*$steps
	For $s = 1 to $steps
		if $s=$steps Then $stepRead=$lastread
		$aContent1 = StringSplit(StringTrimLeft(FileRead($hf1,$stepRead),2),'')
		$aContent2 = StringSplit(StringTrimLeft(FileRead($hf1,$stepRead),2),'')
		$diffs = 0
		For $c=1 to $stepRead*2
			if $aContent1[$c] <> $aContent2[$c] Then
				$diffs+=1
			Else
				$diffs = 0
			EndIf
			if $diffs >= $mindif Then ExitLoop 2
		Next
		; кривые условия, писал ночью лень исправлять
		if $c=$stepRead*2 Then ContinueLoop
		ExitLoop
	Next
	FileClose($hf1)
	FileClose($hf2)
	Return ($s*$c - $diffs)/2

EndFunc


Func ScanNewFiles($path, $mask)
	$Filelist = _FileListToArray($path, $mask)
;~ 	_ArrayDisplay($Filelist)
	For $i = 1 To $Filelist[0]
		$hf = FileOpen($path & $Filelist[$i], 16)
		$Filecontent = StringTrimLeft(FileRead($hf, 12), 2)
		FileClose($Filecontent)
		If StringLeft($Filecontent, 2) = '03' Then

			$BadName = $Filelist[$i]
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $BadName = ' & $BadName & @CRLF) ;### Debug Console
			$Num1 = Dec(_HexStringReverse(StringMid($Filecontent, 16 + 1, 4)))
			$Num2 = Dec(_HexStringReverse(StringMid($Filecontent, 20 + 1, 4)))
;~ 			For $r=0 to UBound($iReturn)-1
			$newName = ''
			$Findall = _ArrayFindAll($aReturn, $Num1, 0, 0, 0, 0, 1)
;~ 			_ArrayDisplay($Findall)
			For $f = 0 To UBound($Findall) - 1
				If $aReturn[$Findall[$f]][2] = $Num2 And $aReturn[$Findall[$f]][1] = $Num1 Then
					If $newName = '' Then
						$newName = $aReturn[$Findall[$f]][0]
					Else
						$newName &= '+' & $aReturn[$Findall[$f]][0]
						ConsoleWrite("Двойное имя = " & $newName & @TAB & "; Р.заг. = " & $aReturn[$Findall[$f]][1] & @TAB & "; Р.зап. = " & $aReturn[$Findall[$f]][2] & @CRLF)
					EndIf
				EndIf
			Next
			If $newName = '' Then
				ConsoleWrite('Не найдено для файла ' & $BadName & ' подходящего имени' & @CRLF)
				ConsoleWrite('Размер заголовка = ' & $Num1 & '; Размер записи = ' & $Num2 & @CRLF)
				For $f = 0 To UBound($Findall) - 1
					ConsoleWrite("Имя = " & $aReturn[$Findall[$f]][0] & @TAB & "; Р.заг. = " & $aReturn[$Findall[$f]][1] & @TAB & "; Р.зап. = " & $aReturn[$Findall[$f]][2] & @CRLF)
				Next
			Else
				;определение нужного имени из двойного имени путем исключения
				$oneName = StringLeft($newName, StringInStr($newName, "+") - 1)
				For $on = 1 To 20
					If FileExists($path & $oneName) Then
						$twoname = StringReplace($newName, $oneName & '+', '')
						if Stringlen($twoname) > 3 Then
							$t = StringLeft($twoname, StringInStr($twoname, "+") - 1)
							if Stringlen($t) > 3 Then
								$oneName = $t
							Else
								$oneName = $twoname
							Endif
						Else
							ExitLoop
						EndIf
					Else
						ExitLoop
					EndIf
				Next

				$newName=$oneName
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $newName = ' & $newName & @CRLF) ;### Debug Console

				$rename = ''
				If FileExists($path & $newName) Then $rename = '(2)'
				$irename = 2
				While FileExists($path & $newName & $rename)
					$irename += 1
					$rename = '('&$irename&')'
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $rename = ' & $rename & @CRLF) ;### Debug Console
					sleep(1000)
				WEnd

				FileMove($path & $Filelist[$i], $path & $newName & $rename)
			EndIf


;~ 			ConsoleWrite(@TAB & $Filelist[$i] & @TAB & $aReturn[$iReturn][1] & @TAB & $aReturn[$iReturn][2] & @CRLF)
;~ 			$iReturn+=1
;~ 			Redim $aReturn[$iReturn+1][3]
		EndIf
	Next
EndFunc   ;==>ScanNewFiles

Func _GetNumNameDBFFiles($path)
	$Filelist = _FileListToArray($path, '*.DBF')
;~ 	_ArrayDisplay($Filelist)
	For $i = 1 To $Filelist[0]
		$hf = FileOpen($path & $Filelist[$i], 16)
		$Filecontent = StringTrimLeft(FileRead($hf, 12), 2)
		FileClose($Filecontent)
		If StringLeft($Filecontent, 2) = '03' Then

			$aReturn[$iReturn][0] = $Filelist[$i]
			$aReturn[$iReturn][1] = Dec(_HexStringReverse(StringMid($Filecontent, 16 + 1, 4)))
			$aReturn[$iReturn][2] = Dec(_HexStringReverse(StringMid($Filecontent, 20 + 1, 4)))
			ConsoleWrite(@TAB & $Filelist[$i] & @TAB & $aReturn[$iReturn][1] & @TAB & $aReturn[$iReturn][2] & @CRLF)
			$iReturn += 1
			ReDim $aReturn[$iReturn + 1][3]
		EndIf
	Next
EndFunc   ;==>_GetNumNameDBFFiles

Func _Clear2dArray($array)
	_ArraySort($array)
	$CountLine = UBound($array) - 1
	$CountCol = UBound($array, 2) - 1
	Local $array2[$CountLine + 1][$CountCol + 1], $inds[$CountLine + 1]
	For $i = 0 To $CountLine - 1
		If $inds[$i] <> 1 Then
			$indCopy = _ArrayBinarySearch($array, $array[$i][0], $i + 1)
			If $indCopy >= 0 Then
				$Schet = -1
				For $c = 0 To $CountCol ; считает количество совпадений в строке
					If $array[$i][$c] = $array[$inds][$c] Then $Schet += 1
				Next
				If $Schet = $CountCol Then ;обе строки одинаковые
					$inds[$indCopy] = 1
					For $c = 0 To $CountCol
						$array2[$i][$c] = $array[$i][$c]
					Next
				Else
					For $c = 0 To $CountCol
						$array2[$i][$c] = $array[$i][$c]
						$array2[$inds][$c] = $array[$inds][$c]
					Next
				EndIf
			EndIf
		EndIf
	Next
	$array2 = _ArrayClearEmpty($array2)
	Return $array2
EndFunc   ;==>_Clear2dArray


Func _HexStringReverse($nHex)
	$aRet = StringRegExp($nHex, '([[:xdigit:]]{2})', 3)
	$sRet = ''

	For $i = UBound($aRet) - 1 To 0 Step -1
		$sRet &= $aRet[$i]
	Next

	Return $sRet
EndFunc   ;==>_HexStringReverse

Func _levenshtein($a_vsource, $a_vtarget);

	Local $l_nlength_vsource
	Local $l_nlength_vtarget
	Local $v_cost

	Local $i, $j

	$v_cost = 0
	$l_nlength_vsource = StringLen($a_vsource)
	$l_nlength_vtarget = StringLen($a_vtarget)

	Local $column_to_left[$l_nlength_vtarget+2], $current_column[$l_nlength_vtarget+2]

	If $l_nlength_vsource = 0 Then
		Return $l_nlength_vtarget
	ElseIf $l_nlength_vtarget = 0 Then
		Return $l_nlength_vsource
	Else
		For $j = 1 To ($l_nlength_vtarget + 1)
			$column_to_left[$j] = $j
		Next
		For $i = 1 To $l_nlength_vsource
			$current_column[1] = $i
			For $j = 2 To ($l_nlength_vtarget + 1)
				If StringMid($a_vsource, $i, 1) = StringMid($a_vtarget, $j - 1, 1) Then
					$v_cost = 0
				Else
					$v_cost = 1
				EndIf
				$current_column[$j] = $current_column[$j - 1] + 1
				If ($column_to_left[$j] + 1) < $current_column[$j] Then
					$current_column[$j] = $column_to_left[$j] + 1
				EndIf
				If ($column_to_left[$j - 1] + $v_cost) < $current_column[$j] Then
					$current_column[$j] = $column_to_left[$j - 1] + $v_cost
				EndIf
			Next
			For $j = 1 To ($l_nlength_vtarget + 1)
				$column_to_left[$j] = $current_column[$j]
			Next
		Next

	EndIf

	Return $current_column[$l_nlength_vtarget + 1] - 1

EndFunc   ;==>_gf_lev_distance

#cs
	Удалит в 2-мерном массиве все дублирующиеся строки (если дан $a_Array[n][q], то строка = $a_Array[i][0] & $a_Array[i][1] & ... & $a_Array[i][q - 1]).
	$a_Array        - 2-мерный массив.
	$i_Start        - индекс строки, начиная с которой идет проверка (только 0 или 1) (-1 = 0, Default = 0). По умолчанию 0.
	$i_Casesense    - 0 - не учитывать регистр, 1 - учитывать. По умолчанию 0.
	При успехе вернет  1, флаг @error = 0 и флаг @extended = кол-во удаленных (повторяющихся) строк.
	При неудаче вернет 0 и флаг @error =
	1               - $a_Array не 2-мерный массив.
	2               - $i_Start - некорректное значение.
	3               - Ошибка создания объекта Scripting.Dictionary
#ce
Func _Array2DUnique(ByRef $a_Array, $i_Start = 0, $i_Casesense = 0)
	Local $o_Dict, $i_Row, $i_Column, $a_TempArray = $a_Array, $i_Count, $s_Key

	If UBound($a_TempArray, 0) <> 2 Then Return SetError(1, 0, 0)
	$i_Row = UBound($a_TempArray, 1)
	$i_Start = Number($i_Start)
	Switch $i_Start
		Case 0, 1
		Case -1, Default
			$i_Start = 0
		Case Else
			Return SetError(2, 0, 0)
	EndSwitch
	If $i_Row - $i_Start < 1 Then Return SetError(2, 0, 0)
	$i_Count = $i_Start
	$i_Column = UBound($a_Array, 2)
	$o_Dict = ObjCreate('Scripting.Dictionary')
	If @error Then Return SetError(3, 0, 0)
	$o_Dict.CompareMode = Number(Not $i_Casesense)
	For $i = $i_Start To $i_Row - 1
		$s_Key = ''
		For $j = 0 To $i_Column - 1
			$s_Key &= $a_TempArray[$i][$j]
		Next
		If $o_Dict.Exists($s_Key) Then ContinueLoop
		$o_Dict.Item($s_Key)
		For $j = 0 To $i_Column - 1
			$a_Array[$i_Count][$j] = $a_TempArray[$i][$j]
		Next
		$i_Count += 1
	Next
	If $i_Count <> $i_Row Then ReDim $a_Array[$i_Count][$i_Column]
	Return SetExtended($i_Row - $i_Count, 1)
EndFunc   ;==>_Array2DUnique

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
