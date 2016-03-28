#NoTrayIcon
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Table.au3>

Dim $aTableName[4] = ['Наташа', 'Света', 'Ира', 'Виктория'] ; имена


$hColor1 = 0x000000 ; цвет фона окна
$hColor2 = 0xFFFFFF ; цвет фона таблицы
$hColor3 = 0xC80E0E ; цвет шрифта имен
$hColor4 = 0x9B36FF ; цвет шрифта конкурсов
$hColor5 = 0xFF0000 ; цвет текста таблицы


$hParent = GUICreate('Управление', 700, 350, -1, -1, -1)
$Label1 = GUICtrlCreateLabel('Конкурс 1', 36, 24, 101, 40)
GUICtrlSetFont(-1, 12, 400, Default, 'Comic Sans MS')
GUICtrlCreateLabel($aTableName[0], 36, 74, 101, 40)
GUICtrlCreateLabel($aTableName[1], 136, 74, 101, 40)
GUICtrlCreateLabel($aTableName[2], 236, 74, 101, 40)
GUICtrlCreateLabel($aTableName[3], 336, 74, 101, 40)

$Input1 = GUICtrlCreateInput('', 36, 94, 100, 44, 0x2000)
GUICtrlSetFont(-1, 15, 400, Default, 'Comic Sans MS')
GUICtrlSetLimit(-1, 5)
$Input2 = GUICtrlCreateInput('', 136, 94, 100, 44, 0x2000)
GUICtrlSetFont(-1, 15, 400, Default, 'Comic Sans MS')
GUICtrlSetLimit(-1, 5)
$Input3 = GUICtrlCreateInput('', 236, 94, 100, 44, 0x2000)
GUICtrlSetFont(-1, 15, 400, Default, 'Comic Sans MS')
GUICtrlSetLimit(-1, 5)
$Input4 = GUICtrlCreateInput('', 336, 94, 100, 44, 0x2000)
GUICtrlSetFont(-1, 15, 400, Default, 'Comic Sans MS')
GUICtrlSetLimit(-1, 5)
$check1 = GUICtrlCreateCheckbox('Фиксировать и отправить', 460, 100, 220, 20)


$Label2 = GUICtrlCreateLabel('Конкурс 2', 36, 144, 101, 40)
GUICtrlSetFont(-1, 12, 400, Default, 'Comic Sans MS')

GUICtrlCreateLabel($aTableName[0], 36, 194, 101, 40)
GUICtrlCreateLabel($aTableName[1], 136, 194, 101, 40)
GUICtrlCreateLabel($aTableName[2], 236, 194, 101, 40)
GUICtrlCreateLabel($aTableName[3], 336, 194, 101, 40)
$Input5 = GUICtrlCreateInput('', 36, 214, 100, 44, 0x2000)
GUICtrlSetFont(-1, 15, 400, Default, 'Comic Sans MS')
GUICtrlSetLimit(-1, 5)
$Input6 = GUICtrlCreateInput('', 136, 214, 100, 44, 0x2000)
GUICtrlSetFont(-1, 15, 400, Default, 'Comic Sans MS')
GUICtrlSetLimit(-1, 5)
$Input7 = GUICtrlCreateInput('', 236, 214, 100, 44, 0x2000)
GUICtrlSetFont(-1, 15, 400, Default, 'Comic Sans MS')
GUICtrlSetLimit(-1, 5)
$Input8 = GUICtrlCreateInput('', 336, 214, 100, 44, 0x2000)
GUICtrlSetFont(-1, 15, 400, Default, 'Comic Sans MS')
GUICtrlSetLimit(-1, 5)
$check2 = GUICtrlCreateCheckbox('Фиксировать и отправить', 460, 220, 220, 20)
GUIRegisterMsg($WM_COMMAND, '_WM_COMMAND')
GUISetState(@SW_SHOW, $hParent)


$hChild = GUICreate('Окно1', 1366, 768, 0, 0, $WS_POPUP)
GUISetBkColor($hColor1)

