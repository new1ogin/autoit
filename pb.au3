#include <WinAPI.au3>
#Include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <Icons.au3>
#include <color.au3>
#include "MouseOnEvent.au3"

Opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 0)

global $command=0,$winx,$winy,$hWnD,$starttime,$MAP,$Paused
global $getcolordcC,$getcolordcM,$getcolordcB,$getcolordcL,$schet=0,$posy,$schet2=0,$schet3=0
#region data
$dcLc=0xD2D1D1
$dcLx=900
$dcLy=712

$dcBc=0xD7D7D7
$dcBx=898
$dcBy=744

$dcMc=0xDCDFDB
$dcMx=901
$dcMy=724

$dcCc=0xA9A8A9 ;tolerance~3
$dcCx=882
$dcCy=720

$dcDc=0xF0D26E
$dcDx=520
$dcDy=172
#endregion data

$timer_to_start=60000*8.5



HotKeySet("{insert}", "_DetectWindow_and_start")
HotKeySet("{ScrollLock}", "Terminate")
HotKeySet("{end}", "_easy_fight")
HotKeySet("{home}", "_Pause")
Func Terminate()
;~ 	If GUICtrlRead($CheckBox1) = 1 Then TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		Sleep(100)
;~ 		If $trayP = 1 And GUICtrlRead($CheckBox1) = 1 Then TrayTip("Подсказка", "Пауза", 1000)
	WEnd
	ToolTip("")
EndFunc   ;==>_Pause

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func _DetectWindow_and_start()
	;получение размера рабочего элемента окна
	$hWnD = WinGetHandle("[ACTIVE]")
	$sControl = ControlGetFocus($hWnD)
	$aPos = ControlGetPos($hWnD, "", $sControl)
;~ 	MsgBox(0,'',$hWnD& "   "&$sContro l& "   "&$aPos& "   ")
	$winx = $aPos[2]
	$winy = $aPos[3]

	;определение ширины окна и расчёт поправки координаты x
	Dim $coord[2]
	$Xcoordinat_detected_YES = 0
	$xcor = 0
	$ycor = 0
	$getcolor = 0

;~ 	while 1
;~ $cx = random(-500,500,1)+500
;~ 	$cy = random(-300,300,1)+300
$cx=870
$cy=770
;~ mousemove($cx,$cy)
;~ MouseClick('left',870,770)

;~ ControlClick($hWnD, '', $sControl, "left", 1, $cx + $xcor + Random(-4, 4, 1), $cy + $ycor + Random(-4, 4, 1))
sleep(64)
;~ wend
;~ 	while 1
;~ $xcor = random(-500,500,1)
;~ 	$ycor = random(-300,300,1)
;~ dim $aPos[2]
;~ $aPos[0]=0
;~ $aPos[1]=0

_detect_start()
;~ mousemove(MouseGetPos (0)-12.2	,MouseGetPos (1),10) ;поворот ~92%
;~ $getcolorL = Hex(PixelGetColor(524 + $xcor, 344 + $ycor, $hWnD), 6)
$getcolorL = Hex(PixelGetColor(524 + $xcor, 344 + $ycor, $hWnD), 6)
;~ $getcolordcC = Hex(PixelGetColor(524 + $xcor, 344 + $ycor, $hWnD), 6)
;~ 	$getcolordcL = Hex(PixelGetColor($dcLx, $dcLy, $hWnD), 6)
;~ 	$getcolordcM = Hex(PixelGetColor($dcMx, $dcMy, $hWnD), 6)
;~ 	$getcolordcB = Hex(PixelGetColor($dcBx, $dcBy, $hWnD), 6)
;~ mousemove($cx,$cy)

;~ MsgBox(0,'',$getcolorL)
;~ traytip('',$getcolorL,100)
;~ sleep(300)
;~ wend

;~ $result=_detect_command()
;~ MsgBox(0,'',$result&' _ '&$getcolordcC&'  '&$getcolordcM&'  '&$getcolordcB&'  '&$getcolordcL)
traytip('','я закончил',500)
EndFunc ;_DetectWindow_and_start()

func _detect_and_close_priglashenie()
	$getcolorCLOSE1 = PixelGetColor(523,456, $hWnD)
	if $getcolorCLOSE1 = 0x444444 Then
		$getcolorCLOSE2 = PixelGetColor(542,454, $hWnD)
		$getcolorCLOSE3 = PixelGetColor(546,460, $hWnD)
		if $getcolorCLOSE2 = $getcolorCLOSE3 = 0xADADAD then
				mousemove(550,460) ;нет на приглашении
				MouseDown ( "left" )
				sleep(64)
				Mouseup ( "left" )
		EndIf
	EndIf



EndFunc

