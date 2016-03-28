#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <GUIConstants.au3>


Local $file, $btn, $msg, $hGui
Global $Text, $aArray, $result, $filename, $LANip, $windows, $Antivirus, $processor, $core, $RAM, $ddr, $stripRAM, $partitionC, $partitions

Global $Texto



Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=
$hGui = GUICreate("GUI ? ?????????? drag and drop", 381, 161, 192, 125, -1, BitOR($WS_EX_ACCEPTFILES,$WS_EX_WINDOWEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "hGuiClose")
;~ GUISetOnEvent($GUI_EVENT_MINIMIZE, "hGuiMinimize")
;~ GUISetOnEvent($GUI_EVENT_MAXIMIZE, "hGuiMaximize")
;~ GUISetOnEvent($GUI_EVENT_RESTORE, "hGuiRestore")
$file = GUICtrlCreateInput("", 10, 5, 280, 21)
GUICtrlSetData($file, "E:\autoitv3.3.8.1\autoitv3.3.8.1\Work\AIDA64\Reports\104-6(Note).htm")  ;для тестирования
GUICtrlSetOnEvent(-1, "fileChange")
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$hButtonOpenFolder = GUICtrlCreateButton("Обзор", 298, 5, 72, 20)
GUICtrlSetOnEvent(-1, "hButtonOpenFolderClick")
$btn = GUICtrlCreateButton("OK", 8, 39, 70, 26)
GUICtrlSetOnEvent(-1, "btnClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


;~ 	$hGui = GUICreate("GUI с поддержкой drag and drop", 380, 160, @DesktopWidth / 2 - 190, @DesktopHeight / 2 - 80, -1, $WS_EX_ACCEPTFILES)
;~ 	$file = GUICtrlCreateInput('', 10, 5, 360, 20) ; принимает перетаскиваемые в Input файлы (drag and drop)
;~ 	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
;~ 	;~ GUICtrlCreateInput('', 10, 35, 360, 20, -1, $WS_EX_STATICEDGE) ; Стиль трёх-мерный
;~ 	;~ GUICtrlCreateInput('', 10, 65, 360, 22, -1, $WS_EX_DLGMODALFRAME) ; выпуклый
;~ 	;~ GUICtrlCreateInput('', 10, 95, 360, 22, $WS_BORDER)
;~ 	$hButtonOpenFolder = GUICtrlCreateButton('Выбрать папку', 10, 35, 360, 20);кнопка выбора каталога
;~ 	$btn = GUICtrlCreateButton("OK", (380 - 70) / 2, 127, 70, 26)

;~ GUISetState()


;наверное совсем не нужная часть кода, но на всякий случай пусть будет
_waiting()

Func _waiting()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _waiting() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console


$msg = 0
While $msg <> $GUI_EVENT_CLOSE
    $msg = GUIGetMsg()
    Select
        Case $msg = $btn
            ExitLoop

		Case $Msg = $hButtonOpenFolder; нажата кнопка вбора каталога
			$hFolder = FileOpenDialog('Выберите файл для обработки',@ScriptDir, "Html (*.htm; *.html)|Все (*.*)")
            If $hFolder <> '' Then  GUICtrlSetData($file, $hFolder);если пользователь не нажал отмену или не закрыл окно выбора каталога, то заносим полученный путь в поле ввода

    EndSelect
WEnd
EndFunc

;функция отвечает за извлечение информации из отчетов АИДЫ
Func _parameter_extraction()
$time_extraction=TimerInit()



;Антивирус + версия + обновления баз
	$Antivirus = StringRegExp ( $Text, "(?i)<!-- SW -->.*?Anti-Virus.*?</TABLE><TABLE>(?s).*?(?-s)<TR><TD><TD><TD>(?s).*?(?-s)<TR><TD><TD><TD>(.*?)<TD CLASS=cr>(.*?)<TD CLASS=cr>(.*?)<TD CLASS=cr>(?s).*?(?-s)</TABLE>", 2)
	;вырезание пробела &nbsp;
	For $i = 0 To UBound($Antivirus) - 1
	   $Antivirus[$i] = StringReplace ( $Antivirus[$i], "&nbsp;", "" )
	Next


;количество ядер процессора
	$core	= StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?cpuid.*?</TABLE><TABLE>(?s).*?(?-s)<TR><TD><TD><TD><TD>HTT.*(.{2})(?s).*?(?-s)</TABLE>", 2)

;Ип адрес во внутренней сети
	$LANip	= StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?windows network.*?</TABLE><TABLE>(?s).*?(?-s)<TR><TD><TD><TD><TD>IP....*?<TD>(.*?)/(?s).*?(?-s)</TABLE>", 2)

;Версия Windows + разрядность
	$windows = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?operating system.*?</TABLE><TABLE>(?s).*?(?-s)<TR><TD><TD><TD(?s).*?(?-s)<TR><TD><TD><TD><TD>.*?<TD>(.*?)(?m)$(?s).*?(?-s)<TR><TD><TD><TD><TD>.*?<TD>.*?\((..)-bit\)(?s).*?(?-s)</TABLE>", 2)

;Процессор с информацией
	$processor = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)CPU Type.*?<TD><.*?>(.*?)<(?s).*?(?-s)</TABLE>", 2)
	$processor = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)Тип ЦП.*?<TD><.*?>(.*?)<(?s).*?(?-s)</TABLE>", 2)

