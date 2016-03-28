#include <WindowsConstants.au3>
#include <StaticConstants.au3>
$filetext = @ScriptDir & '\TextMessage.txt'
$text=''
if FileExists($filetext) Then
	$text = FileRead($filetext)
	$text = StringRegExpReplace($text,'//.*','')
EndIf
;~ if StringLen($text) = 0 Then
;~ 	$text = 'Сейчас на компьютере работает администратор.'  & @CRLF & 'Пожалуйста Дождитесь окончания его работы.' & @CRLF & _
;~ 	'//(Dlia administratorov: chtoby` izmenit` e`tot tekst, vnesite svoi` tekst v fai`l TextMessage.txt)'
;~ EndIf

if stringLen( $text=0 then exit
$hWndGUI =  _Message($text)
sleep(3000)
Func _Message($Message)
	$width = 400
	$height = 100
	$hWndGUI = GUICreate("Подсказка",$width,$height,Default,Default,$WS_POPUP,$WS_EX_TRANSPARENT)
	$Input = GUICtrlCreateLabel($Message, 20, 20, $width-20, $height-20, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	WinSetTrans($hWndGUI,"",500)
	GUISetState(@SW_SHOW)
	return SetError(0,$Input,$hWndGUI)
EndFunc