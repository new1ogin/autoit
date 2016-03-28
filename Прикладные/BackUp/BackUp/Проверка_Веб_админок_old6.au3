#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Проверка_Доступности_Веб_админок_x32.exe
#AutoIt3Wrapper_Outfile_x64=Проверка_Доступности_Веб_админок_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <IE.au3>
#include <log.au3>
Opt("MustDeclareVars", 1) ; обязательно объявить переменные
HotKeySet("{F7}", "_Exit")
Global $Paused, $oIE, $hLog, $OnlySearch, $sleep, $sleepMin, $sleepLoad, $CountTestPass
$hLog = _Log_Open(@ScriptDir & '\ОтчетПроверки.log', '### Лог программы Проверка_Веб_админок ###')

$OnlySearch = 1; Переключатель в режим только поиска
$sleep = 500 ;стандартное время ожидания между действиями
$sleepMin = 100 ; минимальное время ожидания между действиями
$sleepLoad = 5000 ;ожидание загрузки страницы

$CountTestPass = 2
Local $LoginPass[6][2] = [['admin1', 'admin'], ['admin2', ''], ['admin3', ''], ['admin4', 'admin'], ['admin5', ''], ['admin6', '']]
Local $Content, $Strings, $IgnorWordList, $WhiteList,$IgnorRegExpList
Global $titleWinPassword, $controlWinLogin, $controlWinPass, $controlWinButtonOK, $controlWinButtonCANCEL, $titleWinList, $aIgnorWordList, $aWhiteList,$aIgnorRegExpList
; загаловки окна windows c запросом пароля
$titleWinPassword = 'Безопасность Windows'
$titleWinList = 'Безопасность Windows|Подключение к'
$controlWinLogin = '[CLASS:Edit; INSTANCE:1]'
$controlWinPass = '[CLASS:Edit; INSTANCE:2]'
$controlWinButtonOK = '[CLASS:Button; INSTANCE:2]'
$controlWinButtonCANCEL = '[CLASS:Button; INSTANCE:3]'

$IgnorWordList = 'ErrorPageTemplate|<h1>Welcome to nginx|Apache HTTP Server Test Page|В процессе разработки|>Under construction<|Site is under construction|<h1>It works!</h1>|This is the default web page||If you are the owner of this website, please contact your hosting provider|>Default Web Site Page<|>Welcome to the home of <|>Forbidden<|Apache is functioning normally|' & _
'>default.domain<|>400 Bad Request|>401 Unauthorized|>402 Payment Required|>403 Forbidden|>404 Not Found|>405 Method Not Allowed|>406 Not Acceptable|>407 Proxy Authentication Required|>408 Request Timeout|>409 Conflict|>410 Gone|>411 Length Required|>412 Precondition Failed|>413 Request Entity Too Large|>414 Request-URL Too Long|>415 Unsupported Media Type|>416 Requested Range Not Satisfiable|>417 Expectation Failed|>418 I' & "'" & 'm a teapot|>422 Unprocessable Entity|>423 Locked|>424 Failed Dependency|>425 Unordered Collection|>426 Upgrade Required|>428 Precondition Required|>429 Too Many Requests|>431 Request Header Fields Too Large|>434 Requested host unavailable|>449 Retry With|>451 Unavailable For Legal Reasons|>300 Multiple Choices|>301 Moved Permanently|>302 Found|>302 Moved Temporarily|>303 See Other|>304 Not Modified|>305 Use Proxy|>306 (зарезервировано)|>307 Temporary Redirect|>500 Internal Server Error|>501 Not Implemented|>502 Bad Gateway|>503 Service Unavailable|>504 Gateway Timeout|>505 HTTP Version Not Supported|>506 Variant Also Negotiates|>507 Insufficient Storage|>509 Bandwidth Limit Exceeded|>510 Not Extended|>511 Network Authentication Required|>100 Continue|>101 Switching Protocols|>200 OK|>201 Created|>202 Accepted|>203 Non-Authoritative Information|>204 No Content|>205 Reset Content|>206 Partial Content|>408 Request Time-out|>414 Request URL Too Long|>504 Gateway Time-out|>505 HTTP Version not supported'
$aIgnorWordList = StringSplit($IgnorWordList, '|')
$IgnorRegExpList = '(?i)<title>.*?nginx.*?</title>|(?i)<title>.*?Apache.*?</title>|(?i)<title>.*?Test Page.*?</title>|(?i)<title>.*?Default.*?</title>|(?i)<title>.*?It works.*?</title>|(?i)<title>.*?Under construction.*?</title>|(?i)<title>.*?В процессе разработки.*?</title>|(?i)<title>.*?default web page.*?</title>|(?i)<title>.*?Default Web Site.*?</title>|(?i)<title>.*?default web.*?</title>|(?i)<title>.*?Welcome to the home.*?</title>|(?i)<title>.*?Welcome to home.*?</title>|(?i)<title>.*?Debian.*?</title>|(?i)<title>.*?Test .*?</title>|(?i)<title>.*?example.*?</title>|(?i)<title>.*?IIS .*?</title>|(?i)<title>.*?lighttpd.*?</title>|(?i)<title>.*?Resin.*?</title>|(?i)<title>.*?Cherokee.*?</title>|(?i)<title>.*?Rootage.*?</title>|(?i)<title>.*?THTTPD.*?</title>|(?i)<title>.*?httpd.*?</title>|(?i)<title>.*?HTTP File Server.*?</title>|(?i)<title>.*?Sambar.*?</title>|(?i)<title>.*?TinyWeb.*?</title>|(?i)<title>.*?Squid.*?</title>|(?i)<title>.*?3proxy.*?</title>|(?i)<title>.*?HandyCache.*?</title>|(?i)<title>.*?UserGate.*?</title>'
$aIgnorRegExpList = StringSplit($IgnorRegExpList, '|')
$WhiteList = 'Ошибка сертификата|Сертификат безопасности'
$aWhiteList = StringSplit($WhiteList, '|')

