#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=autoshot.ico
#AutoIt3Wrapper_Outfile=AutoShot - shotgun 0.1- F9.exe
#AutoIt3Wrapper_Outfile_x64=AutoShot - shotgun 0.1_64.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
; *** Start added by AutoIt3Wrapper ***
#include <APIConstants.au3>
;~ #include <vkConstants.au3>
; *** End added by AutoIt3Wrapper ***
#include <WinAPI.au3>
#Include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <Icons.au3>
#Include <PixelSearchEx.au3>
#include <MouseOnEvent.au3>
#include <ButtonConstants.au3>
#include <TabConstants.au3>
#include <GUIHotKey.au3>
#Include <HotKey.au3>
#include <Inet.au3>
#include <Misc.au3>


Global $sApp_Version,$sAppUpdate_Page = "http://www.new1ogin.guru-hosting.ru/files/Autoshot_Update.txt"
Global $sCurrent_AppVersion=$sApp_Version = "0.1"
Global $hGUI = 0
;Here we checking in quiet mode (only if new version available there will be a message).
_AppCheckUpdates_Proc($sAppUpdate_Page, $sApp_Version, 1)

Global $WindowWidth=1024, $WindowHeight=768

Global $HK, $VK,$OldCode,$Code=0,$oldCode2,$Code2=0, $UseM =0, $UseM_=5
$timeout=5
$timeSleepMacros=650

Global $nBytes,$n=76
Global $file = @ScriptDir & '\screenShotsPB\color'&$n&'.bmp'

