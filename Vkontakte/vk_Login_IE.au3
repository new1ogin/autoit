#include <IE.au3>

;~ Opt('MustDeclareVars',      1)
Opt('TrayIconDebug', 1)
$iHide = 0 ; 0 - ������� 1 - �������
HotKeySet('{ESC}', '_Exit')
Global $oIE
Global $OldPass = 'xp42DF#&*()', $NewPass = 'xp42DF#&*()'
While 1
	_VK_Pass_change()
	Sleep((10*60000)+Random(765,(5*60000)))
WEnd


Func _VK_Pass_change()

	$oIE = _IECreate('http://vk.com', 0, $iHide )
	If @error Then
		ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	EndIf
	Sleep(2000)
	$errorLogin = 0
	_VK_Login('newlogin7@gmail.com', 'xp42DF#&*()', $iHide )
	If @error Then
		$errorLogin = 1
		ConsoleWrite('�����������' & '������ �����������: ' & @TAB & @error & @CRLF & '������ �������: ' & @TAB & @TAB & @extended)
		$oDivs = _IETagNameGetCollection($oIE, 'a')
		If Not @error Then
			For $oDiv In $oDivs
				$sPropDiv = _IEPropertyGet($oDiv, 'outerhtml')
				If Not @error Then
					If StringInStr($sPropDiv, '�����') Then
						ConsoleWrite(' �� ������������ ������� ��� ����� ������' )
						$errorLogin = 0
						_VK_LogOut()
						_IEQuit ( $oIE )
						_VK_Pass_change()
						return
						ExitLoop

					EndIf
				EndIf
			Next
		EndIf
	EndIf

	if $errorLogin=0 then
		_VKPassChange($OldPass,$NewPass)
		If @error Then ConsoleWrite( '���� �������'& '������ : ' & @TAB & @error & @CRLF & '������ �������: ' & @TAB & @TAB & @extended)

		_VK_LogOut()

		_IEQuit ( $oIE )
	Else
		_VK_LogOut()
		_IEQuit ( $oIE )
		sleep(5000)
		_VK_Pass_change()
		return

	EndIf
EndFunc

Func _VK_LogOut()
sleep(1000)


	Local $oButtons, $oDivs, $oBtns, $sPropDiv, $sPropBtn
;~ 	$oButtons = _IETagNameGetCollection($oIE, 'button')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oButtons = ' & $oButtons & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	For $oButton In $oButtons
;~ 		If $oButton.classname == 'button' And $oButton.innertext == '�����' Then
;~ 			_IEAction($oButton, 'click')
;~ 			_IELoadWait($oIE)
;~ 		EndIf
;~ 	Next
;~ 	sleep(5000)
;~ 	$oDivs=_IETagNameGetCollection($oIE, 'div')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oDivs = ' & $oDivs & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	If Not @error Then
;~ 		For $oDiv In $oDivs
;~ 			$sPropDiv=_IEPropertyGet($oDiv, 'outerhtml')
;~ 			If Not @error Then
;~ 				If StringInStr($sPropDiv, 'button') And StringInStr($sPropDiv, '�����') Then
;~ 					_IEAction($oDiv, 'click')
;~ 					ExitLoop
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	EndIf
;~ 	sleep(5000)
;~ 		$oBtns=_IETagNameGetCollection($oIE, 'button')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oBtns = ' & $oBtns & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	If Not @error Then
;~ 		For $oBtn In $oBtns
;~ 			$sPropBtn=_IEPropertyGet($oBtn, 'outerhtml')
;~ 			If Not @error Then
;~ 				If StringInStr($sPropBtn, 'button') And StringInStr($sPropBtn, '�����') Then
;~ 					_IEAction($oBtn, 'click')
;~ 					ExitLoop
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	EndIf

;~ 	$oButtons = _IETagNameGetCollection($oIE, 'a')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oButtons = ' & $oButtons & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	For $oButton In $oButtons
;~ 		If $oButton.innertext == '�����' Then
;~ 			_IEAction($oButton, 'click')
;~ 			_IELoadWait($oIE)
;~ 		EndIf
;~ 	Next
;~ 	sleep(5000)
	$oDivs = _IETagNameGetCollection($oIE, 'a')
	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oDivs = ' & $oDivs & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If Not @error Then
		For $oDiv In $oDivs
			$sPropDiv = _IEPropertyGet($oDiv, 'outerhtml')
			If Not @error Then
				If StringInStr($sPropDiv, '�����') Then
					_IEAction($oDiv, 'click')
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf
;~ 	sleep(5000)
;~ $oBtns=_IETagNameGetCollection($oIE, 'a')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oBtns = ' & $oBtns & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	If Not @error Then
;~ 		For $oBtn In $oBtns
;~ 			$sPropBtn=_IEPropertyGet($oBtn, 'outerhtml')
;~ 			If Not @error Then
;~ 				If StringInStr($sPropBtn, '�����') Then
;~ 					_IEAction($oBtn, 'click')
;~ 					ExitLoop
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	EndIf
;~ sleep(5000)
;~ $oButtons = _IETagNameGetCollection($oIE, 'a')
;~ For $oButton In $oButtons
;~     If $oButton.classname == "top_nav_link" Then
;~         $oButton.Click()
;~         ExitLoop
;~     EndIf
;~ Next
sleep(500)
EndFunc   ;==>_VK_LogOut


Func _VK_Login($sEmail, $sPass, $iHide = 1)
	Local $oLoginForm, $oEmail, $oPass

	$oLoginForm = _IEFormGetObjByName($oIE, 'login')
	If @error Then
		SetError(2, @error)
		Return 0
	EndIf

	$oEmail = _IEFormElementGetObjByName($oLoginForm, 'email')
	If @error Then
		SetError(3, @error)
		Return 0
	EndIf

	$oPass = _IEFormElementGetObjByName($oLoginForm, 'pass')
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oEmail, $sEmail)
	If @error Then
		SetError(5, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oPass, $sPass)
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf

	_IEFormSubmit($oLoginForm)
	If @error Then
		SetError(5, @error)
		Return 0
	EndIf


	If $iHide Then _IEAction($oIE, 'visible')
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf

	SetError(0, 0)
	Return 1
EndFunc   ;==>_VK_Login

Func _Exit()
	Exit
EndFunc   ;==>_Exit


Func _VKPassChange($OldPassL, $NewPassL)
	Local $oButtons, $oDivs, $oBtns, $oOldPass, $oNewPass, $oNewConfPass, $sPropBtn

	_IENavigate($oIE, "http://vk.com/settings")
	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : _IENavigate($oIE, "http://vk.com/settings") = ' & _IENavigate($oIE, "http://vk.com/settings") & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Sleep(2000)
;~     $oPass      = _IEFormElementGetObjByName($oLoginForm, 'old_password')
	$oOldPass = _IEGetObjByName($oIE, "settings_old_pwd")
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oOldPass, $OldPassL)
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf


	$oNewPass = _IEGetObjByName($oIE, "settings_new_pwd")
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oNewPass, $NewPassL)
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf


	$oNewConfPass = _IEGetObjByName($oIE, "settings_confirm_pwd")
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oNewConfPass, $NewPassL)
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf

	$oBtns = _IETagNameGetCollection($oIE, 'button')
	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oBtns = ' & $oBtns & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If Not @error Then
		For $oBtn In $oBtns
			$sPropBtn = _IEPropertyGet($oBtn, 'outerhtml')
			If Not @error Then
				If StringInStr($sPropBtn, 'button') And StringInStr($sPropBtn, '�������� ������') Then
					_IEAction($oBtn, 'click')
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

EndFunc   ;==>_VKPassChange
