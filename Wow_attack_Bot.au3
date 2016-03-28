#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=WOW_attack_Bot-729.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinAPIEx.au3>
#include <Misc.au3>
			global $x1=171
			global $x2=674
			global $y1=729
			global $y2=729
#include <array.au3>
global $shade=40, $Paused ; максимально 70
$timedown=64
;~ 0xCDCB5E
HotKeySet("{End}", "Terminate")
;~ HotKeySet("{PgUp}", "PgUp")
;~ HotKeySet("{PgDn}", "PgDn")
;~ HotKeySet("{Ins}", "PgUp1")
;~ HotKeySet("{Del}", "PgDn1")
HotKeySet("{home}", "_Pause")
Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Beep(9000, 300)
	Run(@ComSpec & " /c " & 'Net Start uxsms', "", @SW_HIDE); выход из программы и включение
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
Func _Pause()
	if Not $Paused then Beep(9000, 300)
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
Func PgUp()
	$shade+=10
	ConsoleWrite($shade&@CRLF)
EndFunc
Func PgDn()
	$shade+=-10
	ConsoleWrite($shade&@CRLF)
EndFunc
Func PgUp1()
	$y1+=1
	$y2+=1
	ConsoleWrite($y1&@CRLF)
EndFunc
Func PgDn1()
	$y1+=-1
	$y2+=-1
	ConsoleWrite($y1&@CRLF)
EndFunc
Run(@ComSpec & " /c " & 'Net Stop uxsms', "", @SW_HIDE) ; отключаем аеро
   $hWnd = WinWaitActive("World of Warcraft")
   $size = WinGetPos($hWnd)
   $xsize=$size[2]&'x'&$size[3]
			;для 1366x768
			global $x1=171
			global $x2=674
			global $y1=729
			global $y2=729
		;для мониторо 1280x1024
   	Switch $xsize
		Case '1280x1024'
			$x1=472
			$x2=804
			$y1=815
			$y2=815
		Case '1032x795'
			$x1=377
			$x2=644
			$y1=601
			$y2=601
		Case '1198x979'
			$x1=483
			$x2=794
			$y1=777
			$y2=777

		EndSwitch
	ConsoleWrite(' Ваше текущее разрешение: '&$xsize&@CRLF)
;~ sleep(4000)
;~ 1032x795
;~ 377-644
;~ 601


;~ 1198x979 (x0,9560546875)
;~ (-82x45)
;~ 483-794
;~ 777 (38) (0,9533742331288344)
;~ 1280x1024

$winacive=0
Opt("PixelCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
while 1
if WinActive ( "World of Warcraft" ) <> 0 then
	if $winacive=0 then
		sleep(500)
		_WinGetCoords()
		beep(500,100)
		ConsoleWrite($x1&$y1&$x2&$y2&@CRLF)
	EndIf
	$winacive=1
	$PixelFind=PixelSearch($x2,$y1,$x1,$y2,0xFFFFFF,$shade)
	if not @error and $PixelFind[0]<> $x1 and $PixelFind[0]<>634 and $PixelFind[0]<> $x2 then
	ConsoleWrite(@MIN&@SEC&' '&$PixelFind[0]&@CRLF)
	_click($PixelFind[0])
	EndIf
	$PixelFind=PixelSearch($x2,$y1,$x1,$y2,0xCDCB5E,$shade-5)
	if not @error and $PixelFind[0]<> $x1 and $PixelFind[0]<> $x2 then
	ConsoleWrite(@MIN&@SEC&' '&$PixelFind[0]&@CRLF)
	_click($PixelFind[0])
	ConsoleWrite(" Найден ЖЕЛТЫЙ вариант мерцания "&@CRLF)
	EndIf
	$PixelFind=PixelSearch($x2,$y1,$x1,$y2,0x77FFFB,$shade-5)
	if not @error and $PixelFind[0]<> $x1 then
	ConsoleWrite(@MIN&@SEC&' '&$PixelFind[0]&@CRLF)
	_click($PixelFind[0])
	ConsoleWrite(" Найден СИНИЙ вариант мерцания "&@CRLF)
	EndIf

Else
	sleep(100)
	$winacive=0
Endif

sleep(10)
wend

Func _Key($Code)
	_WinAPI_Keybd_Event($Code, 0) ;клавиша 1
	sleep($timedown)
	_WinAPI_Keybd_Event($Code, 2) ;клавиша 1
	ConsoleWrite(" Нажата клавиша с кодом "&Hex($Code,2)&@CRLF)
EndFunc


Func _click($PixelCoords)
	$Cell=($x2-$x1)/12
	Switch $PixelCoords
		Case $x1-($Cell*0)+$Cell*0 To $x1+($Cell*1)+$Cell*0
		_Key(0x31)
		Case $x1-($Cell*0)+$Cell*1 To $x1+($Cell*1)+$Cell*1
		_Key(0x32)
		Case $x1-($Cell*0)+$Cell*2 To $x1+($Cell*1)+$Cell*2
		_Key(0x33)
		Case $x1-($Cell*0)+$Cell*3 To $x1+($Cell*1)+$Cell*3
		_Key(0x34)
		Case $x1-($Cell*0)+$Cell*4 To $x1+($Cell*1)+$Cell*4
		_Key(0x35)
		Case $x1-($Cell*0)+$Cell*5 To $x1+($Cell*1)+$Cell*5
		_Key(0x36)
		Case $x1-($Cell*0)+$Cell*6 To $x1+($Cell*1)+$Cell*6
		_Key(0x37)
		Case $x1-($Cell*0)+$Cell*7 To $x1+($Cell*1)+$Cell*7
		_Key(0x38)
		Case $x1-($Cell*0)+$Cell*8 To $x1+($Cell*1)+$Cell*8
		_Key(0x39)
		Case $x1-($Cell*0)+$Cell*9 To $x1+($Cell*1)+$Cell*9
		_Key(0x30)
		Case $x1-($Cell*0)+$Cell*10 To $x1+($Cell*1)+$Cell*10
		_Key(0xBD)
		Case $x1-($Cell*0)+$Cell*11 To $x1+($Cell*1)+$Cell*11
		_Key(0xBB)
		Case $x1-($Cell*0)+$Cell*12 To $x1+($Cell*1)+$Cell*12
	EndSwitch
	sleep(100)
EndFunc

Func _WinGetCoords()
   $hWnd = WinWaitActive("World of Warcraft")
   $size = WinGetPos($hWnd)
   $xsize=$size[2]&'x'&$size[3]
   	Switch $xsize
		Case '1280x1024'
			global $x1=472
			global $x2=804
			global $y1=815
			global $y2=815
		Case '1032x795'
			global $x1=377
			global $x2=644
			global $y1=601
			global $y2=601
		Case '1198x979'
			global $x1=483
			global $x2=794
			global $y1=777
			global $y2=777

	EndSwitch
	ConsoleWrite(' Ваше текущее разрешение: '&$xsize&@CRLF)
EndFunc


