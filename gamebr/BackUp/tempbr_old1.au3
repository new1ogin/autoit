

Opt("WinTitleMatchMode", -2) ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
#RequireAdmin

$returnBuffer=0
$title = WinGetHandle(WinGetTitle('[TITLE:Подбор слов - Internet Explorer; CLASS:IEFrame]'))
$page = 'https://wordstat.yandex.ru/#!/?regions=11353'
$sleep1000=1000
$sleep5000=3000
global $delay=200

$word='Привет'
WinActivate($title)
sleep($delay)

_ReloadPage($title,$page)
ClipPut($word) ; помещяем слово в буффер обмена
sleep($sleep5000)
_SendPlus('{INS}', 0, 1) ; вставляем слово
_SendPlus('{Enter}', 0, 4) ; подтверждаем слово
ClipPut('') ;отчищяем буфер обена
sleep($sleep5000)
_SendPlus('{TAB}', 0,4)
_SendPlus('{TAB}', 0,4)
_SendPlus('ф', 'a', 0) ; выделяем всю страницу
_SendPlus('{INS}', 0, 0) ;Копируем
$text = ClipGet()
ClipPut('') ;отчищяем буфер обена

$text = StringReplace($text,@CRLF&@CRLF,@CRLF)
$text = StringReplace($text,@CRLF&@CRLF,@CRLF)
$text = StringReplace($text,@CRLF&@CRLF,@CRLF)
$text = StringReplace($text,@CRLF&@CRLF,@CRLF)
Msgbox(0,'',StringRight($text,1000))

Func _ReloadPage($title,$page)
	Opt("WinTitleMatchMode", -2) ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
	$hwnd = $title
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $title = ' & $title & @CRLF ) ;### Debug Console
	if $returnBuffer=1 then $Clip = ClipGet()
	ClipPut($page)
	WinActivate($hwnd)
	Sleep(100)
;~ 	_SendPlus('t', 'е') ; Создаём вкладку
	_SendPlus('е', 't')
	_SendPlus('{Backspace}', 0, 4) ; стираем лишний символ
	_SendPlus('{INS}', 0, 1) ; вставляем адрес страницы
	Sleep(100)
	_SendPlus('{TAB}', 0) ; переходим на другую вкладку
;~ 	_SendPlus('w', 'ц') ; закрываем её
	_SendPlus('ц', 'w') ; закрываем её
	Sleep(1000)
	_SendPlus('{Enter}', 0, 4) ; загружаем текущую страницу
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