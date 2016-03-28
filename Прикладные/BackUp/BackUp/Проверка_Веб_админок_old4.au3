#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=��������_���_�������_x32.exe
#AutoIt3Wrapper_Outfile_x64=��������_���_�������_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <IE.au3>
#include <log.au3>
Opt("MustDeclareVars", 1) ; ����������� �������� ����������
HotKeySet("{F7}", "_Exit")
Global $Paused, $oIE, $hLog, $OnlySearch, $sleep, $sleepMin, $sleepLoad, $CountTestPass
$hLog = _Log_Open(@ScriptDir & '\�������������.log', '### ��� ��������� ��������_���_������� ###')

$OnlySearch = 1; ������������� � ����� ������ ������
$sleep = 500 ;����������� ����� �������� ����� ����������
$sleepMin = 100 ; ����������� ����� �������� ����� ����������
$sleepLoad = 5000 ;�������� �������� ��������

$CountTestPass = 2
Local $LoginPass[6][2] = [['admin1', 'admin'], ['admin2', ''], ['admin3', ''], ['admin4', 'admin'], ['admin5', ''], ['admin6', '']]
Local $Content, $Strings
Global $titleWinPassword, $controlWinLogin, $controlWinPass, $controlWinButtonOK, $controlWinButtonCANCEL,$titleWinList
; ��������� ���� windows c �������� ������
$titleWinPassword = '������������ Windows'
$titleWinList = '������������ Windows|����������� �'
$controlWinLogin = '[CLASS:Edit; INSTANCE:1]'
$controlWinPass = '[CLASS:Edit; INSTANCE:2]'
$controlWinButtonOK = '[CLASS:Button; INSTANCE:2]'
$controlWinButtonCANCEL = '[CLASS:Button; INSTANCE:3]'


; ��������� ���������� �� ���������� ������
Dim $CmdLineN[2]
If $CmdLine[0] = 1 Then
	$CmdLineN = $CmdLine
Else
	$CmdLineN[0] = 1
	$CmdLineN[1] = @ScriptDir & '\VNC_bypauth.txt'
EndIf

$Content = FileRead($CmdLineN[1]) ;������ ������� ������ �� �����
$Content = StringReplace(StringReplace(StringReplace(StringReplace($Content, @CRLF, @CR), @LF, @CR), @CR & @CR, @CR), @CR, @CRLF) ;���������� ����� ��� ������� �� ������
$Strings = StringSplit($Content, @CRLF, 1) ;�������� �� ������ � ������
_Log_Report($hLog, '��������� ������� ������: '& $Strings[0] & @CRLF)

; ������ ��������
$oIE = _IECreate('about:blank', 0, 0)
_IEAction($oIE, 'visible')
Sleep($sleepLoad / 2)

For $i = 1 To 10;$Strings[0]
	;������ �������� ������ � ��������
	_IEStartCheck($Strings[$i])
Next


Func _IEStartCheck($address)
	Local $a, $t, $html, $search
	_IENavigate($oIE, $address, 0) ;��������� �� ��������
	$a = _IELoadWait($oIE, 500, $sleepLoad);������� ��������� �������� ��������
	_getHWND()
	If WinExists($titleWinPassword) Then _CheckWinPass($address)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
	$html = _IEDocReadHTML($oIE)
	;����������� ���� �� �� �������� �������
	$search = 1
	If StringInStr($html, 'ErrorPageTemplate') Then $search = 0
	If StringInStr($html, '<h1>Welcome to nginx!</h1>') Then $search = 0
	If $search = 1 And StringLen($html) > 100 Then _Log_Report($hLog, '������ ������� �� �����: ' & $address & @CRLF)
	ConsoleWrite($html)
EndFunc   ;==>_IEStartCheck

Func _CheckWinPass($address)
	Local $a, $t, $c
	_Log_Report($hLog, '������ ������ ������ � ��������� ���� �� �����: ' & $address & @CRLF)
	If $OnlySearch = 1 Then
		;������ ����� � ������������ ��������
		For $c = 1 To 20
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  $c = ' & $c & @CRLF) ;### Debug Console
			If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; ���� �� ������ ������
			Sleep($sleep)
		Next
		Return 1
	EndIf

	_getHWND()
	For $p = 0 To UBound($LoginPass) - 1 Step $CountTestPass ; ���� ���� �� ���������� ��� ������
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $p = ' & $p & @CRLF) ;### Debug Console
		If WinWait($titleWinPassword, '', 1) = 0 Then Return 0 ;����� ���� �� ���������� ���� ����� ������
		For $i = 0 To $CountTestPass - 1
			WinActivate($titleWinPassword) ;��������� ����
			ControlSend($titleWinPassword, '', $controlWinLogin, $LoginPass[$p + $i][0]) ;�������� ������
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, '{TAB}') ;���
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, $LoginPass[$p + $i][1]) ;�������� ������
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
		Next
		;������ ����� � ������������ ��������
		For $c = 1 To 10
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  $c = ' & $c & @CRLF) ;### Debug Console
			If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; ���� �� ������ ������
			Sleep($sleep)
		Next

		Sleep($sleep)
		If $p > UBound($LoginPass) - 3 Then ContinueLoop
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $address = ' & $address & @CRLF) ;### Debug Console
		_IENavigate($oIE, $address, 0) ;��������� �� ��������
		$a = _IELoadWait($oIE, 500, $sleepLoad);������� ��������� �������� ��������
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
		$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF) ;### Debug Console
		If $t = 0 Then ; ������ �������
			Sleep($sleep)
			_IENavigate($oIE, $address, 0) ;��������� �� ��������
			$a = _IELoadWait($oIE, 500, $sleepLoad);������� ��������� �������� ��������
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
			$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF) ;### Debug Console
		EndIf

	Next

EndFunc   ;==>_CheckWinPass

Func _getHWND() ;������� ��������� ��������� ����
	local $hwnd,$t
	Opt("WinTitleMatchMode", 1)
	StringSplit($titleWinList,'|')
	For $i=1 to $t[0]
		If WinExists('[TITLE:'&$t[$i]&'; CLASS:#32770]') Then
			$titleWinPassword = '[TITLE:'&$t[$i]&'; CLASS:#32770]'
			return $titleWinPassword
		EndIf
	Next
	return $titleWinPassword
EndFunc


Func _Exit()
	Exit
EndFunc   ;==>_Exit


;~ $oIE.Visible=1
;~ $oIE.RegisterAsDropTarget = 1
;~ $oIE.RegisterAsBrowser = 1
;~ $oIE.Navigate( "http://www.AutoItScript.com/" )
