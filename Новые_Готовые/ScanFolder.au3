#include <File.au3>
#include <Array.au3>
#include <FileOperations.au3>

;~ $FileList1=_FileListToArray(@ScriptDir)
$dir = @ScriptDir
;~ $dir = @DesktopDir
$_UserDir=@ScriptDir
global $dir = FileSelectFolder('Выберите папку для её сканирования',$_UserDir,4,$_UserDir) ;Запрос на ввод директории для поиска
if $dir = '' then exit
$filelistROOT = _FO_FolderSearch($dir, '*', True, 0)

$displaysize = 3
$displaydate1 = 3
$displaydate2 = 3
$displaymax = 0
If $displaysize <> 0 Then $displaymax += 1
If $displaydate1 <> 0 Then $displaymax += 1
If $displaydate2 <> 0 Then $displaymax += 1
;~ if $displaysize > $displaydate1 Then
;~ 	$displaymax += $displaysize
;~ Elseif $displaydate1 > $displaydate2 Then
;~ 	$displaymax += $displaydate1
;~ Else
;~ 	$displaymax += $displaydate2
;~ EndIf


ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $displaydate2 = ' & $displaydate2 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
Global $qParams = 4 ;количество колонок
Global $display[-2 + ($filelistROOT[0]) * (4 + $displaysize + $displaydate1 + $displaydate2) + $displaymax][$qParams], $iDisplay = 0 ; так и не понял почему -2 и 4+... но
$display[$iDisplay][0] = 'Имя:'
$display[$iDisplay][1] = 'Размер:'
$display[$iDisplay][2] = 'Дата изменения:'
$display[$iDisplay][3] = 'Дата доступа:'
$iDisplay += 1

;упорядочивание папок по размеру
Local $tafs[$filelistROOT[0] + 1][2]
For $fr = 1 To $filelistROOT[0]
	$tafs[$fr][0] = $filelistROOT[$fr]
	$tafs[$fr][1] = _DirGetSizeEx($filelistROOT[$fr])
Next
_ArraySort($tafs, 1, 1, 0, 1)
For $fr = 1 To $filelistROOT[0]
	$filelistROOT[$fr] = $tafs[$fr][0]
Next
;~ _ArrayDisplay($filelistROOT)

For $fr = 1 To $filelistROOT[0] ;Получение информации и вывод в массив для отображения
	ToolTip($fr)
	$filelist = _FO_FileSearch($filelistROOT[$fr])
	Local $tarray[$filelist[0] + 1][$qParams], $Fullsize = 0
;~ 	_ArrayDisplay($filelist)
	For $f = 1 To $filelist[0]
		$tarray[$f][0] = $filelist[$f]
		$tarray[$f][1] = FileGetSize($filelist[$f])
		$ta = FileGetTime($filelist[$f], 0)
		$tarray[$f][2] = $ta[0] & "/" & $ta[1] & "/" & $ta[2] & " " & $ta[3] & ":" & $ta[4]
		$ta = FileGetTime($filelist[$f], 2)
		$tarray[$f][3] = $ta[0] & "/" & $ta[1] & "/" & $ta[2] & " " & $ta[3] & ":" & $ta[4]
		$Fullsize += $tarray[$f][1]
	Next
	ToolTip($fr & '+')
	_ArraySort($tarray, 1, 0, 0, 1) ; сортировка по размеру
	;создание массива на вывод
	$iFolderdisplay = $iDisplay
	$display[$iFolderdisplay][0] = 'ВСЯ ПАПКА: ' & $filelistROOT[$fr]
	$display[$iFolderdisplay][1] = $Fullsize
	$iDisplay += 1
	If $displaysize > $filelist[0] Then $displaysize = $filelist[0] ; на тот случай если в папке меньше файлов чем надо вывести
	For $d = 1 To $displaysize
		If $d = 1 Then
			$display[$iDisplay][0] = '  САМЫЕ БОЛЬШИЕ ФАЙЛЫ:'
			$iDisplay += 1
		EndIf
		For $p = 0 To $qParams - 1
			If UBound($display) = $iDisplay Then ConsoleWrite('@@ Debug(' & UBound($display) & ') : $iDisplay = ' & $iDisplay & @CRLF & $p & $d & @CRLF) ;### Debug Console
			$display[$iDisplay][$p] = '  ' & $tarray[$d - 1][$p]
		Next
		$iDisplay += 1
	Next
	_ArraySort($tarray, 1, 0, 0, 2) ; сортировка по Дата изменения
	$display[$iFolderdisplay][2] = $tarray[1][2]
	If $displaydate1 > $filelist[0] Then $displaydate1 = $filelist[0] ; на тот случай если в папке меньше файлов чем надо вывести
	For $d = 1 To $displaydate1
		If $d = 1 Then
			$display[$iDisplay][0] = '  САМЫЕ НОВЫЕ ПО ДАТЕ ИЗМЕНЕНИЯ:'
			$iDisplay += 1
		EndIf
		For $p = 0 To $qParams - 1
			$display[$iDisplay][$p] = '  ' & $tarray[$d - 1][$p]
		Next
		$iDisplay += 1
	Next
	_ArraySort($tarray, 1, 0, 0, 3) ; сортировка по Дата доступа
	$display[$iFolderdisplay][3] = $tarray[1][3]
	If $displaydate2 > $filelist[0] Then $displaydate2 = $filelist[0] ; на тот случай если в папке меньше файлов чем надо вывести
	For $d = 1 To $displaydate2
		If $d = 1 Then
			$display[$iDisplay][0] = '  САМЫЕ НОВЫЕ ПО ДАТЕ ДОСТУПА:'
			$iDisplay += 1
		EndIf
		For $p = 0 To $qParams - 1
			$display[$iDisplay][$p] = '  ' & $tarray[$d - 1][$p]
		Next
		$iDisplay += 1
	Next
	ToolTip('')