;~ 	Opt("GUIOnEventMode", 1)
;~ 	#Region ### START Koda GUI section ### Form=D:\Vitaliy\PROGRAMS\autoitv3.3.8.1\Koda\Autoshot Shotgun2.kxf
;~ 	$hForm = GUICreate("Autoshot Shotgun", 271, 238, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
;~ 	GUISetOnEvent($GUI_EVENT_CLOSE, "Terminate")
;~ 	$Tab1 = GUICtrlCreateTab(0, 0, 265, 169)
;~ 	$TabSheet1 = GUICtrlCreateTabItem("Настройки")
;~ 	$timeoutI = GUICtrlCreateInput("16", 156, 33, 97, 21)
;~ 	GUICtrlSetTip(-1, "Можно увеличить для того чтобы не лагало,"&@CRLF&"или уменьшить чтобы выстрел происходил быстрее.")
;~ 	$Label3 = GUICtrlCreateLabel("Задержка обновления", 12, 33, 118, 17)
;~ 	GUICtrlSetTip(-1, "Можно увеличить для того чтобы не лагало,"&@CRLF&"или уменьшить чтобы выстрел происходил быстрее.")
;~ 	$timeSleepMacrosI = GUICtrlCreateInput("400", 156, 81, 97, 21)
;~ 	GUICtrlSetTip(-1, "Чем меньше значение тем быстрее вы будете делать следующий выстрел."&@CRLF&"Но слишком маленькая задержка приведёт к тому, чтопосле смены выстрела"&@CRLF&"не произойдёт. Подбирайте этот параметр для своего компьютера"&@CRLF&"используя тест макроса и если двигаясь по диагонали(W+D)"&@CRLF&"у Вас всё работает, значит проблем не возникнет.")
;~ 	$timedownI = GUICtrlCreateInput("32", 156, 57, 97, 21)
;~ 	GUICtrlSetTip(-1, "Можно вообще не менять. Слишком маленькая задержка"&@CRLF&"может привести к 'не проходящему' клику.")
;~ 	$Label1 = GUICtrlCreateLabel("Мин-ое время перезарядки", 12, 81, 144, 17)
;~ 	GUICtrlSetTip(-1, "Значение имеет смысл менять только если "&@CRLF&"у вас есть купон быстрой смены, в обчном "&@CRLF&" же случае игра просто не даст выстрелить "&@CRLF&" быстрее. Маленькое значение может пивести"&@CRLF&" к смене без выстрела.")
;~ 	$Label2 = GUICtrlCreateLabel("Задержка на клик", 12, 57, 97, 17)
;~ 	GUICtrlSetTip(-1, "Можно вообще не менять. Слишком маленькая задержка"&@CRLF&"может привести к 'не проходящему' клику.")
;~ 	$UseMacros = GUICtrlCreateCombo("Вариант2-безопасный", 132, 136, 121, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
;~ 	GUICtrlSetData(-1, "Вариант1-быстрый|Не исполоьзовать|Только макрос (!1)|Только макрос (!2)")
;~ 	GUICtrlSetTip(-1, "Быстрая смена Варианта-2 работает у большинства,"&@CRLF&" но медленнее. Вариант-1 будет работать быстрее,"&@CRLF&" рекомендую проверить будет ли происходить смена"&@CRLF&" сначала на варианте-1.")
;~ 	$Label9 = GUICtrlCreateLabel("Использовать макрос", 12, 136, 118, 17)
;~ 	GUICtrlSetTip(-1, "Быстрая смена Варианта-2 работает у большинства,"&@CRLF&" но медленнее. Вариант-1 будет работать быстрее,"&@CRLF&" рекомендую проверить будет ли происходить смена"&@CRLF&" сначала на варианте-1.")
;~ 	;~ $Label10 = GUICtrlCreateLabel("Label10", 12, 104, 42, 17)
;~ 	;~ $Input6 = GUICtrlCreateInput("In*put6", 156, 104, 97, 21)
;~ 	;~ $TabSheet2 = GUICtrlCreateTabItem("Клавиши")
;~ 	;~ $Label4 = GUICtrlCreateLabel("Старт Автошота в окне ПБ", 8, 32, 139, 17)
;~ 	;~ $Input1 = GUICtrlCreateInput("Input1", 160, 32, 97, 21)
;~ 	;~ $Input2 = GUICtrlCreateInput("Input2", 160, 56, 97, 21)
;~ 	;~ $Label5 = GUICtrlCreateLabel("Пауза", 8, 56, 35, 17)
;~ 	;~ $Input3 = GUICtrlCreateInput("Input3", 160, 80, 97, 21)
;~ 	;~ $Label6 = GUICtrlCreateLabel("Запустить тест макроса", 8, 80, 128, 17)
;~ 	;~ $Input4 = GUICtrlCreateInput("Input4", 160, 104, 97, 21)
;~ 	;~ $Label7 = GUICtrlCreateLabel("Уменьшить задержку макр.", 8, 104, 147, 17)
;~ 	;~ $Label8 = GUICtrlCreateLabel("Увеличить задержку макр.", 8, 126, 142, 17)
;~ 	;~ $Input5 = GUICtrlCreateInput("Input5", 160, 126, 97, 21)
;~ 	$TabSheet3 = GUICtrlCreateTabItem("Информация")
;~ 	GUICtrlCreateEdit("", 4, 33, 249, 129, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$WS_VSCROLL))
;~ 	GUICtrlSetData(-1, StringFormat("Для запуска автошота:\r\n-Установте третий прицел(жирная точка)\r\n-В окне ПБ нажмите клавишу Insert,\r\nили на звездочку, на доп. клавиатуре\r\n-Если вы слышали короткий звук, и\r\nвылезло окошко "&Chr(39)&"Отклонение успешно.."&Chr(39)&"\r\nзначит автошот будет работать\r\n-Если вы услышали длинный высокий звук\r\nпопробуйте ещё раз чуть позже\r\n\r\nДля работы макроса:\r\n-Вы можете настроить параметры смены,\r\nдля более быстрой стрельбы под себя.\r\n-Для определения задержки макроса\r\nиспользуйте в игре клавишу PageDown.\r\n-Наведите мышью на параметры, для их\r\nподробного описания.\r\n\r\nНастройки\r\n-Вы можете выбрать горячие клавиши\r\nдля работы Автошота на вкладке\r\n"&Chr(39)&"Клавиши"&Chr(39)&".\r\n-Для получения информации о настройках\r\nНаведите мышью на параметры, для их\r\nподробного описания.\r\n\r\n"))
;~ 	GUICtrlCreateTabItem("")
;~ 	$Button1 = GUICtrlCreateButton("Применить", 8, 208, 75, 25)
;~ 	GUICtrlSetOnEvent(-1, "_apply")
;~ 	$Button2 = GUICtrlCreateButton("Пауза", 96, 208, 75, 25)
;~ 	GUICtrlSetOnEvent(-1, "_Pause")
;~ 	$Button3 = GUICtrlCreateButton("Закрыть", 184, 208, 75, 25)
;~ 	GUICtrlSetOnEvent(-1, "Terminate")
;~ 	$hHotKey = _GUICtrlHotKey_Create($hForm, _GUICtrlHotKey_MakeKeyCode($HOTKEYF_ALT, $VK_F5), 152, 176, 105, 21)
;~ 	GUICtrlSetTip(-1, "Нажмите выбранную клавишу когда будете в игре.")
;~ 	$Label11 = GUICtrlCreateLabel("Горячая клавиша запуска", 8, 176, 136, 17)
;~ 	GUICtrlSetTip(-1, "Нажмите выбранную клавишу когда будете в игре.")
;~ 	GUISetState(@SW_SHOW)
;~ 	#EndRegion ### END Koda GUI section ###


_HotKeyAssign(0x0474, '_DetectWindow_and_start')


;~ 	Func _apply()
;~ 					$OldCode=$Code
;~ 		$Code = _GUICtrlHotKey_GetHotKey($hHotKey)
;~ 				_GUICtrlHotKey_GetKeys($Code, $HK, $VK)
;~ 							_HotKeyAssign($OldCode, "")
;~ 	;~ 					ConsoleWrite('Сбрасывается - @@ Debug(' & @ScriptLineNumber & ') : $OldCode = ' & $OldCode & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 				sleep(500)
;~ 				_HotKeyAssign($Code, '_DetectWindow_and_start')
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Code = ' & $Code & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

;~ 		$timeout=GUICtrlRead($timeoutI)
;~ 		$timeSleepMacros=GUICtrlRead($timeSleepMacrosI)
;~ 		$timedown=GUICtrlRead($timedownI)


;~ 		Switch GUICtrlSendMsg($UseMacros, $CB_GETCURSEL, 0, 0)
;~ 			Case 0
;~ 				$UseM =0
;~ 			Case 1
;~ 				$UseM =1
;~ 			Case 2
;~ 				$UseM =2
;~ 		EndSwitch

;~ 		TrayTip("Автошот", "Настройки применены", 500)
;~ 		Sleep(500)
;~ 	EndFunc


;Отслеживание Правой кнопки мыши
Global $RightMouse=0
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $RightMouse = ' & $RightMouse & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
Dim $hMHook, $pMHook, $hHook
$hMHook = DllCallbackRegister('LowLevelMouseProc', 'long', 'int;wparam;lparam')
$pMHook = DllCallbackGetPtr($hMHook)
$hHook = _WinAPI_SetWindowsHookEx($WH_MOUSE_LL, $pMHook, _WinAPI_GetModuleHandle(0))
Func LowLevelMouseProc($iCode, $iwParam, $ilParam)
 If $iCode < 0 Then Return _WinAPI_CallNextHookEx($hHook, $iCode, $iwParam, $ilParam)
 Switch $iwParam
  Case 0x204
;~    $MC=true
		If $RightMouse=0 Then
			$RightMouse=1
		Else
			$RightMouse=0
		EndIf
   ConsoleWrite("Внимание! Щелчок мыши"&@CRLF)
   Return _WinAPI_CallNextHookEx($hHook, $iCode, $iwParam, $ilParam)
 EndSwitch
 Return _WinAPI_CallNextHookEx($hHook, $iCode, $iwParam, $ilParam)
EndFunc





Opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 2)

global $command=0,$winx,$winy,$hWnD,$starttime,$MAP,$Paused,$Pos1x=0,$Pos1y=0,$xcor=1001,$ycor=1001,$timeout,$pricelx,$pricely,$4y,$sArray
global $getcolordcC,$getcolordcM,$getcolordcB,$getcolordcL,$schet=0,$posy,$schet2=0,$schet3=0,$sArray[2],$sArray,$BulletCoord=0,$Num_cycles=16,$timedown=24,$timeSleepMacros=660,$numDetect=0
global $exit=0, $FirstShot=0, $FirstShotTimer=0,$NextShotTimer=0, $Time2macros,$Time1macros

HotKeySet("{NUMPADMULT}", "_DetectWindow_and_start")
;~ HotKeySet("{F7}", "_Ctrl_Win")
HotKeySet("{F8}", "_OpredeleniePricela")
HotKeySet("{F9}", "_DetectWindowPB")
HotKeySet("{End}", "Terminate")
HotKeySet("{F5}", "_testmacros3")
HotKeySet("{PgDn}", "_testmacros4")
_HotKeyAssign(192, '_RightClickCorrect')
;~ HotKeySet("{End}", "Terminate")
HotKeySet("{home}", "_Pause")

Func Terminate()
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

;~ msgbox(0,'автошот',''

;~ InputBox('автошот','Установте третий прицел (жирная точка)'&@CRLF&'После закрытия окна, в игре нажмите клавишу "*" на доп.клавиатуре'&@CRLF&'пауза на клавишу Home'&@CRLF&'закрыть на клавишу End'&@CRLF&'ниже введите задержку макроса в милесекундах'&@CRLF&'СЕЙЧАС НАЖМИТЕ ОК, остальное потом',600,'',250,210)


;~ _MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "_Mouse",0,0)
While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

EndSwitch
Sleep(100)
WEnd



Func _DetectWindow_and_start()
	$numDetect+=1
	;получение размера рабочего элемента окна
	$hWnD = WinGetHandle("[ACTIVE]")
	if not @error then
		$sControl = ControlGetFocus($hWnD)
		$aPos = ControlGetPos($hWnD, "", $sControl)
		$winx = $aPos[2]
		$winy = $aPos[3]
	Else
	EndIf


	;определение ширины окна и расчёт поправки координаты x
	Dim $coord[2]
	$Xcoordinat_detected_YES = 0
	$getcolor = 0
ConsoleWrite($winx&'  '&$winy&@CRLF)

	;поиск отклонений - в меню
	$ArrayMenu=PixelSearchEx(0, 0, $winx, $winy, 0xD6D9DD, 3, 77, 1, $hWnD)
	If Not @error then
		ConsoleWrite('inmenu pixelsearchex coords X= '&$ArrayMenu[0]&'; Y= '&$ArrayMenu[1]&@CR)
		$Xcoordinat_detected_YES = 1
		$xcor = $ArrayMenu[0]-117
		$ycor = $ArrayMenu[1]-12
					TrayTip("Подсказка", 'Отклонение в координатах успешно установленно !' & $xcor&'  '&$ycor, 1000)
			Beep(1000, 200)
			sleep(1500)
	endif

	;только в х64 поиск отклонений - до боя в меню
;~ 	$coord = PixelSearch(0, 0, $winx, $winy, 0x2A344D, 10, 1, $hWnD)
;~ 	If Not @error and $coord[0]<100 and $coord[1]<100 And $Xcoordinat_detected_YES=0 Then
;~ 		$Xcoordinat_detected_YES = 1
;~ 		$xcor = $coord[0]
;~ 		$ycor = $coord[1]
;~ 		if $xcor<>1001 or $ycor<>1001 then
;~ 			TrayTip("Подсказка", 'Отклонение в координатах успешно установленно !' & $xcor&'  '&$ycor, 1000)
;~ 			Beep(1000, 200)
;~ 			sleep(1500)
;~ 		Else
;~ 			sleep(1500)
;~ 			if $numDetect<5 then _DetectWindow_and_start()
;~ 		EndIf


;~ 	Else
		;Поиск отклонений в игре по плюсикуна карте
		$Array=PixelSearchEx(0, 0, $winx, $winy, 0x9C9A9C, 1, 13, 1, $hWnD)
		if @error And $Xcoordinat_detected_YES=0 then
		TrayTip("Подсказка", "Отклонение в координатах не установленно :(", 1000)
		Beep(9000, 1000)
		sleep(1500)
		Dim $Array[2]
		$Array[0]=1001+135
		$Array[1]=1001+170
		endif

		If $Xcoordinat_detected_YES=0 then
			$xcor = $Array[0] -135
			$ycor = $Array[1] -170
			$Xcoordinat_detected_YES = 1

			if $xcor<>1001 or $ycor<>1001 then
				TrayTip("Подсказка", 'Отклонение в координатах успешно установленно !' & $xcor&'  '&$ycor, 1000)
				Beep(1000, 200)
				sleep(1500)
			Else
;~ 				sleep(1500)
;~ 				if $numDetect<5 then _DetectWindow_and_start()
			EndIf
		endif

;~ 	EndIf

ConsoleWrite($xcor&'  '&$ycor&@CRLF)

if $ycor<>0 then
	$4y=($winy*0.0102)
Else
	$4y=0
EndIf


$pricelx=Round (($winx/2)-$xcor) + $xcor
$pricely=Round (($winy/2)-$ycor+$4y) + $ycor
ConsoleWrite($pricelx&'  '&$pricely&@CRLF)
ConsoleWrite($hwnd&@CRLF)





if $Xcoordinat_detected_YES = 1 Then
;~ 	if  GUICtrlRead($CheckBox1) = 1 then

_func2()
;~ 		If $UseM <>2 Then
;~ 			If $UseM=3 Then
;~ 				_Macros_Only(1)
;~ 			Else
;~ 				_Macros_Only(0)
;~ 			EndIf

;~ 			_func2()
;~ 		Else
;~ 			_func0()
;~ 		EndIf


Else
		TrayTip("Подсказка", "Отклонение в координатах не установленно :(", 1000)
		Beep(9000, 1000)
		sleep(1500)
EndIf

 _Ctrl_Win()

;~ 0x2A344D

;~ 	while 1
;~ $cx = random(-500,500,1)+500
;~ 	$cy = random(-300,300,1)+300
$cx=870
$cy=770-20
;~ mousemove($cx,$cy)
;~ MouseDown ( "left" )
;~ sleep(64)
;~ Mouseup ( "left" )
;~ sleep(200)


;~ MouseClick('left',870,770-20)
;~ sleep(200)
;~ MouseClick('left',870,770-20)

;~ while 1

;~ 					;поворот ~92%
;~ 					$schet=$schet+1
;~ 					$aPos = MouseGetPos()
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aPosx = ' & $aPos[0]) ;### Debug Console
;~ 					ConsoleWrite('       $aPosy = ' & $aPos[1]  & @crlf) ;### Debug Console

;~ 					if $schet=1 then $posy=$aPos[1]
;~ 												ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $schet = ' & $schet & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 					if $schet=1 then
;~ 					mousemove($aPos[0]+1	,$aPos[1],10)
;~ 					else
;~ 					mousemove($Pos1x+(($aPos[0]-$Pos1x)/50)+1	,$Pos1y+(($aPos[1]-$Pos1y)/50),10)
;~ 					endif
;~ 					if $schet=1 then
;~ 					$Pos1x=$aPos[0]
;~ 					$Pos1y=$aPos[1]
;~ 					endif

;~ 					sleep(1000)

										;поворот ~92%
;~ 					$schet=$schet+1
;~ 					$aPos = MouseGetPos()
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aPosx = ' & $aPos[0]) ;### Debug Console
;~ 					ConsoleWrite('    $aPosy = ' & $aPos[1]  & @crlf) ;### Debug Console

;~ 					if $schet=1 then $posy=$aPos[1]
;~ 					mousemove($aPos[0]-1	,$aPos[1],10)

;~ 					sleep(1000)
;~ 					wend

;~ ;зажатие и отжатие клавиши W
;~ _WinAPI_Keybd_Event(0x57, 0)
;~ sleep(1500)
;~ _WinAPI_Keybd_Event(0x57, 2)

;~ ;зажатие и отжатие клавиши M
;~ _WinAPI_Keybd_Event(57, 0)
;~ sleep(1500)
;~ _WinAPI_Keybd_Event(57, 2)

;пример
;~ _WinAPI_Keybd_Event(Number($a[0]), $iFlags)
;~ _WinAPI_keybd_event ($vkCode, $iScanCode, $iFlag, $iExtraInfo) (required: #include <WinAPIEx.au3>)

;~ $getcolorL = Hex(PixelGetColor(511 + $xcor, 383 + $ycor, $hWnD), 6)
;~ $getcolorL = Hex(PixelGetColor(523 + $xcor, 484 + $ycor), 6/)
;~ consolewrite($getcolorL)

;~ 0x35FF35

;~ MsgBox(0,'',$getcolorL)
;~ traytip('',$getcolorL	,100)
;~ sleep(300)
;~ wend

traytip('','я закончил',500)

EndFunc



func _func1()
;~ $i=0

while 1
$sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,0,1,$hWnD)
;~ if not @error then ConsoleWrite('Est1-'&$sArray[0]&'-'&$sArray[1]&'  ')
;~ $sArray=pixelsearch($winx, 0,0 , $winy,0xABA8A3,0,1,$hWnD)
;~ $sArray=pixelsearch(130,24, 130,24,0x394051,1,1,$hWnD)
if @error then
	ConsoleWrite('No'&@CRLF)
Else
	$BulletCoord=1
;~ 	ConsoleWrite('Est2 '&$sArray[0]&'  '&$sArray[1]&'  ')
EndIf

;~ if not @error then

;~ endif
for $r=0 to $Num_cycles						;ИЗМЕНИТЬ ЗНАЧЕНИЕ ДЛЯ АВТОМАТОВ!!!!!!!!!!!!!!
;~ $i+=1
;~ зеленый 0x61FF40
;~ красный 0xFF573B 0xFF1617 0xFF0000

$getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
;~ $getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)
IF $getcolorL = 'FFFFFF' Then
sleep(64)
_func1()
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
if $getcolorLs = 'FF' Then  ;ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
;~ 	consolewrite('SHOT'&@CRLF)
	MouseDown ( "left" )
	sleep(50)
	if $BulletCoord=1 Then
		$BulletCoord=0
	$getcolorBullet = PixelGetColor($sArray[0],$sArray[1], $hWnD)
