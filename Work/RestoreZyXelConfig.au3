global $SleepCorr=1

HotKeySet("{Esc}", "Terminate")
Func Terminate()
	 TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep($SleepCorr*1000)
	Exit 0
EndFunc   ;==>Terminate

			Opt("WinTitleMatchMode", 3)
			Opt("SendKeyDelay", 64)          ;5 миллисекунд
			Opt("SendKeyDownDelay", 10)      ;1 миллисекунда
			Opt("MouseCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские

;~ $timeoutmsgbox = 300
;~ $msgbox = msgbox(3," Предупреждение "," Внимание! Сейчас настройки межсетевого экрана ZyXel будут восстановлены, нажмите Отмена для отмены ", $timeoutmsgbox)
;~ exit
While 1
$timeoutmsgbox = 120
$msgbox = msgbox(3," Предупреждение "," Внимание! Сейчас настройки межсетевого экрана ZyXel будут восстановлены, нажмите Нет для пропуска восстановления ", $timeoutmsgbox)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $msgbox = ' & $msgbox & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

if $msgbox <> 2 and $msgbox <> 7 then
	_SetConfig()
Else
	if $msgbox = 7 then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $msgbox = ' & $msgbox & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		; продолжить выполнение
	Else
		Terminate()
	EndIf

EndIf

Sleep(2*60000)
wend
#region ---Au3Recorder generated code Start (v3.3.7.0)  ---

#region --- Internal functions Au3Recorder Start ---
Func _Au3RecordSetup()
Opt('WinWaitDelay',100)
Opt('WinDetectHiddenText',1)
Opt('MouseCoordMode',0)
EndFunc

Func _WinWaitActivate($title,$text,$timeout=0)
	WinWait($title,$text,$timeout)
	If Not WinActive($title,$text) Then WinActivate($title,$text)
	WinWaitActive($title,$text,$timeout)
EndFunc

Func _SetConfig()
_AU3RecordSetup()
#endregion --- Internal functions Au3Recorder End ---
$SleepCorr=2
$ycor=48
$FrimwareUpdeteCor=48
$BrowserPid = Run('"C:\Program Files\Google\Chrome\Application\chrome.exe" http://192.168.1.1/rpSys.html')
$hWnd = _WinGetHandleEx($BrowserPid, "", "", "", 0)
Sleep($SleepCorr*5000)
WinSetState($hWnd, "", @SW_MAXIMIZE)
Sleep($SleepCorr*1000)
_WinWaitActivate("192.168.1.1 - ZyXEL ZyWALL 35 Internet Security Appliance - Google Chrome","192.168.1.1 - ZyXEL ")
Send("admin{ENTER}")
Sleep($SleepCorr*3000)
MouseClick("left",54,342-$ycor+$FrimwareUpdeteCor,1)
Sleep($SleepCorr*1000)
MouseClick("left",680,216-$ycor,1)
Sleep($SleepCorr*1000)
MouseClick("left",340,401-$ycor,1)
Sleep($SleepCorr*1000)
_WinWaitActivate("Открыть","")
Sleep($SleepCorr*1000)
Send("C:\workconfigzyxel{ENTER}")
Sleep($SleepCorr*1000)
_WinWaitActivate("192.168.1.1 - ZyXEL ZyWALL 35 Internet Security Appliance - Google Chrome","192.168.1.1 - ZyXEL ")
Sleep($SleepCorr*1000)
MouseClick("left",482,432-$ycor,1)
MouseClick("left",482+100,432-$ycor,1)
Sleep($SleepCorr*10000)
WinClose($hWnd)
Endfunc
#endregion --- Au3Recorder generated code End ---



Func _WinGetHandleEx($iPID, $sClassNN="", $sPartTitle="", $sText="", $iVisibleOnly=1)
    If IsString($iPID) Then $iPID = ProcessExists($iPID)

    Local $sWList_Str = "[CLASS:" & $sClassNN & ";REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"
    If $sClassNN = "" Then $sWList_Str = "[REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"

    Local $aWList = WinList($sWList_Str, $sText)
    If @error Then Return SetError(1, 0, "")

    For $i = 1 To $aWList[0][0]
        If WinGetProcess($aWList[$i][1]) = $iPID Then
            If Not $iVisibleOnly Or ($iVisibleOnly And BitAND(WinGetState($aWList[$i][1]), 2)) Then Return $aWList[$i][1]
        EndIf
    Next

    Return SetError(2, 0, "")
EndFunc
