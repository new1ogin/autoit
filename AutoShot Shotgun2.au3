#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=autoshot.ico
#AutoIt3Wrapper_Outfile=AutoShot - shotgun2 (zvezdochka).exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinAPI.au3>
#Include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <TabConstants.au3>
#Include <Icons.au3>
#Include <PixelSearchEx.au3>
#include <MouseOnEvent.au3>
#include <GUIConstantsEx.au3>
#include <GUIHotKey.au3>
#Include <HotKey.au3>

Opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 2)

global $command=0,$winx,$winy,$hWnD,$starttime,$MAP,$Paused,$Pos1x=0,$Pos1y=0,$xcor=1001,$ycor=1001,$timeout,$pricelx,$pricely,$4y,$sArray
global $getcolordcC,$getcolordcM,$getcolordcB,$getcolordcL,$schet=0,$posy,$schet2=0,$schet3=0,$sArray[2],$sArray,$BulletCoord=0,$Num_cycles=16,$timedown=24,$timeSleepMacros=660,$numDetect=0
global $coordbulletx,$coordbullety






Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=d:\vitaliy\programs\autoitv3.3.8.1\koda\form1_4.kxf
$Form1_2_1_1 = GUICreate("Autoshot Shotgun", 271, 238, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
GUISetOnEvent($GUI_EVENT_CLOSE, "_Pro_Exit")
$Tab1 = GUICtrlCreateTab(0, 0, 265, 185)
$TabSheet1 = GUICtrlCreateTabItem("Настройки")
$timeoutI = GUICtrlCreateInput("32", 156, 41, 97, 21)
GUICtrlSetTip(-1, "Можно увеличить для того чтобы не лагало,"&@CRLF&"или уменьшить чтобы выстрел происходил быстрее.")
$Label3 = GUICtrlCreateLabel("Задержка обновления", 12, 41, 118, 17)
GUICtrlSetTip(-1, "Можно увеличить для того чтобы не лагало,"&@CRLF&"или уменьшить чтобы выстрел происходил быстрее.")
$Checkbox1 = GUICtrlCreateCheckbox("Использовать макрос 'быстрая смена'?", 17, 73, 241, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$timeSleepMacrosI = GUICtrlCreateInput("620", 156, 97, 97, 21)
GUICtrlSetTip(-1, "Чем меньше значение тем быстрее вы будете делать следующий выстрел."&@CRLF&"Но слишком маленькая задержка приведёт к тому, чтопосле смены выстрела"&@CRLF&"не произойдёт. Подбирайте этот параметр для своего компьютера"&@CRLF&"используя тест макроса и если двигаясь по диагонали(W+D)"&@CRLF&"у Вас всё работает, значит проблем не возникнет.")
$timedownI = GUICtrlCreateInput("24", 156, 129, 97, 21)
GUICtrlSetTip(-1, "Можно вообще не менять. Слишком маленькая задержка"&@CRLF&"может привести к 'не проходящему' клику.")
$Label1 = GUICtrlCreateLabel("Задержка макроса", 12, 97, 102, 17)
GUICtrlSetTip(-1, "Чем меньше значение тем быстрее вы будете делать следующий выстрел."&@CRLF&"Но слишком маленькая задержка приведёт к тому, чтопосле смены выстрела"&@CRLF&"не произойдёт. Подбирайте этот параметр для своего компьютера"&@CRLF&"используя тест макроса и если двигаясь по диагонали(W+D)"&@CRLF&"у Вас всё работает, значит проблем не возникнет.")
$Label2 = GUICtrlCreateLabel("Задержка на клик", 12, 129, 97, 17)
GUICtrlSetTip(-1, "Можно вообще не менять. Слишком маленькая задержка"&@CRLF&"может привести к 'не проходящему' клику.")
$TabSheet2 = GUICtrlCreateTabItem("Клавиши")
$Label4 = GUICtrlCreateLabel("Старт Автошота в окне ПБ", 8, 32, 139, 17)
$Input1 = GUICtrlCreateInput("Input1", 160, 32, 97, 21)
$Input2 = GUICtrlCreateInput("Input2", 160, 56, 97, 21)
$Label5 = GUICtrlCreateLabel("Пауза", 8, 56, 35, 17)
$Input3 = GUICtrlCreateInput("Input3", 160, 80, 97, 21)
$Label6 = GUICtrlCreateLabel("Запустить тест макроса", 8, 80, 128, 17)
$Input4 = GUICtrlCreateInput("Input4", 160, 104, 97, 21)
$Label7 = GUICtrlCreateLabel("Уменьшить задержку макр.", 8, 104, 147, 17)
$Label8 = GUICtrlCreateLabel("Увеличить задержку макр.", 8, 126, 142, 17)
$Input5 = GUICtrlCreateInput("Input5", 160, 126, 97, 21)
$TabSheet3 = GUICtrlCreateTabItem("Информация")
GUICtrlCreateEdit("", 4, 33, 249, 145, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$WS_VSCROLL))
GUICtrlSetData(-1, StringFormat("Для запуска автошота:\r\n-Установте третий прицел(жирная точка)\r\n-В окне ПБ нажмите клавишу Insert,\r\nили на звездочку, на доп. клавиатуре\r\n-Если вы слышали короткий звук, и\r\nвылезло окошко "&Chr(39)&"Отклонение успешно.."&Chr(39)&"\r\nзначит автошот будет работать\r\n-Если вы услышали длинный высокий звук\r\nпопробуйте ещё раз чуть позже\r\n\r\nДля работы макроса:\r\n-Вы можете настроить параметры смены,\r\nдля более быстрой стрельбы под себя.\r\n-Для определения задержки макроса\r\nиспользуйте в игре клавишу PageDown.\r\n-Наведите мышью на параметры, для их\r\nподробного описания.\r\n\r\nНастройки\r\n-Вы можете выбрать горячие клавиши\r\nдля работы Автошота на вкладке\r\n"&Chr(39)&"Клавиши"&Chr(39)&".\r\n-Для получения информации о настройках\r\nНаведите мышью на параметры, для их\r\nподробного описания.\r\n\r\n"))
GUICtrlCreateTabItem("")
$Button1 = GUICtrlCreateButton("ОК", 8, 200, 75, 25)
GUICtrlSetOnEvent(-1, "_apply")
$Button2 = GUICtrlCreateButton("Пауза", 96, 200, 75, 25)
$Button3 = GUICtrlCreateButton("Выход", 184, 200, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###






While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

Func _Pro_Exit()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		Sleep(100)
		If $trayP = 1 Then TrayTip("Подсказка", "Пауза", 1000)
	WEnd
	ToolTip("")
EndFunc   ;==>_Pause


Func _apply()

$timeout=GUICtrlRead($timeoutI)
$timeSleepMacros=GUICtrlRead($timeSleepMacrosI)
$timedown=GUICtrlRead($timedownI)


EndFunc



Func _DetectWindow_and_start()
	$numDetect+=1
	;получение размера рабочего элемента окна
	$hWnD = WinGetHandle("[ACTIVE]")
	$sControl = ControlGetFocus($hWnD)
	$aPos = ControlGetPos($hWnD, "", $sControl)
	$winx = $aPos[2]
	$winy = $aPos[3]

	;определение ширины окна и расчёт поправки координаты x
	Dim $coord[2]
	$Xcoordinat_detected_YES = 0
	$getcolor = 0
	ConsoleWrite($winx&'  '&$winy&@CRLF)

	;Определение клика мыши и кнопки R (они которые могут изменить кол-во патронов)
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "_Mouse")
	;~ _HotKeyAssign(0x52, '_r',$HK_FLAG_NOBLOCKHOTKEY)


	;рабочий поиск отклонений - до боя в меню
	$coord = PixelSearch(0, 0, $winx, $winy, 0x2A344D, 10, 1, $hWnD)
;~ 	If Not @error Then $getcolor = Hex(PixelGetColor($coord[0] + 1, $coord[1], $hWnD), 6)
;~ 	If Not @error And $getcolor = "D9E0E7" Then
	If Not @error and $coord[0]<100 and $coord[1]<100 Then
		$Xcoordinat_detected_YES = 1
		$xcor = $coord[0]
		$ycor = $coord[1]
		if $xcor<>1001 or $ycor<>1001 then
			TrayTip("Подсказка", 'Отклонение в координатах успешно установленно !' & $xcor&'  '&$ycor, 1000)
			Beep(1000, 200)
			sleep(1500)
		Else
			sleep(1500)
			if $numDetect<5 then _DetectWindow_and_start()
		EndIf


	Else
		;Поиск отклонений в игре по плюсику на карте
;~ 		$xcor = 0
		$Array=PixelSearchEx(0, 0, $winx, $winy, 0x9C9A9C, 1, 13, 1, $hWnD)
		if @error then
		TrayTip("Подсказка", "Отклонение в координатах не установленно :(", 1000)
		Beep(3500,900)
		sleep(1500)
		endif
		$xcor = $Array[0] -135
		$ycor = $Array[1] -170
		$Xcoordinat_detected_YES = 1
		if $xcor<>1001 or $ycor<>1001 then
			TrayTip("Подсказка", 'Отклонение в координатах успешно установленно !' & $xcor&'  '&$ycor, 1000)
			Beep(1000, 200)
			sleep(1500)
		Else
			sleep(1500)
			if $numDetect<5 then _DetectWindow_and_start()
		EndIf

	EndIf

ConsoleWrite($xcor&'  '&$ycor&@CRLF) ;Отправка в консоль отклонений координат

if $ycor<>0 then
	$4y=($winy*0.0102)
Else
	$4y=0
EndIf

;расчёт положения прицела
$pricelx=Round (($winx/2)-$xcor) + $xcor
$pricely=Round (($winy/2)-$ycor+$4y) + $ycor
ConsoleWrite($pricelx&'  '&$pricely&@CRLF)
ConsoleWrite($hwnd&@CRLF)

;запуск соответствующего алгоритма Автошота
if $Xcoordinat_detected_YES = 1 Then
	if  GUICtrlRead($CheckBox1) = 1 then
		_func2()
	Else
		_func0()
	EndIf
Else
		TrayTip("Подсказка", "Отклонение в координатах не установленно :(", 1000)
		Beep(3500,900)
		sleep(1500)
EndIf

 _Ctrl_Win()

EndFunc


; (ОТ НЕЁ ПРИШЛОСЬ ОТКАЗАТЬСЯ ИЗ-ЗА МОИХ НЕПОНЯТНЫХ КОСЯКОВ) функция поиска последней пули в обойме, и автошота и запуска макроса в случае чего.
func _func1()

while 1

$sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,0,1,$hWnD)
;~ $sArray=pixelsearch($winx, 0,0 , $winy,0xABA8A3,0,1,$hWnD)
;~ $sArray=pixelsearch(130,24, 130,24,0x394051,1,1,$hWnD)
if @error then
	ConsoleWrite('No'&@CRLF)
