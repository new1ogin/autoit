#include <Array.au3>
#include <ListViewConstants.au3>
#include <GUIConstantsEx.au3>
#include <GuiListView.au3>
#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
;~ #include <GuiListBox.au3> ; Для удаления
$Timerinit = TimerInit()
Global $iListView, $iListViewCheck, $hListViewCheck, $iCountCheck = 0, $iLbl
$SkipSysFiles = 1
$UserDir = _PathSplitByRegExp(@UserProfileDir)
$UserDir = $UserDir[2]

$aDomains = _LoadArrays(0) ;Записывает в переменную список доменов верхнего уровня, для последующего поиска сайтов
$aBrowsers = _LoadArrays(1)
;~ $aSkipFiles = _LoadArrays(2)
;~ _ArrayDisplay($aBrowsers)
$patchlnk = FileSelectFolder("Выберите папку для поиска ярлыков",'',4,$UserDir) ;Запрос на ввод директории для поиска
if $patchlnk = '' then exit
;~ ToolTip("Дождитесь окончания поиска файлов, в зависимости от размера выбранной папки это может занять продолжительное время")
$hWndGUI =  _Message("Дождитесь окончания поиска файлов, в зависимости от размера выбранной папки это может занять продолжительное время")
$aLnks = _FileSearch($patchlnk, "*.lnk")
GUIDelete($hWndGUI) ;Удаление подсказки
$TextMessage = "Обработка"
$hWndGUI =  _Message($TextMessage)
$Input = @extended
$tempdir = @TempDir & '\'
Tooltip(27 & ' Время работы = ' & TimerDiff($Timerinit) & @CRLF ) ;### Debug Console
ToolTip('Ubound($aLnks) = ' & $aLnks[0] & @CRLF ) ;### Debug Console
;Отчистка Полученых путей файлов
For $c=1 to $aLnks[0]
	$aLnks[$c] = _ClearPatch($aLnks[$c])
;~ 	ToolTip(' = ' & $c & @CRLF ) ;### Debug Console
Next
ToolTip(34 & ' Время работы = ' & TimerDiff($Timerinit) & @CRLF ) ;### Debug Console
;Отсортировать Массив и оставить только уникальные значения
_ArraySort($aLnks,1,1)
Dim $aLnksT[Ubound($aLnks)]
For $c=1 to Ubound($aLnks)-1
	if $aLnks[$c] <> $aLnks[$c-1] Then
		$aLnksT[$c] = $aLnks[$c]
	Endif
Next
$aLnksT = _ArrayClearEmpty($aLnksT)
$aLnks = $aLnksT
$aLnksT = ''

ToolTip(36 & ' Время работы = ' & TimerDiff($Timerinit) & @CRLF ) ;### Debug Console
dim $otchet[1][12]
$aLnks[0] = Ubound($aLnks)-1
;~ _ArrayDisplay($aLnks)
; цикл перебора ярлыков на поиск параметров и свойств
for $i=1 to $aLnks[0]
	$aLnkInfo = FileGetShortcut ( $aLnks[$i] )
;~ 	if $i=219 then _ArrayDisplay($aLnkInfo)
	; если ярлык содержит параметры добавить его в массив отчет
	if not @error Then
	if $SkipSysFiles=0 or StringInStr($aLnkInfo[0],@WindowsDir)=0 then ;Если Файл не системный
		$Redim = 0
		;Если ярлык не находиться в последних документах
		if not StringInStr($aLnks[$i],"Recent") then
			$TimerBrowserSearch = Timerinit()
			;поиск на соответствие ярлыку какому-нибудь браузеру
			For $b=0 to Ubound($aBrowsers)-1
				;Если браузер то выделить
				if StringRegExp($aLnkInfo[0],"(?i)"&$aBrowsers[$b]) or StringRegExp($aLnkInfo[3],"(?i)"&$aBrowsers[$b]) Then
