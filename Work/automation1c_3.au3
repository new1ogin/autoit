	#Include <WinAPIEx.au3>
#include <Date.au3>

HotKeySet("{Esc}", "Terminate")
Func Terminate()
	 TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

HotKeySet("{Ins}", "Switchkey")



			Opt("WinTitleMatchMode", 3)
			Opt("SendKeyDelay", 64)          ;5 миллисекунд
			Opt("SendKeyDownDelay", 10)      ;1 миллисекунда
			Opt("MouseCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
clipput(" Буфер обмена ")
$slp=3
$Startchange = InputBox(" Выбор "," Введите номер певого запускаемого окна. 1 - 1С Предприятие ; 2 - 1С Конфигуратор ",1)
$CloseWinPp=0
$timeoutStart=0
$timerExitPp=0
$timerExitKonfigurator=0
$thwnd=0
$thwnd2=0
$thwnd3=0
$thwnd4=0
$namePp= "1С:Предприятие - "

$IdleMinimum = 1000 ; допустимый период неактивности в миллисекундах

ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

Func Switchkey()
	if $Startchange = 1 then
	 $Startchange = 2
 Else
	 $Startchange = 1
 endif
ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

 EndFunc   ;==>Terminate

while 1

	Opt("WinTitleMatchMode", 1)
	$thwnd = WinGetTitle('Управление торговлей')
	Opt("WinTitleMatchMode", 3)
	if WinExists($thwnd)=1 and WinActive($thwnd)<>0 then
		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WinActivate($thwnd)
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:5]')
		MouseMove(453,536)
		sleep(200)
		MouseClick('left')
		sleep(200)
		MouseClick('left')

			$thwnd = 'Обновление конфигурации'
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &" Ожидаю появление окна " & $thwnd & @CRLF)
			WinWait($thwnd,'',10)
			WinActivate($thwnd)
			send ('{TAB}')
			send ('{TAB}')
			send ('{Enter}')

	endif

	;завершение обновления
;~ 	$thwnd = WinGetHandle('Обновление конфигурации')
	$thwnd = 'Обновление конфигурации'
	if WinExists($thwnd)=1 and WinActive($thwnd)<>0  then
		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$aData = _WinAPI_EnumChildWindows($thwnd)
		if not @error then
			if $aData[0][0] = 44 Then
				MsgBox(0,"","кол-во "& $aData[0][0])
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &" Ожидаю появление окна " & $thwnd & @CRLF)
			WinWait($thwnd,'',10)
				WinActivate($thwnd)
				send ('{TAB}')
				send ('{TAB}')
				send ('{Enter}')
				sleep(10000)
			EndIf
		EndIf
	EndIf

	;Проверка легальности получения обновления
	Opt("WinTitleMatchMode", 1)
	$thwnd = WinGetTitle('Легальность получения обновлений - ')
	Opt("WinTitleMatchMode", 3)
	  if WinExists($thwnd)=1 Then
		  ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:10]')
		controlclick($thwnd,'','[CLASS:V8CommandBar; INSTANCE:1]')
				WinActivate($thwnd)
		controlSend($thwnd,'','',"{Enter}")
		controlSend($thwnd,'','',"{Enter}")
			$thwnd = 'Обновление конфигурации'
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &" Ожидаю появление окна " & $thwnd & @CRLF)
			WinWait($thwnd,'',10)
			WinActivate($thwnd)
			sleep($slp*3000)
			send ('{TAB}')
			send ('{TAB}')
			send ('{TAB}')
			sleep(1000)
			send ('{Enter}')

;~ 		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
;~ 		$thwnd = WinGetTitle ( $namePp )
;~ 		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase

;~ 			_winclose($thwnd)
;~ 	;~ 			_winclose('1С:Предприятие - Зарплата и Управление Персоналом, редакция 2.5')
;~ 		sleep(1000)
;~ 		$thwnd = '1С:Предприятие'
;~ 		if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*2000)
;~ 		Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 		$Startchange = 2
;~ 		$CloseWinPp=1
;~ 		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf
	$thwnd = "Легальность получения обновлений - Управление торговлей, редакция 11.1 / Администратор"
	  if WinExists($thwnd)=1 Then
		  ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:10]')
		controlclick($thwnd,'','[CLASS:V8CommandBar; INSTANCE:1]')
				WinActivate($thwnd)
		controlSend($thwnd,'','',"{Enter}")
		controlSend($thwnd,'','',"{Enter}")

			$thwnd = 'Обновление конфигурации'
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &" Ожидаю появление окна " & $thwnd & @CRLF)
			WinWait($thwnd,'',10)
			WinActivate($thwnd)
			sleep($slp*3000)
			send ('{TAB}')
			send ('{TAB}')
			send ('{TAB}')
			sleep(1000)
			send ('{Enter}')
	 EndIf
			;~ 	if WinExists($namePp2) then
