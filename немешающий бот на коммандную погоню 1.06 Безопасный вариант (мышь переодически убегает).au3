AutoItSetOption("WinTitleMatchMode",1)
$Title = 'NEED FOR SPEED' ; The Name Of The Game...
$Full = WinGetTitle ($Title) ; Get The Full Title..
$HWnD = WinGetHandle ($Full) ; Get The Handle

HotKeySet("{ScrollLock}", "Terminate")
Func Terminate()
   TrayTip ("���������","��� ������, ����� �������� :)",1500)
   sleep (1000)
    Exit 0
EndFunc

Global $Paused
HotKeySet("{INS}", "U")
Func U()
    $Paused = NOT $Paused
    While $Paused
	   TrayTip ("���������","��� �������������, ��� ����������� ������� Ins",399)
        sleep (400)
    WEnd
EndFunc

$timeout = InputBox ( "NFSWBOT", '��� ��� NFS World ��� ���������� ������.' & @CR & '1. ��������� NFS � ������ � ������ ���� 800�600' & @CR & '2.������������� ����� �� ��������! � ��������� � �������� ������ ����. ' & @CR & '4. � ����� ���������: ����, ����������� ������(infinite powerups), ���������(DrunkDriver)' & @CR & '���� ������ ������ ����� ������������� � ������:' & @CR & '1 = 10 ���' & @CR & '2 = 20 ���' & @CR & '3 = 30 ���' & @CR & '����� ������� ���� ������� - (Skroll Lock). ����� ��������� �� ����� - (Insert)' , "3" , "", -1, 400) 


AutoItSetOption("MouseCoordMode",2)

For $i = 0 TO 99000
   ;InputBox ('��� ����?', '��� ����?')
   ;if @error = 1 then exit
   
   





; ���� ��������� �� ���� ��� ��� � 20 ���
; ���� ���������� ����� �� �����
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
 ;����������� start race
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
   
   ;����������� ���������� �����
   $TitleNow = WinGetTitle("[active]")
   $pos = MouseGetPos()
   WinActivate ($HWnD)
   MouseMove(659,478+Random ( -1, 1, 1), 0)
   ControlClick ($HWnD, '','', "left", 1, 659, 478+Random ( -1, 1, 1))
   WinActivate ($TitleNow)
   MouseMove($pos[0],$pos[1],0)
	
	ControlClick ($HWnD, '','', "left", 1, 100+Random ( -6, 6, 1), 250+Random ( -6, 6, 1)); ���������� ������ powerup
	
	  
	  For $i = 0 TO 20
	  ;start race
	  $WinID=$HWnD
	  $ret=DllCall("user32.dll", "long", "LoadKeyboardLayout", "str", "00000409", "int", 0)
	  DllCall("user32.dll", "ptr", "SendMessage", "hwnd", $WinID, "int", "0x50", "int", 1, "int", $ret[0])

	  ControlSend ($HWnD, '','', '[')
	  ControlSend ($HWnD, '','', 'J')
	  ControlClick ($HWnD, '','', "left", 1, 380+Random ( -20, 20, 1), 300+Random ( -20, 20, 1))  ;�������� ������� ��������
	  ControlClick ($HWnD, '','', "left", 1, 405+Random ( -3, 3, 1), 430+Random ( -3, 3, 1)) ;���� ������� ���� "��������� ����"
	  ControlClick ($HWnD, '','', "left", 1, 659, 478+Random ( -1, 1, 1)) ;���������� �����
	  sleep (500+Random ( -10, 200, 1))
	  Next
   
   Next


Next


;~ ; ������� ����� ����������� ������, � ��� ��� ��������� ����� ������ 343-����� ������ 335�����������