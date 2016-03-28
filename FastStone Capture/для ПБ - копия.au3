#include <WinAPI.au3>
#include <WinAPIEx.au3>
   #include <Encoding.au3>
   #include <Excel.au3>
   #include <Date.au3>
#include <Misc.au3>
#include <GUIConstantsEx.au3>
#include <GUIEdit.au3>

   Global $ClipHome, $ClipEnd

   Global $Rus = 0x00000419; Раскладка русского языка
   Global $Eng = 0x00000409; Раскладка английского языка
   Global $Title1, $Full1, $HWnDTextPipe, $sLayoutID, $WM_INPUTLANGCHANGEREQUEST, $aRet, $hWnd
global $schet=0



AutoItSetOption("WinTitleMatchMode",1)
$Title = 'Macro Recorder' ; The Name Of The Game...
$Full = WinGetTitle ($Title) ; Get The Full Title..
$HWnD = WinGetHandle ($Full) ; Get The Handle
if $HWnD = 0 Then
	$Title = 'Jitbit Macro Recorder' ; The Name Of The Game...
	$Full = WinGetTitle ($Title) ; Get The Full Title..
	$HWnD = WinGetHandle ($Full) ; Get The Handle
EndIf

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $HWnD = ' & $HWnD & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console


;~ 	_WinAPI_LoadKeyboardLayoutEx($Eng); переводим раскладку в АНГЛ иначе не будут работать сочетания клавиш
;~ 	_WinAPI_LoadKeyboardLayoutEx(0x0409)
;~ 	_SendEx("^"&"R") ;обход залипания клавиш
	_SendEx("^R") ;обход залипания клавиш


_WinAPI_Keybd_Event(0xA2, 0) ;клавиша левый CONTROL
_WinAPI_Keybd_Event(0x52, 0)
sleep(64)
_WinAPI_Keybd_Event(0x52, 2)
_WinAPI_Keybd_Event(0xA2, 2)







   Func _WinAPI_LoadKeyboardLayoutEx($sLayoutID = 0x0409, $hWnd = 0)
	   Local Const $WM_INPUTLANGCHANGEREQUEST = 0x50
	   Local $aRet = DllCall("user32.dll", "long", "LoadKeyboardLayoutW", "wstr", Hex($sLayoutID, 8), "int", 0)

	   If Not @error And $aRet[0] Then
		   If $hWnd = 0 Then
			   $hWnd = WinGetHandle(AutoItWinGetTitle())
		   EndIf

		   DllCall("user32.dll", "ptr", "SendMessage", "hwnd", $hWnd, "int", $WM_INPUTLANGCHANGEREQUEST, "int", 1, "int", $aRet[0])
		   Return 1
	   EndIf

	   Return SetError(1)

	EndFunc

Func _SendEx($sSend_Data)
    Local $hUser32DllOpen = DllOpen("User32.dll")

    While _IsPressed("10", $hUser32DllOpen) Or _IsPressed("11", $hUser32DllOpen) Or _IsPressed("12", $hUser32DllOpen)
        Sleep(10)
    WEnd

    Send($sSend_Data)

    DllClose($hUser32DllOpen)
EndFunc
