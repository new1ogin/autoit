#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <ListViewConstants.au3>
#include <WindowsConstants.au3>
#include <GuiListView.au3>





#Region ### START Начальные данные ###
;Записываем "строки"/"слова в строках" которые необходимо удалить
$DelteString = 'Framework' & '|' & _
'Intel(R) PRO Network Connections' & '|' & _
'Graphics Media Accelerator' & '|' & _
'Program  	Version  	Inst. Size' & '|' & _
'Internet Explorer \E\d+\Q' & '|' & _
'\EKB\d+\Q' & '|' & _
'\E(KB[0-9]+)\Q' & '|' & _
'Программа  	Версия  	Размер' & '|' & _
'Microsoft Visual C++ ' & '|' & _
'Графический драйвер' & '|' & _
'Compatibility Pack' & '|' & _
'.NET Framework' & '|' & _
'Audio Driver' & '|' & _
'MSXML' & '|' & _
'Security Update' & '|' & _
'Vista Drive Icon' & '|' & _
'Language Pack' & '|' & _
'Paper Specification Shared' & '|' & _
'Microsoft Software Update' & '|' & _
'Пакет обеспечения совместимости' & '|' & _
'Shockwave' & '|' & _
'Intel® Management Engine' & '|' & _
'Intel Management Engine' & '|' & _
'Installed Programs' & '|' & _
'Установленные программы' & '|' & _
'Microsoft Office Suite Service Pack 2' & '|' & _
'REALTEK\E.*\QEthernet' & '|' & _
'Microsoft\E.*\QAdd-in' & '|' & _
'\E^\QCCC Help\E.*\Q' & '|' & _
'\EПакет.+обеспечения.+совместимости\Q'

;Записываем слова из первых ячеек которые можно обобщить, например Nero (чтобы удалить все дополнения Nero из списка)
$EqualString = '\E^Nokia\Q' & '|' & _
'SAMSUNG Mobile' & '|' & _
'Samsung PC Studio 3' & '|' & _
'\E^Microsoft Office\Q' & '|' & _
'Samsung SCX-4100 Series' & '|' & _
'\E^\QSTDU Viewer' & '|' & _
'Windows Media\E.*\d+\Q' & '|' & _
'Catalyst Control Center' & '|' & _
'clear.fi' & '|' & _
'Galeria\E.*\QWindows Live' & '|' & _
'Java' & '|' & _
'Nero' & '|' & _
'Windows Live Essentials' & '|' & _
'Windows Live Fotog' & '|' & _
'Windows Live Photo' & '|' & _
'Windows Live Mail' & '|' & _
'Windows Live Mesh' & '|' & _
'Windows Live Messenger' & '|' & _
'Windows Live Movie Maker' & '|' & _
'Windows Live Photo Common' & '|' & _
'Windows Live Remote' & '|' & _
'Windows Live Writer' & '|' & _
'Adobe Flash Player \E\d+\Q'

