#Include <WinAPIEx.au3>
Global $hListView, $PID = 0, $Prev1 = 0, $Prev2 = 0
Global Const $sProcess = 'WorldOfTanks.exe'

	$ID = ProcessExists($sProcess)
	$Time1 = _WinAPI_GetProcessTimes($ID)
	$Time2 = _WinAPI_GetSystemTimes()
	$Prev1 = $Time1[1] + $Time1[2]
	$Prev2 = $Time2[1] + $Time2[2]
while 1
	Dim $CPUarray[1], $memoryarray[1]
	For $i=0 to 6
		$ID = ProcessExists($sProcess)

		Local $ID, $Mem, $Time1, $Time2
			$Time1 = _WinAPI_GetProcessTimes($ID)
			$Time2 = _WinAPI_GetSystemTimes()
			If (IsArray($Time1)) And (IsArray($Time2)) Then
				$Time1 = $Time1[1] + $Time1[2]
				$Time2 = $Time2[1] + $Time2[2]
					$Mem = _WinAPI_GetProcessMemoryInfo($PID)
					$CPU=Round(($Time1 - $Prev1) / ($Time2 - $Prev2) * 100)
					$memory=_KB(Round($Mem[9] / 1024))
;~ 					ConsoleWrite($CPU &'  '&$memory & @CRLF)
					Redim $CPUarray[$i+1], $memoryarray[$i+1]
					$CPUarray[$i]=$CPU
					;$memoryarray[$i]=$memory
				$Prev1 = $Time1
				$Prev2 = $Time2
				$PID = $ID

			EndIf
			sleep(300)

	next
;~ 	_arraydisplay($CPUarray)
	;Расчет средних значений
	$Uboundarray=UBound($CPUarray)-1
	local $CPUarraySumm=0;, $memoryarraySumm=0
	For $i=0 to $Uboundarray
		$CPUarraySumm+=$CPUarray[$i]
		;$memoryarraySumm+=$memoryarray[$i]
	Next
	$CPUarrayAver=$CPUarraySumm/$Uboundarray
	$memoryarrayAver=$memory;-$memory+$memoryarraySumm/$Uboundarray
	ConsoleWrite($CPUarrayAver &'|'&$memoryarrayAver  & @CRLF)

wend

Func _KB($iSize)
    If StringLen($iSize) > 3 Then
        Return StringTrimRight($iSize, 3)  & ',' & StringLeft($iSize, 3) ; & ' K'
    EndIf
EndFunc   ;==>_KB