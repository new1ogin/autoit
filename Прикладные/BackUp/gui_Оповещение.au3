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
;~ Opt("GUIOnEventMode", 1)

HotKeySet("+{ESC}", "_quite")
HotKeySet("+{F2}", "_Go")
HotKeySet("+{F2}", "_Proc")
HotKeySet("+{F2}", "_Pause")
Global $NumberSplits = 1001, $aMemoryImage, $Struct
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Dim $aMemoryImage[$NumberSplits + 1][10] ; ������ ��� �������� ���������� ��� ���������
Global $hwnd, $posWin, $title = '', $emailUser, $URL_smsruUser, $sleepForCheckImage, $func = 0, $IndexCompare, $MaxIndexCompare = 1
Global $Form1 = 0, $paus = 0, $exitFunc = 0, $startFunc = '', $workFunc = ''
Global $PID = 0, $Prev1 = 0, $Prev2 = 0
;~ $UrlSendSMS = "http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text="
;~ $UrlSendSMS = "http://sms.ru/sms/send?api_id=124104f6-e803-4934-ad08-066e8b9493ea&to=79131042000&text="
Global $textMSG = '��������, ��������� �������! '
$sleepTrack = 1000
Opt("TrayMenuMode", 1 + 2)
Opt("TrayOnEventMode", 1)
$iExit = TrayCreateItem("�����")
TrayItemSetOnEvent(-1, "_quite")
$iMenu = TrayCreateItem("����")
TrayItemSetOnEvent(-1, "_GuiCreate")

_GuiCreate()
ConsoleWrite('�������� ������� '&$startFunc & @CRLF)
If $startFunc <> '' Then ConsoleWrite('�������� ������� '&$startFunc & @CRLF)
While 1
	Sleep(100)
	If $startFunc <> '' Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $startFunc = ' & $startFunc & @CRLF ) ;### Debug Console
		$workFunc = _getFuncDiscription($startFunc)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $workFunc = ' & $workFunc & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$nowFunc = $startFunc
		$startFunc = 0
		Execute($nowFunc)

	EndIf
WEnd



Func _Area()
	$i = 0
	While 1
		Sleep(100)
		$i += 1
		If Mod($i, 10) = 0 Then ConsoleWrite($i / 10 & @CRLF)
		if $exitFunc=1 then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $exitFunc = ' & $exitFunc & @CRLF ) ;### Debug Console
			$exitFunc=0
			return
		EndIf
	WEnd

EndFunc   ;==>_Area

Func _Dot()

	$i = 0
	While 1
		Sleep(100)
		$i += 1
		If Mod($i, 10) = 0 Then ConsoleWrite('DotClick' & $i / 10 & @CRLF)
		if $exitFunc=1 then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $exitFunc = ' & $exitFunc & @CRLF ) ;### Debug Console
			$exitFunc=0
			return
		EndIf
	WEnd
EndFunc   ;==>_Dot


Func _quite()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _quite() = ' & @CRLF) ;### Debug Console
	GUIDelete($Form1)
	Exit
EndFunc   ;==>_quite

Func _getFuncDiscription($func)
	Switch $func
		Case '_AreaClick()'
			Return '"������� �� ��������"'
		Case '_Dot()'
			Return '"������� �� ������"'
		Case '_WindowDrag()'
			Return '"���������� ����"'
		Case '_Area()'
			Return '"������� �� ��������"'
		Case '_Proc()'
			Return '"������� �� ��������� ��������"'
		Case '_Folder()'
			Return '"������� �� ������"'
	EndSwitch
	if $func=0 then $func=''
	return $func
EndFunc   ;==>_getFuncDiscription

;~ Func _GuiShow()
;~ 	$exitFunc=1
;~ 	_GuiCreate()
;~ EndFunc

