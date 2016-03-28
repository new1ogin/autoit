#RequireAdmin
#include <BlockInputEx.au3>
;~ #include <SendMessage.au3>
#include <Misc.au3>
#include <UserInput.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPIEx.au3>
#include <GuiButton.au3>
#include <GuiImageList.au3>

Opt('MustDeclareVars', 1)
Opt('GUICloseOnESC', 0)

Global Const $lciWM_SYSCommand = 274
Global Const $lciSC_MonitorPower = 61808
Global Const $lciPower_Off = 2
Global Const $lciPower_On = -1

Global $MonitorIsOff = False

Global $hForm, $tRECT, $X, $Y, $Width, $Height, $time = True, _
        $hImage, $nButton, $nMsg, $nPic


;~ HotKeySet("{F11}", "_Monitor_OFF")
;~ HotKeySet("{F10}", "_Monitor_ON")
HotKeySet("{Esc}", "_Quit")

_MyGUI()
While $time
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $nButton
            If MsgBox(262180, 'Test', '�������?') = 6 Then
                _Quit()
            EndIf
    EndSwitch
WEnd

;~ 	$timer = TimerInit()
;~ 	While TimerDiff($timer) < 20000
;~ 		$aRead = _UserInput_Read('[:ALLKEYS:]|[:ALLMOUSE:]') ;Read All inputs

;~ 		If $aRead[0] Then
;~ 			_Output_Result($aRead[1])
;~ 		EndIf

;~ 		Sleep(10)
;~ 	WEnd
;~ Exit

Func _MyGUI()
	$hForm = GUICreate("��� ����� ������.", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_TOPMOST)
;~ $nPic = GUICtrlCreatePic('C:\Users\Public\Pictures\Sample Pictures\Jellyfish.jpg', 0, 0, $Width, $Height) ;�������� ��������
;~ $nPic = GUICtrlCreatePic('C:\Users\Public\Pictures\Sample Pictures\Jellyfish.jpg', 0, 0, $Width, $Height) ;�������� ��������
	GUICtrlSetState(-1, $GUI_DISABLE)
	;GUISetBkColor(0x87CEFA, $hForm)
	$nButton = GUICtrlCreateButton('Click', @DesktopWidth / 2 - 40, @DesktopHeight / 2 - 16, 80, 32) ; �������
	GUICtrlSetFont(-1, 12, 600)
	_GUICtrlButton_SetImageList(-1, $hImage)
	WinSetTrans($hForm, '', 220)
	GUISetState()

;~ 	_WinAPI_EmptyWorkingSet()
EndFunc

Func _Quit()
	Exit
EndFunc


; ������������� ������������� (�����������)
; ������� ������� �������� ��������
; ����������� � �������� ��������
; ��������������� ������� �������� ���������
; ��������� ��������� ������ ��� ������ �������� �������� (�������� ������ ��� ���. ���������)
; �������������� ����� ������� ��� ������ ������������ �������� (�� ���������� ������������)
; ���� ���������� ������������ (x2, x3 �� ������� ��������) ��� �������� �� �� ������� � ������� ������� �� ��������� ����� ������������
; ���������� ������ � ��� ������ ���� ������ ������� ��������� ��������� �������������� ����������� ������������ (������ ����������)
; ���������� ������ ��� ���������� �������