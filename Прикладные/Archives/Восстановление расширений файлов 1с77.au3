#include <array.au3>
#include <File.au3>
$testsleep = 100
HotKeySet("{Esc}", "Terminate")
Func Terminate()
	Exit
EndFunc   ;==>Terminate
;~ Opt('MustDeclareVars', 1)

Global $aBaseFiles[2][5], $iBaseFiles = 1 ;������ �� ���������� -  ��� ����� | ������ ��������� | ������ ������
;~ Global $aResult[2][3], $iResult = 1

$pathZahifrovannye = 'd:\Temp\test\Trio\Zashifrovannye2\'

$path = 'd:\Temp\test\Trio\predprinimatelVadia\1SBMDemo\'
_GetNumNameDBFFiles($path)
$path = 'd:\Temp\test\Trio\predprinimatelVadia\1SBMDB\'
_GetNumNameDBFFiles($path)
$path = 'd:\Temp\test\Trio\Kopiia predprinimatelVadia\1SBMDemo\'
_GetNumNameDBFFiles($path)
$path = 'd:\Temp\test\Trio\Kopiia predprinimatelVadia\1SBMDB\'
_GetNumNameDBFFiles($path)
$path = '\\server01\�����\�������\���������\2\'
_GetNumNameDBFFiles($path)
$path = '\\server01\�����\�������\���������\'
_GetNumNameDBFFiles($path)
	;~ $path = 'd:\Temp\test\Trio\predprinimatelVadia\1SBMDemo\'
	;~ _GetNumNameDBFFiles($path)

