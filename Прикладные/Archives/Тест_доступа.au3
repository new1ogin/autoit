#include <File.au3>
#include <array.au3>
#include <WinAPIProc.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

If @ComputerName<>"ServerAD" Then
	MsgBox(0,"��� ������ ����������: "&@ComputerName,'���������� ��������� ��������� �� �������, �������� ����� "ServerAD.rdp". ����� ������� � �������� ��������� ��� ���.')
	Exit
EndIf


if $cmdline[0]>0 and $cmdline[1]='runas' Then
	$user = _WinAPI_GetProcessUser (@AutoItPID)
	TrayTip('���������',' �������� �������� �� ����� ������������: '&$user[0] & @CRLF & '���������� ��������� ��������� ������ � ��������� ���� �����������',5000)
Else
	Local $sUserName = "Username"
	Local $sPassword = "Password"

	#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate("Form1", 242, 215, 190, 125)
	$Label1 = GUICtrlCreateLabel("����� ������ ������������� ��� ��������:", 8, 8, 231, 17)
	$Radio1 = GUICtrlCreateRadio("���������", 8, 32, 113, 17)
	$Radio2 = GUICtrlCreateRadio("����������-��������", 8, 56, 161, 17)
	$Radio3 = GUICtrlCreateRadio("�����������", 8, 80, 113, 17)
	$Radio4 = GUICtrlCreateRadio("���������� �� ���", 8, 104, 129, 17)
	$Radio5 = GUICtrlCreateRadio("���������", 8, 128, 113, 17)
	$Button1 = GUICtrlCreateButton("������", 80, 176, 83, 25)
	$Radio6 = GUICtrlCreateRadio("��������(��� ���� �� ������)", 8, 152, 177, 17)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

			Case $Form1
			Case $Form1
				Case $Form1
			Case $Form1
			Case $Label1
			Case $Radio1
				$sUserName = "Mitkins"
				$sPassword = "Mit301199"
			Case $Radio2
				$sUserName = "Konstruktor2"
				$sPassword = "Kon687476"
			Case $Radio3
				$sUserName = "NikiforovA"
				$sPassword = "Nik618317"
			Case $Radio4
				$sUserName = "Murtazinr"
				$sPassword = "Mur196812"
			Case $Radio5
				$sUserName = "Chernoguzovs"
				$sPassword = "Che317859"
			Case $Radio6
				$sUserName = "��������"
				$sPassword = "Proff123"
			Case $Button1
				ExitLoop
		EndSwitch
	WEnd

;~ 	MsgBox(0,'',$sUserName&' '& @ComputerName&' '& $sPassword&' '& 0&' '& @AutoItExe&' runas'&' '&@ScriptDir)
	; Run a command prompt as the other user.
	RunAs($sUserName, "MAF", $sPassword, 0, @AutoItExe&' runas',@ScriptDir)
	if @error Then MsgBox(0,'������','��������� ��������� �� ��� ������������ '&$sUserName&' �� �������.',10)
;~ 	sleep(2000)
	exit
EndIf

;~ 182048940


$path = 'D:\Public'
;~ $input = InputBox('��������� ����',""
global $_patch = FileSelectFolder('�������� ����� ��� �������� ������� � ���',$path,4,$path)
if $_patch = '' then exit
;~ TrayTip('���������',' �������� �������� �� ����� ������������: '&$user[0] & @CRLF & '���������� ��������� ��������� ������ � ��������� ���� �����������',5000)
ToolTip($user[0]&' - ���������� ��������� ��������� ������ � ��������� ���� �����������')

$aDirs = _FileListToArrayRec($path, "", $FLTAR_FILESFOLDERS, $FLTAR_RECUR, $FLTAR_SORT)

local $aDirsAcc[$aDirs[0]+1][2]
$name = '�������� ���� ��� ��������.txt'

For $i = 1 to $aDirs[0]

	$f = 0
	$aDirsAcc[$i][0] = $aDirs[$i]
		;���� ����� �� ������
	$ff = FileFindFirstFile ($aDirs[$i] & '\*.*')
	if @error <> 1 and $ff = -1 Then
		$f-=100
	Else
		;���� ����� �� ������
		$h = FileOpen($aDirs[$i]&'\'&$name, 1)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $h = ' & $h &  @CRLF) ;### Debug Console
		$f += $h
		FileClose($h)
		if FileExists($aDirs[$i]&'\'&$name) Then
			$d = FileDelete($aDirs[$i]&'\'&$name)
			if $f=-1 then $f&=' ERROR'
			if $d=0 then
				FileRecycle ($aDirs[$i]&'\'&$name)
				DirRemove($aDirs[$i]&'\'&$name,1)
				$f&=' DELETE ERROR'
			EndIf
		Else
			$f-=0.5
		EndIf
	EndIf




	$aDirsAcc[$i][1] = $f
Next
ToolTip('')
_ArrayDisplay($aDirsAcc)