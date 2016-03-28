#include <IE.au3>
;~ $hwnd = WinGetHandle('Yota – Yota 4G - Internet Explorer')
;~ ControlClick($hWnd,'','[CLASS:Internet Explorer_Server; INSTANCE:1]','left',2,155, 488)
;~ Exit
;~ global $errTempdocumentreadyState=0
$testsleep = 2000
$sLogin = "new1ogin@gmail.com"
$sPass = "29101991"
$sUrl = 'https://my.yota.ru/'
$xc = 28
$yc = 46
$xc = 0
$yc = 30
; создание обьекта
;~ $oIE = _IECreate("about:blank")
$oIE = _IECreate($sUrl,1)
If @error Then Exit 11
sleep($testsleep)
_IENavigate($oIE, $sUrl) ;переход по ссылке
If @error Then Exit 12
$hWnd = _IEPropertyGet($oIE, 'hwnd') ; получение хендела окна
; циклы подключения
For $i = 1 To 1
    $oForm = _IEGetObjById($oIE, 'customerLoginForm');ищем форму авторизации (обычно авторизация проходит через форму)
    ;код страницы: <form id="LoginForm"...
    ;остальные элементы находятся внутри этой формы:
    $oUserName = _IEFormElementGetObjByName($oForm, 'IDToken1');код страницы: <input type="text" name="ID"...
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oUserName = ' & $oUserName & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $oUserPass = _IEFormElementGetObjByName($oForm, 'IDToken2');код страницы: <input type="password" name="Password"...
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oUserPass = ' & $oUserPass & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	if $oUserName==0 and $oUserPass==0 then exitloop
	ConsoleWrite('@@')
	exit
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
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : exitloop = '  & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				exitloop
			EndIf
		WEnd ; ждём до начала загрузки следующей страницы
	Endif
	ConsoleWrite("Ждем загрузки "& @CRLF)
    _IELoadWait($oIE) ; теперь ждём до конца загрузки
	ConsoleWrite("Ожидание завершено"& @CRLF)
;~ 	$oInputs = _IETagNameGetCollection ($oIE, "input")
;~ 	For $oInput In $oInputs
;~ 		MsgBox(4096, "Form Input Type", "Form: " & $oInput.form.name & " Type: " & $oInput.type)
;~ 		ConsoleWrite("Form: " & $oInput.form.name & " Type: " & $oInput.type & @CRLF)
;~ 	Next
;Opt("MouseCoordMode", 2)

;~ sleep(5500)
$sHTML = _IEBodyReadHTML($oIE)
;~ $sHTML = StringReplace($sHTML, '<strong>300</strong>', '<strong>0</strong>')
$t350 = '<div class="tarriff-info"><div class="cost"><strong>350</strong> <span>руб. в месяц</span></div><div class="speed"><strong>768</strong> <span>Кбит/сек (макс.)</span></div><div class="time"><strong>25</strong> <span>дней останется</span></div><a class="btn" onclick="changeOffer(' & "'POS-MA15-0003'" & ', this, true); return false;" href="#">Подключить</a> </div>'
$t400 = '<div class="tarriff-info"><div class="cost"><strong>400</strong> <span>руб. в месяц</span></div> <div class="speed"><strong>1.0</strong> <span>Мбит/сек (макс.)</span></div> <div class="time"><strong>21</strong> <span>день останется</span></div> <a class="btn" onclick="changeOffer('&"'POS-MA15-0004'"&', this, true); return false;" href="#">Подключить</a></div>'
$sHTML = StringRegExpReplace($sHTML,'<div class="tarriff-info">.*?</div>',$t350)
MsgBox(0,'',@extended)
;~ $sHTML = StringReplace($sHTML, 'Новичок', 'Супер-пупер модератор :)')
;~ $errTempdocumentreadyState=0
ConsoleWrite("Записываем... "& @CRLF)
_IEBodyWriteHTML($oIE, $sHTML, 1)
;~ $oIE.visible = 1
sleep(500)
	$oElements = _IETagNameAllGetCollection ($oIE)
	For $oElement In $oElements
		if $oElement.tagname == 'A' Then
			if $oElement.classname == 'btn' Then
					;ConsoleWrite("Tagname: " & $oElement.tagname&$oElement.id & @CR & "x: " &$iElementX& "y: " &$iElementY& @CR & "innerText: " & $oElement.innerText & @CRLF)
					$t1 = _IEAction($oElement, 'click')
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			EndIf
		EndIf
	Next
Exit
;~ <a class="btn" onclick="changeOffer('POS-MA15-0003', this, true); return false;" href="#">Подключить</a>
	$oElements = _IETagNameAllGetCollection ($oIE)
	$schet = 0
	$increaseN = 0
	For $oElement In $oElements