;~ 					if $i=219 then _ArrayDisplay($aLnkInfo)
					$aTempFile = _PathSplitByRegExp($aLnkInfo[0])
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aLnkInfo[0] = ' & $aLnkInfo[0] &' $i '& $i & @CRLF) ;### Debug Console
;~ 					ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $aLnkInfo[0] = ' & $aLnkInfo[0] & @CRLF ) ;### Debug Console
;~ 					ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $aLnkInfo[3] = ' & $aLnkInfo[3] & @CRLF ) ;### Debug Console
;~ 					ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $aLnks[$i] = ' & $aLnks[$i] & @CRLF ) ;### Debug Console
					$otchet[Ubound($otchet)-1][9] = 'Браузер (exe)'
					$otchet[Ubound($otchet)-1][10] = 0x660000
					;Если расширение файла не exe то указать это
					if $aTempFile[7] <> 'exe' Then
	;~ 					$otchet[Ubound($otchet)-1][10] = 0x990000
						$otchet[Ubound($otchet)-1][9] = StringRegExpReplace($otchet[Ubound($otchet)-1][9],"\(.*?\)","("&$aTempFile[7]&")")
						; Если расширение cmd, bat, url, lnk то выделить красным
						if $aTempFile[7] = 'cmd' or $aTempFile[7] = 'bat' or $aTempFile[7] = 'url' Then
							$otchet[Ubound($otchet)-1][10] = 0xFF0000
							$otchet[Ubound($otchet)-1][9] = StringRegExpReplace($otchet[Ubound($otchet)-1][9],".*?\(","Подмена Файла")
						EndIf
					EndIf
					$Redim = 1
				EndIf
			Next
			ToolTip(72 & ' $TimerBrowserSearch = ' & TimerDiff($TimerBrowserSearch) & @CRLF ) ;### Debug Console
		EndIf
		;Если у ярлыка есть параметры запуска
		if $aLnkInfo[2] <> '' or $Redim = 1 Then
			$otchet[Ubound($otchet)-1][0] = $aLnkInfo[0]
			$otchet[Ubound($otchet)-1][1] = $aLnkInfo[1]
			$otchet[Ubound($otchet)-1][2] = $aLnkInfo[2]
			$otchet[Ubound($otchet)-1][3] = $aLnkInfo[3]
			$otchet[Ubound($otchet)-1][4] = $aLnkInfo[4]
			$otchet[Ubound($otchet)-1][5] = $aLnkInfo[5]
			$otchet[Ubound($otchet)-1][6] = $aLnkInfo[6]
			$aFile = _PathSplitByRegExp($aLnks[$i])
			$otchet[Ubound($otchet)-1][7] = $aFile[5]
			$otchet[Ubound($otchet)-1][8] = $aLnks[$i]
			$otchet[Ubound($otchet)-1][11] = 0
			$aTempFile = _PathSplitByRegExp($aLnkInfo[0])
			if $Redim = 0 then
				if $aTempFile[7] = 'exe' Then
					$otchet[Ubound($otchet)-1][9] = '('&$aTempFile[7]&')'
				Else
					$otchet[Ubound($otchet)-1][9] = '('&$aTempFile[7]&')'
					$otchet[Ubound($otchet)-1][10] = 0x000099
				EndIf
			EndIf
			$Redim = 1
		EndIf
		If $Redim = 1 Then
			ReDim $otchet[Ubound($otchet)+1][12]
			ToolTip(99 & ' Время работы = ' & TimerDiff($Timerinit) & @CRLF ) ;### Debug Console
		EndIf

	EndIf
	Else
		msgbox(0, " Ошибка", "Из ярлыка "&$aLnks[$i]&" не удалось получить информацию")
	Endif
	GUICtrlSetData ( $Input, $TextMessage & ' ('&$i&'/'&$aLnks[0]&') ')
Next
_ArrayDelete($otchet,Ubound($otchet)-1) ;коррекция массива
_ArraySort($otchet)
;~ _ArrayDisplay($otchet)
;~ exit
ToolTip(110 & ' Время работы = ' & TimerDiff($Timerinit) & @CRLF ) ;### Debug Console
GUIDelete($hWndGUI) ;Удаление подсказки

