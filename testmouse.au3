global $t0
HotKeySet('^+{f6}','_tt')
HotKeySet('{f7}','_update')
HotKeySet("^+{F7}", "_Quit") ;Это вызов
$sleep = 179000
$sleepStart = 20000*2
$patchYoTariff = 'C:\Users\Виталий\Desktop\YoTarif\YoTarif.exe'

beep(1000,4000)
exit

While 1
	sleep(100)
WEnd


Func _tt()
	$apos = MouseGetPos()
	$col = PixelGetColor($apos[0],$apos[1])

	While 1
		$t0= TimerInit()
		ConsoleWrite(@HOUR&@MIN&@SEC)
		BlockInput(1)
		$Origapos = MouseGetPos()
		sleep(50)
;~ 		MouseClick('left',$apos[0],$apos[1],1,0)
		MouseMove($apos[0],$apos[1],0)
		sleep(50)
		MouseDown('left')
		sleep(100)
		MouseUp('left')
		MouseMove($Origapos[0],$Origapos[1],0)
		sleep(50)
		BlockInput(0)
		$t1 = TimerInit()
		sleep(50)
		While PixelGetColor($apos[0],$apos[1]) <> $col
			sleep(100)
			if TimerDiff($t0)+5000 > $sleep Then
				ProcessClose("YoTarif.exe")
				sleep(100)
				Run($patchYoTariff)
				sleep($sleepStart)
			EndIf

		WEnd
		ConsoleWrite( ' (' &TimerDiff($t0)& ')' & ' Время подключения = ' & TimerDiff($t1) & @CRLF)
		While TimerDiff($t0) < $sleep
			sleep(100)
		WEnd
	WEnd

EndFunc

func _update()
	$t0=0
EndFunc

func _Quit()
	Exit
EndFunc

