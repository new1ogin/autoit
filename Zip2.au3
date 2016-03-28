#include <GDIPlus.au3>
#include <Array.au3>
#include <Color.au3>
#include <ScreenCapture.au3>
#include <GuiConstantsEx.au3>
#include <WinAPIEx.au3>

#include <GDIP.au3>
global  $Paused, $testSC[2], $testSumm[2][12]
global $timedown=64
$X1 = 130
$X2 = $X1+505
$Y1 = 1000-2
$Y2 = 1002+2; Coordinates of upper left and bottom right vertices of recatangle to scan
;~ sleep(1000)
$step = 1
global $summ[12][2]
$Cell=($x2-$x1)/12



HotKeySet("{ins}", "_start")
HotKeySet("{end}", "Terminate")
;~ HotKeySet("{PgUp}", "PgUp")
;~ HotKeySet("{PgDn}", "PgDn")
;~ HotKeySet("{Ins}", "PgUp1")
;~ HotKeySet("{Del}", "PgDn1")
HotKeySet("{home}", "_Pause")
Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	_GDIPlus_Shutdown()
;~ 	_ArrayDisplay($testSumm)
	_Beep_NO()
	Run(@ComSpec & " /c " & 'Net Start uxsms', "", @SW_HIDE); выход из программы и включение
	Sleep(1000)
	Exit 0

EndFunc   ;==>Terminate
Func _Pause()
	if Not $Paused then _Beep_NO()
	$Paused = Not $Paused
	$trayP = 0
	global $winacive=0
	While $Paused
		$trayP += 1
		Sleep(100)
		If $trayP = 1 Then TrayTip("Подсказка", "Пауза", 1000)
	WEnd
	ToolTip("")
EndFunc   ;==>_Pause
sleep(2000)
;~ _GDIPlus_Startup ()
$hBMP = _ScreenCapture_Capture (@ScriptDir & '\color7.bmp', $X1, $Y1, $X2, $Y2)
;~ exit
While 1
	sleep(100)
WEnd

Func _start()
	$t=0
	ConsoleWrite(' Начинаем...'& @CRLF)
	;первичный поиск изображений
	    _GDIPlus_Startup ()
		$timer_fon=TimerInit()
;~ 	For $t=0 to 11
;~ 		ConsoleWrite(' Кнопка '&$t&'  '&" координата х1 " &$X1+$Cell*$t&" координата х2 " &$X1+$Cell*($t+1)& @CRLF)
;~ 		$Summ[$t][0] = _fon($X1+$Cell*$t, $Y1, $X1+$Cell*($t+1), $Y2, 1) ; возвращает сумму пикселей
;~ 		_fon($X1, $Y1, $X2, $Y2, 1,0) ; возвращает сумму пикселей
;~ 		_ScreenCapture_Capture (@ScriptDir & '\Wow\SC0'&$t&'.bmp', $X1+$Cell*$t, $Y1, $X1+$Cell*($t+1), $Y2)
;~ 	Next

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $timer_fon = ' & TimerDiff($timer_fon) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite($testSC[0]&@CRLF)

Beep()
	;цикл повторных поисков
	while 1

;~ 		For $t=0 to 11
;~ 			$Summ[$t][1] = _fon($X1+$Cell*$t, $Y1, $X1+$Cell*($t+1), $Y2, 1) ; возвращает сумму пикселей
			While 1
;~ 				 _fon($X1, $Y1, $X2, $Y2, 1, 1) ; возвращает сумму пикселей
				If $testSC[0]=$testSC[1] then ExitLoop
				sleep(50)
				ConsoleWrite(" шаблоны не совпадвют" &@CRLF)
			wend
;~ 		Next
		Redim $testSumm[Ubound($testSumm)+1][12]
		For $t=0 to 11
			_ScreenCapture_Capture (@ScriptDir & '\Wow\SC'&StringFormat("%03s",Ubound($testSumm))&StringFormat("%02s",$t)&'.bmp', $X1+$Cell*$t, $Y1, $X1+$Cell*($t+1), $Y2)
;~ 			$testSumm[Ubound($testSumm)-2][$t]=StringMid ($summ[$t][0],1,3)&StringMid ($summ[$t][1],1,3)
			If $summ[$t][0]/$summ[$t][1] < 0.5 then
				 ConsoleWrite(' '&$summ[$t][0]&' '&$summ[$t][1]&' '&$summ[$t][0]/$summ[$t][1]&@CRLF)

