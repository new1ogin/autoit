Opt('MustDeclareVars',1)
#include <Constants.au3>
#include <Encoding.au3>
#include <array.au3>
#include <log.au3>
Opt('MustDeclareVars',1)
Opt("WinTitleMatchMode", 1)
Local $Sleep, $timerReStart, $FindUser, $server, $username, $pass
local $sString, $help, $apatchq, $t1, $helptext, $timerst, $returnStart, $closeresult
global $Patchqwinsta, $timer, $hLog, $Pidmstsc
$hLog = _Log_Open(@ScriptDir & '\Scan_n_Logon2.log', '### Лог программы Scan_n_Logon ###')
$Sleep = 5000 ; Период проверки в мс
$timerReStart = 600000 ; Минимальное время для повторного запуска RDP в мс
$Patchqwinsta = "C:\Windows\System32\qwinsta.exe"
$FindUser = 'Виталий' ; Имя искомого пользователя
$server = '192.168.0.250'
$username = $FindUser
$pass = '1234'

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

if not FileExists($Patchqwinsta) Then
	_Quit('Не найден или недоступен файл qwinsta.exe ('&$Patchqwinsta&'), пожалуйста укажите к нему путь. Справка -h')
	exit
EndIf

_Log_Report($hLog, "Запуск с параметрами: " & $server & ' ' & $FindUser & ' ' & 'Пароль ****' & @CRLF)
While 1
	$sString = _GetStatusUser($FindUser,$server)
;~ 	_ArrayDisplay($sString)
;~ 	Msgbox(0,'',_timeReStart(@TempDir & '\timeReStart4Autoit.txt') & ' ' & $sString & ' ' & Ubound($sString))
	if UBound($sString) <= 2 Then
		$timerst = _timeReStart(@TempDir & '\timeReStart4Autoit.txt')
		if $timerst > $timerReStart or $timerst < 0 Then
			_Log_Report($hLog, "Пользователь не найден, и будет осуществлен вход " & @CRLF)
;~ 			Msgbox(0,'',$server & ' ' & $username & ' ' & $pass)
			$returnStart = _StartRdpUser($server, $username, $pass)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _StartRdpUser = ' & 1 & @CRLF) ;### Debug Console
			_timeReStart(@TempDir & '\timeReStart4Autoit.txt', 1)
			_Log_Report($hLog, "Завершение запуска... Результат: " & $returnStart[1] & ' ' & @CRLF)
			WinWait($returnStart[0])
			WinSetState($returnStart[0],'',@SW_HIDE)
			WinSetState($returnStart[0],'',@SW_MINIMIZE)
			sleep(5000)
			$closeresult = _closeWinRDP($returnStart[0])
			_Log_Report($hLog, "Закрытие окна... Результат: " & $closeresult & ' ' & @CRLF)
		EndIf
	EndIf
	Sleep($Sleep)
WEnd

Exit

; Выход с возвраением текста
Func _Quit($text)
	_Log_Report($hLog, "Выход по ошибке: " & $text & @CRLF)
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
	local $randstr, $hFile, $titleSec, $classSec, $hwnd, $tmprdp, $r
	; Создание Верменного файла .rdp
	$randstr = ''
	For $i=0 to 15
		$randstr &= Chr(Random(97,122,1))
	Next
	$hFile = FileOpen (@TempDir & '\' & $randstr & '.rdp' , 10)
	$tmprdp = FileGetLongName ( @TempDir & '\' & $randstr & '.rdp' )
	FileWrite($hFile, "full address:s:" & $server & @CRLF & "username:s:" & $username)
	FileClose($hFile)
	$Pidmstsc = Run('mstsc ' & $tmprdp)
	_Log_Report($hLog, "Запуск... Имя временного файла RDP: " & @TempDir & '\' & $randstr & '.rdp' & ' PID mstsc: ' & $Pidmstsc & ' ' & @CRLF)
	$titleSec = 'Безопасность Windows'
	$classSec = '#32770'
	$r &= ' WinWait: ' & WinWait("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]", '', 10)
	$r &= ' WinActiv: ' & WinActivate("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]")
	$hwnd = WinGetHandle("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]")
	$r &= ' CntSend: ' & ControlSend($hwnd, '', '[CLASS:Edit; INSTANCE:1]', $Pass)
	$r &= ' CntClick: ' & ControlClick($hwnd, '', '[CLASS:Button; INSTANCE:2]')
	$r &= ' Fd: ' & FileDelete($tmprdp)
	Dim $return[2]
	$return[0] = $randstr
	$return[1] = $r
	return $return
EndFunc

; Закрывает окно
Func _closeWinRDP($title)
	local $pid, $titleSec, $classSec, $r
	$r=''
	WinWait($title,'',20)
	$pid = WinGetProcess ($title)
	$r &= ' WinClose: ' & WinClose($title)
	$titleSec = 'Подключение к удаленному рабочему столу'
	$classSec = '#32770'
	$r &= ' WinWait: ' & WinWait("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]", '', 3)
	$r &= ' WinActiv: ' & WinActivate("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]")
	$r &= ' CntClick ' & ControlClick("[TITLE:"&$titleSec&"; CLASS:"&$classSec&"]", '', '[CLASS:Button; INSTANCE:1]')
	sleep(1000)
	$r &= ' ProcClose1: ' & ProcessClose($pid)
	$r &= ' ProcClose2: ' & ProcessClose($Pidmstsc)
	return $r
EndFunc



Func _PathSplitByRegExp($sPath,$pDelim='')
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

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