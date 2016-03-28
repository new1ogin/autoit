#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=����������Mail.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <File.au3>
#include <INet.au3>
#include <WinAPIEx.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
Opt("GUIOnEventMode", 1)

HotKeySet("+{ESC}", "_quite")
HotKeySet("+{F2}", "_Go")
HotKeySet("+{F2}", "_Proc")
HotKeySet("+{F2}", "_Pause")
Global $NumberSplits = 1001, $aMemoryImage, $Struct
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Dim $aMemoryImage[$NumberSplits + 1][10] ; ������ ��� �������� ���������� ��� ���������
Global $hwnd, $posWin, $title = '', $emailUser, $URL_smsruUser, $sleepForCheckImage, $func = 0, $IndexCompare, $MaxIndexCompare = 1
Global $Form1 = 0, $paus = 0
Global $PID = 0, $Prev1 = 0, $Prev2 = 0
$UrlSendSMS = "http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text="
;~ $UrlSendSMS = "http://sms.ru/sms/send?api_id=124104f6-e803-4934-ad08-066e8b9493ea&to=79131042000&text="
Global $textMSG = '��������, ��������� �������! '
$sleepTrack = 1000
Opt("TrayMenuMode", 1 + 2)
Opt("TrayOnEventMode", 1)
TrayCreateItem("�����")
TrayItemSetOnEvent(-1, "_quite")
TrayCreateItem("����")
TrayItemSetOnEvent(-1, "_GuiCreae")
;~ 	TraySetOnEvent($TRAY_EVENT_PRIMARYDOUBLE, "_GuiCreae")
;~ 	TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "clr")
;~ 	TraySetOnEvent($TRAY_EVENT_PRIMARYUP, "clr")
_GuiCreae()
_pause()

Func clr()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : clr() = ' & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
EndFunc   ;==>clr


Func _pause()
	TrayTip('���������', '�� ����� ������ ������ �������� ����������� ������, ��� ������� ���� �� ������ � ����', 5000)
	;��������
	While 1
		Sleep(100)
	WEnd
EndFunc   ;==>_pause

_GuiCreae()

Func _GuiCreae()
	If Not $Form1 = 0 Then
		GUISetState(@SW_SHOW, $Form1)
		Return 2
	EndIf
	If $paus = 0 Then
