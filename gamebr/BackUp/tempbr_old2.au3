

Opt("WinTitleMatchMode", -2) ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
#RequireAdmin

$returnBuffer = 0
$title = WinGetHandle(WinGetTitle('[TITLE:������ ���� - Internet Explorer; CLASS:IEFrame]'))
if $title = 0 then $title = WinGetHandle(WinGetTitle('[CLASS:IEFrame]'))

$page = 'https://wordstat.yandex.ru/#!/?regions=11353'
$sleep1000 = 1000
$sleep5000 = 3000
Global $delay = 200

$word = '������'
WinActivate($title)
Sleep($delay)

_ReloadPage($title, $page)
ClipPut($word) ; �������� ����� � ������ ������
Sleep($sleep5000)
_SendPlus('{INS}', 0, 1) ; ��������� �����
_SendPlus('{Enter}', 0, 4) ; ������������ �����
ClipPut('') ;�������� ����� �����
Sleep($sleep5000)
_SendPlus('{TAB}', 0, 4)
_SendPlus('{TAB}', 0, 4)
_SendPlus('�', 'a', 0) ; �������� ��� ��������
_SendPlus('{INS}', 0, 0) ;��������
$text = ClipGet()
ClipPut('') ;�������� ����� �����

$text = StringReplace($text, @CRLF & @CRLF, @CRLF)
$text = StringReplace($text, @CRLF & @CRLF, @CRLF)
$text = StringReplace($text, @CRLF & @CRLF, @CRLF)
$text = StringReplace($text, @CRLF & @CRLF, @CRLF)
MsgBox(0, '', StringRight($text, 1000))
Func _ReloadPage($title, $page)
	Opt("WinTitleMatchMode", -2) ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
	$hwnd = $title
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $title = ' & $title & @CRLF) ;### Debug Console
	If $returnBuffer = 1 Then $Clip = ClipGet()
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
	If $returnBuffer = 1 Then ClipPut($Clip)
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
	Sleep($delay)
EndFunc   ;==>_SendPlus