Dim $deletepar[1]
dim $aChecked[Ubound($otchet)]
$GuiWidth = 650
; создание формы для выбора действий
$hGUI = GUICreate("ListView", $GuiWidth, 600,-1,-1,$WS_OVERLAPPEDWINDOW)
;~ $iListView = GUICtrlCreateListView("|Имя файла|Путь к файлу|Параметры запуска", 5, 5, 640, 550, -1, BitOR($WS_EX_CLIENTEDGE))
$iListView = GUICtrlCreateListView('', 5, 5, 640, 550, -1)
_GUICtrlListView_SetExtendedListViewStyle($iListView, BitOR($LVS_EX_FULLROWSELECT + $WS_EX_CLIENTEDGE, $LVS_EX_CHECKBOXES, $LVS_EX_GRIDLINES))
;добовление колонок
_GUICtrlListView_AddColumn($iListView, 'Кол-во', Ubound($otchet))
_GUICtrlListView_AddColumn($iListView, 'Тип', Ubound($otchet))
_GUICtrlListView_AddColumn($iListView, 'Имя файла', Ubound($otchet))
_GUICtrlListView_AddColumn($iListView, 'Путь к файлу', Ubound($otchet))
_GUICtrlListView_AddColumn($iListView, 'Параметры запуска', Ubound($otchet))
_GUICtrlListView_AddColumn($iListView, 'Место где находится ярлык', Ubound($otchet))
;создание и вывод содержание табоицы
dim $item[Ubound($otchet)]
Dim $deletepar[1]
Dim $test[1]
dim $quality[Ubound($otchet)]
dim $qOtchet[Ubound($otchet)+1][12]
For $i=0 to Ubound($otchet)-1
	For $s=0 to Ubound($otchet)-1
		if $quality[$s] = '' then
			$comp = 0
			For $q = 0 to 6
				if $i <> Ubound($otchet)-1 and $otchet[$i][$q] = $otchet[$s][$q] Then
					$comp += 1
				EndIf
			Next
			if $comp=7 then $quality[$s] = $i
		EndIf
	Next
Next
For $i=0 to Ubound($quality)-1
	For $s=0 to Ubound($quality)-1
		if $quality[$i]=$s then
			$otchet[$i][11] += 1
			for $o=0 to ubound($otchet,2)-1
				$qOtchet[$quality[$i]][$o] = $otchet[$i][$o]
			Next
		EndIf
	Next
Next



_ArrayDisplay($qOtchet)
;~ exit


For $i=0 to Ubound($otchet)-1
	;Сравнение одинаковых ярлыков НЕОБХОДИМО АБСОЛЮТНОЕ СРАВНЕНИЕ А НЕ ТОЛЬКО БЛИЖАЙШИХ
	$comp = 0
	For $q = 0 to 6
		if $i <> Ubound($otchet)-1 and $otchet[$i][$q] = $otchet[$i+1][$q] Then
			$comp +=1
;~ 		Elseif $i <> Ubound($otchet)-1 Then
;~ 			ConsoleWrite('@@ Debug(' & $q & ') : $otchet[$i][$q] = ' & $otchet[$i][$q] & @CRLF) ;### Debug Console
;~ 			ConsoleWrite('@@ Debug(' & $q & ') : $otchet[$i+1][$q] = ' & $otchet[$i+1][$q] & @CRLF) ;### Debug Console
		EndIf
	Next
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $comp = ' & $comp & @CRLF) ;### Debug Console
	if $comp = 7 Then
		$quality+=1
	Else
		$JustFileName = _PathSplitByRegExp($otchet[$i][0])
		if not @error then
			$JustFileName = $JustFileName[6]
		Else
			$JustFileName = ''
		EndIf
		$item[$i] = GUICtrlCreateListViewItem($quality&"|"&$otchet[$i][9]&"|"&$JustFileName&"|"&$otchet[$i][0]&"|"&$otchet[$i][2]&"|"&$otchet[$i][8], $iListView)
		if $otchet[$i][10] <> '' then
			GUICtrlSetColor( -1, $otchet[$i][10])
			if $otchet[$i][10] = 0xFF0000 then GUICtrlSetFont ( -1, 8.5 , 700 ) ;Жирный шрифт
		EndIf
		$quality=1
	EndIf
