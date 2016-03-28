#include <Misc.au3>
$newBuffer = ClipGet()
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($newBuffer) = ' & StringLen($newBuffer)  & @CRLF) ;### Debug Console
	$newBuffer = StringLeft($newBuffer,StringInStr($newBuffer,'end.'&@CRLF,0,-1)+5)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringInStr($newBuffer,''end.''&@CRLF,0,-1)+5 = ' & StringInStr($newBuffer,'end.'&@CRLF,0,-1)+5  & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringInStr($newBuffer,''end.'',0,-1) = ' & StringInStr($newBuffer,'end.',0,-1)  & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringInStr($newBuffer,''end.'',0,1) = ' & StringInStr($newBuffer,'end.',0,1)  & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $newBuffer = ' & $newBuffer  & @CRLF) ;### Debug Console
HotKeySet('{ESC}', '_Exit')
HotKeySet('{f2}', '_go')
HotKeySet('{PAUSE}"', '_go')
HotKeySet('{lwin}', '_go')

While 1
    sleep(100)
	if _IsPressed(04) then _GO()
	if _IsPressed(02) then _GO()
WEnd

#include <Array.au3>
sleep(2000)
Send('{END}')
While 1
	Send('^{Down}')
	sleep(10)
	Send('{UP}')
	Send('{UP}')
	sleep(10)
WEnd



exit


ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($newBuffer) = ' & StringLen($newBuffer)  & @CRLF) ;### Debug Console

fUNC _GO()
ConsoleWrite('nul')
Send('{APPSKEY}')
Send('{DOWN}')
Send('{DOWN}')
Send('{DOWN}')
Send('{ENTER}')
EndFunc

fUNC _GO2()
ConsoleWrite('nul')
Send('+{ESC}')
Send('{DOWN}')

EndFunc

#include <WinAPIEx.au3>

Global $PID = 0, $Prev1 = 0, $Prev2 = 0

While 1
    ConsoleWrite(_CPU('palemoon.exe') & @CRLF)
    sleep(1000)
WEnd

Func _CPU($sProcess)
    Local $ID, $Time1, $Time2, $CPU
    $ID = ProcessExists($sProcess)
    If $ID Then
        $Time1 = _WinAPI_GetProcessTimes($ID)
        $Time2 = _WinAPI_GetSystemTimes()
        If(IsArray($Time1)) And(IsArray($Time2)) Then
            $Time1 = $Time1[1] + $Time1[2]
            $Time2 = $Time2[1] + $Time2[2]
            If($Prev1) And($Prev2) And($PID = $ID) Then
                $CPU = Round(($Time1 - $Prev1) / ($Time2 - $Prev2) * 100)
            EndIf
            $Prev1 = $Time1
            $Prev2 = $Time2
            $PID = $ID
            Return $CPU
        EndIf
    EndIf
    $Prev1 = 0
    $Prev2 = 0
    $PID = 0
EndFunc   ;==>_CPU

func _exit()
	Exit
EndFunc