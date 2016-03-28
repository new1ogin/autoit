#include <WinAPI.au3>
#include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Icons.au3>
#region
#AutoIt3Wrapper_Res_File_Add="CrashXP.bmp", 2, 200
#endregion

Opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 2)

Global $hWnD, $sControl, $xcor, $ycor, $nstart, $sleepclick, $loc
Global $wait_for_battle = 1 ;Пауза в поиске и боях 1х1 для ожидания группового боя
$sleepclick = 1000
;~ AutoItSetOption("WinTitleMatchMode",1)
;~ $Title = 'Челябинск 2013 - Мертвая зона' ; The Name Of The Game...
;~ $Full = WinGetTitle ($Title) ; Get The Full Title..
;~ $HWnD = WinGetHandle ($Full) ; Get The Handle

HotKeySet("{ScrollLock}", "Terminate")
Func Terminate()
	TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

HotKeySet("{F1}", "_doit") ;собирает вещи на первой локации
HotKeySet("{F2}", "_doit") ;собирает вещи на второй локации
HotKeySet("{F3}", "_F5_Reload") ;играет в одиночные бои
HotKeySet("{F4}", "pause") ;играет в одиночные бои

Func pause()
	While 1
		TrayTip("Подсказка", "Пауза", 100)
		Sleep(10000)
	WEnd
EndFunc   ;==>pause


