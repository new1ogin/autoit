#include <File.au3>
#include <Encoding.au3>

$iStart = TimerInit()
$NowDay = @YEAR & @MON & @MDAY & '000000'
$sDir = 'C:\Program Files (x86)\KidLogger\logs\Виталий' ;@SystemDir
If $CmdLine[0] > 0 And FileExists($CmdLineRaw) Then
	$sDir = $CmdLineRaw
Else
;~ 	_Quit('Недостаточно параметров для запуска файла, передайте полный путь директории' & $CmdLineRaw)
	$sDir = @ScriptDir
EndIf

$iIndex = 0
$iTime = 0
$iTimeOld = 0
$aFileList = _FileListToArray($sDir, '*', 1)
If Not @error Then
	For $i = 1 To $aFileList[0]
		$iTime = FileGetTime($sDir & '\' & $aFileList[$i], 0, 1)
		If $iTime < $NowDay Then
			If StringRight($aFileList[$i], 4) = '.htm' Or StringRight($aFileList[$i], 4) = 'html' Then
				_html_replace($sDir & '\' & $aFileList[$i], $sDir, $sDir & '\' & StringLeft($iTime, 8))
				DirCreate($sDir & '\' & StringLeft($iTime, 8))
				FileMove($sDir & '\' & $aFileList[$i], $sDir & '\' & StringLeft($iTime, 8) & '\' & $aFileList[$i])
			ElseIf StringRight($aFileList[$i], 4) = '.jpg' Or StringRight($aFileList[$i], 4) = 'jpeg' Then
				DirCreate($sDir & '\' & StringLeft($iTime, 8))
				FileMove($sDir & '\' & $aFileList[$i], $sDir & '\' & StringLeft($iTime, 8) & '\' & $aFileList[$i])
			EndIf

		EndIf
;~ 		exit
	Next
;~     MsgBox(0, 'Время выполнения : ' & Round(TimerDiff($iStart), 2) & ' ms', "Самый новый файл: " & $aFileList[$iIndex])
EndIf


Func _html_replace($file, $string, $replace)
	$FileText = FileRead($file)
	$FileText = StringReplace($FileText, $string, $replace)
	$hfile = FileOpen($file, 2 + 128)
	FileWrite($hfile, $FileText)
	FileClose($hfile)
EndFunc   ;==>_html_replace


; Выход с возвраением текста
Func _Quit($text)
;~ 	_Log_Report($hLog, "Выход по ошибке: " & $text & @CRLF)
	ConsoleWrite(_Encoding_ANSIToOEM($text))
	MsgBox(0, 'Ошибка', $text)
	Exit
EndFunc   ;==>_Quit