;Список приортитности софта, бесплатный софт <=6 , платный софт >6
dim $SortString[199][2] = [['Windows\E.*\QLive', 2 ], _
['7-zip', 4 ], _
['(?-i)Acer ', 3 ], _
['Acer Incorporated', 3 ], _
['Adobe Reader', 2 ], _
['Flash Player', 2 ], _
['Adobe AIR', 2 ], _
['AIMP', 4 ], _
['(?-i)AMD ', 3 ], _
['Audacity', 5 ], _
['avast! Free ', 5 ], _
['Bing Bar', 6 ], _
['Catalyst Control Center', 3 ], _
['ccc-utility', 3 ], _
['CDBurnerXP', 4 ], _
['D3DX\E.*\QMicrosoft', 3 ], _
['Evernote', 5 ], _
['GIMP', 5 ], _
['Google Chrome', 2 ], _
['Google Update', 2 ], _
['Java(TM)', 2 ], _
['Codec Pack', 4 ], _
['Runtime\E.*\QMicrosoft', 3 ], _
['Silverlight', 4 ], _
['Microsoft SQL Server', 2 ], _
['Mozilla Firefox', 2 ], _
['MSVCRT', 2 ], _
['Nero', 7 ], _
['OpenOffice', 4 ], _
['Picasa', 5 ], _
['(?-i)QIP ', 5 ], _
['RAID\E.*\QAMD', 3 ], _
['Run-time', 3 ], _
['Runtime', 3 ], _
['Skype', 5 ], _
['Total Commander', 7 ], _
['Xerox', 3 ], _
['Декларация 2010', 2 ], _
['Печать НД с PDF', 2 ], _
['Планы\E.*\QMMIS', 2 ], _
['MMIS Lab', 2 ], _
['ВПО-2', 2 ], _
['Формы статотчетности', 2 ], _
['Росстат', 2 ], _
['Сведения о численности и оплате труда работников', 2 ], _
['Microsoft Application', 4 ], _
['2ГИС ', 5 ], _
['WinRAR', 7 ], _
['WinUtilities', 8 ], _
['ESET ', 7 ], _
['FineReader', 7 ], _
['Foxit ', 4 ], _
['Live\E.*\QMicrosoft', 2 ]]
$SortString=_ArrayClearEmpty($SortString, 0, 0)


$file = FileOpen("LogDelete.csv",9)
$date =  @MDAY & '/' & @MON & '/' & @YEAR & ' - ' & @HOUR & ':' & @MIN & ':' & @SEC
FileWriteLine($file,' '&@CRLF& '____<<<' & $date & ' ' & _ListWindows())

$SplitDelteString = StringSplit($DelteString, '|')
$SplitEqualString = StringSplit($EqualString, '|')
; При добовлении в список обобщения слов содержащихся в двух списках одновременно, происходит удаление обоих списков. Например 'Nokia' 'Connectivity'
;~ _ArrayDisplay($SplitDelteString)
#EndRegion ### END Начальные данные ###





Local $file, $btn, $msg, $hGui
Global $Text, $aArray, $result, $filename, $LANip, $windows, $Antivirus, $processor, $core, $RAM, $ddr, $stripRAM, $partitionC, $partitions

Global $Texto, $ListView, $OneFilePatch, $ThisFilePatch, $schetStrok=0
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=\\server2003\Shared\autoitv3.3.8.1\Koda\hGui2.kxf
$hGui = GUICreate("Обработка списка ПО", 611, 571, 224, 97, BitOR($GUI_SS_DEFAULT_GUI,$WS_MAXIMIZEBOX,$WS_SIZEBOX,$WS_THICKFRAME,$WS_TABSTOP), BitOR($WS_EX_ACCEPTFILES,$WS_EX_WINDOWEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "hGuiClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "hGuiMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "hGuiMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "hGuiRestore")
$file = GUICtrlCreateInput("", 10, 5, 504, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$hButtonOpenFolder = GUICtrlCreateButton("Обзор", 522, 5, 72, 20)
GUICtrlSetOnEvent(-1, "hButtonOpenFolderClick")
$btn = GUICtrlCreateButton("OK", 8, 39, 70, 26)
GUICtrlSetOnEvent(-1, "btnClick")
$Copy = GUICtrlCreateButton("Скопировать все", 472, 56, 121, 25)
GUICtrlSetOnEvent(-1, "CopyClick")
$ListView = GUICtrlCreateListView("|||", 8, 88, 593, 473)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 350)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 100)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 75)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 60)
$ListView_0 = GUICtrlCreateListViewItem("Назв-е|ПО|2|3|4", $ListView)
GUICtrlSetOnEvent(-1, "SetBuffer")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd


; по нажатию кнопки ок
Func btnClick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : btnClick() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
ConsoleWrite(GUICtrlRead($file) & @CRLF)
	If StringInStr ( GUICtrlRead($file), "|") <>0 Then
		$OneFilePatch = StringSplit(GUICtrlRead($file), '|')
		For $i=1 To $OneFilePatch[0]
			ConsoleWrite($OneFilePatch[$i] & '   количество циклов:'& $OneFilePatch[0] & @CRLF)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $OneFilePatch[$i] = ' & $OneFilePatch[$i] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			_Obrabotka($OneFilePatch[$i])
			if $OneFilePatch[0] > 1 and $i <> $OneFilePatch[0] then msgbox(0,'Предупреждение','Проверьте правильность данных, по нажатию кнопки "ОК" обработается следующий файл')
			ConsoleWrite(' отладка ' &@CRLF)
		Next

	Else
;~ 		$OneFilePatch = $file
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : GUICtrlRead($file) = ' & GUICtrlRead($file) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		_Obrabotka(GUICtrlRead($file))
;~ 		ConsoleWrite(' отладка ' &@CRLF)
;~ 		_waiting()
	EndIf


EndFunc

;действие на кнопку Обзор
Func hButtonOpenFolderClick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hButtonOpenFolderClick() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 	MsgBox(0, "drag drop файл", 'Выберите файл для обработки', 0, $hGui)
            $hFolder = FileOpenDialog('Выберите файл для обработки',@ScriptDir, "TXT (*.txt; *.csv)|Все (*.*)")
            If $hFolder <> '' Then  GUICtrlSetData($file, $hFolder);если пользователь не нажал отмену или не закрыл окно выбора каталога, то заносим полученный путь в поле ввода

;~             $hFile = FileOpenDialog('Выберите файл для обработки',@ScriptDir, "Html (*.htm; *.html)|Все (*.*)")
;~             If $hFile <> '' Then  GUICtrlSetData($file, $hFile);если пользователь не нажал отмену или не закрыл окно выбора каталога, то заносим полученный путь в поле ввода


EndFunc

;закрытие программы
Func hGuiClose()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hGuiClose() = ' & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 	MsgBox(262144,'Debug line ~' & @ScriptLineNumber,'Selection:' & @lf & 'hGuiClose()' & @lf & @lf & 'Return:' & @lf & hGuiClose()) ;### Debug MSGBOX
exit
EndFunc

;действие при нажатии на кнопку
Func hGuiMaximize()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hGuiMaximize() = ' & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

EndFunc

;действие при нажатии на кнопку
Func hGuiMinimize()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hGuiMinimize() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

EndFunc

;действие при нажатии на кнопку
Func hGuiRestore()

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hGuiRestore() = ' & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

EndFunc


Func CopyClick()

	 	Local $aItem, $sText, $hListView
	;~     ; Получает текст 2-го пункта
	;~ 	$Index = _GUICtrlListView_GetSelectedIndices($ListView)
	;~ 	TrayTip('',$Index,500)
	;~     $aItem = _GUICtrlListView_GetItemTextArray($ListView, $Index)
	;~     For $i = 1 To $aItem[0]
	;~         $sText &= StringFormat("Колонка[%2d] %s", $i, $aItem[$i]) & @TAB
	;~ 		$sText &= $aItem[$i] & @TAB
	;~     Next
	;~ ClipPut($sText)

	; получим число пунктов в ListView
    $schetStrok=_GUICtrlListView_GetItemCount($ListView)

	ConsoleWrite($schetStrok & @CRLF)
	For $i=0 To $schetStrok
	;~ _GUICtrlListView_GetItemText($ListView, $i)

		$aItem = _GUICtrlListView_GetItemTextArray($ListView, $i)
			For $t = 1 To $aItem[0]
		;~         $sText &= StringFormat("Колонка[%2d] %s", $i, $aItem[$i]) & @TAB
				$sText &= $aItem[$t] & @TAB
			Next
		$sText &= @CRLF
		ConsoleWrite($sText & @CRLF)

	;~     $Index = _GUICtrlListView_GetSelectedIndices($ListView)
	;~ 	ToolTip('Скопированно: '&_GUICtrlListView_GetItemText($ListView, $i))
	;~ 	TrayTip('',$Index,500)
	;~     ClipPut(_GUICtrlListView_GetItemText($ListView, Number($Index)))
	Next

	ClipPut($sText)

