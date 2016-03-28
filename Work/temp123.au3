#include <Date.au3>

HotKeySet("{ESC}", "_Quit")

$IdleMinimum = 50 ; допустимый период неактивности в миллисекундах

While 1
    $iIdle = _IdleWaitStart($IdleMinimum)
    ConsoleWrite(_NowTime(5)&_Now() & ' ' & @UserName & ' неактивен уже ' & _TickToTimeString($iIdle) & @CRLF)
    $iIdle = _IdleWaitCommit($IdleMinimum)
    ConsoleWrite(_NowTime(5)&_Now() & ' ' & @UserName & ' был неактивен ' & _TickToTimeString($iIdle) & @CRLF)
	sleep(1000)
WEnd

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

    If $iHours Then $sText = $iHours & ' часов '
    If $iMins Then $sText &= $iMins & ' минут '
    If $iSecs Then $sText &= $iSecs & ' секунд'
    If $sText = '' Then $sText = 'меньше секунды'

    Return $sText
EndFunc   ;==>_TickToTimeString

Func _Quit()
    Exit
EndFunc   ;==>_Quit
