#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=D:\torrents\MInstAll v.27.06.2015 By Andreyonohov & Leha342\MInstAll\software\System\CMD_RUN_FIX.exe
#AutoIt3Wrapper_Outfile_x64=D:\torrents\MInstAll v.27.06.2015 By Andreyonohov & Leha342\MInstAll\software\System\CMD_RUN_FIX.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <array.au3>
#Include <FileOperations.au3>

$file=''
$ScriptDir = @ScriptDir
;~ $ScriptDir = 'D:\torrents\MInstAll v.27.06.2015 By Andreyonohov & Leha342\MInstAll\software\System\.NET Framework'
$fileName = StringRegExpReplace(@AutoItExe, '.*' & '\' & '|\.[^.]*$', '')
$aFiles = _FO_FileSearch($ScriptDir,'*.bat|*.cmd',True,0)
if $aFiles[0]=1 Then
	$file=$aFiles[1]
Else
	For $i=0 to $aFiles[0]
		if Stringinstr($fileName,$aFiles[$i]) Then
			$file=$aFiles[$i]
			ExitLoop
		EndIf
	Next
EndIf

$FileContent = FileRead($file)
if @error then Exit
$aFileContent = StringSplit(StringReplace($FileContent,@CRLF,@LF),@CRLF)
;только запуск exe
For $i=0 to $aFileContent[0]
	$RunFile=''
	$find0=''
	$find20=''
	$find30=''
	$find = StringRegExp($aFileContent[$i],'[^ \\/:*?"<>|]*.exe',2)
	$find2 = StringRegExp($aFileContent[$i],'[^ \\/:*?"<>|]* [^ \\/:*?"<>|]*.exe',2)
	$find3 = StringRegExp($aFileContent[$i],'[^ \\/:*?"<>|]* [^ \\/:*?"<>|]* [^ \\/:*?"<>|]*.exe',2)
	if IsArray($find) then $find0=$find[0]
	if IsArray($find2) then $find20=$find2[0]
	if IsArray($find3) then $find30=$find3[0]
	if _FileExists(@ScriptDir&$find0) Then
		$RunFile = @ScriptDir&$find0
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $RunFile = ' & $RunFile & @CRLF) ;### Debug Console
	Elseif _FileExists(@ScriptDir&$find20) Then
		$RunFile = @ScriptDir&$find20
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $RunFile = ' & $RunFile & @CRLF) ;### Debug Console
	Elseif _FileExists(@ScriptDir&$find30) Then
		$RunFile = @ScriptDir&$find30
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $RunFile = ' & $RunFile & @CRLF) ;### Debug Console
	EndIf


;~ 	_ArrayDisplay($find)
;~ 	If FileExists(
;~ 	Run(@ComSpec&' /c '&$aFileContent[$i,$ScriptDir,@SW_HIDE)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aFileContent[$i] = ' & $aFileContent[$i] & @CRLF) ;### Debug Console
	ConsoleWrite($RunFile & @CRLF)
Next

;~ For $i=0 to $aFileContent[0]
;~ 	Run(@ComSpec&' /c '&$aFileContent[$i],$ScriptDir,@SW_HIDE)
;~ 	ConsoleWrite($aFileContent[$i] & @CRLF)
;~ Next


;~ _PathSplitByRegExp()











Func _FileExists($path)
	if FileExists ( $path ) Then
		if not StringInStr(FileGetAttrib ( $path  ),'D') Then return 1
	EndIf
	return 0
EndFunc


Func _SCompare($text1,$text2)
EndFunc



Func _PathSplitByRegExp($sPath,$pDelim='')
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"

    $aRetArray[0] = $sPath ;Full path
    $aRetArray[1] = StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
    $aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
    $aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
    $aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
    $aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
    $aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
    $aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file

    Return $aRetArray
EndFunc