#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Encoding.au3>
#include <array.au3>
#include <WinAPIEx.au3>
#include <log.au3>

Opt("SendKeyDelay", 25) ;5 миллисекунд
Opt("SendKeyDownDelay", 5) ;1 миллисекунда
Opt("WinTitleMatchMode", -2) ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
Global $patch, $tempDir, $pid
$user = ''
$user = 'user'
$pass = '135790'
$patch = @ScriptDir & '\Radmin.exe'
$address = '92.125.34.190:4803'
$port = ''
$run = '"' & $patch & '" /connect:' & $address & ':' & $port & ' /telnet'
$tempDir = @ScriptDir


$minCmdLines = 4
$maxCmdLines = 6
$Commands = 'adress|user|pass'

Dim $CmdLineN[$maxCmdLines+1]
For $i = 0 To $CmdLine[0]
	$CmdLineN[$i] = $CmdLine[$i]
Next
$CmdLineN[1] ='-adress'
$CmdLineN[2] ='92.125.34.190:4803'
$CmdLineN[3] ='-user'
$CmdLineN[4] ='USERNAME'
$CmdLineN[5] ='-pass'
$CmdLineN[6] ='PASSWORD'

$help = StringLeft($CmdLineN[1], 2)
If $help = '/h' Or $help = '/?' Or $help = '-h' Or $help = '-?' Then ; отображение справки и выход
	$helptext = "Функция проверки запуска службы spooler по Radmin. Поместить в папку с Radmin.exe" & @CRLF & _
			"Использование: " & @ScriptName & " -adress address:port -user USERNAME -pass PASSWORD" & @CRLF & _
			"Пример: " & @ScriptName & " 192.168.0.190:4899 -user User -pass QWErty123" & @CRLF
	MsgBox(0, 'Подсказка', $helptext)
	ConsoleWrite(_Encoding_ANSIToOEM($helptext))
	Exit
Else
	If $CmdLineN[0] < $minCmdLines Then
		_Quit('Недостаточно параметров для запуска файла, смотри справку -h')
		Exit
	EndIf
	$aCommands=StringSplit($Commands,"|")
	;Обработка команд
	For $i = 1 To $CmdLineN[0]
		For $c=1 to $aCommands[0]
			if $aCommands[$c]=StringMid($CmdLineN[$i], 2, -1) Then
				Assign ( $aCommands[$c], $CmdLineN[$i], 2)
				$i+=1
				ExitLoop
			EndIf
		Next
	Next
EndIf

;Обработка адреса
if StringInStr($address,":") Then
	$address = StringRegExp($address, "(.*?):(.*)", 2)
	$pass = $address[2]
	$address = $address[1]
Else
	$pass = ''
EndIf

