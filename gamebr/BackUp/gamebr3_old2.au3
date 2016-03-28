#include <array.au3>
#include <PixelSearchEx.au3>
#include <APIConstants.au3>
#include <GDIPlus.au3>
#include <WinAPIEx.au3>
#include <ScreenCapture.au3>
#include <Color.au3>
Global $aColorGems[5][3] = [[87, 74, 54], [214, 196, 148], [99, 172, 57], [192, 153, 24], [124, 57, 66]] ; крест, череп, зел, жел, крас
global $aActivDetect[2][3] = [[76, 55, 14], [90, 66, 18]] ; темный, светлый
Global $x1, $y1, $Cstart, $Wstart, $Hstart
HotKeySet("{F7}", "Terminate")
HotKeySet("{F8}", "_DetectAndClick")
$x1 = 0
$y1 = 0
$x2 = 0
$y2 = 0

_FindCoords() = 1 then _autoGame()
;~ 4C370E
;~ 5A4212

While 1
	Sleep(100)
WEnd

Func _autoGame()
	For $i=0 to 30
		_DetectAndClick()
		sleep(10000)
	Next
EndFunc

;~ $aPos = _CreatArray()
;~ $timer = TimerInit()
;~ $aRightChange = _Analyze($aPos)
;~ $aRightChange = _CalculateResult($aRightChange)
;~ ConsoleWrite('@@ Debug(' & UBound($aRightChange) & ') : $iRgtCng = ' & $aRightChange & @CRLF) ;### Debug Console
;~ ConsoleWrite("TimerDiff=" & TimerDiff($timer) & @CRLF)
;~ _ArraySort($aRightChange, 1, 0, 0, 4)
;~ _ArrayDisplay($aRightChange)
;~ Exit

;~ $x1=388
;~ $y1=226
;~ $x2=634
;~ $y2=472

;~ MouseMove($x1, $y1)
;~ Sleep(1000)
;~ MouseMove($x2, $y2)

;~ _ArrayDisplay($aRightChange)
Exit

Func _FindCoords()
	For $i = 1 To 10
		$a = PixelSearchEx(0, 0, @DesktopWidth, @DesktopHeight, 0xFFE899, 1, 222, 1, 0, 1)
		If Not @error Then ExitLoop
		If $i = 10 Then return
		Sleep(500)
	Next
;~ 	ToolTip($a[0] & ' ' & $a[1])
	$x1 = $a[0] - 4
	$y1 = $a[1] + 1
	$x2 = $x1 + 634 - 388
	$y2 = $y1 + 472 - 226
	$MinH = 110
	$Cstart = 41
	$Wstart = $x2 - $x1
	$Hstart = $y2 - $y1
	return 1
EndFunc   ;==>_FindCoords

Func _DetectAndClick()
	_FindCoords()
	$aPos = _GetArrayLocation($x1, $y1, $x2, $y2, $Hstart, $Wstart, $Cstart)
;~ 	;вывод в консоль
	For $i = 0 To 5
		For $j = 0 To 5
			ConsoleWrite($aPos[$i][$j] & ' ')
		Next
		ConsoleWrite(@CRLF)
	Next
	$timer =TimerInit()
	$aRightChange = _Analyze($aPos)
	$timer2 =TimerDiff($timer)
;~ 	$aRightChange = _CalculateResult($aRightChange)
	ConsoleWrite("время расчета = " & Round(TimerDiff($timer),2) & ' из них обработка результата = '&Round($timer2,2) &@CrLF)
	_ArraySort($aRightChange, 1, 0, 0, 4)
;~ 	For $ac=0 to UBound($aRightChange)-1
;~ 		For $bc=0 to UBound($aRightChange,2)-1
;~ 			ConsoleWrite($aRightChange[$ac][$bc] & ' ')
;~ 		Next
;~ 		ConsoleWrite(@CRLF)
;~ 	Next

	_ClickChoise($aRightChange[0][0], $aRightChange[0][1], $aRightChange[0][2])
EndFunc   ;==>_DetectAndClick

Func _ClickChoise($i, $j, $h)
	;Клик на выбор карты -146 353
	if $x1 > 0 and $y1 > 0 then
		_mouseClick($x1 - 146, $y1 + 353+5)