Else
	$BulletCoord=1
	$coordbulletx=$sArray[0]
	$coordbullety=$sArray[1]
EndIf

for $r=0 to $Num_cycles						;ИЗМЕНИТЬ ЗНАЧЕНИЕ ДЛЯ АВТОМАТОВ!!!!!!!!!!!!!!

$getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
;~ $getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)
IF $getcolorL = 'FFFFFF' Then
sleep(64)
_func1()
endif

$getcolorLs=StringLeft ( $getcolorL, 2 );ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ

;~ if $getcolorL = 0xFF0000 Then
;~ if $getcolorL = 'FF0000' Then
if $getcolorLs = 'FF' Then  ;ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
	MouseDown ( "left" )
	sleep(50)
	if $BulletCoord=1 Then
		$BulletCoord=0
		$timeccle=TimerInit()
		while 1
	$getcolorBullet = PixelGetColor($coordbulletx,$coordbullety, $hWnD)
	if $getcolorBullet<>0xABA8A3 then _macros()
	if TimerDiff($timeccle)>500 then ExitLoop
		wend
	endif
	Mouseup ( "left" )
	_func1()
else
	sleep ($timeout)
endif
next
wend
endfunc

;прямая функция только атошота, проверка наличия красного прицела и выстрел
func _func0()

while 1

	$getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)

	if $getcolorL = 0xFF0000 Then
		MouseDown ( "left" )
		sleep($timedown)
		Mouseup ( "left" )
	else
		sleep ($timeout)
	endif