;~ 	ConsoleWrite ('$getcolorBullet = '&$getcolorBullet&@CRLF)
	if $getcolorBullet=0xABA8A3 then _macros()

	endif
	Mouseup ( "left" )
	_func1()
;~ 	consolewrite($getcolorL& '  ')
else
	sleep ($timeout)
endif
;~ consolewrite($getcolorL& '  ')
;~ consolewrite($getcolorLs& '  ')
next
wend
endfunc

;простой выстрел оп прицелу
func _func0()
;~ $i=0

while 1
;~ $sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,0,1,$hWnD)
;~ if not @error then ConsoleWrite('Est1-'&$sArray[0]&'-'&$sArray[1]&'  ')
;~ $sArray=pixelsearch($winx, 0,0 , $winy,0xABA8A3,0,1,$hWnD)
;~ $sArray=pixelsearch(130,24, 130,24,0x394051,1,1,$hWnD)
;~ if @error then
;~ 	ConsoleWrite('No'&@CRLF)
;~ Else
;~ 	$BulletCoord=1
;~ 	ConsoleWrite('Est2 '&$sArray[0]&'  '&$sArray[1]&'  ')
;~ EndIf

;~ if not @error then

;~ endif
;~ for $r=0 to 9						;ИЗМЕНИТЬ ЗНАЧЕНИЕ ДЛЯ АВТОМАТОВ!!!!!!!!!!!!!!
;~ $i+=1
;~ зеленый 0x61FF40
;~ красный 0xFF573B 0xFF1617 0xFF0000