;определение какая карта или меню открыто
func _map_detect()
		$MAP=0
	$gcMap = PixelGetColor(490,385,$hWnD)
	$ColorMap1=0xAE9F4B  ;логово динозавров
	$ColorMap2=0x010D09  ;пригород
	$ColorMap3=0x767572  ;прорыв
	$iColor = _ColorGetRGB($gcMap)
	$iColor2 = _ColorGetRGB($ColorMap1)
	$difiColor=($iColor2[0]-$iColor[0])+($iColor2[1]-$iColor[1])+($iColor2[2]-$iColor[2])
	if abs($difiColor)<2 then $MAP=1
	$iColor3 = _ColorGetRGB($ColorMap2)
	$difiColor=($iColor3[0]-$iColor[0])+($iColor3[1]-$iColor[1])+($iColor3[2]-$iColor[2])
	if abs($difiColor)<2 then $MAP=2
	$iColor2 = _ColorGetRGB($ColorMap3)
	$difiColor=($iColor2[0]-$iColor[0])+($iColor2[1]-$iColor[1])+($iColor2[2]-$iColor[2])
	if abs($difiColor)<2 then $MAP=3
	if $gcMap=0x1E1E1E then
	_detect_and_close_priglashenie()
	return -1
	endif
	if $gcMap= 0x161616 then return -1
EndFunc

;осуществляет вход в комнату и начало боя
func _detect_start()

_map_detect()

	if $MAP=0 Then
		_detect_and_close_priglashenie()
		$getcolorTest=0
		$coord = PixelSearch(0, 0, $winx, $winy, 0x00FEFE, 1, 1, $hWnD)
		If Not @error then $getcolorTest=PixelGetColor($coord[0]+54,$coord[1]+4, $hWnD)
		If Not @error and $getcolorTest=0xCDCDCD Then
			 MouseMove($coord[0],$coord[1])
			for $i=1 to 3
				sleep(64)
				MouseDown ( "left" )
				sleep(64)
				Mouseup ( "left" )
			Next
		Else
;~ 			if $getcolorTest=0x646464 then $123=123 ;найденное бегство заполненно
			_detect_and_close_priglashenie()
			MouseMove(982,458) ;нижний скролл в окне выбора комнаты
			for $i=1 to 8
				sleep(64)
				MouseDown ( "left" )
				sleep(64)
				Mouseup ( "left" )
			Next
				$schet3=$schet3+1
				if $schet3=8 Then
					_detect_and_close_priglashenie()
					MouseMove(982,150) ;верхний скролл в окне выбора комнаты
					for $i=1 to 8*5+1
						sleep(64)
						MouseDown ( "left" )
						sleep(64)
						Mouseup ( "left" )
					Next
				EndIf

		_detect_start()
	EndIf
	sleep(500)
	_map_detect()
	if $MAP=0 then _detect_start()
	EndIf

;~ msgbox(0,'','номер карты'&$MAP)
;~ return
	;войти только когда начнётся бой
	while 1
		PixelSearch(0,0,$winx,$winy,0xFF7800,2,2,$hWnD)
		If Not @error Then
			_launch_start()
			$starttime=TimerInit() ;TimerDiff($starttime)
		Else
		endif
		sleep(512)
	Wend

EndFunc  ;_detect_start()

func _launch_start()

	sleep($timer_to_start) 	;зайти только в определенную минуту боя
	WinActivate($hWnD)

	mousemove(880,690)
	MouseDown ( "left" )
	sleep(64)
	Mouseup ( "left" )
	sleep(3000)

	_detect_command()
	sleep(2000)
	_detect_wait_fight()
	sleep(1000)
	_detect_command()

	_easy_fight()
endfunc

;Определение за какую комманду идёт игра дино/люди
func _detect_command()

	$getcolordcC = PixelGetColor($dcCx, $dcCy, $hWnD)
	$iColor = _ColorGetRGB($getcolordcC)
	$iColor2 = _ColorGetRGB($dcCc)
	$difiColor=($iColor2[0]-$iColor[0])+($iColor2[1]-$iColor[1])+($iColor2[2]-$iColor[2])
	if abs($difiColor)<10 then $command=1

	$getcolordcL = PixelGetColor($dcLx, $dcLy, $hWnD)
	$iColor = _ColorGetRGB($getcolordcL)
	$iColor2 = _ColorGetRGB($dcLc)
	$difiColor=($iColor2[0]-$iColor[0])+($iColor2[1]-$iColor[1])+($iColor2[2]-$iColor[2])
	if abs($difiColor)<5 then $command=2

	$getcolordcM = PixelGetColor($dcMx, $dcMy, $hWnD)
	$iColor = _ColorGetRGB($getcolordcM)
	$iColor2 = _ColorGetRGB($dcMc)
	$difiColor=($iColor2[0]-$iColor[0])+($iColor2[1]-$iColor[1])+($iColor2[2]-$iColor[2])
	if abs($difiColor)<5 then $command=3

	$getcolordcB = PixelGetColor($dcBx, $dcBy, $hWnD)
	$iColor = _ColorGetRGB($getcolordcB)
	$iColor2 = _ColorGetRGB($dcBc)
	$difiColor=($iColor2[0]-$iColor[0])+($iColor2[1]-$iColor[1])+($iColor2[2]-$iColor[2])
	if abs($difiColor)<5 then $command=4

	return $command