;~ 				 _click($t)
			EndIf
		Next
		sleep(100)
	wend

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $summ = ' & $summ & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


	;~ _ArrayDisplay($Array)
EndFunc


#comments-start
_GDIPlus_Startup()
$sPath = @ScriptDir & '\color6.bmp'
$hBitmap = _GDIPlus_BitmapCreateFromFile($sPath)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hBitmap = ' & $hBitmap & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $Width = _GDIPlus_ImageGetWidth($hBitmap)
    $Height = _GDIPlus_ImageGetHeight($hBitmap)
ConsoleWrite($hBitmap&' '&$Width&' '&$Height&@CRLF)

sleep(1000)
$X1 = 640
$X2 = 650
$Y1 = 700
$Y2 = 710; Coordinates of upper left and bottom right vertices of recatangle to scan
    $hBMP = _ScreenCapture_Capture ("", $X1, $Y1, $X2, $Y2)
	$hBitmap2 = _GDIPlus_BitmapCreateFromHBITMAP ($hBMP)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hBitmap = ' & $hBitmap & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $Width2 = _GDIPlus_ImageGetWidth($hBitmap2)
    $Height2 = _GDIPlus_ImageGetHeight($hBitmap2)
ConsoleWrite($hBitmap2&' '&$Width2&' '&$Height2&@CRLF)

    ; Создаёт GUI
    $hGUI = GUICreate("GDI+", 400, 300)
    GUISetState()
	   $hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI)
    _GDIPlus_GraphicsDrawImage ($hGraphic, $hBitmap, 0, 0)
		   $hGraphic2 = _GDIPlus_GraphicsCreateFromHWND ($hGUI)
    _GDIPlus_GraphicsDrawImage ($hGraphic, $hBitmap2, 15, 0)
    Do
    Until GUIGetMsg() = $GUI_EVENT_CLOSE
#comments-end
Func _click($numkey)

	Switch $numkey
		Case 0
		_Key(0x31)
		Case 1
		_Key(0x32)
		Case 2
		_Key(0x33)
		Case 3
		_Key(0x34)
		Case 4
		_Key(0x35)
		Case 5
		_Key(0x36)
		Case 6
		_Key(0x37)
		Case 7
		_Key(0x38)
		Case 8
		_Key(0x39)
		Case 9
		_Key(0x30)
		Case 10
		_Key(0xBD)
		Case 11
		_Key(0xBB)
		Case Else
		ConsoleWrite('координаты кнопки переданы неправильно '&@CRLF)
	EndSwitch
	sleep(100)
EndFunc
Func _Key($Code)
	_WinAPI_Keybd_Event($Code, 0) ;клавиша 1
	sleep($timedown)
	_WinAPI_Keybd_Event($Code, 2) ;клавиша 1
	ConsoleWrite(" Нажата клавиша с кодом "&Hex($Code,2)&@CRLF)
EndFunc

;функция подсчета пикселей на изображении
Func _fon($X1, $Y1, $X2, $Y2, $count=1, $test=1)
;~ 	_GDIPlus_Startup ()
		$hBMP = _ScreenCapture_Capture ("", $X1, $Y1, $X2, $Y2)
		$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP ($hBMP)
		$Width = _GDIPlus_ImageGetWidth($hBitmap)
		$Height = _GDIPlus_ImageGetHeight($hBitmap)
		$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $Width, $Height, $GDIP_ILMREAD, $GDIP_PXF32ARGB)
		$bData = DllStructGetData(DllStructCreate('byte[' & ($Width * $Height * 4) & ']', DllStructGetData($tMap, 'Scan0')), 1)
;~ 		$aTemp = StringRegExp($bData, '(\S{1,6})FF', 3)
		$bData = StringTrimLeft($bData, 2)
		StringLen($bData )
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($bData ) = ' & StringLen($bData ) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$summ_f=0
		For $i=0 to StringLen($bData)/8
			For $t=0 to 2
				$summ_f+='0x'&StringMid ( $bData, 1+($i*8)+$t*2 ,2)
			Next
		Next

		$testSC[$test] = StringMid ($bData,1,2*8)
		if StringMid($testSC[$test],1,6)=StringMid($testSC[$test],9,6) or StringMid($testSC[$test],1,6)='000000' Then
			sleep(100)
			ConsoleWrite('Ошибка. Первые пиксели области совпадают '&StringMid($testSC[$test],1,6)&' '&StringMid($testSC[$test],9,6)&@CRLF)
			_fon($X1, $Y1, $X2, $Y2, $count, $test)
			Return
		EndIf

		$LenData=StringLen($bData)/12
		For $n=0 to 11
			$bDatat=StringMid ( $bData, 1+$LenData*$n ,$LenData+$LenData*$n)
			For $i=0 to StringLen($bDatat)/8
				For $t=0 to 2
					$summ_f+='0x'&StringMid ( $bDatat, 1+($i*8)+$t*2 ,2)
				Next
			Next
			$Summ[$n][$test] = $summ_f

		Next
;~ 		_WinAPI_DeleteObject ($hBMP)
;~ 		_GDIPlus_Shutdown()
;~ 		Local $hGUI, $hBMP, $hBitmap, $hGraphic
;~ 		; Draw bitmap to GUI
;~ 		$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP ($hBMP)
;~ 		   $hGUI = GUICreate("GDI+", $X2-$X1, $Y2-$Y1,-1, -1)
;~ 			GUISetState()
;~ 			$hGraphic = _GDIPlus_GraphicsCreateFromHWND ($hGUI)
;~ 			_GDIPlus_GraphicsDrawImage ($hGraphic, $hBitmap, 0, 0)
;~ 		; Shut down GDI+ library

;~     ; Loop until user exits
;~     Do
;~     Until GUIGetMsg() = $GUI_EVENT_CLOSE
;~ 		return $summ_f
EndFunc   ;==>_fon

;функция подсчета уникальных пикселей на изображении
Func _fon1($X1, $Y1, $X2, $Y2, $count=1)
    Local $hBitmap, $tMap, $Width, $Height, $bData, $i

    _GDIPlus_Startup()
;~     $hBitmap = _GDIPlus_BitmapCreateFromFile($sPath)
    $hBMP = _ScreenCapture_Capture ("", $X1, $Y1, $X2, $Y2)
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP ($hBMP)
    $Width = _GDIPlus_ImageGetWidth($hBitmap)
    $Height = _GDIPlus_ImageGetHeight($hBitmap)
    If $Width * $Height < 16000000 Then
        $tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $Width, $Height, $GDIP_ILMREAD, $GDIP_PXF32ARGB)
        $bData = DllStructGetData(DllStructCreate('byte[' & ($Width * $Height * 4) & ']', DllStructGetData($tMap, 'Scan0')), 1)
        _GDIPlus_BitmapUnlockBits($hBitmap, $tMap)
        _GDIPlus_BitmapDispose($hBitmap)
        _GDIPlus_Shutdown()
        $bData = StringTrimLeft($bData, 2)
        $bData = '######FF' & $bData

        $aTemp = StringRegExp($bData, '(\S{1,6})FF', 3)
        $aTemp[0] = UBound($aTemp) - 1

        For $i = 1 To $aTemp[0] Step $count
            Assign($aTemp[$i], Eval($aTemp[$i]) + 1)
        Next

        Dim $uArray[$aTemp[0]][2] = [[0]]

        For $i = 1 To $aTemp[0] Step $count
            If Eval($aTemp[$i]) > 0 Then
                $uArray[0][0] += 1
                $uArray[$uArray[0][0]][0] = $aTemp[$i]
                $uArray[$uArray[0][0]][1] = Eval($aTemp[$i])
                Assign($aTemp[$i], -1)
            EndIf
        Next
        ReDim $uArray[$uArray[0][0] + 1][2]

        _ArraySort($uArray, 1, 1, 0, 1)

        For $i = 1 To Ubound($uArray) - 1
            $uArray[$i][0] = '0x' & Hex(_ColorGetBlue('0x' & $uArray[$i][0]), 2) & Hex(_ColorGetGreen('0x' & $uArray[$i][0]), 2) & Hex(_ColorGetRed('0x' & $uArray[$i][0]), 2)
        Next

;~         ConsoleWrite('Высота: ' & $Height & @CRLF)
;~         ConsoleWrite('Ширина: ' & $Width & @CRLF)
;~         ConsoleWrite('Всего цветов: ' & $aTemp[0] & @CRLF)
        ConsoleWrite('Уникальных цветов: ' & $uArray[0][0] & @CRLF)
;~         ConsoleWrite('Фон: ' & $uArray[1][0] & @CRLF)

        Return $uArray
    Else
        _GDIPlus_BitmapDispose($hBitmap)
        _GDIPlus_Shutdown()
    EndIf
EndFunc   ;==>_fon

Func _Beep_NO()
	Beep(9000, 200)
EndFunc
Func _beep_YES()
	beep(500,100)
EndFunc