;~ $getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
$getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)
;~ IF $getcolorL = 'FFFFFF' Then
;~ sleep(64)
;~ _func0()
;~ endif
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
;~ $getcolorLs=StringLeft ( $getcolorL, 2 );ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ

if $getcolorL = 0xFF0000 Then
;~ if $getcolorL = 'FF0000' Then
;~ if $getcolorLs = 'FF' Then  ;ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
;~ 	consolewrite('SHOT'&@CRLF)
	MouseDown ( "left" )
	sleep($timedown)
;~ 	if $BulletCoord=1 Then
;~ 		$BulletCoord=0
;~ 	$getcolorBullet = PixelGetColor($sArray[0],$sArray[1], $hWnD)
;~ 				ConsoleWrite ('$getcolorBullet = '&$getcolorBullet&@CRLF)
;~ 	if $getcolorBullet=0xABA8A3 then _macros()

;~ 	endif
	Mouseup ( "left" )
;~ 	consolewrite($getcolorL& '  ')
else
	sleep ($timeout)
endif
;~ consolewrite($getcolorL& '  ')
;~ consolewrite($getcolorLs& '  ')
;~ next
wend
endfunc

;выстрел по нику
Func _Func_snaipa_nick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _Func_snaipa_nick() = '  & '>Error code: ' & @error & @CRLF) ;### Debug Console

	Local $pixelFind, $TimePixel,$schetTimePixel=0,$TimePixelAll
	While 1
		$schetTimePixel+=1
		$TimePixel=TimerInit()
		$pixelFind=PixelSearch($pricelx-1,70+$ycor,$pricelx-1,$pricely-1,0xFF0000)
