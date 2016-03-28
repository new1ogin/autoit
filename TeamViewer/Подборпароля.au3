#Include <WinAPIEx.au3>
#include <Inet.au3>
#include <File.au3>
#include <log.au3>
#include <array.au3>
HotKeySet("{End}", "Terminate") ;забиваем клавиши для функций
HotKeySet("{Ins}", "_Pause")
Func Terminate() ;функция выхода
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	_EndWindow()
	Exit 0
EndFunc   ;==>Terminate
global $Paused
Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		If $trayP = 1 Then
			TrayTip("Подсказка", "Пауза", 1000)
		EndIf
		Sleep(100)
	WEnd
EndFunc   ;==>_Pause


$hwnd = WinActivate('[CLASS:#32770]')
;~ WinMove($hwnd,'',1980,1080)

$aPosWindow = WinGetPos ( $hwnd )
WinMove($hwnd,'',@DesktopWidth-$aPosWindow[2]/2+100,@DesktopHeight/2-$aPosWindow[3]/2)
;~ exit
$timerEAPM = TimerInit()
Opt("MouseCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
;~ ControlClick($hwnd,'','','left',1,211,246)
;~ _EndWindow()
;~ exit
For $i=0 to 10*10000

	MouseClick('left',165,246)
;~ 	sleep(150)
	Send('{DOWN}')
	Send('{ENTER}')
;~ 	sleep(100)
	;~ MouseClick('left',165,246)
	;~ sleep(100)

	MouseClick('left',165,258)
;~ 	MouseMove(165,264,0)
	;~ 165,246
	global $passtv, $PIDtv=0,$NotCloseTV=1, $VisibleTV=1, $HandleTVChoise=0
;~ 	_WaitAndGetPassTV()
	$passtv=ControlGetText ( $hwnd, "", "[CLASS:Edit; INSTANCE:3]" )
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $passtv = ' & $passtv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite($passtv & ' ')
	If Mod($i,20)=0 then
		$hwnd = WinActivate('[CLASS:#32770]')
		ConsoleWrite( @CRLF & @HOUR&':'&@MIN&':'&@SEC &" ")
	EndIf
;~ 	sleep(100)
	if $passtv = 1441 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $passtv = ' & $passtv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		msgbox(0,'','')
		exitloop
	EndIf

;~ exitloop
;~ 	if TimerDiff($timerEAPM) > 30*60000 Then
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $timerEAPM = ' & $timerEAPM & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		Run('"C:\Shared\TeamViewerT#new1ogin@mail.ru.exe"')
;~ 		exit
;~ 	EndIf



Next

_EndWindow()


Func _EndWindow()
	$aPosWindow = WinGetPos ( $hwnd )
	WinMove($hwnd,'',@DesktopWidth/2-$aPosWindow[2]/2,@DesktopHeight/2-$aPosWindow[3]/2)
	WinSetState($hWND, "", @SW_MINIMIZE )
EndFunc


Func _WaitAndGetPassTV()
	if $PIDtv<>0 then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $PIDtv = ' & $PIDtv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$arrayHwnds = _WinGetHandleEx($PIDtv, "", "", "", 1)
		for $i=0 to 299
			;закрытие всех лишних окон TeamViewer
			if $NotCloseTV=0 then
				For $i=0 to ubound($arrayHwnds)-1
					Opt("WinTitleMatchMode", 3)
					$t=0
					$tClose=0
					if WinGetTitle($arrayHwnds[$i])<>'TeamViewer' Then
						Opt("WinTitleMatchMode", -1)
						if WinGetTitle($arrayHwnds[$i])<>'Панель TeamViewer' then
							$t = WinClose($arrayHwnds[$i])
							ConsoleWrite('-->>')
							$tClose+=1
						EndIf
					EndIf
				;~ 	if ubound($arrayHwnds)>$tClose then
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & ' : WinGetTitle($arrayHwnds[$i]) = ' & WinGetTitle($arrayHwnds[$i])  & @CRLF ) ;### Debug Console
				;~ 	sleep(1000)
				Next
				Opt("WinTitleMatchMode", -1)
			EndIf

			$arrayHwnds = _WinGetHandleEx($PIDtv, "", "", "", $VisibleTV)
			; алгоритм выбора разных окон TV
			if not @error then
				if ubound($arrayHwnds)>1 Then
	;~ 				switch ubound($arrayHwnds)
	;~ 					case 1
					if $HandleTVChoise=0 then
						$HandleTV=$arrayHwnds[ubound($arrayHwnds)-1]
						$HandleTVChoise=ubound($arrayHwnds)-1
					Else
						$HandleTV=$arrayHwnds[$HandleTVChoise-1]
					EndIf
				Else
					$HandleTV=$arrayHwnds[0]
				EndIf
			Else
				$VisibleTV=0
				$HandleTV='TeamViewer'
				$NotCloseTV=1
			EndIf

			;		  sleep(1000)
			_MinimizeTV($HandleTV)
			;		  sleep(1000)
			$IDtv=ControlGetText ( $HandleTV, "", "[CLASS:Edit; INSTANCE:2]" )
			;		  sleep(1000)
			$passtv=ControlGetText ( $HandleTV, "", "[CLASS:Edit; INSTANCE:3]" )
			;		  sleep(1000)
			if StringRegExp ($passtv,'[0-9]')<>0 then ExitLoop
			if $i>0 and MOD($i,99)=0 then
				ConsoleWrite( ' Продолжаю ожидать окна TeamViewer... '&@CRLF)
				WinActivate("TeamViewer")
				For $i=0 to ubound($arrayHwnds)-1
					WinActivate($arrayHwnds[$i])
				Next
			endif
			sleep(100)
		Next
	Else
		for $i=0 to 299
			WinClose("Компьютеры и контакты")
			WinClose("TeamViewer - ")
			;		  sleep(1000)
			if $PIDtv<>0 then _MinimizeTV("TeamViewer")
			;		  sleep(1000)
			$IDtv=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:2]" )
			;		  sleep(1000)
			$passtv=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:3]" )
			;		  sleep(1000)
			if StringRegExp ($passtv,'[0-9]')<>0 then ExitLoop
			if $i>0 and MOD($i,23)=0 then WinActivate("TeamViewer")
			if $i>0 and MOD($i,49)=0 then
				ConsoleWrite( ' Продолжаю ожидать окна TeamViewer, попытка получить PID... '&@CRLF)
				$PIDtv = ProcessExists("TeamViewer.exe")
				return _WaitAndGetPassTV()
			endif
			sleep(100)
		Next
	EndIf
