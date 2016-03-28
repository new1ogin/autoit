#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=WOW_attack_Bot-729.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinAPIEx.au3>
#include <Misc.au3>
#include <array.au3>
#include <pixelsearchex.au3>
global $shade=50, $Paused ; максимально 70
$timedown=64
;для 1366x768
global $x1=0
global $x2=0
global $y1=0
global $y2=0
				global $smeshenie1=0
				global $smeshenie2=1
;~ 0xCDCB5E
HotKeySet("{ins}", "Terminate")
;~ HotKeySet("{PgUp}", "PgUp")
;~ HotKeySet("{PgDn}", "PgDn")
;~ HotKeySet("{Ins}", "PgUp1")
;~ HotKeySet("{Del}", "PgDn1")
HotKeySet("{home}", "_Pause")
Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
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
#comments-start
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
		Opt("PixelCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
	Opt("MouseCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
	$shadeS=5
	$shadeS2=5
	$array=PixelSearchEx(0, $size[3]-100, $size[2], $size[3], 0xB3B4B3, $shadeS, 505, 1, $hWnd, $shadeS2)
	if not @error Then
		ConsoleWrite(' Координаты: '&$array[0]&' x '&$array[1]&@CRLF)
;~ 		MouseMove($array[0],$array[1]-2)
			global $x1=$array[0]
			global $x2=$array[0]+507
			global $y1=$array[1]-2+1
			global $y2=$array[1]-2+1
	Else
		ConsoleWrite(' Координаты не найдены'&@CRLF)
	EndIf
;~ sleep(4000)
;~ 1032x795
;~ 377-644
;~ 601


;~ 1198x979 (x0,9560546875)
;~ (-82x45)
;~ 483-794
;~ 777 (38) (0,9533742331288344)
;~ 1280x1024
#comments-end
_WinGetCoords()
$winacive=0
Opt("PixelCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
while 1
if WinActive ( "World of Warcraft" ) <> 0 then
	if $winacive=0 then
		sleep(500)
		_WinGetCoords()
		_Beep_YES()
		ConsoleWrite($x1&' '&$y1&' '&$x2&' '&$y2&@CRLF)
	EndIf
	$winacive=1

	$PixelFind=PixelSearch($x2,$y1,$x1,$y2,0xCDCB5E,$shade-5)
	if not @error and $PixelFind[0]<> $x1 and $PixelFind[0]<> $x2 then
	ConsoleWrite(@MIN&@SEC&' '&$PixelFind[0]&@CRLF)
	_click($PixelFind[0])
	ConsoleWrite(" Найден ЖЕЛТЫЙ вариант мерцания "&@CRLF)
	EndIf

	$PixelFind=PixelSearch($x2,$y1,$x1,$y2,0xFFFFFF,$shade)
	if not @error and $PixelFind[0]<> $x1 and $PixelFind[0]<>634 and $PixelFind[0]<> $x2 then
	ConsoleWrite(@MIN&@SEC&' '&$PixelFind[0]&@CRLF)
	_click($PixelFind[0])
	EndIf

	$PixelFind=PixelSearch($x2,$y1,$x1,$y2,0x77FFFB,$shade-5)
	if not @error and $PixelFind[0]<> $x1 and $PixelFind[0]<> $x2 then
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
	;смещение для поиска слева

	Switch $PixelCoords
		Case $x1-($Cell*$smeshenie1)+$Cell*0 To $x1+($Cell*$smeshenie2)+$Cell*0
		_Key(0x31)
		Case $x1-($Cell*$smeshenie1)+$Cell*1 To $x1+($Cell*$smeshenie2)+$Cell*1
		_Key(0x32)
		Case $x1-($Cell*$smeshenie1)+$Cell*2 To $x1+($Cell*$smeshenie2)+$Cell*2
		_Key(0x33)
		Case $x1-($Cell*$smeshenie1)+$Cell*3 To $x1+($Cell*$smeshenie2)+$Cell*3
		_Key(0x34)
		Case $x1-($Cell*$smeshenie1)+$Cell*4 To $x1+($Cell*$smeshenie2)+$Cell*4
		_Key(0x35)
		Case $x1-($Cell*$smeshenie1)+$Cell*5 To $x1+($Cell*$smeshenie2)+$Cell*5
		_Key(0x36)
		Case $x1-($Cell*$smeshenie1)+$Cell*6 To $x1+($Cell*$smeshenie2)+$Cell*6
		_Key(0x37)
		Case $x1-($Cell*$smeshenie1)+$Cell*7 To $x1+($Cell*$smeshenie2)+$Cell*7
		_Key(0x38)
		Case $x1-($Cell*$smeshenie1)+$Cell*8 To $x1+($Cell*$smeshenie2)+$Cell*8
		_Key(0x39)
		Case $x1-($Cell*$smeshenie1)+$Cell*9 To $x1+($Cell*$smeshenie2)+$Cell*9
		_Key(0x30)
		Case $x1-($Cell*$smeshenie1)+$Cell*10 To $x1+($Cell*$smeshenie2)+$Cell*10
		_Key(0xBD)
		Case $x1-($Cell*$smeshenie1)+$Cell*11 To $x1+($Cell*$smeshenie2)+$Cell*11
		_Key(0xBB)
		Case Else
		ConsoleWrite('координаты кнопки переданы неправильно '&@CRLF)
	EndSwitch
	sleep(100)
EndFunc

Func _WinGetCoords()
   $hWnd = WinWaitActive("World of Warcraft")
	For $i=0 to 70 ;поиск не белого и не черного пикселя, для определения загрузки изображения
	   $array=PixelSearch(25,25,50,50,0x808080,126)
	   if not @error then
;~ 			$col=PixelGetColor($array[0],$array[1])
;~ 		   ConsoleWrite($array[0]&' '&$array[1]&' '&hex($col,6)&@CRLF)
		   exitloop
	   endif
		sleep(100)
	Next
	sleep(1000) ;отладка
   $size = WinGetPos($hWnd)
   $xsize=$size[2]&'x'&$size[3]
;~    	Switch $xsize
;~ 		Case '1280x1024'
;~ 			global $x1=472
;~ 			global $x2=804
;~ 			global $y1=815
;~ 			global $y2=815
;~ 		Case '1032x795'
;~ 			global $x1=377
;~ 			global $x2=644
;~ 			global $y1=601
;~ 			global $y2=601
;~ 		Case '1198x979'
;~ 			global $x1=483
;~ 			global $x2=794
;~ 			global $y1=777
;~ 			global $y2=777

;~ 	EndSwitch
	ConsoleWrite(' Ваше текущее разрешение: '&$xsize&@CRLF)
	Opt("PixelCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
	Opt("MouseCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
	$shadeS=5
	$shadeS2=5
;~ 	$colors[3][2]=[[0xB3B4B3,505],[0x918B85
;~ 	For $i=0 to Ubound($colors) - 1
;~ #comments-start
	$exit=1
	if $xsize='1032x795' then
		ConsoleWrite(' Первый вариант поиска 1024*768'&@CRLF)
		$array=PixelSearchEx(0, $size[3]-100, $size[2], $size[3], 0xB3B4B3, $shadeS, 505, 1, $hWnd, $shadeS2) ;1024*768w
		if not @error Then
	;~ 		MouseMove($array[0],$array[1])
				;поиск по началу первой ячейки
				global $x1=$array[0]-4
				global $x2=$array[0]+507
				global $y1=$array[1]-2-3
				global $y2=$array[1]-2-3
				global $smeshenie1=-0.1
				global $smeshenie2=0.9

				ConsoleWrite(' Координаты: '&$array[0]&' x '&$array[1]&@CRLF)
				$exit=0
		Else
			if $xsize='1366x768' Then
				global $x1=171
				global $x2=674
				global $y1=729
				global $y2=729
				$exit=0
			Else
			$exit=1
			EndIf
		EndIf
	EndIf

	if $exit = 1 and $xsize='1278x789' Then
		ConsoleWrite(' Второй вариант поиска 1280*768 '&@CRLF)
		$array=PixelSearchEx(0, $size[3]-150, $size[2]/2, $size[3], 0x63593E, $shadeS, 506, 1, $hWnd, $shadeS2) ;1280*768 по глазу грифона
		if not @error Then
				;поиск по глазу грифона
				global $x1=$array[0]-8
				global $x2=$array[0]+507
				global $y1=$array[1]+19
				global $y2=$array[1]+19
				global $smeshenie1=0.5
				global $smeshenie2=1.5
				ConsoleWrite(' Координаты: '&$array[0]&' x '&$array[1]&@CRLF)
				$exit=0
		Else
					$exit=1
		EndIf
	EndIf
	if $exit = 1 and $xsize='1280x1024' Then
				global $x1=132
				global $x2=$x1+507
				global $y1=983-2
				global $y2=983-2
				global $smeshenie1=0.3
				global $smeshenie2=1.3
				$exit=0
				ConsoleWrite(' Координаты: '&'1280x1024'&@CRLF)
	EndIf
If $exit=1 then exit
;~ #comments-end
EndFunc

Func _Beep_NO()
	Beep(9000, 200)
EndFunc
Func _beep_YES()
	beep(500,100)
EndFunc

