#include <WinAPI.au3>

Global $nBytes,$n=76
Global $file = @ScriptDir & '\screenShotsPB\color'&$n&'.bmp'

$X1 = ((1024/2)+4)-40
$X2 = ((1024/2)+4)+20
$Y1 = 24+0
$Y2 = ((768/2)+24)-1; Coordinates of upper left and bottom right vertices of recatangle to scan
ConsoleWrite($X1& $X2& $Y1& $Y2)
Sleep(1000)
For $i=0 To 100
	Global $n=$i
	Global $file = @ScriptDir & '\screenShotsPB\color'&$n&'.bmp'
	ConsoleWrite(' Цикл: '&$n)
_Header($X1, $X2, $Y1, $Y2)
_BMPFiller($X1, $X2, $Y1, $Y2)
Next


Func _BMPFiller($X1, $X2, $Y1, $Y2)
    $tBuffer = DllStructCreate("byte[" & 3 & "]")
    $hFile = _WinAPI_CreateFile($file, 3)
    _WinAPI_SetFilePointer($hFile, 0, 2)
    For $j = $Y2 to $Y1 Step -1
        For $i = $X1 to $X2
            $data = Binary(PixelGetColor($i, $j))
            DllStructSetData($tBuffer, 1, $data)
            _WinAPI_WriteFile($hFile, DllStructGetPtr($tBuffer), 3, $nBytes)
        Next
        If Mod($w, 4) > 0 Then
            $tmp_buf = DllStructCreate("byte[" & Mod($w, 4) & "]")
            $zero = Binary(0)
            DllStructSetData($tmp_buf, 1, $zero)
            _WinAPI_WriteFile($hFile, DllStructGetPtr($tmp_buf), Mod($w, 4), $nBytes)
        EndIf
    Next
EndFunc

Func _Header($X1, $X2, $Y1, $Y2)
    Global $w = $X2 - $X1 + 1
    Global $h = $Y2 - $Y1 + 1
    $hWrite = FileOpen($file, 16 + 2)
    FileWrite($hWrite, 'BM'); 2 bytes - 1-2
    $imsize = ($w * 3 + Mod($w, 4)) * $h
    $size = $imsize + 54
    FileWrite($hWrite, Dec(Hex($size)));        4 bytes - 3-6
    FileWrite($hWrite, 0x0);                    2x2 bytes - 7-10
    FileWrite($hWrite, 0x36);                   4 bytes - 11-14
    FileWrite($hWrite, 40);                     4 bytes - 15-18
    FileWrite($hWrite, Int($w));                4 bytes - 19-22
    FileWrite($hWrite, Int($h));                4 bytes - 23-26
    FileWrite($hWrite, Int(1572865));           2x2 bytes; 2bytes - 1, 2 bytes-24; 27-30
    FileWrite($hWrite, Int(0));                 4 bytes - 31-34
    FileWrite($hWrite, Dec(Hex($imsize)));          4 bytes - 35-38
    FileWrite($hWrite, 3780);                   4 bytes - 39-42
    FileWrite($hWrite, 3780);                   4 bytes - 43-46
    FileWrite($hWrite, Int(0));                 #########; 4 bytes of zeros - 47-50
    FileWrite($hWrite, Int(0));                 #########; 4 bytes of zeros - 50-54
    FileClose($hWrite)
EndFunc




;Попиксельная запись изображения в файл
Func _pixel_inFile()

	$X1 = $pricelx-4
	$X2 = $pricelx+2
	$Y1 = 70+$ycor
	$Y2 = $pricely-1; Coordinates of upper left and bottom right vertices of recatangle to scan

	Sleep(5000)
	For $i=0 To 100
		Global $n=$i
		Global $file = @ScriptDir & '\screenShotsPB\color'&$n&'.bmp'
		ConsoleWrite(' Цикл: '&$n)
	_Header($X1, $X2, $Y1, $Y2)
	_BMPFiller($X1, $X2, $Y1, $Y2)
	Next
endfunc
