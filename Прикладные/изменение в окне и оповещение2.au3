#include <array.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <Crypt.au3>

; слежение за state окна
#include<WinAPIEx.au3>
#include <WinAPI.au3>
$pid=''
$title = 'Конфигуратор - Бухгалтерия предприятия (базовая), редакция 3.0'
$title = WinGetHandle($title)
While 1
	$state = WinGetState($title)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $state = ' & $state & @CRLF) ;### Debug Console
;~ 	_WinAPI_GetProcessIoCounters($title)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _WinAPI_GetProcessIoCounters($title) = ' & _WinAPI_GetProcessIoCounters($title) & @CRLF) ;### Debug Console
;~ 	_WinAPI_GetProcessIoCounters(17528)

_WinAPI_GetWindowThreadProcessId($title,$pid)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _WinAPI_GetProcessIoCounters(17528) = ' & $pid & @CRLF) ;### Debug Console
	$title = 'ТСЖН "Советская 60" / <Не указан> / Бухгалтерия предприятия (базовая), редакция 3.0'
	$state = WinGetState($title)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $state = ' & $state & @CRLF) ;### Debug Console
	_WinAPI_GetWindowThreadProcessId($title,$pid)
	$title = 'Обновление версии программы - ТСЖН "Советская 60" / <Не указан> / Бухгалтерия предприятия (базовая), редакция 3.0'
	$state = WinGetState($title)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $state = ' & $state & @CRLF) ;### Debug Console
	exit
wend
Func GetProcessUsage($hProc)
    Local $last_sys, $last_proc, $sys, $proc, $ret
    $last_sys = _WinAPI_GetSystemTimes()
    $last_proc = _WinAPI_GetProcessTimes($hProc)
    Sleep(1000)
    $sys = _WinAPI_GetSystemTimes()
    $proc = _WinAPI_GetProcessTimes($hProc)
    $sys[1] -= $last_sys[1]
    $sys[2] -= $last_sys[2]
    $proc[1] -= $last_proc[1]
    $proc[2] -= $last_proc[2]

    $ret = (($proc[1]+$proc[2])/($sys[1]+$sys[2]))*100.0
    If StringInStr($ret, '#') Then $ret = 0

    Return $ret
EndFunc

global $hwnd, $posWin, $title = '', $emailUser, $URL_smsruUser, $sleepForCheckImage
HotKeySet("{F7}", "_GetWindow") ;Это вызов
$sleepForCheckImage=1000

_GUI()
;~ sleep(5000)
;~ exit
While 1
	Sleep(100)
WEnd



;~ _ArrayDisplay($posWin)
dim $array[10]
dim $array2[10]
For $i=0 to 9
	$array[$i] = PixelChecksum ( $posWin[0], $posWin[1], $posWin[0]+$posWin[2], $posWin[1]+$posWin[3], 1, $hwnd, 1)
	sleep($sleepForCheckImage)
Next
For $i=0 to 9
;~ 	$array[$i]
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $array[$i] = ' & $array[$i] & @CRLF) ;### Debug Console
Next


