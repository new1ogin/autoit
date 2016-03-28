#include <WinAPI.au3>
#include <WinAPIEx.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <ScreenCapture.au3>

;предрасчёты и переменные для функции

	;получение размера рабочего элемента окна
	$hWnD = WinGetHandle("[ACTIVE]")
	$sControl = ControlGetFocus($hWnD)
	$aPos = ControlGetPos($hWnD, "", $sControl)
	$winx = $aPos[2]
	$winy = $aPos[3]



   Global $hTimer,$pricelx,$pricely,$coordbullet[2],$q=0

$maxy = 1024
$maxx = 1280
$minx = 99
$miny = 99

$timedetect=2000 ;минимальное время запоминания изменений
$minprocent=15 ;минимальный процент изменений
$detect=0 ;эта переменная станет равна 1 в случае, если изменения будут больше чем минимальные

$step=10
$numberblockx=Floor(($maxx-$minx) /$step)
$numberblocky=Floor(($maxy-$miny) /$step)
$numberblocks=$numberblockx*$numberblocky
$numberC=($timedetect/($numberblocks*0.3))+10

Global $blocks[$numberblockx][$numberblocky], $blocks2[$numberblockx][$numberblocky], $Cblocks[$numberblockx][$numberblocky]
;~ ConsoleWrite("X : "&$numberblockx& @LF)
;~ ConsoleWrite("X : "&$numberblocky& @LF)


$summ=0

 ;ОТЛАДКА
 $summ1=0
 $summ2=0




;сюда можно записать скалько раз необходимо проверить
$number_prohod =  100

global $iDiff[$number_prohod+2]

$i247=0
$hTimer = TimerInit()
for $i=1 to $number_prohod
_test_function()
$iDiff[$i] = TimerDiff($hTimer)
$i247=$iDiff[$i]
next


;~ $s247 = 0; Буфер для хранения промежуточных сумм
;~ ;------Вычисление суммы всех элементов
;~ For $i = 1 to $number_prohod
;~    $s247 = $s247 + $iDiff[$i]
;~ Next
;---------------------------------------------------------
$iDiff_= $i247 / $number_prohod; Среднее значение


MsgBox(0, "скорость" , 'скорость первого выполнения ' &$iDiff[1] & @CR & 'средняя скорость '& $iDiff_) ;отладка






	;рабочий поиск отклонений - до боя в меню
	$coord = PixelSearch(0, 0, $winx, $winy, 0x2A344D, 10, 1, $hWnD)
;~ 	If Not @error Then $getcolor = Hex(PixelGetColor($coord[0] + 1, $coord[1], $hWnD), 6)
;~ 	If Not @error And $getcolor = "D9E0E7" Then
	If Not @error and $coord[0]<100 and $coord[1]<100 Then
		$Xcoordinat_detected_YES = 1
;~ 		TrayTip("Подсказка", 'Отклонение в координатах успешно установленно !' & $xcor&'  '&$ycor, 1000)
		Beep(1000, 200)
		sleep(1500)
		$xcor = $coord[0]
		$ycor = $coord[1]
	Else
;~ 		$xcor = 0
		$Array=PixelSearch(0, 0, $winx, $winy, 0x9C9A9C, 1, 1, $hWnD)
		if @error then
;~ 		TrayTip("Подсказка", "Отклонение в координатах не установленно :(", 1000)
		Beep(9000, 300)
		sleep(1500)
		endif
;~ 	$Array[0] = x, $Array[1] = y
;~ 	0x9C9A9C
		$xcor = $Array[0] -135
		$ycor = $Array[1] -170
		$Xcoordinat_detected_YES = 1
;~ 		TrayTip("Подсказка", 'Отклонение в координатах успешно установленно !' & $xcor&'  '&$ycor, 1000)
		Beep(1000, 200)
		sleep(1500)
	EndIf
;~ ConsoleWrite($xcor&'  '&$ycor&@CRLF)
if $ycor<>0 then
	$4y=($winy*0.0102)
Else
	$4y=0
EndIf
$pricelx=Round ($winx/2)
$pricely=Round ($winy/2)
;~ ConsoleWrite($pricelx&'  '&$pricely&@CRLF)
;~ ConsoleWrite($hwnd&@CRLF)
$coordbullet[0]=500
$coordbullet[1]=500
global $sArray[2]=[500,500]
$sArray[0]=500
$sArray[1]=500
Global	$coordbulletx=500,	$coordbullety=500


;тестируемая функция
Func _test_function()




;~     for $t=0 to $numberblocky-1

;~    $stroka=$t
;~    $ytop=$stroka*$step
;~    $ybottom=$stroka*$step+$step