;~ 		Sleep(Random(2000, 3000))
	EndIf
	;Клики на выор камней
	_mouseClick($x1 + ($j * $Cstart + ($Cstart / 2)), $y1 + ($i * $Cstart + ($Cstart / 2)))
	If $h = 0 Then
		_mouseClick($x1 + ($j * $Cstart + ($Cstart / 2)), $y1 + (($i + 1) * $Cstart + ($Cstart / 2)))
	Else
		_mouseClick($x1 + (($j + 1) * $Cstart + ($Cstart / 2)), $y1 + ($i * $Cstart + ($Cstart / 2)))
	EndIf
	Sleep(Random(100, 1000))
	; перемещение мышки в безопасное место
	MouseMove($x1 - 10, $y1 - 20)
EndFunc   ;==>_ClickChoise

Func _mouseClick($x, $y)
	MouseClick('left', Random($x - $Cstart / 8, $x + $Cstart / 8), Random($y - $Cstart / 8, $y + $Cstart / 8))
	Sleep(Random(100, 1000))
EndFunc   ;==>_mouseClick

Func _GetArrayLocation($x1, $y1, $x2, $y2, $h, $W, $C)
	Local $Matrix[$h / $C][$W / $C]
	Local $HLS[3]
	$hBitmap = _ScreenCapture_Capture("", $x1, $y1, $x2, $y2)
	$hSrcDC = _WinAPI_CreateCompatibleDC(0)
	$hSrcSv = _WinAPI_SelectObject($hSrcDC, $hBitmap)
	$hDstDC = _WinAPI_CreateCompatibleDC(0)
	$hDib = _WinAPI_CreateDIB(1, 1)
	$hDstSv = _WinAPI_SelectObject($hDstDC, $hDib)
	_WinAPI_SetStretchBltMode($hDstDC, $HALFTONE)

	For $y = 0 To $h / $C - 1
		For $x = 0 To $W / $C - 1
			_WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C + 10, $y * $C + 10, 10, 10, $SRCCOPY) ; определяет камни
			$RGB = _WinAPI_GetPixel($hDstDC, 0, 0)
			$aColors = _ColorGetRGB($RGB)
			$Matrix[$y][$x] = _CompareColor($aColors, $aColorGems)
;~         ; Visual representation
;~ 			$hDC = _WinAPI_GetDC(0)
;~ 			$tRect = _WinAPI_CreateRectEx($x * $C, $y * $C, $C, $C)
;~ 			$hBrush = _WinAPI_CreateSolidBrush(_WinAPI_SwitchColor($RGB))
;~ 			_WinAPI_FillRect($hDC, DllStructGetPtr($tRect), $hBrush)
;~ 			_WinAPI_DeleteObject($hBrush)
;~ 			_WinAPI_ReleaseDC(0, $hDC)
		Next
	Next

	_WinAPI_SelectObject($hSrcDC, $hSrcSv)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hSrcDC)
	_WinAPI_SelectObject($hDstDC, $hDstSv)
	_WinAPI_DeleteObject($hDib)
	_WinAPI_DeleteDC($hDstDC)
	Return $Matrix
EndFunc   ;==>_GetArrayLocation

Func _CompareColor($aColors, $aData)
	Local $aCompare[UBound($aData)]
	For $col = 0 To UBound($aData)-1
		For $nc = 0 To 2
			$aCompare[$col] += Abs($aColors[$nc] - $aData[$col][$nc])
		Next
	Next
	Return _ArrayMinIndex($aCompare)+1
EndFunc   ;==>_CompareColor

Func _getcolors($x1, $y1, $x2, $y2, $h, $W, $C, $MinH)
	Local $Matrix[$h / $C][$W / $C]
	Local $HLS[3]
	$hBitmap = _ScreenCapture_Capture("", $x1, $y1, $x2, $y2)
	$hSrcDC = _WinAPI_CreateCompatibleDC(0)
	$hSrcSv = _WinAPI_SelectObject($hSrcDC, $hBitmap)
	$hDstDC = _WinAPI_CreateCompatibleDC(0)
	$hDib = _WinAPI_CreateDIB(1, 1)
	$hDstSv = _WinAPI_SelectObject($hDstDC, $hDib)
	_WinAPI_SetStretchBltMode($hDstDC, $HALFTONE)

	For $y = 0 To $h / $C - 1
		For $x = 0 To $W / $C - 1
