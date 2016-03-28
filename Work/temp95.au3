#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <Array.au3>


global $variantotveta

$ini = StringTrimRight(@ScriptFullPath, 3) & 'ini'
If Not FileExists($ini) Then
    $hFile = FileOpen($ini, 2)
    FileWrite($hFile, _
            '[1]' & @CRLF & _
            '0 = 840.Какой цвет запрещающий' & @CRLF & _
            '1 = Зелёный' & @CRLF & _
            '2 = Жёлтый' & @CRLF & _
			'2 = Жёлтый' & @CRLF & _
            '3 = Красный' & @CRLF & @CRLF & _
            '[2]' & @CRLF & _
            '0 = 5210.Диаметр Сатурна' & @CRLF & _
            '1 = 12 000 км' & @CRLF & _
			'2 = Жёлтый' & @CRLF & _
            '2 = 30 000 км' & @CRLF & _
            '3 = 60 000 км')
    FileClose($hFile)
EndIf

$ainiSection = IniReadSectionNames($ini)
ConsoleWrite($ainiSection & @CRLF) ;отладка
If @error Then Exit MsgBox(0, 'Сообщение', 'ini-файл пустой')

$iStep = 0 ; Счётсик шагов, чтобы завершить, когда достигнута последняя секция ini-файла
Local $aiCountAnswer[$ainiSection[0] + 1][2] = [[0]] ; Счётчик результата, количество правильных ответов
$sCurAnswer = 0 ; Правильный ответ, чтобы сравнивать

;Объявление массива ответов
global $variantotveta, $MassivOtvetov[UBound($aiCountAnswer)]

; Максимальное число ответов по шифрованию 10, по размеру GUI - 9
$hGui = GUICreate('Программа для тестирования уровня знаний', 610, 320) ; идентификаторы GUI начинаются с 3
GUISetFont(11)
$iQuestion = GUICtrlCreateLabel('', 5, 5, 600, 66) ; стили центрирования $SS_CENTER + $SS_CENTERIMAGE
; GUICtrlSetBkColor(-1, 0xfdffae)
$iHorz = GUICtrlCreateLabel('-', 5, 71, 600, 0, $SS_ETCHEDHORZ) ; горизонтальная линия
GUICtrlSetState(-1, $GUI_HIDE)

If $CmdLine[0] Then ; Если передан параметр ком-строки, то включаем рещим редактирования
    $iMenu = GUICtrlCreateContextMenu($iQuestion)
    $iRnd = GUICtrlCreateMenuItem('Сохранить выбранный ответ', $iMenu)
Else ; Иначе создаём пустышку
    $iRnd = GUICtrlCreateDummy()
EndIf

Local $aID[1] = [0] ; идентификаторы радиокнопок
$ID_Start = 0 ; Комбинация ID при которых Switch -> Case не сработает
$ID_End = -1

$iBtnNext = GUICtrlCreateButton('Начать тест', 477, 276, 108, 28)
$iBtnBack = GUICtrlCreateButton('Назад', 367, 276, 108, 28)
GUICtrlSetState(-1, $GUI_HIDE)
; $iStatusBar = GUICtrlCreateLabel('StatusBar', 5, 260 - 20, 150, 17)
GUISetState()
While 1
    $iMsg = GUIGetMsg()
    Switch $iMsg
        Case -3
            Exit
        Case $iRnd
            ; $iRndAns = InputBox(' ', ' ', '', '', 170, 150)
            ; If Not @error And StringIsDigit($iRndAns) Then
                ; If StringLen($iRndAns) = 1 Then
                    ; ClipPut((Random(1, 99, 1) & $iRndAns) * 19 + 23)
                ; Else
                    ; ClipPut($iRndAns * 19 + 23)
                ; EndIf
            ; EndIf
            ; Ввод правильного ответа
            For $i = 1 To $aID[0]
                If GUICtrlRead($aID[$i]) = $GUI_CHECKED Then
                    $j = $aID[$i] - $aID[1] + 1 ; Номер текущего выбора
					
					;отладка
;~ 					ConsoleWrite($j & @CRLF)
					
                    $tmp = IniRead($ini, $ainiSection[$iStep], '0', 'Ошибка') ; Запрос ответа
                    $tmp = StringRegExp($tmp, '^\d+?\.(.*)$', 1)
                    If @error Then
                        MsgBox(0, 'ошибка', 'ошибка')
                        ContinueLoop
                    EndIf
                    IniWrite($ini, $ainiSection[$iStep], '0', (Random(1, 99, 1) & $j) * 19 + 23 & '.' & $tmp[0])
                    ExitLoop
                EndIf
            Next
        Case $iBtnNext
            If $ID_End = -3 Then Exit
            _StepGUI()
            ; Если ответ содержит ID, то отмечаем выбор
            If $ID_End <> -3 And $aiCountAnswer[$iStep][1] Then 
			   GUICtrlSetState($aiCountAnswer[$iStep][1], $GUI_CHECKED)
			EndIf
			
			; Запись ответа в массив
					 ConsoleWrite('выбранный вариант ответа: '&$variantotveta & '   iшаг= ' & $iStep & @CRLF) ; отладка 
			if $variantotveta > 0 then 
			   $MassivOtvetov[$iStep-1] = $variantotveta
			   ConsoleWrite('(ВАРИАНТ ОТВЕТА НЕ НОЛЬ) выбранный вариант ответа: '&$variantotveta & '   iшаг= ' & $iStep & @CRLF)
			EndIf
				  
		   ; Переход на отображение результатов
			If $iStep > $ainiSection[0] Then 
			   _Vyvod_Resultatyov()
			EndIf
				  
        Case $iBtnBack
            _StepGUI(0)
            ; Если ответ содержит ID, то отмечаем выбор
            If $ID_End <> -1 And $aiCountAnswer[$iStep][1] Then GUICtrlSetState($aiCountAnswer[$iStep][1], $GUI_CHECKED)
        Case $ID_Start To $ID_End
            $j = $iMsg - $ID_Start + 1 ; Номер текущего выбора
								   
					$variantotveta=$j
            ; MsgBox(0, 'Check', $j, 0, $hGui)
            $aiCountAnswer[$iStep][1] = $iMsg ; Сохраняем ID, чтобы при возврате автоматом выставлять выбор
            If $j == StringRight(($sCurAnswer - 23) / 19, 1) Then ; номер ответа * 19 + 23, например для 3 будет 43 * 19 + 23 = 840
                $aiCountAnswer[$iStep][0] = 1 ; 'Верно
            Else
                $aiCountAnswer[$iStep][0] = 0 ; Не верно
			EndIf
			 					;отладка
