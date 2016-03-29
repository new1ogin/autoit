#include <ScreenCapture.au3>
;~ #include <File.au3>


;~ sleep(100)
;Делаем скриншот
_ScreenCapture_Capture(@ScriptDir & '\screenshot'&@UserName&"_"&@YEAR&"-"&@MON&"-"&@MDAY&"_"&@HOUR&"-"&@MIN&"-"&@SEC&'.jpg')
exit
;~ ;Копируем скриншот в бефер обмена
;~ _ClipPutFile(@TempDir & '\screenshot.jpg')