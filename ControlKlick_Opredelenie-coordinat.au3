#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>

Global $tStruct = DllStructCreate($tagPOINT)
Global $cx1, $cy1, $cy2, $cx2, $cx, $cy, $centerx, $centery, $n, $sControl, $move, $maxlong, $detect1, $detect2
Global $EDIT_DEF_ITEMS[1][2] = [[0, 0]]

AutoItSetOption("WinTitleMatchMode",1)
$Title = 'Челябинск 2013 - Мертвая зона' ; The Name Of The Game...
$Full = WinGetTitle ($Title) ; Get The Full Title..
$HWnD = WinGetHandle ($Full) ; Get The Handle

opt('PixelCoordMode', 0)

HotKeySet("{ScrollLock}", "Terminate")
Func Terminate()
   TrayTip ("Подсказка","Программа закрыта, Всего хорошего :)",1500)
   sleep (1000)
    Exit 0
EndFunc

HotKeySet("{F2}", "_doit") ;определение элемента внутри рабочего окна
HotKeySet("{F3}", "pause")
Func pause()
MsgBox ( '', 'Координаты','Координаты последнего клика внутри области' & @CR &  "X : " &$cx1 & "Y : " & $cy1)
$detect1= PixelChecksum ( 0, 500, 1000, 501, 2)
EndFunc   ;==>pause
HotKeySet("{F4}", "_doit")

;~ $dots=10
;~ $n=Round(Sqrt($dots))

$move=5	;шаг в пикселях
$timeout = 500
_gui_dlya_vvoda()

func _gui_dlya_vvoda()
$hGui = GUICreate('Программа', 350, 250, -1, -1, -1)
;~ $hGui = GUICreate('Программа')
;~ GUICtrlCreateLabel('Программа предназначена для "прокликивания" всей выбранной области приложения.' & @CR & 'Для выбора области шелкните по ней мышкой и нажмите клавишу "F2"' & @CR & 'Для закрытия программы нажмите клавишу "Scroll Lock"' & @CR & 'Для остановки кликов и просмотра последних координат клика нажмите клавишу "F3"' & @CR & 'Введите расстояние между кликами в пикселях:', 10, 10, 330, 110)
;~ 		 $nEdit1 = GUICtrlCreateInput("", 5, 5, 100, 20)
;~ 		 _GUICtrlEdit_SetDefault($nEdit1, "This is the test", 0xFFC1C1, 0x0000FF)
$move = GUICtrlCreateInput('20', 10, 120, 150, 20)
;~ _GUICtrlEdit_SetDefault($move, "This is the test", 0xFFC1C1, 0x0000FF)
;~ GUICtrlSetColor(-1, 0x505050)
;~ GUICtrlCreateLabel('Введите дополнительный таймаут между кликами в миллисекундах:', 10, 150, 330, 110)
;~ 		 $nEdit2 = GUICtrlCreateInput("", 5, 30, 100, 20)
;~ 		 _GUICtrlEdit_SetDefault($nEdit2, "Take 2.", 0x989898)
$timeout = GUICtrlCreateInput('100', 10, 185, 150, 20)
;~ 		 _GUICtrlEdit_SetDefault($timeout, "This is the test", 0xFFC1C1, 0x0000FF)
;~ _GUICtrlEdit_SetDefault($timeout, "Take 2.", 0x989898)

;~ GUICtrlCreateInput("Just a standard input", 5, 55, 200, 20)
;~ GUICtrlSetState(-1, $GUI_FOCUS)
GUICtrlCreateLabel('Программа предназначена для "прокликивания" всей выбранной области приложения.' & @CR & 'Для выбора области шелкните по ней мышкой и нажмите клавишу "F2"' & @CR & 'Для закрытия программы нажмите клавишу "Scroll Lock"' & @CR & 'Для остановки кликов и просмотра последних координат клика нажмите клавишу "F3"' & @CR & 'Введите расстояние между кликами в пикселях:', 10, 10, 330, 110)
GUICtrlCreateLabel('Введите дополнительный таймаут между кликами в миллисекундах:', 10, 150, 330, 30)


;~ $nEdit1 = GUICtrlCreateInput("", 5, 5, 100, 20)
;~ _GUICtrlEdit_SetDefault($nEdit1, "This is the test", 0xFFC1C1, 0x0000FF)

;~ $nEdit2 = GUICtrlCreateInput("", 5, 30, 100, 20)
;~ _GUICtrlEdit_SetDefault($nEdit2, "Take 2.", 0x989898)

