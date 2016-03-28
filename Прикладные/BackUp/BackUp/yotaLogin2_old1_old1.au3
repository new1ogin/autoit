#include <IE.au3>
;~ $hwnd = WinGetHandle('Yota – Yota 4G - Internet Explorer')
;~ ControlClick($hWnd,'','[CLASS:Internet Explorer_Server; INSTANCE:1]','left',2,155, 488)
;~ Exit
;~ global $errTempdocumentreadyState=0
HotKeySet("^{F7}", "Terminate")
$testsleep = 000
$sLogin = "new1ogin@gmail.com"
$sPass = "29101991"
$sUrl = 'https://my.yota.ru/'
$ErrorLogin = 0
$Reload = 0
$StillLogin = 0
$sleep=550*1000
$xc = 28
$yc = 46
$xc = 0
$yc = 30
; создание обьекта
;~ $oIE = _IECreate("about:blank")
$oIE = _IECreate($sUrl,1)
If @error Then Exit 11


; циклы подключения
While 1
For $i = 1 To 1
	sleep($testsleep)
	$timerLogin = Timerinit()
	ConsoleWrite(@YDAY& ' ' & @Hour& ':' & @MIN & ':' & @SEC &' Начало загрузки страницы ')
	_IENavigate($oIE, $sUrl) ;переход по ссылке
	ConsoleWrite(@YDAY& ' ' & @Hour& ':' & @MIN & ':' & @SEC &' - конец '&@crlf)
	If @error Then Exit 12
	$hWnd = _IEPropertyGet($oIE, 'hwnd') ; получение хендела окна
	if _IEPropertyGet($oIE,"title") <> 'Yota – Yota 4G' Then
		$StillLogin=0
		$oForm = _IEGetObjById($oIE, 'customerLoginForm');ищем форму авторизации (обычно авторизация проходит через форму)
		;код страницы: <form id="LoginForm"...
		;остальные элементы находятся внутри этой формы:
		$oUserName = _IEFormElementGetObjByName($oForm, 'IDToken1');код страницы: <input type="text" name="ID"...
		$oUserPass = _IEFormElementGetObjByName($oForm, 'IDToken2');код страницы: <input type="password" name="Password"...
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oUserPass = ' & $oUserPass & @CRLF) ;### Debug Console
		if $oUserName==0 or $oUserPass==0 then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _IEPropertyGet($oIE,"title") = ' & _IEPropertyGet($oIE,"title") & @CRLF) ;### Debug Console
			if _IEPropertyGet($oIE,"title") = 'Yota - Вход в Профиль' Then
				$ErrorLogin=1
				exitloop
			EndIf
			if StringInStr(StringLower(_IEPropertyGet($oIE,"title")), 'страниц') Then
				$ErrorLogin=1
				$reload = 1
				exitloop
			EndIf
		EndIf

		; Вводим логин, пароль и входим
		if not @error Then ; ConsoleWrite('@error'&@error& @CRLF)
			$oUserPass = $oUserPass.nextSibling.nextSibling
			$oL1 = _IETagNameGetCollection($oIE, 'label', 0)
			$oL2 = _IETagNameGetCollection($oIE, 'label', 1)
			$oL1.style.visibility = 'hidden'
			$oL2.style.visibility = 'hidden'
			_IEFormElementSetValue($oUserName, $sLogin);заполняем поля
			_IEFormElementSetValue($oUserPass, $sPass);заполняем поля

			$oSubmit = _IEGetObjById($oIE, "doSubmitLoginForm")
			_IEAction($oSubmit, "click")
			ConsoleWrite("ждём до начала загрузки следующей страницы "& @CRLF)
			$Timer = TimerInit()
			While IsObj($oIE) And $oIE.readyState == 4
				Sleep(50)
				if TimerDiff($Timer) > 10000 Then
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : exitloop = '  & @CRLF) ;### Debug Console
					exitloop
				EndIf
			WEnd ; ждём до начала загрузки следующей страницы
		Endif
		ConsoleWrite("Ждем загрузки "& @CRLF)
		_IELoadWait($oIE) ; теперь ждём до конца загрузки
		ConsoleWrite("Ожидание завершено"& @CRLF)
	Else
		$StillLogin=1
		ConsoleWrite("Вход не требуется "& @CRLF)
		_IELoadWait($oIE) ; теперь ждём до конца загрузки
	EndIf
	$DiffLogin = TimerDiff($timerLogin)


