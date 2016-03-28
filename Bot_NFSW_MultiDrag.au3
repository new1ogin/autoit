#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=NFSW_drag.ico
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
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
#include <color.au3>
#include "MouseOnEvent.au3"

Opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 0)

global $command=0,$winx,$winy,$hWnD,$starttime,$MAP,$Paused, $exit
global $getcolordcC,$getcolordcM,$getcolordcB,$getcolordcL,$schet=0,$posy,$schet2=0,$schet3=0
#region data

#endregion data

;Графический интерфейс
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=D:\Vitaliy\PROGRAMS\autoitv3.3.8.1\NFSW.kxf
$Form1_2 = GUICreate("Бот на мультиплеерный драг в NFSW", 263, 229, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
$Checkbox1 = GUICtrlCreateCheckbox("Запустить бот используя Speed Hack", 8, 144, 249, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateEdit("", 8, 8, 249, 129, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlSetData(-1, StringFormat("1. Откройте NFS World в окне 800х600\r\n2. Присоеденитесь к многопользвовательской\r\nигре в ДРЕГ (например ROCKPORT)\r\n3. Переключите коробку передачь на автомат\r\n4. Используйте NFSW_hack (by gmz)\r\nи активируйте F5 (Drunk Driver)\r\n5. Нажмите Запуск\r\n\r\nОкно бота вы можете просто свернуть"))
$Button2 = GUICtrlCreateButton("Запуск", 33, 200, 89, 25)
GUICtrlSetOnEvent(-1, "_DetectWindow_and_start")
$Combo1 = GUICtrlCreateCombo("3", 160, 168, 97, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "4|5|1|2")
$Label1 = GUICtrlCreateLabel("Выберите номер карточки", 8, 168, 138, 17)
$Button1 = GUICtrlCreateButton("Пауза", 145, 200, 89, 25)
;~ GUICtrlSetOnEvent(-1, "_Pause")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



GUIRegisterMsg($WM_SYSCOMMAND, 'WM_SYSCOMMAND')

func WM_SYSCOMMAND($hWnd, $Msg, $wParam, $lParam)
;~ 	exit
	if $wParam=0xF060 then _Pro_Exit()
EndFunc

GUIRegisterMsg($WM_COMMAND, "WM_COMMAND")
func WM_COMMAND($hWnd, $Msg, $wParam, $lParam)
	Local $nID = BitAND($wParam, 0x0000FFFF) ; _WinAPI_LoWord
;~ 	ConsoleWrite($nID & '  ')
	if $nID = $Button1 then _Pause()
	if $nID = $Button2 then _DetectWindow_and_start()
EndFunc
;~ HotKeySet("{home}", "_DetectWindow_and_start")
;~ HotKeySet("{end}", "_Pro_Exit")
;~ HotKeySet("{end}", "_easy_fight")
;~ HotKeySet("{pgdn}", "_Pause")

;Выход из бота по нажатию кнопки Выход
Func _Pro_Exit()
	TrayTip("Подсказка", "Бот закрыт, всего хорошего :)", 1500)
	WinActivate($hWnD)
	WinWaitActive($hWnD)
	send('{pgup up}')
	send('{UP up}')
	send('{ц up}')
	Sleep(1000)
	Exit
	$exit=1
EndFunc   ;==>_Pro_Exit()


Func _Pause()
	if $exit=1 then exit
	 WinSetState($Form1_2, '', @SW_MINIMIZE)
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		Sleep(100)
		If $trayP = 1 Then TrayTip("Подсказка", "Пауза", 1000)
	WEnd
;~ 	WinActive($Form1_2)
EndFunc   ;==>_Pause

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

EndSwitch
sleep(100)
WEnd

Func _DetectWindow_and_start()
if $exit=1 then exit
	;получение хендла и размера рабочего элемента окна
	$hWnD = WinGetHandle("NEED FOR SPEED™ WORLD")
	$sControl = ControlGetFocus($hWnD)
	$aPos = ControlGetPos($hWnD, "", $sControl)
	$winx = $aPos[2]
	$winy = $aPos[3]

	;выбор карточки
	$cardy=280
	$cardx=380
$CardN = GUICtrlSendMsg($Combo1, $CB_GETCURSEL, 0, 0)
If $CardN = 4 Then $cardx=250
If $CardN = 3 Then $cardx=130
If $CardN = 2 Then $cardx=630
If $CardN = 1 Then $cardx=510
If $CardN = 0 Then $cardx=380

;отправка в окно NFSW зажатых клавиш и возвращение в предыдущее окно
$hWnD_activ = WinGetHandle("[ACTIVE]")
WinActivate($hWnD)
WinWaitActive($hWnD)
;зажатие PgDown для ускорения если эта функция отмечена галочкой
If GUICtrlRead($CheckBox1) = 1 Then send('{pgup down}')
;~ send('{UP down}')
sleep(12)
WinActivate($hWnD_activ)

TrayTip('Подсказка','Бот запущен',1500)

;запуск бесконечного цикла кликов
while 1

ControlClick($hWnD, '', '', "left", 1, 660 , 475) ;нажатие всех далее
sleep(500)
ControlClick($hWnD, '', '', "left", 1, 660 , 475) ;нажатие всех далее
sleep(500)
ControlClick($hWnD, '', '', "left", 1, 660 , 475) ;нажатие всех далее
sleep(500)
ControlClick($hWnD, '', '', "left", 1, 660 , 475) ;нажатие всех далее
sleep(500)
ControlClick($hWnD, '', '', "left", 1, 660 , 475) ;нажатие всех далее
sleep(500)
ControlClick($hWnD, '', '', "left", 1, 405 , 435) ;закрытие информационного окна
ControlClick($hWnD, '', '', "left", 1, $cardx , $cardy) ;выбор карточки
Controlsend($hWnD, '', '', '\')
Controlsend($hWnD, '', '', '[')
Controlsend($hWnD, '', '', 'j')
sleep(1000)

wend




EndFunc


