#include <log.au3>
$hLog = _Log_Open(@ScriptDir & '\avtobest-18.09.log', '### ��� ���������  ###')
HotKeySet("{Scrolllock}", "Terminate") ;�������� ������� ��� �������
HotKeySet("{Ins}", "_Pause")
Func Terminate() ;������� ������
TrayTip("���������", "��������� �������, ����� �������� :)", 1500)
	Sleep(1000)
;~ 	_EndWindow()
	Exit 0
EndFunc   ;==>Terminate
global $Paused
Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		If $trayP = 1 Then
			TrayTip("���������", "�����", 1000)
		EndIf
		Sleep(100)
	WEnd
EndFunc   ;==>_Pause


For $i=1 to 120
	$timer = TimerInit()
	WinActivate("[CLASS:Chrome_WidgetWin_1]")
	sleep(300)
	Send("^a")
	sleep(300)
	Send("^c")
	sleep(500)
	$Buffer = ClipGet()
	if Stringinstr($Buffer,"strong")<>0 or Stringinstr($Buffer,"<b>")<>0 Then
		ConsoleWrite("�������� �������� ������!!!!"&@CRLF)
;~ 		exit
	EndIf
	if Stringinstr($Buffer,"������������")<>0 Then
		ConsoleWrite("��������!!"&@CRLF)
		exit
	EndIf
	if Stringinstr($Buffer,"������ ���� ������� ���������")<>0 Then
		ConsoleWrite("��������!! ������ ���� ������� ���������"&@CRLF)
		exit
	EndIf
	$Buffer = StringReplace($Buffer,"</br>","")
	$Buffer = StringRegExpReplace($Buffer,@CRLF&@CRLF,@CRLF)
	$Buffer = StringRegExpReplace($Buffer,@CR&@CR,@CRLF)
	$Buffer = StringRegExpReplace($Buffer,@LF&@LF,@CRLF)
	$Buffer = StringRegExpReplace($Buffer,@CRLF&" "&@CRLF,@CRLF)
	$Buffer = StringRegExpReplace($Buffer,@CRLF&"  "&@CRLF,@CRLF)
	;~ ConsoleWrite($Buffer)
	 _Log_Report($hLog, $Buffer & @CRLF)

	 Send("^r")
	while  TimerDiff($timer)<(65*1000)
		sleep(1000)
;~ 		$color = PixelGetColor(17,5)
		Opt("PixelCoordMode", 0)            ;1=����������, 0=�������������, 2=����������
		$color = PixelGetColor(21,21)
;~ 		$color = PixelGetColor(67,21) ; ���������
		$color = hex($color,6)
		if $color = '1A2349' then exitloop
	wend
;~ 	if TimerDiff($timer)<(3*1000) Then
;~ 		ConsoleWrite("����������� ������. �������� �������� ������!!!!"&@CRLF)
;~ 		_Pause()
;~ 	Endif

next