Func _GUI()
	#include <ButtonConstants.au3>
	#include <EditConstants.au3>
	#include <GUIConstantsEx.au3>
	#include <StaticConstants.au3>
	#include <WindowsConstants.au3>
	Opt("GUIOnEventMode", 1)
	#Region ### START Koda GUI section ### Form=
	$Window_Change = GUICreate("Изменение в окне и оповещение", 530, 299, 760, 399)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Window_ChangeClose")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "Window_ChangeMinimize")
	GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Window_ChangeMaximize")
	GUISetOnEvent($GUI_EVENT_RESTORE, "Window_ChangeRestore")
	$Info1 = GUICtrlCreateLabel("Выберите окно за которым надо следить и нажмите F7", 8, 8, 287, 17)
	GUICtrlSetOnEvent(-1, "Info1Click")
	$Info2 = GUICtrlCreateLabel("Выбранное окно:", 8, 24, 516, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetOnEvent(-1, "Info2Click")
	global $SelectWindowInfo = GUICtrlCreateLabel("Ещё не выбрано", 8, 49, 520, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetOnEvent(-1, "SelectWindowInfoClick")
	$Group1 = GUICtrlCreateGroup("Способы оповещения", 8, 80, 513, 121)
	$Info3 = GUICtrlCreateLabel("По e-mail адресу:", 16, 104, 89, 17)
	GUICtrlSetOnEvent(-1, "Info3Click")
	global $email = GUICtrlCreateInput("new1ogin@mail.ru", 16, 124, 497, 21)
	GUICtrlSetOnEvent(-1, "emailChange")
	$Info4 = GUICtrlCreateLabel("По SMS (sms.ru)", 15, 150, 83, 17)
	GUICtrlSetOnEvent(-1, "Info4Click")
	global $URL_smsru = GUICtrlCreateInput("http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text=", 15, 170, 497, 21)
	GUICtrlSetOnEvent(-1, "URL_smsruChange")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Start = GUICtrlCreateButton("Начать", 56, 264, 160, 25)
	GUICtrlSetOnEvent(-1, "StartClick")
	$Group2 = GUICtrlCreateGroup("Настройки", 8, 208, 513, 49)
	$Info5 = GUICtrlCreateLabel("Частота обновления в мс:", 16, 228, 138, 17)
	GUICtrlSetOnEvent(-1, "Info5Click")
	global $Sleep = GUICtrlCreateInput("1000", 160, 224, 121, 21)
	GUICtrlSetOnEvent(-1, "SleepChange")
	$Label1 = GUICtrlCreateLabel("Количество вариантов изображения:", 290, 228, 193, 17)
	GUICtrlSetOnEvent(-1, "Label1Click")
	global $QCheckSummsImage = GUICtrlCreateLabel("0", 487, 228, 26, 17)
	GUICtrlSetOnEvent(-1, "QCheckSummsImageClick")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Cancel = GUICtrlCreateButton("Отменить", 310, 264, 160, 25)
	GUICtrlSetOnEvent(-1, "CancelClick")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###


EndFunc

Func _getWindow()
	$hwnd = WinGetHandle("[ACTIVE]")
	$posWin = WinGetPos($hwnd)
	$title = WinGetTitle($hwnd)
	GUICtrlSetData($SelectWindowInfo,"" & StringLeft($title,50) & '...')
EndFunc

Func StartClick()
	if $title == '' Then
		Msgbox(0,"Ошибка"," Сначала выберите окно за которым надо следить и нажмите F7")
	Else

	$emailUser = GUICtrlRead($email)
	$URL_smsruUser = GUICtrlRead($URL_smsru)
	$sleepForCheckImage = GUICtrlRead($Sleep)
;~ 	Msgbox(0,'',$emailUser&$URL_smsruUser&$sleepForCheckImage)
	dim $array[10]
;~ 	While 1
;~ 		For $i=0 to 9
;~ 			$posWin = WinGetPos($hwnd)
;~ 			$array[$i] = PixelChecksum ( $posWin[0], $posWin[1], $posWin[0]+$posWin[2], $posWin[1]+$posWin[3], 1, $hwnd, 1)
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $array[$i] = ' & $array[$i] & @CRLF) ;### Debug Console
;~ 			sleep($sleepForCheckImage)
;~ 		Next
;~ 	WEnd
;~ _GDIPlus_Startup()
;~ $aArea = _GridArea(100, $posWin[2], $posWin[3])
;~ $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd, $posWin[2], $posWin[3]))
;~ _GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Test000.jpg")
;~ $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd, $aArea[1][0]+$aArea[1][2], $aArea[1][1]+$aArea[1][3]))
;~ _GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Test111.jpg")
;~ $hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd, $aArea[2][0]+$aArea[2][2], $aArea[2][1]+$aArea[2][3]))
;~ _GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Test222.jpg")

