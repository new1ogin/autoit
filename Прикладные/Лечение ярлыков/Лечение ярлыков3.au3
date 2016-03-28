#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <ListViewConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
;~ #include <GuiListBox.au3> ; Для удаления

Global $iListView, $iListViewCheck, $hListViewCheck, $iCountCheck = 0, $iLbl

$UserDir = _PathSplitByRegExp(@UserProfileDir)
$UserDir = $UserDir[2]

$aDomains = _domainsList() ;Записывает в переменную список доменов верхнего уровня, для последующего поиска сайтов
$patchlnk = FileSelectFolder("Выберите папку для поиска ярлыков",'',4,$UserDir) ;Запрос на ввод директории для поиска
if $patchlnk = '' then exit
$aLnks = _FileSearch($patchlnk, "*.lnk")
$tempdir = @TempDir & '\'

dim $aListLnk[10000][8]
dim $otchet[1][9]
; цикл перебора ярлыков на поиск параметров и свойств
for $i=1 to $aLnks[0]
	$aLnkInfo = FileGetShortcut ( $aLnks[$i] )
	; если ярлык содержит параметры добавить его в массив отчет
	if not @error then
		$aListLnk[$i][0] =$aLnkInfo[0]
		$aListLnk[$i][1] =$aLnkInfo[1]
		$aListLnk[$i][2] =$aLnkInfo[2]
		$aListLnk[$i][3] =$aLnkInfo[3]
		$aListLnk[$i][4] =$aLnkInfo[4]
		$aListLnk[$i][5] =$aLnkInfo[5]
		$aListLnk[$i][6] =$aLnkInfo[6]
		$file = _PathSplitByRegExp($aLnks[$i])
		$aListLnk[$i][7] = $file[5]
		if $aLnkInfo[2] <> '' Then
			$otchet[Ubound($otchet)-1][0] = $aLnkInfo[0]
			$otchet[Ubound($otchet)-1][1] = $aLnkInfo[1]
			$otchet[Ubound($otchet)-1][2] = $aLnkInfo[2]
			$otchet[Ubound($otchet)-1][3] = $aLnkInfo[3]
			$otchet[Ubound($otchet)-1][4] = $aLnkInfo[4]
			$otchet[Ubound($otchet)-1][5] = $aLnkInfo[5]
			$otchet[Ubound($otchet)-1][6] = $aLnkInfo[6]
			$otchet[Ubound($otchet)-1][7] = $file[5]
			$otchet[Ubound($otchet)-1][8] = $aLnks[$i]
			ReDim $otchet[Ubound($otchet)+1][9]
		EndIf
	Else
		msgbox(0, " Ошибка", "Из ярлыка "&$aLnks[$i]&" не удалось получить информацию")
	EndIf
Next
_ArrayDelete($otchet,Ubound($otchet)-1) ;коррекция массива

Dim $deletepar[1]
dim $aChecked[Ubound($otchet)]
$GuiWidth = 650
; создание формы для выбора действий
$hGUI = GUICreate("ListView", $GuiWidth, 600,-1,-1,$WS_OVERLAPPEDWINDOW)
;~ $iListView = GUICtrlCreateListView("|Имя файла|Путь к файлу|Параметры запуска", 5, 5, 640, 550, -1, BitOR($WS_EX_CLIENTEDGE))
$iListView = GUICtrlCreateListView('', 5, 5, 640, 550, -1)
_GUICtrlListView_SetExtendedListViewStyle($iListView, BitOR($LVS_EX_FULLROWSELECT + $WS_EX_CLIENTEDGE, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
;добовление колонок
_GUICtrlListView_AddColumn($iListView, '', Ubound($otchet))
_GUICtrlListView_AddColumn($iListView, 'Имя файла', Ubound($otchet))
_GUICtrlListView_AddColumn($iListView, 'Путь к файлу', Ubound($otchet))
_GUICtrlListView_AddColumn($iListView, 'Параметры запуска', Ubound($otchet))
;создание и вывод содержание табоицы
dim $aItems[Ubound($otchet)][4]
For $i = 0 To UBound($aItems) - 1
	$JustFileName = _PathSplitByRegExp($otchet[$i][0])
	if not @error then
		$JustFileName = $JustFileName[6]
	Else
		$JustFileName = ''
	EndIf
	$aItems[$i][1] = $JustFileName
	$aItems[$i][2] = $otchet[$i][0]
	$aItems[$i][3] = $otchet[$i][2]
Next
_GUICtrlListView_AddArray($iListView, $aItems)
; установка ширины колонки
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 0, 25)
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 1, 100)
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 2, 250)
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 3, 250)
;добовление кнопок и показ формв
GUICtrlCreateDummy ( ) ;фикс бага ))
$button = GUICtrlCreateButton("Отчистить ярлыки", $GuiWidth/2-60, 570, -1, 25)
GUISetState()
GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY')
; цикл ожидания нажатия на кнопки или выхода
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			exit
		Case $button
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $button = ' & $button & @CRLF) ;### Debug Console
;~ 			_ArrayDisplay($aChecked)
			for $i=0 to Ubound($otchet)-1
				if $aChecked[$i] = 1 Then
					$deletepar[Ubound($deletepar)-1] = $i
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $i = ' & $i & @CRLF) ;### Debug Console
					ReDim $deletepar[Ubound($deletepar)+1]
				EndIf
			Next
