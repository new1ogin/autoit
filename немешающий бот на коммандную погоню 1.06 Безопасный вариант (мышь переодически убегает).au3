AutoItSetOption("WinTitleMatchMode",1)
$Title = 'NEED FOR SPEED' ; The Name Of The Game...
$Full = WinGetTitle ($Title) ; Get The Full Title..
$HWnD = WinGetHandle ($Full) ; Get The Handle

HotKeySet("{ScrollLock}", "Terminate")
Func Terminate()
   TrayTip ("Подсказка","Бот закрыт, Всего хорошего :)",1500)
   sleep (1000)
    Exit 0
EndFunc

Global $Paused
HotKeySet("{INS}", "U")
Func U()
    $Paused = NOT $Paused
    While $Paused
	   TrayTip ("Подсказка","Бот приостановлен, для продолжения нажмите Ins",399)
        sleep (400)
    WEnd
EndFunc

$timeout = InputBox ( "NFSWBOT", 'Это бот NFS World для коммандной погони.' & @CR & '1. Запустите NFS С ЧИТАМИ в режиме окна 800х600' & @CR & '2.Разворачиваем карту на максимум! И прижимаем к верхнему левому углу. ' & @CR & '4. В читах выставите: Танк, бесконечные бонусы(infinite powerups), Автопилот(DrunkDriver)' & @CR & 'Ниже можете ввести время присоединения к погоне:' & @CR & '1 = 10 сек' & @CR & '2 = 20 сек' & @CR & '3 = 30 сек' & @CR & 'Чтобы закрыть бота нажмите - (Skroll Lock). Чтобы поставить на паузу - (Insert)' , "3" , "", -1, 400) 


AutoItSetOption("MouseCoordMode",2)

For $i = 0 TO 99000
   ;InputBox ('Еще цикл?', 'Еще цикл?')
   ;if @error = 1 then exit
   
   





; ниже следующее не чаще чем раз в 20 сек
; фикс возврощает карту на место
;Func _ClickDragEx()
    Opt ("MouseCoordMode", 1)
    $tppp = MouseGetPos()
    Opt ("MouseCoordMode", 2)
    Opt ("PixelCoordMode", 2)
    $titAct = WinGetTitle("")
    WinActivate($HWnD)
    MouseClickDrag('left', 310, 470+Random ( -3, 3, 1), 790+Random ( -3, 3, 1), 40+Random ( -3, 3, 1), 0)
    WinActivate($titAct)
    Opt ("MouseCoordMode", 1)
    MouseMove($tppp[0], $tppp[1], 0)
    Opt ("MouseCoordMode", 2)
    Opt ("PixelCoordMode", 2)
 ;EndFunc
 
AutoItSetOption("MouseCoordMode",0)
Opt("MouseCoordMode",0)
 ;Безопастный start race
ControlClick ($HWnD, '','', "left", 1, 192-10+Random ( -3, 3, 1), 278+5+Random ( -3, 3, 1)) 
sleep (500+Random ( -100, 100, 1))
 $TitleNow = WinGetTitle("[active]")
   $pos = MouseGetPos()
   WinActivate ($HWnD)
   MouseMove(318,398,0)
   ControlClick ($HWnD, '','', "left", 1, 318+Random ( -3, 3, 1), 378+Random ( -3, 3, 1))
   WinActivate ($TitleNow)
   MouseMove($pos[0],$pos[1],0)
    
	
	
   For $a = 0 to $timeout
  ;$TitleNow = WinGetTitle("[active]")
			;AutoItSetOption("MouseCoordMode",1)
   ;$pos = MouseGetPos()
   ;WinActivate ($HWnD)
			;ControlFocus ($HWnD, '', '') 
			;AutoItSetOption("MouseCoordMode",2)
   ;MouseMove(659,478,0)
   
			;AutoItSetOption("MouseCoordMode",1)
   ;WinActivate ($TitleNow)
   ;MouseMove($pos[0],$pos[1],0)
   
   ;безопастное Завершение гонки
   $TitleNow = WinGetTitle("[active]")
   $pos = MouseGetPos()
   WinActivate ($HWnD)
   MouseMove(659,478+Random ( -1, 1, 1), 0)
   ControlClick ($HWnD, '','', "left", 1, 659, 478+Random ( -1, 1, 1))
   WinActivate ($TitleNow)
   MouseMove($pos[0],$pos[1],0)
	
	ControlClick ($HWnD, '','', "left", 1, 100+Random ( -6, 6, 1), 250+Random ( -6, 6, 1)); использует первый powerup
	
	  
	  For $i = 0 TO 20
	  ;start race
	  $WinID=$HWnD
	  $ret=DllCall("user32.dll", "long", "LoadKeyboardLayout", "str", "00000409", "int", 0)
	  DllCall("user32.dll", "ptr", "SendMessage", "hwnd", $WinID, "int", "0x50", "int", 1, "int", $ret[0])

	  ControlSend ($HWnD, '','', '[')
	  ControlSend ($HWnD, '','', 'J')
	  ControlClick ($HWnD, '','', "left", 1, 380+Random ( -20, 20, 1), 300+Random ( -20, 20, 1))  ;выбираем среднюю карточку
	  ControlClick ($HWnD, '','', "left", 1, 405+Random ( -3, 3, 1), 430+Random ( -3, 3, 1)) ;фикс Закрыть окно "необходим буст"
	  ControlClick ($HWnD, '','', "left", 1, 659, 478+Random ( -1, 1, 1)) ;Завершение гонки
	  sleep (500+Random ( -10, 200, 1))
	  Next
   
   Next


Next


;~ ; разница между поправленой картой, и той что остаеться после заезда 343-после заезда 335поправленая