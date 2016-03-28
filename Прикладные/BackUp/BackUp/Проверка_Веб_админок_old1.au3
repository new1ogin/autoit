#include <array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <IE.au3>
HotKeySet("{F7}", "_Exit")
Global $Paused, $oIE

$sleep = 500 ;����������� ����� �������� ����� ����������
$sleepMin = 10 ; ����������� ����� �������� ����� ����������
$sleepLoad = 5000 ;�������� �������� ��������

$CountTestPass = 2
local $LoginPass[6][2]=[['admin1','admin'],['admin2',''],['admin3',''],['admin4','admin'],['admin5',''],['admin6','']]

; ��������� ���� windows c �������� ������
$titleWinPassword = '������������ Windows'
$controlWinLogin = '[CLASS:Edit; INSTANCE:1]'
$controlWinPass = '[CLASS:Edit; INSTANCE:2]'
$controlWinButtonOK = '[CLASS:Button; INSTANCE:2]'
$controlWinButtonCANCEL = '[CLASS:Button; INSTANCE:3]'


; ��������� ���������� �� ���������� ������
Dim $CmdLineN[2]
if $CmdLine[0] = 1 Then
	$CmdLineN = $CmdLine
Else
	$CmdLineN[0]=1
	$CmdLineN[1]=@scriptdir&'\VNC_bypauth.txt'
EndIf

$Content = FileRead($CmdLineN[1]) ;������ ������� ������ �� �����
$Content = StringReplace(StringReplace(StringReplace(StringReplace($Content,@CRLF,@CR),@LF,@CR),@CR&@CR,@CR),@CR,@CRLF) ;���������� ����� ��� ������� �� ������
$Strings = StringSplit($Content,@CRLF,1) ;�������� �� ������ � ������

For $i=1 to 1;$Strings[0]
	;������ �������� ������ � ��������
	_IEStartCheck($Strings[$i])
Next


Func _IEStartCheck($address)
	if not $oIE Then ; ������ �������� ���� ��� �� �������
		$oIE        = _IECreate('about:blank', 0, 0)
		_IEAction($oIE, 'visible')
		sleep($sleepLoad)
	EndIf
	_IENavigate ($oIE, $address,0) ;��������� �� ��������
	$a = _IELoadWait($oIE,500,$sleepLoad);������� ��������� �������� ��������
	if WinExists($titleWinPassword) then _CheckWinPass($address)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
	$html=_IEDocReadHTML($oIE)
	ConsoleWrite($html)
EndFunc

Func _CheckWinPass($address)
	For $p=0 to UBound($LoginPass)-1 step $CountTestPass ; ���� ���� �� ���������� ��� ������
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $p = ' & $p & @CRLF) ;### Debug Console
		if WinWait($titleWinPassword,'',0.5)=0 then return 0 ;����� ���� �� ���������� ���� ����� ������
		For $i=0 to $CountTestPass
			WinActivate($titleWinPassword) ;��������� ����
			ControlSend($titleWinPassword,'',$controlWinLogin,$LoginPass[$p+$i][0]) ;�������� ������
			sleep($sleepMin)
			Controlsend($titleWinPassword,'',$controlWinPass,'{TAB}') ;���
			sleep($sleepMin)
			ControlSend($titleWinPassword,'',$controlWinPass,$LoginPass[$p+$i][1]) ;�������� ������
			sleep($sleepMin)
			Controlsend($titleWinPassword,'',$controlWinPass,'{ENTER}') ; Enter
			sleep($sleepMin)
		Next
		;������ ����� � ������������ ��������
		For $i=1 to 10
			if WinWait($titleWinPassword,'',0.5)=0 then exitloop
			Controlsend($titleWinPassword,'',$controlWinPass,'{ENTER}') ; Enter
			sleep($sleepMin)
			ControlClick($titleWinPassword,'',$controlWinButtonCANCEL) ; ���� �� ������ ������
			sleep($sleep)
		Next

		sleep($sleep)
		_IENavigate ($oIE, $address,0) ;��������� �� ��������
		$a = _IELoadWait($oIE,500,$sleepLoad);������� ��������� �������� ��������
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$t = WinWait($titleWinPassword,'',$sleepLoad/1000)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		if $t=0 then ; ������ �������
			sleep($sleep)
			_IENavigate ($oIE, $address,0) ;��������� �� ��������
			$a = _IELoadWait($oIE,500,$sleepLoad);������� ��������� �������� ��������
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			$t = WinWait($titleWinPassword,'',$sleepLoad/1000)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		EndIf

	Next

EndFunc
Func _Exit()
	Exit
EndFunc


;~ $oIE.Visible=1
;~ $oIE.RegisterAsDropTarget = 1
;~ $oIE.RegisterAsBrowser = 1
;~ $oIE.Navigate( "http://www.AutoItScript.com/" )