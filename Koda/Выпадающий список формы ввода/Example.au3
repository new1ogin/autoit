#Region Includes
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#EndRegion Includes
#NoTrayIcon

Dim $aData[10][3]
For $i = 0 To 9
    $aData[$i][0] = 'Row ' & StringFormat('%02d', $i)
    $aData[$i][1] = Random(1, 100, 1)
Next

$hMainGui = GUICreate('Demo', 400, 300)

$ListView = GUICtrlCreateListView("", 5, 5, 490, 290)
_GUICtrlListView_SetExtendedListViewStyle($ListView, BitOR($LVS_EX_DOUBLEBUFFER, $LVS_EX_GRIDLINES, $LVS_EX_FULLROWSELECT))

_GUICtrlListView_InsertColumn($ListView, 0, "Col 1", 100, 2)
_GUICtrlListView_InsertColumn($ListView, 1, "Col 2", 100, 2)

For $i = 0 To 9
    $iCol = _GUICtrlListView_InsertItem($ListView, $aData[$i][0])
    _GUICtrlListView_SetItemText($ListView, $iCol, $aData[$i][1], 1)
Next

GUIRegisterMsg($WM_NOTIFY, "WM_NOTIFY")
GUISetState()

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE
            Exit
    EndSwitch
WEnd

Func _SetColorMarker($_tCustDraw, $_iItem)
    $sCellText = _GUICtrlListView_GetItemText($ListView, $_iItem, 1)

    If $sCellText > 50 Then
        DllStructSetData($_tCustDraw, 'clrTextBk', _Color_Convert_RGB2BGR(0xFFFFFF)) ; Text Backgroudn Color White
        DllStructSetData($_tCustDraw, 'clrText', _Color_Convert_RGB2BGR(0x0000FF)) ; Text Color Blue
    Else
        DllStructSetData($_tCustDraw, 'clrTextBk', _Color_Convert_RGB2BGR(0xFFFFFF)) ; Text Backgroudn Color White
        DllStructSetData($_tCustDraw, 'clrText', _Color_Convert_RGB2BGR(0xFF0000)) ; Text Color Red
    EndIf
EndFunc

Func _Color_Convert_RGB2BGR($_iColor)
    Return BitAND(BitShift(String(Binary($_iColor)), 8), 0xFFFFFF)
EndFunc   ;==>_Color_Convert_RGB2BGR

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)
    Local $hWndFrom, $iCode, $tNMHDR, $tInfo

    Local $hListView = $ListView
    If Not IsHWnd($hListView) Then $hListView = GUICtrlGetHandle($hListView)

    $tNMHDR = DllStructCreate($tagNMHDR, $ilParam)
    $hWndFrom = HWnd(DllStructGetData($tNMHDR, "hWndFrom"))
    $iCode = DllStructGetData($tNMHDR, "Code")

    If $hWndFrom = $hListView And $iCode = $NM_CUSTOMDRAW Then
        If Not _GUICtrlListView_GetViewDetails($hWndFrom) Then Return $GUI_RUNDEFMSG

        Local $iDrawStage, $iItem, $iSubitem
        Local $tCustDraw = DllStructCreate('hwnd hwndFrom;int idFrom;int code;dword DrawStage;hwnd hdc;long rect[4];dword ItemSpec;' & _
                                                                             'int ItemState;dword Itemlparam;dword clrText;dword clrTextBk;int SubItem;dword ItemType;' & _
                                                                             'dword clrFace;int IconEffect;int IconPhase;int PartID;int StateID;long rectText[4];int Align', $ilParam)

        $iDrawStage = DllStructGetData($tCustDraw, "DrawStage")
        If $iDrawStage = $CDDS_PREPAINT Then Return $CDRF_NOTIFYITEMDRAW
        If $iDrawStage = $CDDS_ITEMPREPAINT Then Return $CDRF_NOTIFYSUBITEMDRAW ; request drawing each cell separately

        $iItem    = DllStructGetData($tCustDraw, "ItemSpec")
        $iSubitem = DllStructGetData($tCustDraw, "SubItem")

        If $iItem > _GUICtrlListView_GetItemCount($hWndFrom) Then Return 0
        If $iSubitem > _GUICtrlListView_GetColumnCount($hWndFrom) Then Return 0

        _SetColorMarker($tCustDraw, $iItem)
    EndIf

    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY
