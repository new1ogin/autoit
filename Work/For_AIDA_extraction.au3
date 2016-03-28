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
GUICtrlSetData($file, "E:\autoitv3.3.8.1\autoitv3.3.8.1\Work\AIDA64\Reports\104-6(Note).htm")  ;��� ������������
GUICtrlSetOnEvent(-1, "fileChange")
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
$hButtonOpenFolder = GUICtrlCreateButton("�����", 298, 5, 72, 20)
GUICtrlSetOnEvent(-1, "hButtonOpenFolderClick")
$btn = GUICtrlCreateButton("OK", 8, 39, 70, 26)
GUICtrlSetOnEvent(-1, "btnClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


;~ 	$hGui = GUICreate("GUI � ���������� drag and drop", 380, 160, @DesktopWidth / 2 - 190, @DesktopHeight / 2 - 80, -1, $WS_EX_ACCEPTFILES)
;~ 	$file = GUICtrlCreateInput('', 10, 5, 360, 20) ; ��������� ��������������� � Input ����� (drag and drop)
;~ 	GUICtrlSetState(-1, $GUI_DROPACCEPTED)
;~ 	;~ GUICtrlCreateInput('', 10, 35, 360, 20, -1, $WS_EX_STATICEDGE) ; ����� ���-������
;~ 	;~ GUICtrlCreateInput('', 10, 65, 360, 22, -1, $WS_EX_DLGMODALFRAME) ; ��������
;~ 	;~ GUICtrlCreateInput('', 10, 95, 360, 22, $WS_BORDER)
;~ 	$hButtonOpenFolder = GUICtrlCreateButton('������� �����', 10, 35, 360, 20);������ ������ ��������
;~ 	$btn = GUICtrlCreateButton("OK", (380 - 70) / 2, 127, 70, 26)

;~ GUISetState()


;�������� ������ �� ������ ����� ����, �� �� ������ ������ ����� �����
_waiting()

Func _waiting()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _waiting() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console


$msg = 0
While $msg <> $GUI_EVENT_CLOSE
    $msg = GUIGetMsg()
    Select
        Case $msg = $btn
            ExitLoop

		Case $Msg = $hButtonOpenFolder; ������ ������ ����� ��������
			$hFolder = FileOpenDialog('�������� ���� ��� ���������',@ScriptDir, "Html (*.htm; *.html)|��� (*.*)")
            If $hFolder <> '' Then  GUICtrlSetData($file, $hFolder);���� ������������ �� ����� ������ ��� �� ������ ���� ������ ��������, �� ������� ���������� ���� � ���� �����

    EndSelect
WEnd
EndFunc

;������� �������� �� ���������� ���������� �� ������� ����
Func _parameter_extraction()
$time_extraction=TimerInit()



;��������� + ������ + ���������� ���
	$Antivirus = StringRegExp ( $Text, "(?i)<!-- SW -->.*?Anti-Virus.*?</TABLE><TABLE>(?s).*?(?-s)<TR><TD><TD><TD>(?s).*?(?-s)<TR><TD><TD><TD>(.*?)<TD CLASS=cr>(.*?)<TD CLASS=cr>(.*?)<TD CLASS=cr>(?s).*?(?-s)</TABLE>", 2)
	;��������� ������� &nbsp;
	For $i = 0 To UBound($Antivirus) - 1
	   $Antivirus[$i] = StringReplace ( $Antivirus[$i], "&nbsp;", "" )
	Next


;���������� ���� ����������
	$core	= StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?cpuid.*?</TABLE><TABLE>(?s).*?(?-s)<TR><TD><TD><TD><TD>HTT.*(.{2})(?s).*?(?-s)</TABLE>", 2)

;�� ����� �� ���������� ����
	$LANip	= StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?windows network.*?</TABLE><TABLE>(?s).*?(?-s)<TR><TD><TD><TD><TD>IP....*?<TD>(.*?)/(?s).*?(?-s)</TABLE>", 2)

;������ Windows + �����������
	$windows = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?operating system.*?</TABLE><TABLE>(?s).*?(?-s)<TR><TD><TD><TD(?s).*?(?-s)<TR><TD><TD><TD><TD>.*?<TD>(.*?)(?m)$(?s).*?(?-s)<TR><TD><TD><TD><TD>.*?<TD>.*?\((..)-bit\)(?s).*?(?-s)</TABLE>", 2)

;��������� � �����������
	$processor = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)CPU Type.*?<TD><.*?>(.*?)<(?s).*?(?-s)</TABLE>", 2)
	$processor = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)��� ��.*?<TD><.*?>(.*?)<(?s).*?(?-s)</TABLE>", 2)

;���������� ������� ������ ����������� ������   $stripRAM   + ����� ��������� ������ $RAM[4]
	$RAM = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)(<TR><TD><TD>.*?(��������� �����|Motherboard)(?s).*?(?-s)<TR><TD><TD><TD><TD>(��������� ������|System Memory).*<TD>(\d*) (?s).*?(?-s)<TR><TD>&nbsp;)(?s).*?(?-s)</TABLE>", 2)
if not @error then
   stringreplace ($RAM[1], 'DIMM', "dimm")
   $stripRAM = @extended
EndIf