;~ 		$namePp = $namePp2
;~ 		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $namePp = ' & $namePp & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	EndIf

	;Закрытие диалогового окна
	$thwnd='1С:Предприятие. Доступ к информационной базе'
	if WinExists($thwnd)=1 Then
		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		WinActivate($thwnd)

		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:5]')
		controlsend($thwnd,'','',"{Enter}")
	EndIf

		;Закрытие ошибки
;~ 	$thwnd=0
;~ 	$thwnd='[TITLE:1С:Предприятие;CLASS:V8NewLocalFrameBaseWnd; W:450; H:119]'
;~ 	 if WinExists($thwnd)=1 Then
;~ 		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
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
		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WinActivate($thwnd)
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:2]')
		controlsend($thwnd,'','',"{Enter}")
	EndIf
	$thwnd='[TITLE:1С:Предприятие;CLASS:V8NewLocalFrameBaseWnd; W:224; H:101]'
	 if WinExists($thwnd)=1 Then
		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
	EndIf

		;Реорганизация информации
	$thwnd=0
	$thwnd='[TITLE:Реорганизация информации;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		 $timerExitKonfigurator = 0
		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : WinExists($thwnd) = ' & WinExists($thwnd)& @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlsend($thwnd,'','',"^{Enter}")
		_CloseConfigurator()
		_runPp()
	EndIf




	;Проверка легальности получения обновления
	$thwnd='[TITLE:Проверка легальности получения обновления;CLASS:V8NewLocalFrameBaseWnd]'
	  if WinExists($thwnd)=1 Then
		  ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlclick($thwnd,'','[CLASS:V8CommandBar; INSTANCE:1]')
				WinActivate($thwnd)
		controlSend($thwnd,'','',"{Enter}")
		controlSend($thwnd,'','',"{Enter}")
;~ 		_ClosePp()
		_runConfigurator()
	EndIf





	;Ошибка конфигуратора
	$thwnd='[TITLE:Конфигуратор;CLASS:V8NewLocalFrameBaseWnd; W:552; H:127]'
	 if WinExists($thwnd)=1 Then
		 ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WinActivate($thwnd)
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:2]')
		controlSend($thwnd,'','',"{Esc}")
		$timerExitKonfigurator = Timerinit()+5000
	EndIf

	; выполнить обнновление конф-ии в конфигураторе
	$thwnd='[TITLE:Конфигуратор;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		 ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') выполнить обнновлен е конф-ии в конфигураторе : WinExists($thwnd) = ' & WinExists($thwnd) &  '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlSend($thwnd,'','',"{Enter}")
		$timerExitKonfigurator = Timerinit()
	EndIf
	if $timerExitKonfigurator<>0 and TimerDiff($timerExitKonfigurator) > $slp*5000 then
		$timerExitKonfigurator=0
		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &" выход из концигуратора по таймауту ")
		$thwnd='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
		$thwnd2='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
		_CloseConfigurator()
		_runPp()

	EndIf



	; завершение обновления в базе
;~ 	$thwnd='[TITLE:Конфигуратор;CLASS:V8NewLocalFrameBaseWnd]'
;~ 	 if WinExists($thwnd)=1 Then
;~ 		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : WinExists(''[CLASS:V8NewLocalFrameBaseWnd]'') = ' & WinExists('[CLASS:V8NewLocalFrameBaseWnd]')& @CRLF) ;### Debug Console
;~ 		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*3000)
;~ 	;~ 		_winclose('1С:Предприятие - Наша организация')
;~ 		sleep(1000)
;~ 		if WinExists('1С:Предприятие') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*2000)
;~ 		Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 		$Startchange = 2
;~ 		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
;~ 	EndIf

	; запуск $Startchange = 1
	$thwnd='[TITLE:Запуск 1С:Предприятия;CLASS:V8NewLocalFrameBaseWnd]'
	if WinExists($thwnd)=1 Then
		_startFromStartWindow()

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
		if WinActive($thwnd)<>0 then
			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
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
			ControlSend($thwnd,'','','{Alt}')
			sleep($slp*500)
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
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' & @CRLF & Clipget() & @CRLF)
			MouseClick('left')
			sleep(20)
			MouseClick('left')
			sleep(300)
			send ("^{Enter}")
			sleep(200)
			send ("^{Enter}")
			BlockInput(0)
			$Startchange = 1
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

		EndIf
		EndIf
	endif

	$thwnd='1С:Предприятие - Наша организация'
	$thwnd2='1С:Предприятие - Наша организация'
	Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
	$thwnd = WinGetTitle ( $namePp )
	Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