#Region ### START Koda GUI section ### Form=d:\autoitv3.3.8.1\����������\backup\form2.kxf
$Form1 = GUICreate("����������", 316, 401, 192, 114)
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
GUICtrlSetTip($ButtonQuestion, "������ �� ��������� api_id ��� �������� ���")
GUICtrlSetOnEvent($ButtonQuestion, "ButtonQuestionClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$OK = GUICtrlCreateButton("������ ����������", 160, 360, 139, 25)
GUICtrlSetFont($OK, 8, 800, 0, "MS Sans Serif")
GUICtrlSetTip($OK, "��� ���� �������� � ���� � ��������� ����������� ��������� �������� ���������� �������")
GUICtrlSetOnEvent($OK, "OKClick")
$ButtonDot = GUICtrlCreateButton("������� �� ������", 160, 328, 139, 25)
GUICtrlSetTip($ButtonDot, "�������� �� ���������� ����� ������� �� ������� ��������� ������")
GUICtrlSetOnEvent($ButtonDot, "ButtonDotClick")
$ButtonWindowDrag = GUICtrlCreateButton("�������. ����", 16, 328, 139, 25)
GUICtrlSetTip($ButtonWindowDrag, "���������� ���� �� ������� ������ ��������, ��� ������ �������� �� ���� �����"&@CRLF&"���� ������������ �� ������� ������ �� ���� ��� �������� �� ����� ���������.")
GUICtrlSetOnEvent($ButtonWindowDrag, "ButtonWindowDragClick")
$ButtonArea = GUICtrlCreateButton("������� �� ��������", 16, 296, 139, 25)
GUICtrlSetTip($ButtonArea, "�������� �� ������������� �������� � ������������ ����")
GUICtrlSetOnEvent($ButtonArea, "ButtonAreaClick")
$ButtonProc = GUICtrlCreateButton("������� �� ���������", 160, 296, 139, 25)
GUICtrlSetTip($ButtonProc, "�������� �� ������������� ���������� ����������� ���������")
GUICtrlSetOnEvent($ButtonProc, "ButtonProcClick")
$Group2 = GUICtrlCreateGroup("������ ��� ������� ����������", 16, 136, 281, 153)
$Label8 = GUICtrlCreateLabel("Shift+F2 - ������� �� ������", 24, 160, 146, 17)
GUICtrlSetTip($Label8, "�������� �� ���������� ����� ������� �� ������� ��������� ������")
GUICtrlSetOnEvent($Label8, "Label8Click")
$Label9 = GUICtrlCreateLabel("Shift+F3 - ������� �� �������� � ����*", 24, 176, 201, 17)
GUICtrlSetTip($Label9, "�������� �� ������������� �������� � ������������ ����")
GUICtrlSetOnEvent($Label9, "Label9Click")
$Label10 = GUICtrlCreateLabel("Shift+F4 - ������� �� ��������� ��������", 24, 192, 215, 17)
GUICtrlSetTip($Label10, "�������� �� ������������� ���������� ����������� ���������")
GUICtrlSetOnEvent($Label10, "Label10Click")
$Label11 = GUICtrlCreateLabel("Shift+F5 - ���������� ����*", 24, 208, 142, 17)
GUICtrlSetTip($Label11, "���������� ���� �� ������� ������ ��������, ��� ������ �������� �� ���� �����"&@CRLF&"���� ������������ �� ������� ������ �� ���� ��� �������� �� ����� ���������.")
GUICtrlSetOnEvent($Label11, "Label11Click")
$Label12 = GUICtrlCreateLabel("Shift+F6 - ������� �� ������", 24, 224, 148, 17)
GUICtrlSetTip($Label12, "�������� �� ������ �� ������� ������ ��� ������ ��������� � �����, "&@CRLF&"���������/������������ �����(��), ��������� ���� ����������� �����(��)")
GUICtrlSetOnEvent($Label12, "Label12Click")
$Label2 = GUICtrlCreateLabel("Shift+Esc - �����", 24, 240, 90, 17)
GUICtrlSetTip($Label2, "����������� ������ � �����������, ����� ��� ����� �� ������ ������������ ������ ���� �� ������ � ����")
GUICtrlSetOnEvent($Label2, "Label2Click")
$Label1 = GUICtrlCreateLabel("* ������� ��� �� �����������", 24, 264, 167, 17)
GUICtrlSetTip($Label1, "����������� ������ � �����������, ����� ��� ����� �� ������ ������������ ������ ���� �� ������ � ����")
GUICtrlSetOnEvent($Label1, "Label1Click")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$ButtonFolder = GUICtrlCreateButton("������� �� ������", 16, 359, 139, 25)
GUICtrlSetTip($ButtonFolder, "�������� �� ������ �� ������� ������ ��� ������ ��������� � �����, "&@CRLF&"���������/������������ �����(��), ��������� ���� ����������� �����(��)")
GUICtrlSetOnEvent($ButtonFolder, "ButtonFolderClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
	EndIf

	While 1
		Sleep(100)

		If $paus = 1 Then
			TrayTip('���������', '�� ����� ������ ������ �������� ����������� ������, ��� ������� ���� �� ������ � ����', 5000)
			$paus = 0
		EndIf

	WEnd
EndFunc   ;==>_GuiCreae

Func ButtonAreaClick()
	$i=0
	While 1
		sleep(100)
		$i+=1
		if Mod($i,10)=0 then ConsoleWrite($i/10 & @CRLF)
	WEnd

EndFunc   ;==>ButtonAreaClick
Func ButtonDotClick()

EndFunc   ;==>ButtonDotClick
Func ButtonProcClick()

EndFunc   ;==>ButtonProcClick
Func ButtonWindowDragClick()

EndFunc   ;==>ButtonWindowDragClick
Func OKClick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : OKClick() = ' & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	GUISetState(@SW_HIDE, $Form1)
	$paus = 1
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
Func Label8Click()

EndFunc   ;==>Label8Click
Func Label9Click()

EndFunc   ;==>Label9Click
Func Label10Click()

EndFunc   ;==>Label10Click
Func Label11Click()

EndFunc   ;==>Label11Click
Func Label12Click()

EndFunc   ;==>Label12Click
Func ButtonFolderClick()

EndFunc   ;==>ButtonFolderClick





While 1
	Sleep(100)
WEnd


Func _go()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_���������", Default, Default, "_go", 0, 0)
EndFunc   ;==>_go


Func _Proc()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_���������", Default, Default, "_Proc", 0, 0)
EndFunc   ;==>_Proc

Func _quite()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_���������", Default, Default, "_quite", 0, 0)
	Exit
EndFunc   ;==>_quite
