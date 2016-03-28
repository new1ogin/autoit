#include <WinAPI.au3>
#Include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <Icons.au3>
#Region
#AutoIt3Wrapper_Res_File_Add="primer.bmp", 2, 200
#EndRegion

opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 2)

global $hWnD, $sControl, $xcor, $ycor,$nstart,$sleepclick, $loc, $CheckBox1, $Paused
global $wait_for_battle=1 ;Пауза в поиске и боях 1х1 для ожидания группового боя
global $testdelay=0, $sleepclick=1000, $menudelay=1000

#Region ### Coords
    ;координаты атаки в бою
	global $cx_attack=360, $cy_attack=470
	;координаты использования животного в бою
	global $cx_helper=700, $cy_helper=470
	;координаты вещей на локации мёртвая окраина
	global $cx_loc[10][6+1], $cy_loc[10][6+1]
	$cx_loc[1][1]=665
	$cy_loc[1][1]=100
	$cx_loc[1][2]=370
	$cy_loc[1][2]=300
	$cx_loc[1][3]=630
	$cy_loc[1][3]=370
	$cx_loc[1][4]=440
	$cy_loc[1][4]=525
	$cx_loc[1][5]=650
	$cy_loc[1][5]=570
	$cx_loc[1][6]=270
	$cy_loc[1][6]=650
	;координаты вещей на локации спальный район
	$cx_loc[2][1]=500
	$cy_loc[2][1]=120
	$cx_loc[2][2]=759
	$cy_loc[2][2]=135
	$cx_loc[2][3]=817
	$cy_loc[2][3]=355
	$cx_loc[2][4]=407
	$cy_loc[2][4]=290
	$cx_loc[2][5]=750
	$cy_loc[2][5]=520
	$cx_loc[2][6]=400
	$cy_loc[2][6]=690
	;координаты вещей на локации 3 промзона
	$cx_loc[3][1]=790
	$cy_loc[3][1]=165
	$cx_loc[3][2]=660
	$cy_loc[3][2]=340
	$cx_loc[3][3]=430
	$cy_loc[3][3]=405
	$cx_loc[3][4]=193
	$cy_loc[3][4]=430
	$cx_loc[3][5]=773
	$cy_loc[3][5]=550
	$cx_loc[3][6]=320
	$cy_loc[3][6]=695
#EndRegion ### Coords

HotKeySet("{ScrollLock}", "Terminate")
Func Terminate()
   if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Программа закрыта, Всего хорошего :)",1500)
   sleep (1000)
    Exit 0
EndFunc

HotKeySet("{F1}", "_DetectWindow_and_start") ;собирает вещи на первой локации
HotKeySet("{F2}", "_DetectWindow_and_start") ;собирает вещи на второй локации
HotKeySet("{F3}", "_local_detect") ;играет в одиночные бои
HotKeySet("{F4}", "_pause") ;играет в одиночные бои
HotKeySet("{F6}", "_DetectWindow_and_start2")


Func _Pause()
    $Paused = Not $Paused
	$trayP=0
    While $Paused
		$trayP+=1
        Sleep(100)
        if $trayP=1 and Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Пауза",1000)
    WEnd
    ToolTip("")
EndFunc


