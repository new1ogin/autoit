;~ #AutoIt3Wrapper_Run_Obfuscator=y
;~ #Obfuscator_Ignore_Funcs=_UnblockMouseMove
Global $Blocked=0
#include <Misc.au3>
#include <BlockInputEx.au3>

#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>



;~ #Include <HotKey.au3>
;~ #Include <HotKey_17b.au3>
;~ #Include <HotKey_20b.au3>
; Нужна только для завершения скрипта
HotKeySet("{Ins}", "_BlockMouseMove")
HotKeySet("^!b", "_BlockMouseMove1")
HotKeySet("^!u", "_UnblockMouseMove")
HotKeySet("^!и", "_BlockMouseMove1")
HotKeySet("^!г", "_UnblockMouseMove")
;~ HotKeySet("{home}", "_Pause")
;~ $CtrlAltB=0x0642
;~ $CtrlAltU=0x0655
;~ _HotKeyAssign($CtrlAltB, '_BlockMouseMove1')
;~ _HotKeyAssign($CtrlAltU, '_UnblockMouseMove', $HK_FLAG_NOBLOCKHOTKEY)


Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
Global $BlockMouseMove = GUICreate("Block Mouse Move", 316, 155, 529, 582)
GUISetOnEvent($GUI_EVENT_CLOSE, "BlockMouseMoveClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "BlockMouseMoveMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "BlockMouseMoveMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "BlockMouseMoveRestore")
Global $GroupBox1 = GUICtrlCreateGroup("", 8, 1, 297, 97)
Global $Label1 = GUICtrlCreateLabel("Для блкировки движений мыши сверните это окно,  и нажмите на выбор:"&@CRLF&"Insert - Блокировка/Разблокировка движений мыши"&@CRLF&"Ctrl+Alt+B - Блокировка движений мыши"&@CRLF&"Ctrl+Alt+U - Разблокировка движений мыши", 16, 16, 275, 70, $SS_Left)
GUICtrlSetOnEvent(-1, "Label1Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
Global $Button1 = GUICtrlCreateButton("&Свернуть окно", 17, 115, 115, 25)
GUICtrlSetOnEvent(-1, "Button1Click")
Global $Button2 = GUICtrlCreateButton("&Закрыть программу", 162, 115, 131, 25)
GUICtrlSetOnEvent(-1, "Button2Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd

Func BlockMouseMoveClose()
	Terminate()
EndFunc
Func BlockMouseMoveMaximize()

EndFunc
Func BlockMouseMoveMinimize()
	GUISetState(@SW_MINIMIZE, $BlockMouseMove)
EndFunc
Func BlockMouseMoveRestore()

EndFunc
Func Button1Click()
	GUISetState(@SW_MINIMIZE, $BlockMouseMove)
EndFunc
Func Button2Click()
	Terminate()
EndFunc
Func Label1Click()

EndFunc


Func Terminate()
	_BlockInputEx(0) ;Разблокируем все
;~ TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
;~ 	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate


;для инсерта
Func _BlockMouseMove()
	if $Blocked=0 then
		;~ While 1
		;~     If _IsPressed(4) Then
		;~         _BlockInputEx(3) ;Блокируем клавиатуру
				_BlockInputEx(2, "{MWUP}|{MWDOWN}|{MPDOWN}|{MPUP}|{MSDOWN}|{MSUP}|{MWSCROLL}")  ;Блокируем мышь, кроме всех кнопок
				$Blocked=1
		;~         Do
		;~             Sleep(100)
		;~         Until _IsPressed(4) = 0
		;~         _BlockInputEx(0) ;Разблокируем все
		;~     EndIf
		;~ WEnd

		While 1
		sleep(10)
		WEnd
	Else
		_UnblockMouseMove()
	EndIf

EndFunc

Func _BlockMouseMove1()
				_BlockInputEx(2, "{MWUP}|{MWDOWN}|{MPDOWN}|{MPUP}|{MSDOWN}|{MSUP}|{MWSCROLL}")  ;Блокируем мышь, кроме всех кнопок
				$Blocked=1

		While 1
		sleep(10)
		WEnd
EndFunc

Func _UnblockMouseMove()
;~ 	ConsoleWrite("_UnblockMouseMove"&@CRLF)
	_BlockInputEx(0) ;Разблокируем все
	$Blocked=0
EndFunc
