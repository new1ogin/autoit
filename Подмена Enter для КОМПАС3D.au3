#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=temp11.exe
#AutoIt3Wrapper_UseUpx=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinAPIEx.au3>
#include <Misc.au3>

;~ if $CmdLine[0]<>0 then
;~ 	MsgBox(0,'',$CmdLine[0])
;~ _ArrayDisplay($CmdLine)
;~ EndIf



	HotKeySet("{End}", "Terminate")

	while 1
		sleep(30)
	if _IsPressed('0D' ) then _func_enter()
	WEnd

Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

Func _func_enter()
	Opt("WinTitleMatchMode", 2)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
	$Title = 'КОМПАС-3D' ; The Name Of The Game...
	$Full = WinGetTitle ($Title) ; Get The Full Title..
	$HWnD = WinGetHandle ($Full) ; Get The Handle

	If WinActive($HWnD) <>0 then
		Send("{BS}")
		ControlClick($HWnD, '', '[CLASS:KPSPanelBar:400000:8:10003:10; ID:3200]', 'left' ,1 , 11, 12)
	Else
;~ 		Send("{ENTER}")
		ConsoleWrite('Enter start'&@CRLF)
;~ 		Send("{ENTER DOWN}")
;~ 		sleep(10)
;~ 		Send("{ENTER UP}")
;~ 		ConsoleWrite('Enter start'&@CRLF)
;~ 		_WinAPI_Keybd_Event ( 0x0D, 0)
;~ 		sleep(16)
;~ 		_WinAPI_Keybd_Event ( 0x0D, 2)
;~ 		ConsoleWrite('Enter end'&@CRLF)
	EndIf

EndFunc








