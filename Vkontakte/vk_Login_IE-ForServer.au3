#include <IE.au3>
#include <Array.au3>

;~ Opt('MustDeclareVars',      1)
Opt('TrayIconDebug', 1)
$iHide = 1 ; 0 - ������� 1 - �������
HotKeySet('{ESC}', '_Exit')
Global $oIE
Global $OldPass = 'xp42DF#&*()', $NewPass = 'xp42DF#&*()'

	$oIE = _IECreate('http://vk.com', 0, $iHide )
	If @error Then
		ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	EndIf
	Sleep(2000)
	$errorLogin = 0
	_VK_Login('newlogin8@gmail.com', 'murena31', $iHide )
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
;~ 						_VK_LogOut()
;~ 						_IEQuit ( $oIE )
;~ 						_VK_Pass_change()
;~ 						return
						ExitLoop

					EndIf
				EndIf
			Next
		EndIf
	EndIf

	$pagen = 0
_IENavigate($oIE, "http://vk.com/horror_tales#/wall-40529013?offset="&$pagen*20&"&own=1")

$oLinks = _IELinkGetCollection($oIE)
$sMyString = 'http://vk.com'
Dim $aResult[1]
For $i = 0 To 1
  For $oLink in $oLinks
    If StringInStr($oLink.href, $sMyString) Then
        $aResult[0] = UBound($aResult)
        _ArrayAdd($aResult, $oLink.href)
    EndIf
  Next
Next

_ArrayDisplay($aResult) ; ������� ������ � ���������� ��������

exit


if @ComputerName="server" Then
	Sleep(3*60000)

	If ProcessExists("PingPlotter.exe")=0 Then
;~ 		MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & 'ProcessExists("PingPlotter.exe")' & @CRLF & @CRLF & 'Return:' & @CRLF & ProcessExists("PingPlotter.exe")) ;### Debug MSGBOX
		Run('"'&@ProgramFilesDir&'\PingPlotter Pro\PingPlotter.exe"','',@SW_HIDE)
;~ 		MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & 'Run(''"''&@ProgramFilesDir&''\PingPlotter Pro\PingPlotter.exe"'','''',@SW_HIDE)' & @CRLF & @CRLF & 'Return:' & @CRLF & Run('"'&@ProgramFilesDir&'\PingPlotter Pro\PingPlotter.exe"','',@SW_HIDE)) ;### Debug MSGBOX
	EndIf
EndIf

;~ MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '@ComputerName' & @CRLF & @CRLF & 'Return:' & @CRLF & @ComputerName) ;### Debug MSGBOX


While 1

	if @WDAY<>1 and @WDAY<>7 then
		if @hour <8 or @hour>16 then
			_VK_Pass_change()
			Sleep((10*60000)+Random(765,(5*60000)))
		Else
			sleep(60*60000)
		EndIf
	Else
		_VK_Pass_change()
		Sleep((10*60000)+Random(765,(5*60000)))
	EndIf

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
