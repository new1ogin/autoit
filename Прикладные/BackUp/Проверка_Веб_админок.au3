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
;~ Opt("MustDeclareVars", 1) ; обязательно объявить переменные
HotKeySet("{F7}", "_Exit")
Global $Paused, $oIE, $hLog, $OnlySearch, $sleep, $sleepMin, $sleepLoad, $CountTestPass, $hFileDone, $hFileFindWin, $hFileFindWeb, $aDone, $RestartIE
Local $fileDone, $fileFindWin, $fileFindWeb
$hLog = _Log_Open(@ScriptDir & '\ОтчетПроверки.log', '### Лог программы Проверка_Веб_админок ###')
$fileDone = @ScriptDir & '\УжеВыполненные.txt'
$fileFindWin = @ScriptDir & '\Найденные_по_всплывающиму_окну.txt'
$fileFindWeb = @ScriptDir & '\Найденные_по_html_контенту.txt'
$fileCorrect = @ScriptDir & '\Найденные_пароли.txt'

$OnlySearch = 0; Переключатель в режим только поиска
$sleep = 500 ;стандартное время ожидания между действиями
$sleepMin = 100 ; минимальное время ожидания между действиями
$sleepLoad = 10000 ;ожидание загрузки страницы

$CountTestPass = 2
Local $Content, $Strings, $IgnorWordList, $WhiteList, $IgnorRegExpList, $timer, $q = 0, $shet
Global $titleWinPassword, $controlWinLogin, $controlWinPass, $controlWinButtonOK, $controlWinButtonCANCEL, $titleWinList, $aIgnorWordList, $aWhiteList, $aIgnorRegExpList
; загаловки окна windows c запросом пароля
$titleWinPassword = 'Безопасность Windows'
$titleWinList = 'Безопасность Windows|Подключение к'
$controlWinLogin = '[CLASS:Edit; INSTANCE:1]'
$controlWinPass = '[CLASS:Edit; INSTANCE:2]'
$controlWinButtonOK = '[CLASS:Button; INSTANCE:2]'
$controlWinButtonCANCEL = '[CLASS:Button; INSTANCE:3]'

$IgnorWordList = 'ErrorPageTemplate|<h1>Welcome to nginx|Apache HTTP Server Test Page|В процессе разработки|>Under construction<|Site is under construction|<h1>It works!</h1>|This is the default web page||If you are the owner of this website, please contact your hosting provider|>Default Web Site Page<|>Welcome to the home of <|>Forbidden<|Apache is functioning normally|' & _
		'Сайт отключен|>Shared IP<|>There is no site here<|>default.domain<|>400 Bad Request|>401 Unauthorized|>402 Payment Required|>403 Forbidden|>404 Not Found|>405 Method Not Allowed|>406 Not Acceptable|>407 Proxy Authentication Required|>408 Request Timeout|>409 Conflict|>410 Gone|>411 Length Required|>412 Precondition Failed|>413 Request Entity Too Large|>414 Request-URL Too Long|>415 Unsupported Media Type|>416 Requested Range Not Satisfiable|>417 Expectation Failed|>418 I' & "'" & 'm a teapot|>422 Unprocessable Entity|>423 Locked|>424 Failed Dependency|>425 Unordered Collection|>426 Upgrade Required|>428 Precondition Required|>429 Too Many Requests|>431 Request Header Fields Too Large|>434 Requested host unavailable|>449 Retry With|>451 Unavailable For Legal Reasons|>300 Multiple Choices|>301 Moved Permanently|>302 Found|>302 Moved Temporarily|>303 See Other|>304 Not Modified|>305 Use Proxy|>306 (зарезервировано)|>307 Temporary Redirect|>500 Internal Server Error|>501 Not Implemented|>502 Bad Gateway|>503 Service Unavailable|>504 Gateway Timeout|>505 HTTP Version Not Supported|>506 Variant Also Negotiates|>507 Insufficient Storage|>509 Bandwidth Limit Exceeded|>510 Not Extended|>511 Network Authentication Required|>100 Continue|>101 Switching Protocols|>200 OK|>201 Created|>202 Accepted|>203 Non-Authoritative Information|>204 No Content|>205 Reset Content|>206 Partial Content|>408 Request Time-out|>414 Request URL Too Long|>504 Gateway Time-out|>505 HTTP Version not supported'