$nClose_Button = GUICtrlCreateButton('X', 1366 - 19, 3, 10, 10)
GUICtrlSetColor(-1, 0xFFFFFF)

GUICtrlSetBkColor(-1, 0xFF0000)
GUICtrlCreateLabel('', 0, 0, 1366, 15, $WS_CLIPSIBLINGS, $GUI_WS_EX_PARENTDRAG)
GUICtrlSetBkColor(-1, $hColor1)
GUISetState(@SW_SHOW, $hChild)

GUICtrlCreateLabel('Конкурс', 12, 25, 1340, 50, 0x01)
GUICtrlSetBkColor(-1, 0xD5DCEE)
GUICtrlSetFont(-1, 20, 400, Default, 'Comic Sans MS')
$table = _GUICtrlTable_Create(30, 80, 232, 165, 4, 5, 2)
_GUICtrlTable_Set_ColumnWidth($table, 1, 370)
;_GUICtrlTable_Set_Text_Cell($table, 1, 1, '')

_GUICtrlTable_Set_Text_Cell($table, 2, 1, 'Конкурс 1')
_GUICtrlTable_Set_Text_Cell($table, 3, 1, 'Конкурс 2')
;_GUICtrlTable_Set_Text_Cell($table, 4, 1, 'Конкурс 3')
_GUICtrlTable_Set_Text_Cell($table, 4, 1, 'Средний балл')

_GUICtrlTable_Set_Text_Cell($table, 1, 2, $aTableName[0])
_GUICtrlTable_Set_Text_Cell($table, 1, 3, $aTableName[1])
_GUICtrlTable_Set_Text_Cell($table, 1, 4, $aTableName[2])
_GUICtrlTable_Set_Text_Cell($table, 1, 5, $aTableName[3])
_GUICtrlTable_Set_TextColor_All($table, $hColor5)
_GUICtrlTable_Set_TextColor_Column($table, 1, $hColor3)
_GUICtrlTable_Set_TextColor_Row($table, 1, $hColor4)
_GUICtrlTable_Set_Justify_Row($table, 0, 0)
_GUICtrlTable_Set_Justify_All($table, 1, 1)
;_GUICtrlTable_Set_TextFont_Row($table, 2, 30, 800)
_GUICtrlTable_Set_TextFont_All($table, 55, 400, 0, 'MS Sans Serif')
_GUICtrlTable_Set_CellColor_All($table, $hColor2)
WinSetOnTop($hParent, '', 1)


