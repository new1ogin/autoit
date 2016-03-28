#RequireAdmin
#include <Process.au3>
#include <array.au3>
#include <Encoding.au3>

;���������� ������� ���� ������� ����
;~ $scetchik=0
;~ for $i=1 to 3
;~ 	$Localip = Execute('@IPAddress'&$i)
;~ 	if $Localip = '0.0.0.0' then $scetchik+=1
;~ Next
;~ if $scetchik<>2 then


$iTempFile = @TempDir & '\NetInfo.txt'
RunWait(@ComSpec & ' /C netsh interface ip show config >> ' & $iTempFile, '', @SW_HIDE)
$NetInfoContents = FileRead($iTempFile)
if StringInStr($NetInfoContents,'����������� �� ��������� ����')=0 then $NetInfoContents =_Encoding_866To1251($NetInfoContents)
$CountInt = StringSplit ( $NetInfoContents, "����������� �� ��������� ����",1)
if $CountInt[0]-1=0 then
	MsgBox(0,"���������",'����������� �� ��������� ���� �� ��������!')
	Exit
EndIf
$iReg = StringRegExp($NetInfoContents, '(?s)"����������� �� ��������� ����.*?(\d{2,3}\.\d{2,3}\.\d{1,3}\.\d{1,3}).*?"', 3)
;~ _ArrayDisplay($iReg)

; ��� ������� ����������, �������������� ��������
if stringinstr($iReg[0],'192.168.1.')<>0 and $iReg[0]<>'127.0.0.1' Then
	;��������� ������ ��������� � ����
	$sNameSet = "1.config" ; ���� �������� ��������
	$sSaveSet = "netsh dump>"&$sNameSet
	$sLoadSet = "netsh exec "&$sNameSet
	_RunDOS($sSaveSet) ; ��������� ���������
		;_RunDOS($sLoadSet) ; ��������� ���������

	; ���������� ��������� �� ����� � ��������� ����
	for $FreeIP=250 to 2 step -1
		if ping('192.168.1.'&$FreeIP,500) = 0 Then ExitLoop
	Next
	;�������� ������ ���������
	$ipaddres = '192.168.1.'&$FreeIP
	$subnetmask = '255.255.255.0'
	$gateway = '192.168.1.1'
	$dns = '78.140.0.254'
	$nameInterface = '"����������� �� ��������� ����"'
	$t = Run(@ComSpec & ' /c ' & 'netsh interface ip set address '&$nameInterface&' static '&$ipaddres&' '&$subnetmask&' '&$gateway&' 1', '', @SW_HIDE)
	$t = Run(@ComSpec & ' /c ' & 'netsh interface ip set dns '&$nameInterface&' static '&$dns, '', @SW_HIDE)
	MsgBox(0,"���������",'�������� ����������� ��������!',5)
else if $iReg[0]<>'127.0.0.1' and FileExists(@ScriptDir&"\1.config")
	$sNameSet = "1.config" ; ���� �������� ��������
	$sSaveSet = "netsh dump>"&$sNameSet
	$sLoadSet = "netsh exec "&$sNameSet
	;_RunDOS($sSaveSet) ; ��������� ���������
	_RunDOS($sLoadSet) ; ��������� ���������
	MsgBox(0,"���������",'�������� ����������� ��������������!',5)
Else
	MsgBox(0,"������",'������. �������� ����������� ������������!')
EndIf


