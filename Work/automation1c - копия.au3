HotKeySet("{Esc}", "Terminate")
Func Terminate()
	 TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

Opt("WinTitleMatchMode", 3)

$slp=3
$Startchange = InputBox(" Выбор "," Введите номер певого запускаемого окна. 1 - 1С Предприятие ; 2 - 1С Конфигуратор ",1)
$CloseWinPp=1
$timeoutStart=0
$timerExitPp=0
$timerExitKonfigurator=0
$thwnd=0
$thwnd2=0
$thwnd3=0
$thwnd4=0
$namePp= "1С:Предприятие - "

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

while 1

	;Закрытие диалогового окна
	$thwnd='1С:Предприятие. Доступ к информационной базе'
	if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		WinActivate($thwnd)
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:5]')
		controlsend($thwnd,'','',"{Enter}")
	EndIf

		;Закрытие ошибки
;~ 	$thwnd=0
;~ 	$thwnd='[TITLE:1С:Предприятие;CLASS:V8NewLocalFrameBaseWnd; W:450; H:119]'
;~ 	 if WinExists($thwnd)=1 Then
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		WinActivate($thwnd)
;~ 		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		controlsend($thwnd,'','',"{Enter}")
;~ 	EndIf

	;Закрытие диалогового окна
;~ 	Style:	0x96C81000
;~ ExStyle:	0x00000100
	$thwnd=0
	$thwnd='[TITLE:1С:Предприятие;CLASS:V8NewLocalFrameBaseWnd; W:516; H:101]'
	 if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WinActivate($thwnd)
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:2]')
		controlsend($thwnd,'','',"{Enter}")
	EndIf
	$thwnd='[TITLE:1С:Предприятие;CLASS:V8NewLocalFrameBaseWnd; W:224; H:101]'
	 if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
	EndIf

		;Реорганизация информации
	$thwnd=0
	$thwnd='[TITLE:Реорганизация информации;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		 $timerExitKonfigurator = 0
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists($thwnd) = ' & WinExists($thwnd)& @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlsend($thwnd,'','',"^{Enter}")
		sleep($slp*3000)
		$thwnd='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
		$thwnd2='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		$thwnd = WinGetTitle ( "Конфигуратор - " )
		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase

;~ 		$thwnd3='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
;~ 		$thwnd4='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
		_winclose($thwnd)
		sleep(1000)
		$thwnd = '1С:Предприятие'
		if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*2000)
		Run("C:\Program Files\1cv82\common\1cestart.exe")
		$Startchange = 1
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf

	;Проверка легальности получения обновления
	$thwnd='[TITLE:Проверка легальности получения обновления;CLASS:V8NewLocalFrameBaseWnd]'
	  if WinExists($thwnd)=1 Then
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlclick($thwnd,'','[CLASS:V8CommandBar; INSTANCE:1]')
				WinActivate($thwnd)
		controlSend($thwnd,'','',"{Enter}")
		controlSend($thwnd,'','',"{Enter}")
		sleep($slp*5000)

		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		$thwnd = WinGetTitle ( "1С:Предприятие - " )
		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase

			_winclose($thwnd)
;~ 			_winclose('1С:Предприятие - Зарплата и Управление Персоналом, редакция 2.5')
		sleep(1000)
		$thwnd = '1С:Предприятие'
		if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*2000)
		Run("C:\Program Files\1cv82\common\1cestart.exe")
		$Startchange = 2
		$CloseWinPp=1
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf
	;Ошибка конфигуратора
	$thwnd='[TITLE:Конфигуратор;CLASS:V8NewLocalFrameBaseWnd; W:552; H:127]'
	 if WinExists($thwnd)=1 Then
		 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WinActivate($thwnd)
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:2]')
		controlSend($thwnd,'','',"{Esc}")
		$timerExitKonfigurator = Timerinit()+5000
	EndIf

	; выполнить обнновление конф-ии в конфигураторе
	$thwnd='[TITLE:Конфигуратор;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') выполнить обнновлен е конф-ии в конфигураторе : WinExists($thwnd) = ' & WinExists($thwnd) &  '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlSend($thwnd,'','',"{Enter}")
		$timerExitKonfigurator = Timerinit()
	EndIf
	if $timerExitKonfigurator<>0 and TimerDiff($timerExitKonfigurator) > $slp*5000 then
		$timerExitKonfigurator=0
		ConsoleWrite(" выход из концигуратора по таймауту ")
		$thwnd='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
		$thwnd2='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		$thwnd = WinGetTitle ( "Конфигуратор - " )
		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase

;~ 		$thwnd3='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
;~ 		$thwnd4='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
		_winclose($thwnd)
		sleep(1000)
		$thwnd = '1С:Предприятие'
		if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*2000)
		Run("C:\Program Files\1cv82\common\1cestart.exe")
		$Startchange = 1
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf



	; завершение обновления в базе
;~ 	$thwnd='[TITLE:Конфигуратор;CLASS:V8NewLocalFrameBaseWnd]'
;~ 	 if WinExists($thwnd)=1 Then
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists(''[CLASS:V8NewLocalFrameBaseWnd]'') = ' & WinExists('[CLASS:V8NewLocalFrameBaseWnd]')& @CRLF) ;### Debug Console
;~ 		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*3000)
;~ 	;~ 		_winclose('1С:Предприятие - Наша организация')
;~ 		sleep(1000)
;~ 		if WinExists('1С:Предприятие') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*2000)
;~ 		Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 		$Startchange = 2
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
;~ 	EndIf

	; запуск $Startchange = 1
	$thwnd='[TITLE:Запуск 1С:Предприятия;CLASS:V8NewLocalFrameBaseWnd]'
	if WinExists($thwnd)=1 Then

		 WinActivate($thwnd)
		 if timerdiff($timeoutStart) > 15000 then
			 $timeoutStart= Timerinit()
			if $Startchange = 1 then
				$CloseWinPp=0
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:10]')
				send('{Enter}')
				ConsoleWrite(" запуск 1С предприятия" & @CRLF)
			Else
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:11]')
				send('{Enter}')
				ConsoleWrite(" запуск 1С конфигуратор" & @CRLF)
			endif
		endif
	EndIf

	if $Startchange = 2 Then
		$thwnd='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
		$thwnd2='Конфигуратор - Зарплата и Управление Персоналом, редакция 2.5'
		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		$thwnd = WinGetTitle ( "Конфигуратор - " )
		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase

;~ 		$thwnd3='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
;~ 		$thwnd4='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
		if WinExists($thwnd)=1 or WinExists($thwnd2)=1 or WinExists($thwnd3)=1 or WinExists($thwnd4)=1 Then
			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			BlockInput(1)
			WinActivate($thwnd)
			Opt("SendKeyDelay", 64)          ;5 миллисекунд
			Opt("SendKeyDownDelay", 10)      ;1 миллисекунда
			Opt("MouseCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские

			; открыть конфигурацию
			ControlSend($thwnd,'','','{Alt}')
			sleep(200)
			ControlSend($thwnd,'','','{Right}')
			sEND('п')
			ControlSend($thwnd,'','','{Right}')
			ControlSend($thwnd,'','','{Enter}')
			sleep($slp*1000)
			; запустить обновление
			ControlSend($thwnd,'','','{Alt}')
			sleep(200)
			ControlSend($thwnd,'','','{Right}')
			sEND('п')
			ControlSend($thwnd,'','','{Right}')
			;ControlSend($thwnd,'','','{Right}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{Right}')
			ControlSend($thwnd,'','','{Enter}')
			sleep(200)
			ControlSend($thwnd,'','','{Enter}')
			ControlSend($thwnd,'','','{Enter}')
			ControlSend($thwnd,'','','{Enter}')
			ControlClick($thwnd,'','','left',1,154,69)
			ControlClick($thwnd,'','','left',1,154,69)
			ControlClick($thwnd,'','','left',1,154,69)
			MouseMove(154,69)
			MouseClick('left')
			sleep(300)
			Send('^c')
			sleep(100)
			Send('^{Ins}')
			sleep(100)
			ConsoleWrite( @CRLF & Clipget() & @CRLF)
			MouseClick('left')
			sleep(20)
			MouseClick('left')
			sleep(300)
			send ("^{Enter}")
			sleep(200)
			send ("^{Enter}")
			BlockInput(0)
			$Startchange = 1
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

		EndIf
	endif

	$thwnd='1С:Предприятие - Наша организация'
	$thwnd2='1С:Предприятие - Наша организация'
	Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
	$thwnd = WinGetTitle ( "1С:Предприятие - " )
	Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
;~ 	$thwnd3='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
;~ 	$thwnd4='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
	if $CloseWinPp=1 then
		if WinExists($thwnd)=1 or WinExists($thwnd2)=1 or WinExists($thwnd3)=1 or WinExists($thwnd4)=1 Then
			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
			ConsoleWrite(' онаружено не закрытое окно 1С:Предприятия')
;~ 			_winclose('1С:Предприятие - Наша организация')
			_winclose($thwnd)
;~ 			_winclose('1С:Предприятие - Зарплата и Управление Персоналом, редакция 2.5')
			sleep(1000)
			if WinExists('1С:Предприятие') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		EndIf
	Else
		if $timerExitPp=0 and WinExists($thwnd)=1 then
			$timerExitPp=timerinit()
		EndIf
		if $timerExitPp<>0 and WinExists($thwnd)=1 then
			if TimerDiff($timerExitPp) > $slp*5000 Then
				_winclose($thwnd)
	;~ 			_winclose('1С:Предприятие - Зарплата и Управление Персоналом, редакция 2.5')
				sleep(1000)

				$thwnd = '1С:Предприятие'
				if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
				sleep($slp*2000)
				Run("C:\Program Files\1cv82\common\1cestart.exe")
				$Startchange = 2
				$CloseWinPp=1

			EndIf
		EndIf
	EndIf
	$thwnd='Рекомендуется обновить версию конфигурации'
 	$thwnd2='Рекомендуется обновить версию конфигурации'
;~ 	$thwnd3='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
;~ 	$thwnd4='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
	if WinExists($thwnd)=1 or WinExists($thwnd2)=1 or WinExists($thwnd3)=1 or WinExists($thwnd4)=1 Then
			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
			WinActivate($thwnd)
			Opt("SendKeyDelay", 64)          ;5 миллисекунд
			Opt("SendKeyDownDelay", 10)      ;1 миллисекунда
			Opt("MouseCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
		ConsoleWrite(' Рекомендуется обновить версию конфи' &@CRLF)
		ControlSend($thwnd,'','','{Tab}')
		ControlSend($thwnd,'','','{Enter}')
	endif


	sleep(500)
WEnd

func _winclose($win)
	ConsoleWrite(' попытка закрыть окно: ' & $win) ; StringLeft($win,10))
	for $i=0 to 99
		if WinExists($win)=0 then
			ConsoleWrite(' ; закрыто окно: ' & StringLeft($win,10) &"..." &@CRLF)
			Return
		EndIf
		WinClose($win)
			$thwnd=0
			$thwnd='[TITLE:1С:Предприятие;CLASS:V8NewLocalFrameBaseWnd; W:516; H:101]'
			 if WinExists($thwnd)=1 Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				WinActivate($thwnd)
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:2]')
				controlsend($thwnd,'','',"{Enter}")
			EndIf
			$thwnd='[TITLE:1С:Предприятие;CLASS:V8NewLocalFrameBaseWnd; W:224; H:101]'
			 if WinExists($thwnd)=1 Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
				controlsend($thwnd,'','',"{Enter}")
			EndIf
		sleep(100)
	Next
EndFunc