$aIgnorWordList = StringSplit($IgnorWordList, '|')
$IgnorRegExpList = '(?i)<title>.*?nginx.*?</title>|(?i)<title>.*?nginx.*?</title>|(?i)<title>.*?nginx.*?</title>|(?i)<title>.*?Shared IP.*?</title>|(?i)<title>.*?Apache.*?</title>|(?i)<title>.*?Test Page.*?</title>|(?i)<title>.*?Default.*?</title>|(?i)<title>.*?It works.*?</title>|(?i)<title>.*?Under construction.*?</title>|(?i)<title>.*?В процессе разработки.*?</title>|(?i)<title>.*?default web page.*?</title>|(?i)<title>.*?Default Web Site.*?</title>|(?i)<title>.*?default web.*?</title>|(?i)<title>.*?Welcome to the home.*?</title>|(?i)<title>.*?Welcome to home.*?</title>|(?i)<title>.*?Debian.*?</title>|(?i)<title>.*?Test .*?</title>|(?i)<title>.*?example.*?</title>|(?i)<title>.*?IIS .*?</title>|(?i)<title>.*?lighttpd.*?</title>|(?i)<title>.*?Resin.*?</title>|(?i)<title>.*?Cherokee.*?</title>|(?i)<title>.*?Rootage.*?</title>|(?i)<title>.*?THTTPD.*?</title>|(?i)<title>.*?httpd.*?</title>|(?i)<title>.*?HTTP File Server.*?</title>|(?i)<title>.*?Sambar.*?</title>|(?i)<title>.*?TinyWeb.*?</title>|(?i)<title>.*?Squid.*?</title>|(?i)<title>.*?3proxy.*?</title>|(?i)<title>.*?HandyCache.*?</title>|(?i)<title>.*?UserGate.*?</title>|(?i)<title>.*?no site.*?</title>'
$aIgnorRegExpList = StringSplit($IgnorRegExpList, '|')
$WhiteList = 'none|Сертификат безопасности'
$aWhiteList = StringSplit($WhiteList, '|')

; получение параметров из коммандной строки
Dim $CmdLineN[2]
If $CmdLine[0] = 1 Then
	$CmdLineN = $CmdLine
Else
	$CmdLineN[0] = 1
	$CmdLineN[1] = @ScriptDir & '\VNC_bypauth.txt'
EndIf

;получение паролей и логинов
Local $aTemp, $tpos, $TempRead, $schetchik, $noneString, $filePass = @ScriptDir & '\VNC_LoginPass.txt'
If Not FileExists($filePass) And $OnlySearch = 0 Then MsgBox(0, ' Ошибка', ' Не нейден файл с логинами паролями: ' & @CRLF & $filePass)
$TempRead = FileRead($filePass)
$TempRead = StringReplace(StringReplace(StringReplace(StringReplace($TempRead, @CRLF, @CR), @LF, @CR), @CR & @CR, @CR), @CR, @CRLF) ;подготовка файла для деления на строки
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


;Чтение адресов сайтов
$Content = FileRead($CmdLineN[1]) ;чтение адресов сайтов из файла
$Content = StringReplace(StringReplace(StringReplace(StringReplace($Content, @CRLF, @CR), @LF, @CR), @CR & @CR, @CR), @CR, @CRLF) ;подготовка файла для деления на строки
$Strings = StringSplit($Content, @CRLF, 1) ;Разбитие на строки в массив
$Content = ''
Global $aStrings
Dim $aStrings[$Strings[0] + 1][2]
For $i = 0 To $Strings[0] ; Копируем массив адресов в двумерный массив
	$aStrings[$i][0] = $Strings[$i]
Next
$Strings = ''
_Log_Report($hLog, 'Загружено адресов сайтов: ' & $aStrings[0][0] & @CRLF)

;открытие вспомогательных файлов
If Not FileExists($fileDone) Then FileWrite($fileDone, 'Список выполненных адресов:' & @CRLF)
$aDone = StringSplit(FileRead($fileDone), @CRLF)
_ArraySort($aDone, 0, 1)
$hFileDone = FileOpen($fileDone, 1)
$hFileFindWin = FileOpen($fileFindWin, 1)
$hFileFindWeb = FileOpen($fileFindWeb, 1)
$hfileCorrect = FileOpen($fileCorrect, 1)

