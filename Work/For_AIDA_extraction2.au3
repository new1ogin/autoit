#include <WindowsConstants.au3>
#include <GUIConstantsEx.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <Array.au3>
#include <GUIConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>

Local $file, $btn, $msg, $hGui
Global $Text, $aArray, $result, $filename, $LANip, $windows, $Antivirus, $processor, $core, $RAM, $ddr, $stripRAM, $partitionC, $partitions

Global $Texto, $ListView, $OneFilePatch, $ThisFilePatch, $schetStrok=0



Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=D:\Vitaliy\PROGRAMS\autoitv3.3.8.1\Koda\hGui.kxf
$hGui = GUICreate("GUI ? ?????????? drag and drop", 601, 292, 192, 125, -1, BitOR($WS_EX_ACCEPTFILES,$WS_EX_WINDOWEDGE))
GUISetOnEvent($GUI_EVENT_CLOSE, "hGuiClose")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "hGuiMinimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "hGuiMaximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "hGuiRestore")
$file = GUICtrlCreateInput("", 10, 5, 504, 21)
GUICtrlSetState(-1, $GUI_DROPACCEPTED)
;~ GUICtrlSetOnEvent(-1, "fileChange")
$hButtonOpenFolder = GUICtrlCreateButton("�����", 522, 5, 72, 20)
GUICtrlSetOnEvent(-1, "hButtonOpenFolderClick")
$btn = GUICtrlCreateButton("OK", 8, 39, 70, 26)
GUICtrlSetOnEvent(-1, "btnClick")
$ListView = GUICtrlCreateListView("����-�|IP(lan)|Win|Antivir|����.��|Q|RAM|DDR|������|���� �|����.%|��� ����|����.%", 8, 88, 585, 193)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 0, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 1, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 2, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 3, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 4, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 5, 15)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 6, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 7, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 8, 20)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 9, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 10, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 11, 50)
GUICtrlSendMsg(-1, $LVM_SETCOLUMNWIDTH, 12, 50)
;~ $ListView_0 = GUICtrlCreateListViewItem("����-�|IP (lan)|Win|Antivir|����.��|����|RAM|DDR|������ ������|���� �|��������, %|��� ����|�������� %", $ListView)
;~ $ListView_1 = GUICtrlCreateListViewItem("����-�2|IP (lan)2|Win2|Antivir2|����.��2|����2|RAM2|DDR2|������ ������2|���� �2|��������, %2|��� ����2|�������� %", $ListView)
;~ $ListView_2 = GUICtrlCreateListViewItem("����-�2|IP (lan)2|Win2|Antivir2|����.��2|����2|RAM2|DDR2|������ ������2|���� �2|��������, %2|��� ����2|�������� %", $ListView)

