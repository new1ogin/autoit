#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WindowsConstants.au3>
#include <StaticConstants.au3>
#include <array.au3>
$filetext = @ScriptDir & '\TextMessage.txt'
$text = ''
$ReadFile=1
global $t=0

If FileExists($filetext) Then
	$text = FileRead($filetext)
	$text = StringRegExpReplace($text, '//.*', '')
EndIf
if StringLen($text) = 0 Then
	$ReadFile=0
	$text = 'Сейчас на компьютере работает администратор.'  & @CRLF & 'Пожалуйста Дождитесь окончания его работы.' & @CRLF & _
	'//(Dlia administratorov: chtoby` izmenit` e`tot tekst, vnesite svoi` tekst v fai`l TextMessage.txt)'
EndIf

While 1
	if $ReadFile=1 Then ; перечитываем файл
		$text = FileRead($filetext)
		$text = StringRegExpReplace($text, '//.*', '')
	EndIf
	$null=StringStripWS($text,3)
	If StringLen($null)=1 and StringInStr($null,'0') Then Exit ; условие выхода при записи 0 в файл
	$hWndGUI = _Message($text) ; создание сообщения
	Sleep(3000)
Wend
Func _Message($Message)
	$aMaxLen = _MaxLen($text,10,35)
	$width = $aMaxLen[0]
	$height = $aMaxLen[1]
	if $t=0 then
		$hWndGUI = GUICreate("Подсказка", $width, $height, Default, Default, $WS_POPUP, 0x00000028)
		$aPosTemp = WinGetPos($hWndGUI)
	Else
		WinMove ( "Подсказка", "", ((@DesktopWidth-$width)/2)-2, ((@DesktopHeight-$height)/2)-15, $width , $height)
	Endif
	$Input = GUICtrlCreateLabel($Message, 20, 20, $width - 20, $height - 20, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	if $t=0 then WinSetTrans($hWndGUI, "", 450)
	$t=1
	GUISetState(@SW_SHOW)
	Return SetError(0, $Input, $hWndGUI)
EndFunc   ;==>_Message

Func _MaxLen($text,$Kwidth=10,$Kheight=30)
	$a = StringSplit($text,@LF)
	local $l[$a[0]+1], $return[2]
	For $i=1 to $a[0]
		$l[$i]=StringLen($a[$i])
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($a[$i]) = ' & StringLen($a[$i]) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Next
	$return[0]= _ArrayMax($l)*$Kwidth
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $return[0] = ' & $return[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	$return[1]= $a[0]*$Kheight
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $return[1] = ' & $return[1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	return $return
EndFunc