EndFunc

Func fileChange()

EndFunc



Func SetBuffer()
;~ 	Local $aItem, $sText, $hListView
;~     ; Получает текст 2-го пункта
;~ 	$Index = _GUICtrlListView_GetSelectedIndices($ListView)
;~ 	TrayTip('',$Index,500)
;~     $aItem = _GUICtrlListView_GetItemTextArray($ListView, $Index)
;~     For $i = 1 To $aItem[0]
;~         $sText &= StringFormat("Колонка[%2d] %s", $i, $aItem[$i]) & @TAB
;~ 		$sText &= $aItem[$i] & @TAB
;~     Next
;~ ClipPut($sText)



    $Index = _GUICtrlListView_GetSelectedIndices($ListView)
	ToolTip('Скопированно: '&_GUICtrlListView_GetItemText($ListView, Number($Index)))
	TrayTip('',$Index,500)
    ClipPut(_GUICtrlListView_GetItemText($ListView, Number($Index)))
EndFunc



Func _Obrabotka($FilePatch='')
	if StringLen($FilePatch)<4 then
		$buffer = ClipGet()
	Else
		$fileRead = FileOpen($FilePatch)
		$buffer = FileRead($fileRead)
	EndIf

Dim $SplitBuffer = StringSplit(StringStripCR($buffer), @LF) ;второй вариант разбития
;~ $SplitBuffer = StringSplit($buffer, @CR)
Consolewrite($SplitBuffer[0])
;~ _ArrayDisplay($splitBuffer,'ДО')

;Удаление пустых строк
$deletei=0
For $i=1 to  UBound($SplitBuffer)-1
   If StringIsSpace ( $SplitBuffer[$i] )=1 then
	  _ArrayDelete($SplitBuffer, $i); $SplitBuffer[$i]=''
	  $deletei+=1
	  $i=$i-1
;~ 	  ConsoleWrite('найдена пустая строка, удаляю: '&$i&@CRLF)
   EndIf
;~    ConsoleWrite($i&' '&$SplitBuffer[$i]&@CRLF)
   If $i > UBound($SplitBuffer)-1-$deletei then ExitLoop
Next

;Создания копии исходного массива, для последующего сравнения
Dim $CopySplitBuffer = $SplitBuffer
_ArrayDisplay($CopySplitBuffer)

global $Equal[$SplitBuffer[0]+1][$SplitEqualString[0]+1], $tempEqualDeleteList[$SplitBuffer[0]+1]
global $delete [$SplitBuffer[0]+1]
$schet=0
$schet2=1
global $splitBufferCell[2]
For $i=1 to  UBound($SplitBuffer)-1  ; ГЛАВНЫЙ порядок поиска строк
;~ 	  ConsoleWrite('нач' & $i & ' ')
;~ 	  ConsoleWrite($splitBuffer[$i] & @CRLF)
	  If StringRegExp ( $splitBuffer[$i], "\S" ) = 0 Then
		 $delete[$i]=1
;~ 		 ConsoleWrite('пустая строка '&$i&' '&$splitBuffer[$i]&@CRLF)
	  Else
		 ;Сравнение строки со списком для удаления
		 For $t=1 to $SplitDelteString[0]
;~ 			If StringInStr ( $splitBuffer[$i], $SplitDelteString[$t]) <>0 Then
			If StringRegExp ( $splitBuffer[$i], '(?i)\Q'& $SplitDelteString[$t] &'\E') <>0 Then
			   $delete[$i]=1
;~ 			   ConsoleWrite($delete[$i]&' Найденно совпадение '&$i&' '&$splitBuffer[$i]&@CRLF)
			EndIf
		 Next

		 ;Сравнение строки со списком обобщения
		 For $t=1 to $SplitEqualString[0]