;~ GUICtrlSetOnEvent(-1, "SetBuffer")
$Copy = GUICtrlCreateButton("����������� ���", 472, 56, 121, 25)
GUICtrlSetOnEvent(-1, "CopyClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###


;~ While 1
;~     Switch GUIGetMsg()
;~         Case $GUI_EVENT_CLOSE
;~             Exit
;~ 	EndSwitch
;~ 	Sleep(100)
;~ WEnd

Func SetBuffer()
;~ 	Local $aItem, $sText, $hListView
;~     ; �������� ����� 2-�� ������
;~ 	$Index = _GUICtrlListView_GetSelectedIndices($ListView)
;~ 	TrayTip('',$Index,500)
;~     $aItem = _GUICtrlListView_GetItemTextArray($ListView, $Index)
;~     For $i = 1 To $aItem[0]
;~         $sText &= StringFormat("�������[%2d] %s", $i, $aItem[$i]) & @TAB
;~ 		$sText &= $aItem[$i] & @TAB
;~     Next
;~ ClipPut($sText)



    $Index = _GUICtrlListView_GetSelectedIndices($ListView)
	ToolTip('������������: '&_GUICtrlListView_GetItemText($ListView, Number($Index)))
	TrayTip('',$Index,500)
    ClipPut(_GUICtrlListView_GetItemText($ListView, Number($Index)))
EndFunc


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

Sleep(100)
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
	$parts = StringRegExp ( $Text, "(?i)<TABLE WIDTH=100%>.*?summary.*?</TABLE><TABLE>(?s).*?(?-s)(�������|Partitions)(?s).*?(?-s)<TR><TD><TD><TD><TD>.*?<TD>([0-9.,]*? ..).*?\(([0-9.,]*? ..)(?s).*?(?-s)(����� �����|Total Size).*?<TD>([0-9.,]*? ..).*?\(([0-9.,]*? ..)(?s).*?(?-s)</TABLE>", 2)
	If Not @error Then $partitions = $parts


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

	$PercFreeDiskC=Round(($partitions[3]/$partitions[2])*100, 2)
	$PercFreeDiskAll=Round(($partitions[6]/$partitions[5])*100, 2)

	GUICtrlCreateListViewItem($filename &'|'& $LANip[1] &'|'& $windows[1] &'|'& $Antivirus[1]&' v.'&$Antivirus[2]&'Update-'&$Antivirus[3] &'|'& $processor[1]  &'|'& $core[1] _
	&'|'& $RAM[4] &'|'& $ddr[4] &'|'& $stripRAM &'|'& $partitions[2] &'|'& $PercFreeDiskC &'|'& $partitions[5] &'|'& $PercFreeDiskAll, $ListView)
	$schetStrok +=1

;~ $aArray=$Antivirus
;~ For $i = 0 To UBound($aArray) - 1
;~     MsgBox(4096, "����=2",   "$aArray[" & $i & "] = " & $aArray[$i])
;~ Next
;~ $filename, $LANip, $windows, $Antivirus, $processor, $core, $RAM, $ddr, $stripRAM, $partitionC, $partitions

EndFunc

;������� ����� ���������� ����� �� ����������
Func FileReadFile($ThisFilePatch)
	$Texto = FileRead($ThisFilePatch, 20) ;�������
	ToolTip($Texto )

	$Text = FileRead($ThisFilePatch)

$filename = StringRegExpReplace($ThisFilePatch, ".+\\(.+)\..+", "\1", 1)
;~ StringRegExpReplace(GUICtrlRead($file)
;~ StringReplace ( GUICtrlRead($file), "searchstring/start", "replacestring" [, -1)
;~ 	TrayTip("drag drop ����", $Texto, 800)
;~ MsgBox(0, "drag drop ����", $Texto, 0, $hGui)
_parameter_extraction()
EndFunc

; �� ������� ������ ��
Func btnClick()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : btnClick() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
ConsoleWrite(GUICtrlRead($file) & @CRLF)
	If StringInStr ( GUICtrlRead($file), "|") <>0 Then
		$OneFilePatch = StringSplit(GUICtrlRead($file), '|')
		For $i=1 To $OneFilePatch[0]
			ConsoleWrite($OneFilePatch[$i] & '   ���������� ������:'& $OneFilePatch[0] & @CRLF)
			FileReadFile($OneFilePatch[$i])
			ConsoleWrite(' ������� ' &@CRLF)
		Next

	Else
;~ 		$OneFilePatch = $file
		FileReadFile(GUICtrlRead($file))
		ConsoleWrite(' ������� ' &@CRLF)
;~ 		_waiting()
	EndIf


EndFunc

;������� ����� ���������� ����� �� ���������� �� ������� ������ Enter
;~ Func fileChange()
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : fileChange() = '  & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ btnClick()
;~ EndFunc

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


Func CopyClick()

	 	Local $aItem, $sText, $hListView
	;~     ; �������� ����� 2-�� ������
	;~ 	$Index = _GUICtrlListView_GetSelectedIndices($ListView)
	;~ 	TrayTip('',$Index,500)
	;~     $aItem = _GUICtrlListView_GetItemTextArray($ListView, $Index)
	;~     For $i = 1 To $aItem[0]
	;~         $sText &= StringFormat("�������[%2d] %s", $i, $aItem[$i]) & @TAB
	;~ 		$sText &= $aItem[$i] & @TAB
	;~     Next
	;~ ClipPut($sText)
	ConsoleWrite($schetStrok & @CRLF)
	For $i=0 To $schetStrok
	;~ _GUICtrlListView_GetItemText($ListView, $i)

		$aItem = _GUICtrlListView_GetItemTextArray($ListView, $i)
			For $i = 1 To $aItem[0]
		;~         $sText &= StringFormat("�������[%2d] %s", $i, $aItem[$i]) & @TAB
				$sText &= $aItem[$i] & @TAB
			Next
		$sText &= @CRLF
		ConsoleWrite($sText & @CRLF)

	;~     $Index = _GUICtrlListView_GetSelectedIndices($ListView)
	;~ 	ToolTip('������������: '&_GUICtrlListView_GetItemText($ListView, $i))
	;~ 	TrayTip('',$Index,500)
	;~     ClipPut(_GUICtrlListView_GetItemText($ListView, Number($Index)))
	Next

	ClipPut($sText)

EndFunc




