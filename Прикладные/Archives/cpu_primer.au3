#include <WinAPIEx.au3>
#include <array.au3>

Global $PID = 0, $Prev1 = 0, $Prev2 = 0, $CPU, $memr

While 1
	_CPU(3324)
    ConsoleWrite($CPU & @CRLF)
	ConsoleWrite($memr & @CRLF)
    sleep(1000)
WEnd

Func _CPU($sProcess)
    Local $ID, $Time1, $Time2, $mem
    $ID = ProcessExists($sProcess)
    If $ID Then
        $Time1 = _WinAPI_GetProcessTimes($ID)
        $Time2 = _WinAPI_GetSystemTimes()
        If(IsArray($Time1)) And(IsArray($Time2)) Then
            $Time1 = $Time1[1] + $Time1[2]
            $Time2 = $Time2[1] + $Time2[2]
            If($Prev1) And($Prev2) And($PID = $ID) Then
                $CPU = Round(($Time1 - $Prev1) / ($Time2 - $Prev2) * 100,2)
            EndIf
            $Prev1 = $Time1
            $Prev2 = $Time2
            $PID = $ID
			$mem = _WinAPI_GetProcessMemoryInfo($ID)
;~ 			_ArrayDisplay($mem)
			$memr = Round($Mem[9] / 1024) + Round($Mem[2] / 1024) ; память неразделяемый байт + рабочий набор

            Return 1
        EndIf
    EndIf
    $Prev1 = 0
    $Prev2 = 0
    $PID = 0
EndFunc   ;==>_CPU