_Array2DUnique($aBaseFiles, 1)
_FileWriteFromArray(@ScriptDir&'\'&'testarray.txt', $aBaseFiles)
_FileReadToArray(@ScriptDir & '\' & 'testarray.txt', $aBaseFiles, 161, '|')
;~ _ArrayDisplay($aBaseFiles)
ScanNewFiles($pathZahifrovannye, '*.cbf')
;~ _ScanNewFilesCompareStart($pathZahifrovannye, 'd:\Temp\test\Trio\Kopiia predprinimatelVadia\cdx\', '*.cbf', '*.cdx')
;~ 			$Findall = _ArrayFindAll($aBaseFiles, 97, 0, 0, 0, 0, 1)
;~ 			_ArrayDisplay($Findall)

Func _ScanNewFilesCompareStart($path1, $path2, $mask1, $mask2)
	$Filelist1 = _FileListToArray($path1, $mask1)
	$Filelist2 = _FileListToArray($path2, $mask2)
	Local $aTemp[$Filelist2[0] + 1][3]
	For $i = 1 To $Filelist1[0]
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Filelist1[$i] = ' & $Filelist1[$i] & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($path1 & $Filelist1[$i]) = ' & FileGetSize($path1 & $Filelist1[$i]) & @CRLF) ;### Debug Console
;~ 		For $j = 1 To $Filelist2[0]
;~ 			$aTemp[$j][0] = _CompareStartFiles2($path1 & $Filelist1[$i], $path2 & $Filelist2[$j])
;~ 			$aTemp[$j][1] = $Filelist2[$j]
;~ 		Next
;~ 		_ArraySort($aTemp, 1)
;~ 		_ArrayDisplay($aTemp,"������ ����� " & StringRight($Filelist1[$i],40))
;~ 		Dim $aTemp[$Filelist2[0] + 1][3]

		For $j = 1 To $Filelist2[0]
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Filelist2[$j] = ' & $Filelist2[$j] & @CRLF) ;### Debug Console
			$aTemp[$j][0] = _CompareStartFiles($path1 & $Filelist1[$i], $path2 & $Filelist2[$j])
			$aTemp[$j][1] = $Filelist2[$j]
			$aTemp[$j][2] = FileGetSize($path2 & $Filelist2[$j])
		Next
		_ArraySort($aTemp, 1)
		_ArrayDisplay($aTemp, "������ ����� " & StringRight($Filelist1[$i], 40))
	Next
EndFunc   ;==>_ScanNewFilesCompareStart

Func _CompareStartFiles($file1, $file2, $mindif = 5)
	$steps = 40000
	$stepRead = 1
	;���������� ����� ���� ������, �� � ����� ������
	$filesize = FileGetSize($file1)
	$filesize2 = FileGetSize($file2)
	If $filesize2 < $filesize Then
		$t = $file1
		$file1 = $file2
		$file2 = $t
		$filesize = $filesize2
	EndIf
	If $filesize = 0 Then Return 0
	$hf1 = FileOpen($file1, 16)
	$hf2 = FileOpen($file2, 16)
;~ 	$mindif = $mindif * 2
	$diffs = 0
	$schet = 0
	For $s = 1 To $steps
		$Content1 = StringTrimLeft(FileRead($hf1, $stepRead), 2)
		$Content2 = StringTrimLeft(FileRead($hf2, $stepRead), 2)
		If $Content1 = $Content2 Then
			$diffs = 0
		Else
			$diffs += 1
;~ 			ConsoleWrite('$s = '&$s&' $Content1 = '&$Content1&' $Content2 = '&$Content2&@CRLF)
		EndIf
		$schet += 1
		If $diffs >= $mindif Then ExitLoop
	Next
	Return $schet - $diffs


EndFunc   ;==>_CompareStartFiles

Func _CompareStartFiles2($file1, $file2, $mindif = 5) ; $mindif ����������� ���������� ������ �������� ������
	$stepRead = 4096
	;���������� ����� ���� ������, �� � ����� ������
	$filesize = FileGetSize($file1)
	$filesize2 = FileGetSize($file2)
	If $filesize2 < $filesize Then
		$t = $file1
		$file1 = $file2
		$file2 = $t
		$filesize = $filesize2
	EndIf
	If $filesize = 0 Then Return 0
	If $filesize < $stepRead Then $stepRead = $filesize * 0.6
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $filesize = ' & $filesize & @CRLF) ;### Debug Console
	$hf1 = FileOpen($file1, 16)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $file1 = ' & $file1 & @CRLF) ;### Debug Console
	$hf2 = FileOpen($file2, 16)
	$mindif = $mindif * 2
	$steps = Floor($filesize / $stepRead)
	$lastread = $filesize - $stepRead * $steps
	$c = 1
	For $s = 1 To $steps
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $s = ' & $s & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $c = ' & $c & @CRLF) ;### Debug Console
		If $s = $steps Then $stepRead = $lastread
		$aContent1 = StringSplit(StringTrimLeft(FileRead($hf1, $stepRead), 2), '')
		$aContent2 = StringSplit(StringTrimLeft(FileRead($hf2, $stepRead), 2), '')
		$diffs = 0
		$c = 1
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aContent1[0] = ' & $aContent1[0] & @CRLF) ;### Debug Console
		For $c = 1 To $aContent1[0]
			If $aContent1[$c] <> $aContent2[$c] Then
;~ 				ConsoleWrite('@@ Debug(' & ($s * $stepRead + $c) & ') : $aContent2[$c] = ' & $aContent2[$c]& ') : $aContent1[$c] = ' & $aContent1[$c] & @CRLF) ;### Debug Console
				$diffs += 1
			Else
				$diffs = 0
			EndIf
			If $diffs >= $mindif Then ExitLoop 2
		Next
		; ������ �������, ����� ����� ���� ����������
;~ 		If $c = $stepRead * 2 Then ContinueLoop
;~ 		ExitLoop
	Next
	FileClose($hf1)
	FileClose($hf2)

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $s = ' & $s & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $c = ' & $c & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $diffs = ' & $diffs & @CRLF) ;### Debug Console
	Return (($s - 1) * $stepRead * 2 + $c - $diffs) / 2
EndFunc   ;==>_CompareStartFiles2


Func ScanNewFiles($path, $mask)
	$Filelist = _FileListToArray($path, $mask)
;~ 	_ArrayDisplay($Filelist)
	For $i = 1 To $Filelist[0]
		; ��������� � ����� ���
		$hf = FileOpen($path & $Filelist[$i], 16)
		$Filecontent = StringTrimLeft(FileRead($hf, 12), 2)
		FileClose($Filecontent)
		If StringLeft($Filecontent, 2) = '03' Then

			$BadName = $Filelist[$i]
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $BadName = ' & $BadName & @CRLF) ;### Debug Console
			$Num1 = Dec(_HexStringReverse(StringMid($Filecontent, 16 + 1, 4)))
			$Num2 = Dec(_HexStringReverse(StringMid($Filecontent, 20 + 1, 4)))
;~ 			For $r=0 to UBound($iBaseFiles)-1
			$newName = ''
			$Findall = _ArrayFindAll($aBaseFiles, $Num1, 0, 0, 0, 0, 1)
;~ 			_ArrayDisplay($Findall)
			Dim $tname[100][2]
			$itn = 0
			For $f = 0 To UBound($Findall) - 1
				If $aBaseFiles[$Findall[$f]][2] = $Num2 And $aBaseFiles[$Findall[$f]][1] = $Num1 Then
					If $newName = '' Then
						$newName = $aBaseFiles[$Findall[$f]][0]
					Else
						$newName &= '+' & $aBaseFiles[$Findall[$f]][0]
						ConsoleWrite("������� ��� = " & $newName & @TAB & "; �.���. = " & $aBaseFiles[$Findall[$f]][1] & @TAB & "; �.���. = " & $aBaseFiles[$Findall[$f]][2] & @CRLF)
					EndIf
					$tname[$itn][0]= $aBaseFiles[$Findall[$f]][0]
					$tname[$itn][1]= _compareZagolovki(_GetZagolovki($path & $Filelist[$i],1), $aBaseFiles[$Findall[$f]][4])
					$itn+=1
;~ 					;����� ����� �������� ���������
;~ 					$hft = FileOpen($aBaseFiles[$Findall[$f]][3]&$aBaseFiles[$Findall[$f]][0],16)

				EndIf
			Next
			If $newName = '' Then
				ConsoleWrite('�� ������� ��� ����� ' & $BadName & ' ����������� �����' & @CRLF)
				ConsoleWrite('������ ��������� = ' & $Num1 & '; ������ ������ = ' & $Num2 & @CRLF)
				For $f = 0 To UBound($Findall) - 1
					ConsoleWrite("��� = " & $aBaseFiles[$Findall[$f]][0] & @TAB & "; �.���. = " & $aBaseFiles[$Findall[$f]][1] & @TAB & "; �.���. = " & $aBaseFiles[$Findall[$f]][2] & @CRLF)
				Next
			Else
				If StringInStr($newName, '+') Then $fullnames = $newName
;~ 				If StringInStr($newName, '+') Then
;~ 					;����������� ������� ����� �� �������� ����� ����� ����������
;~ 					$oneName = StringLeft($newName, StringInStr($newName, "+") - 1)
;~ 					For $on = 1 To 20
;~ 						If FileExists($path & $oneName) Then
;~ 							$twoname = StringReplace($newName, $oneName & '+', '')
;~ 							If StringLen($twoname) > 3 Then
;~ 								$t = StringLeft($twoname, StringInStr($twoname, "+") - 1)
;~ 								If StringLen($t) > 3 Then
;~ 									$oneName = $t
;~ 								Else
;~ 									$oneName = $twoname
;~ 								EndIf
;~ 							Else
;~ 								ExitLoop
;~ 							EndIf
;~ 						Else
;~ 							ExitLoop
;~ 						EndIf
;~ 					Next

;~ 					$newName = StringRegExpReplace($newName, '\+?' & $oneName & '\+?', '+')
;~ 					$newName = $oneName & '(' & $newName & ')'
;~ 				EndIf
;~ 				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $newName = ' & $newName & @CRLF) ;### Debug Console

				;����������� ������� ����� �� ����������
				if StringLen($tname[1][0])>2 Then
;~ 					_ArrayDisplay($tname)
					_ArraySort($tname,1,0,0,1)
;~ 					_ArrayDisplay($tname)
					$newName = $tname[0][0]
;~ 					Exit
				EndIf

				; ���������� � ����� ����� ���� ���� ����������
				$rename = ''
				If FileExists($path & $newName) Then $rename = '(2)'
				$irename = 2
				While FileExists($path & $newName & $rename)
					$irename += 1
					$rename = '(' & $irename & ')'
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $rename = ' & $rename & @CRLF) ;### Debug Console
;~ 					Sleep(1000)
				WEnd
				if $rename <> '' then $rename &= $fullnames

				FileMove($path & $Filelist[$i], $path & $newName & $rename)
			EndIf


;~ 			ConsoleWrite(@TAB & $Filelist[$i] & @TAB & $aBaseFiles[$iBaseFiles][1] & @TAB & $aBaseFiles[$iBaseFiles][2] & @CRLF)
;~ 			$iBaseFiles+=1
;~ 			Redim $aBaseFiles[$iBaseFiles+1][3]
		EndIf
	Next
EndFunc   ;==>ScanNewFiles

Func _compareZagolovki($Zag1,$Zag2)
	;������� ���������� ���������� � �������
	$aZag1 = StringSplit($Zag1,'&')
	$countZag1 = $aZag1[0]
	$aZag2 = StringSplit($Zag2,'&')
	$countZag2 = $aZag2[0]
	If $countZag2 < $countZag1 Then ;������ ��������� ���, ����� ������ ��� ����������
		$t = $countZag1
		$countZag1 = $countZag2
		$countZag2 = $t
		$t = $Zag1
		$Zag1 = $Zag2
		$Zag2 = $t
		$t = $aZag1
		$aZag1 = $aZag2
		$aZag2 = $t
		$t = ''
	EndIf
;~ 	$at = StringSplit($Zag1,'|')
;~ 	_ArrayDisplay($at)
;~ 	_ArrayDisplay($at2)
	$sovpadenia = 0
	For $i= 2 to $countZag1-1
		if _ArraySearch($aZag2,$aZag1[$i]) > -1 Then
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aZag1[$i] = ' & $aZag1[$i] & @CRLF ) ;### Debug Console
			$sovpadenia +=1
		EndIf
	Next
	;������������ ����������
	if $sovpadenia > 0 then $sovpadenia = $sovpadenia - ($countZag2-$countZag1)/2
	return $sovpadenia

EndFunc

Func _GetZagolovki($path, $mod=0)
	$readbytes = 4096
	$hft = FileOpen($path,16)
	$zagalovok = StringTrimLeft(FileRead($hft, $readbytes), 2)
	$zagalovokt = StringLeft($zagalovok,StringInStr($zagalovok,'202020')-1)
	if StringLen($zagalovokt) > 10 then $zagalovok = $zagalovokt
	FileClose($hft)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $zagalovok = ' & $zagalovok & @CRLF ) ;### Debug Console
;~ 	$aZagolovki = StringRegExp($zagalovok,"00000000(([0-9A-F])(?!00){6}[0-9A-F]{2,}?)00000000",3)
	$aZagolovki = StringRegExp($zagalovok,"00000000([0-9A-F]{8,}?)00000000",3)
	local $aTemp[UBound($aZagolovki)/2]
	$sTemp = '&'
	For $i=1 to UBound($aZagolovki)-1 step 2
		$aTemp[($i-1)/2] = StringRegExpReplace($aZagolovki[$i],'(00){2,}([0-9A-F]{8,}?)','$2',1)
		$sTemp &= $aTemp[($i-1)/2] & '&'
	Next

;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sTemp = ' & $sTemp & @CRLF ) ;### Debug Console
	if $mod = 1 Then return $sTemp
	return $aTemp
EndFunc

Func _GetNumNameDBFFiles($path)
	$Filelist = _FileListToArray($path, '*.DBF')
;~ 	_ArrayDisplay($Filelist)
	For $i = 1 To $Filelist[0]
		$hf = FileOpen($path & $Filelist[$i], 16)
		$Filecontent = StringTrimLeft(FileRead($hf, 12), 2)
		FileClose($Filecontent)
		If StringLeft($Filecontent, 2) = '03' Then

			$aBaseFiles[$iBaseFiles][0] = $Filelist[$i]
			$aBaseFiles[$iBaseFiles][1] = Dec(_HexStringReverse(StringMid($Filecontent, 16 + 1, 4)))
			$aBaseFiles[$iBaseFiles][2] = Dec(_HexStringReverse(StringMid($Filecontent, 20 + 1, 4)))
			$aBaseFiles[$iBaseFiles][3] = $path
			$aBaseFiles[$iBaseFiles][4] = _GetZagolovki($path & $Filelist[$i],1)
			ConsoleWrite(@TAB & $Filelist[$i] & @TAB & $aBaseFiles[$iBaseFiles][1] & @TAB & $aBaseFiles[$iBaseFiles][2] & @CRLF)
			$iBaseFiles += 1
			ReDim $aBaseFiles[$iBaseFiles + 1][5]
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
				$schet = -1
				For $c = 0 To $CountCol ; ������� ���������� ���������� � ������
					If $array[$i][$c] = $array[$inds][$c] Then $schet += 1
				Next
				If $schet = $CountCol Then ;��� ������ ����������
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

	Local $column_to_left[$l_nlength_vtarget + 2], $current_column[$l_nlength_vtarget + 2]

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

EndFunc   ;==>_levenshtein

#cs
	������ � 2-������ ������� ��� ������������� ������ (���� ��� $a_Array[n][q], �� ������ = $a_Array[i][0] & $a_Array[i][1] & ... & $a_Array[i][q - 1]).
	$a_Array        - 2-������ ������.
	$i_Start        - ������ ������, ������� � ������� ���� �������� (������ 0 ��� 1) (-1 = 0, Default = 0). �� ��������� 0.
	$i_Casesense    - 0 - �� ��������� �������, 1 - ���������. �� ��������� 0.
	��� ������ ������  1, ���� @error = 0 � ���� @extended = ���-�� ��������� (�������������) �����.
	��� ������� ������ 0 � ���� @error =
	1               - $a_Array �� 2-������ ������.
	2               - $i_Start - ������������ ��������.
	3               - ������ �������� ������� Scripting.Dictionary
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