;~         _WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C, $y * $C, $C, $C, $SRCCOPY)
			_WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C, $y * $C, 5, 5, $SRCCOPY)
;~ 		_WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C+($C-5), $y * $C+($C-5), 5, 5, $SRCCOPY)
;~         _WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C+10, $y * $C+10, 10, 10, $SRCCOPY) ; определяет камни
			$RGB = _WinAPI_GetPixel($hDstDC, 0, 0)
			_WinAPI_ColorRGBToHLS($RGB, $HLS[0], $HLS[1], $HLS[2])
			If $HLS[0] > $MinH Then
				_WinAPI_StretchBlt($hDstDC, 0, 0, 1, 1, $hSrcDC, $x * $C + ($C - 5), $y * $C + ($C - 5), 5, 5, $SRCCOPY)
				$RGB = _WinAPI_GetPixel($hDstDC, 0, 0)
				_WinAPI_ColorRGBToHLS($RGB, $HLS[0], $HLS[1], $HLS[2])
				If $HLS[0] > $MinH Then
					$Matrix[$y][$x] = 1
				EndIf
			EndIf
;~         ; Visual representation
;~ 			$hDC = _WinAPI_GetDC(0)
;~ 			$tRect = _WinAPI_CreateRectEx($x * $C, $y * $C, $C, $C)
;~ 			$hBrush = _WinAPI_CreateSolidBrush(_WinAPI_SwitchColor($RGB))
;~ 			_WinAPI_FillRect($hDC, DllStructGetPtr($tRect), $hBrush)
;~ 			_WinAPI_DeleteObject($hBrush)
;~ 			_WinAPI_ReleaseDC(0, $hDC)
		Next
	Next
	_WinAPI_SelectObject($hSrcDC, $hSrcSv)
	_WinAPI_DeleteObject($hBitmap)
	_WinAPI_DeleteDC($hSrcDC)
	_WinAPI_SelectObject($hDstDC, $hDstSv)
	_WinAPI_DeleteObject($hDib)
	_WinAPI_DeleteDC($hDstDC)
	Return $Matrix
EndFunc   ;==>_getcolors

Func _Analyze($aPos)
	Local $aPosC[6][6][6]
	Local $aRightChange[1000][7], $iRgtCng = 0
	Local $t
	; разделение на цвета
	For $i = 0 To 5
		For $j = 0 To 5
			$aPosC[$i][$j][$aPos[$i][$j]] = 1
		Next
	Next
	ConsoleWrite('Перебор изменений'&@CRLF)
	;Перебор изменений
	For $C = 1 To 5 ; цвета
;~ 		For $i = 0 To 5
;~ 			For $j = 0 To 5
;~ 				if $aPosC[$i][$j][$C] = 1 Then
;~ 					ConsoleWrite($aPosC[$i][$j][$C] & ' ')
;~ 				Else
;~ 					ConsoleWrite(0 & ' ')
;~ 				EndIf
;~ 			Next
;~ 			ConsoleWrite(@CRLF)
;~ 		Next
		For $i = 0 To 5
			For $j = 0 To 5
				For $h = 0 To 1 ; смена направления изменения
					$aPosC2 = $aPosC
					If $h = 0 And $i < 5 Then
						;Смена по i
						$t = $aPosC2[$i][$j][$C]
						$aPosC2[$i][$j][$C] = $aPosC2[$i + 1][$j][$C]
						$aPosC2[$i + 1][$j][$C] = $t
					EndIf
					If $h = 1 And $j < 5 Then
						;Смена по j
						$t = $aPosC2[$i][$j][$C]
						$aPosC2[$i][$j][$C] = $aPosC2[$i][$j + 1][$C]
						$aPosC2[$i][$j + 1][$C] = $t
					EndIf
					If $h = 0 And $i = 5 Then ContinueLoop
					If $h = 1 And $j = 5 Then ContinueLoop
					if $C=2 and $i=3 and $j=3 and $h=1 Then ; костыль
