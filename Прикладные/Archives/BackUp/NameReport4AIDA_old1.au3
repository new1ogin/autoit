;~ #Include <FTPEx.au3>
;~ #include <File.au3>
#include <array.au3>
#include <Inet.au3>
#Include <FileOperations.au3>
#RequireAdmin
Global $aFilesFTP[1][6]

$TimeToWait = 30*60*1000
$ProcessName = 'aida64.exe'
$FileAIDA = @ScriptDir&'\aida64.exe'
$filepathReports = @ScriptDir & '\Reports'
$FileSendReportsOnFTP = @ScriptDir & '\SendReportsOnFTP.exe'
$TimeCompare = 5000 ;время сравнения списка файлов отчетов

; проверка на запущенность aida
if not ProcessExists($ProcessName) Then
	if not FileExists($FileAIDA) Then _error('Программа AIDA64 не запущена и не найдена в папке программы.')
	Run($FileAIDA)
	sleep(2000)
EndIf
;создаём массив для проверки новых файлов отчетов
$fileList = _FO_FileSearch($filepathReports, '*', True, 3)
If IsArray($fileList) And $fileList[0] > 0 Then
	$fileList = $fileList[0]
Else
	$fileList=0
EndIf


$PublicIP = _getPublicIP()
$timer = TimerInit()
$switch=2
$t=1
while 1
	if WinExists('[TITLE:Сохранить отчёт; CLASS:#32770]') Then
		$hwnd = WinGetHandle("[TITLE:Сохранить отчёт; CLASS:#32770]")
		ConsoleWrite('@@ Debug(' & $switch & ') : $hwnd = ' & $hwnd & @CRLF) ;### Debug Console
		if $switch = 0 Then
			$switch=1
			$hwnd = WinGetHandle("[TITLE:Сохранить отчёт; CLASS:#32770]")
			WinActivate($hwnd)
			sleep(200)
			$sText = ControlGetText($hwnd, "", "[CLASS:Edit; INSTANCE:1]")
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sText = ' & $sText & @CRLF) ;### Debug Console
			if $sText = "Report" Then
				$sText = $PublicIP&'_'&@ComputerName
				if StringLen(StringStripWS($sText,3)) > 1 Then
	;~ 				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sText = ' & $sText & @CRLF) ;### Debug Console
					ControlSetText($hwnd, "", "[CLASS:Edit; INSTANCE:1]",$sText)
				Else
					$switch=0
				EndIf
			EndIf

;~ 			ConsoleWrite($sText & @CRLF)
		EndIf
	Else
		$switch=0
	EndIf
	;сравнение списка файлов отчетов с начальным
	$timerDiff = TimerDiff($timer)
	if $timerDiff>$TimeCompare*$t Then
		$t+=1
		$fileList2 = _FO_FileSearch($filepathReports, '*', True, 3)
		If IsArray($fileList2) And $fileList2[0] > 0 Then
			$fileList2 = $fileList2[0]
		Else
			$fileList2=0
		EndIf
		if $fileList2>$fileList Then
			Run($FileSendReportsOnFTP)
		Endif
	EndIf
	sleep(200)
	if $timerDiff>$TimeToWait then ExitLoop
WEnd

exit

Func _SendPlus($send, $send2 = 0, $key = 0)
	If $key = 0 Then Send('{CTRLDOWN}')
	If $key = 1 Then Send('{SHIFTDOWN}')
	If $key = 2 Then Send('{ALTDOWN}')
	Sleep(64)
	Send($send)
	If $send2 <> 0 Then Send($send)
;~ 	  ControlSend('[CLASS:MozillaWindowClass]', '', '', $send)
;~ 	  if $send2<>0 then ControlSend('[CLASS:MozillaWindowClass]', '', '', $send2)
	Sleep(64)
	If $key = 0 Then Send('{CTRLUP}')
	If $key = 1 Then Send('{SHIFTUP}')
	If $key = 2 Then Send('{ALTUP}')
	Sleep(64)
EndFunc   ;==>_SendPlus

Func _getPublicIP()
	$xPage = InetRead("http://www.whatismyip.ru")
	$sPage = BinaryToString($xPage)
	$IP_pat = '(?s).+\<font\scolor\=blue\>\<h1\>Ваш\sip\sадрес:\<br\>\n(\d+\.\d+\.\d+\.\d+)\n\</h1\>\</font\>.+'
	return StringRegExpReplace($sPage, $IP_pat, '\1')
EndFunc


Func _error($text)
	Msgbox(0,"Ошибка помошника отчетов для AIDA64", "Ошибка помошника отчетов для AIDA64:" & @CRLF & $text, 20)
	Exit
EndFunc

Func _PathSplitByRegExp($sPath,$pDelim='', $mod=-1)
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"
	if $mod >= 0 Then
		Switch $mod
			Case 0
				return $sPath
			Case 1
				return StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
			Case 2
				return StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
			Case 3
				return StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
			Case 4
				return StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
			Case 5
				return StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
			Case 6
				return StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
			Case 7
				return StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file
		EndSwitch
	EndIf

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
