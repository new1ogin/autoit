HotKeySet("{Esc}", "Terminate")
Func Terminate()
	 TrayTip("���������", "��������� �������, ����� �������� :)", 1500)
	sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

$slp=9
$Startchange = InputBox(" ����� "," ������� ����� ������ ������������ ����. 1 - 1� ����������� ; 2 - 1� ������������ ",1)
$timeoutStart=0
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

while 1
		;������������� ����������
	$thwnd=0
	$thwnd='[TITLE:������������� ����������;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists($thwnd) = ' & WinExists($thwnd)& @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlsend($thwnd,'','',"^{Enter}")
		sleep($slp*3000)
		winclose("������������ - ����������� �����������, �������� 2.0")
		sleep(1000)
		if WinExists('1�:�����������') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*2000)
		Run("C:\Program Files\1cv82\common\1cestart.exe")
		$Startchange = 1
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf

	;�������� ����������� ��������� ����������
	$thwnd=0
	$thwnd='[TITLE:�������� ����������� ��������� ����������;CLASS:V8NewLocalFrameBaseWnd]'
	  if WinExists($thwnd)=1 Then
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlclick($thwnd,'','[CLASS:V8CommandBar; INSTANCE:1]')
				WinActivate($thwnd)
		controlSend($thwnd,'','',"{Enter}")
		controlSend($thwnd,'','',"{Enter}")
		sleep($slp*5000)
		winclose('1�:����������� - ���� �����������')
		sleep(1000)
		if WinExists('1�:�����������') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*2000)
		Run("C:\Program Files\1cv82\common\1cestart.exe")
		$Startchange = 2
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf

	; ��������� ��������� � ����-�� � �������������
	$thwnd=0
	$thwnd='[TITLE:������������;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') ��������� ��������� � ����-�� � ������������� : WinExists($thwnd) = ' & WinExists($thwnd) &  '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlSend($thwnd,'','',"{Enter}")
	EndIf


	; ���������� ���������� � ����
	$thwnd=0
;~ 	$thwnd='[TITLE:������������;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists(''[CLASS:V8NewLocalFrameBaseWnd]'') = ' & WinExists('[CLASS:V8NewLocalFrameBaseWnd]')& @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*3000)
;~ 		winclose('1�:����������� - ���� �����������')
		sleep(1000)
		if WinExists('1�:�����������') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		sleep($slp*2000)
		Run("C:\Program Files\1cv82\common\1cestart.exe")
		$Startchange = 2
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf

	; ������ $Startchange = 1
	$thwnd=0
	$thwnd='[TITLE:������ 1�:�����������;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then

		 WinActivate($thwnd)
		 if timerdiff($timeoutStart) > 15000 then
			 $timeoutStart= Timerinit()
			if $Startchange = 1 then
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:10]')
				send('{Enter}')
				ConsoleWrite(" ������ 1� �����������" & @CRLF)
			Else
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:11]')
				send('{Enter}')
				ConsoleWrite(" ������ 1� ������������" & @CRLF)
			endif
		endif
	EndIf

	if $Startchange = 2 Then
		$thwnd=0
		$thwnd='������������ - ����������� �����������, �������� 2.0'
		if WinExists($thwnd)=1 Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists($thwnd) = ' & WinExists($thwnd)& @CRLF) ;### Debug Console
			BlockInput(1)
			WinActivate($thwnd)
			Opt("SendKeyDelay", 64)          ;5 �����������
			Opt("SendKeyDownDelay", 10)      ;1 ������������
			Opt("MouseCoordMode", 2)        ;1=����������, 0=�������������, 2=����������

			;������� ������������
			ControlSend($thwnd,'','','{Alt}')
			sleep(200)
			ControlSend($thwnd,'','','{Right}')
			sEND('�')
			ControlSend($thwnd,'','','{Right}')
			sleep(200)
			ControlSend($thwnd,'','','{Enter}')
			send ("{Enter}")
			sleep($slp*500)
			;������� ����������
			ControlSend($thwnd,'','','{Alt}')
			sleep(200)
			ControlSend($thwnd,'','','{Right}')
			sEND('�')
			ControlSend($thwnd,'','','{Right}')
			;ControlSend($thwnd,'','','{Right}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{down}')
			ControlSend($thwnd,'','','{Right}')
			ControlSend($thwnd,'','','{Enter}')
			sleep(200)
			ControlSend($thwnd,'','','{Enter}')
			ControlSend($thwnd,'','','{Enter}')
			ControlSend($thwnd,'','','{Enter}')
			ControlClick($thwnd,'','','left',1,154,69)
			ControlClick($thwnd,'','','left',1,154,69)
			ControlClick($thwnd,'','','left',1,154,69)
			MouseMove(154,69)
			MouseClick('left')
			sleep(20)
			MouseClick('left')
			sleep(300)
			send ("^{Enter}")
			sleep(200)
			send ("^{Enter}")
			BlockInput(0)
			$Startchange = 1
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

		EndIf
	endif

	sleep(500)
WEnd

