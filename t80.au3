#include <GuiToolbar.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <BlockInputEx.au3>

;~ #include <BlockInputEx.au3>
Global $X, $Y, $podmena1=0
;================== CLASSes usage Example ==================

;~ _BlockInputEx(3, '', "{TAB}|{ENTER}")
;����� �� ��������� ���� ������ ���������, ������ "Test" (������ ������ � ���� ������), � ������� ������� UP / DOWN.
HotKeySet("{Enter}", "_Podmena1") ;��� ������� _Podmena1
HotKeySet("{Enter}") ;��� ������� _Podmena1

$Hwnd=WinWaitActive("�������� ������ �����������")
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Hwnd = ' & $Hwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
_CreateButton($hWnd)
;~ _BlockInputEx(3, $Hwnd, "{TAB}|{ENTER}")
;~ $controlID='[CLASS:TBitBtn; INSTANCE:2]'
;~ ControlDisable ( $Hwnd, "", $controlID )

;��� ������ ��� �������, �� ������ ���� ��� �� ���������, ������ �������� ���� ������ ����� 10 ������.
;~ AdlibRegister("_Quit", 10000)

While 1
    Sleep(100)
WEnd

Func _Quit()
    Exit
EndFunc

Func _CreateButton($hWnd)

	$hForm = GUICreate('', 100, 30, -1, -1, $WS_POPUP, -1, $hWnd)
	$Button = GUICtrlCreateButton('OK', 0, 0, 100, 30)
	GUISetState(@SW_SHOWNOACTIVATE)

	While 1
		$Pos = WinGetPos($hWnd)
		If @error Then
			Exit
		EndIf
		If ($X <> $Pos[0]) Or ($Y <> $Pos[1]) Then
			$X = $Pos[0]
			$Y = $Pos[1]
			WinMove($hForm, '', $X + 105, $Y + 227)
		EndIf
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $Button
				MsgBox(0, '', 'OK')
		EndSwitch
	WEnd

EndFunc
;~ Opt('MustDeclareVars', 1)

;~ $Debug_TB = False ; ��������� ClassName ������������ � �������. ���������� True � ����������� ���������� �� ������� ��������, ����� ������� ��� ��� ��������

;~ _Main()

;~ Func _Main()
;~     Local $hGUI, $hToolbar
;~     Local Enum $idNew = 1000, $idOpen, $idSave, $idHelp

;~     ; ������ GUI
;~     $hGUI = GUICreate("Toolbar", 400, 300)
;~     $hToolbar = _GUICtrlToolbar_Create ($hGUI)
;~     GUISetState()

;~     ; ��������� ����������� ��������� bitmaps
;~     _GUICtrlToolbar_AddBitmap ($hToolbar, 1, -1, $IDB_STD_LARGE_COLOR)

;~     ; ��������� ������
;~     _GUICtrlToolbar_AddButton ($hToolbar, $idNew, $STD_FILENEW)
;~     _GUICtrlToolbar_AddButton ($hToolbar, $idOpen, $STD_FILEOPEN)
;~     _GUICtrlToolbar_AddButton ($hToolbar, $idSave, $STD_FILESAVE)
;~     _GUICtrlToolbar_AddButtonSep ($hToolbar)
;~     _GUICtrlToolbar_AddButton ($hToolbar, $idHelp, $STD_HELP)
;~ 	ConsoleWrite($hToolbar&' '&$idHelp&' '&@CRLF)
;~     ; Disable Help button

;~ 	$hToolbar=0x00250364
;~ 	local $idHelp2=2425700
;~     _GUICtrlToolbar_EnableButton ($hToolbar, $idHelp2, False)

;~     ; ���� �����������, ���� ���� �� ����� �������
;~     Do
;~     Until GUIGetMsg() = $GUI_EVENT_CLOSE

;~ EndFunc   ;==>_Main