$sHTML = _IEBodyReadHTML($oIE) ; Получаем код страницы
$HtmlTariff = _GetHtmlTariff(350) ;Берем HTML код нужного тарифа
$sHTML = StringRegExpReplace($sHTML,'<div class="tarriff-info">.*?</div>',$HtmlTariff) ;Заменяем код на странице
ConsoleWrite("Записываем... "& @CRLF)
;~ _IEBodyWriteHTML($oIE, $sHTML, 1) ;Применяем изменения

;~ sleep(500)
	;Нажимаем на кнопку Подключить
;~ 	$oElements = _IETagNameAllGetCollection ($oIE)
;~ 	For $oElement In $oElements
;~ 		if $oElement.tagname == 'A' Then
;~ 			if $oElement.classname == 'btn' Then
;~ 					;ConsoleWrite("Tagname: " & $oElement.tagname&$oElement.id & @CR & "x: " &$iElementX& "y: " &$iElementY& @CR & "innerText: " & $oElement.innerText & @CRLF)
;~ 					$t1 = _IEAction($oElement, 'click')
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF) ;### Debug Console
;~ 			EndIf
;~ 		EndIf
;~ 	Next

Next

if $Reload = 0 Then
	If $ErrorLogin=1 Then
		ConsoleWrite(@YDAY& ' ' & @Hour& ':' & @MIN & ':' & @SEC &' ОШИБКА НЕ УДАЛОСЬ ВОЙТИ В ЛК !!! '&@crlf)
	EndIf
	If $StillLogin=1 Then
		ConsoleWrite(@YDAY& ' ' & @Hour& ':' & @MIN & ':' & @SEC &' Пользователь ещё в онлайне, время загрузки = '& $DiffLogin&@crlf)
	Else
		ConsoleWrite(@YDAY& ' ' & @Hour& ':' & @MIN & ':' & @SEC &' Вход выполнен, время загрузки = '& $DiffLogin&@crlf)
	EndIf

	;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _IEPropertyGet($oIE,"title") = ' & _IEPropertyGet($oIE,"title") & @CRLF) ;### Debug Console
	For $i=1 to 100
		Sleep($sleep/100)
		ConsoleWrite('|')
	Next
	ConsoleWrite(@CRLF)
Else
	ConsoleWrite(@YDAY& ' ' & @Hour& ':' & @MIN & ':' & @SEC &' Ошибка загрузки страницы '&@crlf)
EndIf

Wend

exit


Func _GetHtmlTariff($num) ;Берем HTML код нужного тарифа
	Switch $num
		Case 350
			$return = '<div class="tarriff-info"><div class="cost"><strong>350</strong> <span>руб. в месяц</span></div><div class="speed"><strong>768</strong> <span>Кбит/сек (макс.)</span></div><div class="time"><strong>25</strong> <span>дней останется</span></div><a class="btn" onclick="changeOffer(' & "'POS-MA15-0003'" & ', this, true); return false;" href="#">Подключить</a> </div>'
		Case 400
			$return = '<div class="tarriff-info"><div class="cost"><strong>400</strong> <span>руб. в месяц</span></div> <div class="speed"><strong>1.0</strong> <span>Мбит/сек (макс.)</span></div> <div class="time"><strong>21</strong> <span>день останется</span></div> <a class="btn" onclick="changeOffer('&"'POS-MA15-0004'"&', this, true); return false;" href="#">Подключить</a></div>'
		Case 0
			$return = 0
	EndSwitch

	return $return
EndFunc



;~ Func _DelayReload($time,$win,$url)
;~ 	$text = 'timeout /t '&$time&@CRLF&@ScriptDir&'\IEReload.exe '&$win&' '&$url
;~ 	FileWrite(@TempDir & '\DelayReload4autoit.cmd',$text)

Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate