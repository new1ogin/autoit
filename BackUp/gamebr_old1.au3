#Include <array.au3>
#include <PixelSearchEx.au3>
HotKeySet("^{F7}", "Terminate")

;~ $x1=384
;~ $y1=219
;~ $x2=638
;~ $y2=474
;~ sleep(3000)
;~ MouseMove($x1,$y1)
;~ sleep(1000)
;~ MouseMove($x2,$y2)
;~ sleep(1000)

;~ While 1
;~ $a = PixelSearchEx($x1, $y1, $x2, $y2, 0x619BAE, 50, 222, 1, 0, 50)
;~ if not @error Then exitloop
;~ sleep(50)
;~ WEnd
;~ _ArrayDisplay($a)

sleep(2000)
;~ 388, 225
;~ 634, 473
$x1=388
$y1=225
$x2=634
$y2=473
$timer=TimerInit()
local $aSumm1[12][12]
For $i=0 to 11
	For $j=0 to 11
		$LeftTopx = $x1+($j*(($x2-$x1)/12))
		$LeftTopy = $y1+($i*(($y2-$y1)/12))
		$aSumm1[$i][$j] = PixelChecksum($LeftTopx,$LeftTopy,$LeftTopx+($x2-$x1)/12,$LeftTopy+($y2-$y1)/12)
;~ 		MouseMove($LeftTopx,$LeftTopy)
	Next
Next
ConsoleWrite("старт окончен за " & TimerDiff($timer)/1000 & @CRLF)
;~ _ArrayDisplay($aSumm1)
while 1
	local $aSumm2[12][12]
	For $i=0 to 11
		For $j=0 to 11
			$LeftTopx = $x1+$j*($x1-$x2)/12
			$LeftTopy = $y1+$i*($y1-$y2)/12
			$aSumm2[$i][$j] = PixelChecksum($LeftTopx,$LeftTopy,$LeftTopx+($x1-$x2)/12,$LeftTopy+($y1-$y2)/12)
;~ 			MouseMove($LeftTopx,$LeftTopy)
		Next
	Next

	; сравнение
	$test=0
	For $i=0 to 5
		For $j=0 to 5
			if $aSumm1[$i*2][$j*2]<>$aSumm2[$i*2][$j*2] then
			if $aSumm1[$i*2-1][$j*2]<>$aSumm2[$i*2-1][$j*2] Then
			if $aSumm1[$i*2][$j*2-1]<>$aSumm2[$i*2][$j*2-1] then
			if $aSumm1[$i*2-1][$j*2-1]<>$aSumm2[$i*2-1][$j*2-1] Then
			if $aSumm1[$i*2][$j*2-2]<>$aSumm2[$i*2][$j*2-2] then
			if $aSumm1[$i*2-1][$j*2-2]<>$aSumm2[$i*2-1][$j*2-2] Then
			if $aSumm1[$i*2][$j*2-3]<>$aSumm2[$i*2][$j*2-3] then
			if $aSumm1[$i*2-1][$j*2-3]<>$aSumm2[$i*2-1][$j*2-3] Then
				$aSumm1[$i*2][$j*2]=0
				$aSumm1[$i*2-1][$j*2]=0
				$aSumm1[$i*2][$j*2-1]=0
				$aSumm1[$i*2-1][$j*2-1]=0
				$aSumm1[$i*2][$j*2-2]=0
				$aSumm1[$i*2-1][$j*2-2]=0
				$aSumm1[$i*2][$j*2-3]=0
				$aSumm1[$i*2-1][$j*2-3]=0
				_ArrayDisplay($aSumm1)
				exit
			EndIf
			EndIf
			EndIf
			EndIf
			EndIf
			EndIf
			EndIf
			EndIf
		Next
	Next

	sleep(50)
WEnd








;~ 384, 219
;~ 638, 474   (384, 219, 638, 474
;~ 460, 421
;~ +34 +71
;~ 494, 498
;~ 494, 498
;~ 0x658F96
;~ 0x6397A4
;~ 0x558A96
;~ 0x619BAE
;~ 0x567F86

func Terminate()
	Exit
EndFunc
