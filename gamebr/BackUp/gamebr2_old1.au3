#Include <array.au3>
#include <PixelSearchEx.au3>
#Include <APIConstants.au3>
#Include <GDIPlus.au3>
#Include <WinAPIEx.au3>
#include <ScreenCapture.au3>
HotKeySet("{F7}", "Terminate")
sleep(2000)
;~ $x1=384
;~ $y1=219
;~ $x2=638
;~ $y2=474
;~ sleep(3000)
;~ MouseMove($x1,$y1)
;~ sleep(1000)
;~ MouseMove($x2,$y2)
;~ sleep(1000)
;~ #RequireAdmin
;~ While 1
;~ $a = PixelSearchEx($x1, $y1, $x2, $y2, 0xFFE899, 1, 222, 1, 0, 1)
For $i=1 to 5
	$a = PixelSearchEx(0, 0, @DesktopWidth, @DesktopHeight, 0xFFE899, 1, 222, 1, 0, 1)
	if not @error then ExitLoop
	sleep(500)
Next
Tooltip($a[0] & ' ' & $a[1])
;~ ConsoleWrite($a[0] & ' ' & $a[1] & @CRLF)
;~ if not @error Then exitloop
;~ sleep(50)
;~ WEnd
;~ _ArrayDisplay($a)
$x1=$a[0]-4
$y1=$a[1]+1
$x2=$x1+634-388
$y2=$y1+472-226

local $aPos[6][6]
For $i=0 to 5
	For $j=0 to 5
		$aPos[$i][$j] = Random(1,5,0)
		ConsoleWrite($aPos[$i][$j] & ' ')
	Next
	ConsoleWrite(@CRLF)
Next
_Analyze($aPos)

$MinH = 110
;~ $x1=388
;~ $y1=226
;~ $x2=634
;~ $y2=472
global $C = 41
$W = $x2-$x1
$H = $y2-$y1
MouseMove($x1,$y1)
sleep(1000)
MouseMove($x2,$y2)


for $i=0 to 0
	mousemove($x1-10,$y1-10)
	sleep(777)
$Matrix = _getcolors($x1, $y1, $x2, $y2, $H, $W, $C,$MinH)
;~ _ArrayDisplay($Matrix)
; сравнение
For $i=0 to Ubound($Matrix,1)-1
	For $j=0 to Ubound($Matrix,2)-1
		if $j<>Ubound($Matrix,2)-1 then
		if $Matrix[$i][$j]=1 and $Matrix[$i][$j+1]=1 Then
			_mouseClick($x1 + ($i * $C+($C/2)), $y1+ ($j * $C+($C/2)))
			_mouseClick($x1 + ($i * $C+($C/2)), $y1+ ($j+1 * $C+($C/2)))
		EndIf
		EndIf

		if $i<>Ubound($Matrix,2)-1 then
		if $Matrix[$i][$j]=1 and $Matrix[$i+1][$j]=1 Then
			ConsoleWrite('@@ Debug(' & $i & ' ' & $j & ') :  $Matrix[$i+1][$j] = ' &  $Matrix[$i+1][$j]  & @CRLF) ;### Debug Console
			_mouseClick( $x1+ (($j * $C)+($C/2)),$y1 + (($i * $C)+($C/2)))
			_mouseClick( $x1+ ($j * $C+($C/2)),$y1 + (($i+1) * $C+($C/2)))
		EndIf
		endif

	Next
Next
Next

EXIT

Func _mouseClick($x,$y)
	MouseClick('left',random($x-$c/8,$x+$c/8),random($y-$c/8,$y+$c/8))
	sleep(random(100,1000))
EndFunc

Func _getcolors($x1, $y1, $x2, $y2, $H, $W, $C,$MinH)
	local $Matrix[$H / $C][$W / $C]
	local $HLS[3]
	$hBitmap = _ScreenCapture_Capture("",$x1, $y1, $x2, $y2)
	$hSrcDC = _WinAPI_CreateCompatibleDC(0)
	$hSrcSv = _WinAPI_SelectObject($hSrcDC, $hBitmap)
	$hDstDC = _WinAPI_CreateCompatibleDC(0)
	$hDib = _WinAPI_CreateDIB(1, 1)
	$hDstSv = _WinAPI_SelectObject($hDstDC, $hDib)
	_WinAPI_SetStretchBltMode($hDstDC, $HALFTONE)

	For $y = 0 To $H / $C - 1
		For $x = 0 To $W / $C - 1
;~         _WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C, $y * $C, $C, $C, $SRCCOPY)
        _WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C, $y * $C, 5, 5, $SRCCOPY)
;~ 		_WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C+($C-5), $y * $C+($C-5), 5, 5, $SRCCOPY)
;~         _WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C+10, $y * $C+10, 10, 10, $SRCCOPY) ; определяет камни
        $RGB = _WinAPI_GetPixel($hDstDC, 0, 0)
        _WinAPI_ColorRGBToHLS($RGB, $HLS[0], $HLS[1], $HLS[2])
		if $HLS[0] > $MinH Then
			_WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C+($C-5), $y * $C+($C-5), 5, 5, $SRCCOPY)
			$RGB = _WinAPI_GetPixel($hDstDC, 0, 0)
			_WinAPI_ColorRGBToHLS($RGB, $HLS[0], $HLS[1], $HLS[2])
			if $HLS[0] > $MinH Then
				$Matrix[$y][$x] = 1
			EndIf
		EndIf
		;~         ; Visual representation
        $hDC = _WinAPI_GetDC(0)
        $tRect = _WinAPI_CreateRectEx($x * $C, $y * $C, $C, $C)
        $hBrush = _WinAPI_CreateSolidBrush(_WinAPI_SwitchColor($RGB))
        _WinAPI_FillRect($hDC, DllStructGetPtr($tRect), $hBrush)
        _WinAPI_DeleteObject($hBrush)
        _WinAPI_ReleaseDC(0, $hDC)


		Next
	Next

	_WinAPI_SelectObject($hSrcDC, $hSrcSv)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hSrcDC)
	_WinAPI_SelectObject($hDstDC, $hDstSv)
	_WinAPI_DeleteObject($hDib)
	_WinAPI_DeleteDC($hDstDC)
	return $Matrix
EndFunc

Func _Analyze($aPos)
	local $aPosC[6][6][6]
	; разделение на цвета
	For $i=0 to 5
		For $j=0 to 5
			$aPosC[$i][$j][$aPos[$i][$j]] = 1
		Next
	Next
	;Перебор изменений
	For $c = 1 to 5 ; цвета
		For $i=0 to 5
			For $j=0 to 5
				For $h=0 to 1 ; смена направления изменения
				;Смена по i
				$aPosC[$i][$j][$c]=$t
				$aPosC[$i][$j][$c]=$aPosC[$i+][$j][$c]
				$aPosC[$i+][$j][$c] = $t
			Next
		Next
	Next

	For $i=0 to 5
		For $j=0 to 5

		Next
	Next

EndFunc

func Terminate()
	Exit
EndFunc
