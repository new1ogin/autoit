#include <GUIConstants.au3>
#include <Array.au3>

$sFileType = '*.cp';расширения обрабатываемых файлов, через точку с запятой
$sSearch1 = 'G01X0.000Y0.000';искомые строки
$sSearch2 = 'M02'
$sSign = '#';строка для обозначения нового файла

$hGUI = GUICreate('Обработчик файлов *.cp', 640, 220);окно
$hInputPath = GUICtrlCreateInput('', 5, 5, 630, 21);поле для вывода пути к каталогу
GUICtrlSetState(-1, $GUI_DISABLE);поле делаем "только для чтения"
$hButtonOpenFolder = GUICtrlCreateButton('Выбрать папку', 480, 30, 150, 25);кнопка выбора каталога
$hButtonChek = GUICtrlCreateButton('Подсчитать', 10, 30, 120, 24);кнопка проверки файлов
$hButtonStart = GUICtrlCreateButton('Пуск', 250, 30, 80, 24);кнопка старта обратотки
$hLabelInfo = GUICtrlCreateLabel('', 10, 60, 620, 120)
$hProgress = GUICtrlCreateProgress(10, 190, 620, 15)
GUISetState(@SW_SHOW)

While 1
    $hMsg = GUIGetMsg();отлавливаем нажатия на кнопки
    Select
        Case $hMsg = $GUI_EVENT_CLOSE; закрытие окна программы
            Exit
        Case $hMsg = $hButtonOpenFolder; нажата кнопка вбора каталога
            $hFolder = FileOpenDialog('Выберите файл для обработки',@ScriptDir, "Html (*.htm; *.html)|Все (*.*)")
            If $hFolder <> '' Then  GUICtrlSetData($hInputPath, $hFolder);если пользователь не нажал отмену или не закрыл окно выбора каталога, то заносим полученный путь в поле ввода
        Case $hMsg = $hButtonStart; нажата кнопка пуска скрипта
            $sFolder = GUICtrlRead($hInputPath);читаем путь до каталога
            If $sFolder = '' Then;путь не был указан
                MsgBox(0, 'Ошибка', 'Не выбран каталог для обработки')
            ElseIf Not FileExists($sFolder) Then;такой каталог не существует
                MsgBox(0, 'Ошибка', 'Данного каталога не существует')
            Else
                $sOut = _processing($sFolder, $sSign);функция обработки файлов
                If Not @error Then
                    GUICtrlSetData($hLabelInfo, 'Всего найдено и обработано файлов: ' & $sOut)
                Else
                    MsgBox(0, 'Ничего не найдено', 'В данном каталоге не найдено ни одного подходящего файла')
                EndIf
            EndIf
        Case $hMsg = $hButtonChek; нажата кнопка проверки файлов
            $sFolder = GUICtrlRead($hInputPath);читаем путь до каталога
            If $sFolder = '' Then;путь не был указан
                MsgBox(0, 'Ошибка', 'Не выбран каталог для обработки')
            ElseIf Not FileExists($sFolder) Then;такой каталог не существует
                MsgBox(0, 'Ошибка', 'Данного каталога не существует')
            Else
                $aOut = _checkFiles($sFolder);функция анализа файлов
                If Not @error Then
                    GUICtrlSetData($hLabelInfo, 'Всего найдено файлов: ' & $aOut[0] & @CRLF & 'полученная сумма: ' & $aOut[1])
                Else
                    MsgBox(0, 'Ничего не найдено', 'В данном каталоге не найдено ни одного подходящего файла')
                EndIf
            EndIf
    EndSelect
WEnd

Func _checkFiles($sPath)
    $aFiles = _FileSearch($sPath, $sFileType); ищем файлы нужного расширения с выводом в массив
    If Not @error And $aFiles[0] > 0 Then; найден хотя бы один файл
        Local $iSumm = 0;здесь будем хранить сумму всех чисел, записанных в именах файлов
        For $i = 1 To $aFiles[0]
            $iSumm += Number(StringRegExpReplace($aFiles[$i], '^.*\\.*?\=(\d+).*', '$1'));от полного пути файла оставляем только цифры после знака равно, приводим его к числовому значению и сумируем
        Next
        Dim $aOut[2] = [$aFiles[0], $iSumm]
        Return $aOut
    Else;ничего не найдено
        SetError(1)
        Return 0
    EndIf
EndFunc

Func _processing($sPath, $sStr)
    $aFiles = _FileSearch($sPath, $sFileType); ищем файлы нужного расширения с выводом в массив
    If Not @error And $aFiles[0] > 0 Then; найден хотя бы один файл
        Dim $aNewNames[$aFiles[0] + 1][2];массив для хранения новых имен файлов
        $sPattern = '\Q' & $sSearch1 & '\E\v+\Q' & $sSearch2 & '\E$';шаблон для поиска искомых строк в конце файла
        For $i = 1 To $aFiles[0]
            GUICtrlSetData($hProgress, 100*(Round($i/$aFiles[0], 2)));двигаем прогресс
            GUICtrlSetData($hLabelInfo, 'Обрабатывается файл: ' & $aFiles[$i] & @CRLF & 'обрабатоно файлов: ' & $i & ' из ' & $aFiles[0])
            $aNewNames[$i][0] = StringRegExpReplace($aFiles[$i], '\\[^\\]*$', '');от полного пути файла оставляем только путь до файла
            $aNewNames[$i][1] = StringRegExpReplace($aFiles[$i], '^.*\\', '');от полного пути файла оставляем только имя и расширение
            $sFile = FileRead($aFiles[$i]);считываем файл
            If StringRegExp($sFile, $sPattern, 0) Then;в файле найдены искомые строки - удаляем
                $sNewFile = StringRegExpReplace($sFile, $sPattern, '');удаляем найденные строки в тексте
                $hFile = FileOpen($aFiles[$i], 2); открываем файл для перезаписи
                FileWrite($hFile, $sNewFile); пишем в файл
                FileClose($hFile);закрываем файл
            EndIf
            FileMove($aFiles[$i], $aNewNames[$i][0] & '\' & $sStr & $aNewNames[$i][1], 1); переименовываем обработанные файлы
        Next
        Return $aFiles[0]
    Else;ничего не найдено
        SetError(1)
        Return 0
    EndIf
EndFunc

Func _FileSearch($sPath, $sFileMask, $iSubDir = 1); функция поиска файлов (супер быстрая), есть на нашем форуме
    ;первый параметр - путь, второй маска файлов для поиска, третий - флаг поиска в подкаталогах
    Local $sOutBin, $sOut, $aOut, $sRead, $hDir, $sAttrib
    If $iSubDir = 1 Then
        $sAttrib = ' /S /B /A'
    Else
        $sAttrib = ' /B /A'
    EndIf
    $sOut = StringToBinary('0' & @CRLF, 2)
    $aMasks = StringSplit($sFileMask, ';')
    For $i = 1 To $aMasks[0]
        $hDir = Run(@ComSpec & ' /U /C DIR "' & $sPath & '\' & $aMasks[$i] & '"' & $sAttrib, @SystemDir, @SW_HIDE, 6)
        While 1
            $sRead = StdoutRead($hDir, False, True)
            If @error Then
                ExitLoop
            EndIf
            If $sRead <> '' Then
                $sOut &= $sRead
            EndIf
        WEnd
    Next
    $aOut = StringRegExp(BinaryToString($sOut, 2), '[^\r\n]+', 3)
    If @error Then
        Return SetError(1)
    EndIf
    $aOut[0] = UBound($aOut) - 1
    Return $aOut
EndFunc   ;==>_FileSearch