;~ GUICtrlCreateInput("Just a standard input", 5, 55, 200, 20)
;~ GUICtrlSetState(-1, $GUI_FOCUS)

;~ GUISetState()

;~ While GUIGetMsg() <> -3
;~ WEnd




GUISetState()
;~ GUIRegisterMsg($WM_COMMAND, 'WM_COMMAND')
;~ if @error=1 then Exit 0

While 1
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            GUICtrlDelete($hGui)
			traytip('',$move,100)
			sleep(2000)
			exit
    EndSwitch
WEnd

$nMsg = GUIGetMsg()
    Switch $nMsg
		Case $GUI_EVENT_CLOSE
						traytip('',$move,100)
			sleep(2000)
EndSwitch

EndFunc
While 1
    Sleep(100)
WEnd


Func _Click($cx, $cy)
   if $cx<$centerx*2 AND $cy<$centery*2 and $cx>0 and $cy>0 then

   opt('MouseCoordMode', 0)
   Mousemove($cx, $cy+41)
   ControlClick ($HWnD, '',$sControl, "left", 1, $cx, $cy)

   Else
   EndIf
EndFunc


   ;срабатываниеавтопаузы
;~ Func _DetectChange()
;~ $detect2= PixelChecksum ( 0, 500, 1000, 501, 2)
;~ if $detect1<>$detect2 then pause()
;~ EndFunc   ;==>DetectChange

; присвоение координат для кликов от центра к краям по спирали, через определённый шаг
Func _doit()

   ;Определение изменений на экране для срабатывания автопаузы


   ;получение размера рабочего элемента окна
   $hWnd = WinGetHandle("[ACTIVE]")
    $sControl = ControlGetFocus($hWnd)
    $aPos = ControlGetPos($hWnd, "", $sControl)
    $aPos = ControlGetPos($hWnd, "", "")
;~     ConsoleWrite("X : "&$aPos[0] & @LF)
;~     ConsoleWrite("Y : "&$aPos[1] & @LF)
;~     ConsoleWrite("Ширина "&$aPos[2] & @LF)
;~     ConsoleWrite("Высота: "&$aPos[3] & @LF)

	;получение размера окна
	WinGetPos($hWnD)
	if @error<>1 then
	$winx=$aPos[2]
	$winy=$aPos[3]
	  Else
	Endif
    ConsoleWrite("Ширина окна "&$aPos[2] & @LF)
    ConsoleWrite("Высота окна: "&$aPos[3] & @LF)

	;вычисление центра рабочего элемента окна
   $centerx=$aPos[2]/2
   $centery=$aPos[3]/2
   $cx1=$aPos[2]/2 - 40
   $cy1=$aPos[3]/2 +60

   ;вычисление максимального размера площади для кликов внутри рабочего элемента окна
   If $centerx>$centery Then
			$maxlong=$centerx*2
		 Else
			$maxlong=$centery*2
		 EndIf
   $n=Round($maxlong/$move)


   For $i = 1 TO $n

	  If Mod($i, 2) = 0 Then
		  $znaky=-1	;это чётное число.
		  $znakx=1
	  Else
		  $znakx=-1	;это нечётное число.
		  $znaky=1
	  EndIf

	  if $cx2<>0 then $cx1=$cx2 ;отладка


	  For $i2 = 1 TO $i

;~ 	  _DetectChange()

	  $cx1=$cx1
	  $cy1=$cy1+($move*$znaky)

	  $cx2=$cx1
	  $cy2=$cy1

	   if $i2=$n Then
;~ 		  ConsoleWrite("i="&$i2 & @LF)
;~ 		  ConsoleWrite("X1 : "&$centerx & '  ')
;~ 		  ConsoleWrite("Y1 : "&$centery & @LF)
		  _Click($centerx,$centery)
	   Else

;~ 	  ControlFocus ($HWnD, '','')
;~ 	  ControlClick ($HWnD, '','', "left", 1, $cx1, $cy1)
;~ 	  ConsoleWrite("X1 : "&$cx1 & '  ')
;~ 	  ConsoleWrite("Y1 : "&$cy1 & @LF)
	  _Click($cx1,$cy1)
	  sleep($timeout)
	   EndIf
	  Next


;~    $cx1=$cx2
;~    $cy1=$cy2

    if $i<$n then
	  For $i3 = 1 TO $i

