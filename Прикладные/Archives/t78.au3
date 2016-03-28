#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <WinAPIEx.au3>
#include <GuiButton.au3>
#include <GuiImageList.au3>

Opt('MustDeclareVars', 1)
Opt('GUICloseOnESC', 0)

Global $hForm, $tRECT, $X, $Y, $Width, $Height, $time = True, _
        $hImage, $nButton, $nMsg, $nPic

HotKeySet('^{F12}', '_Exit') ;Ctrl+F12 выход

;~ $hImage = _GUIImageList_Create(16, 16, 5, 1)
;~ _GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 110)
;~ _GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 131)
;~ _GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 165)
;~ _GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 168)
;~ _GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 137)
;~ _GUIImageList_AddIcon($hImage, @SystemDir & "\shell32.dll", 146)

$tRECT = _WinAPI_GetWorkArea()
$Width = DllStructGetData($tRECT, 'Right') - DllStructGetData($tRECT, 'Left')
$Height = DllStructGetData($tRECT, 'Bottom') - DllStructGetData($tRECT, 'Top')
$X = DllStructGetData($tRECT, 'Left')
$Y = DllStructGetData($tRECT, 'Top')
$hForm = GUICreate("Вот такие пироги.", @DesktopWidth, @DesktopHeight, 0, 0, $WS_POPUP, $WS_EX_TOPMOST)
;~ $hForm = GUICreate('MyGUI', $Width, $Height, $X, $Y, $WS_POPUP, $WS_EX_TOPMOST)
$nPic = GUICtrlCreatePic('C:\Users\Public\Pictures\Sample Pictures\Jellyfish.jpg', 0, 0, $Width, $Height)
GUICtrlSetState(-1, $GUI_DISABLE)
;GUISetBkColor(0x87CEFA, $hForm)
$nButton = GUICtrlCreateButton('Click', $Width / 2 - 40, $Height / 2 - 16, 80, 32)
GUICtrlSetFont(-1, 12, 600)
_GUICtrlButton_SetImageList(-1, $hImage)
WinSetTrans($hForm, '', 220)
GUISetState()

_WinAPI_EmptyWorkingSet()

While $time
    $nMsg = GUIGetMsg()
    Switch $nMsg
        Case $GUI_EVENT_CLOSE
            Exit
        Case $nButton
            If MsgBox(262180, 'Test', 'Выходим?') = 6 Then
                _Exit()
            EndIf
    EndSwitch
WEnd

Func _Exit()
    $time = False
EndFunc   ;==>_Exit