Func _GuiCreate()

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GuiCreate() = ' & @CRLF) ;### Debug Console
	If $Form1 == 0 Then
		#Region ### START Koda GUI section ### Form=D:\autoitv3.3.8.1\����������\BackUp\form3.kxf
		$Form1 = GUICreate("����������", 316, 401, 192, 114)
		Global $Group1 = GUICtrlCreateGroup("����� �������� ����������", 16, 8, 281, 121)
		Global $InputEmail = GUICtrlCreateInput("������� ��� Email", 23, 48, 265, 21)
		Global $InputSMSapi_id = GUICtrlCreateInput("��� api_id � ����� sms.ru", 23, 96, 241, 21)
		Global $CheckboxEmail = GUICtrlCreateCheckbox("���������� Email", 24, 32, 241, 17)
		GUICtrlSetState($CheckboxEmail, $GUI_CHECKED)
		Global $CheckboxSMSapi_id = GUICtrlCreateCheckbox("��������� ���", 24, 80, 241, 17)
		Global $ButtonQuestion = GUICtrlCreateButton("?", 272, 94, 17, 25)
		GUICtrlSetTip($ButtonQuestion, "������ �� ��������� api_id ��� �������� ���")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		Global $OK = GUICtrlCreateButton("������ ����������", 160, 360, 139, 25)
		GUICtrlSetFont($OK, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetTip($OK, "��� ���� �������� � ���� � ��������� ����������� ��������� �������� ���������� �������")
		Global $ButtonDot = GUICtrlCreateButton("������� �� ������", 160, 328, 139, 25)
		GUICtrlSetTip($ButtonDot, "�������� �� ���������� ����� ������� �� ������� ��������� ������")
		Global $ButtonWindowDrag = GUICtrlCreateButton("�������. ����", 16, 328, 139, 25)
		GUICtrlSetTip($ButtonWindowDrag, "���������� ���� �� ������� ������ ��������, ��� ������ �������� �� ���� �����" & @CRLF & "���� ������������ �� ������� ������ �� ���� ��� �������� �� ����� ���������.")
		Global $ButtonArea = GUICtrlCreateButton("������� �� ��������", 16, 296, 139, 25)
		GUICtrlSetTip($ButtonArea, "�������� �� ������������� �������� � ������������ ����")
		Global $ButtonProc = GUICtrlCreateButton("������� �� ���������", 160, 296, 139, 25)
		GUICtrlSetTip($ButtonProc, "�������� �� ������������� ���������� ����������� ���������")
		Global $Group2 = GUICtrlCreateGroup("������ ��� ������� ����������", 16, 136, 281, 153)
		Global $Label8 = GUICtrlCreateLabel("Shift+F2 - ������� �� ������", 24, 160, 146, 17)
		GUICtrlSetTip($Label8, "�������� �� ���������� ����� ������� �� ������� ��������� ������")
		Global $Label9 = GUICtrlCreateLabel("Shift+F3 - ������� �� �������� � ����*", 24, 176, 201, 17)
		GUICtrlSetTip($Label9, "�������� �� ������������� �������� � ������������ ����")
		Global $Label10 = GUICtrlCreateLabel("Shift+F4 - ������� �� ��������� ��������", 24, 192, 215, 17)
		GUICtrlSetTip($Label10, "�������� �� ������������� ���������� ����������� ���������")
		Global $Label11 = GUICtrlCreateLabel("Shift+F5 - ���������� ����*", 24, 208, 142, 17)
		GUICtrlSetTip($Label11, "���������� ���� �� ������� ������ ��������, ��� ������ �������� �� ���� �����" & @CRLF & "���� ������������ �� ������� ������ �� ���� ��� �������� �� ����� ���������.")
		Global $Label12 = GUICtrlCreateLabel("Shift+F6 - ������� �� ������", 24, 224, 148, 17)
		GUICtrlSetTip($Label12, "�������� �� ������ �� ������� ������ ��� ������ ��������� � �����, " & @CRLF & "���������/������������ �����(��), ��������� ���� ����������� �����(��)")
		Global $Label2 = GUICtrlCreateLabel("Shift+Esc - �����", 24, 240, 90, 17)
		GUICtrlSetTip($Label2, "����������� ������ � �����������, ����� ��� ����� �� ������ ������������ ������ ���� �� ������ � ����")
		Global $Label1 = GUICtrlCreateLabel("* ������� ��� �� �����������", 24, 264, 167, 17)
		GUICtrlSetTip($Label1, "����������� ������ � �����������, ����� ��� ����� �� ������ ������������ ������ ���� �� ������ � ����")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		Global $ButtonFolder = GUICtrlCreateButton("������� �� ������", 16, 359, 139, 25)
		GUICtrlSetTip($ButtonFolder, "�������� �� ������ �� ������� ������ ��� ������ ��������� � �����, " & @CRLF & "���������/������������ �����(��), ��������� ���� ����������� �����(��)")
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
	Else
		GUISetState(@SW_SHOW, $Form1)

	EndIf

	if $workFunc<>'' then GUICtrlSetData($OK, '���������� ����������')

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

			Case $Form1
			Case $InputEmail
			Case $InputSMSapi_id
			Case $CheckboxEmail
			Case $CheckboxSMSapi_id
			Case $ButtonQuestion
			Case $OK
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : OKClick() = ' & @CRLF) ;### Debug Console
				GUISetState(@SW_HIDE, $Form1)
				ExitLoop
			Case $ButtonDot
				If _startFromGUI('_Dot()') = 1 Then return
			Case $ButtonWindowDrag
			Case $ButtonArea
				If _startFromGUI('_Area()') = 1 Then return
			Case $ButtonProc
			Case $Label8
			Case $Label9
			Case $Label10
			Case $Label11
			Case $Label12
			Case $Label2
			Case $Label1
			Case $ButtonFolder
		EndSwitch
		Sleep(100)
	WEnd
EndFunc   ;==>_GuiCreate

Func _startFromGUI($func)
	$t = 1
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $workFunc = ' & $workFunc & @CRLF ) ;### Debug Console
	If $workFunc <> '' Then
		$t = MsgBox(1, '��������������', '� ������ ������ ����������� ������� ' & $workFunc & @CRLF & '���� ���������� � ���������� ������������')
	EndIf
	If $t = 1 Then
		If $workFunc <> '' Then
			$exitFunc=1
		EndIf
		$startFunc = $func
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $startFunc = ' & $startFunc & @CRLF ) ;### Debug Console
		GUISetState(@SW_HIDE, $Form1)
		TrayTip('���������', '�������� ��������'&@CRLF&'�� ����� ������ ������������ ��������� ������, ��� ������� ���� �� ������ � ����', 5000)
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_startFromGUI