;~ 	$thwnd3='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
;~ 	$thwnd4='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
	if $CloseWinPp=1 then
		if WinExists($thwnd)=1 or WinExists($thwnd2)=1 or WinExists($thwnd3)=1 or WinExists($thwnd4)=1 Then
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			_ClosePp()
		EndIf
	Else
		if $timerExitPp=0 and WinExists($thwnd)=1 then
			$timerExitPp=timerinit()
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'Ожидание завершения окна Предприятие' & @CRLF)
		EndIf
		if $timerExitPp<>0 and WinExists($thwnd)=1 then
			if TimerDiff($timerExitPp) > $slp*5000 Then ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'|')
			if TimerDiff($timerExitPp) > $slp*10000 Then
				$timerExitPp=0
				ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $timerExitPp = ' & $timerExitPp & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				_ClosePp(0)
				_runConfigurator()

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
		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &' Рекомендуется обновить версию конфи' &@CRLF)
		ControlSend($thwnd,'','','{Tab}')
		ControlSend($thwnd,'','','{Enter}')
	endif

	   $iIdle = _IdleWaitStart($IdleMinimum)
;~     ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &_Now() & ' ' & @UserName & ' неактивен уже ' & _TickToTimeString($iIdle) & @CRLF)
    $iIdle = _IdleWaitCommit($IdleMinimum)
;~     ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &_Now() & ' ' & @UserName & ' был неактивен ' & _TickToTimeString($iIdle) & @CRLF)
	if _TickToTimeString($iIdle) > 30 Then

					Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
					$thwndP = WinGetTitle ( $namePp )
					Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		if WinActive($thwndP)<>0 Then
			$Startchange=1
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

			_ClosePp()
		Else
					Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
					$thwndC = WinGetTitle ( "Конфигуратор - " )
					Opt("WinTitleMatchMode", 3)
			if WinActive($thwndC)<>0 then
;~ 				_CloseConfigurator
				if $Startchange=2 then

					_runPp()
				Else
					$Startchange=2
					ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

				EndIf

			Else
				if WinExists($thwndP)<>0 and WinExists($thwndC)=0 then
					$Startchange=1
					ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

					_ClosePp()
				Else
					if WinExists($thwndP)=0 and WinExists($thwndC)<>0 then
						if $Startchange=2 then
							_runPp()
						Else
							$Startchange=2
							ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

						EndIf
					Else
						ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &' ОШИБКА ОШИБКА!!! неизвестная причина неактивности пользователя ' &@CRLF)
					EndIf
				EndIf

				sleep(5000)
			EndIf
		EndIf
	EndIf








	sleep(500)
WEnd

func _winclose($win)
	ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &' попытка закрыть окно: ' & $win) ; StringLeft($win,10))
	for $i=0 to 99
		if WinExists($win)=0 then
			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &' ; закрыто окно: ' & StringLeft($win,10) &"..." &@CRLF)
			Return
		EndIf
		WinClose($win)
			$thwnd=0
			$thwnd='[TITLE:1С:Предприятие;CLASS:V8NewLocalFrameBaseWnd; W:516; H:101]'
			 if WinExists($thwnd)=1 Then
				ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				WinActivate($thwnd)
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:2]')
				controlsend($thwnd,'','',"{Enter}")
				sleep($slp*1000)
			EndIf
			$thwnd='[TITLE:1С:Предприятие;CLASS:V8NewLocalFrameBaseWnd; W:224; H:101]'
			 if WinExists($thwnd)=1 Then
				ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
				controlsend($thwnd,'','',"{Enter}")
			EndIf
		sleep(100)
	Next
EndFunc


func _CloseConfigurator()
;~ 	sleep($slp*3000)
;~ 		$thwnd='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
;~ 		$thwnd2='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
;~ 		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
;~ 		$thwnd = WinGetTitle ( "Конфигуратор - " )
;~ 		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase

	;~ 		$thwnd3='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
	;~ 		$thwnd4='Конфигуратор - Бухгалтерия предприятия, редакция 2.0'
;~ 			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
;~ 			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
;~ 			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
;~ 		_winclose($thwnd)
;~ 		sleep(1000)
;~ 		$thwnd = '1С:Предприятие'
;~ 		if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*2000)
;~ 		Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 		$Startchange = 1
;~ 		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
EndFunc