;~ 			If StringInStr ( $splitBuffer[$i], $SplitDelteString[$t]) <>0 Then
			If StringRegExp ( $splitBuffer[$i], '(?i)\Q'& $SplitEqualString[$t] &'\E') <>0 Then
;~ 			   $delete[$i]=10+$t
			   $splitEqualCells=StringSplit($splitBuffer[$i], @TAB)
;~ 			   $schet2+=1
;~ 			   Redim $Equal[$SplitEqualString[0]][$schet2]
			   $Equal[$i][0]=1
			   $Equal[$i][$t]=StringLen($splitEqualCells[1])
			   $delete[$i]=2
;~ 			   ConsoleWrite('Найденно совпадение '&$i&' '&$splitBuffer[$i]&@CRLF)
			EndIf
		 Next

		 ;Удаление строк, если первая ячейка уже повторялась
		 $schet+=1
		 if $schet>1 then ;Пропускаем первую строку
			$splitBufferCell2=StringSplit($splitBuffer[$i], @TAB)
;~ 			ConsoleWrite('$SBC2='&$splitBufferCell2&'  ')
			if not @error then
			   For $t=1 to Ubound($splitBufferCell)-1 ;перебирает массив запомненных первых ячеек
				  If StringCompare ( $splitBufferCell2[1], $splitBufferCell[$t])=0 then

					 $delete[$i]=1
;~ 					 ConsoleWrite(StringCompare ( $splitBufferCell2[1], $splitBufferCell[$t])&' Найденно совпадение одинаковых первых яччеек '&$i&' '&$splitBuffer[$i]&@CRLF)
				  EndIf
			   Next
			EndIf

		 ;Удаление строки если предыдущая первая ячейка строки была похожа более чем на 10%
		 If $delete[$i]<>1 then
			$Str1=StringSplit($splitBuffer[$i], @TAB)
			$Str2=StringSplit($splitBuffer[$i-1], @TAB)
			$Compare=_StringCompare($Str2[1],$Str1[1],1)
			$Compare1=_StringCompare($Str1[1],$Str2[1], 1)
			if $Compare>$Compare1 then $Compare=$Compare1
			If (100-$Compare) <= 10 Then
			   $delete[$i]=1
;~     			ConsoleWrite('Найденны одинаковые строки '&$Compare&'% , удалена: '&$i&' '&$splitBuffer[$i]&@CRLF)
			endif
		 EndIf

		 endif
		 ;Получение массива первых ячеек таблицы, для удаления дубликатов в них
			$splitBufferCells=0
			$splitBufferCells=StringSplit($splitBuffer[$i], @TAB)
;~ 			If not @error Then
			   Redim $splitBufferCell[Ubound($splitBufferCell)+1]
			   $splitBufferCell[$i]=$splitBufferCells[1]
;~ 			   ConsoleWrite('$SBC='&$splitBufferCell[$i]&'  ')
;~ 			EndIf




	  Endif

;~ 	  ConsoleWrite('кон' & $i & ' ')

Next

;определение самой длинной строки подходящей под обощяющий список
For $i=1 to $SplitBuffer[0]
   If $delete[$i]=2 then
	  If $Equal[$i][0]=1 Then ;если в этой строке найдено обобщающее значение
		 For $t=1 to $SplitEqualString[0]
			if $Equal[$i][$t]>0 Then ;Если это обобщающее значение найденно в этой строке
			   Dim $tempArray[$SplitBuffer[0]+1]
			   ;Перенос данных о длине строки в одномерный массив
			   For $n=1 to $SplitBuffer[0]
				  $tempArray[$n]=$Equal[$n][$t]
				  If $delete[$i]=2 then

				  EndIf
			   Next
			   $delete[_ArrayMaxIndex($tempArray,1,1)]=0 ;устанавливает НЕСТИРАНИЕ на самый длиный обобщающий элемент