;~ 	_GUICtrlListView_SetItemChecked($ListView, $i)
;~ 	ToolTip('@@ Debug(' & @ScriptLineNumber & ') : _GUICtrlListView_GetItemChecked($ListView, $item[$i]) = ' & _GUICtrlListView_GetItemChecked($ListView, $item[$i]-1) & @CRLF ) ;### Debug Console
Next
; установка ширины колонки
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 0, 35)
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 1, 85)
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 2, 100)
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 3, 250)
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 4, 250)
GUICtrlSendMsg($iListView, $LVM_SETCOLUMNWIDTH, 5, -1)
;добовление кнопок и показ формв
GUICtrlCreateDummy ( ) ;фикс бага ))
$button = GUICtrlCreateButton("Отчистить ярлыки", $GuiWidth/2-60, 570, -1, 25)
$text1 = GUICtrlCreateLabel ( ChrW(9679) & " - Браузеры", 20, 557 ) ;149
GUICtrlSetColor( $text1, 0x660000)
$text2 = GUICtrlCreateLabel ( ChrW(9679) & " - Возможен подмен файла запуска", 20, 572, ($GuiWidth/2-60)-40)
GUICtrlSetColor( $text2, 0xFF0000)
GUICtrlSetFont ( -1, 8.5 , 700 ) ;Жирный шрифт
;~ $text3 = GUICtrlCreateLabel ( "Расширение файла не соответствует", 20, 585 )
;~ GUICtrlSetColor( $text3, 0x660000)
GUISetState()
GUIRegisterMsg($WM_NOTIFY, 'WM_NOTIFY')
ToolTip('')
; цикл ожидания нажатия на кнопки или выхода
While 1
	Switch GUIGetMsg()
		Case $GUI_EVENT_CLOSE
			exit
		Case $button
			ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $button = ' & $button & @CRLF) ;### Debug Console
;~ 			_ArrayDisplay($aChecked)
			for $i=0 to Ubound($otchet)-1
				if $aChecked[$i] = 1 Then
					$deletepar[Ubound($deletepar)-1] = $i
					ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $i = ' & $i & @CRLF) ;### Debug Console
					ReDim $deletepar[Ubound($deletepar)+1]
				EndIf
;~ 				$t1 = GUICtrlSetColor( $item[$i], 0xFF00FF)
;~ 				ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 &' $item[$i] = ' & $item[$i] & @CRLF ) ;### Debug Console

			Next
;~ 			$delList = _deletepar($deletepar, $otchet)
;~ 			 For $i=0 to Ubound($delList)-1
;~ 				 if $delList[$i] <> '' then
;~ 					GUICtrlSendMsg($iListView, $LVM_DELETEITEM, $delList[$i], 0)
;~ 				EndIf
;~ 			 Next

	EndSwitch
	sleep(10)
WEnd

;функция изменения цвета строк
Func _SetColorMarker($_tCustDraw, $_iItem)
    $sCellText = _GUICtrlListView_GetItemText($iListView, $_iItem, 1)
	ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF ) ;### Debug Console
    $sCellText = _GUICtrlListView_GetItemText($iListView, $_iItem, 2)
	ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF ) ;### Debug Console
    $sCellText = _GUICtrlListView_GetItemText($iListView, $_iItem, 3)
	ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF ) ;### Debug Console

    If $sCellText > 50 Then
		ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF) ;### Debug Console
        DllStructSetData($_tCustDraw, 'clrTextBk', _Color_Convert_RGB2BGR(0xFFFFFF)) ; Text Backgroudn Color White
        DllStructSetData($_tCustDraw, 'clrText', _Color_Convert_RGB2BGR(0x0000FF)) ; Text Color Blue
    Else
		ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $sCellText = ' & $sCellText & @CRLF) ;### Debug Console
        DllStructSetData($_tCustDraw, 'clrTextBk', _Color_Convert_RGB2BGR(0xFFFFFF)) ; Text Backgroudn Color White
        DllStructSetData($_tCustDraw, 'clrText', _Color_Convert_RGB2BGR(0xFF0000)) ; Text Color Red
    EndIf
EndFunc