;~ 	if Ubound($arrayHwnds)>0 Then
;~ 		_MinimizeTV($arrayHwnds)
;~ 	Else
;~ 		_MinimizeTV("TeamViewer")
;~ 	EndIf
EndFunc

Func _MinimizeTV($hWND)
;~ 	if Ubound($hWND)>0 Then
;~ 		For $i=0 to ubound($hWND)-1
;~ 			WinSetState($hWND[$i], "", @SW_MINIMIZE )
;~ 		Next
;~ 	Else
;~ 		WinSetState($hWND, "", @SW_MINIMIZE )
;~ 	EndIf
EndFunc


Func _WinGetHandleEx($iPID, $sClassNN="", $sPartTitle="", $sText="", $iVisibleOnly=1)
    If IsString($iPID) Then $iPID = ProcessExists($iPID)
	Dim $ResultList[1]
    Local $sWList_Str = "[CLASS:" & $sClassNN & ";REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"
    If $sClassNN = "" Then $sWList_Str = "[REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"

    Local $aWList = WinList($sWList_Str, $sText)
    If @error Then Return SetError(1, 0, "")
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aWList[0][0] = ' & $aWList[0][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    For $i = 1 To $aWList[0][0]
        If WinGetProcess($aWList[$i][1]) = $iPID Then
            If Not $iVisibleOnly Or ($iVisibleOnly And BitAND(WinGetState($aWList[$i][1]), 2)) Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($ResultList) = ' & Ubound($ResultList) & ') : WinGetTitle($aWList[$i][1]) = ' & WinGetTitle($aWList[$i][1]) & ') : $aWList[$i][1] = ' & $aWList[$i][1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				if $ResultList[0]>0 then  Redim $ResultList[Ubound($ResultList)+1]
				$ResultList[Ubound($ResultList)-1]=$aWList[$i][1]
;~ 				Return $aWList[$i][1]
			EndIf
        EndIf
    Next
;~ 	_ArrayDisplay($ResultList)
	if not @error and Ubound($ResultList)>0 and $ResultList[0]>0 then Return $ResultList
    Return SetError(2, 0, "")
EndFunc