_startIE() ; запуск браузера
$shet = 0
For $i = 1 To $aStrings[0][0]
	$timer = TimerInit()
	$RestartIE = 0
	If _ArrayBinarySearch($aDone, $aStrings[$i][0], 1) = -1 Then ; проверка не выполнялся ли уже этот адрес
		$shet += 1
		_IEStartCheck($i);Запуск проверки адреса в браузере
		If TimerDiff($timer) > 10 Or $shet < 10 Then
			$q = 0
			FileWriteLine($fileDone, $aStrings[$i][0] & @CRLF)
		Else
			If $q > 50 Then _Exit('Выход по ошибке: Слишком быстрый пропуск сайтов')
			$q += 1
		EndIf
		Sleep($sleep)
	EndIf
Next

Func _IEStartCheck($iadd)
	Local $a, $t, $html, $search, $w
	ConsoleWrite($aStrings[$iadd][0] & @CRLF)
	_IENavigate($oIE, $aStrings[$iadd][0], 0) ;Переходим на страницу
	For $w = 1 To 4
		$a = _IELoadWait($oIE, 100, $sleepLoad / 4);Ожидаем окончания загрузки страницы
		If $a = 1 Then ExitLoop
		If WinExists($titleWinPassword) Then ExitLoop
	Next
	_getHWND()
	If TimerDiff($timer) > $sleepLoad Then $RestartIE = 1
	If WinExists($titleWinPassword) Then _CheckWinPass($iadd)
	If $RestartIE = 1 Then ;обработка зависшей загрузки страницы
		$html = _IEDocReadHTML($oIE)
		If StringLen($html) < 100 Then ;проверка зависла ли действительно страница
			_IEQuit($oIE)
			Sleep(1000)
			For $i = 1 To 5
				If Not ProcessExists('iexplore.exe') Then ExitLoop
				ProcessClose('iexplore.exe')
				Sleep($sleepMin)
			Next
			Sleep($sleep)
			_startIE() ; запуск браузера
			Return 0
		EndIf
	EndIf

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

	If $search = 1 And StringLen($html) > 100 Then
		_Log_Report($hLog, 'Найден контент на сайте: ' & $aStrings[$iadd][0] & @CRLF)
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
	_Log_Report($hLog, 'Найден запрос пароля в отдельном окне на сайте: ' & $aStrings[$iadd][0] & @CRLF)
	FileWriteLine($hFileFindWin, $aStrings[$iadd][0] & @CRLF)
	If $OnlySearch = 1 Then
		_cancelWindowPass() ;отмена ввода
		Return 1
	EndIf

	_getHWND()
	;получение содержимого страницы при неправильном ответе
	If $aStrings[$iadd][1] = '' Then
		_cancelWindowPass() ;отмена ввода
		Sleep($sleep * 2)
		$aStrings[$iadd][1] = _IEDocReadHTML($oIE) ;запись содержимого
		_IEStartCheck($iadd)
		Return 1
	EndIf



	For $p = 0 To 0;UBound($aLoginPass) - 1 Step $CountTestPass ; цикл пока не закончатся все пароли
		If WinWait($titleWinPassword, '', 1) = 0 Then Return 0 ;выйти если не существует окна ввода пароля
		For $i = 0 To $CountTestPass - 1
			WinActivate($titleWinPassword) ;активация окна
			ControlSend($titleWinPassword, '', $controlWinLogin, $aLoginPass[$p + $i][0]) ;отправка логина
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, '{TAB}') ;таб
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, $aLoginPass[$p + $i][1]) ;отправка пароля
			Sleep($sleepMin)
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			; проверка удачно ли введен пароль
			Sleep($sleep * 2)
			$html = _IEDocReadHTML($oIE) ;запись содержимого
			If StringRegExpReplace($html, '[0-9]', '') = StringRegExpReplace($aStrings[$iadd][1], '[0-9]', '') Then
				ConsoleWrite(' Логин и Пароль не подошли: ' & $aLoginPass[$p + $i][0] & '   ' & $aLoginPass[$p + $i][1] & @CRLF)
			Else
				ConsoleWrite(' Логин и Пароль ПОДОШЛИ: ' & $aLoginPass[$p + $i][0] & '   ' & $aLoginPass[$p + $i][1] & @CRLF)
				FileWriteLine($hfileCorrect, $aStrings[$iadd][0] & '   ' & $aLoginPass[$p + $i][0] & '   ' & $aLoginPass[$p + $i][1] & @CRLF)
				return 2
			EndIf
		Next
		;отмена ввода и перезагрузка страницы
		For $c = 1 To 10
			If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; клик по кнопке отмена
			Sleep($sleep)
		Next

		Sleep($sleep)

		; странная непонятная хрень, назначение которой я забыл на вторые сутки...
		If $p > UBound($aLoginPass) - 3 Then ContinueLoop
		_IENavigate($oIE, $aStrings[$iadd][0], 0) ;Переходим на страницу
		$a = _IELoadWait($oIE, 500, $sleepLoad);Ожидаем окончания загрузки страницы
		$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
		If $t = 0 Then ; вторая попытка
			Sleep($sleep)
			_IENavigate($oIE, $aStrings[$iadd][0], 0) ;Переходим на страницу
			$a = _IELoadWait($oIE, 500, $sleepLoad);Ожидаем окончания загрузки страницы
			$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
		EndIf

	Next

