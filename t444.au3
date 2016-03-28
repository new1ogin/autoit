#NoTrayIcon
#Include <GuiToolBar.au3>
#include <array.au3>

$hwnd = WinGetHandle("YoTarif")
;~ $hwnd = WinGetHandle('[ACTIVE]')
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetHandle("YoTarif") = ' & WinGetHandle("YoTarif") & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ [223]|µTorrent 3.2|0x000000000041042A
;~ sleep(1000)
;~ Controlsend($hwnd,'','','{Up}')
;~ Exit
_SysTray_ClickItem("NoNameItem", "right", 1)
sleep(1000)
;~ WinClose($hwnd)
ConsoleWrite("Количество пунктов: " & _GUICtrlMenu_GetItemCount($hwnd) & @LF)
WinActivate($hwnd)
$hMenu = _SendMessage(WinGetHandle("[class:#32768]"), 0x01E1, 0, 0) ;MN_GETHMENU
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetHandle("[class:#32768]") = ' & WinGetHandle("[class:#32768]") & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

ConsoleWrite("Количество пунктов: " & _GUICtrlMenu_GetItemCount($hMenu) & @LF)
Controlsend($hwnd,'','','{Down}')
sleep(10)
Controlsend($hwnd,'','','{Down}')
sleep(10)
Controlsend($hwnd,'','','{Down}')
#include <GuiMenu.au3>
$t1 = _GUICtrlMenu_GetMenu($hWnd)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

If @error Then MsgBox(48, "Failure", "Required item not found")

;=========# _SysTray_ClickItem #======================================================
;
;Function Name:    _SysTray_ClickItem()
;Description:      Click on item in Windows system tray by any substring in the title
;Parameters:       $iTitle - The title of the item in Windows system tray (you can see the title of the item when mouse cursor hovered on item).
;                  $iButton - [optional] The button to click, "left" or "right". Default is the left button.
;                  $iClick - [optional] The number of times to click the mouse. Default is 1
;                  $sMove = [optional] True = Mouse will be moved, False (default) = Mouse will not be moved
;                  $iSpeed = [optional] Mouse movement speed
;Return Value(s):  Success - Returns 1
;                  Failure - Returns 0 and sets @error to 1 if required item not found
;Requirement(s):   AutoIt 3.2.10.0 and above
;Autor(s):        R.Gilman (a.k.a rasim); Siao (Thanks for idea)
;
;====================================================================================
Func _SysTray_ClickItem($iTitle, $iButton = "left", $iClick = 1, $sMove = False, $iSpeed = 1)
    Local $hToolbar, $iButCount, $aRect, $hButton, $cID, $i

    $hToolbar = ControlGetHandle("[Class:Shell_TrayWnd]", "", "[Class:ToolbarWindow32;Instance:1]")
    If @error Then
        Return SetError(1, 0, 0)
    EndIf

    $iButCount = _GUICtrlToolbar_ButtonCount($hToolbar)
    If $iButCount = 0 Then
        Return SetError(1, 0, 0)
    EndIf

    $hButton = ControlGetHandle("[Class:Shell_TrayWnd]", "", "Button2")
    If $hButton <> "" Then ControlClick("[Class:Shell_TrayWnd]", "", "Button2")

    For $i = 0 To $iButCount - 1
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iButCount = ' & $iButCount & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') :  $iTitle = ' &  _GUICtrlToolbar_GetButtonText($hToolBar, $cID) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
        $cID = _GUICtrlToolbar_IndexToCommand($hToolBar, $i)
        If StringInStr(_GUICtrlToolbar_GetButtonText($hToolBar, $cID), $iTitle) or _GUICtrlToolbar_GetButtonText($hToolBar, $cID)='' Then
            _GUICtrlToolbar_ClickButton($hToolbar, $cID, $iButton, $sMove, $iClick, $iSpeed)
            Return 1
        EndIf
    Next
    Return SetError(1, 0, 0)
EndFunc