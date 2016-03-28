#include <GUIConstantsEx.au3>
#Region
#AutoIt3Wrapper_Res_requestedExecutionLevel=requireAdministrator
#EndRegion
$s_Serial = DriveGetSerial(StringLeft(@ScriptDir, 2))
$gui = GUICreate ("Идентификатор", 230,35)
GUICtrlCreateLabel ("Ваш идентификатор:", 10,10)
$s_Serial1 = GUICtrlCreateInput ($s_Serial, 120,8, 100)
GUISetState(@SW_SHOW)

While 1
    $msg = GUIGetMsg(1)
    Select
    Case $msg[0] = $GUI_EVENT_CLOSE
    If $msg[1] = $gui Then
        Exit
    EndIf
    EndSelect
WEnd
GUIDelete()
