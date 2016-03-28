#Include <WinAPIEx.au3>
Global $hListView, $PID = 0, $Prev1 = 0, $Prev2 = 0
;~ Global Const $sProcess = 'WorldOfTanks.exe'
;~ $PID = ProcessExists($sProcess)

;~ While 1
;~ 					$Mem = _WinAPI_GetProcessMemoryInfo($PID)
;~ 					$memory=_KB(Round($Mem[9] / 1024))
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $memory = ' & $memory & @CRLF) ;### Debug Console
;~ 					sleep(500)
;~ wend


;~ Func _KB($iSize)
;~     If StringLen($iSize) > 3 Then
;~         Return StringTrimRight($iSize, 3)  & ',' & StringLeft($iSize, 3) ; & ' K'
;~     EndIf
;~ EndFunc   ;==>_KB
;~ local $timerLoading=
;~ if $timerLoading<0 Then ConsoleWrite('@@ Debug(')
;~ 	ConsoleWrite(TimerDiff($timerLoading))

Opt("SendKeyDelay", 100)          ;5 миллисекунд
Opt("SendKeyDownDelay", 64)      ;1 миллисекунда
Opt("WinTitleMatchMode", -4)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
$Title = WinGetTitle ( "b777" ) ;часть имени окна
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Title = ' & $Title & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$hwnd=WinGetHandle($Title)
WinActivate($hwnd)
;~ send("root{Enter}")
;~ send("administrator{Enter}")
;~ send("admin{Enter}")
;~ send("user{Enter}")
sleep(500)
send("yjds1_")
sleep(500)
send("gfh0km")
sleep(500)
send("{Enter}")



ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : send("{Enter}") = ' & send("{Enter}") & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