wend

endfunc


;(НА ДАННЫЙ МОМЕНТ ИСПОЛЬЗУЕМАЯ И ДОРОБАТЫВАЕМАЯ) Функция автошота с макросом
func _func2()
;~ $i=0
_shot()

;~ while 1
;~ $sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,0,1,$hWnD)
;~ 	;~ if not @error then ConsoleWrite('Est1-'&$sArray[0]&'-'&$sArray[1]&'  ')
;~ 	;~ $sArray=pixelsearch($winx, 0,0 , $winy,0xABA8A3,0,1,$hWnD)
;~ 	;~ $sArray=pixelsearch(130,24, 130,24,0x394051,1,1,$hWnD)
;~ if @error then
;~ 	;~ 	ConsoleWrite('No'&@CRLF)
;~ Else
;~ 	;~ 	$BulletCoord=1
;~ $coordbulletx=$sArray[0]
;~ $coordbullety=$sArray[1]
;~ _shot()
;~ 	;~ 	ConsoleWrite('Est2 '&$sArray[0]&'  '&$sArray[1]&'  ')
;~ EndIf

;~ 	;~ if not @error then

;~ 	;~ endif

;~ wend
endfunc

;Функция макроса быстрой смены
func _macros()

_WinAPI_Keybd_Event(0x33, 0) ;клавиша 3
sleep($timedown)
_WinAPI_Keybd_Event(0x33, 2) ;клавиша 3
;~ sleep(124)
_WinAPI_Keybd_Event(0x31, 0) ;клавиша 1
sleep($timedown)
_WinAPI_Keybd_Event(0x31, 2) ;клавиша 1
Mouseup ( "left" )
sleep($timeSleepMacros)											;задержка макроса