Opt("GUIOnEventMode", 1)
#region ### START Koda GUI section ### Form=C:\TEMP\autoitv3.3.8.1\Form1_2.kxf
$Form1_2 = GUICreate("Бот на Мертвая зона в ВК", 413, 395, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
$sleepclick = GUICtrlCreateInput("1000", 280, 264, 121, 21)
$Label1 = GUICtrlCreateLabel("Если хотите изменить размер окна то делайте это так, чтобы", 8, 128, 319, 17)
$Label2 = GUICtrlCreateLabel("перейдите на вторую локацию и нажмите клавишу «F2»", 8, 24, 288, 17)
$Label3 = GUICtrlCreateLabel("Введите задержку между кликами в (мс)", 8, 264, 213, 17)
$Bossnumber = GUICtrlCreateCombo("Хохотун", 256, 296, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Близняшко|Мясник")
$Label4 = GUICtrlCreateLabel("Выберите Босса для группового боя", 8, 296, 190, 17)
$WorkEnergynumber = GUICtrlCreateCombo("Стройка", 256, 328, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Не использовать")
$Label5 = GUICtrlCreateLabel("Место для использования энергии", 8, 328, 182, 17)
$Label6 = GUICtrlCreateLabel("верхний угол приложения был виден", 8, 144, 191, 17)
$Label7 = GUICtrlCreateLabel("Откройте приложение в отдельном окне (не развёрнутом),", 8, 8, 304, 17)
$Label8 = GUICtrlCreateLabel("На данный момент бот выполняет следующие функции:", 8, 56, 289, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$Label9 = GUICtrlCreateLabel("1.Бои с появившимися на 1 и 2 локации громилами, зомби и сбор предметов", 8, 72, 399, 17)
$Label10 = GUICtrlCreateLabel("2.Принятие участия в групповых боях и нападении на боссов", 8, 88, 315, 17)
$Label11 = GUICtrlCreateLabel("3.Выполнение работы используя энергию", 8, 104, 218, 17)
$Label12 = GUICtrlCreateLabel("Это окно вы можете просто свернуть.", 8, 40, 198, 17)
$Button1 = GUICtrlCreateButton("Выход", 143, 360, 105, 25)
GUICtrlSetOnEvent(-1, "_Pro_Exit")

$Pic2 = GUICtrlCreatePic("C:\TEMP\autoitv3.3.8.1\primer.bmp", 8, 160, 204, 82)
$Pic = GUICtrlCreatePic("", 8, 160, 204, 82)
$hInstance = _WinAPI_GetModuleHandle(0)
$hBitmap = _WinAPI_LoadBitmap($hInstance, 200)
_SetHImage($Pic, $hBitmap)
_WinAPI_DeleteObject($hBitmap)
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func _Pro_Exit()
	Exit
EndFunc   ;==>_Pro_Exit


Func _whats_wrong()

	$B_Close_Wrong = 0
	$B_Close_Wrong = PixelSearch(490 + $xcor, 340 + 77 + $ycor, 545 + $xcor, 350 + 77 + $ycor, 0x6EAD55, 1, 1, $hWnD)
	If $B_Close_Wrong <> 0 Then _Click($B_Close_Wrong[0] - $xcor, $B_Close_Wrong[1] - 77 - $ycor)
	If $B_Close_Wrong <> 0 Then _F5_Reload()


EndFunc   ;==>_whats_wrong


Func _Click($cx, $cy)
;~    if $cx<$centerx*2 AND $cy<$centery*2 and $cx>0 and $cy>0 then

;~    Mousemove($cx, $cy+77+$ycor)
	If $cx <> 360 Or $cx <> 482 Then
		Sleep(Random($sleepclick, $sleepclick * 1.5, 1))
	Else
		Sleep(Random(0, 10, 1))
	EndIf

;~ ControlFocus ( $hWnD, "", '' )
;~ 			$mousePos = MouseGetPos()
;~ 			MouseMove ( $cx+$xcor, $cy+77+$ycor ,0 )
;~ sleep(64)
	ControlClick($hWnD, '', $sControl, "left", 1, $cx + $xcor + Random(-4, 4, 1), $cy + $ycor + Random(-4, 4, 1))
;~       ControlClick ($hWnD, '','', "left", 1, $cx+random(-4,4,1), $cy+random(-4,4,1))

;~ 			 MouseMove ( $mousePos[0], $mousePos[1] ,0 )\
;~ ;traytip('','локация '&$loc,1000)
;~ Sleep(500)
;~ ;traytip('','X: '&$cx+$xcor+random(-4,4,1)&'   Y: '&$cy+$ycor+random(-4,4,1),1000)
;~ Sleep(1000)

;~    Else
;~    EndIf
EndFunc   ;==>_Click

Func _CloseClick()

	$B_Close_Wrong2 = 0
	$B_Close_Wrong2 = PixelSearch(0, 0, 920, 790, 0xFF7425, 0, 1, $hWnD)
	If Not @error Then
		$getcol1 = Hex(PixelGetColor($B_Close_Wrong2[0], $B_Close_Wrong2[1] + 1, $hWnD), 6)
		$getcol2 = Hex(PixelGetColor($B_Close_Wrong2[0], $B_Close_Wrong2[1] + 2, $hWnD), 6)
		If $getcol1 = 'FF7425' And $getcol2 = 'FF7425' Then _Click($B_Close_Wrong2[0] + 6, $B_Close_Wrong2[1] + 6 - 77)
	EndIf

EndFunc   ;==>_CloseClick

Func _local_detect($Targetloc = 0)
	;определение локации
	Dim $locLD
;~    $loc=2
	Sleep(1500)
	$noloc = 0
	$noloc = $loc
	$getcolorL = Hex(PixelGetColor(776 + $xcor + 5, 133 + 77 + $ycor, $hWnD), 6)
	If $getcolorL = '615B4D' Then $locLD = 1
	If $getcolorL = '171C08' Then $locLD = 2
	Global $loc = $locLD
;~    if $Targetloc=0 then
;~ 	  if $loc=0 then $loc=$noloc ;возврашение к предыдущему состоянию локации на случай ошибки
;~ 	  Return $loc
;~    Else
;~ 	  if $Targetloc=1 then _Change_loc(1)
;~ 	  if $Targetloc=2 then _Change_loc(2)
;~ 	  endif
	;traytip('','локация в функции локал детект '&$loc,1000)
	If $nstart = 0 Then
		If @HotKeyPressed = "{F1}" Then $loc = 1
		If @HotKeyPressed = "{F2}" Then $loc = 2
		$nstart = 1
	EndIf
	If $loc = 0 Then $loc = $noloc ;возврашение к предыдущему состоянию локации на случай ошибки

	TrayTip("Подсказка", 'Вы на ' & $loc & '-й локации', 100)
	Sleep(1500)
	Return $loc
EndFunc   ;==>_local_detect



Func _doit()
	$nstart = 0

;~ 	   msgbox(0,'',$getcolorL)
;~ 	  msgbox(0,'',$loc)



	;получение размера рабочего элемента окна
	$hWnD = WinGetHandle("[ACTIVE]")
	$sControl = ControlGetFocus($hWnD)
	$aPos = ControlGetPos($hWnD, "", $sControl)
;~     $aPos = ControlGetPos($hWnd, "", "")
	$winx = $aPos[2]
	$winy = $aPos[3]

	$x1 = 0
	$y1 = 0

	;определение ширины окна и расчёт поправки координаты x
	Dim $coord[2]
	$Xcoordinat_detected_YES = 0
	$xcor = 0
	$getcolor = 0
	$coord = PixelSearch(140, 125, 700, 156, 0xF2F2F2, 10, 1, $hWnD)
	If Not @error Then $getcolor = Hex(PixelGetColor($coord[0] + 1, $coord[1], $hWnD), 6)

	If Not @error And $getcolor = "D9E0E7" Then
		TrayTip("Подсказка", 'Отклонение в координате "X" успешно установленно', 100)
		$xcor = $coord[0] - 150
		$Xcoordinat_detected_YES = 1
;~    msgbox(0,'',$coord[0])
	Else
		TrayTip("Подсказка", "Отклонение в координатах не установленно :(", 100)
		$xcor = 0
	EndIf

	;определение ширины окна и расчёт поправки координаты Y
	Dim $coord2[2]
	$ycor = 0
	$getcolor = 0
	$coord2 = PixelSearch($winx / 2, 0, ($winx / 2) + 1, $winy, 0xDAE1E8, 1, 1, $hWnD)
	If Not @error Then $getcolor = Hex(PixelGetColor($coord2[0], $coord2[1] + 1, $hWnD), 6)
;~ msgbox(0,'',$coord2[1] & 'wdtn следующего пикселя: ' & $getcolor);отладка
	If Not @error And $getcolor = "F7F7F7" Then
		If $Xcoordinat_detected_YES = 1 Then
			TrayTip("Подсказка", 'Отклонение в координате "X" успешно установленно = ' & $xcor & @CR & 'Отклонение в координате "Y" успешно установленно = ' & $ycor, 1000)
		Else
			TrayTip("Подсказка", 'Отклонение в координате "Y" успешно установленно', 1000)
		EndIf
		$ycor = $coord2[1] - 147
;~    msgbox(0,'',$coord2[1]);отладка
	Else
		TrayTip("Подсказка", "Отклонение в координате Y не установленно :(", 1000)
		$xcor = 0
	EndIf

	Sleep(1000)

;~ $loc=_local_detect(0)

;~ ;traytip('','локация возвращённая '&$loc,1000)
;~ Sleep(1500)
;~ sleep(3000);отладка


	;ОТЛАДКА
;~ MsgBox(0, "X и Y равны:", WinGetTitle ($hWnd))
;~ 	If Not @error Then
;~ 	   $getcolor=PixelGetColor ( $coord[0]+1 , $coord[1] , $hWnd )
;~     MsgBox(0, "X и Y равны:", $coord[0] & "," & $coord[1] & '  getcolor=' & Hex($getcolor, 6))
;~  Else
;~ 	MsgBox(0, "erorr","erorr")
;~ EndIf



	;координаты атаки в бою
	Global $cx_attack = 360, $cy_attack = 470
;~ 	_Click($cx_attack, $cy_attack)
	;координаты использования животного в бою
	Global $cx_helper = 700, $cy_helper = 470
;~ 	_Click($cx_helper, $cy_helper)


	;координаты вещей на локации мёртвая окраина
	Global $cx_loc[10][6 + 1], $cy_loc[10][6 + 1]
	$cx_loc[1][1] = 665
	$cy_loc[1][1] = 100
	$cx_loc[1][2] = 370
	$cy_loc[1][2] = 300
	$cx_loc[1][3] = 630
	$cy_loc[1][3] = 370
	$cx_loc[1][4] = 440
	$cy_loc[1][4] = 525
	$cx_loc[1][5] = 650
	$cy_loc[1][5] = 570
	$cx_loc[1][6] = 270
	$cy_loc[1][6] = 650
	;координаты вещей на локации спальный район
	$cx_loc[2][1] = 500
	$cy_loc[2][1] = 120
	$cx_loc[2][2] = 759
	$cy_loc[2][2] = 135
	$cx_loc[2][3] = 817
	$cy_loc[2][3] = 355
	$cx_loc[2][4] = 407
	$cy_loc[2][4] = 290
	$cx_loc[2][5] = 750
	$cy_loc[2][5] = 520
	$cx_loc[2][6] = 400
	$cy_loc[2][6] = 690
;~ 	_Click($cx_loc1_3, $cy_loc1_3)

	Global $Q = 12000
	_local_detect()
	_thinks_loc()


;~ 		 $B_Close = 0
;~ 		 $B_Close = PixelSearch ( 460, 560+77+$ycor, 470, 570+77+$ycor, 0x6EAD55,1,1, $hWnd )
;~ 	  if $B_Close<>0 then
;~ 	MsgBox(0, 'сообщение', ' вы в бою ')
;~ 	  Else
;~ 	  EndIf


;~ 	;Отличительная черта ведения боя
;~ 	$getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
;~ 	if $getcolor_attack='A7A7A7' then MsgBox(0, 'сообщение', ' вы в бою ' & $i)
;~
;~
;~ 	for $i=1 to 2
;~     _Click($coordx, $coordy)
;~    sleep(10)
;~    next


EndFunc   ;==>_doit


;выбирает вещи
Func _thinks_loc()

	TrayTip('', 'локация в поиске вещей ' & $loc, 1000)
	Sleep(1500)

	For $thin = 1 To $Q
		$aRandom = _RandomEx(1, 6, 1, 6, 1)
;~ 						$hTimer = TimerInit()
		For $i = 1 To 6

			TrayTip("Подсказка", "я ищю вещи", 100);ОТЛАДКА
			_local_detect()
			_pause_battle() ;Пауза в поиске и боях 1х1 для ожидания группового боя
			_whats_wrong()

			$t = $aRandom[$i]
			_Click($cx_loc[$loc][$t], $cy_loc[$loc][$t])
			$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 444 + 77 + $ycor, $hWnD), 6)
			If $getcolor_attack = 'A7A7A7' Then $i = 6 ;ЗАМЕТЬ ЭТО МЕСТО!!!!!!!ЗАМЕТЬ ЭТО МЕСТО!!!!!!!ЗАМЕТЬ ЭТО МЕСТО!!!!!!!
			;закрывает сообщение о победе
			$B_Close = 0
			$B_Close = PixelSearch(460 + $xcor, 560 + 77 + $ycor, 470 + $xcor, 570 + 77 + $ycor, 0x6EAD55, 1, 1, $hWnD)
			If $B_Close <> 0 Then _Click($B_Close[0] - $xcor, $B_Close[1] - 77 - $ycor)
			;Смотрит идёт ли бой и переходит на бой
			$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
			If $getcolor_attack = 'A7A7A7' Then _fight()
;~ 		 MsgBox(0, 'сообщение', ' вы в бою ' & $getcolor_attack) ;ОТЛАДКА
			;условие неокончания поиска вещей
;~ 						$iDiff = TimerDiff($hTimer) ;$hTimer = TimerInit()
;~ 						if $iDiff<15000 then
;~ 						   $Q=1
;~ 						else
;~ 						   exit ; окончание поиска вещеё
;~ 						endif
		Next
	Next

EndFunc   ;==>_thinks_loc

Func _fight()
	TrayTip("Подсказка", "Я в бою!", 100) ;ОТЛАДКА
	$hTimer_f = TimerInit() ;замер времени на случай ошибки и "вечного боя"


	_Click($cx_helper, $cy_helper)
	Sleep(10)
	_Click($cx_helper, $cy_helper)
	Sleep(10)
	_Click($cx_helper, $cy_helper)
	Sleep(10)
	_Click($cx_attack, $cy_attack)
	Sleep(100)

	If TimerDiff($hTimer_f) > 600000 Then Return ;замер времени на случай ошибки и "вечного боя"

	;закрывает сообщение о победе
	$B_Close = 0
	$B_Close = PixelSearch(460 + $xcor, 560 + 77 + $ycor, 470 + $xcor, 570 + 77 + $ycor, 0x6EAD55, 10, 1, $hWnD)
	If $B_Close = 0 Then
		_fight()
	Else
		_Click($B_Close[0] - $xcor, $B_Close[1] - 77 - $ycor)
		Sleep(500)
		_Click($B_Close[0] - $xcor + 10, $B_Close[1] - 77 - $ycor + 10)
		TrayTip("Подсказка", "ухожу из боя", 100);ОТЛАДКА
;~ 		 _thinks_loc($loc)
	EndIf


EndFunc   ;==>_fight

;БЕСПОЛЕЗНАЯ ФУНКЦИЯ КОТОРУЮ НАДО УДАЛИТЬ;БЕСПОЛЕЗНАЯ ФУНКЦИЯ КОТОРУЮ НАДО УДАЛИТЬ
Func _PxSr_and_click($px1, $py1, $px2, $py2, $color, $variation)
;~
	For $i = 0 To 2 ;Подтверждает выбор боя ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ
		$B_Select = 0
		$B_Select = PixelSearch($px1 + $xcor, $py1 + 77 + $ycor, $px2 + $xcor, $py2 + 77 + $ycor, 0x6EAD55, $variation, 1, $hWnD)
		If $B_Select = 0 Then
			$i = 0
		Else
			_Click($B_Select[0] - $xcor, $B_Select[1] - 77 - $ycor)
			TrayTip("Подсказка", "Цвет найден, клик выполнен", 100);ОТЛАДКА
			$i = 2
			Sleep(1000)
			_Click(604, 310) ;хочу в этот бой
			Sleep(1000)
			_Click(755, 180) ;закрывает окно выбора
		EndIf
	Next

EndFunc   ;==>_PxSr_and_click


;Пауза в поиске и боях 1х1 для ожидания группового боя
Func _pause_battle()
	$testdelay = 0
	TrayTip('', 'Функция паузы в бою, минуты: ' & @MIN, 100)
	Sleep($testdelay)
;~ 	  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=15 or @MIN=00 or @MIN=30 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then _fight_detect()
	If @MIN = 14 Or @MIN = 59 Or @MIN = 29 Or @MIN = 13 Or @MIN = 58 Or @MIN = 28 And $wait_for_battle = 1 Then
;~ 		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then
		TrayTip('', 'Функция паузы в бою, локация: ' & $loc & "   время ожидания определенно   ", 100)
		Sleep($testdelay)
		_fight_detect()
	Else
		TrayTip('', 'Функция паузы в бою, локация: ' & $loc & "  Ищу время смены локации   ", 100)
		Sleep($testdelay)
;~ 				If @MIN>=45 and @MIN<=57 or @MIN>=20 and @MIN<=27 then
		If @MIN >= 20 And @MIN <= 27 Or @MIN >= 45 And @MIN <= 57 Then
			If $loc = 1 Then Return
			If $loc = 2 Then
				_Change_loc(1)
				TrayTip('', 'Функция паузы в бою, локация: ' & $loc & "   пеменяли локацию на другую   ", 100)
				Sleep($testdelay)
				_thinks_loc()

			Else
				TrayTip('', 'Функция паузы в бою, локация: ' & $loc & "   иначе   ", 100)
				Sleep($testdelay)
				Return
			EndIf
		Else
		EndIf
		;traytip('','Функция паузы в бою, локация: '&$loc&"  Ничего я не нашел(((   ",100)
		Sleep($testdelay)
	EndIf

EndFunc   ;==>_pause_battle


;смена локации
Func _Change_loc($location)
;~    global $loc=$location

	_Click(882, 299) ;Нажимаем на карту для смены локации
	Sleep(1000)
	If $location = 1 Then
		_Click(556, 349) ;Первая локация
		Global $loc = 1
	EndIf
	If $location = 2 Then
		_Click(740, 326) ;Вторая локация
		Global $loc = 2
	EndIf
	Sleep(1000)

EndFunc   ;==>_Change_loc

;Функция ожидания группового боя и сбирания плюшек во время этого
Func _fight_detect()

	$hTimer_fd = TimerInit() ;замер времени на случай ошибки и "вечного боя"

	For $fight_detect = 0 To 1
		_Change_loc(2)
		TrayTip("Подсказка", "Ожидаю группового боя", 100) ;ОТЛАДКА
		Sleep(500)

		;Смотрит идёт ли бой и переходит на бой
		$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
		If $getcolor_attack = 'A7A7A7' Then _fight()

		;выберает бой
		If @MIN = 59 Or @MIN = 58 Or @MIN = 29 Or @MIN = 28 Then
;~    if @MIN=59 or @MIN=00 or @MIN=29 or @MIN=30 then
			$BossN = GUICtrlSendMsg($Bossnumber, $CB_GETCURSEL, 0, 0)
			If $BossN = 2 Then _Click(614, 145) ;выбор мясорубки
			If $BossN = 1 Then _Click(745, 610) ;выбор Близняшко
			If $BossN = 0 Then _Click(315, 350) ;выбор Хохотун

			;Подтверждает выбор боя
			Sleep(1000)
			_Click(655, 420) ; запись в бой
			TrayTip("Подсказка", "Бой выбран", 100);ОТЛАДКА
			Sleep(1000)
			_Click(604, 310) ;хочу в этот бой
			Sleep(1000)
			_Click(755, 180) ;закрывает окно выбора

			;Смотрит идёт ли бой и переходит на бой
			$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
			If $getcolor_attack = 'A7A7A7' Then _fight()

			; Работает используя энергию
			$workE = GUICtrlSendMsg($WorkEnergynumber, $CB_GETCURSEL, 0, 0)
			If $workE <> 1 Then
				Sleep(1000)
				_Click(305, 165) ;выбор Стройка
				Sleep(1000)
				;прокликивает кнопки работы, пока находит цвет зелёной кнопки
				For $i = 0 To 63
					$coord = PixelSearch(575 + $xcor, 310 + 77 + $ycor, 580 + $xcor, 700 + 77 + $ycor, 0x6EAD55, 5)
					If Not @error Then
						_Click($coord[0] - $xcor, $coord[1] - 77 - $ycor)
						Sleep(600)
					Else
						;закрывает сообщение о выйгрыше
						_Click(800, 190) ;крестик на предложении покупки энергии
						Sleep(300)
						_Click(782, 111) ;крестик на окне работы
						$B_Close = 0
						$B_Close = PixelSearch(520 + $xcor, 420 + 77 + $ycor, 525 + $xcor, 700 + 77 + $ycor, 0x6EAD55, 1, 1, $hWnD)
						If $B_Close <> 0 Then _Click($B_Close[0] - $xcor, $B_Close[1] - 77 - $ycor)
						ExitLoop
					EndIf


					;Смотрит идёт ли бой и переходит на бой
					$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
					If $getcolor_attack = 'A7A7A7' Then _fight()
				Next
			EndIf

;~ 	  for $i=0 to 2 ;Подтверждает выбор боя ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ
;~ 		 $B_Select = 0
;~ 		 $B_Select = PixelSearch ( 565, 400+77+$ycor, 720, 415+77+$ycor, 0x6EAD55,10,1, $hWnd )
;~ 		 if $B_Select=0 then
;~ 			$i=0
;~ 			else
;~ 			_Click($B_Select[0]-$xcor, $B_Select[1]-77-$ycor)
;~ 			TrayTip ("Подсказка","Бой выбран", 100);ОТЛАДКА
;~ 			$i=2
;~ 			sleep (1000)
;~ 			_Click(604, 310) ;хочу в этот бой
;~ 			sleep (1000)
;~ 			_Click(755, 180) ;закрывает окно выбора
;~ 		 EndIf
;~ 	  next
		Else
			If @MIN = 14 Or @MIN = 13 Then
				_Click(800, 190) ;выбор боя 30х30 на второй локации

				;Подтверждает выбор боя
				Sleep(1000)
				_Click(410, 565) ; запись в бой 30х30
				TrayTip("Подсказка", "Бой выбран", 100);ОТЛАДКА
				Sleep(1000)
				_Click(604, 310) ;хочу в этот бой
				Sleep(1000)
				_Click(775, 180) ;закрывает окно выбора

;~ 	  	  for $i=0 to 2 ;Подтверждает выбор боя
;~ 		 $B_Select = 0
;~ 		 $B_Select = PixelSearch ( 325, 550+77+$ycor, 495, 565+77+$ycor, 0x6EAD55,10,1, $hWnd )
;~ 			if $B_Select=0 then
;~ 			   $i=0
;~ 			   else
;~ 			   _Click($B_Select[0]-$xcor, $B_Select[1]-77-$ycor)
;~ 			   TrayTip ("Подсказка","Бой выбран", 100);ОТЛАДКА
;~ 			   $i=2
;~ 			   sleep (1000)
;~ 			   _Click(605, 310) ;хочу в этот бой
;~ 			   sleep (1000)
;~ 			   _Click(775, 180) ;закрывает окно выбора
;~ 			EndIf
;~ 		  next
			Else
				_thinks_loc()
			EndIf
			;Смотрит идёт ли бой и переходит на бой
			$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
			If $getcolor_attack = 'A7A7A7' Then _fight()


		EndIf

		;Смотрит идёт ли бой и переходит на бой
		$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
		If $getcolor_attack = 'A7A7A7' Then _fight()
	Next

	While 1
		;Смотрит идёт ли бой и переходит на бой
		$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
		If $getcolor_attack = 'A7A7A7' Then _fight()
		If TimerDiff($hTimer_fd) > 180000 Then Return ;замер времени на случай ошибки и "вечного боя"
	WEnd
EndFunc   ;==>_fight_detect


Func _F5_Reload()

;~    ControlSend ($hwnd, '','','{F5}')
	Sleep(5000)
	While 1
		$CheckColor = Hex(PixelGetColor(255 + 2, 83 + 77, $hWnD), 6)
		If $CheckColor = '9ACACC' Or $CheckColor = '4D6667' Then
			If $CheckColor = '4D6667' Then
				_CloseClick()
				Sleep(500)
			EndIf
			_Click(880, 150)
			Sleep(1000)
			ExitLoop
		EndIf

		TrayTip('', 'ожидаю появления в ангаре ', 100)
		Sleep(500)
	WEnd

EndFunc   ;==>_F5_Reload















Func _doit2()
	;получение размера рабочего элемента окна
	$hWnD = WinGetHandle("[ACTIVE]")
	$sControl = ControlGetFocus($hWnD)
	$aPos = ControlGetPos($hWnD, "", $sControl)
;~     $aPos = ControlGetPos($hWnd, "", "")
	$winx = $aPos[2]
	$winy = $aPos[3]

	$x1 = 0
	$y1 = 0

	;определение ширины окна и расчёт поправки координаты x
	Dim $coord[2]
	$getcolor = 0
	$coord = PixelSearch(140, 125, 700, 156, 0xF2F2F2, 10, 1, $hWnD)
	If Not @error Then $getcolor = Hex(PixelGetColor($coord[0] + 1, $coord[1], $hWnD), 6)

	If Not @error And $getcolor = "D9E0E7" Then
		TrayTip("Подсказка", "Отклонение в координатах успешно установленно", 100)
		$xcor = $coord[0] - 150
	Else
		TrayTip("Подсказка", "Отклонение в координатах не установленно :(", 100)
		$xcor = 0
	EndIf

	;координаты атаки в бою
	Global $cx_attack = 360, $cy_attack = 470
;~ 	_Click($cx_attack, $cy_attack)
	;координаты использования животного в бою
	Global $cx_helper = 700, $cy_helper = 470
;~ 	_Click($cx_helper, $cy_helper)


	;координаты вещеё на локации мёртвая окраина
	Global $cx_loc[10][6 + 1], $cy_loc[10][6 + 1]
	$cx_loc[1][1] = 665
	$cy_loc[1][1] = 100
	$cx_loc[1][2] = 370
	$cy_loc[1][2] = 300
	$cx_loc[1][3] = 630
	$cy_loc[1][3] = 370
	$cx_loc[1][4] = 440
	$cy_loc[1][4] = 525
	$cx_loc[1][5] = 650
	$cy_loc[1][5] = 570
	$cx_loc[1][6] = 270
	$cy_loc[1][6] = 650
	;координаты вещеё на локации спальный район
	$cx_loc[2][1] = 500
	$cy_loc[2][1] = 120
	$cx_loc[2][2] = 800
	$cy_loc[2][2] = 135
	$cx_loc[2][3] = 817
	$cy_loc[2][3] = 355
	$cx_loc[2][4] = 407
	$cy_loc[2][4] = 290
	$cx_loc[2][5] = 750
	$cy_loc[2][5] = 520
	$cx_loc[2][6] = 400
	$cy_loc[2][6] = 690
;~ 	_Click($cx_loc1_3, $cy_loc1_3)

	;координаты выбора жертвы в одиночном бою
	Global $cx_attack1x1 = 482, $cy_attack1x1 = 313

	$q2 = 25

	For $i = 1 To $q2
		Sleep(500)
		$y = 0
		While $y = 0

			;Пауза в поиске и боях 1х1 для ожидания группового боя
			If @MIN = 59 Or @MIN = 29 And $wait_for_battle = 1 Then _fight_detect()

			$mousePos = MouseGetPos()
			MouseMove(480 + $xcor, 320 + 77 + $ycor, 0)
			_Click($cx_attack1x1 + Random(-15, 15, 1), $cy_attack1x1 + Random(-15, 15, 1))
			Sleep(15)
			MouseMove($mousePos[0], $mousePos[1], 0)
			Sleep(700)

			$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
			If $getcolor_attack = 'A7A7A7' Then $y = 1
			TrayTip("Подсказка", $y, 100)

		WEnd

		_fight()

	Next

EndFunc   ;==>_doit2


















Func _RandomEx($_iSNum = 0, $_iENum = 1, $_iUnique = 1, $_iRNumCount = 0, $_iRetFormat = 0, $_sRetDelimiter = ",")
	Local $sRNumStr = "`", $iNumCount = 0

	If $_iSNum >= $_iENum Then Return SetError(1, 0, 0)
	If $_iUnique And ($_iENum - $_iSNum + 1) < $_iRNumCount Then Return SetError(2, 0, 0)

	If $_iRNumCount = 0 Then $_iRNumCount = $_iENum - $_iSNum + 1

	While $iNumCount <> $_iRNumCount
		$iRNum = Random($_iSNum, $_iENum, 1)

		If $_iUnique = 1 Then
			If IsDeclared("<" & $iRNum & ">") Then ContinueLoop

			Assign("<" & $iRNum & ">", "", 1)

			$sRNumStr &= $iRNum & "`"

			$iNumCount += 1
		Else
			$sRNumStr &= $iRNum & "`"

			$iNumCount += 1
		EndIf
	WEnd
	$sRNumStr = StringTrimLeft(StringTrimRight($sRNumStr, 1), 1)

	If $_iRetFormat = 0 Then Return StringReplace($sRNumStr, "`", $_sRetDelimiter)
	If $_iRetFormat = 1 Then Return StringSplit($sRNumStr, "`")
EndFunc   ;==>_RandomEx