;~ 						ConsoleWrite("костыль"&@CRLF)
;~ 						For $i3 = 0 To 5
;~ 							For $j3 = 0 To 5
;~ 								if $aPosC[$i3][$j3][$C] = 1 Then
;~ 									ConsoleWrite($aPosC[$i3][$j3][$C] & ' ')
;~ 								Else
;~ 									ConsoleWrite(0 & ' ')
;~ 								EndIf
;~ 							Next
;~ 							ConsoleWrite(@CRLF)
;~ 						Next
					EndIf

					;Поиск соответствий
					For $i2 = 0 To 5
						For $j2 = 0 To 5
							$qs = ''
							;условия совпадения ячеек для двух разворотов "три в ряд"
							If $i2 < 4 And $aPosC2[$i2][$j2][$C] = 1 And $aPosC2[$i2 + 1][$j2][$C] = 1 And $aPosC2[$i2 + 2][$j2][$C] = 1 Then
								$q = 3
;~ 									ConsoleWrite('--пред(' & $i & ')(' & $j & ')(' & $H & ')($i2=' & $i2 & ')($j2=' & $j2 & ')(' & $qs & '): по i ' & '' & @CRLF) ;### Debug Console
								If $i2 > 0 And $aPosC2[$i2 - 1][$j2][$C] = 1 Then $q += 1
								If $i2 > 1 And $aPosC2[$i2 - 2][$j2][$C] = 1 Then $q += 1
								If $i2 < 3 And $aPosC2[$i2 + 3][$j2][$C] = 1 Then $q += 1
								If $i2 < 2 and $aPosC2[$i2 + 4][$j2][$C] = 1 Then $q += 1
								$qs &= "+" & $q
								;проверка не была ли часть этого совпадения уже найдена
								$AlreadyFind = _CompareWithArray($aRightChange, $i, $j, $h, -1, -1, $C, 0)
								If not @error and $AlreadyFind > 0 Then
									ConsoleWrite('$aRightChange = ')
									For $bc=0 to UBound($aRightChange,2)-1
										ConsoleWrite($aRightChange[$AlreadyFind][$bc] & ' ')
									Next
									ConsoleWrite(@CRLF)
									if $aRightChange[$AlreadyFind][4] < Execute($qs) then
										$aRightChange[$AlreadyFind][4] = Execute($qs)
										$aRightChange[$AlreadyFind][3] = $qs
									EndIf
									$qs = ''
								EndIf
;~ 								ConsoleWrite('(' & $i & ')(' & $j & ')(' & $H & ')($i2=' & $i2 & ')($j2=' & $j2 & ')(' & $qs & '): по i ' & '' & @CRLF) ;### Debug Console
							EndIf
							If StringLen($qs) > 1 Then $iRgtCng += _WriteToRightChange($aRightChange, $i, $j, $h, $qs, $iRgtCng, $C, 0)
							$qs = ''
							If $j2 < 4 And $aPosC2[$i2][$j2][$C] = 1 And $aPosC2[$i2][$j2 + 1][$C] = 1 And $aPosC2[$i2][$j2 + 2][$C] = 1 Then
								$q = 3
								If $j2 > 0 And $aPosC2[$i2][$j2 - 1][$C] = 1 Then $q += 1
								If $j2 > 1 And $aPosC2[$i2][$j2 - 2][$C] = 1 Then $q += 1
								If $j2 < 2 And $aPosC2[$i2][$j2 + 4][$C] = 1 Then $q += 1
								If $j2 < 3 And $aPosC2[$i2][$j2 + 3][$C] = 1 Then $q += 1
								$qs &= "+" & $q
								;проверка не была ли часть этого совпадения уже найдена
								$AlreadyFind = _CompareWithArray($aRightChange, $i, $j, $h, -1, -1, $C, 1)
								If not @error and $AlreadyFind > 0 Then
									ConsoleWrite('$aRightChange = ')
									For $bc=0 to UBound($aRightChange,2)-1
										ConsoleWrite($aRightChange[$AlreadyFind][$bc] & ' ')
									Next
									ConsoleWrite(@CRLF)
									if $aRightChange[$AlreadyFind][4] < Execute($qs) then
										$aRightChange[$AlreadyFind][4] = Execute($qs)
										$aRightChange[$AlreadyFind][3] = $qs
									EndIf
									$qs = ''
								EndIf
