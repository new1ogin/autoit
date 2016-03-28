#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Compression=4
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <Security.au3>

$Username = @UserName
$test = 0

; ��������� ������ �� ��������� ������
$help = stringLeft($CmdLine[1],2)
if $help = '/h' or $help = '/?' or $help = '-h' or $help = '-?' Then
	$helptext = "������� ������� �����, ���� �������� ������� �� ���������� ��� ������ �������������" & @CRLF & _
	'�������������: Start_if_not_exist.exe "����_�_�����_�_�����������" ���_��������_���_������ [���_������������]' & @CRLF & _
	'������: Start_if_not_exist.exe " ""C:\windows\system32\cmd.exe"" /k ping ""ya.ru""" notepad.exe �������������' & @CRLF
	Msgbox(0, '���������', $helptext)
;~ 	ConsoleWrite(_Encoding_ANSIToOEM($helptext))
	exit
Else
	if $CmdLine[0] < 2 Then
		_Quit('������������ ���������� ��� ������� �����, ������ ������� -h')
		exit
	EndIf
	$patch = $CmdLine[1]
	$process = $CmdLine[2]
	if $CmdLine[0] > 2 Then $Username = $CmdLine[3]
	if $CmdLine[0] > 3 Then $test = $CmdLine[4]
EndIf


; ����� �������� ��� ���������� ������������
$ta = ProcessList($process)
$findproc = 0
For $i=1 to $ta[0][0]
	If _EquallyString(_GetProcessUser($ta[$i][1])) = _EquallyString($Username) Then
		if $test = 1 Then Msgbox(0,'���������','������� ���������� ���� ' & _GetProcessUser($ta[$i][1]) & ' � ' & $Username)
		$findproc = 1
	EndIf
Next

; ������ ��������
if $findproc = 0 Then
	if $test = 1 Then Msgbox(0,'���������','������ ���������: ' & _EquallyString($patch))
	Run(_EquallyString($patch))
EndIf

if $test = 1 Then
	$c = InputBox("","")
	$p = InputBox("","")

	Call($c,$p)
EndIf



Exit

Func _Run($patch)
	Run($patch)
EndFunc

Func _ShellExecute($patch)
	ShellExecute($patch)
EndFunc


Func _EquallyString($String)
	$String = StringStripWS(StringLower($String), 3)
	return $String
EndFunc

Func _GetProcessUser($PID)
	$WTS_PROCESS_INFO= "DWORD SessionId; DWORD ProcessId; PTR pProcessName; PTR pUserSid"
	$aDllRet=DllCall("WTSApi32.dll", "bool", "WTSEnumerateProcesses", "Dword", 0, "Dword", 0, _
							"Dword", 1, "ptr*", DllStructGetPtr($WTS_PROCESS_INFO), "Dword*", 0)
	Local $mem, $aProc[$aDllRet[5]][4]
	For $i=0 To $aDllRet[5]-1
		 $mem=DllStructCreate($WTS_PROCESS_INFO, $aDllRet[4]+($i*DllStructGetSize($mem)))
		 $aProc[$i][1]=DllStructGetData($mem, "ProcessId")
		 $aSid = _Security__LookupAccountSid(DllStructGetData($mem, "pUserSid"))
		 If IsArray($aSid) Then $aProc[$i][3] = $aSid[0]
	Next
	For $i=0 to UBound($aProc) - 1
		 if $aProc[$i][1] = $PID Then
		   Return $aProc[$i][3]
		 EndIf
	Next
	DllCall("WTSApi32.dll", "int", "WTSFreeMemory", "int", $aDllRet[4])
EndFunc

; ����� � ����������� ������
Func _Quit($text)
;~ 	_Log_Report($hLog, "����� �� ������: " & $text & @CRLF)
;~ 	ConsoleWrite(_Encoding_ANSIToOEM($text))
	Msgbox(0, '������', $text)
	Exit
EndFunc