Func WM_NOTIFY($hWnd, $iMsg, $iwParam, $ilParam)

    Local $tInfo, $iIndex, $iIndexCh

    $tInfo = DllStructCreate($tagNMITEMACTIVATE, $ilParam)
    Switch DllStructGetData($tInfo, 'IDFrom')
        Case $iListView
            Switch DllStructGetData($tInfo, 'Code')
                Case $LVN_ITEMCHANGED
                    Switch DllStructGetData($tInfo, 'NewState')
                        Case $LVM_FIRST
                            $iCountCheck -= 1
                            $iIndex = DllStructGetData($tInfo, 'Index')
							ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $iIndex = ' & $iIndex & @CRLF) ;### Debug Console
							$aChecked[$iIndex] = 0
                            GUICtrlSetData($iLbl, 'Checked: ' & $iCountCheck)
                        Case $LVM_FIRST * 2
                            $iCountCheck += 1
                            $iIndex = DllStructGetData($tInfo, 'Index')
							ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $iIndex = ' & $iIndex & @CRLF) ;### Debug Console
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
		ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF) ;### Debug Console
		$t15 = FileDelete($otchet[$deletepar[$i]][8])
		if $t15 = 0 Then msgbox(0," Ошибка","Файл "&$otchet[$deletepar[$i]][0]&", не удалось удалить.")
		$t2 = FileMove($tempdir & $otchet[$deletepar[$i]][7], $otchet[$deletepar[$i]][8], 1)
		ToolTip('@@ Debug(' & @ScriptLineNumber & ') : $t2 = ' & $t2 & @CRLF) ;### Debug Console
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
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, _PathSplitByRegExpReturn())

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return SetError(1, 0, _PathSplitByRegExpReturn())
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"

    $aRetArray[0] = $sPath ;Full path
    $aRetArray[1] = StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
	if @error then
		SetError (1)
		$aRetArray[1] = ''
	EndIf
    $aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
	if @error then
		SetError (1)
		$aRetArray[2] = ''
	EndIf
    $aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
	if @error then
		SetError (1)
		$aRetArray[3] = ''
	EndIf
    $aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
	if @error then
		SetError (1)
		$aRetArray[4] = ''
	EndIf
    $aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
	if @error then
		SetError (1)
		$aRetArray[5] = ''
	EndIf
    $aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
	if @error then
		SetError (1)
		$aRetArray[6] = ''
	EndIf
    $aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file
	if @error then
		SetError (1)
		$aRetArray[7] = ' '
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aRetArray[7] = ' & $aRetArray[7] & @CRLF) ;### Debug Console
	EndIf

    Return $aRetArray
EndFunc

Func _PathSplitByRegExpReturn()
	Local $aRetArray[8]
		$aRetArray[1] = ''
		$aRetArray[2] = ''
		$aRetArray[3] = ''
		$aRetArray[4] = ''
		$aRetArray[5] = ''
		$aRetArray[6] = ''
		$aRetArray[7] = ' '
    Return $aRetArray
EndFunc

Func _ArrayClearEmpty($a_Array, $i_SubItem = 0, $i_Start = 0)
    If Not IsArray($a_Array) Or UBound($a_Array, 0) > 2 Then Return SetError(1, 0, 0)

    Local $i_Index = -1
    Local $i_UBound_Row = UBound($a_Array, 1) - 1
    Local $i_UBound_Column = UBound($a_Array, 2) - 1

    If $i_UBound_Column = -1 Then $i_UBound_Column = 0
    If $i_SubItem > $i_UBound_Column Then $i_SubItem = 0
    If $i_Start < 0 Or $i_Start > $i_UBound_Row Then $i_Start = 0

    Switch $i_UBound_Column + 1
        Case 1
            Dim $a_TempArray[$i_UBound_Row + 1]
            If $i_Start Then
                For $i = 0 To $i_Start - 1
                    $a_TempArray[$i] = $a_Array[$i]
                Next
                $i_Index = $i_Start - 1
            EndIf
            For $i = $i_Start To $i_UBound_Row
                If String($a_Array[$i]) Then
                    $i_Index += 1
                    $a_TempArray[$i_Index] = $a_Array[$i]
                EndIf
            Next
            If $i_Index > -1 Then
                ReDim $a_TempArray[$i_Index + 1]
            Else
                Return SetError(2, 0, 0)
            EndIf
        Case 2
            Dim $a_TempArray[$i_UBound_Row + 1][$i_UBound_Column + 1]
            If $i_Start Then
                For $i = 0 To $i_Start - 1
                    For $j = 0 To $i_UBound_Column
                        $a_TempArray[$i][$j] = $a_Array[$i][$j]
                    Next
                Next
                $i_Index = $i_Start - 1
            EndIf
            For $i = $i_Start To $i_UBound_Row
                If String($a_Array[$i][$i_SubItem]) Then
                    $i_Index += 1
                    For $j = 0 To $i_UBound_Column
                        $a_TempArray[$i_Index][$j] = $a_Array[$i][$j]
                    Next
                EndIf
            Next
            If $i_Index > -1 Then
                ReDim $a_TempArray[$i_Index + 1][$i_UBound_Column + 1]
            Else
                Return SetError(2, 0, 0)
            EndIf
    EndSwitch
    Return SetError(0, $i_UBound_Row - $i_Index, $a_TempArray)
