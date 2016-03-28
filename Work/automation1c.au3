HotKeySet("{Esc}", "Terminate")
Func Terminate()
	 TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

$slp=9
$Startchange = InputBox(" Выбор "," Введите номер певого запускаемого окна. 1 - 1С Предприятие ; 2 - 1С Конфигуратор ",1)
$timeoutStart=0
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

while 1
		;Реорганизация информации
	$thwnd=0
	$thwnd='[TITLE:Реорганизация информации;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists($thwnd) = ' & WinExists($thwnd)& @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlsend($thwnd,'','',"^{Enter}")
		sleep($slp*3000)
		winclose("Конфигуратор - Бухгалтерия предприятия, редакция 2.0")
		sleep(1000)
		if WinExists('1С:Предприятие') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*2000)
		Run("C:\Program Files\1cv82\common\1cestart.exe")
		$Startchange = 1
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf

	;Проверка легальности получения обновления
	$thwnd=0
	$thwnd='[TITLE:Проверка легальности получения обновления;CLASS:V8NewLocalFrameBaseWnd]'
	  if WinExists($thwnd)=1 Then
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlclick($thwnd,'','[CLASS:V8CommandBar; INSTANCE:1]')
				WinActivate($thwnd)
		controlSend($thwnd,'','',"{Enter}")
		controlSend($thwnd,'','',"{Enter}")
		sleep($slp*5000)
		winclose('1С:Предприятие - Наша организация')
		sleep(1000)
		if WinExists('1С:Предприятие') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*2000)
		Run("C:\Program Files\1cv82\common\1cestart.exe")
		$Startchange = 2
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf

	; выполнить обнновлен е конф-ии в конфигураторе
	$thwnd=0
	$thwnd='[TITLE:Конфигуратор;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') выполнить обнновлен е конф-ии в конфигураторе : WinExists($thwnd) = ' & WinExists($thwnd) &  '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlSend($thwnd,'','',"{Enter}")
	EndIf


	; завершение обновления в базе
	$thwnd=0
;~ 	$thwnd='[TITLE:Конфигуратор;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists(''[CLASS:V8NewLocalFrameBaseWnd]'') = ' & WinExists('[CLASS:V8NewLocalFrameBaseWnd]')& @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*3000)
;~ 		winclose('1С:Предприятие - Наша организация')
		sleep(1000)
		if WinExists('1С:Предприятие') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*2000)
		Run("C:\Program Files\1cv82\common\1cestart.exe")
		$Startchange = 2
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf

	; запуск $Startchange = 1
	$thwnd=0
	$thwnd='[TITLE:Запуск 1С:Предприятия;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then

		 WinActivate($thwnd)
		 if timerdiff($timeoutStart) > 15000 then
			 $timeoutStart= Timerinit()
			if $Startchange = 1 then
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
		$thwnd=0
		$thwnd='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
		if WinExists($thwnd)=1 Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists($thwnd) = ' & WinExists($thwnd)& @CRLF) ;### Debug Console
			BlockInput(1)
			WinActivate($thwnd)
			Opt("SendKeyDelay", 64)          ;5 миллисекунд
			Opt("SendKeyDownDelay", 10)      ;1 миллисекунда
			Opt("MouseCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские

			;открыть концигурайию
			ControlSend($thwnd,'','','{Alt}')
			sleep(200)
			ControlSend($thwnd,'','','{Right}')
			sEND('п')
			ControlSend($thwnd,'','','{Right}')
			sleep(200)
			ControlSend($thwnd,'','','{Enter}')
			send ("{Enter}")
			sleep($slp*500)
			;выбрать обновление
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

	sleep(500)
WEnd