;~ 				ConsoleWrite(' Установленно нестирание строки: '&_ArrayMaxIndex($tempArray,1,1)&' для обобщающего списка '&$t&@CRLF)
;~ 				FileWriteLine($file,
				$tempLine=$splitBuffer[_ArrayMaxIndex($tempArray,1,1)]
				FileWriteLine($file, '>>>'&StringLeft($tempLine,StringInStr($tempLine,@TAB)))
				$tempLine=$splitBuffer[$i]
				$tempEqualDeleteList[$i]=1
				FileWriteLine($file, '>'&StringLeft($tempLine,StringInStr($tempLine,@TAB)))
			EndIf
		 Next
	  EndIf
  EndIf

Next



;Удаление отмеченных строк
For $i=1 to $SplitBuffer[0]
	if $tempEqualDeleteList[$i]<>1 then FileWriteLine($file, StringLeft($splitBuffer[$i],StringInStr($splitBuffer[$i],@TAB)))
;~ 	ConsoleWrite($delete[$i]&@CRLF)
   if $delete[$i]=1 or $delete[$i]=2 then
;~ 	  _ArrayDelete($splitBuffer, $i)
	  $splitBuffer[$i]=''
   EndIf
;~ 	ConsoleWrite($delete[$i]&' Найденно совпадение '&$i&' '&$splitBuffer[$i]&@CRLF)
Next
$delete=0

;Удаление пустых строк
$deletei=0
For $i=1 to  UBound($SplitBuffer)-1
   If StringIsSpace ( $SplitBuffer[$i] )=1 then
	  _ArrayDelete($SplitBuffer, $i); $SplitBuffer[$i]=''
	  $deletei+=1
	  $i=$i-1
   Else
	  $SplitBuffer[$i] = StringStripWS ( $SplitBuffer[$i], 3 )
   EndIf
   If $i > UBound($SplitBuffer)-1-$deletei then ExitLoop
Next
   $SplitBuffer=_ArrayClearEmpty($splitBuffer, 0, 1)
;Удаление дубликатов
$SplitBuffer=_ArrayRemoveDuplicates($splitBuffer)


;Сортировка массива для ответа в соответствии со списком
Dim $SplitBufferSort[UBound($SplitBuffer)][2]
For $i=1 to  UBound($SplitBuffer)-1
$SplitBufferSort[$i][0] = $SplitBuffer[$i]
Next
For $i=1 to  UBound($SplitBufferSort)-1 ;проход по всему массиву оставшихся значений
	 For $k=0 to UBound($SortString)-1 ;Проход по всему массиву списка сортировки
		if $SplitBufferSort[$i][1]<1 then ;если сортировка ещё не выполненна
			If StringRegExp ( $SplitBufferSort[$i][0], '(?i)\Q'& $SortString[$k][0] &'\E') <>0 Then
			   $SplitBufferSort[$i][1]=$SortString[$k][1]
		;~ 			   ConsoleWrite($delete[$i]&' Найденно совпадение '&$i&' '&$SplitBufferSort[$i]&@CRLF)
			EndIf
;~ 			if StringInStr($SplitBufferSort[$i][0],"Skype")<>0 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $SplitBufferSort = ' & $SplitBufferSort[$i][1] &') : $SortString = ' & $SortString[$k][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 			if $SplitBufferSort[$i][1] = 7 then _ArrayDisplay($SplitBufferSort)
		EndIf
	Next
	if $SplitBufferSort[$i][1]<1 then $SplitBufferSort[$i][1]=6.5
Next
_ArraySort($SplitBufferSort, 1 , 1, 0, 1)
For $i=1 to  UBound($SplitBuffer)-1
$SplitBuffer[$i] = $SplitBufferSort[$i][0]
Next


;~ ;помещаем текст обратно в буффер
$BufferOut=''
For $i=1 to Ubound($SplitBuffer)-1
	if $splitBuffer[$i]<>'' then
		$BufferOut =$BufferOut & $SplitBuffer[$i] & @CRLF
		GUICtrlCreateListViewItem(StringReplace($SplitBuffer[$i],@TAB,'|') ,$ListView)
	EndIf
;~    $BufferOut=$BufferOut & $SplitBuffer[$i]
Next

