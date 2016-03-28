#include <Constants.au3>

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$Form1 = GUICreate("�������� �� �����������", 434, 224, 192, 124)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
$Edit1 = GUICtrlCreateEdit("", 8, 8, 417, 177, BitOR($GUI_SS_DEFAULT_EDIT,$ES_READONLY))
GUICtrlSendMsg(-1, $EM_LIMITTEXT, -1, 0) ; ������� ����������� �� ���������� �������� 30 000
GUICtrlSetData(-1, StringFormat("��������� ��������\r\n"))
GUICtrlSetOnEvent(-1, "Edit1Change")
$Button1 = GUICtrlCreateButton("������� ���", 288, 192, 137, 25)
GUICtrlSetOnEvent(-1, "Button1Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###
global $iPIDOrientir = Run('Orientir.exe', @SystemDir)
global $iPID = Run("StartOrientirFastFTP-2.exe", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
Local $sOutput
While 1
    $sOutput = StdoutRead($iPID)
    If @error Then ; ����� �� �����, ���� ������� �������� ��� StdoutRead ���������� ������.
        ExitLoop
    EndIf
	if $sOutput<>'' then  GUICtrlSetData($Edit1, $sOutput&@CRLF, 1)
	Sleep(100)
WEnd
GUICtrlSetData($Edit1, ' ��������� ��������� '&@CRLF, 1)
While 1
	Sleep(100)
WEnd

Func Button1Click()
	ProcessClose ( $iPID )
	ProcessClose ($iPIDOrientir)
 exit
EndFunc
Func Edit1Change()

EndFunc
Func Form1Close()
Button1Click()
EndFunc
Func Form1Maximize()

EndFunc
Func Form1Minimize()

EndFunc
Func Form1Restore()

EndFunc




Local $iPID = Run("StartOrientirFastFTP-2.exe", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
Local $sOutput
While 1
    $sOutput = StdoutRead($iPID)
    If @error Then ; ����� �� �����, ���� ������� �������� ��� StdoutRead ���������� ������.
        ExitLoop
    EndIf
    MsgBox(4096, "Stdout ���������:", $sOutput)
WEnd

While 1
    $sOutput = StderrRead($iPID)
    If @error Then ; ����� �� �����, ���� ������� �������� ��� StdoutRead ���������� ������.
        ExitLoop
    EndIf
    MsgBox(4096, "Stderr ���������:", $sOutput)
WEnd


