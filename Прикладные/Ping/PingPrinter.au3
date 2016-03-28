#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=PingPrinter.exe
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Constants.au3>
#include <Encoding.au3>
$mod=0

; Получение данных из командной строки
$help = stringLeft($CmdLine[1],2)
if $help = '/h' or $help = '/?' or $help = '-h' or $help = '-?' Then
	$helptext = "PingPrinter - Пинг с определенным интервалом, использование: PingPrinter.exe address sec" & @CRLF & _
	'Пример для интервала 119 секунд: PingPrinter.exe 192.168.0.5 119' & @CRLF
	Msgbox(0, 'Подсказка', $helptext)
	ConsoleWrite(_Encoding_ANSIToOEM($helptext))
	exit
Else
	if $CmdLine[0] < 2 Then
		_Quit('Недостаточно параметров для запуска файла, смотри справку -h')
		exit
	EndIf
	$address = $CmdLine[1]
	$seconds = $CmdLine[2]
	if $CmdLine[0] > 2 Then $mod = $CmdLine[3]
EndIf
$RetText = ''


While 1
	$t = TimerInit()
	$ping = _Ping($address, $RetText,6000)

if $mod=0 Then
ConsoleWrite(_Encoding_ANSIToOEM(@YDAY & ' ' & @Hour & ':' & @MIN & '(Время '&Round(TimerDiff($t),3)&' мс) Результат пинга адреса: '&$address&' - '&$ping) & @LF)
Else
ConsoleWrite(_Encoding_ANSIToOEM(@YDAY & ' ' & @Hour & ':' & @MIN & '('&Round(TimerDiff($t),1)&') '&$ping & ' ' & $RetText) & @LF)
EndIf

	if TimerDiff($t) < 1000*$seconds Then Sleep(1000*$seconds - TimerDiff($t))

WEnd

While 1
	$t = TimerInit()
	$ping = Ping($address)
	$error = @error
	if $ping == 0 Then
		Switch $error
			Case 1
				$error = 'Хост в офлайне'
			Case 2
				$error = 'Хост недоступен'
			Case 3
				$error = 'Bad destination'
			Case 4
				$error = 'Другие ошибки'
		EndSwitch
		ConsoleWrite(_Encoding_ANSIToOEM(@YDAY & ' ' & @Hour & ':' & @MIN & '(Время пинга '&Round(TimerDiff($t),3)&' мс) Результат пинга адреса: '&$address&' - '&$ping & ' Ошибкa: ' & $error) & @LF)
	Else

		ConsoleWrite(_Encoding_ANSIToOEM(@YDAY & ' ' & @Hour & ':' & @MIN & '(Время пинга '&Round(TimerDiff($t),3)&' мс) Результат пинга адреса: '&$address&' - '&$ping) & @LF)
	EndIf

	sleep(1000*$seconds)
WEnd


Func _Ping($address,byref $RetText,$timerlim=6000)
	local $sRead, $iPID, $timer, $tReturn, $sString
	$sRead = ''
	$iPID = Run(@ComSpec & ' /C ' & 'ping' & ' '& $address &' -n 1', '', @SW_HIDE, $STDOUT_CHILD)
	If Not $iPID Then
		ProcessClose($iPID)
		if $timerlim <> 180000 Then
			$tReturn = _Ping($address, $RetText,20000)
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
			if $timerlim <> 20000 Then
				$tReturn = _Ping($address, $RetText,20000)
				if $tReturn <> 0 Then Return $tReturn
			Else
				Return 0
			EndIf
		EndIf
	WEnd
	$sRead = _Encoding_866To1251($sRead)
	$aStrings = StringSplit($sRead,@LF)
	$RetText = $aStrings[3]

	if StringInStr($aStrings[3], 'число байт') or StringInStr($aStrings[3], 'bytes') Then
		return 1
	Else
		return 0
	EndIf

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sRead = ' & $sRead & @CRLF) ;### Debug Console
;~ 	$sString = StringRegExp(StringLower($sRead),'('&StringLower($FindUser)&') +(\d+) +([а-яёА-ЯЁa-zA-Z]+)',2)
;~ 	_ArrayDisplay($aStrings)

;~ 	return $sString
EndFunc



; Выход с возвращением текста
Func _Quit($text)
;~ 	_Log_Report($hLog, "Выход по ошибке: " & $text & @CRLF)
	ConsoleWrite(_Encoding_ANSIToOEM($text))
	Msgbox(0, 'Ошибка', $text)
	Exit
EndFunc