;~ If (IsArray($aArea) And ($aArea[0][0] > 0)) Then
;~   _ArrayDisplay($aArea)
;~ EndIf
;~ exit
;~ Dim $aMemoryImage[($posWin[2] * $posWin[3] * 4) + 1]
Dim $aMemoryImage[101]
	$schet = 0
	$IndexCompare = 0
	_GDIPlus_Startup()
	$Struct = ''
	For $i=1 to 99
		$Struct &= 'byte[' & Ceiling(($posWin[2] * $posWin[3] * 4)/100) & '];'
	Next
	$Struct &= 'byte[' & ($posWin[2] * $posWin[3] * 4)-Ceiling(($posWin[2] * $posWin[3] * 4)/100)*99 & ']'
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Struct = ' & $Struct & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('byte[' & ($posWin[2] * $posWin[3] * 2 ) & ']' & ';byte[' & ($posWin[2] * $posWin[3] * 2 ) & ']' & @CRLF)
	While 1
		$posWin = WinGetPos($hwnd)
		$timer = TimerInit()
		$t_array = Round(TimerDiff($timer),2)
		$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd))
		$t_zahvat = Round(TimerDiff($timer),2)
		$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $posWin[2], $posWin[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
		$t_obr1 = Round(TimerDiff($timer),2)
		$tData = DllStructCreate($Struct, DllStructGetData($tMap, 'Scan0'))
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : DllStructGetSize ($tData) = ' & DllStructGetSize ($tData) & @CRLF) ;### Debug Console
;~ 		$bData = DllStructGetData($tData, 1)
;~ 		ConsoleWrite("   Len="&StringLen($bData) & "   DATA="&StringLeft($bData,20)&"   "& StringRight($bData,20) & @CRLF)
;~ 		$bData = DllStructGetData($tData, 100)
;~ 		ConsoleWrite("   Len="&StringLen($bData) & "   DATA="&StringLeft($bData,20)&"   "& StringRight($bData,20) & @CRLF)
;~ 		$CountStructur = DllStructGetSize ($tData)
		$timer2 = TimerInit()
		if $schet = 0 then
;~ 			For $i = 1 To $CountStructur
;~ 				$aMemoryImage[$i] = DllStructGetData($tData, 1, $i)
;~ 			Next
			For $i = 1 To 100
				$aMemoryImage[$i] = DllStructGetData($tData, $i)
;~ 				$aMemoryImage[$i] = StringMid($bData,$i*($CountStructur/100),$CountStructur/100)
			Next
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer2) = ' & TimerDiff($timer2) & @CRLF) ;### Debug Console
		Else
;~ 			For $i = 1 To $CountStructur
;~ 				if $aMemoryImage[$i] <> DllStructGetData($tData, 1, $i) Then $IndexCompare += 1
;~ 			Next
			For $i = 1 To 100
				if $aMemoryImage[$i] <> DllStructGetData($tData, $i) Then $IndexCompare += 1
;~ 				if $aMemoryImage[$i] <> StringMid($bData,$i*($CountStructur/100),$CountStructur/100) Then $IndexCompare += 1
			Next
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer2) = ' & TimerDiff($timer2) & @CRLF) ;### Debug Console
		EndIf


		ConsoleWrite(@CRLF)
		$t_obr2 = Round(TimerDiff($timer),2)
;~ 		$i = _Crypt_HashData($bData,$CALG_MD5)
		$t_Hash = Round(TimerDiff($timer),2)
		_GDIPlus_BitmapUnlockBits($hBitmap, $tMap)
		_GDIPlus_BitmapDispose($hBitmap)