;~ 		$pixelFind=PixelSearch($pricelx-1,$pricely-1,$pricelx-1,70+$ycor,0xFF0000)
		If Not @error Then
			$TimePixelAll+=TimerDiff($TimePixel)
			If $RightMouse=0 Then
				MouseDown ( "right" )
				Sleep(40)
				MouseDown ( "left" )
				sleep($timedown)
				Mouseup ( "left" )
				Mouseup ( "right" )
				Sleep(284)
				MouseDown ( "right" )
				sleep($timedown)
				Mouseup ( "right" )
			Else
				MouseDown ( "left" )
				sleep($timedown)
				Mouseup ( "left" )
			EndIf


			If $schetTimePixel / 10 = Round($schetTimePixel / 10) Then
				ConsoleWrite(' Координаты: ' & $pixelFind[0] &'  '& $pixelFind[1])
			EndIf
		Else
			$TimePixelAll+=TimerDiff($TimePixel)
			sleep ($timeout)
		endif

		If $schetTimePixel / 100 = Round($schetTimePixel / 100) Then
			ConsoleWrite(' среднее время пикселсеарч = ' & $TimePixelAll/$schetTimePixel &@CRLF)
		EndIf
	wend
EndFunc

;выстрел по нику
Func _Func_droba_nick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _Func_droba_nick() = '  & '>Error code: ' & @error & @CRLF) ;### Debug Console

	Local $pixelFind, $TimePixel,$schetTimePixel=0,$TimePixelAll
	While 1
;~ 		$schetTimePixel+=1
;~ 		$TimePixel=TimerInit()
;~ 		$pixelFind=PixelSearch($pricelx-1,70+$ycor,$pricelx-1,$pricely-1,0xFF0000)
		$getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)
		If Not @error Then
;~ 			$TimePixelAll+=TimerDiff($TimePixel)
			if $getcolorL = 0xFF0000 Then
				MouseDown ( "left" )
				sleep($timedown)
				Mouseup ( "left" )
					_WinAPI_Keybd_Event(0x33, 0) ;клавиша 3
					sleep($timedown)
					_WinAPI_Keybd_Event(0x33, 2) ;клавиша 3

					_WinAPI_Keybd_Event(0x31, 0) ;клавиша 1
					sleep($timedown)
					_WinAPI_Keybd_Event(0x31, 2) ;клавиша 1
				Sleep(640)

			else
				sleep ($timeout)
			endif
;~ 			If $RightMouse=0 Then
;~ 				MouseDown ( "right" )
;~ 				Sleep(40)
;~ 				MouseDown ( "left" )
;~ 				sleep($timedown)
;~ 				Mouseup ( "left" )
;~ 				Mouseup ( "right" )
;~ 				Sleep(284)
;~ 				MouseDown ( "right" )
;~ 				sleep($timedown)
;~ 				Mouseup ( "right" )
;~ 			Else
;~ 				MouseDown ( "left" )
;~ 				sleep($timedown)
;~ 				Mouseup ( "left" )
;~ 			EndIf


;~ 			If $schetTimePixel / 10 = Round($schetTimePixel / 10) Then
;~ 				ConsoleWrite(' Координаты: ' & $pixelFind[0] &'  '& $pixelFind[1])
;~ 			EndIf
		Else
;~ 			$TimePixelAll+=TimerDiff($TimePixel)
			sleep ($timeout)
		endif

;~ 		If $schetTimePixel / 100 = Round($schetTimePixel / 100) Then
;~ 			ConsoleWrite(' среднее время пикселсеарч = ' & $TimePixelAll/$schetTimePixel &@CRLF)
;~ 		EndIf
	wend
EndFunc


func _macros($UseM_=5)

;~ 	5 10010 1005
;~ 60 780	720
;~ 915
;~ 720
;~ 0xABA8A3
;~ consolewrite( '_macros  '&@CRLF)
;~ $sArray=pixelsearch(1005, 720, 915, 720,0xABA8A3,$hWnD)
;~ $getcolorBullet = PixelGetColor($sArray[0],$sArray[1], $hWnD)
;~ if $getcolorBullet=0xABA8A3 then _macros()
;~ sleep(124)
If $UseM=0 Or $UseM_=0 then
;~ 	~90мс на выполнение. Включая две задержки по 32мс
	$Time0macros=TimerInit()
	Send("{3 down}")
	sleep($timedown)
	Send("{3 up}")

	Send("{1 down}")
	sleep($timedown)
	Send("{1 up}")
	ConsoleWrite("Медл.вариант2 = "&TimerDiff($Time0macros)-($timedown*2)&"  Медл.вариант2 = "&TimerDiff($Time0macros)&@CR)
Else
;~ 	~70-75мс на выполнение. Включая две задержки по 32мс
	$Time1macros=TimerInit()
	_WinAPI_Keybd_Event(0x33, 0) ;клавиша 3
	sleep($timedown)
	_WinAPI_Keybd_Event(0x33, 2) ;клавиша 3

	_WinAPI_Keybd_Event(0x31, 0) ;клавиша 1
	sleep($timedown)
	_WinAPI_Keybd_Event(0x31, 2) ;клавиша 1
	ConsoleWrite("Быстр.вариант1 = "&TimerDiff($Time1macros)-($timedown*2)&"   Быстр.вариант1 = "&TimerDiff($Time1macros)&@CR)
endif


Mouseup ( "left" )
;~ sleep($timeSleepMacros)											;задержка макроса


endfunc