;~ 			$delList = _deletepar($deletepar, $otchet)
;~ 			 For $i=0 to Ubound($delList)-1
;~ 				 if $delList[$i] <> '' then
;~ 					GUICtrlSendMsg($iListView, $LVM_DELETEITEM, $delList[$i], 0)
;~ 				EndIf
;~ 			 Next

	EndSwitch
WEnd

;функция изменения цвета строк
Func _SetColorMarker($_tCustDraw, $_iItem)
    $sCellText = _GUICtrlListView_GetItemText($iListView, $_iItem, 1)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $sCellText = _GUICtrlListView_GetItemText($iListView, $_iItem, 2)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $sCellText = _GUICtrlListView_GetItemText($iListView, $_iItem, 3)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    If $sCellText > 50 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF) ;### Debug Console
        DllStructSetData($_tCustDraw, 'clrTextBk', _Color_Convert_RGB2BGR(0xFFFFFF)) ; Text Backgroudn Color White
        DllStructSetData($_tCustDraw, 'clrText', _Color_Convert_RGB2BGR(0x0000FF)) ; Text Color Blue
    Else
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF) ;### Debug Console
        DllStructSetData($_tCustDraw, 'clrTextBk', _Color_Convert_RGB2BGR(0xFFFFFF)) ; Text Backgroudn Color White
        DllStructSetData($_tCustDraw, 'clrText', _Color_Convert_RGB2BGR(0xFF0000)) ; Text Color Red
    EndIf
EndFunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

    Local $tInfo, $iIndex, $iIndexCh
	;для раскраски текста
	Local $hWndFrom, $iCode, $tNMHDR, $tInfo

    Local $hListView = $iListView
    If Not IsHWnd($hListView) Then $hListView = GUICtrlGetHandle($hListView)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ilParam = ' & $ilParam & @CRLF ) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iwParam = ' & $iwParam & @CRLF ) ;### Debug Console
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
        If $iDrawStage = $CDDS_PREPAINT Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $CDRF_NOTIFYITEMDRAW = ' & $CDRF_NOTIFYITEMDRAW & @CRLF) ;### Debug Console
			Return $CDRF_NOTIFYITEMDRAW
		EndIf
        If $iDrawStage = $CDDS_ITEMPREPAINT Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $CDRF_NOTIFYSUBITEMDRAW = ' & $CDRF_NOTIFYSUBITEMDRAW & @CRLF) ;### Debug Console
			Return $CDRF_NOTIFYSUBITEMDRAW		 ; request drawing each cell separately
		EndIf
        $iItem    = DllStructGetData($tCustDraw, "ItemSpec")
        $iSubitem = DllStructGetData($tCustDraw, "SubItem")

        If $iItem > _GUICtrlListView_GetItemCount($hWndFrom) Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GUICtrlListView_GetColumnCount($hWndFrom) = ' & _GUICtrlListView_GetColumnCount($hWndFrom) & @CRLF) ;### Debug Console
			Return 0
		EndIf
        If $iSubitem > _GUICtrlListView_GetColumnCount($hWndFrom) Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GUICtrlListView_GetColumnCount($hWndFrom) = ' & _GUICtrlListView_GetColumnCount($hWndFrom) & @CRLF) ;### Debug Console
			Return 0
		EndIf

        _SetColorMarker($tCustDraw, $iItem)
    EndIf

    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
    Switch DllStructGetData($tInfo, 'IDFrom')
        Case $iListView
            Switch DllStructGetData($tInfo, 'Code')
                Case $LVN_ITEMCHANGED
                    Switch DllStructGetData($tInfo, 'NewState')
                        Case $LVM_FIRST
                            $iCountCheck -= 1
                            $iIndex = DllStructGetData($tInfo, 'Index')
							ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iIndex = ' & $iIndex & @CRLF) ;### Debug Console
							$aChecked[$iIndex] = 0
                            GUICtrlSetData($iLbl, 'Checked: ' & $iCountCheck)
                        Case $LVM_FIRST * 2
                            $iCountCheck += 1
                            $iIndex = DllStructGetData($tInfo, 'Index')
							ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iIndex = ' & $iIndex & @CRLF) ;### Debug Console
							$aChecked[$iIndex] = 1
                            GUICtrlSetData($iLbl, 'Checked: ' & $iCountCheck)
                    EndSwitch
            EndSwitch
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_NOTIFY