;~ 		$bData = DllStructGetData($tData, 1, 1234)
;~ 		ConsoleWrite("   Len="&StringLen($bData) & "   DATA="&StringLeft($bData,200) & @CRLF)

		$t_End = Round(TimerDiff($timer),2)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $IndexCompare = ' & $IndexCompare & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & StringLen($bData) & ') : $i = ' & $i & "   Len="&StringLen($bData) & "   DATA="&StringLeft($bData,200) & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t_zahvat = ' & $t_zahvat&'('&$t_array&')'&' $t_obr1 = ' & $t_obr1&'('&$t_obr1-$t_zahvat&')'&' $t_obr2 = ' & $t_obr2&'('&$t_obr2-$t_obr1&')'&' $t_Hash = ' & $t_Hash&'('&$t_Hash-$t_obr2&')'&' $t_End = ' & $t_End&'('&$t_End-$t_Hash&')'& @CRLF) ;### Debug Console
		sleep($sleepForCheckImage)
		$schet+=1
		if $schet = 2 then exit
	WEnd
	_GDIPlus_Shutdown()




;~ 	_GDIPlus_Startup()
;~ 	;$hBitmap = Capture_Window($hWnd, $posWin[2], $posWin[3])
;~ 	$iWidth = _WinAPI_GetWindowWidth($hWnd)
;~ 	_WinAPI_GetWindowHeight($hWnd)
;~ 	$hHBitmap = _WinCapture($hWnd, $posWin[2], $posWin[3])
;~ 	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hBitmap = ' & $hBitmap & @CRLF) ;### Debug Console
;~ 	$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $posWin[2], $posWin[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
;~ 	$tMap = StringLeft(DllStructGetData(DllStructCreate('byte[' & ($posWin[2] * $posWin[3] * 4) & ']', DllStructGetData($tMap, 'Scan0')), 1),9999)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tMap = ' & $tMap & @CRLF) ;### Debug Console
;~ 	_GDIPlus_ImageSaveToFile($hBitmap, @ScriptDir & "\Test.jpg")
;~ 	_GDIPlus_BitmapDispose($hBitmap)
;~ 	ShellExecute(@ScriptDir & "\Test.jpg")
;~ 	_GDIPlus_Shutdown()
	Endif
EndFunc



Func Capture_Window($hWnd, $w, $h)
    Local $hDC_Capture = _WinAPI_GetWindowDC($hWnd)
    Local $hMemDC = _WinAPI_CreateCompatibleDC($hDC_Capture)
    Local $hHBitmap = _WinAPI_CreateCompatibleBitmap($hDC_Capture, $w, $h)
    Local $hObj = _WinAPI_SelectObject($hMemDC, $hHBitmap)
    DllCall("user32.dll", "int", "PrintWindow", "hwnd", $hWnd, "handle", $hMemDC, "int", 0)
    _WinAPI_DeleteDC($hMemDC)
    Local $hObject = _WinAPI_SelectObject($hMemDC, $hObj)
    _WinAPI_ReleaseDC($hWnd, $hDC_Capture)
    Local $hBmp = _GDIPlus_BitmapCreateFromHBITMAP($hHBitmap)
    _WinAPI_DeleteObject($hHBitmap)
    Return $hBmp
EndFunc

Func _WinCapture($hWnd, $iWidth = -1, $iHeight = -1)
    Local $iH, $iW, $hDDC, $hCDC, $hBMP
;~ 	$iH = 150
;~ 	$iW = 150
    If $iWidth = -1 Then $iWidth = _WinAPI_GetWindowWidth($hWnd)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iWidth = ' & $iWidth & @CRLF) ;### Debug Console
    If $iHeight = -1 Then $iHeight = _WinAPI_GetWindowHeight($hWnd)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iHeight = ' & $iHeight & @CRLF) ;### Debug Console
    $hDDC = _WinAPI_GetDC($hWnd)
;~ 	Local $hGDC =   _WinAPI_GetWindowDC ($hWND) ; взято
    $hCDC = _WinAPI_CreateCompatibleDC($hDDC)
    $hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iWidth, $iHeight)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hBMP = ' & $hBMP & @CRLF) ;### Debug Console
    _WinAPI_SelectObject($hCDC, $hBMP)