EndFunc   ;==>_ArrayClearEmpty

Func _Message($Message)
	$width = 400
	$height = 100
	$hWndGUI = GUICreate("Подсказка",$width,$height,Default,Default,$WS_POPUP,$WS_EX_TRANSPARENT)
	$Input = GUICtrlCreateLabel($Message, 20, 20, $width-20, $height-20, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	WinSetTrans($hWndGUI,"",500)
	GUISetState(@SW_SHOW)
	return SetError(0,$Input,$hWndGUI)
EndFunc

Func _ClearPatch($sText)
	$aClear = StringSplit($sText,'\')
	$searchWord = ''
	$i = 2
	while $i < $aClear[0]
		if $aClear[$i] = $aClear[$i-1] and $aClear[$i] = $aClear[$i+1] Then
			$searchWord = $aClear[$i]
			_ArrayDelete($aClear, $i-1)
			$aClear[0] -= 1
		EndIf
		if $aClear[$i] = $searchWord Then
			_ArrayDelete($aClear, $i)
			$aClear[0] -= 1
			$i -= 1
		Else
			$searchWord = ''
		EndIf
		$i += 1
	WEnd
	_ArrayDelete($aClear,0)
	$sText = _ArrayToString($aClear, '\')
	Return $sText
EndFunc

Func _LoadArrays($mod = 0)
	if $mod = 0 then
		dim $array[324] = ['aero', 'asia', 'biz', 'cat', 'com', 'coop', 'edu', 'gov', 'info', 'int', 'jobs', 'mil', 'mobi', 'museum', 'name', 'net', 'org', 'pro', 'tel', 'travel', 'xxx', 'ac', 'ad', 'ae', 'af', 'ag', 'ai', 'al', 'am', 'an', 'ao', 'aq', 'ar', 'as', 'at', 'au', 'aw', 'ax', 'az', 'ba', 'bb', 'bd', 'be', 'bf', 'bg', 'bh', 'bi', 'bj', 'bm', 'bn', 'bo', 'br', 'bs', 'bt', 'bv', 'bw', 'by', 'bz', 'ca', 'cc', 'cd', 'cf', 'cg', 'ch', 'ci', 'ck', 'cl', 'cm', 'cn', 'co', 'cr', 'cs', 'cu', 'cv', 'cx', 'cy', 'cz', 'dd', 'de', 'dj', 'dk', 'dm', 'do', 'dz', 'ec', 'ee', 'eg', 'er', 'es', 'et', 'eu', 'fi', 'fj', 'fk', 'fm', 'fo', 'fr', 'ga', 'gb', 'gd', 'ge', 'gf', 'gg', 'gh', 'gi', 'gl', 'gm', 'gn', 'gp', 'gq', 'gr', 'gs', 'gt', 'gu', 'gw', 'gy', 'hk', 'hm', 'hn', 'hr', 'ht', 'hu', 'id', 'ie', 'il', 'im', 'in', 'io', 'iq', 'ir', 'is', 'it', 'je', 'jm', 'jo', 'jp', 'ke', 'kg', 'kh', 'ki', 'km', 'kn', 'kp', 'kr', 'kw', 'ky', 'kz', 'la', 'lb', 'lc', 'li', 'lk', 'lr', 'ls', 'lt', 'lu', 'lv', 'ly', 'ma', 'mc', 'md', 'me', 'mg', 'mh', 'mk', 'ml', 'mm', 'mn', 'mo', 'mp', 'mq', 'mr', 'ms', 'mt', 'mu', 'mv', 'mw', 'mx', 'my', 'mz', 'na', 'nc', 'ne', 'nf', 'ng', 'ni', 'nl', 'no', 'np', 'nr', 'nu', 'nz', 'om', 'pa', 'pe', 'pf', 'pg', 'ph', 'pk', 'pl', 'pm', 'pn', 'pr', 'ps', 'pt', 'pw', 'py', 'qa', 're', 'ro', 'rs', 'ru', 'рф', 'rw', 'sa', 'sb', 'sc', 'sd', 'se', 'sg', 'sh', 'si', 'sj', 'sk', 'sl', 'sm', 'sn', 'so', 'sr', 'st', 'su', 'sv', 'sy', 'sz', 'tc', 'td', 'tf', 'tg', 'th', 'tj', 'tk', 'tl', 'tm', 'tn', 'to', 'tp', 'tr', 'tt', 'tv', 'tw', 'tz', 'ua', 'ug', 'uk', 'us', 'uy', 'uz', 'va', 'vc', 've', 'vg', 'vi', 'vn', 'vu', 'wf', 'ws', 'ye', 'yt', 'za', 'zm', 'zw', 'xn--lgbbat1ad8j', 'xn--fiqs8s', 'xn--fiqz9s', 'xn--wgbh1c', 'xn--j6w193g', 'xn--h2brj9c', 'xn--mgbbh1a71e', 'xn--fpcrj9c3d', 'xn--gecrj9c', 'xn--s9brj9c', 'xn--xkc2dl3a5ee0h', 'xn--45brj9c', 'xn--mgba3a4f16a', 'xn--mgbayh7gpa', 'xn--mgbc0a9azcg', 'xn--ygbi2ammx', 'xn--wgbl6a', 'xn--p1ai', 'xn--mgberp4a5d4ar', 'xn--90a3ac', 'xn--yfro4i67o', 'xn--clchc0ea0b2g2a9gcd', 'xn--3e0b707e', 'xn--fzc2c9e2c', 'xn--xkc2al3hye2a', 'xn--ogbpf8fl', 'xn--kprw13d', 'xn--kpry57d', 'xn--o3cw4h', 'xn--pgbs0dh', 'xn--j1amh', 'xn--mgbaam7a8h', 'срб', 'укр', 'xn--54b7fta0cc', 'xn--90ae', 'xn--node', 'xn--4dbrk0ce', 'xn--mgb9awbf', 'xn--mgbai9azgqp6j', 'xn--mgb2ddes', 'бг', 'xn--kgbechtv', 'xn--hgbk6aj7f53bba', 'xn--0zwm56d', 'xn--g6w251d', 'xn--80akhbyknj4f', 'xn--11b5bs3a9aj6g', 'xn--jxalpdlp', 'xn--9t4b11yi5a', 'xn--deba0ad', 'xn--zckzah', 'xn--hlcj6aya9esc7a']
;~ 		$aDomains = StringSplit($domains,'|')
	elseif $mod = 1 then
		dim $array[211] = ['Netscape Navigator', 'Netscape Communicator', 'Internet Explorer', '(?-i)Opera([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Mozilla Suite', 'Mozilla Firefox', 'Safari', 'Google Chrome', 'AGIS Explorer', 'Arlington Kiosk Browser', 'AM Browser', 'AOL Explorer', 'Avant Browser', 'Browzar', 'Lunascape', 'MaxBrowser', 'Maxthon 1', 'Maxthon 2', 'Maxthon 3', 'SlimBrowser', 'NetCaptor', 'Netscape Browser', 'Yahoo!', '(?-i)Yahoo([^0-9a-zA-ZА-яЁё_-]|\Z)', 'iRider', 'NeoPlanet', 'Smart Bro', 'Nano Browser', 'FastIE', 'Acoo browser', 'Nintendo DS Browser', 'Nintendo DSi Browser', 'Internet Channel', 'Opera Mobile', 'Opera Mini', 'Alefox', 'Aphrodite', 'BackArrow', 'Beonex Communicator', 'Camino', 'CompuServe', 'Conkeror', 'DocZilla', 'Epiphany', '(?-i)Flock([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Galeon', 'IceWeasel', 'K-Meleon', 'K-MeleonCCF', 'K-Ninja', 'Kazehakase', 'Madfox', 'ManyOne', 'Mozilla Application Suite', 'Orca Browser', 'Pale Moon', 'Salamander', 'SeaMonkey', 'Skipstone', 'Skyfire', 'Torpark', 'Nano Browser Gecko', 'ABrowse', '(?-i)Arora([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Atlantis', 'CoolNovo', 'Coowon', 'Chromium', 'Comodo Dragon', 'Dolphin Browser', 'Dooble', 'Iris Browser', 'Konqueror', 'Maxthon', 'Midori', 'Net Positive', 'Oiynsoft Web-Browser', 'OmniWeb', '(?-i)QtWeb([^0-9a-zA-ZА-яЁё_-]|\Z)', 'QupZilla', 'Rekonq', 'RockMelt', 'Shiira', 'SkyKruzer', 'SunriseBrowser', '(?-i)Swift([^0-9a-zA-ZА-яЁё_-]|\Z)', 'SRWare Iron', 'Web Browser for S60', 'WebPositive', 'HotJava', 'ICE Browser', 'Jazilla', 'JxBrowser', 'MozSwing', 'Warrior', 'WebRenderer', 'BrailleSurf', 'Browsezilla', 'Deck-It', 'Ghostzilla', 'Heatseek', 'Public Web Browser', 'Alis Tango', '(?-i)Abaco([^0-9a-zA-ZА-яЁё_-]|\Z)', '(?-i)Amaya([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Arachne', 'Ariadna', '(?-i)AWeb([^0-9a-zA-ZА-яЁё_-]|\Z)', 'BrowseX', 'Charon', 'Chimera', '(?-i)Dillo([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Deepnet Explorer', 'Deepnet Explorer - Web + P2P + News Browser', 'DeskBrowse', '(?-i)Emacs([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Espial Escape', 'Frostzone Navigators', 'Gazelle', 'Gollum browser', 'IBrowse', '(?-i)iCab([^0-9a-zA-ZА-яЁё_-]|\Z)', '(?-i)Kidz CD([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Krozilo', 'Links2', 'Links-hacked', 'Mothra', 'NetPositive', 'NetSurf', 'Off By One', 'Offline Downloader', 'Oiynsoft Explorer', 'Oregano', 'Planetweb', 'ProSyst mBrowser', 'PlayStation Portable web browser', 'Sleipnir', 'SphereXPlorer', '(?-i)SPIN([^0-9a-zA-ZА-яЁё_-]|\Z)', 'SuperBot', 'VMS Mosaic', 'Voyager', 'Website Extractor', 'Webster XL', 'X-Smiles', 'Fusion Media Explorer', '(?-i)Layar([^0-9a-zA-ZА-яЁё_-]|\Z)', '(?-i)Rota([^0-9a-zA-ZА-яЁё_-]|\Z)', 'e-Capsule Private Browser', '(?-i)ICab([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Spyglass', 'Tasman', 'Vallet', 'LeechCraft', '(?-i)Rezac([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Eric Bina', 'Mozilla Foundation', 'Mercurial Communications', '(?-i)LGPL([^0-9a-zA-ZА-яЁё_-]|\Z)', 'SeaMonkey Council', 'WorldWideWeb', 'Mozilla', 'Sunrise', '(?-i)CSS2([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Acoo Browser', '(?-i)Amigo([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Apple Safari', 'Goona Browser', 'GreenBrowser', 'Internet Surfboard', '(?-i)Kylo([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Microsoft Internet Explorer', 'Mozilla CometBird', 'Mozilla Flock', 'Mozilla SeaMonkey', '(?-i)Nuke([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Orbitum', 'PirateBrowser', 'PlayFree Browser', 'Polarity Browser', 'QIP Surf Browser', 'QtWeb Browser', 'Slepnir Browser', 'Sundance Browser', 'TheWorld', 'Tor Browser Bundle', 'Torch Browser', 'YandexBrowser', 'YRC Weblink', 'Netscape', 'Tor Bundle', 'Browser', '(?-i)Интернет([^0-9a-zA-ZА-яЁё_-]|\Z)', '(?-i)Хром([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Одноклассники', 'одноклассники', 'Рамблер-Браузер', 'рамблер-браузер', 'Рамблер Нихром', 'рамблер нихром', 'Хром от Яндекса', 'хром от яндекса', 'Браузер', 'браузер', 'Нихром', 'нихром', '(?-i)Амиго([^0-9a-zA-ZА-яЁё_-]|\Z)', '(?-i)амиго([^0-9a-zA-ZА-яЁё_-]|\Z)', 'Яндекс.Браузер', 'яндекс.браузер', '3D браузер']
		; Для котортких слов Обязатльно учитывать регистр и конец слов
;~ 		For $b=0 to Ubound($aBrowsers)-1
;~ 			if StringLen($aBrowsers[$b]) < 6 Then
;~ 				$aBrowsers[$b] = '(?-i)' & $aBrowsers[$b] & '([^0-9a-zA-ZА-яЁё_-]|\Z)'
;~ 			EndIf
;~ 		Next
	elseif $mod = 2 then
		dim $array[2] = ['1','2']
	EndIf
	return $array
EndFunc