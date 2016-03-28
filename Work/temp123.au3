#include <Date.au3>

HotKeySet("{ESC}", "_Quit")

$IdleMinimum = 50 ; ���������� ������ ������������ � �������������

While 1
    $iIdle = _IdleWaitStart($IdleMinimum)
    ConsoleWrite(_NowTime(5)&_Now() & ' ' & @UserName & ' ��������� ��� ' & _TickToTimeString($iIdle) & @CRLF)
    $iIdle = _IdleWaitCommit($IdleMinimum)
    ConsoleWrite(_NowTime(5)&_Now() & ' ' & @UserName & ' ��� ��������� ' & _TickToTimeString($iIdle) & @CRLF)
	sleep(1000)
WEnd

; �������� ������ ����������� ������������.
; ���������� ����� ������������ (� �����)
; $idlesec - ����������� ������������ ��������� ������������ (� �����)
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

; �������� ��������� ����������� ������������.
; ���������� ����� ������������ � (�����)
; $idlesec - ����������� ������������ ��������� ������������ � (�����)
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

    If $iHours Then $sText = $iHours & ' ����� '
    If $iMins Then $sText &= $iMins & ' ����� '
    If $iSecs Then $sText &= $iSecs & ' ������'
    If $sText = '' Then $sText = '������ �������'

    Return $sText
EndFunc   ;==>_TickToTimeString

Func _Quit()
    Exit
EndFunc   ;==>_Quit
