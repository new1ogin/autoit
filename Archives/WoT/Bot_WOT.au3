#Include <WinAPIEx.au3>
#include <Array.au3>
Opt("PixelCoordMode", 2)
HotKeySet("{End}", "Terminate")
;~ HotKeySet("{Ins}", "_Menu")
;~ HotKeySet("{Home}", "_Wait_Battle")
Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
ProcessClose('Bot_WOT_s.exe')
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

global $menuCPU, $menuMEM
#include <Constants.au3>
ProcessClose('Bot_WOT_s.exe')
$path=@ScriptDir & "\Bot_WOT_s.exe"
Global $turn = 1, $stop = 0, $TimeOutTurn = 0
global $iPID = Run($path, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
Local $sOutput, $SummmenuCPU, $SummmenuMEM


global $SummmenuCPU=0,$SummmenuMEM=0

;~ ConsoleWrite(' бесконечное ожидание начато '&@CRLF)
;~ While 1
;~ 	sleep(100)
;~ WEnd


;~ _Menu()

	$hwnd=WinGetHandle('WoT Client')

	$thwnd=WinGetTitle('[ACTIVE]')

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

	global $ArrayWaitCPU,$ArrayWaitMEM
	_Wait()


	;Ожидание
	For $i=1 to 20
		global $WaitCPU=_ArrayMax($ArrayWaitCPU,1),$WaitMEM=_ArrayMax($ArrayWaitMEM,1)
		If ($WaitCPU/1.6)<$menuCPU or ($WaitMEM/1.1)<$menuMEM then
			_Wait()
		Else
			ConsoleWrite(" Режим ожидания закончен " & @CRLF)
			ExitLoop
		Endif
	next
	sleep(3000)
	_CruiseControl()

	_Wait_Battle()
	sleep(5000)

	;закытие сообщение завершения боя
	$thwnd=WinGetTitle('[ACTIVE]')
	ControlSend($hwnd,'','','{Esc}')
	WinActivate($hwnd)
	Sleep(100)
	ControlSend($hwnd,'','','{Enter}')
	Sleep(100)
	ControlSend($hwnd,'','','{Enter}')
	Sleep(100)
	ControlSend($hwnd,'','','{Esc}')
	sleep(500)

WEnd

Func _Menu()
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
				ConsoleWrite( 'обнаружена ошибка в показаниях процесса, данные : '& ' '&$PrevCPUMEM[1]& ' '&$CPUMEM[1]& '   '&$PrevCPUMEM[2]& ' '&$CPUMEM[2] &@CRLF)
				_Menu()
				Return
			EndIf
			$PrevCPUMEM=$CPUMEM
			ConsoleWrite($CPUMEM[1] &'   '& $CPUMEM[2])
		Else
			$i-=1
		EndIf


		Sleep(100)
	next

	$menuCPU=$SummmenuCPU/5
	$menuMEM=$SummmenuMEM/5
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $menuCPU = ' & $menuCPU &' ;  $menuMEM = ' & $menuMEM &  @CRLF) ;### Debug Console
EndFunc

Func _Wait()
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

Func _Wait_Battle()
	ConsoleWrite(' Начато ожидание окончания боя ' &@CRLf)
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
				ConsoleWrite( 'обнаружена ошибка в показаниях процесса, данные : '& ' '&$PrevCPUMEM[1]& ' '&$CPUMEM[1]& '   '&$PrevCPUMEM[2]& ' '&$CPUMEM[2] &@CRLF)
			Else
				$schet+=1
					If $schet>3 then ;пропуск первых показаний
						$sravznach=($CPUMEM[2]*1.05)
						if $sravznach<$PrevCPUMEM[2] or $sravznach<$PrevPrevCPUMEM[2] then
							ConsoleWrite( @CRLF&' $CPUMEM2 = ' &($CPUMEM[2]*1.05)& ' '&Round($PrevCPUMEM[2],0)& ' '&Round($PrevPrevCPUMEM[2],0))
							ConsoleWrite (' Бой окончен ' &@CRLF)
							exitloop
						EndIf
;~ 						ConsoleWrite( ' $PrevCPUMEM = ' & $PrevCPUMEM[1]& ' '&$PrevCPUMEM[2] )
					EndIf

;~ 					ConsoleWrite(' $PrevPrevCPUMEM = ' & $PrevPrevCPUMEM[1]& ' '&$PrevPrevCPUMEM[2]& @CRLF)
;~ 					ConsoleWrite( @CRLF&' $CPUMEM = ' & $CPUMEM[1]& ' '&$CPUMEM[2])
;~ 					ConsoleWrite( ' $PrevCPUMEM = ' & $PrevCPUMEM[1]& ' '&$PrevCPUMEM[2] )
;~ 					ConsoleWrite(' $PrevPrevCPUMEM = ' & $PrevPrevCPUMEM[1]& ' '&$PrevPrevCPUMEM[2]& @CRLF)
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
	;~ sleep(100)
	WinActivate($thwnd)
EndFunc


;~ For $i=0 to 99
;~ ControlSend($hwnd,'','','{R}')
;~ next
Func _KB($iSize)
    If StringLen($iSize) > 3 Then
        Return StringTrimRight($iSize, 3)  & ',' & StringLeft($iSize, 3) ; & ' K'
    EndIf
EndFunc   ;==>_KB