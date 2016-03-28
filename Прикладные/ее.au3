#include <GUIConstants.au3>
#include <ComboConstants.au3>
#include <ButtonConstants.au3>
#include <WindowsConstants.au3>
#include <GUIListBox.au3>

Opt('TrayIconDebug', 1)

Global $GUI1 = 0, $GUI2 = 0

Gui_start()

Func Gui_start()
    Local $str

    ;=== GUI1 ===
    $GUI1 = GUICreate('������ �������� v1.8', 250, 250) ;�������� GUI (���� ����� ����)
    GUICtrlCreateLabel('������� ����', 10, 20, 120)
    $date = GUICtrlCreateDate(@MDAY & '\' & @MON & '\' & @YEAR, 120, 20, 120, 20, 0x00)
    GUICtrlSetState(-1, $GUI_DROPACCEPTED)
    GUICtrlCreateGroup('���������', 8, 60, 235, 140)
    $radio_1 = GUICtrlCreateRadio('��������� �����', 15, 80, 110, 20)
    $radio_2 = GUICtrlCreateRadio('�������� �������', 15, 100, 115, 20)
    $radio_3 = GUICtrlCreateRadio('��� ������', 15, 120, 100, 20)
    $combo_1 = GUICtrlCreateCombo('', 150, 77, 80, 15, $CBS_DROPDOWNLIST)
    $btn_radio_2 = GUICtrlCreateButton('�������', 150, 102, 80, 20)
    $nCh1 = GUICtrlCreateCheckbox('������ �� ��������� �������', 55, 150, 175, 20, $BS_RIGHTBUTTON)
    $nCh2 = GUICtrlCreateCheckbox('������� ���������� TMP', 55, 170, 175, 20, $BS_RIGHTBUTTON)
;~ "GUICtrlSetTip" - ������� ��� ��������� ���������:
    GUICtrlSetTip($nCh1, '������ ������� �� ��������� ������� ..\reestr\test')
    GUICtrlSetTip($nCh2, '������� ���������� ���������� �������� ..\reestr\test')
    GUICtrlSetData($combo_1, '6501|6502|6503|6504|6505|6506|6507|6508|6509|6510|6511|6512|6513|6514|6515|6516|6517|6518|6519|6520|6521|6522|6523')
    GUICtrlSetState($radio_3, $GUI_CHECKED + $GUI_DEFBUTTON)
    GUICtrlSetState($combo_1, $GUI_DISABLE)
    GUICtrlSetState($btn_radio_2, $GUI_DISABLE)
    GUICtrlCreateGroup('', -99, -99, 1, 1) ;������� ������
    $btn_ok = GUICtrlCreateButton('Ok', 30, 210, 80, 30)
    $btn_cencel = GUICtrlCreateButton('Cencel', 140, 210, 80, 30)
    GUISetState()
    ;=== GUI1 ===

    ;=== GUI2 ===
    $GUI2 = GUICreate("", 140, 250)
    $List = GUICtrlCreateList("", 5, 5, 130, 200, BitOR($LBS_MULTIPLESEL, $GUI_SS_DEFAULT_LIST))
    For $i = 6501 To 6523
        GUICtrlSetData($List, $i)
    Next
    $AllValues = GUICtrlCreateCheckbox("������� ���", 5, 200, 130, 20)
    $BtnValues = GUICtrlCreateButton("��������", 5, 220, 70, 25)
    $BtnValues_ok = GUICtrlCreateButton("OK", 80, 220, 55, 25)
    ;=== GUI2 ===

    GUIRegisterMsg($WM_MOVE, "WM_MOVE")

    While 1
        $aMsg = GUIGetMsg(1)

        Switch $aMsg[0]
            Case $GUI_EVENT_CLOSE, $btn_cencel
                If $aMsg[1] = $GUI1 Then
                    Exit
                ElseIf $aMsg[1] = $GUI2 Then
                    GUISetState(@SW_HIDE, $GUI2)
                EndIf
            Case $btn_ok
                $dd = String(GUICtrlRead($date, 1))
                $var_combo_1 = GUICtrlRead($combo_1)
                $var_btn_radio_2 = $str
                $state_combo_1 = GUICtrlGetState($combo_1)
                $state_btn_radio_2 = GUICtrlGetState($btn_radio_2)

                If $state_combo_1 = '80' And $var_combo_1 <> '' Then
                    $single_region_flag = True
                    $range_region_flag = False
                    $single_region = $var_combo_1
                    $message = MsgBox(4, '�������� ����������', '������� ����:   ' & StringLeft($dd, 2) & '\' & StringMid($dd, 4, 2) & '\' & StringRight($dd, 4) & @CRLF _
                            & '������ �����: ' & $var_combo_1)
                ElseIf $state_btn_radio_2 = '80' And $var_btn_radio_2 <> '' Then
                    $range_region_flag = True
                    $single_region_flag = False
                    $range_region = $var_btn_radio_2
                    $message = MsgBox(4, '�������� ����������', '������� ����:   ' & StringLeft($dd, 2) & '\' & StringMid($dd, 4, 2) & '\' & StringRight($dd, 4) & @CRLF _
                            & '������ �������� �������: ' & @CRLF & $var_btn_radio_2)
                Else
                    $single_region_flag = False
                    $range_region_flag = False
                    $single_region = ''
                    $range_region = ''
                    $message = MsgBox(4, '�������� ����������', '������� ����:   ' & StringLeft($dd, 2) & '\' & StringMid($dd, 4, 2) & '\' & StringRight($dd, 4) & @CRLF _
                            & '������ �����: ���')
                EndIf

                ;����� ���?!
;~              If $message = 7 Then
;~                  ContinueLoop
;~              ElseIf $message = 6 Then
;~                  ExitLoop
;~              EndIf
            Case $radio_1
                GUICtrlSetState($combo_1, $GUI_ENABLE)
                GUICtrlSetState($btn_radio_2, $GUI_DISABLE)
            Case $radio_2
                GUICtrlSetState($btn_radio_2, $GUI_ENABLE)
                GUICtrlSetState($combo_1, $GUI_DISABLE)
            Case $btn_radio_2
                GUISetState(@SW_SHOW, $GUI2)
                WM_MOVE($GUI1, 0, 0, 0)
            Case $AllValues
                If BitAND(GUICtrlRead($AllValues), $GUI_CHECKED) Then
                    _GUICtrlListBox_SelItemRange($List, 0, _GUICtrlListBox_GetCount($List) - 1, True)
                Else
                    _GUICtrlListBox_SelItemRange($List, 0, _GUICtrlListBox_GetCount($List) - 1, False)
                EndIf
            Case $BtnValues
                $str = ""
                $Items = _GUICtrlListBox_GetSelItemsText(ControlGetHandle($GUI2, "", $List))

                If $Items[0] = 0 Then
                    MsgBox(0, "��������", "������ �� �������")
                Else
                    For $i = 1 To $Items[0]
                        $str &= $Items[$i] & @CRLF
                    Next

                    MsgBox(0, "��������", $str)
                EndIf
            Case $BtnValues_ok
                $str = ""
                $Items = _GUICtrlListBox_GetSelItemsText(ControlGetHandle($GUI2, "", $List))

                If $Items[0] = 0 Then
                    MsgBox(0, "��������", "������ �� �������")
                Else
                    For $i = 1 To $Items[0]
                        $str &= $Items[$i] & @CRLF
                    Next

                    GUISetState(@SW_HIDE, $GUI2)
                EndIf
            Case $List
                GUICtrlSetState($AllValues, $GUI_UNCHECKED)
            Case $radio_3
                GUICtrlSetState($combo_1, $GUI_DISABLE)
                GUICtrlSetState($btn_radio_2, $GUI_DISABLE)
        EndSwitch
    WEnd
EndFunc

Func WM_MOVE($hWnd, $Msg, $wParam, $lParam)
    If Not BitAND(WinGetState($GUI2), 2) Then
        Return $GUI_RUNDEFMSG
    EndIf

    Local $aPos1 = WinGetPos($GUI1)
    Local $aPos2 = WinGetPos($GUI2)

    If $hWnd = $GUI1 Then
        WinMove($GUI2, "", $aPos1[0] + $aPos1[2] + 15, $aPos1[1])
    ElseIf $hWnd = $GUI2 Then
        WinMove($GUI1, "", $aPos2[0] - $aPos1[2] - 15, $aPos2[1])
    EndIf
EndFunc