;~ 								ConsoleWrite('(' & $i & ')(' & $j & ')(' & $H & ')($i2=' & $i2 & ')($j2=' & $j2 & ')(' & $qs & '): по j ' & '' & @CRLF) ;### Debug Console
							EndIf
							If StringLen($qs) > 1 Then $iRgtCng += _WriteToRightChange($aRightChange, $i, $j, $h, $qs, $iRgtCng, $C, 1)

						Next
					Next
				Next
			Next
		Next
	Next

	$aRightChange = _ArrayClearEmpty($aRightChange) ; отчистка массива результатов от пустых строк

	Return $aRightChange
EndFunc   ;==>_Analyze

Func _CalculateResult($aRightChange)
	;Сложение результатов за 1 ход для разных цветов
	For $i = 0 To UBound($aRightChange) - 1
		For $j = $i + 1 To UBound($aRightChange) - 1
			If StringLen($aRightChange[$i][3]) > 1 And $aRightChange[$i][0] = $aRightChange[$j][0] And $aRightChange[$i][1] = $aRightChange[$j][1] And $aRightChange[$i][2] = $aRightChange[$j][2] Then
				;сложение результатов в первое значение
				$aRightChange[$i][3] = $aRightChange[$i][3] & $aRightChange[$j][3]
				$aRightChange[$i][4] = Execute($aRightChange[$i][3])
				ConsoleWrite('(' & $aRightChange[$i][0] & ')(' & $aRightChange[$i][1] & ')(' & $aRightChange[$i][2] & '): по = ' & $aRightChange[$i][3] & @CRLF) ;### Debug Console
				ConsoleWrite('(' & $aRightChange[$j][0] & ')(' & $aRightChange[$j][1] & ')(' & $aRightChange[$j][2] & '): по = ' & $aRightChange[$j][3] & @CRLF) ;### Debug Console
				For $a = 0 To 6 ;отчистка второго массива
					$aRightChange[$j][$a] = ''
				Next
				ConsoleWrite('(' & $aRightChange[$i][0] & ')(' & $aRightChange[$i][1] & ')(' & $aRightChange[$i][2] & '): по = ' & $aRightChange[$i][3] & @CRLF) ;### Debug Console
				ConsoleWrite('(' & $aRightChange[$j][0] & ')(' & $aRightChange[$j][1] & ')(' & $aRightChange[$j][2] & '): по = ' & $aRightChange[$j][3] & @CRLF) ;### Debug Console
				ExitLoop
			EndIf
		Next
	Next
	$aRightChange = _ArrayClearEmpty($aRightChange) ; отчистка массива результатов от пустых строк
	Return $aRightChange
EndFunc   ;==>_CalculateResult

Func _WriteToRightChange(ByRef $aRightChange, $i, $j, $h, $qs, $iRgtCng, $C, $napr)
	$aRightChange[$iRgtCng][3] = $qs
	$aRightChange[$iRgtCng][4] = Execute($qs)
	$aRightChange[$iRgtCng][0] = $i
	$aRightChange[$iRgtCng][1] = $j
	$aRightChange[$iRgtCng][2] = $h
	$aRightChange[$iRgtCng][5] = $C
	$aRightChange[$iRgtCng][6] = $napr
;~ 	ConsoleWrite('@@ Debug(' & $i & ')(' & $j & ')(' & $H & ')(' & $qs & ') : $iRgtCng = ' & $iRgtCng & @CRLF) ;### Debug Console
	Return 1
EndFunc   ;==>_WriteToRightChange

