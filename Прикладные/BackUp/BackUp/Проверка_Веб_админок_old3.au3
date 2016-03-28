#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Проверка_Веб_админок_x32.exe
#AutoIt3Wrapper_Outfile_x64=Проверка_Веб_админок_x64.exe
#AutoIt3Wrapper_Compile_Both=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <IE.au3>
#include <log.au3>
Opt("MustDeclareVars", 1) ; обязательно объявить переменные
HotKeySet("{F7}", "_Exit")
Global $Paused, $oIE, $hLog,$OnlySearch,$sleep,$sleepMin,$sleepLoad,$CountTestPass
$hLog = _Log_Open(@ScriptDir & '\ОтчетПроверки.log', '### Лог программы Проверка_Веб_админок ###')

$OnlySearch = 1; Переключатель в режим только поиска
$sleep = 500 ;стандартное время ожидания между действиями
$sleepMin = 100 ; минимальное время ожидания между действиями
$sleepLoad = 3000 ;ожидание загрузки страницы

$CountTestPass = 2
Local $LoginPass[6][2] = [['admin1', 'admin'], ['admin2', ''], ['admin3', ''], ['admin4', 'admin'], ['admin5', ''], ['admin6', '']]
Local $Content, $Strings
global $titleWinPassword,$controlWinLogin,$controlWinPass,$controlWinButtonOK,$controlWinButtonCANCEL
; загаловки окна windows c запросом пароля
$titleWinPassword = 'Безопасность Windows'
$controlWinLogin = '[CLASS:Edit; INSTANCE:1]'
$controlWinPass = '[CLASS:Edit; INSTANCE:2]'
$controlWinButtonOK = '[CLASS:Button; INSTANCE:2]'
$controlWinButtonCANCEL = '[CLASS:Button; INSTANCE:3]'


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

; запуск браузера
$oIE = _IECreate('about:blank', 0, 0)
_IEAction($oIE, 'visible')
Sleep($sleepLoad / 2)

For $i = 1 To 10;$Strings[0]
	;Запуск проверки адреса в браузере
	_IEStartCheck($Strings[$i])
Next


Func _IEStartCheck($address)
	local $a, $t,$html, $search
	_IENavigate($oIE, $address, 0) ;Переходим на страницу
	$a = _IELoadWait($oIE, 500, $sleepLoad);Ожидаем окончания загрузки страницы
	If WinExists($titleWinPassword) Then _CheckWinPass($address)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
	$html = _IEDocReadHTML($oIE)
	;Определение есть ли на странице админка
	$search = 1
	If StringInStr($html, 'ErrorPageTemplate') Then $search = 0
	If StringInStr($html, '<h1>Welcome to nginx!</h1>') Then $search = 0
	If $search = 1 And StringLen($html) > 100 Then _Log_Report($hLog, 'Найден контент на сайте: ' & $address & @CRLF)
	ConsoleWrite($html)
EndFunc   ;==>_IEStartCheck

Func _CheckWinPass($address)
	local $a, $t, $c
	_Log_Report($hLog, 'Найден запрос пароля в отдельном окне на сайте: ' & $address & @CRLF)
	If $OnlySearch = 1 Then
		;отмена ввода и перезагрузка страницы
		For $c = 1 To 20
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  $c = ' & $c & @CRLF) ;### Debug Console
			If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; клик по кнопке отмена
			Sleep($sleep)
		Next
		Return 1
	EndIf

	For $p = 0 To UBound($LoginPass) - 1 Step $CountTestPass ; цикл пока не закончатся все пароли
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $p = ' & $p & @CRLF) ;### Debug Console
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
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  $c = ' & $c & @CRLF) ;### Debug Console
			If WinWait($titleWinPassword, '', 1) = 0 Then ExitLoop
			ControlSend($titleWinPassword, '', $controlWinPass, '{ENTER}') ; Enter
			Sleep($sleepMin)
			ControlClick($titleWinPassword, '', $controlWinButtonCANCEL) ; клик по кнопке отмена
			Sleep($sleep)
		Next

		Sleep($sleep)
		If $p > UBound($LoginPass) - 3 Then ContinueLoop
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $address = ' & $address & @CRLF) ;### Debug Console
		_IENavigate($oIE, $address, 0) ;Переходим на страницу
		$a = _IELoadWait($oIE, 500, $sleepLoad);Ожидаем окончания загрузки страницы
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
		$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF) ;### Debug Console
		If $t = 0 Then ; вторая попытка
			Sleep($sleep)
			_IENavigate($oIE, $address, 0) ;Переходим на страницу
			$a = _IELoadWait($oIE, 500, $sleepLoad);Ожидаем окончания загрузки страницы
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $a = ' & $a & @CRLF) ;### Debug Console
			$t = WinWait($titleWinPassword, '', $sleepLoad / 1000)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF) ;### Debug Console
		EndIf

	Next

EndFunc   ;==>_CheckWinPass


Func _Exit()
	Exit
EndFunc   ;==>_Exit


;~ $oIE.Visible=1
;~ $oIE.RegisterAsDropTarget = 1
;~ $oIE.RegisterAsBrowser = 1
;~ $oIE.Navigate( "http://www.AutoItScript.com/" )