Func _Color_Convert_RGB2BGR($_iColor)
    Return BitAND(BitShift(String(Binary($_iColor)), 8), 0xFFFFFF)
EndFunc   ;==>_Color_Convert_RGB2BGR

Func _deletepar($deletepar, $otchet)
	dim $result[Ubound($deletepar)]
	For $i=0 to Ubound($deletepar) - 2
;~ 		MsgBox(0,'',$otchet[$deletepar[$i]][0])
		$t1 = FileCreateShortcut($otchet[$deletepar[$i]][0], $tempdir & $otchet[$deletepar[$i]][7], $otchet[$deletepar[$i]][1], '', $otchet[$deletepar[$i]][3], $otchet[$deletepar[$i]][4], $otchet[$deletepar[$i]][5], $otchet[$deletepar[$i]][6])
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF) ;### Debug Console
		$t15 = FileDelete($otchet[$deletepar[$i]][8])
		if $t15 = 0 Then msgbox(0," Ошибка","Файл "&$otchet[$deletepar[$i]][0]&", не удалось удалить.")
		$t2 = FileMove($tempdir & $otchet[$deletepar[$i]][7], $otchet[$deletepar[$i]][8], 1)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t2 = ' & $t2 & @CRLF) ;### Debug Console
		if $t1+$t15+$t2 = 3 then $result[$i] = $deletepar[$i]
	Next
	return $result
EndFunc


;$iFlag = 0 - Файлы и папки (по умолчанию)
;$iFlag = 1 - Только файлы
;$iFlag = 2 - Только папки
Func _FileSearch($sPath, $sFileMask, $iFlag = 0)
    Local $sOutBin, $sOut, $aOut, $sRead, $hDir, $sAttrib

    Switch $iFlag
        Case 1
            $sAttrib = ' /A-D'
        Case 2
            $sAttrib = ' /AD'
        Case Else
            $sAttrib = ' /A'
    EndSwitch

    $sOut = StringToBinary('0' & @CRLF, 2)
    $aMasks = StringSplit($sFileMask, ';')

    For $i = 1 To $aMasks[0]
        $hDir = Run(@ComSpec & ' /U /C DIR "' & $sPath & '\' & $aMasks[$i] & '" /S /B' & $sAttrib, @SystemDir, @SW_HIDE, 6)

        While 1
            $sRead = StdoutRead($hDir, False, True)

            If @error Then
                ExitLoop
            EndIf

            If $sRead <> "" Then
                $sOut &= $sRead
            EndIf
        Wend
    Next

    $aOut = StringRegExp(BinaryToString($sOut, 2), '[^\r\n]+', 3)

    If @error Then
        Return SetError(1)
    EndIf

    $aOut[0] = UBound($aOut)-1
    Return $aOut
EndFunc

Func _PathSplitByRegExp($sPath,$pDelim = '')
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"

    $aRetArray[0] = $sPath ;Full path
    $aRetArray[1] = StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
    $aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
    $aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
    $aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
    $aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
    $aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
    $aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file

    Return $aRetArray
EndFunc

Func _domainsList()
	$domains = 'aero|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|xxx|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cs|cu|cv|cx|cy|cz|dd|de|dj|dk|dm|do|dz|ec|ee|eg|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|рф|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sv|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|za|zm|zw|xn--lgbbat1ad8j|xn--fiqs8s|xn--fiqz9s|xn--wgbh1c|xn--j6w193g|xn--h2brj9c|xn--mgbbh1a71e|xn--fpcrj9c3d|xn--gecrj9c|xn--s9brj9c|xn--xkc2dl3a5ee0h|xn--45brj9c|xn--mgba3a4f16a|xn--mgbayh7gpa|xn--mgbc0a9azcg|xn--ygbi2ammx|xn--wgbl6a|xn--p1ai|xn--mgberp4a5d4ar|xn--90a3ac|xn--yfro4i67o|xn--clchc0ea0b2g2a9gcd|xn--3e0b707e|xn--fzc2c9e2c|xn--xkc2al3hye2a|xn--ogbpf8fl|xn--kprw13d|xn--kpry57d|xn--o3cw4h|xn--pgbs0dh|xn--j1amh|xn--mgbaam7a8h|срб|укр|xn--54b7fta0cc|xn--90ae|xn--node|xn--4dbrk0ce|xn--mgb9awbf|xn--mgbai9azgqp6j|xn--mgb2ddes|бг|xn--kgbechtv|xn--hgbk6aj7f53bba|xn--0zwm56d|xn--g6w251d|xn--80akhbyknj4f|xn--11b5bs3a9aj6g|xn--jxalpdlp|xn--9t4b11yi5a|xn--deba0ad|xn--zckzah|xn--hlcj6aya9esc7a'
	$aDomains = StringSplit($domains,'|')
	return $aDomains
EndFunc
