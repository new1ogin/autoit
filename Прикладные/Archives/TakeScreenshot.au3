#include <ScreenCapture.au3>
;~ #include <File.au3>
$Randomstring=''
For $i=0 to 5
	$Randomstring&=Chr(Random(Asc("A"), Asc("Z"), 1))
Next

sleep(3000)
;Делаем скриншот
_ScreenCapture_Capture(@ScriptDir & '\screenshot'&$Randomstring&'.jpg')
;~ ;Копируем скриншот в бефер обмена
;~ _ClipPutFile(@TempDir & '\screenshot.jpg')