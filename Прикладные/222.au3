#Include <WinAPIEx.au3>
#Include <array.au3>
#include <date.au3>

#Include <GDIPlus.au3>
#Include <GUIConstantsEx.au3>
#Include <Math.au3>
#Include <WinAPI.au3>
#include <File.au3>
#include <Color.au3>
$testsleep=200
HotKeySet("{F7}", "Terminate")
HotKeySet("{F10}", "_Go")
Func Terminate()
	Exit
EndFunc   ;==>Terminate
;~ sleep(2000)
;~ Opt('MustDeclareVars', 1)

While 1
	sleep(100)
WEnd

Func _Go()
For $i=0 to 4999
	ConsoleWrite(ClipGet() & @CRLF)
	sleep($testsleep)
	Send('^{Ins}')
	sleep($testsleep)
	Send('{Down}')


Next
EndFunc

Exit


#RequireAdmin
$hWnd = WinGetHandle("[CLASS:Autoruns]")
WinActivate($hWnd)
sleep(200)
For $i = 1 to 1000
	Send("+{F10}")
	sleep(64)
	Send('{e}')
	sleep(64)
	Send('{v}')
	sleep(64)
	Send('{UP}')
	sleep(200)
Next

Send("{APPSKEY}")
Send('+ev')
Send('{e}')
Send('{v}')

;~ WinMenuSelectItem($hWnd, "", "&Entry", "Check &VirusTotal" )

;~ $sSearch = 'exit'
;~ #include <GuiMenu.au3>
;~ #include <SendMessage.au3>
;~ #include <WindowsConstants.au3>
;~ $hWnd = WinWaitActive('[CLASS:Autoruns]')
;~ $hMain = _GUICtrlMenu_GetMenu($hWnd)
;~ $hFile = _GUICtrlMenu_GetItemSubMenu($hMain, 0)
;~ $iCount = _GUICtrlMenu_GetItemCount($hFile)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iCount = ' & $iCount & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ For $i = 0 To $iCount - 1
;~     $sTemp = _GUICtrlMenu_GetItemText($hFile, $i)
;~     ConsoleWrite($i + 1 & '. ' & $sTemp & @CRLF)
;~     If StringInStr(StringReplace($sTemp, '&', ''), $sSearch) Then $wParam = $i
;~ Next

;~ If $wParam > -1 Then
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $wParam = ' & $wParam & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~     _SendMessage($hWnd, $WM_COMMAND, $wParam)
;~ EndIf

Exit

$file='filename(123213b).ext'
$FtpSize = StringRegExp($file,'\(([0-9]*?)\)\.[^.]*$',2)
if Ubound($FtpSize)>1 then
	$FtpSize = $FtpSize[1]
Else
	$FtpSize = 0
EndIf
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FtpSize = ' & $FtpSize & @CRLF) ;### Debug Console
exit


;~ $loginPage = "http://jarvis1.esy.es/login.php"
;~ #Include <INet.au3> ;Подключаем библиотеку
;~ $HTML = _INetGetSource('http://www.google.ru/') ;Получаем HTML код страницы
;~ $source = BinaryToString(InetRead("http://jarvis1.esy.es/login.php",1),4)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $source = ' & $source & @CRLF) ;### Debug Console

;~ $oHTTP = ObjCreate('WinHttp.WinHttpRequest.5.1')
;~ $oHTTP.Open('GET', $loginPage)
;~ $sCookies = 'sid=d513c6b1f48116e7cb01704f56a59964; '
;~ $sCookies = 'login=new1ogin; '
;~ $sCookies = 'password=jarvis1.esy.es; '
;~ $sCookies &= 'PHPSESSID=f65db015e0193bc77dc426b27285c807;'
;~ $oHTTP.SetRequestHeader('Cookie', $sCookies)
;~ $oHTTP.Send('')
;~ $oHTTP.WaitForResponse
;~ $sHTML = $oHTTP.ResponseText
;~ ConsoleWrite($sHTML & @CRLF)

;~ Exit

;~ Dim $aPoints[300][2]

;~ For $i = 0 To UBound($aPoints) - 1
;~     $aPoints[$i][0] = ($i - 150) / 1.7
;~     $aPoints[$i][1] = 20 * Sin($aPoints[$i][0] / 20) * Sin($aPoints[$i][0] / 2)
;~ Next
$clip = ClipGet()
While 1
	if ClipGet() <> $clip Then
		$clip = ClipGet()
		ConsoleWrite($clip & @CRLF)
	EndIf
	sleep(500)
WEnd
Exit


$timer=TimerInit()
For $i=0 To 5
	For $j=0 to 5
		$t = PixelChecksum($i*100,$j*100,$i*100+100,$j*100+100)
		ConsoleWrite($i & ' ' & $j & ' ' & $t & ' ' & @CRLF)
	Next
Next

ConsoleWrite('$timer = ' & Round(TimerDiff($timer),2) & @CRLF)
Exit
; СКАЧИВАНИЕ РЕЛИЗОВ С САЙТА 1с
$firstn=9
While 1
	Send('{TAB}')
	sleep($testsleep)
	Send('!{Enter}')
	sleep($testsleep)
	sleep(200)
	Send($firstn)
	sleep($testsleep)
	Send('{Enter}')
	sleep($testsleep)
	ConsoleWrite($firstn & @CRLF)
	$firstn+=1
	Sleep(400)
Wend
exit


;~ _ViewGraph($aPoints)
$Size=681574400
$sPath = '\\192.168.0.1\ftp\pub\temp\t3'
;~ $sPath2 = '\\192.168.0.1\ftp\pub\temp\t2'
;~ $sPath='D:\PortableSoft\Any Video Converter Ultimate 5.8.1 Portable by PortableAppZ\MP4'
$sPath2 = 'D:\Temp\Novosib'
$timeWait=1*60000 ; время ожидания для каждого файла проверки
$qIdenticSize=3-1 ; Количество проверок размера фала перед копированием, отсчёт с нуля
local $filesize[999][3], $ifz=0
While 1
$aFiles=_FileListToArray($sPath)
if not @error then

	For $i=1 to $aFiles[0]
		; поиск такого файла в масиве
		$fsize=FileGetSize($sPath&'\'&$aFiles[$i])
		$iFNum=_ArraySearch($filesize,$aFiles[$i],0,0,0,0,1,0)
		if $iFNum = -1 Then ; добовление нового файла в массив
			$filesize[$ifz][0]=$aFiles[$i]
			$iFNum=$ifz
			$ifz+=1
		EndIf
		; сравнение размеров и увеличение счетчика при одинаковом размере
		if $filesize[$iFNum][1] <> $fsize Then
			$filesize[$iFNum][1] = $fsize
			$filesize[$iFNum][2]=0
		Else
			$filesize[$iFNum][2]+=1
		EndIf

		;копирование
		if $filesize[$iFNum][2]=$qIdenticSize Then
			$r=FileMove($sPath&'\'&$aFiles[$i],$sPath2&'\'&$aFiles[$i])
			ConsoleWrite('@@ Debug(' & $aFiles[$i] & ') : $r = ' & $r & @CRLF ) ;### Debug Console
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $fsize = ' & $fsize & @CRLF ) ;### Debug Console
		EndIf
	Next
EndIf

sleep($timeWait)
wend
;~ _ArrayDisplay($aFiles)
exit

local $a[1000][2]
For $i=0 to 999
	$a[$i][1] = Random(Random(),Random())
	$a[$i][0] = $i*0.01
Next
_ArraySort($a)
;~ _ArrayDisplay($a)
_ViewGraph($a)


;~ $Date2=_DateAdd("s",219196829,"1970/01/01 00:00:00")
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Date2 = ' & $Date2 & @CRLF ) ;### Debug Console

Exit


; Получение загрузки прцессора
Global Const $sProcess = 'notepad.exe' ; имя процесса
Global $PID = 0, $Prev1 = 0, $Prev2 = 0,  $nomer = 0, $CPU=0

While 1
$nomer +=1
If _Update() < 10 And $nomer <> 1 Then ; предел загрузки
ExitLoop
EndIf
sleep (500)
WEnd


MsgBox(0, "Заголовок", "Загрузка процессора процессом " & $sProcess &" меньше 10%")


Func _Update()
    Local $ID, $Time1, $Time2
    $ID = ProcessExists($sProcess)
    If $ID Then
        $Time1 = _WinAPI_GetProcessTimes($ID)
        $Time2 = _WinAPI_GetSystemTimes()
        If (IsArray($Time1)) And (IsArray($Time2)) Then
            $Time1 = $Time1[1] + $Time1[2]
            $Time2 = $Time2[1] + $Time2[2]
            If ($Prev1) And ($Prev2) And ($PID = $ID) Then
    $CPU=Round(($Time1 - $Prev1) / ($Time2 - $Prev2) * 100)
            EndIf
            $Prev1 = $Time1
            $Prev2 = $Time2
            $PID = $ID
    Return $CPU
        EndIf
    EndIf
    $Prev1 = 0
    $Prev2 = 0
    $PID = 0
EndFunc



exit


Global $Time1 = 0, $Time2 = 0
For $i=0 to 10
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _CPU($pid) = ' & _CPU('explorer.exe') & @CRLF) ;### Debug Console
	sleep(100)
Next
;~ _CPU($sProcess)

GUICreate('MyGUI', 400, 400)
GUICtrlCreateLabel('CPU usage:', 20, 20, 58, 14)
$Label = GUICtrlCreateLabel('0%', 80, 20, 40, 14)
GUISetState()

;~ AdlibRegister('_CPU', 1000)

Do
Until GUIGetMsg() = -3

Func _CPU($sProcess)
	$ID = ProcessExists($sProcess)
$return=''
local $Time1 = _WinAPI_GetProcessTimes($ID)
    Local $Time2 = _WinAPI_GetProcessTimes()

    If IsArray($Time1) Then
        $TimeBusyCPU = ($Time2[1] + $Time2[2]) - ($Time1[1] + $Time1[2])
        $TimeIdleCPU = ($Time2[0] - $Time1[0])
;~         GUICtrlSetData($Label, StringFormat('%.f%', ($TimeBusyCPU - $TimeIdleCPU) / $TimeBusyCPU * 100))
		$return=StringFormat('%.f%', ($TimeBusyCPU - $TimeIdleCPU) / $TimeBusyCPU * 100)
    EndIf
    $Time1 = $Time2
	return $return
EndFunc   ;==>_CPU


Func _ViewGraph($aPoints)

    Local $hForm, $Pic, $hPic
    Local $Scale, $Xi, $Yi, $Xp, $Yp, $XOffset, $YOffset, $Xmin = $aPoints[0][0], $Ymin = $aPoints[0][1], $Xmax = $Xmin, $Ymax = $Ymin
    Local $hBitmap, $hObj, $hGraphic, $hImage, $hBrush, $hPen

    For $i = 1 To UBound($aPoints) - 1
        If $aPoints[$i][0] < $Xmin Then
            $Xmin = $aPoints[$i][0]
        Else
            If $aPoints[$i][0] > $Xmax Then
                $Xmax = $aPoints[$i][0]
            EndIf
        EndIf
        If $aPoints[$i][1] < $Ymin Then
            $Ymin = $aPoints[$i][1]
        Else
            If $aPoints[$i][1] > $Ymax Then
                $Ymax = $aPoints[$i][1]
            EndIf
        EndIf
    Next

    $Scale = 600 / _Max($Xmax - $Xmin, $Ymax - $Ymin)
    $XOffset = Floor(($Xmin + $Xmax) * $Scale / 2)
    $YOffset = Floor(($Ymin + $Ymax) * $Scale / 2)

    _GDIPlus_Startup()
    $hBitmap = _WinAPI_CreateBitmap(601, 601, 1, 32)
    $hImage = _GDIPlus_BitmapCreateFromHBITMAP($hBitmap)
    _WinAPI_DeleteObject($hBitmap)
    $hGraphic = _GDIPlus_ImageGetGraphicsContext($hImage)
    $hBrush = _GDIPlus_BrushCreateSolid(0xFFFFFFFF)
    $hPen = _GDIPlus_PenCreate(0xFFFF0000)
    _GDIPlus_GraphicsFillRect($hGraphic, 0, 0, 601, 601, $hBrush)
    _GDIPlus_GraphicsSetSmoothingMode($hGraphic, 2)
    If Abs($XOffset) <= 300 Then
        _GDIPlus_GraphicsDrawLine($hGraphic, 300 - $XOffset, 0, 300 - $XOffset, 601, $hPen)
    EndIf
    If Abs($YOffset) <= 300 Then
        _GDIPlus_GraphicsDrawLine($hGraphic, 0, 300 + $YOffset, 601, 300 + $YOffset, $hPen)
    EndIf
    _GDIPlus_PenDispose($hPen)
    $hPen = _GDIPlus_PenCreate(0xFF000000)
    For $i = 0 To UBound($aPoints) - 1
        $Xi = 300 - $XOffset + $Scale * $aPoints[$i][0]
        $Yi = 300 + $YOffset - $Scale * $aPoints[$i][1]
        If $i Then
            _GDIPlus_GraphicsDrawLine($hGraphic, $Xp, $Yp, $Xi, $Yi, $hPen)
        EndIf
        $Xp = $Xi
        $Yp = $Yi
    Next
    $hBitmap = _GDIPlus_BitmapCreateHBITMAPFromBitmap($hImage)
    _GDIPlus_GraphicsDispose($hGraphic)
    _GDIPlus_ImageDispose($hImage)
    _GDIPlus_BrushDispose($hBrush)
    _GDIPlus_PenDispose($hPen)
    _GDIPlus_Shutdown()

    $hForm = GUICreate('My Graph', 601, 601)
    $Pic = GUICtrlCreatePic('', 0, 0, 601, 601)
    $hPic = GUICtrlGetHandle(-1)

    _WinAPI_DeleteObject(_SendMessage($hPic, 0x0172, 0, $hBitmap))
    $hObj = _SendMessage($hPic, 0x0173)
    If $hObj <> $hBitmap Then
        _WinAPI_DeleteObject($hBitmap)
    EndIf

    GUISetState(@SW_SHOW, $hForm)

    Do
    Until GUIGetMsg() = -3

    GUIDelete($hForm)

EndFunc   ;==>_ViewGraph

Func _HexStringReverse($nHex)
    $aRet = StringRegExp($nHex, '([[:xdigit:]]{2})', 3)
    $sRet = ''

    For $i = UBound($aRet)-1 To 0 Step -1
        $sRet &= $aRet[$i]
    Next

    Return $sRet
EndFunc