EndFunc ;_detect_command()

;определяет есть ли подготовка к бою и ждёт её завершения
func _detect_wait_fight()

	for $i=0 to 66

	$getcolordcB = PixelGetColor($dcDx, $dcDy, $hWnD)
	$iColor = _ColorGetRGB($getcolordcB)
	$iColor2 = _ColorGetRGB($dcDc)
	$difiColor=($iColor2[0]-$iColor[0])+($iColor2[1]-$iColor[1])+($iColor2[2]-$iColor[2])
	if $difiColor>3 then return
	sleep(300)
	next

EndFunc

;упрощённая функция ведения боя
func _easy_fight()

			for $i=0 to 1800

			_WinAPI_Keybd_Event(0xA2, 0) ;клавиша левый CONTROL
			sleep(random(500,2000,1))
					;поворот ~92%
					$schet=$schet+1
					$aPos = MouseGetPos()
					if $schet=1 then $posy=$aPos[1]
					mousemove($aPos[0]+random(-1,1,1)	,$posy,10)
			sleep(random(500,2000))
					_WinAPI_Keybd_Event(0x20, 2)
					sleep(random(300,900,1))
					_WinAPI_Keybd_Event(0x20, 0) ;пробел
			sleep(random(500,2000,1))
		if _map_detect()=-1 or $MAP<>0 then _detect_start()
					;поворот ~92%
					$schet=$schet+1
					$aPos = MouseGetPos()
					if $schet=1 then $posy=$aPos[1]
					mousemove($aPos[0]+random(-1,1,1)	,$posy,10)
			sleep(random(500,2000))
					_WinAPI_Keybd_Event(0x20, 2)
					sleep(random(300,900,1))
					_WinAPI_Keybd_Event(0x20, 0) ;пробел
			sleep(random(500,2000,1))
		if _map_detect()=-1 or $MAP<>0 then _detect_start()
					;поворот ~92%
					$schet=$schet+1
					$aPos = MouseGetPos()
					if $schet=1 then $posy=$aPos[1]
					mousemove($aPos[0]+random(-1,1,1)	,$posy,10)
			sleep(random(500,2000))
					_WinAPI_Keybd_Event(0x20, 2)
					sleep(random(300,900,1))
					_WinAPI_Keybd_Event(0x20, 0) ;пробел
					sleep(random(500,2000))
			_WinAPI_Keybd_Event(0xA2, 2)

		if _map_detect()=-1 or $MAP<>0 then _detect_start()
		next

EndFunc


func _fight()
	$comnd=_detect_command()
	if $comnd=1 Then
		if $MAP=1 then
			_WinAPI_Keybd_Event(0x46, 0) ;клавиша F
			sleep(120)
			_WinAPI_Keybd_Event(0x46, 2)
			sleep(256)
		endif
;~ 		;бег с прыжками
		_WinAPI_Keybd_Event(0x57, 0)
				sleep(random(300,900,1))
		_WinAPI_Keybd_Event(0x20, 0) ;пробел
		sleep(64)
		_WinAPI_Keybd_Event(0x20, 2)
				sleep(random(300,900,1))
		_WinAPI_Keybd_Event(0x20, 0) ;пробел
		sleep(64)
		_WinAPI_Keybd_Event(0x20, 2)
				sleep(random(300,900,1))
		_WinAPI_Keybd_Event(0x20, 0) ;пробел
		sleep(64)
		_WinAPI_Keybd_Event(0x20, 2)
				sleep(random(300,900,1))
		_WinAPI_Keybd_Event(0x20, 0) ;пробел
		sleep(64)
		_WinAPI_Keybd_Event(0x20, 2)
				sleep(random(300,900,1))
		_WinAPI_Keybd_Event(0x20, 0) ;пробел
		sleep(64)
		_WinAPI_Keybd_Event(0x20, 2)
		_WinAPI_Keybd_Event(0x57, 2)

		;поворот ~92%
		$schet=$schet+1
		$aPos = MouseGetPos()
		if $schet=1 then $posy=$aPos[1]
		mousemove($aPos[0]-12.2	,$posy,10)

;~ 		;бег
		_WinAPI_Keybd_Event(0x57, 0)

		_WinAPI_Keybd_Event(0x57, 2)

	EndIf


EndFunc

