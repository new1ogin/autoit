#include <ScreenCapture.au3>
;~ #include <File.au3>


;~ sleep(100)
;������ ��������
_ScreenCapture_Capture(@ScriptDir & '\screenshot'&@UserName&"_"&@YEAR&"-"&@MON&"-"&@MDAY&"_"&@HOUR&"-"&@MIN&"-"&@SEC&'.jpg')
exit
;~ ;�������� �������� � ����� ������
;~ _ClipPutFile(@TempDir & '\screenshot.jpg')