;Графический интерфейс пользователя
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=e:\vitaliy\programs\autoitv3.3.8.1\form1_3.kxf
$Form1_2 = GUICreate("Бот на Мертвая зона в ВК", 362, 453, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
$sleepclick = GUICtrlCreateInput("1000", 232, 320, 121, 21)
$Label3 = GUICtrlCreateLabel("Введите задержку между кликами в мс.", 8, 320, 210, 17)
$Bossnumber = GUICtrlCreateCombo("Хохотун", 208, 352, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Близняшко|Мясник")
$Label4 = GUICtrlCreateLabel("Выберите Босса для группового боя", 8, 352, 190, 17)
$WorkEnergynumber = GUICtrlCreateCombo("Стройка", 208, 384, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "Не использовать")
$Label5 = GUICtrlCreateLabel("Место для использования энергии", 8, 384, 182, 17)
$Button1 = GUICtrlCreateButton("Выход", 143, 416, 105, 25)
GUICtrlSetOnEvent(-1, "_Pro_Exit")
$Checkbox1 = GUICtrlCreateCheckbox("Показывать всплывающие подсказки?", 8, 296, 241, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateEdit("", 8, 8, 329, 193, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlSetData(-1, StringFormat("Откройте приложение в отдельнои окне (не развёрнутом), \r\nперейдите на вторую локацию и нажмите клавишу "&Chr(34)&"F2"&Chr(34)&"\r\nЭто окно вы можете просто свернуть.\r\nНа данный момент бот выполняет следующие функции:\r\n1. Бой с появившимися на 1 и 2 локации громилами, зомби\r\nи сбор предметов\r\n2. Принятие участия в групповых боях и нападениях на босов\r\n3. Выполняет работы использую энергию\r\n"&Chr(34)&"F3"&Chr(34)&" - Покажет в подсказке на какой вы локации\r\n"&Chr(34)&"F4"&Chr(34)&" - Пауза, для продолжения снова нажмите "&Chr(34)&"F4"&Chr(34)&"\r\n"&Chr(34)&"F6"&Chr(34)&" - При открытых одиночных боях будет играть в них\r\n\r\nЕсли хотите изменить размер окна, то делайте это так, чтобы\r\nверхний угол приложения был виден"))
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



;~ $Pic2 = GUICtrlCreatePic("C:\TEMP\autoitv3.3.8.1\primer.bmp", 8, 160, 204, 82)
$Pic = GUICtrlCreatePic("", 8, 165+24+16, 204, 82)
$hInstance = _WinAPI_GetModuleHandle(0)
$hBitmap = _WinAPI_LoadBitmap($hInstance, 200)
_SetHImage($Pic, $hBitmap)
_WinAPI_DeleteObject($hBitmap)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

;Выход из бота по нажатию кнопки Выход
Func _Pro_Exit()
    Exit
EndFunc

;Функция определения того, что происходит на экране
Func _whats_wrong()

   		 $B_Close_Wrong = 0
		 $B_Close_Wrong = PixelSearch ( 490+$xcor, 340+77+$ycor, 545+$xcor, 350+77+$ycor, 0x6EAD55,1,1, $hWnd )
	  if $B_Close_Wrong<>0 then _Click($B_Close_Wrong[0]-$xcor, $B_Close_Wrong[1]-77-$ycor)
		 if $B_Close_Wrong<>0 then _F5_Reload()


EndFunc

;Функция кликов по переданным координатам ControlClick
Func _Click($cx, $cy,$mod=0)
	;установка задержек
if $mod=0 Then ;$cx<>360 or
	$sleepD=random(GUICtrlRead($sleepclick),GUICtrlRead($sleepclick)*1.5,1)
   sleep($sleepD)
Else
	$sleepH=random(0,10,1)
   sleep($sleepH)
endif

;~ ControlFocus ( $hWnD, "", '' )

;~ 			$mousePos = MouseGetPos()

;~ 			MouseMove ( $cx+$xcor, $cy+77+$ycor ,0 )

   ControlClick ($hWnD, '',$sControl, "left", 1, $cx+$xcor+random(-4,4,1), $cy+$ycor+random(-4,4,1))

;~ 			 MouseMove ( $mousePos[0], $mousePos[1] ,0 )

EndFunc

;Функция закрывания окошек в игре на крестик
func _CloseClick()

   		 $B_Close_Wrong2 = 0
		 $B_Close_Wrong2 = PixelSearch ( 0, 0, 920, 790, 0xFF7425,0,1, $hWnd )
		 if not @error then
			$getcol1=Hex (PixelGetColor ($B_Close_Wrong2[0],$B_Close_Wrong2[1]+1,$hwnd),6)
			$getcol2=Hex (PixelGetColor ($B_Close_Wrong2[0],$B_Close_Wrong2[1]+2,$hwnd),6)
			if $getcol1='FF7425' and $getcol2='FF7425' then _Click($B_Close_Wrong2[0]+6, $B_Close_Wrong2[1]+6-77)
		 EndIf

EndFunc

;определение локации открытой в данный момент
func _local_detect($Targetloc=0)
   ;определение локации
dim $locLD
;~    $loc=2
sleep(1500) ;Задержка на случай задержки менюшек
$noloc=0
$noloc=$loc
   $getcolorL=Hex(PixelGetColor ( 776+$xcor+5 , 133+77+$ycor , $hWnd ), 6)
   if $getcolorL='615B4D' then $locLD=1
   if $getcolorL='171C08' then $locLD=2
   if $getcolorL='221914' then $locLD=3
	  global $loc=$locLD
	     if $nstart=0 then
			if @HotKeyPressed="{F1}" then $loc=1
			if @HotKeyPressed="{F2}" then $loc=2
			$nstart=1
		 endif
 if $loc=0 then $loc=$noloc ;возврашение к предыдущему состоянию локации на случай ошибки

	if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка",'Вы на ' & $loc & '-й локации', 100)
	sleep(2000) ;отладка
	Sleep($testdelay)
return $loc
endfunc


;Определение окна с игрой и запуск начала боя на локации
Func _DetectWindow_and_start()
   $nstart=0 ;Отладка

   ;получение размера рабочего элемента окна
   $hWnd = WinGetHandle("[ACTIVE]")
    $sControl = ControlGetFocus($hWnd)
    $aPos = ControlGetPos($hWnd, "", $sControl)
   $winx=$aPos[2]
   $winy=$aPos[3]

   ;определение ширины окна и расчёт поправки координаты x
   dim $coord[2]
   $Xcoordinat_detected_YES=0
   $xcor=0
$getcolor=0
$coord = PixelSearch ( 140, 125, 700, 156, 0xF2F2F2,1,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord[0]+1 , $coord[1] , $hWnd ), 6)
if Not @error and $getcolor="D9E0E7" then
$Xcoordinat_detected_YES=1
   if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка",'Отклонение в координате "X" успешно установленно '& $Xcoordinat_detected_YES, 100)
   $xcor=$coord[0]-150

Else
   if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Отклонение в координатах не установленно :(", 100)
   $xcor=0
endif

   ;определение ширины окна и расчёт поправки координаты Y
   dim $coord2[2]
   $ycor=0
$getcolor=0
$coord2 = PixelSearch ( $winx/2, 0, ($winx/2)+1, $winy, 0xDAE1E8,1,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord2[0] , $coord2[1]+1 , $hWnd ), 6)
if Not @error and $getcolor="F7F7F7" then
   if $Xcoordinat_detected_YES=1 then
	   $ycor=$coord2[1]-147
	  if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка",'Отклонение в координате "X" успешно установленно = ' &$xcor& @CR &'Отклонение в координате "Y" успешно установленно = ' &$ycor, 1000)
	  Else
	  if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка",'Отклонение в координате "Y" успешно установленно', 1000)
	  endif
Else
   if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Отклонение в координате Y не установленно :(", 1000)
   $ycor=0
EndIf

sleep($testdelay)


global $Q=12000
   _local_detect()
_thinks_loc()


EndFunc   ;==>doit


;Бои с появившимися на локации громилами, зомби и сбор предметов
func _thinks_loc()

   if Guictrlread($CheckBox1)=1 then Traytip('','локация в поиске вещей '&$loc,1000)
Sleep($testdelay)

for $thin=1 to $Q
$aRandom = _RandomEx(1, 6, 1, 6, 1)
_CloseClick() ;на всякий случай

   for $i=1 to 6

	  if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","я ищю вещи", 100);ОТЛАДКА
	  _local_detect()
	  _pause_battle() ;Пауза в поиске и боях 1х1 для ожидания группового боя
	  _whats_wrong()

	  $t=$aRandom[$i]
	  _Click($cx_loc[$loc][$t], $cy_loc[$loc][$t])
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 444+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then $i=6 ;ЗАМЕТЬ ЭТО МЕСТО!!!!!!!ЗАМЕТЬ ЭТО МЕСТО!!!!!!!ЗАМЕТЬ ЭТО МЕСТО!!!!!!!
		 ;закрывает сообщение о победе
		 $B_Close = 0
		 $B_Close = PixelSearch ( 460+$xcor, 560+77+$ycor, 470+$xcor, 570+77+$ycor, 0x6EAD55,1,1, $hWnd )
	  if $B_Close<>0 then _Click($B_Close[0]-$xcor, $B_Close[1]-77-$ycor)
		 ;Смотрит идёт ли бой и переходит на бой
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()
;~ 		 MsgBox(0, 'сообщение', ' вы в бою ' & $getcolor_attack) ;ОТЛАДКА
						;условие неокончания поиска вещей
;~ 						$iDiff = TimerDiff($hTimer) ;$hTimer = TimerInit()
;~ 						if $iDiff<15000 then
;~ 						   $Q=1
;~ 						else
;~ 						   exit ; окончание поиска вещеё
;~ 						endif
	  next
next

EndFunc

;функция боя
func _fight()
   if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Я в бою!", 100) ;ОТЛАДКА
   $hTimer_f = TimerInit() ;замер времени на случай ошибки и "вечного боя"


;~    _Click($cx_helper, $cy_helper,1)
;~    sleep(10)
;~    _Click($cx_helper, $cy_helper,1)
;~    sleep(10)
   _Click($cx_helper, $cy_helper,1)
   sleep(10)
   _Click($cx_attack, $cy_attack)
   	sleep(200)

	if TimerDiff($hTimer_f) > 600000 then return ;замер времени на случай ошибки и "вечного боя"

			 ;закрывает сообщение о победе
		 $B_Close = 0
		 $B_Close = PixelSearch ( 460+$xcor, 560+77+$ycor, 470+$xcor, 570+77+$ycor, 0x6EAD55,10,1, $hWnd )
	  if $B_Close=0 then
		 _fight()
		 else
		 _Click($B_Close[0]-$xcor, $B_Close[1]-77-$ycor)
		 sleep(500)
		 _Click($B_Close[0]-$xcor+10, $B_Close[1]-77-$ycor+10) ;второй клик на случай не срабатывания (бывало)
		 if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","ухожу из боя", 100);ОТЛАДКА
;~ 		 _thinks_loc($loc)
	  EndIf


endfunc


;Пауза в поиске и боях 1х1 для ожидания группового боя
func _pause_battle()
				  $testdelay=0
   			   if Guictrlread($CheckBox1)=1 then Traytip('','Функция паузы в бою, минуты: '&@MIN,100)
				  sleep($testdelay)
;~ 	  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=15 or @MIN=00 or @MIN=30 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then _fight_detect()
		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then
;~ 		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then
			   if Guictrlread($CheckBox1)=1 then Traytip('','Функция паузы в бою, локация: '&$loc&"   время ожидания определенно   ",100)
				  sleep($testdelay)
			 _fight_detect()
		  Else
			 				if Guictrlread($CheckBox1)=1 then Traytip('','Функция паузы в бою, локация: '&$loc&"  Ищу время смены локации   ",100)
							sleep($testdelay)
;~ 				If @MIN>=45 and @MIN<=57 or @MIN>=20 and @MIN<=27 then
			    If  @MIN>=20 and @MIN<=27 or @MIN>=45 and @MIN<=57 then
					 if $loc=1 then return
					  if $loc=2 then
						 _Change_loc(1)
						if Guictrlread($CheckBox1)=1 then Traytip('','Функция паузы в бою, локация: '&$loc&"   пеменяли локацию на другую   ",100)
						sleep($testdelay)
						_thinks_loc()

						Else
						if Guictrlread($CheckBox1)=1 then Traytip('','Функция паузы в бою, локация: '&$loc&"   иначе   ",100)
						sleep($testdelay)
						return
						endif
				Else
				EndIf
				;if Guictrlread($CheckBox1)=1 then Traytip('','Функция паузы в бою, локация: '&$loc&"  Ничего я не нашел(((   ",100)
						sleep($testdelay)
		  EndIf

EndFunc


;смена локации
Func _Change_loc($location)
;~    global $loc=$location

   _Click(882, 299) ;Нажимаем на карту для смены локации
	  sleep (1000)
	  if $location=1 then
		 _Click(556, 349) ;Первая локация
		 global $loc=1
	  EndIf
	  if $location=2 then
		 _Click(740, 326) ;Вторая локация
		  global $loc=2
	  EndIf
	  if $location=3 then
		 _Click(470, 420) ;Вторая локация
		  global $loc=2
	  EndIf
	  sleep (1000)

endfunc

;Функция ожидания группового боя и сбирания плюшек во время этого
func _fight_detect()

   $hTimer_fd = TimerInit() ;замер времени на случай ошибки и "вечного боя"

for $fight_detect=0 to 1
   _Change_loc(2)
      if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Ожидаю группового боя", 100) ;ОТЛАДКА
   sleep($menudelay)

   	  ;Смотрит идёт ли бой и переходит на бой
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()

   ;выберает бой
   if @MIN=59 or @MIN=58 or @MIN=29 or @MIN=28 then
;~    if @MIN=59 or @MIN=00 or @MIN=29 or @MIN=30 then
		$BossN = GUICtrlSendMsg($Bossnumber, $CB_GETCURSEL, 0, 0)
 		 if $BossN=2 then _Click(614, 145) ;выбор мясорубки
 		 if $BossN=1 then _Click(745, 610) ;выбор Близняшко
		 if $BossN=0 then _Click(315, 350) ;выбор Хохотун

	  ;Подтверждает выбор боя
	   sleep($menudelay)
	  _Click(655, 420) ; запись в бой
	  if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Бой выбран", 100);ОТЛАДКА
	  sleep ($menudelay)
	  _Click(604, 310) ;хочу в этот бой
	  sleep ($menudelay)
	  _Click(755, 180) ;закрывает окно выбора

      	  ;Смотрит идёт ли бой и переходит на бой
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()

	  ; Работает используя энергию
	  $workE = GUICtrlSendMsg($WorkEnergynumber, $CB_GETCURSEL, 0, 0)
	if $workE<>1 then
		  sleep ($menudelay)
		  _Click(305, 165) ;выбор Стройка
		  sleep ($menudelay)
		  ;прокликивает кнопки работы, пока находит цвет зелёной кнопки
		  for $i=0 to 63
			 $coord = PixelSearch( 575+$xcor, 310+77+$ycor, 580+$xcor, 700+77+$ycor, 0x6EAD55, 5 )
			 If Not @error Then
				 _Click($coord[0]-$xcor, $coord[1]-77-$ycor)
				 sleep(600) ;пауза между кликами на работе используя энергию
			  Else
				;закрывает сообщение о выйгрыше
				_Click(800, 190) ;крестик на предложении покупки энергии
				sleep($menudelay)
				_Click(782, 111) ;крестик на окне работы

				;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				$B_Close = 0
				$B_Close = PixelSearch ( 520+$xcor, 420+77+$ycor, 525+$xcor, 700+77+$ycor, 0x6EAD55,1,1, $hWnd )
			 if $B_Close<>0 then _Click($B_Close[0]-$xcor, $B_Close[1]-77-$ycor)
				 ExitLoop
			 EndIf


	  ;Смотрит идёт ли бой и переходит на бой
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()
		Next
  EndIf

;~ 	  for $i=0 to 2 ;Подтверждает выбор боя ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ;ДОБАВИТЬ СЛУЧАЙ ОТСУТСТВИЯ КНОПКИ
;~ 		 $B_Select = 0
;~ 		 $B_Select = PixelSearch ( 565, 400+77+$ycor, 720, 415+77+$ycor, 0x6EAD55,10,1, $hWnd )
;~ 		 if $B_Select=0 then
;~ 			$i=0
;~ 			else
;~ 			_Click($B_Select[0]-$xcor, $B_Select[1]-77-$ycor)
;~ 			if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Бой выбран", 100);ОТЛАДКА
;~ 			$i=2
;~ 			sleep (1000)
;~ 			_Click(604, 310) ;хочу в этот бой
;~ 			sleep (1000)
;~ 			_Click(755, 180) ;закрывает окно выбора
;~ 		 EndIf
;~ 	  next
   Else
		 if @MIN=14 or @MIN=13 Then
		 _Click(800, 190) ;выбор боя 30х30 на второй локации

			;Подтверждает выбор боя
		  sleep(1000)
		 _Click(410, 565) ; запись в бой 30х30
		 if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Бой выбран", 100);ОТЛАДКА
		 sleep (1000)
		 _Click(604, 310) ;хочу в этот бой
		 sleep (1000)
		 _Click(775, 180) ;закрывает окно выбора

;~ 	  	  for $i=0 to 2 ;Подтверждает выбор боя
;~ 		 $B_Select = 0
;~ 		 $B_Select = PixelSearch ( 325, 550+77+$ycor, 495, 565+77+$ycor, 0x6EAD55,10,1, $hWnd )
;~ 			if $B_Select=0 then
;~ 			   $i=0
;~ 			   else
;~ 			   _Click($B_Select[0]-$xcor, $B_Select[1]-77-$ycor)
;~ 			   if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Бой выбран", 100);ОТЛАДКА
;~ 			   $i=2
;~ 			   sleep (1000)
;~ 			   _Click(605, 310) ;хочу в этот бой
;~ 			   sleep (1000)
;~ 			   _Click(775, 180) ;закрывает окно выбора
;~ 			EndIf
;~ 		  next
		 Else
			_thinks_loc()
		 endif
	  ;Смотрит идёт ли бой и переходит на бой
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()


   EndIf

	;Смотрит идёт ли бой и переходит на бой
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()
next

   while 1
;Смотрит идёт ли бой и переходит на бой
$getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
if $getcolor_attack='A7A7A7' then _fight()
if TimerDiff($hTimer_fd) > 180000 then return ;замер времени на случай ошибки и "вечного боя"
wend
endfunc


func _F5_Reload()

;~    ControlSend ($hwnd, '','','{F5}')
   sleep(5000)
   while 1
   $CheckColor = Hex( PixelGetColor (255+2,83+77,$hwnd), 6)
	  if $CheckColor = '9ACACC' or $CheckColor = '4D6667' then
			   if $CheckColor = '4D6667' then
				  _CloseClick()
				  sleep(500)
			   endif
		 _Click(880,150)
		 sleep(1000)
		 ExitLoop
	  endif

	  if Guictrlread($CheckBox1)=1 then Traytip('','ожидаю появления в ангаре ',100)
	  sleep(500)
   wend

EndFunc















Func _DetectWindow_and_start2()
   $nstart=0 ;Отладка

   ;получение размера рабочего элемента окна
   $hWnd = WinGetHandle("[ACTIVE]")
    $sControl = ControlGetFocus($hWnd)
    $aPos = ControlGetPos($hWnd, "", $sControl)
   $winx=$aPos[2]
   $winy=$aPos[3]

   ;определение ширины окна и расчёт поправки координаты x
   dim $coord[2]
   $Xcoordinat_detected_YES=0
   $xcor=0
$getcolor=0
$coord = PixelSearch ( 140, 125, 700, 156, 0xF2F2F2,1,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord[0]+1 , $coord[1] , $hWnd ), 6)
if Not @error and $getcolor="D9E0E7" then
$Xcoordinat_detected_YES=1
   if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка",'Отклонение в координате "X" успешно установленно '& $Xcoordinat_detected_YES, 100)
   $xcor=$coord[0]-150

Else
   if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Отклонение в координатах не установленно :(", 100)
   $xcor=0
endif

   ;определение ширины окна и расчёт поправки координаты Y
   dim $coord2[2]
   $ycor=0
$getcolor=0
$coord2 = PixelSearch ( $winx/2, 0, ($winx/2)+1, $winy, 0xDAE1E8,1,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord2[0] , $coord2[1]+1 , $hWnd ), 6)
if Not @error and $getcolor="F7F7F7" then
   if $Xcoordinat_detected_YES=1 then
	   $ycor=$coord2[1]-147
	  if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка",'Отклонение в координате "X" успешно установленно = ' &$xcor& @CR &'Отклонение в координате "Y" успешно установленно = ' &$ycor, 1000)
	  Else
	  if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка",'Отклонение в координате "Y" успешно установленно', 1000)
	  endif
Else
   if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка","Отклонение в координате Y не установленно :(", 1000)
   $ycor=0
EndIf

sleep($testdelay)

    ;координаты выбора жертвы в одиночном бою
	global $cx_attack1x1=482, $cy_attack1x1=313

$q2=25

for $i=1 to $q2
   sleep($menudelay) ;500
$y=0
   while $y=0

	  ;Пауза в поиске и боях 1х1 для ожидания группового боя
	  _pause_battle()

	  $mousePos = MouseGetPos()
	  MouseMove ( 480+$xcor, 320+77+$ycor ,0 )
	  _Click($cx_attack1x1+Random(-15,15,1), $cy_attack1x1+Random(-15,15,1))
	  sleep(15)
	  MouseMove ( $mousePos[0], $mousePos[1] ,0 )
	   sleep($menudelay) ;700

   $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
		 if $getcolor_attack='A7A7A7' then $y=1
			if Guictrlread($CheckBox1)=1 then Traytip ("Подсказка",$y,100)

	wend

_fight()

next

EndFunc   ;==>doit2


















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
EndFunc