func _testmacros($mode=0)
;~ 	$sArray=pixelsearch(1005+$ycor, 716+$xcor , 915+$ycor , 725+$xcor ,0xABA8A3,5,1,$hWnD)
for $i=0 to 7
	MouseDown ( "left" )
	$timer=TimerInit()
	sleep($timedown)

	_WinAPI_Keybd_Event(0x33, 0) ;клавиша 3
	sleep($timedown)
	_WinAPI_Keybd_Event(0x33, 2) ;клавиша 3
	_WinAPI_Keybd_Event(0x31, 0) ;клавиша 1
	sleep($timedown)
	_WinAPI_Keybd_Event(0x31, 2) ;клавиша 1
		Mouseup ( "left" )
		sleep(400)
	MouseDown ( "left" )

	$sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,10,1,$hWnD)
	if @error then
		ConsoleWrite('Error pixelsearch '&@CRLF)
	Else
		$BulletCoord=1
		ConsoleWrite("Start "&TimerDiff($timer)) ;248
		ConsoleWrite('   '&$sArray[0]&'  '&$sArray[1]&'  ')
	EndIf

	while $exit=0
		if $BulletCoord=1 Then
			$getcolorBullet=0
			$getcolorBullet = pixelsearch($sArray[0], $sArray[1] , $sArray[0] , $sArray[1] ,0xABA8A3,10,1,$hWnD)
				if @error Then
					$BulletCoord=0
					ConsoleWrite(@CR&"  NO "&TimerDiff($timer)) ;778 780
					Mouseup ( "left" )
					$exit=1
				Else

				EndIf

		Else
		EndIf
	wend
	$exit=0
next


EndFunc


FUNC _testmacros2()

;~ 		$sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,10,1,$hWnD)
		$sArray=pixelsearch(1005+$xcor, 716+$ycor , 915+$xcor , 716+$ycor ,0x6C6E68,10,1,$hWnD)

	if @error then
		ConsoleWrite('Error pixelsearch '&@CRLF)
	Else
		$BulletCoord=1
;~ 		ConsoleWrite("Start "&TimerDiff($timer)) ;248
		ConsoleWrite('   '&$sArray[0]&'  '&$sArray[1]&'  ')
	EndIf
	$testtimer=TimerInit()
	MouseDown ( "left" )
$exit=0
$i=0
	while $exit=0
		$i+=1
		if $BulletCoord=1 Then
			$getcolorBullet=0
			$getcolorBullet = pixelsearch($sArray[0], $sArray[1] , $sArray[0] , $sArray[1] ,0x6C6E68,10,1,$hWnD)
				if @error Then
					$BulletCoord=0
					ConsoleWrite(@CR&$i&"  NO "&TimerDiff($testtimer)) ;778 780
					Mouseup ( "left" )
					$exit=1
				Else

				EndIf

		Else
		EndIf
	wend
	Mouseup ( "left" )
EndFunc

;~ ~400мс на выполенние. Включая две задержки по 32мс
FUNC _testmacros3()

;~ 	Run ("D:\Vitaliy\PROGRAMS\autoitv3.3.8.1\macrospb2.exe")
;~ 	Sleep(1000)
;~ 	$Title = 'PlaybackForm' ; The Name Of The Game...
;~ $Full = WinGetTitle ($Title) ; Get The Full Title..
;~ $HWnD = WinGetHandle ($Full) ; Get The Handle
;~ ConsoleWrite($HWnD)
;~ $mLeft="left"
;~ $mRight="right"
	$Time2macros=TimerInit()

;~ 	Run ("D:\Vitaliy\PROGRAMS\autoitv3.3.8.1\macrospb2.exe")

;~ 	_WinAPI_Keybd_Event(0xDC, 0) ;клавиша 3
;~ 	sleep($timedown)
;~ 	_WinAPI_Keybd_Event(0xDC31, 2) ;клавиша 3

;~ 		ConsoleWrite("macrorecorder2 = "&TimerDiff($Time2macros)-(32*2)&"   macrorecorder2 = "&TimerDiff($Time2macros))

Send("{\}")
;~ ControlSend($HWnD, "328738", "toolStrip1", "{\}")

EndFunc

FUNC _testmacros4()
;~ 	$Time0macros=TimerInit()




		ConsoleWrite("macrorecorder2 = "&TimerDiff($Time2macros)-(32*2)&"   macrorecorder2 = "&TimerDiff($Time2macros)&@CR)

;~ 		ConsoleWrite("m31acrorecorder2 = "&TimerDiff($Time1macros)-(32*2)&"   macrorecorder2 = "&TimerDiff($Time1macros)&@CR)

EndFunc



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


func _Mouse()
	ConsoleWrite("1 ")
	sleep($timeSleepMacros)
;~ 	if  GUICtrlRead($CheckBox1) = 1 then
		_func2()
;~ 	Else
;~ 		_func0()
;~ 	EndIf

EndFunc


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

func _shot()

while 1
;~ 	for $r=0 to $Num_cycles+55						;ИЗМЕНИТЬ ЗНАЧЕНИЕ ДЛЯ АВТОМАТОВ!!!!!!!!!!!!!!
;~ 	$FirstShot=1

;~ $getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
$getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)


if $getcolorL = 0xFF0000 Then
	MouseDown ( "left" )
;~ 	$FirstShot+=1
	$FirstShotTimer=Timerinit()
	sleep($timedown)
;~ 	if $FirstShot=1 then
;~ 		$FirstShot=0
		_macros()
		_shot3()
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


func _shot3()
;~ $FirstShot=0

;~ 	for $r=0 to $Num_cycles+55						;ИЗМЕНИТЬ ЗНАЧЕНИЕ ДЛЯ АВТОМАТОВ!!!!!!!!!!!!!!
;~ 	$FirstShot=1
while 1
	$timeForWhile=TimerDiff($FirstShotTimer)
	if $timeForWhile>500 then
		ConsoleWrite("TimerDiff($FirstShotTimer)>500"&@CR)
		if $timeForWhile>800 then _func2()
		ExitLoop
	Else
	endif
	sleep(56)
WEnd

;Ищем количество патронов
$sArray=pixelsearch(1005+$xcor, 716+$ycor , 915+$xcor , 716+$ycor ,0x6C6E68,10,1,$hWnD)
if @error then
	ConsoleWrite('Error pixelsearch '&@CRLF)
Else
	$BulletCoord=1
;~ 		ConsoleWrite("Start "&TimerDiff($timer)) ;248
	ConsoleWrite('   '&$sArray[0]&'  '&$sArray[1]&'  ')
EndIf



		;пытаемся выстрелить когда изменится цвет прицела
while 1
;~ $getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);ВЕРСИЯ С ВТОРЫМ ПРИЦЕЛОМ
	$getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)
	if TimerDiff($FirstShotTimer)>790 then Return

	if $getcolorL = 0xFF0000 Then
		MouseDown ( "left" )
;~ 		$exit=0
;~ 		$i=0

		;Ищет изменение кол-ва патронов, после удачного выстрела
		$timerDown=TimerInit()
		while TimerDiff($timerDown)<$timedown