func _runConfigurator()
;~ 		sleep($slp*2000)
;~ 		Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 		$Startchange = 2
;~ 		$CloseWinPp=1
;~ 		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
EndFunc

func _ClosePp($slpCpp=$slp)
	ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : _ClosePp() = ' &'>Error code: ' & @error & @CRLF) ;### Debug Console

	sleep($slpCpp*5000)

		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		$thwnd = WinGetTitle ( $namePp )
		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase

			_winclose($thwnd)
	;~ 			_winclose('1С:Предприятие - Зарплата и Управление Персоналом, редакция 2.5')
		sleep(1000)
		$thwnd = '1С:Предприятие'
		if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		$Startchange=2


				sleep($slp*1000)
		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		$thwnd = WinGetTitle ( "Конфигуратор - " )
		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		winactivate($thwnd)
	$timerExitPp=0
	EndFunc

		func _runPp()
		sleep($slp*2000)
		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		$thwnd = WinGetTitle ( "Конфигуратор - " )
		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		winactivate($thwnd)
		ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		send('^{F5}')

		Opt("WinTitleMatchMode", 1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
		$thwnd = WinGetTitle ( $namePp )
		Opt("WinTitleMatchMode", 3)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase

			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &" Ожидаю появление окна " & $thwnd & @CRLF )
		if winwait($thwnd,'',20) = 0 then
			send('^{F5}')
		EndIf



;~ 			sleep($slp*2000)
;~ 			Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 			$Startchange = 1
;~ 			ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &'@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
		EndFunc

func _startFromStartWindow()
;~ 			 WinActivate($thwnd)
;~ 		 if timerdiff($timeoutStart) > 15000 then
;~ 			 $timeoutStart= Timerinit()
;~ 			if $Startchange = 1 then
;~ 				$CloseWinPp=0
;~ 				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:10]')
;~ 				send('{Enter}')
;~ 				ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &" запуск 1С предприятия" & @CRLF)
;~ 			Else
;~ 				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:11]')
;~ 				send('{Enter}')
;~ 				ConsoleWrite(_NowTime(5)&'(' & @ScriptLineNumber & ') ' &" запуск 1С конфигуратор" & @CRLF)
;~ 			endif
;~ 		endif
EndFunc


; Ожидание начала бездействия пользователя.
; Возвращает время неактивности (в тиках)
; $idlesec - минимальная длительность ожидаемой неактивности (в тиках)
Func _IdleWaitStart($idlesec)
    Local $aRet, $iSave, $iTick, $LastInputInfo = DllStructCreate("uint;dword")
    DllStructSetData($LastInputInfo, 1, DllStructGetSize($LastInputInfo))
    DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($LastInputInfo))

    Do
        Sleep(200)
        $iSave = DllStructGetData($LastInputInfo, 2)
        DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($LastInputInfo))
        $aRet = DllCall("kernel32.dll", "long", "GetTickCount")
    Until ($aRet[0] - DllStructGetData($LastInputInfo, 2)) > $idlesec

    Return $aRet[0] - DllStructGetData($LastInputInfo, 2)
EndFunc   ;==>_IdleWaitStart












; Ожидание окончания бездействия пользователя.
; Возвращает время неактивности в (тиках)
; $idlesec - минимальная длительность ожидаемой неактивности в (тиках)
Func _IdleWaitCommit($idlesec)
    Local $iSave, $LastInputInfo = DllStructCreate("uint;dword")
    DllStructSetData($LastInputInfo, 1, DllStructGetSize($LastInputInfo))
    DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($LastInputInfo))

    Do
        $iSave = DllStructGetData($LastInputInfo, 2)
        Sleep(200)
        DllCall("user32.dll", "int", "GetLastInputInfo", "ptr", DllStructGetPtr($LastInputInfo))
    Until (DllStructGetData($LastInputInfo, 2) - $iSave) > $idlesec

    Return DllStructGetData($LastInputInfo, 2) - $iSave
EndFunc   ;==>_IdleWaitCommit

Func _TickToTimeString($iTicks)
    Local $iHours, $iMins, $iSecs, $sText = ''
    _TicksToTime($iTicks, $iHours, $iMins, $iSecs)

    If $iHours Then $sText = $iHours *3600
    If $iMins Then $sText += $iMins *60
    If $iSecs Then $sText += $iSecs
    If $sText = '' Then $sText = 0

    Return $sText
EndFunc   ;==>_TickToTimeString