;количество занятых плашек оперативной памяти   $stripRAM   + общая системная память $RAM[4]
	$RAM = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)(<TR><TD><TD>.*?(Системная плата|Motherboard)(?s).*?(?-s)<TR><TD><TD><TD><TD>(Системная память|System Memory).*<TD>(\d*) (?s).*?(?-s)<TR><TD>&nbsp;)(?s).*?(?-s)</TABLE>", 2)
if not @error then
   stringreplace ($RAM[1], 'DIMM', "dimm")
   $stripRAM = @extended
EndIf

;Вид оперативной памяти DDR, $ddr[4]
	$ddr = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)(<TR><TD><TD>.*?(Системная плата|Motherboard)(?s).*?(?-s)<TR><TD><TD><TD><TD>(Системная память|System Memory).*\((.*)\)(?s).*?(?-s)<TR><TD>&nbsp;)(?s).*?(?-s)</TABLE>", 2)

;Размер разделов, и свободное место
;Раздел С:  $partitions[2]   свободно: $partitions[3]
;Общий размер всех азделов: $partitions[5]   свободно: $partitions[6]
	$partitions = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)(Разделы|Partitions)(?s).*?(?-s)<TR><TD><TD><TD><TD>.*?<TD>([0-9.,]*? ..).*?\(([0-9.,]*? ..)(?s).*?(?-s)(Общий объём|Total Size).*?<TD>([0-9.,]*? ..).*?\(([0-9.,]*? ..)(?s).*?(?-s)</TABLE>", 2)


;~ 	"<!-- SW -->.*?Anti-Virus.*?</TABLE><TABLE>.*?<TR><TD><TD><TD>.*?<TR><TD><TD><TD>(.*?)<TD CLASS=cr>(.*?)<TD CLASS=cr>(.*?)<TD CLASS=cr>(.*?)</TABLE>"

;~ <A NAME="anti-virus">(Антивирус)</A>
;~ 	StringRegExpReplace ( "test", "pattern", "replace", [count] )
;~ Номер кабинета	Номер компьютера	IP адрес	Версия Windows	Антивирусное ПО	Частота процессора	Кол-во ядер процессора	Размер RAM	Тип RAM DDR(x)	Кол-во плашек RAM
;~
;~ 101	1 (ноутбук)	192.168.1.78	Microsoft Windows 7 Professional (32-bit)	AVG Free	Celeron(R) Dual-Core CPU T3100 @ 1.90GHz	2	2 GB (2 ranks, 8 banks)	DDR3-1066 (533 MHz)	1

;~ $filename, $LANip, $windows, $Antivirus, $processor, $core, $RAM, $ddr, $stripRAM, $partitionC, $partitions

;~ TimerDiff($time_extraction)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($time_extraction) = ' & TimerDiff($time_extraction) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

_display_information()

EndFunc

;вспомогательная функция верезание пробела (не работает)
Func _Delete_nbsp($name)

	;вырезание пробела &nbsp;
	For $i = 0 To UBound($name) - 1
	   $name[$i] = StringReplace ( $name[$i], "&nbsp;", "" )
	Next

EndFunc


;функция отвечает за передачю извлеченной информации на отображение
Func _display_information()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _display_information() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : UBound($aArray) = ' & UBound($aArray) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

$aArray=$partitionC
For $i = 0 To UBound($aArray) - 1
    MsgBox(4096, "флаг=2",   "$aArray[" & $i & "] = " & $aArray[$i])
Next
;~ $filename, $LANip, $windows, $Antivirus, $processor, $core, $RAM, $ddr, $stripRAM, $partitionC, $partitions

EndFunc

;передаёт текст выбранного файла на извлечение по нажатию кнопки ок
Func btnClick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : btnClick() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

	$Texto = FileRead(GUICtrlRead($file), 20) ;отладка
		ToolTip($Texto )

	$Text = FileRead(GUICtrlRead($file))

$filename = StringRegExpReplace(GUICtrlRead($file), ".+\\(.+)\..+", "\1", 1)
;~ StringRegExpReplace(GUICtrlRead($file)
;~ StringReplace ( GUICtrlRead($file), "searchstring/start", "replacestring" [, -1)
;~ 	TrayTip("drag drop файл", $Texto, 800)
;~ MsgBox(0, "drag drop файл", $Texto, 0, $hGui)
_parameter_extraction()
EndFunc

;передаёт текст выбранного файла на извлечение по нажатию кнопки Enter
Func fileChange()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : fileChange() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
btnClick()
EndFunc

;действие на кнопку Обзор
Func hButtonOpenFolderClick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hButtonOpenFolderClick() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 	MsgBox(0, "drag drop файл", 'Выберите файл для обработки', 0, $hGui)
            $hFolder = FileOpenDialog('Выберите файл для обработки',@ScriptDir, "Html (*.htm; *.html)|Все (*.*)")
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