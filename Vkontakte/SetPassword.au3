#include <IE.au3>
global 	$oIE = _IECreate ("http://vk.com/settings")
;~ _IENavigate
global $OldPass='xp42DF#&*()', $NewPass='xp42DF#&*()'
sleep(3000)
	_FuncPassEnter()
	If @error Then MsgBox(16, 'Ввод паролей', 'Ошибка : ' & @TAB & @error & @CRLF & 'Ошибка функции: ' & @TAB & @TAB & @extended)

;~ 	_IELinkClickByText ($oIE, "Изменить пароль")
;~ 	    If @error Then
;~ 			MsgBox(16, 'Изменить пароль', 'Изменить пароль Ошибка : ' & @TAB & @error)
;~ 		EndIf
;~ 	$oButtons = _IETagNameGetCollection($oIE, 'button')
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oButtons = ' & $oButtons & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	For $oButton In $oButtons
;~ 		If $oButton.classname == 'button' And $oButton.innertext == 'Изменить пароль' Then
;~ 			_IEAction($oButton, 'click')
;~ 			_IELoadWait($oIE)
;~ 		EndIf
;~ 	Next
;~ 	sleep(5000)
;~ 	$oDivs=_IETagNameGetCollection($oIE, 'div')
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oDivs = ' & $oDivs & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	If Not @error Then
;~ 		For $oDiv In $oDivs
;~ 			$sPropDiv=_IEPropertyGet($oDiv, 'outerhtml')
;~ 			If Not @error Then
;~ 				If StringInStr($sPropDiv, 'button') And StringInStr($sPropDiv, 'Изменить пароль') Then
;~ 					_IEAction($oDiv, 'click')
;~ 					ExitLoop
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	EndIf
;~ 	sleep(5000)



Exit

;~ $oForms = _IEFormGetCollection ($oIE)
;~ For $oForm In $oForms
;~ 	_Func($oForm.name)
;~ 	If @error Then MsgBox(16, 'Авторизация', 'Ошибка авторизации: ' & @TAB & @error & @CRLF & 'Ошибка функции: ' & @TAB & @TAB & @extended)
;~ Next

;~ $oForms = _IEFormGetCollection ($oIE)
;~ MsgBox(0, "Forms Info", "There are " & @extended & " forms on this page")
;~ For $oForm In $oForms
;~     MsgBox(0, "Form Info", $oForm.name)
;~ Next

Func _VKPassChange()

	_IENavigate($oIE,"http://vk.com/settings")

;~     $oPass      = _IEFormElementGetObjByName($oLoginForm, 'old_password')
		$oOldPass = _IEGetObjByName($oIE, "settings_old_pwd")
    If @error Then
        SetError(4, @error)
        Return 0
    EndIf

    _IEFormElementSetValue($oOldPass, $OldPass)
    If @error Then
        SetError(6, @error)
        Return 0
    EndIf


		$oNewPass = _IEGetObjByName($oIE, "settings_new_pwd")
    If @error Then
        SetError(4, @error)
        Return 0
    EndIf

    _IEFormElementSetValue($oNewPass, $NewPass)
    If @error Then
        SetError(6, @error)
        Return 0
    EndIf


		$oNewConfPass = _IEGetObjByName($oIE, "settings_confirm_pwd")
    If @error Then
        SetError(4, @error)
        Return 0
    EndIf

    _IEFormElementSetValue($oNewConfPass, $NewPass)
    If @error Then
        SetError(6, @error)
        Return 0
    EndIf

	$oBtns=_IETagNameGetCollection($oIE, 'button')
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oBtns = ' & $oBtns & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If Not @error Then
		For $oBtn In $oBtns
			$sPropBtn=_IEPropertyGet($oBtn, 'outerhtml')
			If Not @error Then
				If StringInStr($sPropBtn, 'button') And StringInStr($sPropBtn, 'Изменить пароль') Then
					_IEAction($oBtn, 'click')
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

EndFunc
