#Include <WinAPIEx.au3>

Global $Time1 = 0, $Time2 = 0

GUICreate('MyGUI', 400, 400)
GUICtrlCreateLabel('CPU usage:', 20, 20, 58, 14)
$Label = GUICtrlCreateLabel('0%', 80, 20, 40, 14)
GUISetState()

AdlibRegister('_CPU', 1000)

Do
Until GUIGetMsg() = -3

Func _CPU()

    Local $Time2 = _WinAPI_GetSystemTimes()

    If IsArray($Time1) Then
        $TimeBusyCPU = ($Time2[1] + $Time2[2]) - ($Time1[1] + $Time1[2])
        $TimeIdleCPU = ($Time2[0] - $Time1[0])
        GUICtrlSetData($Label, StringFormat('%.f%', ($TimeBusyCPU - $TimeIdleCPU) / $TimeBusyCPU * 100))
    EndIf
    $Time1 = $Time2
EndFunc   ;==>_CPU
