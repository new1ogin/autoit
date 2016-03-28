#include <IE.au3>

Opt('MustDeclareVars',      1)
Opt('TrayIconDebug',        1)

HotKeySet('{ESC}', '_Exit')

_VK_Login('newlogin7@gmail.com', 'xp42DF#&*()')
If @error Then MsgBox(16, 'Авторизация', 'Ошибка авторизации: ' & @TAB & @error & @CRLF & 'Ошибка функции: ' & @TAB & @TAB & @extended)

Func _VK_Login($sEmail, $sPass, $iHide=1)
    Local $oIE, $oLoginForm, $oEmail, $oPass

    $oIE        = _IECreate('http://vkontakte.ru', 0, 0)
    If @error Then
        SetError(1, @error)
        Return 0
    EndIf

    $oLoginForm = _IEFormGetObjByName($oIE, 'login')
    If @error Then
        SetError(2, @error)
        Return 0
    EndIf

    $oEmail     = _IEFormElementGetObjByName($oLoginForm, 'email')
    If @error Then
        SetError(3, @error)
        Return 0
    EndIf

    $oPass      = _IEFormElementGetObjByName($oLoginForm, 'pass')
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
EndFunc

Func _Exit()
    Exit
EndFunc


