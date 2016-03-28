#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)

_GuiCreae()

Func _GuiCreae()
	#Region ### START Koda GUI section ### Form=d:\autoitv3.3.8.1\����������\backup\form1.kxf
$Form1 = GUICreate("����������", 316, 334, 192, 114)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
$Group1 = GUICtrlCreateGroup("����� �������� ����������", 16, 8, 281, 121)
$InputEmail = GUICtrlCreateInput("������� ��� Email", 23, 48, 265, 21)
GUICtrlSetOnEvent($InputEmail, "InputEmailChange")
$InputSMSapi_id = GUICtrlCreateInput("��� api_id � ����� sms.ru", 23, 96, 241, 21)
GUICtrlSetOnEvent($InputSMSapi_id, "InputSMSapi_idChange")
$CheckboxEmail = GUICtrlCreateCheckbox("���������� Email", 24, 32, 241, 17)
GUICtrlSetState($CheckboxEmail, $GUI_CHECKED)
GUICtrlSetOnEvent($CheckboxEmail, "CheckboxEmailClick")
$CheckboxSMSapi_id = GUICtrlCreateCheckbox("��������� ���", 24, 80, 241, 17)
GUICtrlSetOnEvent($CheckboxSMSapi_id, "CheckboxSMSapi_idClick")
$ButtonQuestion = GUICtrlCreateButton("?", 272, 94, 17, 25)
GUICtrlSetOnEvent($ButtonQuestion, "ButtonQuestionClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label1 = GUICtrlCreateLabel("������ ����������", 16, 136, 101, 17)
GUICtrlSetOnEvent($Label1, "Label1Click")
$Label2 = GUICtrlCreateLabel("Shift+F2 - ������� �� ������", 16, 152, 146, 17)
GUICtrlSetTip($Label2, "�������� �� ���������� ����� ������� �� ������� ��������� ������")
GUICtrlSetOnEvent($Label2, "Label2Click")
$Label3 = GUICtrlCreateLabel("Shift+Esc - �����", 16, 216, 90, 17)
GUICtrlSetTip($Label3, "����������� ������ � �����������, ����� ��� ����� �� ������ ������������ ������ ���� �� ������ � ����")
GUICtrlSetOnEvent($Label3, "Label3Click")
$Label4 = GUICtrlCreateLabel("Shift+F5 - ���������� ����*", 16, 200, 142, 17)
GUICtrlSetTip($Label4, "���������� ���� �� ������� ������ ��������, ��� ������ �������� �� ���� �����"&@CRLF&"���� ������������ �� ������� ������ �� ���� ��� �������� �� ����� ���������.")
GUICtrlSetOnEvent($Label4, "Label4Click")
$Label5 = GUICtrlCreateLabel("Shift+F4 - ������� �� ��������� ��������", 16, 184, 215, 17)
GUICtrlSetTip($Label5, "�������� �� ������������� ���������� ����������� ���������")
GUICtrlSetOnEvent($Label5, "Label5Click")
$Label6 = GUICtrlCreateLabel("Shift+F3 - ������� �� �������� � ����*", 16, 168, 201, 17)
GUICtrlSetTip($Label6, "�������� �� ������������� �������� � ������������ ����")
GUICtrlSetOnEvent($Label6, "Label6Click")
$OK = GUICtrlCreateButton("������ ���", 224, 296, 75, 25)
GUICtrlSetFont($OK, 8, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent($OK, "OKClick")
$ButtonDot = GUICtrlCreateButton("������� �� ������", 112, 296, 107, 25)
GUICtrlSetOnEvent($ButtonDot, "ButtonDotClick")
$ButtonWindowDrag = GUICtrlCreateButton("�������. ����", 16, 296, 91, 25)
GUICtrlSetOnEvent($ButtonWindowDrag, "ButtonWindowDragClick")
$ButtonArea = GUICtrlCreateButton("������� �� ��������", 16, 264, 139, 25)
GUICtrlSetOnEvent($ButtonArea, "ButtonAreaClick")
$ButtonProc = GUICtrlCreateButton("������� �� ���������", 160, 264, 139, 25)
GUICtrlSetOnEvent($ButtonProc, "ButtonProcClick")
$Label7 = GUICtrlCreateLabel("* ������� ��� �� �����������", 14, 236, 167, 17)
GUICtrlSetOnEvent($Label7, "Label7Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

	While 1
		Sleep(100)
	WEnd
EndFunc   ;==>_GuiCreae

Func ButtonAreaClick()

EndFunc   ;==>ButtonAreaClick
Func ButtonDotClick()

EndFunc   ;==>ButtonDotClick
Func ButtonProcClick()

EndFunc   ;==>ButtonProcClick
Func ButtonWindowDragClick()

EndFunc   ;==>ButtonWindowDragClick
Func OKClick()
	Exit
EndFunc   ;==>OKClick
Func CheckboxEmailClick()

EndFunc   ;==>CheckboxEmailClick
Func CheckboxSMSapi_idClick()

EndFunc   ;==>CheckboxSMSapi_idClick
Func ButtonQuestionClick()

EndFunc   ;==>ButtonQuestionClick

Func Form1Close()
	Exit
EndFunc   ;==>Form1Close
Func Form1Maximize()

EndFunc   ;==>Form1Maximize
Func Form1Minimize()

EndFunc   ;==>Form1Minimize
Func Form1Restore()

EndFunc   ;==>Form1Restore
Func InputEmailChange()

EndFunc   ;==>InputEmailChange
Func InputSMSapi_idChange()

EndFunc   ;==>InputSMSapi_idChange
Func Label1Click()

EndFunc   ;==>Label1Click
Func Label2Click()

EndFunc   ;==>Label2Click
Func Label3Click()

EndFunc   ;==>Label3Click
Func Label4Click()

EndFunc   ;==>Label4Click
Func Label5Click()

EndFunc   ;==>Label5Click
Func Label6Click()

EndFunc   ;==>Label6Click
Func Label7Click()

EndFunc   ;==>Label7Click





HotKeySet("{ESC}", "_quite") ;Это вызов
HotKeySet("{ins}", "_Go") ;Это вызов
HotKeySet("{scrolllock}", "_Proc") ;Это вызов
HotKeySet("{Down}", "_Pause") ;Это вызов


While 1
	Sleep(100)
WEnd


Func _go()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_���������", Default, Default, "_go", 0, 0)
EndFunc   ;==>_go

Func _Pause()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_���������", Default, Default, "_Pause", 0, 0)
EndFunc   ;==>_Pause

Func _Proc()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_���������", Default, Default, "_Proc", 0, 0)
EndFunc   ;==>_Proc

Func _quite()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_���������", Default, Default, "_quite", 0, 0)
	Exit
EndFunc   ;==>_quite