;~ 	_ArrayDisplay($tarray)

Next

;приведение массива в читаемый вид
$maxLen = StringLen($display[0][0])
$procentLen = 1.05
$tText = ''
For $i = 1 To UBound($display) - 1
	$display[$i][1] = _ConvertFileSize($display[$i][1])
	If StringLen($display[$i][0]) > $maxLen Then $maxLen = StringLen($display[$i][0])
Next
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $maxLen = ' & $maxLen & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
For $i = 0 To UBound($display) - 1
	If StringLeft($display[$i][0], 3) = 'ВСЯ' Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $display[$i][0] = ' & $display[$i][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		If StringLen($display[$i][0]) < $maxLen * $procentLen Then
			For $t = 1 To $maxLen * $procentLen - StringLen($display[$i][0])
				$tText &= '-'
			Next
			$display[$i][0] &= $tText
			$tText=''
		EndIf
	EndIf
Next

_ArrayDisplay($display)
;~ _ArrayDisplay($filelist)


Func _ConvertFileSize($iBytes)
	Local Const $iConst = 0.0000234375 ; (1024 / 1000 - 1) / 1024
	Switch $iBytes
		Case 110154232090684 To 1125323453007766
			$iBytes = Round($iBytes / (1099511627776 + $iBytes * $iConst)) & ' TB'
		Case 1098948684577 To 110154232090683
			$iBytes = Round($iBytes / (1099511627776 + $iBytes * $iConst), 1) & ' TB'
		Case 107572492277 To 1098948684576
			$iBytes = Round($iBytes / (1073741824 + $iBytes * $iConst)) & ' GB'
		Case 1073192075 To 107572492276
			$iBytes = Round($iBytes / (1073741824 + $iBytes * $iConst), 1) & ' GB'
		Case 105156613 To 1073192074
			$iBytes = Round($iBytes / (1048576 + $iBytes * $iConst)) & ' MB'
		Case 1048040 To 105156612
			$iBytes = Round($iBytes / (1048576 + $iBytes * $iConst), 1) & ' MB'
		Case 102693 To 1048039
			$iBytes = Round($iBytes / (1024 + $iBytes * $iConst)) & ' KB'
		Case 1024 To 102692
			$iBytes = Round($iBytes / (1024 + $iBytes * $iConst), 1) & ' KB'
		Case 0 To 1023
			$iBytes = Int($iBytes / 1.024)
	EndSwitch
	If $iBytes = 0 Then $iBytes = ''
	Return $iBytes
EndFunc   ;==>_ConvertFileSize

Func _DirGetSizeEx($sPath)
	Local $aPathIsDir, $iSize, $iErr = 0, $iRet = 0

	If Not $sPath Then
		Return SetError(1)
	EndIf

	If Not IsDeclared("o_DGSE_FSO") Then
		Global $o_DGSE_FSO = ObjCreate("Scripting.FileSystemObject")
		Global $o_DGSE_ErrEvent = ObjEvent("AutoIt.Error", "_DirGetSizeEx")
	EndIf

	$aPathIsDir = DllCall('shlwapi.dll', 'int', 'PathIsDirectoryW', 'wstr', $sPath)

	If Not $aPathIsDir[0] Then
		Return SetError(-1, 0, 0)
	EndIf

	If IsObj($o_DGSE_FSO) Then
		$iSize = $o_DGSE_FSO.GetFolder($sPath).Size

		If Not @error Then
			$iRet = $iSize
		EndIf
	EndIf

	If $iRet = 0 Then
		$iRet = DirGetSize($sPath)

		If @error Then
			$iErr = 1
			$iRet = 0
		EndIf
	EndIf

	$o_DGSE_ErrEvent = 0
	Return SetError($iErr, 0, $iRet)
EndFunc   ;==>_DirGetSizeEx
