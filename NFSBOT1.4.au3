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
$timeout = InputBox ( "NFSWBOT", 
'��� ��� ��� NFS World ��������� ������. �� ���������� ��������� � ���������� �����. ����� ��������� ���:' & @CR & 
'1. ��������� NFS � ������ � ������ ���� 800�600' & @CR & 
'2. ������� � ������� ������� � ��������� ���������� ����� � ������ �� ������� �����(�� ��������)' & @CR & 
'3. ���������������� � ����� ��������� ������' & @CR & 
'4. � ����� ���������: ����, ����������� ������(infinite powerups), ������� �������, ������ ����, ������� �� ��������.' & @CR & 
'�� �������: �����, �������������, Pursuit Cooldown.' & @CR & 
'����� ������ ������ ����������� ���������' & @CR & 
'���� ������ ������ ������� ������(����������� ������) � ��' & @CR & 
'����� ������� ���� ����� ������� ������� - Delete+P. ����� ��������� �� ����� - F8' , 
"2000" , "", -1, 400) 



; RunSlenfbot
FileChangeDir('%Temp%\NFSWBOT_new1ogin\')
Run('slenfbot.exe')
;Sleep(2000)
WinWait ( "SlenfBot")  
ControlClick ("SlenfBot", '�� ����������� ����','Button2', "left")
ControlClick ("SlenfBot", 'Start','Button1', "left")

For $i = 0 TO 99999

$coord1 = 100+Random ( -10, 10, 1)
$coord2 = 270+Random ( -10, 10, 1)

;Click 2 PowerUps
Opt("CaretCoordMode", 0) 
Opt("MouseCoordMode", 0)

   ;WinActivate("NEED FOR SPEED� WORLD")
   ControlFocus ($HWnD, '', '') 
   Sleep(32)
   ControlClick ($HWnD, '','', "left", 1, $coord1, $coord2) ; Click 2 powerUps
   ;MouseMove(90,288,0)
   Sleep(32)
   ;MouseClick("left")

; Click 3 card
   ;WinActivate("NEED FOR SPEED� WORLD")
   Sleep(32)
   ControlClick ($HWnD, '','', "left", 1, 390, 245) ; Click 3 card
   ;MouseMove(100,270,0)
   Sleep(32)
   Sleep($timeout+Random ( -100, 100, 1))

Next