While 1
    $aMsg = GUIGetMsg(1)
    Switch $aMsg[1]
        Case $hParent
            Switch $aMsg[0]
                Case $GUI_EVENT_CLOSE
                    Exit
                Case $check1
                    If GUICtrlRead($check1) = 1 Then
                        $sTring1 = GUICtrlRead($Input1) & GUICtrlRead($Input2) & GUICtrlRead($Input3) & GUICtrlRead($Input4)
                        If StringLen($sTring1) = 20 Then
                            $aCon1 = StringSplit($sTring1, '')
                            _GUICtrlTable_Set_Text_Cell($table, 2, 2, Round(($aCon1[1] + $aCon1[2] + $aCon1[3] + $aCon1[4] + $aCon1[5]) / 5, 1))
                            _GUICtrlTable_Set_Text_Cell($table, 2, 3, Round(($aCon1[6] + $aCon1[7] + $aCon1[8] + $aCon1[9] + $aCon1[10]) / 5, 1))
                            _GUICtrlTable_Set_Text_Cell($table, 2, 4, Round(($aCon1[11] + $aCon1[12] + $aCon1[13] + $aCon1[14] + $aCon1[15]) / 5, 1))
                            _GUICtrlTable_Set_Text_Cell($table, 2, 5, Round(($aCon1[16] + $aCon1[17] + $aCon1[18] + $aCon1[19] + $aCon1[20]) / 5, 1))
                            GUICtrlSetState($Input1, $GUI_DISABLE)
                            GUICtrlSetState($Input2, $GUI_DISABLE)
                            GUICtrlSetState($Input3, $GUI_DISABLE)
                            GUICtrlSetState($Input4, $GUI_DISABLE)
                            
                            $sum1 = _GUICtrlTable_Get_Text_Cell($table, 2, 2) + _GUICtrlTable_Get_Text_Cell($table, 3, 2)
                            $sum2 = _GUICtrlTable_Get_Text_Cell($table, 2, 3) + _GUICtrlTable_Get_Text_Cell($table, 3, 3)
                            $sum3 = _GUICtrlTable_Get_Text_Cell($table, 2, 4) + _GUICtrlTable_Get_Text_Cell($table, 3, 4)
                            $sum4 = _GUICtrlTable_Get_Text_Cell($table, 2, 5) + _GUICtrlTable_Get_Text_Cell($table, 3, 5)
                            If _GUICtrlTable_Get_Text_Cell($table, 2, 2) = '' Or _GUICtrlTable_Get_Text_Cell($table, 3, 2) = '' Then
                                _GUICtrlTable_Set_Text_Cell($table, 4, 2, $sum1)
                                _GUICtrlTable_Set_Text_Cell($table, 4, 3, $sum2)
                                _GUICtrlTable_Set_Text_Cell($table, 4, 4, $sum3)
                                _GUICtrlTable_Set_Text_Cell($table, 4, 5, $sum4)
                            Else
                                _GUICtrlTable_Set_Text_Cell($table, 4, 2, Round(($sum1 / 2), 1))
                                _GUICtrlTable_Set_Text_Cell($table, 4, 3, Round(($sum2 / 2), 1))
                                _GUICtrlTable_Set_Text_Cell($table, 4, 4, Round(($sum3 / 2), 1))
                                _GUICtrlTable_Set_Text_Cell($table, 4, 5, Round(($sum4 / 2), 1))
                            EndIf
                            
                        Else
                            GUICtrlSetState($check1, $GUI_UNCHECKED)
                            MsgBox(262144, 'Ошибка', 'Проверьте введенные данные!')
                        EndIf
                    Else
                        GUICtrlSetState($Input1, $GUI_ENABLE)
                        GUICtrlSetState($Input2, $GUI_ENABLE)
                        GUICtrlSetState($Input3, $GUI_ENABLE)
                        GUICtrlSetState($Input4, $GUI_ENABLE)
                    EndIf
                Case $check2
                    If GUICtrlRead($check2) = 1 Then
                        $sTring2 = GUICtrlRead($Input5) & GUICtrlRead($Input6) & GUICtrlRead($Input7) & GUICtrlRead($Input8)
                        If StringLen($sTring2) = 20 Then
                            $aCon2 = StringSplit($sTring2, '')
                            _GUICtrlTable_Set_Text_Cell($table, 3, 2, Round(($aCon2[1] + $aCon2[2] + $aCon2[3] + $aCon2[4] + $aCon2[5]) / 5, 1))
                            _GUICtrlTable_Set_Text_Cell($table, 3, 3, Round(($aCon2[6] + $aCon2[7] + $aCon2[8] + $aCon2[9] + $aCon2[10]) / 5, 1))
                            _GUICtrlTable_Set_Text_Cell($table, 3, 4, Round(($aCon2[11] + $aCon2[12] + $aCon2[13] + $aCon2[14] + $aCon2[15]) / 5, 1))
                            _GUICtrlTable_Set_Text_Cell($table, 3, 5, Round(($aCon2[16] + $aCon2[17] + $aCon2[18] + $aCon2[19] + $aCon2[20]) / 5, 1))
                            GUICtrlSetState($Input5, $GUI_DISABLE)
                            GUICtrlSetState($Input6, $GUI_DISABLE)
                            GUICtrlSetState($Input7, $GUI_DISABLE)
                            GUICtrlSetState($Input8, $GUI_DISABLE)
                            $sum1 = _GUICtrlTable_Get_Text_Cell($table, 2, 2) + _GUICtrlTable_Get_Text_Cell($table, 3, 2)
                            $sum2 = _GUICtrlTable_Get_Text_Cell($table, 2, 3) + _GUICtrlTable_Get_Text_Cell($table, 3, 3)
                            $sum3 = _GUICtrlTable_Get_Text_Cell($table, 2, 4) + _GUICtrlTable_Get_Text_Cell($table, 3, 4)
                            $sum4 = _GUICtrlTable_Get_Text_Cell($table, 2, 5) + _GUICtrlTable_Get_Text_Cell($table, 3, 5)
                            If _GUICtrlTable_Get_Text_Cell($table, 2, 2) = '' Or _GUICtrlTable_Get_Text_Cell($table, 3, 2) = '' Then
                                _GUICtrlTable_Set_Text_Cell($table, 4, 2, $sum1)
                                _GUICtrlTable_Set_Text_Cell($table, 4, 3, $sum2)
                                _GUICtrlTable_Set_Text_Cell($table, 4, 4, $sum3)
                                _GUICtrlTable_Set_Text_Cell($table, 4, 5, $sum4)
                            Else
                                _GUICtrlTable_Set_Text_Cell($table, 4, 2, Round(($sum1 / 2), 1))
                                _GUICtrlTable_Set_Text_Cell($table, 4, 3, Round(($sum2 / 2), 1))
                                _GUICtrlTable_Set_Text_Cell($table, 4, 4, Round(($sum3 / 2), 1))
                                _GUICtrlTable_Set_Text_Cell($table, 4, 5, Round(($sum4 / 2), 1))
                            EndIf

                        Else
                            GUICtrlSetState($check2, $GUI_UNCHECKED)
                            MsgBox(262144, 'Ошибка', 'Проверьте введенные данные!')
                        EndIf
                    Else
                        GUICtrlSetState($Input5, $GUI_ENABLE)
                        GUICtrlSetState($Input6, $GUI_ENABLE)
                        GUICtrlSetState($Input7, $GUI_ENABLE)
                        GUICtrlSetState($Input8, $GUI_ENABLE)
                    EndIf
            EndSwitch
        Case $hChild
            Switch $aMsg[0]
                Case $nClose_Button
                    GUISetState(@SW_HIDE, $hChild)
            EndSwitch
    EndSwitch
