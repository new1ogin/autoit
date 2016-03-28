;~ #Region ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #AutoIt3Wrapper_UseX64=n
;~ #AutoIt3Wrapper_Change2CUI=y
;~ #EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #Region *;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #RequireAdmin
#include <Constants.au3>
#include <Encoding.au3>
#include <array.au3>
#include <Encoding.au3>
Opt('MustDeclareVars',1)
Opt("WinTitleMatchMode", 1)
Local $Sleep, $timerReStart, $FindUser, $server, $username, $pass
local $sString, $help, $apatchq, $t1, $helptext, $timerst, $title
global $Patchqwinsta, $timer
$Sleep = 5000 ; Период проверки в мс
$timerReStart = 200000 ; Минимальное время для повторного запуска RDP в мс
$Patchqwinsta = "C:\Windows\System32\qwinsta.exe"
$FindUser = 'Виталий' ; Имя искомого пользователя
$server = '192.168.0.250'
$username = $FindUser
$pass = 'Zydfhm15'

$help = stringLeft($CmdLine[1],2)
if $help = '/h' or $help = '/?' or $help = '-h' or $help = '-?' Then
	$helptext = "Функция поиска вошедшего пользователя на сервер, и входа по rdp если пользователя нет среди вошедших" & @CRLF & _
	"Использование: Find_n_Logon.exe ServerFullAddres FindUser PasswordUser" & @CRLF & _
	"Пример: Find_n_Logon.exe 192.168.0.250 Виталий QWErty123" & @CRLF & _
	"Пример: Find_n_Logon.exe Server01 Администратор 1234"& @CRLF
	Msgbox(0, 'Подсказка', $helptext)
	ConsoleWrite(_Encoding_ANSIToOEM($helptext))
	exit
Else
	if $CmdLine[0] < 3 Then
		_Quit('Недостаточно параметров для запуска файла, смотри справку -h')
		exit
	EndIf
	$server = $CmdLine[1]
	$FindUser = $CmdLine[2]
	$username = $FindUser
	$pass = $CmdLine[3]
	if $CmdLine[0] > 3 Then $Patchqwinsta = $CmdLine[4]
EndIf
;~ Msgbox(0,'',$server & ' ' & $FindUser & ' ' & $pass)
; Решаем проблему с недоступностью файла qwinsta.exe
;~ if not FileExists($Patchqwinsta) Then
;~ 	$apatchq = _PathSplitByRegExp($Patchqwinsta)
;~ 	if not FileExists($apatchq[3] & '2.' & $apatchq[7]) Then
;~ 		$t1 = Run(@ComSpec & ' /C  copy ' & $Patchqwinsta & ' ' & $apatchq[3] & '2.' & $apatchq[7])
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : '' /C  copy '' & $Patchqwinsta & '' '' & $apatchq[3] & ''2.'' & $apatchq[7] = ' & ' /C  copy ' & $Patchqwinsta & ' ' & $apatchq[3] & '2.' & $apatchq[7] & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF) ;### Debug Console
;~ 		$t1 = FileCopy($Patchqwinsta, $apatchq[3] & '2.' & $apatchq[7])
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF) ;### Debug Console
;~ 		$Patchqwinsta = $apatchq[3] & '2.' & $apatchq[7]
;~ 	Else
;~ 		$Patchqwinsta = $apatchq[3] & '2.' & $apatchq[7]
;~ 	EndIf
;~ EndIf
if not FileExists($Patchqwinsta) Then
	_Quit('Не найден или недоступен файл qwinsta.exe ('&$Patchqwinsta&'), пожалуйста укажите к нему путь. Справка -h')
	exit
EndIf


While 1
	$sString = _GetStatusUser($FindUser,$server)
;~ 	_ArrayDisplay($sString)
;~ 	Msgbox(0,'',_timeReStart(@TempDir & '\timeReStart4Autoit.txt') & ' ' & $sString & ' ' & Ubound($sString))
	if UBound($sString) <= 2 Then
		$timerst = _timeReStart(@TempDir & '\timeReStart4Autoit.txt')
		if $timerst > $timerReStart or $timerst < 0 Then
;~ 			Msgbox(0,'',$server & ' ' & $username & ' ' & $pass)
			$title = _StartRdpUser($server, $username, $pass)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _StartRdpUser = ' & 1 & @CRLF) ;### Debug Console
			_timeReStart(@TempDir & '\timeReStart4Autoit.txt', 1)
			WinWait($title)
			WinSetState($title,'',@SW_HIDE)
			WinSetState($title,'',@SW_MINIMIZE)
			sleep(5000)
			_closeWinRDP($title)
		EndIf
	EndIf
	Sleep($Sleep)
WEnd

Exit

; Выход с возвраением текста
Func _Quit($text)
	ConsoleWrite(_Encoding_ANSIToOEM($text))
	Msgbox(0, 'Ошибка', $text)
	Exit
EndFunc

; получсение статуса искомого пользователя командой qwinsta
Func _GetStatusUser($FindUser,$server,$timerlim=60000)
	local $sRead, $iPID, $timer, $tReturn, $sString
	$sRead = ''
	$iPID = Run(@ComSpec & ' /C ' & $Patchqwinsta & ' /server:'&$server, @UserProfileDir, @SW_HIDE, $STDOUT_CHILD)
	If Not $iPID Then
		ProcessClose($iPID)
		if $timerlim <> 180000 Then
			$tReturn = _GetStatusUser($FindUser,$server,180000)
			if $tReturn <> 0 Then Return $tReturn
		Else
			Return 0
		EndIf
	EndIf
	$timer = TimerInit()
	While 1
		$sRead &= StdoutRead($iPID)
		If @error Then ExitLoop
		Sleep(10)
		if TimerDiff($timer) > $timerlim Then
			ProcessClose($iPID)
			if $timerlim <> 180000 Then
				$tReturn = _GetStatusUser($FindUser,$server,180000)
				if $tReturn <> 0 Then Return $tReturn
			Else
				Return 0
			EndIf
		EndIf
	WEnd
	$sRead = _Encoding_866To1251($sRead)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sRead = ' & $sRead & @CRLF) ;### Debug Console
	$sString = StringRegExp(StringLower($sRead),'('&StringLower($FindUser)&') +(\d+) +([а-яёА-ЯЁa-zA-Z]+)',2)
;~ 	_ArrayDisplay($sString)

	return $sString
EndFunc

; Функция запоминающая и возвращающая время последнего запуска
Func _timeReStart($patch, $mod=0)
	Local $hFile
	if $mod=0 Then
		If FileExists($patch) Then
			return TimerDiff(StringRegExpReplace(FileRead($patch),'(?i)(?s)[^0-9]*',''))
		Else
			return TimerDiff(0)
		EndIf
	Elseif $mod=1 Then
		$hFile = FileOpen($patch,10)
		FileWrite($hFile, TimerInit())
		FileClose($hFile)
	EndIf
EndFunc


; Подключение к RDP
Func _StartRdpUser($server,$username,$pass)
	local $randstr, $hFile, $titleSec, $classSec, $hwnd, $tmprdp
	; Создание Верменного файла .rdp
	$randstr = ''
	For $i=0 to 15
		$randstr &= Chr(Random(97,122,1))
	Next
	$hFile = FileOpen (@TempDir & '\' & $randstr & '.rdp' , 10)
	$tmprdp = FileGetLongName ( @TempDir & '\' & $randstr & '.rdp' )
	FileWrite($hFile, "full address:s:" & $server & @CRLF & "username:s:" & $username)
	FileClose($hFile)
;~ 	Msgbox(0,'',$tmprdp)
;~ 	ShellExecute('mstsc ', $tmprdp & ' /v:'&$server&' /admin /w:1024 /h:768')
;~ 	Run(@ComSpec & ' /C ' & 'mstsc ', $tmprdp & ' /v:'&$server&' /admin /w:1024 /h:768', '')
	$t1 = Run(@ComSpec & ' /C ' & 'mstsc ' & $tmprdp)
;~ 	MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '$t1' & @CRLF & @CRLF & 'Return:' & @CRLF & $t1) ;### Debug MSGBOX
	$titleSec = 'Безопасность Windows'
	$classSec = '#32770'
	WinWait("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]", '', 10)
	WinActivate("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]")
	$hwnd = WinGetHandle("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]")
	ControlSend($hwnd, '', '[CLASS:Edit; INSTANCE:1]', $Pass)
	ControlClick($hwnd, '', '[CLASS:Button; INSTANCE:2]')
	FileDelete($tmprdp)
	return $randstr
EndFunc

; Закрывает окно
Func _closeWinRDP($title)
	local $pid
	WinWait($title,'',20)
	$pid = WinGetProcess ($title)
	WinClose($title)
	$titleSec = 'Подключение к удаленному рабочему столу'
	$classSec = '#32770'
	WinWait("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]", '', 3)
	WinActivate("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]")
	ControlClick("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]", '', '[CLASS:Button; INSTANCE:1]')
	sleep(1000)
	ProcessClose($pid)
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