; получение параметров из коммандной строки
Dim $CmdLineN[2]
If $CmdLine[0] = 1 Then
	$CmdLineN = $CmdLine
Else
	$CmdLineN[0] = 1
	$CmdLineN[1] = @ScriptDir & '\VNC_bypauth.txt'
EndIf

$Content = FileRead($CmdLineN[1]) ;чтение адресов сайтов из файла
$Content = StringReplace(StringReplace(StringReplace(StringReplace($Content, @CRLF, @CR), @LF, @CR), @CR & @CR, @CR), @CR, @CRLF) ;подготовка файла для деления на строки
$Strings = StringSplit($Content, @CRLF, 1) ;Разбитие на строки в массив
_Log_Report($hLog, 'Загружено адресов сайтов: ' & $Strings[0] & @CRLF)

; запуск браузера
$oIE = _IECreate('about:blank', 0, 0)
_IEAction($oIE, 'visible')
Sleep($sleepLoad / 2)

For $i = 1 To $Strings[0]
	;Запуск проверки адреса в браузере
	_IEStartCheck($Strings[$i])
Next


Func _IEStartCheck($address)
	Local $a, $t, $html, $search
	_IENavigate($oIE, $address, 0) ;Переходим на страницу
	$a = _IELoadWait($oIE, 500, $sleepLoad);Ожидаем окончания загрузки страницы
	_getHWND()
	If WinExists($titleWinPassword) Then _CheckWinPass($address)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
	$html = _IEDocReadHTML($oIE)
	;Определение есть ли на странице админка
	$search = 1
	For $i = 1 To $aIgnorWordList[0] ;исключение определенных страниц из отбора
		If StringInStr($html, $aIgnorWordList[$i]) Then
			$search = 0
			ExitLoop
		EndIf
	Next
	For $i = 1 To $aIgnorRegExpList[0] ;исключение определенных страниц из отбора
		If StringRegExp($html, $aIgnorRegExpList[$i]) Then
			$search = 0
			ExitLoop
		EndIf
	Next
	For $i = 1 To $aWhiteList[0] ; включение определенных страниц в отбор, если они были исключены
		If StringInStr($html, $aWhiteList[$i]) Then
			$search = 1
			ExitLoop
		EndIf
	Next

	If $search = 1 And StringLen($html) > 100 Then _Log_Report($hLog, 'Найден контент на сайте: ' & $address & @CRLF)
;~ 	ConsoleWrite($html)
EndFunc   ;==>_IEStartCheck

Func _CheckWinPass($address)
	Local $a, $t, $c
	_Log_Report($hLog, 'Найден запрос пароля в отдельном окне на сайте: ' & $address & @CRLF)
	If $OnlySearch = 1 Then
		;отмена ввода и перезагрузка страницы
		For $c = 1 To 20
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  $c = ' & $c & @CRLF) ;### Debug Console
			If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; клик по кнопке отмена
			Sleep($sleep)
		Next
		Return 1
	EndIf

	_getHWND()
	For $p = 0 To UBound($LoginPass) - 1 Step $CountTestPass ; цикл пока не закончатся все пароли
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $p = ' & $p & @CRLF) ;### Debug Console
		If WinWait($titleWinPassword, '', 1) = 0 Then Return 0 ;выйти если не существует окна ввода пароля
		For $i = 0 To $CountTestPass - 1
			WinActivate($titleWinPassword) ;активация окна
			ControlSend($titleWinPassword, '', $controlWinLogin, $LoginPass[$p + $i][0]) ;отправка логина
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, '{TAB}') ;таб
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, $LoginPass[$p + $i][1]) ;отправка пароля
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
		Next
		;отмена ввода и перезагрузка страницы
		For $c = 1 To 10
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  $c = ' & $c & @CRLF) ;### Debug Console
			If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; клик по кнопке отмена
			Sleep($sleep)
		Next

		Sleep($sleep)
		If $p > UBound($LoginPass) - 3 Then ContinueLoop
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $address = ' & $address & @CRLF) ;### Debug Console
		_IENavigate($oIE, $address, 0) ;Переходим на страницу
		$a = _IELoadWait($oIE, 500, $sleepLoad);Ожидаем окончания загрузки страницы
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
		$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF) ;### Debug Console
		If $t = 0 Then ; вторая попытка
			Sleep($sleep)
			_IENavigate($oIE, $address, 0) ;Переходим на страницу
			$a = _IELoadWait($oIE, 500, $sleepLoad);Ожидаем окончания загрузки страницы
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
			$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF) ;### Debug Console
		EndIf

	Next

EndFunc   ;==>_CheckWinPass

Func _getHWND() ;Функция уточнение загаловка окна
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


Func _Exit()
	Exit
EndFunc   ;==>_Exit


;~ $oIE.Visible=1
;~ $oIE.RegisterAsDropTarget = 1
;~ $oIE.RegisterAsBrowser = 1
;~ $oIE.Navigate( "http://www.AutoItScript.com/" )