;~ 			$i+=1
			if $BulletCoord=1 Then
				$BulletCoord=0
				$getcolorBullet=0
				$getcolorBullet = pixelsearch($sArray[0], $sArray[1] , $sArray[0] , $sArray[1] ,0x6C6E68,10,1,$hWnD)
					if @error Then
						$BulletCoord=0
						$FirstShotTimer=Timerinit()-20
;~ 						ConsoleWrite(@CR&"  Выстрел произошол "&TimerDiff($testtimer)) ;778 780
						ConsoleWrite(@CR&"  Выстрел произошол ") ;778 780
						Mouseup ( "left" )
						sleep(30)
						_macros()
						_shot3()
					Else

					EndIf

			Else
			EndIf
		wend
		Mouseup ( "left" )


	else
		sleep ($timeout)
	endif

;~ consolewrite($getcolorLs& '  ')
;~ next
wend

endfunc


;~ inmenu pixelsearchex coords X= 957; Y= 105
;~ corr coords X= 840; Y= 93
;поиск окна пб
Func _DetectWindowPB()
	Opt('PixelCoordMode', 1)
	Opt("MouseCoordMode", 1)
		ConsoleWrite('----------------------------DetectWindowCoords-----------------------------' & @CRLF)
	$time_extraction=TimerInit()
	$shade=3
	$shade2=3
	$Xcoordinat_detected_YES = 0
	;поиск отклонений - в меню по логотипу Поинтбланк
	$ArrayMenu=PixelSearchEx(0, 0, @DesktopWidth, @DesktopHeight, 0xD6D9DD, $shade, 77, 1, $hWnD)
	If Not @error then
		ConsoleWrite('inmenu pixelsearchex coords X= '&$ArrayMenu[0]&'; Y= '&$ArrayMenu[1]&@CR)
		$Xcoordinat_detected_YES = 1
		$xcor = $ArrayMenu[0]-117
		$ycor = $ArrayMenu[1]-12
		ConsoleWrite('corr coords X= '&$xcor&'; Y= '&$ycor &@CR)
			Beep(1000, 100)
;~ 		MouseMove($xcor,$ycor) ;отладка
		Sleep(1000)
		$winx=$xcor+$WindowWidth
		$winy=$ycor+$WindowHeight
;~ 		MouseMove($winx,$winy) ;отладка

		TrayTip("Подсказка", 'Окно PointBlank успешно найденно! Координаты угла окна- x: ' & $xcor&', y: '&$ycor, 1000)
		Beep(1000, 200)
	Else
		;Поиск отклонений в игре по плюсикуна карте
		$Array=PixelSearchEx(0, 0, @DesktopWidth, @DesktopHeight, 0x9C9A9C, 3, 13, 1, $hWnD)
		If Not @error then
			$Xcoordinat_detected_YES = 1
			$xcor = $Array[0] -135
			$ycor = $Array[1] -170
			$winx=$xcor+$WindowWidth
			$winy=$ycor+$WindowHeight
			ConsoleWrite('corr coords X= '&$xcor&'; Y= '&$ycor &@CR)
				TrayTip("Подсказка", 'Окно PointBlank успешно найденно ! Координаты угла окна- x: ' & $xcor&', y: '&$ycor, 1000)
				Beep(1000, 200)
				ConsoleWrite(' НАЙДЕННО ПО ПЛЮСИКУ КАРТЫ!!!' &@CRLF )
		Else
			TrayTip("Подсказка", "Окно PointBlank не найденно попробуйте позже  :(", 1000)
			Beep(9000, 1500)
			sleep(1500)
			$xcor = 0
			$ycor = 0
		endif
	endif

	If $Xcoordinat_detected_YES = 1 Then
		$pricelx=Round (($WindowWidth/2)) + $xcor
		$pricely=Round (($WindowHeight/2)) + $ycor
		ConsoleWrite('Прицел: '&$pricelx&'  '&$pricely&@CRLF)
		ConsoleWrite($hwnd&@CRLF)
;~ $i=-1
;~ 			For $i=-2 To 2
;~ 				For $ii=-2 To 2
					For $t=1 To 300
					ConsoleWrite(Hex(PixelGetColor($pricelx-1, $pricely-1),6)&@CRLF)
					Sleep(100)
					next
	EndIf

_Func_snaipa_nick()
;~ _Func_droba_nick()
EndFunc

;более ненужная функуция
Func _OpredeleniePricela()
		$pricelx=Round (($WindowWidth/2)) + $xcor
		$pricely=Round (($WindowHeight/2)) + $ycor
		ConsoleWrite('Прицел: '&$pricelx&'  '&$pricely&@CRLF)
		ConsoleWrite($hwnd&@CRLF)
;~ $i=-1
;~ 			For $i=-2 To 2
;~ 				For $ii=-2 To 2
					For $t=1 To 3
;~ 					ConsoleWrite(Hex(PixelGetColor($pricelx+-1, $pricely+-1),6)&' +x: '&$i&' +Y: '&$ii&@CRLF)
					ConsoleWrite(Hex(PixelGetColor($pricelx-1, $pricely-1),6)&@CRLF)
					Sleep(100)
					next
;~ 				Next
;~ 			next
EndFunc


FUNC _testMaksim()




;~ 					_WinAPI_Keybd_Event(0x20, 2)
;~ 					sleep(random(300,900,1))
;~ 					_WinAPI_Keybd_Event(0x20, 0) ;пробел
;~ 	0x09 таб
;~ 	41 42 43 44 45 46 47 48 49 4A 4B 4C 4D 4E 4F 50 51 52 53 54 55 56 57 58 59 5A
;~ 	a  b  c  d  e  f  g  h  i  j  k  l  m  n  o  p  q  r  s  t  u  v  w  x  y  z