;~ 	$hImage = _GDIPlus_BitmapCreateFromHBITMAP ($hBMP)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hImage = ' & $hImage & @CRLF) ;### Debug Console
;~ 	$iX = _GDIPlus_ImageGetWidth ($hImage)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iX = ' & $iX & @CRLF) ;### Debug Console
;~     $iY = _GDIPlus_ImageGetHeight ($hImage)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iY = ' & $iY & @CRLF) ;### Debug Console

    DllCall("User32.dll", "int", "PrintWindow", "hwnd", $hWnd, "hwnd", $hCDC, "int", 0)
;~     _WinAPI_BitBlt($hCDC, 0, 0, $iW, $iH, $hDDC, 0, 0, 0x00330008)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iH = ' & $iH & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iW, = ' & $iW & @CRLF) ;### Debug Console

    _WinAPI_ReleaseDC($hWnd, $hDDC)
    _WinAPI_DeleteDC($hCDC)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hBMP = ' & $hBMP & @CRLF) ;### Debug Console
;~ 	$hImage = _GDIPlus_BitmapCreateFromHBITMAP ($hBMP)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hImage = ' & $hImage & @CRLF) ;### Debug Console
;~ 	$iX = _GDIPlus_ImageGetWidth ($hImage)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iX = ' & $iX & @CRLF) ;### Debug Console
;~     $iY = _GDIPlus_ImageGetHeight ($hImage)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iY = ' & $iY & @CRLF) ;### Debug Console

    Return $hBMP
EndFunc   ;==>_WinCapture



Func _GridArea($iDimension, $iWidth, $iHeight)
    Local $aArea[1][4], $xPos, $yPos, $xCount, $yCount, $iY, $iX
;~     $iWidth  = @DesktopWidth
;~     $iHeight = @DesktopHeight
    While 1
        $xPos += $iDimension
        If ($xPos > $iWidth) Then
            ExitLoop
        EndIf
        $xCount += 1
    Wend
    While 1
        $yPos += $iDimension
        If ($yPos > $iHeight) Then
            ExitLoop
        EndIf
        $yCount += 1
    Wend
    For $iY = 0 To $yCount
        For $iX = 0 To $xCount
            $aArea[0][0] += 1
            ReDim $aArea[$aArea[0][0] + 1][Ubound($aArea, 2)]
            $aArea[$aArea[0][0]][0] = $iDimension * $iX
            $aArea[$aArea[0][0]][1] = $iDimension * $iY
            If ((($aArea[$aArea[0][0]][0]) + $iDimension) <= $iWidth) Then
                $aArea[$aArea[0][0]][2] = $iDimension
            Else
                $aArea[$aArea[0][0]][2] = ($iWidth - $aArea[$aArea[0][0]][0])
            EndIf
            If ((($aArea[$aArea[0][0]][1]) + $iDimension) <= $iHeight) Then
                $aArea[$aArea[0][0]][3] = $iDimension
            Else
                $aArea[$aArea[0][0]][3] = ($iHeight - $aArea[$aArea[0][0]][1])
            EndIf
        Next
    Next
   Return $aArea
EndFunc

Func Window_ChangeClose()
	_quite()
EndFunc
Func CancelClick()
	_quite()
EndFunc

Func _quite()
	_GDIPlus_Shutdown()
	Exit
EndFunc


Func URL_smsruChange()
EndFunc
Func Window_ChangeMaximize()
EndFunc
Func Window_ChangeMinimize()
EndFunc
Func Window_ChangeRestore()
EndFunc
Func emailChange()
EndFunc
Func Info1Click()
EndFunc
Func Info2Click()
EndFunc
Func Info3Click()
EndFunc
Func Info4Click()
EndFunc
Func Info5Click()
EndFunc
Func Label1Click()
EndFunc
Func QCheckSummsImageClick()
EndFunc
Func SelectWindowInfoClick()
EndFunc
Func SleepChange()
EndFunc