;Подсчет выведенных строк
$numberStrngOut=StringSplit($BufferOut,@CRLF)
$numberStrngOut=_ArrayClearEmpty($numberStrngOut, 0, 1)
ConsoleWrite(' -> '& Ubound($numberStrngOut)& '  ')

;вывод результата в буффер обмена
	if StringLen($FilePatch)<4 then
		ClipPut($BufferOut)
	Else	;Сохраняем текст в файл, если он был получен из файла
		$fileWritePatch = _PathSplitByRegExp($FilePatch)
		$ListSoftNewFile = FileOpen ( $fileWritePatch[2]&'\Обработанные_файлы\' & $fileWritePatch[6] & '.txt' , 8+2 )
		FileWrite($ListSoftNewFile, $BufferOut)
		FileClose ( $ListSoftNewFile )
	EndIf




;~ ClipPut($SplitBuffer[1])
;~ ConsoleWrite($BufferOut)
;~ ConsoleWrite( $DelteString )
;~ _ArrayDisplay($splitBuffer,'После')
EndFunc


Func _ListWindows()
	;Получаем список окон
	$List = WinList();'[REGEXPCLASS:Chrome_WidgetWin_]')
	$ListWindows=''
	For $i = 1 To $List[0][0]
		;попытка найти окно отчета
		If $List[$i][0] <> "" And BitAnd(WinGetState($List[$i][1]), 2) Then
			if StringInStr($List[$i][0],'Report')<>0 or StringInStr($List[$i][0],'Отчет')<>0 or StringInStr($List[$i][0],'Отчёт')<>0 then
				$ListWindows&=$List[$i][0]&';  '
			EndIf
		EndIf
	Next
	if $ListWindows='' then
		For $i = 1 To $List[0][0]
			If $List[$i][0] <> "" And BitAnd(WinGetState($List[$i][1]), 2) and StringInStr($List[$i][0],'Обработка_текста')=0 Then
				ConsoleWrite($List[$i][0]&@CRLF);WinGetTitle($List[$i][1])&@CRLF)
				$ListWindows&=$List[$i][0]&';  '
			endif
		Next
	EndIf
	return $ListWindows
EndFunc


;Функция сравнения двух строк и возвращающая % совпадения первой строки ко второй
Func _StringCompare($Str1,$Str2,$StringMode=0)

   $Str1=StringStripWS ( $Str1, 7) ;удаление пробельных символов в конце, начале строки и повторяющихся пробельных символов
   $Str2=StringStripWS ( $Str2, 7)
   If $StringMode=0 Then
	  $Split1=StringSplit($Str1, Chr(9)& Chr(10)& Chr(11)& Chr(12)& Chr(13)& Chr(32)& Chr(0)& '.'& '_'& ','& '-'& '('& ')')
	  $Split2=StringSplit($Str2, Chr(9)& Chr(10)& Chr(11)& Chr(12)& Chr(13)& Chr(32)& Chr(0)& '.'& '_'& ','& '-'& '('& ')')
   Else
	  $Split1=StringSplit($Str1, Chr(9)& Chr(10)& Chr(11)& Chr(12)& Chr(13)& Chr(32)& Chr(0))
	  $Split2=StringSplit($Str2, Chr(9)& Chr(10)& Chr(11)& Chr(12)& Chr(13)& Chr(32)& Chr(0))
   EndIf

   ;опредление самого длинного слова
   Global $maxLenght
   $maxLenght = _Max_Lenght($Split1)
   $maxLenght1 = _Max_Lenght($Split2)
   If $maxLenght > $maxLenght1 Then $maxLenght=$maxLenght1

   ;перебор и сравнение всех слов, для получения общего процета совпадения

   Dim $JointCompare=0, $JoinLenght=0
   Dim $CompareArray[UBound($Split2)]
   For $i=1 to UBound($Split1)-1
	  For $t=1 to UBound($Split2)-1
		 $Compare=_Compare ($Split1[$i], $Split2[$t])
		 $CompareArray[$t]=(_Compare ($Split1[$i], $Split2[$t]))
   ;~ 	  $JoinLenght+=$Lenght1/$maxLenght
	  Next
	  $JoinLenght+=StringLen($Split1[$i])/$maxLenght
	  $JointCompare+=_ArrayMax($CompareArray, 1, 1)*(StringLen($Split1[$i])/$maxLenght)
   ;~    ConsoleWrite(' ' & StringLen($Split1[$i])& '')
   Next
   ;~ ConsoleWrite(@CRLF)
   ;~ ConsoleWrite($JointCompare&@CRLF)
   ;~ ConsoleWrite($JoinLenght&@CRLF)
   $Compare=$JointCompare/$JoinLenght
   return $Compare
   ;~ ConsoleWrite($Compare&@CRLF)
   ;~ ConsoleWrite('$timer1= ' & TimerDiff($timer1)&@CRLF)