;~ 		ConsoleWrite("Tagname: " & $oElement.tagname & @CR & "innerText: " & $oElement.innerText & @CRLF)
;~ 		$oForClick=_IEGetObjById($oIE, $oElement.id)

		;Нахождение тега увеличения
		if $oElement.tagname == 'DIV' Then
			if $oElement.classname == 'increase' Then
				$increaseN = $schet
			$hIE=_IEPropertyGet($oElements,"hwnd")
			$oBCR=$oElement.getBoundingClientRect()
			$iElementX=$oBCR.left ;координаты элемента
			$iElementY=$oBCR.top ;координаты элемента
			if $iElementX<>0 and $iElementY<>0 Then
;~ 				MouseMove($iElementX+$xc,$iElementY+$yc)
;~ 				ConsoleWrite("Tagname: " & $oElement.tagname&$oElement.classname & @CR & "x: " &$iElementX& "y: " &$iElementY& @CR & "innerText: " & $oElement.innerText & @CRLF)
;~ 				sleep(1000)
			EndIf
			Endif
		EndIf
;~ 		if $oElement.id == 'logo' Then
;~ 			$hIE=_IEPropertyGet($oElements,"hwnd")
;~ 			$oBCR=$oElement.getBoundingClientRect()
;~ 			$iElementX=$oBCR.left ;координаты элемента
;~ 			$iElementY=$oBCR.top ;координаты элемента
;~ 			if $iElementX<>0 and $iElementY<>0 Then
;~ 				MouseMove($iElementX+$xc,$iElementY+$yc)
;~ 				ConsoleWrite("Tagname: " & $oElement.tagname&$oElement.id & @CR & "x: " &$iElementX& "y: " &$iElementY& @CR & "innerText: " & $oElement.innerText & @CRLF)
;~ 				sleep(1000)
;~ 			EndIf
;~ 		EndIf
;~ 		if $oElement.tagname == 'IMG' Then
;~ 			$hIE=_IEPropertyGet($oElements,"hwnd")
;~ 			$oBCR=$oElement.getBoundingClientRect()
;~ 			$iElementX=$oBCR.left ;координаты элемента
;~ 			$iElementY=$oBCR.top ;координаты элемента
;~ 			if $iElementX<>0 and $iElementY<>0 Then
;~ 				MouseMove($iElementX+$xc,$iElementY+$yc)
;~ 				ConsoleWrite("Tagname: " & $oElement.tagname&$oElement.id & @CR & "x: " &$iElementX& "y: " &$iElementY& @CR & "innerText: " & $oElement.innerText & @CRLF)
;~ 				sleep(1000)
;~ 			EndIf
;~ 		EndIf
		if $oElement.tagname == 'A' Then
;~ 			ConsoleWrite('class: '&$oElement.classname & @CRLF)
			if $oElement.classname == 'icon' Then
;~ 				ConsoleWrite('@@ Debug(' & $schet & ') : $increaseN = ' & $increaseN & @CRLF) ;### Debug Console
				$hIE=_IEPropertyGet($oElements,"hwnd")
				$oBCR=$oElement.getBoundingClientRect()
				$iElementX=$oBCR.left ;координаты элемента
				$iElementY=$oBCR.top ;координаты элемента
				$iElementH = $oBCR.bottom - $oBCR.top
				$iElementW = $oBCR.right - $oBCR.left
				if $iElementX<>0 and $iElementY<>0 Then
					if $increaseN + 1 = $schet Then ; если иконка после тега увеличения, то кликнуть
		;~ 				MouseMove($iElementX+$xc+($iElementW/2),$iElementY+$yc+($iElementH/2))
						ControlClick($hWnd,'','[CLASS:Internet Explorer_Server; INSTANCE:1]','left',2,$iElementX+($iElementW/2), $iElementY+($iElementH/2))
						ConsoleWrite("Tagname: " & $oElement.tagname&$oElement.classname & @CR & "x: " &$iElementX& "y: " &$iElementY& @CR & "innerText: " & $oElement.innerText & @CRLF)
;~ 						sleep(200)
						exitloop
					EndIf
				EndIf
			Endif
		EndIf
		$schet+=1
	Next
	$oElements = _IETagNameAllGetCollection ($oIE)
	For $oElement In $oElements
		if $oElement.tagname == 'A' Then
			if $oElement.classname == 'btn' Then
				$hIE=_IEPropertyGet($oElements,"hwnd")
				$oBCR=$oElement.getBoundingClientRect()
				$iElementX=$oBCR.left ;координаты элемента
				$iElementY=$oBCR.top ;координаты элемента
				$iElementH = $oBCR.bottom - $oBCR.top
				$iElementW = $oBCR.right - $oBCR.left
				if $iElementX<>0 and $iElementY<>0 Then
					ControlClick($hWnd,'','[CLASS:Internet Explorer_Server; INSTANCE:1]','left',2,$iElementX+($iElementW/2), $iElementY+($iElementH/2))
				EndIf
			EndIf
		EndIf
	Next
Next
;~ <a class="btn" onclick="changeOffer('POS-MA15-0006', this, true); return false;" href="#">Подключить</a>