;~ 	  for $i=0 to $numberblockx-1
;~
;~ 	  $stolbec=$i
;~ 		 if $Cblocks[$i][$t]<>1 then
;~ 			$xleft=$stolbec*$step
;~ 			$xright=$stolbec*$step+$step
;~ 			$blocks[$i][$t]=PixelChecksum ( $xleft, $ytop, $xright, $ybottom, 2)
;~ 			$summ1=$summ1+1 ;отладка
;~ 		 Else
;~ 		 EndIf
;~ 	  next
;~    next




;~ for $i=0 to 999
;~ $pricelx=500
;~ $pricely=500
;~ $getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1), 6);ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
;~ 104 118 44 88
;~ 55 75 80   72
;~ $getcolorL = PixelGetColor($pricelx-1, $pricely-1)
;~ 43 62 95 93
;~ 42 61 73 59

;~ next
;~ for $i=0 to 999
;~ $getcolorL=Hex(0xFFFFFF, 6)
;~ $getcolorLs=StringLeft ( $getcolorL, 2 )
;~ next


;~ dim $coordbulletx=500,	$coordbullety=500
;~ 	$getcolorBullet = PixelGetColor($coordbulletx,$coordbullety, $hWnD)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $getcolorBullet = ' & hex($getcolorBullet,6) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 	ConsoleWrite ('$getcolorBullet = '&$getcolorBullet&@CRLF)
;~ 	if $getcolorBullet=0xABA8A3 then $i=1

;~ 		$getcolorBullet = PixelGetColor($sArray[0],$sArray[1], $hWnD)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $getcolorBullet = ' & hex($getcolorBullet,6) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 		if $getcolorBullet=0xABA8A3 then $i=1

;режим простоя
;~ окно autoit
;~ 1)7.4 2)8.4
;~ окно игры
;~ 1,2) 8,5
;~ 1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
;режим игры
;~ окно autoit
;~ 1)30.459 2)11.65
;~ окно игры
;~ 1,2)~
;~ _WinAPI_Keybd_Event(0x31, 0)
;~ traytip('','Клавиша "1"',500)
;~ sleep(100)
;~ _WinAPI_Keybd_Event(0x31, 2)



;режим простоя
;~ окно autoit
;~ 1)7.4 2)8.4
;~ окно игры
;~ 1,2) 8,5
;~ 1111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111111
;режим игры
;~ окно autoit
;~ 1)33.459 2)20
;~ окно игры
;~ 1,2)~
Send("{1 down}")
sleep(100)
Send("{1 up}")




;~ 143 138
;~ 146 132
;~ 20,4
;~ 19,2
;~ 188
;~ 190

;~ без кликов
;~ 67 77 198
;~ 6 7 19
;~ вмексте с кликами
;~ 173 184 303
;~ 18 18 30
EndFunc


func _test2()

while 1
if $q>1000 then ExitLoop
;~ ConsoleWrite($q& ' ')
pixelsearch(1005, 720, 915, 720,0xABA8A3,1,1,$hWnD)
;~ for $r=0 to 10
;~ $i+=1
;~ зеленый 0x61FF40
;~ красный 0xFF573B 0xFF1617 0xFF0000

$getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
;~ $getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)
IF $getcolorL = 'FFFFFF' Then
;~ sleep(64)
;~ _func1()
endif
;~ $getcolorL = Hex(PixelGetColor(523 + $xcor, 484 + $ycor), 6)
;~ (1030/2)-$xcor       (793/2)-$ycor+8
;~ 512 383
;~ 576 432

;~ 1024  768
;~ 0  0
;~ 512  392
;~ 516 389
;~ consolewrite($getcolorL& '  ')
;~ 0x00050494
$getcolorLs=StringLeft ( $getcolorL, 2 );ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ

;~ if $getcolorL = 0xFF0000 Then
;~ if $getcolorL = 'FF0000' Then
if $q=500 or $q=1000 Then  ;ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
;~ 	consolewrite('SHOT'&@CRLF)
	MouseDown ( "left" )
	sleep(50)
;~ 	consolewrite($coordbullet[0]& '  '&$coordbullet[1])
	$getcolorBullet = PixelGetColor($coordbullet[0],$coordbullet[1], $hWnD)
	if $getcolorBullet=0xABA8A3 then $r=1 ;_macros()
	Mouseup ( "left" )
;~ 	consolewrite($getcolorL& '  ')
else
;~ 	sleep (4)
endif
;~ consolewrite($getcolorL& '  ')
;~ consolewrite($getcolorLs& '  ')

$q=$q+1
;~ next
wend





EndFunc