#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=\\192.168.0.1\ftp\pub\temp\temp\tempbr3.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
global $Paused
HotKeySet("{F7}", "Terminate")
Func Terminate()
	Exit
EndFunc   ;==>Terminate
Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		Sleep(100)
		If $trayP = 1 Then TrayTip("Подсказка", "Пауза", 1000)
	WEnd
EndFunc   ;==>_Pause

Opt("WinTitleMatchMode", -2) ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
;~ #RequireAdmin

;~ ConsoleWrite(_rnd30(1.5*60000) & @CRLF)

$returnBuffer = 0
if StringLen(WinGetTitle('[TITLE:Подбор слов - Internet Explorer; CLASS:IEFrame]')) > 3 Then
	$title = WinGetHandle(WinGetTitle('[TITLE:Подбор слов - Internet Explorer; CLASS:IEFrame]'))
Else
	$title = WinGetHandle(WinGetTitle('[TITLE: - Internet Explorer; CLASS:IEFrame]'))
EndIf

$page = 'https://wordstat.yandex.ru/#!/?regions=11353'
$sleep1000 = _rnd30(1000)
$sleep5000 = _rnd30(3000)
Global $delay = _rnd10(200)
; получения списка ключевых слов для поиска
if FileExists(@ScriptDir & '\keywords.txt') Then
	$sWords=FileRead(@ScriptDir & '\keywords.txt')
Else
	$sWords = ClipGet()
EndIf
$aWords=StringSplit(StringReplace($sWords,@CR,''),@lf)

FileDelete(@ScriptDir&'\alreadyFiish.txt')

For $i=1 to $aWords[0]
	$sleep1000 = _rnd30(1000)
	$sleep5000 = _rnd30(3000)
	$delay = _rnd10(200)
	$word = $aWords[$i]
	WinActivate($title)
	Sleep($delay)

	_ReloadPage($title, $page)
	ClipPut($word) ; помещяем слово в буффер обмена
	Sleep($sleep5000)
	_SendPlus('{INS}', 0, 1) ; вставляем слово
	_SendPlus('{Enter}', 0, 4) ; подтверждаем слово
	ClipPut('') ;отчищяем буфер обена
	Sleep($sleep5000)
	_SendPlus('{TAB}', 0, 4)
	_SendPlus('{TAB}', 0, 4)
	_SendPlus('ф', 'a', 0) ; выделяем всю страницу
	_SendPlus('{INS}', 0, 0) ;Копируем
	$text = ClipGet()
	ClipPut('') ;отчищяем буфер обена


	$a = StringRegExp($text,'(?s)Что искали со словом.*?Показов в месяц(.*?)Запросы, похожие на.*?Показов в месяц(.*?)Страницы',2)
	if not @error then
		FileWrite ( @ScriptDir&'\data1235.txt', '___Words'&@CRLF&_DeleteRNRN($a[1]) & @CRLF & '___Similar'&@CRLF&_DeleteRNRN($a[2]) )
	EndIf
	FileWriteLine(@ScriptDir&'\alreadyFiish.txt',$word)
	Sleep(_rnd30(1.5*60000))

Next

Func _rnd30($int)
	return Round(Random($int-$int*0.3,$int+$int*0.3),0)
EndFunc
Func _rnd10($int)
	return Round(Random($int-$int*0.1,$int+$int*0.1),0)
EndFunc


Func _DeleteRNRN($text)
	$return =0
	For $i=0 to 100
		if StringInStr($text,@CRLF & @CRLF) Then
			$text = StringReplace($text, @CRLF & @CRLF, @CRLF)
		Else
			Return $text
		EndIf
	Next

EndFunc


Func _ReloadPage($title, $page)
	Opt("WinTitleMatchMode", -2) ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
	$hwnd = $title
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $title = ' & $title & @CRLF) ;### Debug Console
	If $returnBuffer = 1 Then $Clip = ClipGet()
	ClipPut($page)
	WinActivate($hwnd)
	Sleep(100)
;~ 	_SendPlus('t', 'е') ; Создаём вкладку
	_SendPlus('е', 't')
;~ 	_SendPlus('{Backspace}', 0, 4) ; стираем лишний символ
	Sleep(300)
	_SendPlus('{TAB}', 0) ; переходим на другую вкладку
;~ 	_SendPlus('w', 'ц') ; закрываем её
	_SendPlus('ц', 'w') ; закрываем её
	Sleep(1000)
	_SendPlus('{INS}', 0, 1) ; вставляем адрес страницы
	Sleep(1000) ; отладка
	_SendPlus('{Enter}', 0, 4) ; загружаем текущую страницу
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
