#Include <WinAPIEx.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("PixelCoordMode", 2)
HotKeySet("{End}", "Terminate")
HotKeySet("{Ins}", "_Pause")
;~ HotKeySet("{Home}", "_Wait_Battle")
Func Terminate()
;~ TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
ProcessClose('Bot_WOT_s.exe')
;~ 	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
global $Paused
Global Const $sProcess = 'WorldOfTanks.exe'

;~ global $menuCPU, $menuMEM
#include <Constants.au3>
ProcessClose('Bot_WOT_s.exe')
$path=@ScriptDir & "\Bot_WOT_s.exe"
Global $turnd=10, $turn = 1, $stop = 0, $TimeOutTurn = 0
;~ global $iPID = Run($path, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
;~ Local $sOutput, $SummmenuCPU, $SummmenuMEM
;~ global $SummmenuCPU=0,$SummmenuMEM=0
global $CruiseControl=1, $ModRadio=1, $Timeturn=1800, $TimeFightDelay=900000, $TimeWaitDelay=30000, $Kwait1=1.01, $Kwait2=1.02, $Kloading=1.05, $KUnloading=1.045, $KAverUnloading=1.04



Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=D:\Vitaliy\PROGRAMS\autoitv3.3.8.1\Koda\Bot_WoT.kxf
$hForm = GUICreate("Autoshot Shotgun", 279, 671, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
GUISetOnEvent($GUI_EVENT_CLOSE, "hFormClose")
$Button1 = GUICtrlCreateButton("Танк готов к бою", 8, 640, 99, 25)
GUICtrlSetOnEvent(-1, "_apply")
$Button2 = GUICtrlCreateButton("Скопировать лог", 168, 640, 99, 25)
GUICtrlSetOnEvent(-1, "_CopyLog")
$Edit1 = GUICtrlCreateEdit("", 8, 144, 257, 490, BitOR($ES_AUTOVSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
$Radio1 = GUICtrlCreateRadio("Почти не мешающий бот", 8, 8, 153, 17)
GUICtrlSetOnEvent(-1, "Radio1Click")
$Radio2 = GUICtrlCreateRadio("Имитация поворотов при остановке машины", 8, 32, 249, 17)
GUICtrlSetOnEvent(-1, "Radio2Click")
$Checkbox1 = GUICtrlCreateCheckbox("Круизконтроль", 16, 56, 97, 17)
GUICtrlSetOnEvent(-1, "Checkbox1Click")
$Input1 = GUICtrlCreateInput("1800", 144, 120, 121, 21)
GUICtrlSetOnEvent(-1, "Input1Change")
GUICtrlSetTip(-1, "Время поворота танка ~ на 90° в миллисекундах")
$Label1 = GUICtrlCreateLabel("Время поворота танка", 8, 120, 119, 17)
GUICtrlSetTip(-1, "Время поворота танка ~ на 90° в миллисекундах")
$Input2 = GUICtrlCreateInput("15", 144, 96, 121, 21)
GUICtrlSetOnEvent(-1, "Input2Change")
GUICtrlSetTip(-1, "Устанавливается на случай ошибки, мин.")
$Label2 = GUICtrlCreateLabel("Максимальное время боя", 8, 96, 137, 17)
GUICtrlSetTip(-1, "Устанавливается на случай ошибки, мин.")
$Button3 = GUICtrlCreateButton("Пауза", 112, 640, 49, 25)
GUICtrlSetOnEvent(-1, "_Pause")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetData($Edit1, 'Горячие клавши: "END" - закрыть БОТ' &@CRLF,1)
GUICtrlSetData($Edit1, '"INS" - приостановить БОТ (пауза)' &@CRLF,1)
GUICtrlSetState($Radio2, $GUI_CHECKED)
GUICtrlSetState($Checkbox1, $GUI_CHECKED)
_applyGUI()

$SCHET = 599
While 1
	$SCHET += 1
	Sleep(100)
	IF MOD($SCHET,600)=0 THEN GUICtrlSetData($Edit1, "Ожидаю действий пользователя.." &@CRLF,1)
	IF MOD($SCHET,100)=0 THEN _applyGUI()
WEnd

Func _apply()
	_applyGUI()
	_startBot()

EndFunc
Func _CopyLog()
	ClipPut(GUICtrlRead($Edit1))
EndFunc
Func Checkbox1Click()
	_applyGUI()
EndFunc
Func hFormClose()
	Terminate()
EndFunc
Func Input1Change()
	_applyGUI()
EndFunc
Func Input2Change()
	_applyGUI()
EndFunc
Func Radio1Click()

	GUICtrlSetState($Input1, $GUI_DISABLE)
	GUICtrlSetState($Label1, $GUI_DISABLE)
	GUICtrlSetState($Checkbox1, $GUI_ENABLE)
	_applyGUI()
EndFunc
Func Radio2Click()
	GUICtrlSetState($Input1, $GUI_ENABLE)
	GUICtrlSetState($Label1, $GUI_ENABLE)
	GUICtrlSetState($Checkbox1, $GUI_CHECKED)
	GUICtrlSetState($Checkbox1, $GUI_DISABLE)
	_applyGUI()
EndFunc

Func _applyGUI()
	If GUICtrlRead($Checkbox1)=1 Then
		$CruiseControl=1
	Else
		$CruiseControl=0
	EndIf
	If GUICtrlRead($Radio1)=1 Then
		$ModRadio=1
		GUICtrlSetState($Input1, $GUI_DISABLE)
		GUICtrlSetState($Label1, $GUI_DISABLE)
		GUICtrlSetState($Checkbox1, $GUI_ENABLE)
	Else
		$ModRadio=2
		GUICtrlSetState($Input1, $GUI_ENABLE)
		GUICtrlSetState($Label1, $GUI_ENABLE)
		GUICtrlSetState($Checkbox1, $GUI_CHECKED)
		GUICtrlSetState($Checkbox1, $GUI_DISABLE)
	EndIf
	$Timeturn=GUICtrlRead($Input1)
	$TimeFightDelay=GUICtrlRead($Input2)*60000

;~ 	GUICtrlSetData($Edit1, '$ModRadio= '&$ModRadio &@CRLF,1)
;~ 	GUICtrlSetData($Edit1, '$CruiseControl= '&$CruiseControl &@CRLF,1)
;~ 	GUICtrlSetData($Edit1, '$Timeturn= '&$Timeturn &@CRLF,1)
;~ 	GUICtrlSetData($Edit1, '$TimeFightDelay= '&$TimeFightDelay &@CRLF,1)
EndFunc

Func _Pause()
	GUICtrlSetData($Edit1, "Функция паузы" &@CRLF,1)
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
;~ 		 $msg = GUIGetMsg()
;~         Select
;~             Case $msg = $GUI_EVENT_CLOSE
;~                 MsgBox(0, "", "Диалог был закрыт", 0, $hForm )
;~                 Exit
;~             Case $msg = $GUI_EVENT_MINIMIZE
;~                 MsgBox(0, "", "Диалог свёрнут", 2, $hForm )
;~             Case $msg = $Button3
;~                 MsgBox(0, "Текущий выбор", "Радио " , 0, $hForm )
;~         EndSelect
		If $trayP = 1 Then
			GUICtrlSetData($Edit1,  @hour&':'&@MIN&':'&@SEC&' '&'Нажата пауза, для продолжения НАЖМИТЕ КЛАВИШУ "INS" на клавиатуре' &@CRLF,1)
			TrayTip("Подсказка", "Пауза", 1000)
		EndIf
		Sleep(100)
	WEnd
;~ 	ToolTip("")
EndFunc   ;==>_Pause


Func _startBot()

	global $hwnd=WinGetHandle('WoT Client')

	global $thwnd=WinGetTitle('[ACTIVE]')

	while 1


		;клик БОЙ (тройной на всякий случай)
		WinActivate($hwnd)
		Opt("MouseCoordMode",2)
		MouseMove(Random(505,515),Random(45,55))
		MouseClick('left',Random(505,515),Random(45,55))
		sleep(200)
		WinActivate($hwnd)
		Opt("MouseCoordMode",2)
		MouseMove(Random(505,515),Random(45,55))
		MouseClick('left',Random(505,515),Random(45,55))
		sleep(200)
		WinActivate($hwnd)
		Opt("MouseCoordMode",2)
		MouseMove(Random(505,515),Random(45,55))
		MouseClick('left',Random(505,515),Random(45,55))
		sleep(200)
		WinActivate($thwnd)
		GUICtrlSetData($Edit1, @hour&':'&@MIN&':'&@SEC&' '& " Клик на копку БОЙ " & @CRLF,1)
		global $ArrayWaitCPU,$ArrayWaitMEM
		_Wait()

		GUICtrlSetData($Edit1, @hour&':'&@MIN&':'&@SEC&' '& " Ожидание начала боя закончено " & @CRLF,1)
		;Ожидание
;~ 		For $i=1 to 20
;~ 			global $WaitCPU=_ArrayMax($ArrayWaitCPU,1),$WaitMEM=_ArrayMax($ArrayWaitMEM,1)
;~ 			If ($WaitCPU/1.6)<$menuCPU or ($WaitMEM/1.1)<$menuMEM then
;~ 				_Wait()
;~ 			Else
;~ 				GUICtrlSetData($Edit1, @hour&':'&@MIN&':'&@SEC&' '& " Режим ожидания закончен " & @CRLF,1)
;~ 				ExitLoop
;~ 			Endif
;~ 		next
		sleep(10000)
		_CruiseControl()

		_stopdetect()
		_Wait_Battle()
		sleep(5000)

		;закытие сообщение завершения боя
		$thwnd=WinGetTitle('[ACTIVE]')
		ControlSend($hwnd,'','','{Esc}')
		sleep(100)
		ControlSend($hwnd,'','','{Enter}')
		WinActivate($hwnd)
		Sleep(100)
		Send('{Enter Down}')
		sleep(64)
		Send('{Enter Up}')
		Sleep(100)
		ControlSend($hwnd,'','','{Space}')
		sleep(500)

	WEnd
Endfunc

Func _Wait()
	$timerWait=TimerInit()
	$PID = ProcessExists($sProcess)
	local $timerLoading=-1
		$Mem = _WinAPI_GetProcessMemoryInfo($PID)
		$memory=_KB(Round($Mem[9] / 1024))
		Dim $Prevmemory[10]
		For $i=0 to UBound($Prevmemory)-1
			$Prevmemory[$i]=$memory
		Next

	While 1
		$Mem = _WinAPI_GetProcessMemoryInfo($PID)
		$memory=_KB(Round($Mem[9] / 1024))
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $memory = ' & $memory& @CRLF) ;### Debug Console
		_ArrayPush($Prevmemory, $memory)

		If $Prevmemory[3]*$Kwait1<$Prevmemory[1] Then
			If $Prevmemory[1]/$Kwait2>$Prevmemory[0] then
				GUICtrlSetData($Edit1, @MIN&@SEC&' '& ' Обнаружен скачек оперативной памяти ' &@CRLf,1)
				ExitLoop
			EndIf
		EndIf
		If $Prevmemory[7]*$Kwait1<$Prevmemory[1] Then
			If $Prevmemory[1]/$Kwait2>$Prevmemory[0] then
				GUICtrlSetData($Edit1, @MIN&@SEC&' '& ' Обнаружен скачек оперативной памяти. тип2 ' &@CRLf,1)
				ExitLoop
			EndIf
		EndIf

		if $Prevmemory[9]*$Kloading<$Prevmemory[0] Then
			if $timerLoading<0 Then
				$timerLoading=TimerInit()
			EndIf
		EndIf
		if $timerLoading>0 Then
			if TimerDiff($timerLoading)>15000 Then
				GUICtrlSetData($Edit1, @MIN&@SEC&' '& ' Обнаружено повышение оперативной памяти ' &@CRLf,1)
				exitloop
			EndIf
		EndIf
		;выход по таймауту
		if TimerDiff($timerWait)>$TimeWaitDelay then
			GUICtrlSetData($Edit1, @MIN&@SEC&' '& ' Окончание ожидания по таймауту: '&$TimeWaitDelay/1000&'сек.' &@CRLf,1)
			exitloop
		EndIf
		sleep(500)
	wend
Endfunc

Func _Wait_Battle()
	$timerWait=TimerInit()
	$schet=0
	GUICtrlSetData($Edit1, @hour&':'&@MIN&':'&@SEC&' '& ' Начато ожидание окончания боя ' &@CRLf,1)
	$PID = ProcessExists($sProcess)
	local $timerLoading=-1
		$Mem = _WinAPI_GetProcessMemoryInfo($PID)
		$memory=_KB(Round($Mem[9] / 1024))
		Dim $Prevmemory[20], $AverPrevmemory[10]
		For $i=0 to UBound($Prevmemory)-1
			$Prevmemory[$i]=$memory
		Next
		For $i=0 to UBound($AverPrevmemory)-1
			$AverPrevmemory[$i]=$memory
		Next

	While 1
		$schet+=1
		$Mem = _WinAPI_GetProcessMemoryInfo($PID)
		$memory=_KB(Round($Mem[9] / 1024))
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $memory = ' & $memory& @CRLF) ;### Debug Console
		_ArrayPush($Prevmemory, $memory)
		IF MOD($schet,4)=0 THEN
			_ArrayPush($AverPrevmemory, ($Prevmemory[0]+$Prevmemory[1]+$Prevmemory[2]+$Prevmemory[3])/4)
			if $AverPrevmemory[4]/$KAverUnloading>$AverPrevmemory[0] Then
				GUICtrlSetData($Edit1, @MIN&@SEC&' '& ' Обнаружено снижение оперативной памяти по средним значениям ' &@CRLf,1)
				ExitLoop
			EndIf
		EndIf

		If $Prevmemory[14]/$KUnloading>$Prevmemory[0] then
			GUICtrlSetData($Edit1, @MIN&@SEC&' '& ' Обнаружено снижение оперативной памяти за последние 7сек ' &@CRLf,1)
			ExitLoop
		EndIf

		;выход по таймауту
		if TimerDiff($timerWait)>$TimeFightDelay then
			GUICtrlSetData($Edit1, @MIN&@SEC&' '& ' Выход из боя по таймауту: '&$TimeFightDelay/60000&'мин.' &@CRLf,1)
			exitloop
		EndIf
		sleep(500)
	WEnd

	ConsoleWrite (' Бой окончен ' &@CRLF)


EndFunc

#comments-start


Func _Menu() ; функция устарела и не используеться...
	Traytip(" подсказка ", ' Пожалуйста просто подождите ~15сек. ', 1000)
	For $i=1 to 6
		$sOutput = StdoutRead($iPID)
		If @error Then ; Выход из цикла, если процесс завершён или StdoutRead возвращает ошибку.
			ExitLoop
		EndIf
		if StringinStr($sOutput,'|')<>0 then
			$CPUMEM=stringsplit($sOutput,'|')
			if $i=1 then
				$PrevCPUMEM=$CPUMEM
			Else
				$SummmenuCPU+=$CPUMEM[1]
				$SummmenuMEM+=$CPUMEM[2]
			EndIf
			;проверка на большие колебания показателей
			if 0.5<$PrevCPUMEM[1]/$CPUMEM[1]>2 or 0.5<$PrevCPUMEM[2]/$CPUMEM[2]>2 Then
				GUICtrlSetData($Edit1,  'обнаружена ошибка в показаниях процесса, данные : '& ' '&$PrevCPUMEM[1]& ' '&$CPUMEM[1]& '   '&$PrevCPUMEM[2]& ' '&$CPUMEM[2] &@CRLF,1)
				_Menu()
				Return
			EndIf
			$PrevCPUMEM=$CPUMEM
			GUICtrlSetData($Edit1, $CPUMEM[1] &'   '& $CPUMEM[2],1)
		Else
			$i-=1
		EndIf


		Sleep(100)
	next

	$menuCPU=$SummmenuCPU/5
	$menuMEM=$SummmenuMEM/5
	GUICtrlSetData($Edit1, '@@ Debug(' & @ScriptLineNumber & ') : $menuCPU = ' & $menuCPU &' ;  $menuMEM = ' & $menuMEM &  @CRLF,1) ;### Debug Console
EndFunc


Func _WaitOld()
	$w=1
	$schet=0
	$timerWait=TimerInit()
	Dim $ArrayWaitCPU[2],$ArrayWaitMEM[2]
	While $w=1
		$sOutput = StdoutRead($iPID)
		If @error Then ; Выход из цикла, если процесс завершён или StdoutRead возвращает ошибку.
			ExitLoop
		EndIf
		if StringinStr($sOutput,'|')<>0 then
			$CPUMEM=stringsplit($sOutput,'|')
			Redim $ArrayWaitCPU[$schet+1],$ArrayWaitMEM[$schet+1]
			$ArrayWaitCPU[$schet]=$CPUMEM[1]
			$ArrayWaitMEM[$schet]=$CPUMEM[2]
			$schet+=1
		EndIf
		Sleep(100)
		if TimerDiff($timerWait)>30000 then $w=0
	Wend
EndFunc

Func _Wait_BattleOld()

	$w=1
	$schet=0
	$timerWait=TimerInit()
	local $PrevCPUMEM[3]=[2,0,0] , $PrevPrevCPUMEM[3]=[2,0,0]
	Dim $ArrayWaitCPU[2],$ArrayWaitMEM[2]
	while $w=1
		$sOutput = StdoutRead($iPID)
		If @error Then ; Выход из цикла, если процесс завершён или StdoutRead возвращает ошибку.
			ExitLoop
		EndIf
		if StringinStr($sOutput,'|')<>0 then
			$CPUMEM=stringsplit($sOutput,'|')
			$CPUMEM[1]=Number($CPUMEM[1])
			$CPUMEM[2]=Number($CPUMEM[2])
			;Проверка данных на корректность
			if 0.5<$PrevCPUMEM[1]/$CPUMEM[1]>2 or 0.5<$PrevCPUMEM[2]/$CPUMEM[2]>2 or 0.5<$PrevPrevCPUMEM[1]/$PrevCPUMEM[1]>2 Then
				GUICtrlSetData($Edit1,  'обнаружена ошибка в показаниях процесса, данные : '& ' '&$PrevCPUMEM[1]& ' '&$CPUMEM[1]& '   '&$PrevCPUMEM[2]& ' '&$CPUMEM[2] &@CRLF,1)
			Else
				$schet+=1
					If $schet>3 then ;пропуск первых показаний
						$sravznach=($CPUMEM[2]*1.05)
						if $sravznach<$PrevCPUMEM[2] or $sravznach<$PrevPrevCPUMEM[2] then
							GUICtrlSetData($Edit1,  @CRLF&' $CPUMEM2 = ' &($CPUMEM[2]*1.05)& ' '&Round($PrevCPUMEM[2],0)& ' '&Round($PrevPrevCPUMEM[2],0),1)
							ConsoleWrite (' Бой окончен ' &@CRLF)
							exitloop
						EndIf
;~ 						GUICtrlSetData($Edit1,  ' $PrevCPUMEM = ' & $PrevCPUMEM[1]& ' '&$PrevCPUMEM[2] ,1)
					EndIf

;~ 					GUICtrlSetData($Edit1, ' $PrevPrevCPUMEM = ' & $PrevPrevCPUMEM[1]& ' '&$PrevPrevCPUMEM[2]& @CRLF,1)
;~ 					GUICtrlSetData($Edit1,  @CRLF&' $CPUMEM = ' & $CPUMEM[1]& ' '&$CPUMEM[2],1)
;~ 					GUICtrlSetData($Edit1,  ' $PrevCPUMEM = ' & $PrevCPUMEM[1]& ' '&$PrevCPUMEM[2] ,1)
;~ 					GUICtrlSetData($Edit1, ' $PrevPrevCPUMEM = ' & $PrevPrevCPUMEM[1]& ' '&$PrevPrevCPUMEM[2]& @CRLF,1)
					$PrevPrevCPUMEM=$PrevCPUMEM
					$PrevCPUMEM=$CPUMEM
			Endif
		Else

		EndIf
		Sleep(100)

		if TimerDiff($timerWait)>900000 then $w=0
		sleep(200)
	WEnd

	ConsoleWrite (' Бой окончен ' &@CRLF)

EndFunc
#comments-end

Func _CruiseControl()
	ControlSend($hwnd,'','','{R}')
	ControlSend($hwnd,'','','{R}')
	ControlSend($hwnd,'','','{R}')
	;~ ControlSend($hwnd,'','','{r}')
	ControlSend($hwnd,'','','{К}')
	ControlSend($hwnd,'','','{К}')
	ControlSend($hwnd,'','','{К}')
	;~ ControlSend($hwnd,'','','{к}')
	sleep(10)
	$thwnd=WinGetTitle('[ACTIVE]')
	WinActivate($hwnd)
	sleep(500) ;лишний делай?
	Send('{r down}')
	Send('{к down}')
	 sleep(100)
	Send('{r up}')
	Send('{к up}')
	WinActivate($thwnd)
EndFunc

Func _stopdetect()
	Opt("PixelCoordMode", 2) ;1=абсолютные, 0=относительные, 2=клиентские
	$hwnd = WinGetHandle('WoT Client')
	WinActivate($hwnd)

	Sleep(500)
	$shade = 25
	$shade2 = 3
	$SCHET = 0
	$NoLifeSchet=0
	$NoLifeSchet0=0
	local $NoLifeTime, $NoLifeTime0, $TimeStop

	;ожидание первого движения
	While 1
		$timeDelay123=Timerinit()
		PixelSearch(4,567,4,569,0x717D69,30,1,$hwnd)
		if not @error Then
			if _pixelSearchSpeed($hwnd)=1 then

			Else
				GUICtrlSetData($Edit1, @hour&':'&@MIN&':'&@SEC&' '& " Танк жив и движется " & @CRLF,1)
				exitloop
			EndIf
		EndIf

		if Timerdiff($timeDelay123)>30000 then ExitLoop
		sleep(500)
	wend

	Send('{r down}')
	Send('{к down}')
	 sleep(100)
	Send('{r up}')
	Send('{к up}')

	While 1
		$SCHET += 1

	;~ $PixelsearchEx=PixelsearchEx(65,605-12,107-28,625-12,0x716E5F,$shade,177,1,$hwnd,$shade2)
	;~ $PixelsearchEx=PixelsearchEx(68,596,70,598,0x716E5F,$shade,177,1,$hwnd,$shade2)
	;~ $PixelsearchEx=PixelsearchEx(69,597,69,597,0x716E5F,$shade,177,1,$hwnd,$shade2)
;~ 		$PixelsearchEx = PixelsearchEx(69, 597, 69, 597, 0x736E4B, $shade, 179, 1, $hwnd, $shade2)
;~ 	 $PixelsearchEx=PixelsearchEx(69,597,69,597,0x736E4B,$shade,179,1,$hwnd,$shade2)
;~ 		If Not @error Then
		if _pixelSearchSpeed($hwnd)=1 then
	;~ 	GUICtrlSetData($Edit1, " Найденнно: " & $PixelsearchEx[0] &' '& $PixelsearchEx[1] &@CRLF,1)
			GUICtrlSetData($Edit1, ".",1)
			If $stop = 0 Then $TimeStop = TimerInit()

			;Опреджеление жизни танка
			PixelSearch(4,567,4,569,0xC65E55,30,1,$hwnd)
			if not @error then
				GUICtrlSetData($Edit1, "танк мертв",1)
					if $NoLifeSchet0=0 Then $NoLifeTime0=TimerInit()
					$NoLifeSchet0+=1
					if Timerdiff($NoLifeTime0)>3000 and $NoLifeSchet0>3 then Return
			Else
				PixelSearch(4,567,4,569,0x717D69,30,1,$hwnd)
				if not @error Then
;~ 					GUICtrlSetData($Edit1, "танк жив",1)
				Else
					GUICtrlSetData($Edit1, "танк нежив!",1)
					if $NoLifeSchet=0 Then $NoLifeTime=TimerInit()
					$NoLifeSchet+=1
					if Timerdiff($NoLifeTime)>10000 and $NoLifeSchet>5 then Return
				EndIf
			EndIf

			$stop = 1
			If $stop = 1 Then
				If TimerDiff($TimeStop) > 1000 Then
					$stop = 0
					_turn()
				EndIf
			EndIf

		Else
	;~ 	GUICtrlSetData($Edit1, " Ненайденнно! " &@CRLF,1)
			GUICtrlSetData($Edit1, "0",1)



		EndIf
		IF MOD($SCHET,10)=0 THEN GUICtrlSetData($Edit1, @CRLF,1)
		Sleep(300)
	WEnd
EndFunc

Func _pixelSearchSpeed($hwnd)
	$shade = 25
	$shade2 = 3
	PixelSearch(69, 597, 69, 597, 0x736E4B, $shade,1,$hwnd)
	if not @error then
;~ 		GUICtrlSetData($Edit1, '@@ Debug(' & @ScriptLineNumber & ') : PixelGetColor(69, 597,$hwnd) = ' & Hex(PixelGetColor(69, 597,$hwnd),6) & @CRLF,1) ;### Debug Console
		PixelSearch(69+1, 597+2, 69+1, 597+8, 0x7B7B61, 35)
		if @error then
			GUICtrlSetData($Edit1, ".",1)
			return 1
		Else
			return 0
;~ 			GUICtrlSetData($Edit1, "0",1)
		EndIf
	EndIf
	return 0
EndFunc

Func _turn()

	;смена направления поворота
	If 900000 > TimerDiff($TimeOutTurn) Then
		If $turn = 1 Then
			If TimerDiff($TimeOutTurn) > 2000 Then
				$turn = 2
			EndIf
		Else
			If $turn = 2 Then
				If TimerDiff($TimeOutTurn) > 2000 Then
					$turn = 1
				EndIf
			EndIf
		EndIf
	EndIf

	;отслеживание количества поворотов в одну сторону
	If $turn=1 Then
;~ 		GUICtrlSetData($Edit1, '@@ Debug(' & @ScriptLineNumber & ') : $turn = ' & $turn & @CRLF & '>Error code: ' & @error & @CRLF,1) ;### Debug Console

		If 9<$turnd<19 then
			$turnd+=1
;~ 					GUICtrlSetData($Edit1, '@@ Debug(' & @ScriptLineNumber & ') : $turnd = ' & $turnd & ' turn='&$turn  & @CRLF,1) ;### Debug Console
		Else
			$turnd=10
		EndIf
	Else
		If 19<$turnd<29 then
			$turnd+=1
;~ 					GUICtrlSetData($Edit1, '@@ Debug(' & @ScriptLineNumber & ') : $turnd = ' & $turnd & ' turn='&$turn  & @CRLF,1) ;### Debug Console
		Else
			$turnd=20
		EndIf
	EndIf
	;изменение направления в случае превышения количества поворотов
;~ 	GUICtrlSetData($Edit1, ' перед сменой направления '') : $turnd = ' & $turnd & ' turn='&$turn  & @CRLF,1)
	If 13<$turnd and 19>$turnd Then
		if $turn=1 then
			$turn=2
			$turnd=20
		Else
			$turn=1
			$turnd=10
		EndIf
;~ 				GUICtrlSetData($Edit1, ' смена направления '') : $turnd = ' & $turnd & ' turn='&$turn  & @CRLF,1)
	EndIf
	If 23<$turnd and 29>$turnd Then
		if $turn=1 then
			$turn=2
			$turnd=20
		Else
			$turn=1
			$turnd=10
		EndIf
;~ 				GUICtrlSetData($Edit1, ' смена направления '') : $turnd = ' & $turnd & ' turn='&$turn  & @CRLF,1)
	EndIf
;~ 		GUICtrlSetData($Edit1, '@@ Debug(' & @ScriptLineNumber & ') : $turnd = ' & $turnd & ' turn='&$turn  & @CRLF,1) ;### Debug Console

	If $turn = 1 Then
		GUICtrlSetData($Edit1, ' поворот налево ' & @CRLF,1)
		Send('{ф down}')
		Send('{a down}')
		Sleep(2000)
		Send('{ф up}')
		Send('{a up}')
		$TimeOutTurn = TimerInit()
	EndIf
	If $turn = 2 Then
		GUICtrlSetData($Edit1, ' поворот направо ' & @CRLF,1)
		Send('{d down}')
		Send('{в down}')
		Sleep(2000)
		Send('{d up}')
		Send('{в up}')
		$TimeOutTurn = TimerInit()
	EndIf
EndFunc   ;==>_turn

;~ For $i=0 to 99
;~ ControlSend($hwnd,'','','{R}')
;~ next
Func _KB($iSize)
    If StringLen($iSize) > 3 Then
        Return StringTrimRight($iSize, 3)  & ',' & StringLeft($iSize, 3) ; & ' K'
    EndIf
EndFunc   ;==>_KB