;��� ����������� ������ DDR, $ddr[4]
	$ddr = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)(<TR><TD><TD>.*?(��������� �����|Motherboard)(?s).*?(?-s)<TR><TD><TD><TD><TD>(��������� ������|System Memory).*\((.*)\)(?s).*?(?-s)<TR><TD>&nbsp;)(?s).*?(?-s)</TABLE>", 2)

;������ ��������, � ��������� �����
;������ �:  $partitions[2]   ��������: $partitions[3]
;����� ������ ���� �������: $partitions[5]   ��������: $partitions[6]
	$partitions = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)(�������|Partitions)(?s).*?(?-s)<TR><TD><TD><TD><TD>.*?<TD>([0-9.,]*? ..).*?\(([0-9.,]*? ..)(?s).*?(?-s)(����� �����|Total Size).*?<TD>([0-9.,]*? ..).*?\(([0-9.,]*? ..)(?s).*?(?-s)</TABLE>", 2)


;~ 	"<!-- SW -->.*?Anti-Virus.*?</TABLE><TABLE>.*?<TR><TD><TD><TD>.*?<TR><TD><TD><TD>(.*?)<TD CLASS=cr>(.*?)<TD CLASS=cr>(.*?)<TD CLASS=cr>(.*?)</TABLE>"

;~ <A NAME="anti-virus">(���������)</A>
;~ 	StringRegExpReplace ( "test", "pattern", "replace", [count] )
;~ ����� ��������	����� ����������	IP �����	������ Windows	������������ ��	������� ����������	���-�� ���� ����������	������ RAM	��� RAM DDR(x)	���-�� ������ RAM
;~
;~ 101	1 (�������)	192.168.1.78	Microsoft Windows 7 Professional (32-bit)	AVG Free	Celeron(R) Dual-Core CPU T3100 @ 1.90GHz	2	2 GB (2 ranks, 8 banks)	DDR3-1066 (533 MHz)	1

;~ $filename, $LANip, $windows, $Antivirus, $processor, $core, $RAM, $ddr, $stripRAM, $partitionC, $partitions

;~ TimerDiff($time_extraction)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($time_extraction) = ' & TimerDiff($time_extraction) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

_display_information()

EndFunc

;��������������� ������� ��������� ������� (�� ��������)
Func _Delete_nbsp($name)

	;��������� ������� &nbsp;
	For $i = 0 To UBound($name) - 1
	   $name[$i] = StringReplace ( $name[$i], "&nbsp;", "" )
	Next

EndFunc


;������� �������� �� �������� ����������� ���������� �� �����������
Func _display_information()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _display_information() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : UBound($aArray) = ' & UBound($aArray) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

$aArray=$partitionC
For $i = 0 To UBound($aArray) - 1
    MsgBox(4096, "����=2",   "$aArray[" & $i & "] = " & $aArray[$i])
Next
;~ $filename, $LANip, $windows, $Antivirus, $processor, $core, $RAM, $ddr, $stripRAM, $partitionC, $partitions

EndFunc

;������� ����� ���������� ����� �� ���������� �� ������� ������ ��
Func btnClick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : btnClick() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

	$Texto = FileRead(GUICtrlRead($file), 20) ;�������
		ToolTip($Texto )

	$Text = FileRead(GUICtrlRead($file))

$filename = StringRegExpReplace(GUICtrlRead($file), ".+\\(.+)\..+", "\1", 1)
;~ StringRegExpReplace(GUICtrlRead($file)
;~ StringReplace ( GUICtrlRead($file), "searchstring/start", "replacestring" [, -1)
;~ 	TrayTip("drag drop ����", $Texto, 800)
;~ MsgBox(0, "drag drop ����", $Texto, 0, $hGui)
_parameter_extraction()
EndFunc

;������� ����� ���������� ����� �� ���������� �� ������� ������ Enter
Func fileChange()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : fileChange() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
btnClick()
EndFunc

;�������� �� ������ �����
Func hButtonOpenFolderClick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hButtonOpenFolderClick() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 	MsgBox(0, "drag drop ����", '�������� ���� ��� ���������', 0, $hGui)
            $hFolder = FileOpenDialog('�������� ���� ��� ���������',@ScriptDir, "Html (*.htm; *.html)|��� (*.*)")
            If $hFolder <> '' Then  GUICtrlSetData($file, $hFolder);���� ������������ �� ����� ������ ��� �� ������ ���� ������ ��������, �� ������� ���������� ���� � ���� �����

;~             $hFile = FileOpenDialog('�������� ���� ��� ���������',@ScriptDir, "Html (*.htm; *.html)|��� (*.*)")
;~             If $hFile <> '' Then  GUICtrlSetData($file, $hFile);���� ������������ �� ����� ������ ��� �� ������ ���� ������ ��������, �� ������� ���������� ���� � ���� �����


EndFunc

;�������� ���������
Func hGuiClose()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hGuiClose() = ' & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 	MsgBox(262144,'Debug line ~' & @ScriptLineNumber,'Selection:' & @lf & 'hGuiClose()' & @lf & @lf & 'Return:' & @lf & hGuiClose()) ;### Debug MSGBOX
exit
EndFunc

;�������� ��� ������� �� ������
Func hGuiMaximize()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hGuiMaximize() = ' & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

EndFunc

;�������� ��� ������� �� ������
Func hGuiMinimize()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hGuiMinimize() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

EndFunc

;�������� ��� ������� �� ������
Func hGuiRestore()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : hGuiRestore() = ' & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

EndFunc