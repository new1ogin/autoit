$Title = 'NEED FOR SPEED� WORLD' ; The Name Of The Game...
$Full = WinGetTitle ($Title) ; Get The Full Title..
$HWnD = WinGetHandle ($Full) ; Get The Handle
$mLeft="left"
$mRight="right"

#include <WindowsConstants.au3>
#include <WinAPI.au3>

HotKeySet("{Delete}" & "{P}", "Terminate")
Func Terminate()
   ProcessClose("slenfbot.exe")
    Exit 0
EndFunc

;User message
;$timeout = InputBox ( "NFSWBOT", '��� ��� ��� NFS World ��������� ������. �� ���������� ��������� � ���������� �����. ����� ��������� ���:' & @CR & '1. ��������� NFS � ������ � ������ ���� 800�600' & @CR & '2. ������� � ������� ������� � ��������� ���������� ����� � ������ �� ������� �����(�� ��������)' & @CR & '3. ���������������� � ����� ��������� ������' & @CR & '4. � ����� ���������: ����, ����������� ������(infinite powerups), ������� �������, ������ ����, ������� �� ��������.' & @CR & '�� �������: �����, �������������, Pursuit Cooldown.' & @CR & '����� ������ ������ ����������� ���������' & @CR & '���� ������ ������ ������� ������(����������� ������) � ��' & @CR & '����� ������� ���� ����� ������� ������� - Delete+P. ����� ��������� �� ����� - F8' , "2000" , "", -1, 400) 

WinActivate("NEED FOR SPEED� WORLD")


For $i = 0 TO 99999

$coord1 = 100+Random ( -10, 10, 1)
$coord2 = 270+Random ( -10, 10, 1)

;Click 2 PowerUps
Opt("CaretCoordMode", 0) 
Opt("MouseCoordMode", 0)

ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(50)
SLEEP(20)
;start on map (~ delay 5000)
SLEEP(10)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 255, 227)
MouseMove(255,227,0)
SLEEP(106)
SLEEP(100)
SLEEP(33)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 181, 310)
MouseMove(181,310,0)
SLEEP(80)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 181, 310)
MouseMove(181,310,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 283, 401)
MouseMove(283,401,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 479, 356) ; fix1
MouseMove(479,356,0)
SLEEP(64)
ControlSend ($HWnD, '', '', 'J') ;  enter race(no COMMENT) (max delay 9000)
SLEEP(64)
ControlSend ($HWnD, '', '', '[') ;  enter race1
SLEEP(204)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 398, 260) ;  click on the finish 2
MouseMove(398,260,0)
SLEEP(64)
; press 1 (delay20000)
SLEEP(64)
; press 3 (delay20000)
SLEEP(205)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 398, 260) ;  click on the finish 2
MouseMove(398,260,0)
SLEEP(64)
ControlSend ($HWnD, '', '', 'J') ;  enter race(no COMMENT) (max delay 9000)
SLEEP(64)
ControlSend ($HWnD, '', '', '[') ;  enter race1
SLEEP(204)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 361, 460) ;  fix2
MouseMove(361,460,0)

SLEEP(64)
ControlSend ($HWnD, '', '', '[') ;  enter race1
SLEEP(64)
ControlSend ($HWnD, '', '', 'J') ;  enter race(no COMMENT) (max delay 9000)
SLEEP(204)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(1300)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 398, 260) ;  click on the finish 2
MouseMove(398,260,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(76)
ControlSend ($HWnD, '', '', 'J') ;  enter race(no COMMENT) (max delay 9000)
SLEEP(128)
ControlSend ($HWnD, '', '', '[') ;  enter race1
SLEEP(128)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(128)
ControlSend ($HWnD, '', '', '[') ;  enter race1
SLEEP(128)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 398, 260) ;  click on the finish 2
MouseMove(398,260,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 479, 356) ; fix1
MouseMove(479,356,0)
SLEEP(32)
SLEEP(64)
ControlSend ($HWnD, '', '', 'J') ;  enter race(no COMMENT) (max delay 9000)
SLEEP(128)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(128)
ControlSend ($HWnD, '', '', '[') ;  enter race1
SLEEP(128)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(1300)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 479, 356) ; fix1
MouseMove(479,356,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 398, 260) ;  click on the finish 2
MouseMove(398,260,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(128)
ControlSend ($HWnD, '', '', 'J') ;  enter race(no COMMENT) (max delay 9000)
SLEEP(128)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(128)
ControlSend ($HWnD, '', '', '[') ;  enter race1
SLEEP(128)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 398, 260) ;  click on the finish 2
MouseMove(398,260,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(128)
ControlSend ($HWnD, '', '', 'J') ;  enter race(no COMMENT) (max delay 9000)
SLEEP(128)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(128)
ControlSend ($HWnD, '', '', '[') ;  enter race1
SLEEP(128)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 479, 356) ; fix1
MouseMove(479,356,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 398, 260) ;  click on the finish 2
MouseMove(398,260,0)
SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 361, 460) ;  fix2
MouseMove(361,460,0)

SLEEP(460)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 643, 579) ; start race (ready!) (delay1300)
MouseMove(643,579,0)
SLEEP(460)
ControlSend ($HWnD, '', '', 'J') ;  enter race(no COMMENT) (max delay 9000)
SLEEP(128)
ControlFocus ($HWnD, '', '') 
ControlClick ($HWnD, '','', "left", 1, 653, 460) ;  click on the finish 1
MouseMove(653,460,0)
SLEEP(128)
ControlSend ($HWnD, '', '', '[') ;  enter race1
SLEEP(128)


Next