EndFunc   ;==>_CheckWinPass

Func _cancelWindowPass() ;отмена ввода
	For $c = 1 To 20
		If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
		ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
		Sleep($sleepMin)
		ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; клик по кнопке отмена
		Sleep($sleep)
	Next
EndFunc   ;==>_cancelWindowPass


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
	$sText = StringRegExpReplace($sText, '(?s)<!--.*?-->', '') ; удаление комментариев

	; ============= блок colspan, rowspan
	$0 = Chr(0)
	$Rep = StringRegExp($sText, '(?s)(<[^<>]+?(?:colspan|rowspan)[^<>]+?>)', 3) ; в массив
	If Not @error Then
		$Tr = 1
		$sText = StringRegExpReplace($sText, '(?s)(<[^<>]+?(?:colspan|rowspan)[^<>]+?[^/]>)', $0) ; временная подмена
	EndIf
	$sText = StringRegExpReplace($sText, '(?s)(<(?:' & $teg & '))[\r\n]* [^<>]*?(>)', '\1\2') ; очистка

	If $Tr Then
		For $i = 0 To UBound($Rep) - 1
			$Rep[$i] = _Replace($Rep[$i])
			$sText = StringReplace($sText, $0, $Rep[$i], 1)
		Next
	EndIf
	; =============

	$sText = StringReplace($sText, '<p><o:p>&nbsp;</o:p></p>', '<br><br>') ; замена переносов строк
	; $sText=StringRegExpReplace($sText, '(?s)(<('&$teg&').*?>)(.*?)</\2>(\s*)\1', '\1\3\4') ; очистка дублирования
	$sText = StringRegExpReplace($sText, '(?s)<(' & $teg & ')[^<>]*?>[\x{A0}\s]*?</\1>', '') ; очистка тегов без контента

	$DelAll = 'xml|style|script'
	$sText = StringRegExpReplace($sText, '(?s)<(' & $DelAll & ')[^<>]*>(.*?)</\1>', '') ; удаление с содержимым

	$DelTag = 'span'
;~ 	$sText = StringRegExpReplace($sText, '(?s)</?(' & $DelTag & ')[^<>]*>', '') ; удаление самих тегов

	Return $sText
EndFunc   ;==>_ClearHTML

Func _Replace($Rep)
	$teg = 'table|td|tr|th'
	$aRep = StringRegExp($Rep, '((?:colspan|rowspan)\h*=\h*"?\d+"?)', 3)
	$Rep = StringRegExpReplace($Rep, '(?s)(<(?:' & $teg & ')) .*?(>)', '\1') ; очистка
	For $i = 0 To UBound($aRep) - 1
		$Rep &= ' ' & $aRep[$i]
	Next
	$Rep &= '>'
	Return $Rep
EndFunc   ;==>_Replace