WEnd

Func _WM_COMMAND($hWnd, $iMsg, $wParam, $lParam)
    Switch BitAND($wParam, 0xFFFF)
        Case $Input1 Or $Input2 Or $Input3 Or $Input4 Or $Input5 Or $Input6 Or $Input6 Or $Input7 Or $Input8
            GUICtrlSetData($Input1, StringRegExpReplace(GUICtrlRead($Input1), '6|7|8|9|0', ''))
            GUICtrlSetData($Input2, StringRegExpReplace(GUICtrlRead($Input2), '6|7|8|9|0', ''))
            GUICtrlSetData($Input3, StringRegExpReplace(GUICtrlRead($Input3), '6|7|8|9|0', ''))
            GUICtrlSetData($Input4, StringRegExpReplace(GUICtrlRead($Input4), '6|7|8|9|0', ''))
            GUICtrlSetData($Input5, StringRegExpReplace(GUICtrlRead($Input5), '6|7|8|9|0', ''))
            GUICtrlSetData($Input6, StringRegExpReplace(GUICtrlRead($Input6), '6|7|8|9|0', ''))
            GUICtrlSetData($Input7, StringRegExpReplace(GUICtrlRead($Input7), '6|7|8|9|0', ''))
            GUICtrlSetData($Input8, StringRegExpReplace(GUICtrlRead($Input8), '6|7|8|9|0', ''))
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>_WM_COMMAND
 
