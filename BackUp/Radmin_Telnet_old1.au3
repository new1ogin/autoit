#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Encoding.au3>
#include <array.au3>
#include <WinAPIEx.au3>
#include <log.au3>

Opt("SendKeyDelay", 25)             ;5 миллисекунд
Opt("SendKeyDownDelay", 5)     ;1 миллисекунда
Opt("WinTitleMatchMode", -2)   ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
global $patch,$tempDir,$pid
$user=''
$user='user'
$pass='135790'
;~ $pass='Rj;tdybrjdj2407'
$patch = 'C:\Users\Виталий.PROFF\Desktop\Radmin Viewer 3\Radmin.exe'
$address = '92.125.34.190'
;~ $address = '92.125.32.63'
$port = '4803'
;~ $port = '4899'
$run = '"'&$patch&'" /connect:'&$address&':'&$port&' /telnet'
$tempDir=@ScriptDir

$hLog = _Log_Open(@ScriptDir & '\'&@ScriptName&'.log', '### Лог программы '&@ScriptName&' ###')


$StatusSpooler=-1
$Report = _SendRadminTelnet($address,$port,$user,$pass,'sc.exe query spooler',1000,'tempRadminSave.txt')
;~ $save='tempRadminSave.txt'
;~ $Report=_Encoding_866To1251(FileRead($tempDir&'\'&$save))
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tq = ' & $tq & @CRLF) ;### Debug Console
$StatusSpooler=_GetSpoolerStatus($Report)

if $StatusSpooler=0 then
	$Report = _SendRadminTelnet($address,$port,$user,$pass,'net start spooler',2000,'tempRadminSave.txt')
	_Log_Report($hLog, "Статус службы: " & $StatusSpooler & ' Команда запуска службы отправлена' & @CRLF)
	sleep(10000)
	$Report = _SendRadminTelnet($address,$port,$user,$pass,'sc.exe query spooler',1000,'tempRadminSave.txt')
	$StatusSpooler=_GetSpoolerStatus($Report)
EndIf

_Log_Report($hLog, "Статус службы: " & $StatusSpooler & @CRLF)

_CloseRadminTelnet()

exit

Func _GetSpoolerStatus($report)
	if StringRegExp($Report,'4\s+RUNNING') then
		$StatusSpooler=1
	Else
		if StringRegExp($Report,'1\s+STOPPED') then
			$StatusSpooler=0
		Else
			$StatusSpooler=-1
		EndIf
	EndIf
	return $StatusSpooler
EndFunc


Func _SendRadminTelnet($address,$port,$user,$pass,$command,$timeToCommand=4100,$save='tempRadminSave.txt')
	$return=0
	;проверяем не запущена ли уже окно, и запускаем при необходимости
	$title=$address&' - Telnet'
	$hwndMain = WinGetHandle($title)
	if $hwndMain = 0 then
		$pid = _RunRadminTelnet($address,$port,$user,$pass)
		if $pid<1 Then Return $pid
		$timer=TimerInit()
		While 1
			$title=_Process2Win($pid)
			$hwndMain = WinGetHandle($title)
			if $hwndMain>1 Then ExitLoop
			if TimerDiff($timer) > 10000 Then return -4 ; Ошибка в получении хендела главного окна
			sleep(100)
		WEnd
	Else
		if $pid<1 Then $pid=_Win2Process($title)
	EndIf
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hwndMain = ' & $hwndMain & @CRLF) ;### Debug Console

	;Получаем контрол главного окна
	$timer=TimerInit()
	While 1
		$ControlsMain= _WinAPI_EnumChildWindows($hwndMain)
		if not @error then
			$ControlIDMain='[CLASS:'&$ControlsMain[1][1]&'; INSTANCE:1]'
			ExitLoop
		EndIf
		if TimerDiff($timer) > 10000 Then return -5 ; Ошибка в получении контрола главного окна
		sleep(100)
	WEnd

	_WinAPI_SetKeyboardLayout ($hwndMain, 0x0409)
	sleep(100)

	;Отправка команды
	Opt("SendKeyDelay", 32)             ;5 миллисекунд
	Opt("SendKeyDownDelay", 8)     ;1 миллисекунда
	$t1=ControlSend($hwndMain,'',$ControlIDMain,_SendConvert($command))
	ControlSend($hwndMain,'',$ControlIDMain,'{Enter}')

	sleep($timeToCommand) ;ожидание на выполнение команды

	If StringLen($save)>1 Then
		;Сохранение ответа в файл
		WinActivate($title)
		$t1 = WinMenuSelectItem($title,'','&Текст','&Сохранить...')
		$titleSave = 'Сохранить содержимое в буфер'
		$hwndSave=WinWait($titleSave,'',5)

		; отправляем путь сохранения с именем файла
		WinActivate($hwndSave)
		_insert($tempDir&'\tempRadminSave.txt')

		ControlClick($titleSave,'','[TEXT:Со&хранить]')
		$titleConfirm='Подтвердить сохранение в виде'
		For $i=1 to 10
			if WinExists($titleConfirm) then ControlClick($titleConfirm,'','[TEXT:&Да]')
			sleep(50)
		Next
		sleep(200)
		$return=_Encoding_866To1251(FileRead($tempDir&'\'&$save))

		return $return
	EndIf

	return $return
EndFunc

Func _CloseRadminTelnet()
	WinClose(_Process2Win($pid))
	sleep(1000)
	ProcessClose($pid)
EndFunc


Func _SendConvert($string)
	$astring = StringSplit($string,"")
	$string=''
	For $i=1 to $astring[0]
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
	return $string
EndFunc

Func _insert($text)
	$tempBuffer=ClipGet()
	For $i=1 to 3
		ClipPut($text)
		Send('+{Ins}')
		ClipPut('')
		Send('{home}')
		Send('+{End}')
		Send('^{Ins}')
		if ClipGet()=$text then
			ExitLoop
		Else
			Send('{del}')
			sleep(100)
		EndIf
	Next
	ClipPut($tempBuffer)
EndFunc

Func _RunRadminTelnet($address,$port,$user,$pass)
	;Запуск Radmin и ожидание появления созданного им окна
	$run = '"'&$patch&'" /connect:'&$address&':'&$port&' /telnet'
	$pid = Run($run)
	$title=-1
	if not @error then
	While $title = -1
		$title=_Process2Win($pid)
		sleep(100)
	WEnd
	Else
		return 0 ;Ошибка запуска файла
;~ 		exit 1
	EndIf

	; ожидание соеденения
	$WinInfo=0
	if $title='Информация о соединении' Then
		while 1
			if WinExists($title) then
				$WinInfo+=1
			Else
				ExitLoop
			EndIf
			if $WinInfo > 300 then
				Controlclick($title,"",'[TEXT:Закрыть]')
;~ 				exit 1
				return -1 ;Ошибка соеденения
			EndIf
			sleep(100)
		WEnd
	EndIf

	; ожидание появления правильного окна
	$timer=TimerInit()
	While Stringinstr($title,$address)==0
		$title=_Process2Win($pid)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $title= = ' & $title & @CRLF) ;### Debug Console
		if TimerDiff($timer)>30000 then return -2 ; Ошибка: Не появилось ожидаемое окно
		sleep(100)
	WEnd

	;Вписываем логин пароль
	$hwnd = WinGetHandle($title)
	;Определяем количество элементов Edit
	$QEdit= _WinAPI_EnumChildWindows($hwnd)
	$QEdit=_ArrayFindAll($QEdit,'Edit',0,0,0,0,1)

	if Ubound($QEdit)>1 then
		ControlSend($hwnd,'','[CLASS:Edit; INSTANCE:1]',$user)
		ControlSend($hwnd,'','[CLASS:Edit; INSTANCE:2]',$pass)
	Else
		ControlSend($hwnd,'','[CLASS:Edit; INSTANCE:1]',$pass)
	EndIf
	sleep(100)
	ControlClick($hwnd,'','[TEXT:ОК]')
	sleep(100)
	return $pid
EndFunc



;~ $title=-1
;~ While not StringInStr($title,'92.125.34.190')
;~ 	$title=_Process2Win($pid)
;~ 	sleep(100)
;~ WEnd






func _Win2Process($wintitle)
;~     if isstring($wintitle) = 0 then return -1
    $wproc = WinGetProcess($wintitle)
    return _ProcessName($wproc)
endfunc

func _ProcessName($pid)
    if isstring($pid) then $pid = processexists($pid)
    if not isnumber($pid) then return -1
    $proc = ProcessList()
    for $p = 1 to $proc[0][0]
        if $proc[$p][1] = $pid then return $proc[$p][0]
    Next
    return -1
EndFunc

func _Process2Win($pid)
    if isstring($pid) then $pid = processexists($pid)
    if $pid = 0 then return -1
    $list = WinList()
    for $i = 1 to $list[0][0]
        if $list[$i][0] <> "" AND BitAnd(WinGetState($list[$i][1]),2) then
            $wpid = WinGetProcess($list[$i][0])
            if $wpid = $pid then return $list[$i][0]
        EndIf
    next
    return -1
endfunc