Func _ArrayClearEmpty($a_Array, $i_SubItem = 0, $i_Start = 0)
	If Not IsArray($a_Array) Or UBound($a_Array, 0) > 2 Then Return SetError(1, 0, 0)

	Local $i_Index = -1
	Local $i_UBound_Row = UBound($a_Array, 1) - 1
	Local $i_UBound_Column = UBound($a_Array, 2) - 1

	If $i_UBound_Column = -1 Then $i_UBound_Column = 0
	If $i_SubItem > $i_UBound_Column Then $i_SubItem = 0
	If $i_Start < 0 Or $i_Start > $i_UBound_Row Then $i_Start = 0

	Switch $i_UBound_Column + 1
		Case 1
			Dim $a_TempArray[$i_UBound_Row + 1]
			If $i_Start Then
				For $i = 0 To $i_Start - 1
					$a_TempArray[$i] = $a_Array[$i]
				Next
				$i_Index = $i_Start - 1
			EndIf
			For $i = $i_Start To $i_UBound_Row
				If String($a_Array[$i]) Then
					$i_Index += 1
					$a_TempArray[$i_Index] = $a_Array[$i]
				EndIf
			Next
			If $i_Index > -1 Then
				ReDim $a_TempArray[$i_Index + 1]
			Else
				Return SetError(2, 0, 0)
			EndIf
		Case 2 Or 3 Or 4 Or 5 Or 6 Or 7
			Dim $a_TempArray[$i_UBound_Row + 1][$i_UBound_Column + 1]
			If $i_Start Then
				For $i = 0 To $i_Start - 1
					For $j = 0 To $i_UBound_Column
						$a_TempArray[$i][$j] = $a_Array[$i][$j]
					Next
				Next
				$i_Index = $i_Start - 1
			EndIf
			For $i = $i_Start To $i_UBound_Row
				If String($a_Array[$i][$i_SubItem]) Then
					$i_Index += 1
					For $j = 0 To $i_UBound_Column
						$a_TempArray[$i_Index][$j] = $a_Array[$i][$j]
					Next
				EndIf
			Next
			If $i_Index > -1 Then
				ReDim $a_TempArray[$i_Index + 1][$i_UBound_Column + 1]
			Else
				Return SetError(2, 0, 0)
			EndIf
	EndSwitch
	Return $a_TempArray
EndFunc   ;==>_ArrayClearEmpty

Func _CompareWithArray(ByRef $aRightChange, $p0, $p1, $p2, $p3, $p4, $p5, $p6)
	; расчет количества сравниваемых параметров
	$qp = 0
	For $n = 0 To 6
		If Eval('p' & $n) <> -1 Then $qp += 1
	Next
	;поиск подходящего элемента в масиве
	For $x = 0 To UBound($aRightChange) - 1
		$shet = 0
		For $n = 0 To 6
			If Eval('p' & $n) <> -1 And $aRightChange[$x][$n] = Eval('p' & $n) Then $shet += 1
		Next
		If $shet = $qp Then Return $x
	Next

	Return -1
EndFunc   ;==>_CompareWithArray

Func _CreatArray()
	Local $aPos[6][6]
	For $i = 0 To 5
		For $j = 0 To 5
			$aPos[$i][$j] = Round(Random(1, 5))
		Next
	Next
	;отчистка сгенерированного массива от трех в ряд
	$exit = 0
	For $n = 0 To 999
		$q = 0
		For $i = 0 To 5
			For $j = 0 To 5
				For $C = 1 To 5
					If $i < 4 And $aPos[$i][$j] = $C And $aPos[$i + 1][$j] = $C And $aPos[$i + 2][$j] = $C Then
						$q += 1
						$aPos[$i + 2][$j] = _random(1, 5, $C)
					EndIf
					If $j < 4 And $aPos[$i][$j] = $C And $aPos[$i][$j + 1] = $C And $aPos[$i][$j + 2] = $C Then
						$q += 1
						$aPos[$j + 2][$j] = _random(1, 5, $C)
					EndIf
				Next
			Next
		Next
		If $q = 0 Then
			ExitLoop
		Else
			For $i = 0 To 5
				For $j = 0 To 5
					$aPos[$i][$j] = Round(Random(1, 5))
				Next
			Next
		EndIf

		If $n = 999 Then $exit = 1
	Next
	ConsoleWrite('@@ Debug(' & $n & ') : $q = ' & $q & @CRLF) ;### Debug Console
	;вывод в консоль
	For $i = 0 To 5
		For $j = 0 To 5
			ConsoleWrite($aPos[$i][$j] & ' ')
		Next
		ConsoleWrite(@CRLF)
	Next
	If $exit = 1 Then Exit
	Return $aPos
EndFunc   ;==>_CreatArray

Func _random($min, $max, $noteq)
	$t = $noteq
	While $t = $noteq
		$t = Round(Random($min, $max))
	WEnd
	Return $t
EndFunc   ;==>_random

Func Terminate()
	Exit
EndFunc   ;==>Terminate