_WinAPI_Keybd_Event(0x57, 0)
traytip('','бегу вперёд',500)
sleep(1000)
_WinAPI_Keybd_Event(0x57, 2)
sleep(200)
_WinAPI_Keybd_Event(0x53, 0)
traytip('','бегу назад',500)
sleep(1000)
_WinAPI_Keybd_Event(0x53, 2)
sleep(200)
_WinAPI_Keybd_Event(0x20, 0)
traytip('','прыгаю',500)
sleep(200)
_WinAPI_Keybd_Event(0x20, 2)
sleep(200)
_WinAPI_Keybd_Event(0x20, 0)
sleep(200)
_WinAPI_Keybd_Event(0x20, 2)
sleep(200)
_WinAPI_Keybd_Event(0x20, 0)
sleep(200)
_WinAPI_Keybd_Event(0x20, 2)
sleep(200)
_WinAPI_Keybd_Event(0x09, 0)
traytip('','Смотрю карту',500)
sleep(1000)
_WinAPI_Keybd_Event(0x09, 2)
;~ 0x30 - 0x39 - (0 - 9) key
sleep(200)
_WinAPI_Keybd_Event(0x31, 0)
traytip('','Клавиша "1"',500)
sleep(1000)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
traytip('','Клавиша "2"',500)
sleep(1000)
_WinAPI_Keybd_Event(0x32, 2)
sleep(200)
_WinAPI_Keybd_Event(0x33, 0)
traytip('','Клавиша "3"',500)
sleep(1000)
_WinAPI_Keybd_Event(0x33, 2)
sleep(200)
_WinAPI_Keybd_Event(0x34, 0)
traytip('','Клавиша "4"',500)
sleep(1000)
_WinAPI_Keybd_Event(0x34, 2)
sleep(200)

$i=256
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=128
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=86
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=64
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=44
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=32
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=27
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=20
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=16
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=12
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=8
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(1500)

$i=4
traytip('','Быстрая смена '&$i,500)
_WinAPI_Keybd_Event(0x31, 0)
sleep($i)
_WinAPI_Keybd_Event(0x31, 2)
sleep(200)
_WinAPI_Keybd_Event(0x32, 0)
sleep($i)
_WinAPI_Keybd_Event(0x32, 2)
sleep(500)

TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	exit
EndFunc

FUNC _testMaksim2()

	Sleep(1000)
	traytip('','Бегу вперёд вариант 1',500)
Send("{w down}")
Sleep(1000)
Send("{w up}")
Sleep(1000)
	traytip('','Бегу вперёд вариант 2',500)
Send("{ц down}")
Sleep(1000)
Send("{ц up}")
Sleep(1000)




$i=256
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=128
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=86
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=64
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=44
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=32
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=27
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=20
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=16
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)


$i=12
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)


$i=8
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=4
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)

$i=2
traytip('','Быстрая смена '&$i,500)
Send("{1 down}")
sleep($i)
Send("{1 up}")
sleep(200)
Send("{2 down}")
sleep($i)
Send("{2 up}")
sleep(1500)


TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	exit
endfunc

Func _Macros_Only($UseM_=0)

	While 1

			;Ищем количество патронов
		$sArray=pixelsearch(1005+$xcor, 716+$ycor , 915+$xcor , 716+$ycor ,0x6C6E68,10,1,$hWnD)
		if @error then
			ConsoleWrite('Error pixelsearch '&@CRLF)
		Else
	;~ 		$BulletCoord=1
		;~ 		ConsoleWrite("Start "&TimerDiff($timer)) ;248
			ConsoleWrite('   '&$sArray[0]&'  '&$sArray[1]&'  ')


	;~ 					$BulletCoord=0
						$getcolorBullet=0
						$getcolorBullet = pixelsearch($sArray[0], $sArray[1] , $sArray[0] , $sArray[1] ,0x6C6E68,10,1,$hWnD)
							if @error Then
	;~ 							$BulletCoord=0
	;~ 							$FirstShotTimer=Timerinit()-20
		;~ 						ConsoleWrite(@CR&"  Выстрел произошол "&TimerDiff($testtimer)) ;778 780
								ConsoleWrite(@CR&"  Выстрел произошол ") ;778 780
	;~ 							Mouseup ( "left" )
								sleep(30)
								_macros($UseM_)
	;~ 							_shot3()
							Else

							EndIf


		EndIf



				;пытаемся выстрелить когда изменится цвет прицела


		;~ consolewrite($getcolorLs& '  ')
		;~ next

	wend

EndFunc

Func _RightClickCorrect()
		If $RightMouse=0 Then
			$RightMouse=1
			TrayTip(' Подсказка','Сейчас зум на снайпе активирован',1000)
		Else
			$RightMouse=0
			TrayTip(' Подсказка','Сейчас зум на снайпе НЕактивирован',1000)
		EndIf
	ConsoleWrite("_RightClickCorrect"&@CRLF)
EndFunc


Func _AppCheckUpdates_Proc($sServer_Page, $sCurrent_AppVersion, $iMode=-1) ;$iMode <> -1 to check quitly
    Local $sUpdate_Info = _INetGetSource($sServer_Page)

    If Not StringInStr($sUpdate_Info, "[Info]") Then
        If $iMode = -1 Then MsgBox(48, "Update check", _
            StringFormat("There was an error (%i) to check update, please contact with the author.", 1), 0, $hGUI)

        Return SetError(1, 0, 0)
    EndIf

    Local $sUpdate_Version = StringRegExpReplace($sUpdate_Info, "(?s)(?i).*Update Version=(.*?)(\r|\n).*", "\1")
    Local $sUpdate_File = StringRegExpReplace($sUpdate_Info, "(?s)(?i).*Update File=(.*?)(\r|\n).*", "\1")

    If _VersionCompare($sUpdate_Version, $sCurrent_AppVersion) = 1 Then
        Local $iUpdate_Ask = MsgBox(36, "Update check", _
            StringFormat("There is new version available (%s).\n\nWould you like to download the update?", $sUpdate_Version), _
            0, $hGUI)

        If $iUpdate_Ask <> 6 Then Return 0

        Local $sScript_Name = StringTrimRight(@ScriptName, 4) & ".efe"

        Local $iInetGet = InetGet($sUpdate_File, @TempDir & "\" & $sScript_Name)

        If @error Or Not $iInetGet Then
            If $iMode = -1 Then MsgBox(48, "Update check", _
                StringFormat("There was an error (%i) to download the update, please contact with the author.", 2), 0, $hGUI)

            Return SetError(2, 0, 0)
        EndIf

        Run(@ComSpec & ' /c Ping -n 2 localhost > nul & Move /y "' & _
            @TempDir & '\' & $sScript_Name & '" "' & @ScriptFullPath & '" & Start "" "' & @ScriptFullPath & '"', '', @SW_HIDE)

        Exit
    EndIf

    If $iMode = -1 Then MsgBox(48, "Update check", "You are using the newest version of this software.", 0, $hGUI)
    Return 1
EndFunc







