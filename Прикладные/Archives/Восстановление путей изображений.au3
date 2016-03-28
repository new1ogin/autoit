#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FileOperations.au3>
#include <Array.au3>
$ScriptDir = @ScriptDir
;~ $ScriptDir = 'C:\Program Files (x86)\KidLogger\logs\Виталий'
$files = _FO_FileSearch($ScriptDir, '*.htm*')

For $i = 1 To $files[0]
	$fileContent = FileRead($files[$i])
	$dir = StringRegExpReplace($files[$i], "\\" & '[^' & "\\" & ']*$', '')

	; Исправляем перенос kelogger файлов
	$test = StringRight($dir, 9)
	If StringIsInt(StringMid($test, 2)) And Not StringIsInt(StringLeft($test, 1)) Then
		$fileContent = StringReplace($fileContent, '<link rel="StyleSheet" href="../../style.css" type="text/css" />', '<link rel="StyleSheet" href="../../../style.css" type="text/css" />')
	EndIf

	$fileContent = StringRegExpReplace($fileContent, "(<img src='file:///)(.*)(\\.*?')>", '$1' & StringReplace($dir, "\", "\\") & '$3 tabindex="0">')
	$hfile = FileOpen($files[$i], 2 + 128)
	FileWrite($hfile, $fileContent)
	FileClose($hfile)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hfile = ' & $hfile & @CRLF) ;### Debug Console
Next


Func _PathSplitByRegExp($sPath, $pDelim = '')
	If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

	Local $aRetArray[8] ;, $pDelim = ""

	If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
	If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

	If $pDelim = "" Then $pDelim = "/"
	If Not StringInStr($sPath, $pDelim) Then Return $sPath
	If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"

	$aRetArray[0] = $sPath ;Full path
	$aRetArray[1] = StringRegExpReplace($sPath, $pDelim & '.*', $pDelim) ;Drive letter
	$aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
	$aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
	$aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
	$aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
	$aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
	$aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file

	Return $aRetArray
EndFunc   ;==>_PathSplitByRegExp