;~ 		 _DetectChange()

	  $cx2=$cx2+($move*$znakx)
	  $cy2=$cy2

;~ 	  ControlFocus ($HWnD, '','')
;~ 	  ControlClick ($HWnD, '','', "left", 1, $cx2, $cy2)
;~ 	  ConsoleWrite("X2 : "&$cx2 & '  ')
;~ 	  ConsoleWrite("Y2 : "&$cy2 & @LF)
	  _Click($cx2,$cy2)
	   sleep($timeout)
	  Next
    EndIf
;~ ConsoleWrite("i="&$i & @LF)
;~    $c1=666
;~    $c2=100
;~
;~    WinActivate($HWnD)
;~    ControlFocus ($HWnD, '','')
;~    ControlClick ($HWnD, '','', "left", 1, $centerx, $centery)
;~    ControlClick ($HWnD, '','', "left", 1, $c1, $c2)


   Next
EndFunc   ;==>doit














;~ Func _GUICtrlEdit_SetDefault($hEdit, $sDefText, $nDefColor = 0x989898, $nTextColor = 0x000000)
;~     If $hEdit = 0 Then
;~         Return SetError(1, 0, 0)
;~     EndIf
;~
;~     If $EDIT_DEF_ITEMS[0][0] = 0 Then
;~         GUIRegisterMsg($WM_COMMAND, "__EDIT_DEF_WM_COMMAND")
;~     EndIf
;~
;~     If GUICtrlRead($hEdit) = "" Then
;~         GUICtrlSetColor($hEdit, $nDefColor)
;~         GUICtrlSetData($hEdit, $sDefText)
;~     EndIf
;~
;~     $EDIT_DEF_ITEMS[0][0] += 1
;~     ReDim $EDIT_DEF_ITEMS[$EDIT_DEF_ITEMS[0][0] + 1][4]
;~
;~     $EDIT_DEF_ITEMS[$EDIT_DEF_ITEMS[0][0]][0] = $hEdit
;~     $EDIT_DEF_ITEMS[$EDIT_DEF_ITEMS[0][0]][1] = $sDefText
;~     $EDIT_DEF_ITEMS[$EDIT_DEF_ITEMS[0][0]][2] = $nDefColor
;~     $EDIT_DEF_ITEMS[$EDIT_DEF_ITEMS[0][0]][3] = $nTextColor
;~
;~     Return 1
;~ EndFunc   ;==>_GUICtrlEdit_SetDefault

;~ Func __EDIT_DEF_WM_COMMAND($hWnd, $msgID, $wParam, $lParam)
;~     Local $n = __EDIT_DEF_GETINDEX(BitAND($wParam, 0xFFFF))
;~
;~     If $n = -1 Then
;~         Return $GUI_RUNDEFMSG
;~     EndIf
;~
;~     Local $nMsg = BitShift($wParam, 16)
;~
;~     If $nMsg = $EN_SETFOCUS Then ; Gained focus (EN_SETFOCUS)
;~         If (GUICtrlRead($EDIT_DEF_ITEMS[$n][0]) == $EDIT_DEF_ITEMS[$n][1]) Then
;~             GUICtrlSetColor($EDIT_DEF_ITEMS[$n][0], $EDIT_DEF_ITEMS[$n][3])
;~             GUICtrlSetData($EDIT_DEF_ITEMS[$n][0], "")
;~         EndIf
;~     ElseIf $nMsg = $EN_KILLFOCUS Then ; Lost Focus (EN_KILLFOCUS)
;~         If GUICtrlRead($EDIT_DEF_ITEMS[$n][0]) = "" Then
;~             GUICtrlSetColor($EDIT_DEF_ITEMS[$n][0], $EDIT_DEF_ITEMS[$n][2])
;~             GUICtrlSetData($EDIT_DEF_ITEMS[$n][0], $EDIT_DEF_ITEMS[$n][1])
;~         EndIf
;~     EndIf
;~ EndFunc   ;==>__EDIT_DEF_WM_COMMAND

;~ Func __EDIT_DEF_GETINDEX($hEdit)
;~     For $i = 1 To UBound($EDIT_DEF_ITEMS) - 1
;~         If $EDIT_DEF_ITEMS[$i][0] = $hEdit Then
;~             Return $i
;~         EndIf
;~     Next
;~
;~     Return -1
;~ EndFunc   ;==>__EDIT_DEF_GETINDEX