

Opt("WinTitleMatchMode", -2) ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
#RequireAdmin

$returnBuffer=0
$title = WinGetHandle(WinGetTitle('[TITLE:������ ���� - Internet Explorer; CLASS:IEFrame]'))
$page = 'https://wordstat.yandex.ru/#!/?regions=11353'
$sleep1000=1000
$sleep5000=3000
global $delay=200

$word='������'
WinActivate($title)
sleep($delay)

_ReloadPage($title,$page)
ClipPut($word) ; �������� ����� � ������ ������
sleep($sleep5000)
_SendPlus('{INS}', 0, 1) ; ��������� �����
_SendPlus('{Enter}', 0, 4) ; ������������ �����
ClipPut('') ;�������� ����� �����
sleep($sleep5000)
_SendPlus('{TAB}', 0,4)
_SendPlus('{TAB}', 0,4)
_SendPlus('�', 'a', 0) ; �������� ��� ��������
_SendPlus('{INS}', 0, 0) ;��������
$text = ClipGet()
ClipPut('') ;�������� ����� �����

$text = StringReplace($text,@CRLF&@CRLF,@CRLF)
$text = StringReplace($text,@CRLF&@CRLF,@CRLF)
$text = StringReplace($text,@CRLF&@CRLF,@CRLF)
$text = StringReplace($text,@CRLF&@CRLF,@CRLF)
Msgbox(0,'',StringRight($text,1000))

Func _ReloadPage($title,$page)
	Opt("WinTitleMatchMode", -2) ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
	$hwnd = $title
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $title = ' & $title & @CRLF ) ;### Debug Console
	if $returnBuffer=1 then $Clip = ClipGet()
	ClipPut($page)
	WinActivate($hwnd)
	Sleep(100)
;~ 	_SendPlus('t', '�') ; ������ �������
	_SendPlus('�', 't')
	_SendPlus('{Backspace}', 0, 4) ; ������� ������ ������
	_SendPlus('{INS}', 0, 1) ; ��������� ����� ��������
	Sleep(100)
	_SendPlus('{TAB}', 0) ; ��������� �� ������ �������
;~ 	_SendPlus('w', '�') ; ��������� �
	_SendPlus('�', 'w') ; ��������� �
	Sleep(1000)
	_SendPlus('{Enter}', 0, 4) ; ��������� ������� ��������
	if $returnBuffer=1 then ClipPut($clip)
EndFunc   ;==>_ReloadPage

Func _SendPlus($send, $send2 = 0, $key = 0)
	If $key = 0 Then Send('{CTRLDOWN}')
	If $key = 1 Then Send('{SHIFTDOWN}')
	If $key = 2 Then Send('{ALTDOWN}')
	Sleep(64)
	Send($send)
	If $send2 <> 0 Then Send($send)
;~ 	  ControlSend('[CLASS:MozillaWindowClass]', '', '', $send)
;~ 	  if $send2<>0 then ControlSend('[CLASS:MozillaWindowClass]', '', '', $send2)
	Sleep(64)
	If $key = 0 Then Send('{CTRLUP}')
	If $key = 1 Then Send('{SHIFTUP}')
	If $key = 2 Then Send('{ALTUP}')
	Sleep(64)
	sleep($delay)
EndFunc   ;==>_SendPlus