exit
$hLog = _Log_Open(@ScriptDir & '\' & @ScriptName & '.log', '### Лог программы ' & @ScriptName & ' ###')


$StatusSpooler = -1
$report = _SendRadminTelnet($address, $port, $user, $pass, 'sc.exe query spooler', 1000, 'tempRadminSave.txt')
If $report < 0 Then _Quit('Ошибка получения отчета с Radmin. Код ошибки: ' & $report)
;~ $save='tempRadminSave.txt'
;~ $Report=_Encoding_866To1251(FileRead($tempDir&'\'&$save))
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tq = ' & $tq & @CRLF) ;### Debug Console
$StatusSpooler = _GetSpoolerStatus($report)

If $StatusSpooler = 0 Then
	$report = _SendRadminTelnet($address, $port, $user, $pass, 'net start spooler', 2000, 'tempRadminSave.txt')
	If $report < 0 Then _Quit('Ошибка получения отчета с Radmin. Код ошибки: ' & $report)
	_Log_Report($hLog, "Статус службы: " & $StatusSpooler & ' Команда запуска службы отправлена' & @CRLF)
	Sleep(10000)
	$report = _SendRadminTelnet($address, $port, $user, $pass, 'sc.exe query spooler', 1000, 'tempRadminSave.txt')
	If $report < 0 Then _Quit('Ошибка получения отчета с Radmin. Код ошибки: ' & $report)
	$StatusSpooler = _GetSpoolerStatus($report)
EndIf

_Log_Report($hLog, "Статус службы: " & $StatusSpooler & @CRLF)

_CloseRadminTelnet()

Exit

Func _GetSpoolerStatus($report)
	If StringRegExp($report, '4\s+RUNNING') Then
		$StatusSpooler = 1
	Else
		If StringRegExp($report, '1\s+STOPPED') Then
			$StatusSpooler = 0
		Else
			$StatusSpooler = -1
		EndIf
	EndIf
	Return $StatusSpooler
EndFunc   ;==>_GetSpoolerStatus


Func _SendRadminTelnet($address, $port, $user, $pass, $command, $timeToCommand = 4100, $save = 'tempRadminSave.txt')
	$return = 0
	;проверяем не запущена ли уже окно, и запускаем при необходимости
	$title = $address & ' - Telnet'
	$hwndMain = WinGetHandle($title)
	If $hwndMain = 0 Then
		$pid = _RunRadminTelnet($address, $port, $user, $pass)
		If $pid < 1 Then Return $pid
		$timer = TimerInit()
		While 1
			$title = _Process2Win($pid)
			$hwndMain = WinGetHandle($title)
			If $hwndMain > 1 Then ExitLoop
			If TimerDiff($timer) > 10000 Then Return -4 ; Ошибка в получении хендела главного окна
			Sleep(100)
		WEnd
	Else
		If $pid < 1 Then $pid = _Win2Process($title)
	EndIf
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hwndMain = ' & $hwndMain & @CRLF) ;### Debug Console

	;Получаем контрол главного окна
	$timer = TimerInit()
	While 1
		$ControlsMain = _WinAPI_EnumChildWindows($hwndMain)
		If Not @error Then
			$ControlIDMain = '[CLASS:' & $ControlsMain[1][1] & '; INSTANCE:1]'
			ExitLoop
		EndIf
		If TimerDiff($timer) > 10000 Then Return -5 ; Ошибка в получении контрола главного окна
		Sleep(100)
	WEnd

	_WinAPI_SetKeyboardLayout($hwndMain, 0x0409)
	Sleep(100)

	;Отправка команды
	Opt("SendKeyDelay", 32) ;5 миллисекунд
	Opt("SendKeyDownDelay", 8) ;1 миллисекунда
	$t1 = ControlSend($hwndMain, '', $ControlIDMain, _SendConvert($command))
	ControlSend($hwndMain, '', $ControlIDMain, '{Enter}')

	Sleep($timeToCommand) ;ожидание на выполнение команды

	If StringLen($save) > 1 Then
		;Сохранение ответа в файл
		WinActivate($title)
		$t1 = WinMenuSelectItem($title, '', '&Текст', '&Сохранить...')
		$titleSave = 'Сохранить содержимое в буфер'
		$hwndSave = WinWait($titleSave, '', 5)

		; отправляем путь сохранения с именем файла
		WinActivate($hwndSave)
		_insert($tempDir & '\tempRadminSave.txt')

		ControlClick($titleSave, '', '[TEXT:Со&хранить]')
		$titleConfirm = 'Подтвердить сохранение в виде'
		For $i = 1 To 10
			If WinExists($titleConfirm) Then ControlClick($titleConfirm, '', '[TEXT:&Да]')
			Sleep(50)
		Next
		Sleep(200)
		$return = _Encoding_866To1251(FileRead($tempDir & '\' & $save))

		Return $return
	EndIf

	Return $return
EndFunc   ;==>_SendRadminTelnet

Func _CloseRadminTelnet()
	WinClose(_Process2Win($pid))
	Sleep(1000)
	ProcessClose($pid)
EndFunc   ;==>_CloseRadminTelnet


Func _SendConvert($string)
	$astring = StringSplit($string, "")
	$string = ''
	For $i = 1 To $astring[0]
		Switch $astring[$i]
			Case ' '
				$string &= '{SPACE}'
			Case '.'
				$string &= '{NUMPADDOT}'
			Case '/'
				$string &= '{NUMPADDIV}'
			Case ':'
				$string &= '{ASC 058}'
			Case Else
				$string &= '{' & $astring[$i] & '}'
		EndSwitch
	Next
	Return $string
EndFunc   ;==>_SendConvert

Func _insert($text)
	$tempBuffer = ClipGet()
	For $i = 1 To 3
		ClipPut($text)
		Send('+{Ins}')
		ClipPut('')
		Send('{home}')
		Send('+{End}')
		Send('^{Ins}')
		If ClipGet() = $text Then
			ExitLoop
		Else
			Send('{del}')
			Sleep(100)
		EndIf
	Next
	ClipPut($tempBuffer)
EndFunc   ;==>_insert

Func _RunRadminTelnet($address, $port, $user, $pass)
	;Запуск Radmin и ожидание появления созданного им окна
	$run = '"' & $patch & '" /connect:' & $address & ':' & $port & ' /telnet'
	$pid = Run($run)
	$title = -1
	If Not @error Then
		While $title = -1
			$title = _Process2Win($pid)
			Sleep(100)
		WEnd
	Else
		Return 0 ;Ошибка запуска файла
;~ 		exit 1
	EndIf

	; ожидание соеденения
	$WinInfo = 0
	If $title = 'Информация о соединении' Then
		While 1
			If WinExists($title) Then
				$WinInfo += 1
			Else
				ExitLoop
			EndIf
			If $WinInfo > 300 Then
				ControlClick($title, "", '[TEXT:Закрыть]')
;~ 				exit 1
				Return -1 ;Ошибка соеденения
			EndIf
			Sleep(100)
		WEnd
	EndIf

	; ожидание появления правильного окна
	$timer = TimerInit()
	While StringInStr($title, $address) == 0
		$title = _Process2Win($pid)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $title= = ' & $title & @CRLF) ;### Debug Console
		If TimerDiff($timer) > 30000 Then Return -2 ; Ошибка: Не появилось ожидаемое окно
		Sleep(100)
	WEnd

	;Вписываем логин пароль
	$hwnd = WinGetHandle($title)
	;Определяем количество элементов Edit
	$QEdit = _WinAPI_EnumChildWindows($hwnd)
	$QEdit = _ArrayFindAll($QEdit, 'Edit', 0, 0, 0, 0, 1)

	If UBound($QEdit) > 1 Then
		ControlSend($hwnd, '', '[CLASS:Edit; INSTANCE:1]', $user)
		ControlSend($hwnd, '', '[CLASS:Edit; INSTANCE:2]', $pass)
	Else
		ControlSend($hwnd, '', '[CLASS:Edit; INSTANCE:1]', $pass)
	EndIf
	Sleep(100)
	ControlClick($hwnd, '', '[TEXT:ОК]')
	Sleep(100)
	Return $pid
EndFunc   ;==>_RunRadminTelnet



;~ $title=-1
;~ While not StringInStr($title,'92.125.34.190')
;~ 	$title=_Process2Win($pid)
;~ 	sleep(100)
;~ WEnd




; Выход с возвраением текста
Func _Quit($text)
	_Log_Report($hLog, "Выход по ошибке: " & $text & @CRLF)
	ConsoleWrite(_Encoding_ANSIToOEM($text))
	MsgBox(0, 'Ошибка', $text)
	Exit
EndFunc   ;==>_Quit

Func _Win2Process($wintitle)
;~     if isstring($wintitle) = 0 then return -1
	$wproc = WinGetProcess($wintitle)
	Return _ProcessName($wproc)
EndFunc   ;==>_Win2Process

Func _ProcessName($pid)
	If IsString($pid) Then $pid = ProcessExists($pid)
	If Not IsNumber($pid) Then Return -1
	$proc = ProcessList()
	For $p = 1 To $proc[0][0]
		If $proc[$p][1] = $pid Then Return $proc[$p][0]
	Next
	Return -1
EndFunc   ;==>_ProcessName

Func _Process2Win($pid)
	If IsString($pid) Then $pid = ProcessExists($pid)
	If $pid = 0 Then Return -1
	$list = WinList()
	For $i = 1 To $list[0][0]
		If $list[$i][0] <> "" And BitAND(WinGetState($list[$i][1]), 2) Then
			$wpid = WinGetProcess($list[$i][0])
			If $wpid = $pid Then Return $list[$i][0]
		EndIf
	Next
	Return -1
EndFunc   ;==>_Process2Win