endfunc

;Функция теста макроса, для определения оптимального значения задержки
func _testmacros($mode=0)

while 1
	MouseDown ( "left" )
	sleep($timedown)
	_macros()
wend
EndFunc

;Функция Удержания левой клавиши CTRL (присядания) и перехода на другое окно.
func _Ctrl_Win()

	;~ ;зажатие и отжатие клавиши CTRL
	_WinAPI_Keybd_Event(0xA2, 0)
	;~ sleep(1500)
	;~ _WinAPI_Keybd_Event(0xA2, 2)

	;~ ;зажатие и отжатие клавиши Win
;~ 	_WinAPI_Keybd_Event(0x5B, 0)
;~ 	sleep(64)
;~ 	_WinAPI_Keybd_Event(0x5B, 2)
WinActivate("максим")

EndFunc


;Функция автошота для Func2
func _shot()

while 1
;~ 	for $r=0 to $Num_cycles+55						;ИЗМЕНИТЬ ЗНАЧЕНИЕ ДЛЯ АВТОМАТОВ!!!!!!!!!!!!!!
;~ 	$FirstShot=1

;~ $getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
$getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)


if $getcolorL = 0xFF0000 Then
	MouseDown ( "left" )
	sleep($timedown)
;~ 	if $FirstShot=1 then
;~ 		$FirstShot=0
		_macros()
		_func2()
;~ 	Else
;~ 		$getcolorBullet = PixelGetColor($coordbulletx,$coordbullety, $hWnD)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $getcolorBullet = ' & hex($getcolorBullet,6) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 		if $getcolorBullet=0xABA8A3 then _macros()
;~ 		_func2()
;~ 	EndIf
	Mouseup ( "left" )
	_func2()

else
	sleep ($timeout)
endif

;~ consolewrite($getcolorLs& '  ')
;~ next
wend

endfunc

;функция отслеживания клика мыши
func _Mouse()
	sleep($timeSleepMacros)
	if  GUICtrlRead($CheckBox1) = 1 then
		_func2()
	Else
		_func0()
	EndIf

EndFunc

;~ func _r()
;~ 	$KeyR=TimerInit()
;~ 	6700
;~
;~ EndFunc