;~ 					ConsoleWrite('клик на вариант ответа: '&$j & @CRLF)

    EndSwitch
WEnd

Func _StepGUI($iNext = 1)
    If $iNext Then
        $iStep += 1
    Else
        $iStep -= 1
    EndIf
    For $i = 1 To $aID[0]
        GUICtrlDelete($aID[$i]) ; Цикл удаление предыдущих элементов
    Next
    If $iStep = 1 Then
        GUICtrlSetData($iBtnNext, 'Далее') ; Изменение кнопки в начале опроса
        GUICtrlSetState($iBtnBack, $GUI_SHOW) ; Показывает кнопку "Назад"
        GUICtrlSetState($iHorz, $GUI_SHOW) ; Показывает линию
    EndIf
    If $iStep <= 0 Then ; Если номер окна равен 0 или меньше то сброс
        Dim $aID[1] = [0]
        $ID_Start = 0 ; Комбинация ID при которых Switch -> Case не сработает
        $ID_End = -1
        GUICtrlSetData($iBtnNext, 'Начать тест') ; Изменение кнопки при возврате в начало
        GUICtrlSetState($iBtnBack, $GUI_HIDE) ; Скрывает кнопку "Назад"
        GUICtrlSetData($iQuestion, '') ; Вступительный текст при возврате в начало
        WinSetTitle($hGui, '', 'Программа для тестирования уровня знаний')
        GUICtrlSetState($iHorz, $GUI_HIDE) ; Скрывает линию
        Return
    EndIf
    If $iStep > $ainiSection[0] Then ; Достигнут конец имён секций, собственно самих вопросов
        Dim $aID[1] = [0]
        $ID_Start = 0 ; Комбинация ID при которых Switch -> Case не сработает
        $ID_End = -3
        GUICtrlSetData($iBtnNext, 'Выход') ; Изменение кнопки в конце опроса
        GUICtrlSetState($iBtnBack, $GUI_HIDE)
        Local $iCountAnswer = 0
        For $i = 1 To UBound($aiCountAnswer) - 1
            $iCountAnswer += $aiCountAnswer[$i][0]
        Next
;~         GUICtrlSetData($iQuestion, 'Правильных ответов: ' & $iCountAnswer & ' из ' & $ainiSection[0]) ; Изменение вопроса
		GUICtrlSetData($iQuestion, 'Результаты тестирования: ') ; Изменение вопроса
        WinSetTitle($hGui, '', 'Результат')
        GUICtrlSetState($iHorz, $GUI_HIDE) ; Скрывает линию

        Return
    EndIf
    WinSetTitle($hGui, '', 'Вопрос ' & $iStep & ' из ' & $ainiSection[0]) ; Дублировать в заголовке
    $aSectionQuestion = IniReadSection($ini, $ainiSection[$iStep]) ; Запрос вопросов из секции
    If @error Or $aSectionQuestion[0][0] < 2 Then Return ; выход если число параметров меньше минимального
    Dim $aID[$aSectionQuestion[0][0]] = [$aSectionQuestion[0][0] - 1] ; Пересоздание массива идентификаторов по числу вопросов
    $tmp = StringRegExp($aSectionQuestion[1][1], '(\d+?)\.(.*)', 1) ; Парсинг вопроса и ответа
    If @error Then ; Ошибка формата строки вопроса и ответа
        Dim $aID[1] = [0]
        $ID_Start = 0 ; Комбинация ID при которых Switch -> Case не сработает
        $ID_End = -2
        GUICtrlSetData($iQuestion, 'Внутренняя ошибка') ; Изменение вопроса на предупреждение
        Return
    EndIf
    $sCurAnswer = $tmp[0]
    GUICtrlSetData($iQuestion,  $tmp[1]) ; Изменение вопроса
    $y = 50
    For $i = 2 To $aSectionQuestion[0][0]
        $y += 22
        $aID[$i - 1] = GUICtrlCreateRadio($aSectionQuestion[$i][1], 13, $y, 590, 22) ; Наполняем вопросами GUI
    Next
    $ID_Start = $aID[1] ; Комбинация ID при которых Switch -> Case срабатывает на указанное колическтво вопросов
    $ID_End = $aID[$aID[0]]
EndFunc   ;==>_StepGUI


Func _Vyvod_Resultatyov()
   
   			  $aArray=$MassivOtvetov
			   For $i = 0 To UBound($aArray) - 1
				   MsgBox(4096, "флаг=2",   "$aArray[" & $i & "] = " & $aArray[$i])
				Next
				
EndFunc   ;==>_Vyvod_Resultatyov