EndFunc

;Определение максимальной длины слов в массиве
Func _Max_Lenght($Split1)
   Dim $LenghtArray[UBound($Split1)]
   For $i=1 to UBound($Split1)-1
	  $LenghtArray[$i]=StringLen($Split1[$i])
   Next
   return _ArrayMax($LenghtArray, 1, 1)
EndFunc

;оригинальная функция сравнения от Yashed
Func _Compare ($Str1, $Str2)
   $Length = StringLen($Str1)
   If ($Length) And (StringLen($Str2) = $Length) Then
	   $Count = 0
	   For $i = 0 To $Length - 1
		   If StringLeft(StringTrimLeft($Str1, $i), 1) = StringLeft(StringTrimLeft($Str2, $i), 1) Then
			   $Count += 1
		   EndIf
		Next
		$Compare = $Count / $Length * 100
;~ 	   ConsoleWrite('Совпадение: ' & $Compare& '%' & @CR)
;~ 	  ConsoleWrite(' ' & $Compare& '%')
	   return $Compare
	Else
	  $Count = 0
	   For $i = 0 To $Length - 1
		   If StringLeft(StringTrimLeft($Str1, $i), 1) = StringLeft(StringTrimLeft($Str2, $i), 1) Then
			   $Count += 1
		   EndIf
		Next
		$Compare = $Count / $Length * 100
	   return $Compare
   EndIf

EndFunc


;Удаление дублей из массива
Func _ArrayRemoveDuplicates(Const ByRef $aArray)
    If Not IsArray($aArray) Then Return SetError(1, 0, 0)
    Local $oSD = ObjCreate("Scripting.Dictionary")
    For $i In $aArray
        $oSD.Item($i) ; shown by wraithdu
    Next
    Return $oSD.Keys()
EndFunc

;Удаление пустых значений в массиве
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






;===============================================================================
; Function Name:    _PathSplitByRegExp()
; Description:      Split the path to 8 elements.
; Parameter(s):     $sPath - Path to split.
; Requirement(s):
; Return Value(s):  On seccess - Array $aRetArray that contain 8 elements:
;                   $aRetArray[0] = Full path ($sPath)
;                   $aRetArray[1] = Drive letter
;                   $aRetArray[2] = Path without FileName and extension
;                   $aRetArray[3] = Full path without File Extension
;                   $aRetArray[4] = Full path without drive letter
;                   $aRetArray[5] = FileName and extension
;                   $aRetArray[6] = Just Filename
;                   $aRetArray[7] = Just Extension of a file
;
;                   On failure - If $sPath not include correct path (the path is not splitable),
;                   then $sPath returned.
;                   If $sPath not include needed delimiters, or it's emty,
;                   then @error set to 1, and returned -1.
;
; Note(s):          The path can include backslash as well (exmp: C:/test/test.zip).
;
; Author(s):        G.Sandler a.k.a CreatoR (MsCreatoR) - Thanks to amel27 for help with RegExp
;===============================================================================
Func _PathSplitByRegExp($sPath)
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8], $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

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