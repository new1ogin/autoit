	#Include <WinAPIEx.au3>


HotKeySet("{Esc}", "Terminate")
Func Terminate()
	 TrayTip("���������", "��������� �������, ����� �������� :)", 1500)
	sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

			Opt("WinTitleMatchMode", 3)
			Opt("SendKeyDelay", 64)          ;5 �����������
			Opt("SendKeyDownDelay", 10)      ;1 ������������
			Opt("MouseCoordMode", 2)        ;1=����������, 0=�������������, 2=����������

$slp=3
$Startchange = InputBox(" ����� "," ������� ����� ������ ������������ ����. 1 - 1� ����������� ; 2 - 1� ������������ ",1)
$CloseWinPp=0
$timeoutStart=0
$timerExitPp=0
$timerExitKonfigurator=0
$thwnd=0
$thwnd2=0
$thwnd3=0
$thwnd4=0
$namePp= "1�:����������� - "

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console

while 1

	Opt("WinTitleMatchMode", 1)
	$thwnd = WinGetTitle('���������� ���������')
	Opt("WinTitleMatchMode", 3)
	if WinExists($thwnd)=1 and WinActive($thwnd)<>0 then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WinActivate($thwnd)
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:5]')
		MouseMove(453,536)
		sleep(200)
		MouseClick('left')
		sleep(200)
		MouseClick('left')

			$thwnd = '���������� ������������'
			WinWait($thwnd)
			WinActivate($thwnd)
			send ('{TAB}')
			send ('{TAB}')
			send ('{Enter}')

	endif

	;���������� ����������
;~ 	$thwnd = WinGetHandle('���������� ������������')
	$thwnd = '���������� ������������'
	if WinExists($thwnd)=1 and WinActive($thwnd)<>0  then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$aData = _WinAPI_EnumChildWindows($thwnd)
		if not @error then
			if $aData[0][0] = 44 Then
				MsgBox(0,"","���-�� "& $aData[0][0])
				WinWait($thwnd)
				WinActivate($thwnd)
				send ('{TAB}')
				send ('{TAB}')
				send ('{Enter}')
				sleep(10000)
			EndIf
		EndIf
	EndIf

	;�������� ����������� ��������� ����������
	Opt("WinTitleMatchMode", 1)
	$thwnd = WinGetTitle('����������� ��������� ���������� - ')
	Opt("WinTitleMatchMode", 3)
	  if WinExists($thwnd)=1 Then
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:10]')
		controlclick($thwnd,'','[CLASS:V8CommandBar; INSTANCE:1]')
				WinActivate($thwnd)
		controlSend($thwnd,'','',"{Enter}")
		controlSend($thwnd,'','',"{Enter}")

			$thwnd = '���������� ������������'
			WinWait($thwnd)
			WinActivate($thwnd)
			sleep($slp*3000)
			send ('{TAB}')
			send ('{TAB}')
			send ('{TAB}')
			sleep(1000)
			send ('{Enter}')

;~ 		Opt("WinTitleMatchMode", 1)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
;~ 		$thwnd = WinGetTitle ( $namePp )
;~ 		Opt("WinTitleMatchMode", 3)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase

;~ 			_winclose($thwnd)
;~ 	;~ 			_winclose('1�:����������� - �������� � ���������� ����������, �������� 2.5')
;~ 		sleep(1000)
;~ 		$thwnd = '1�:�����������'
;~ 		if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*2000)
;~ 		Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 		$Startchange = 2
;~ 		$CloseWinPp=1
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
	EndIf

;~ 	if WinExists($namePp2) then
;~ 		$namePp = $namePp2
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $namePp = ' & $namePp & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	EndIf

	;�������� ����������� ����
	$thwnd='1�:�����������. ������ � �������������� ����'
	if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		WinActivate($thwnd)

		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:5]')
		controlsend($thwnd,'','',"{Enter}")
	EndIf

		;�������� ������
;~ 	$thwnd=0
;~ 	$thwnd='[TITLE:1�:�����������;CLASS:V8NewLocalFrameBaseWnd; W:450; H:119]'
;~ 	 if WinExists($thwnd)=1 Then
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		WinActivate($thwnd)
;~ 		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		controlsend($thwnd,'','',"{Enter}")
;~ 	EndIf

	;�������� ����������� ����
;~ 	Style:	0x96C81000
;~ ExStyle:	0x00000100
	$thwnd=0
	$thwnd='[TITLE:1�:�����������;CLASS:V8NewLocalFrameBaseWnd; W:516; H:101]'
	 if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WinActivate($thwnd)
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:2]')
		controlsend($thwnd,'','',"{Enter}")
	EndIf
	$thwnd='[TITLE:1�:�����������;CLASS:V8NewLocalFrameBaseWnd; W:224; H:101]'
	 if WinExists($thwnd)=1 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
	EndIf

		;������������� ����������
	$thwnd=0
	$thwnd='[TITLE:������������� ����������;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		 $timerExitKonfigurator = 0
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists($thwnd) = ' & WinExists($thwnd)& @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlsend($thwnd,'','',"^{Enter}")
		_CloseConfigurator()
		_runPp()
	EndIf




	;�������� ����������� ��������� ����������
	$thwnd='[TITLE:�������� ����������� ��������� ����������;CLASS:V8NewLocalFrameBaseWnd]'
	  if WinExists($thwnd)=1 Then
		  ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlclick($thwnd,'','[CLASS:V8CommandBar; INSTANCE:1]')
				WinActivate($thwnd)
		controlSend($thwnd,'','',"{Enter}")
		controlSend($thwnd,'','',"{Enter}")
;~ 		_ClosePp()
		_runConfigurator()
	EndIf





	;������ �������������
	$thwnd='[TITLE:������������;CLASS:V8NewLocalFrameBaseWnd; W:552; H:127]'
	 if WinExists($thwnd)=1 Then
		 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WinActivate($thwnd)
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:2]')
		controlSend($thwnd,'','',"{Esc}")
		$timerExitKonfigurator = Timerinit()+5000
	EndIf

	; ��������� ����������� ����-�� � �������������
	$thwnd='[TITLE:������������;CLASS:V8NewLocalFrameBaseWnd]'
	 if WinExists($thwnd)=1 Then
		 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') ��������� ��������� � ����-�� � ������������� : WinExists($thwnd) = ' & WinExists($thwnd) &  '>Error code: ' & @error & @CRLF) ;### Debug Console
		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		controlSend($thwnd,'','',"{Enter}")
		$timerExitKonfigurator = Timerinit()
	EndIf
	if $timerExitKonfigurator<>0 and TimerDiff($timerExitKonfigurator) > $slp*5000 then
		$timerExitKonfigurator=0
		ConsoleWrite(" ����� �� ������������� �� �������� ")
		$thwnd='������������ - ����������� �����������, �������� 2.0'
		$thwnd2='������������ - ����������� �����������, �������� 2.0'
		_CloseConfigurator()
		_runPp()

	EndIf



	; ���������� ���������� � ����
;~ 	$thwnd='[TITLE:������������;CLASS:V8NewLocalFrameBaseWnd]'
;~ 	 if WinExists($thwnd)=1 Then
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists(''[CLASS:V8NewLocalFrameBaseWnd]'') = ' & WinExists('[CLASS:V8NewLocalFrameBaseWnd]')& @CRLF) ;### Debug Console
;~ 		controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*3000)
;~ 	;~ 		_winclose('1�:����������� - ���� �����������')
;~ 		sleep(1000)
;~ 		if WinExists('1�:�����������') then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*2000)
;~ 		Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 		$Startchange = 2
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
;~ 	EndIf

	; ������ $Startchange = 1
	$thwnd='[TITLE:������ 1�:�����������;CLASS:V8NewLocalFrameBaseWnd]'
	if WinExists($thwnd)=1 Then
		_startFromStartWindow()

	EndIf

	if $Startchange = 2 Then
		$thwnd='������������ - ����������� �����������, �������� 2.0'
		$thwnd2='������������ - �������� � ���������� ����������, �������� 2.5'
		Opt("WinTitleMatchMode", 1)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
		$thwnd = WinGetTitle ( "������������ - " )
		Opt("WinTitleMatchMode", 3)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase

;~ 		$thwnd3='������������ - ����������� �����������, �������� 2.0'
;~ 		$thwnd4='������������ - ����������� �����������, �������� 2.0'
		if WinExists($thwnd)=1 or WinExists($thwnd2)=1 or WinExists($thwnd3)=1 or WinExists($thwnd4)=1 Then
		if WinActive($thwnd)<>0 then
			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			BlockInput(1)
			WinActivate($thwnd)
			Opt("SendKeyDelay", 64)          ;5 �����������
			Opt("SendKeyDownDelay", 10)      ;1 ������������
			Opt("MouseCoordMode", 2)        ;1=����������, 0=�������������, 2=����������

			; ������� ������������
			ControlSend($thwnd,'','','{Alt}')
			sleep(200)
			ControlSend($thwnd,'','','{Right}')
			sEND('�')
			ControlSend($thwnd,'','','{Right}')
			ControlSend($thwnd,'','','{Enter}')
			ControlSend($thwnd,'','','{Alt}')
			sleep($slp*500)
			; ��������� ����������
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
			sleep(300)
			Send('^c')
			sleep(100)
			Send('^{Ins}')
			sleep(100)
			ConsoleWrite( @CRLF & Clipget() & @CRLF)
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
		EndIf
	endif

	$thwnd='1�:����������� - ���� �����������'
	$thwnd2='1�:����������� - ���� �����������'
	Opt("WinTitleMatchMode", 1)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
	$thwnd = WinGetTitle ( $namePp )
	Opt("WinTitleMatchMode", 3)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
;~ 	$thwnd3='������������ - ����������� �����������, �������� 2.0'
;~ 	$thwnd4='������������ - ����������� �����������, �������� 2.0'
	if $CloseWinPp=1 then
		if WinExists($thwnd)=1 or WinExists($thwnd2)=1 or WinExists($thwnd3)=1 or WinExists($thwnd4)=1 Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			_ClosePp()
		EndIf
	Else
		if $timerExitPp=0 and WinExists($thwnd)=1 then
			$timerExitPp=timerinit()
			ConsoleWrite('�������� ���������� ���� �����������' & @CRLF)
		EndIf
		if $timerExitPp<>0 and WinExists($thwnd)=1 then
			if TimerDiff($timerExitPp) > $slp*5000 Then ConsoleWrite('|')
			if TimerDiff($timerExitPp) > $slp*10000 Then
				$timerExitPp=0
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $timerExitPp = ' & $timerExitPp & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				_ClosePp(0)
				_runConfigurator()

			EndIf
		EndIf
	EndIf
	$thwnd='������������� �������� ������ ������������'
 	$thwnd2='������������� �������� ������ ������������'
;~ 	$thwnd3='������������ - ����������� �����������, �������� 2.0'
;~ 	$thwnd4='������������ - ����������� �����������, �������� 2.0'
	if WinExists($thwnd)=1 or WinExists($thwnd2)=1 or WinExists($thwnd3)=1 or WinExists($thwnd4)=1 Then
			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
			WinActivate($thwnd)
			Opt("SendKeyDelay", 64)          ;5 �����������
			Opt("SendKeyDownDelay", 10)      ;1 ������������
			Opt("MouseCoordMode", 2)        ;1=����������, 0=�������������, 2=����������
		ConsoleWrite(' ������������� �������� ������ �����' &@CRLF)
		ControlSend($thwnd,'','','{Tab}')
		ControlSend($thwnd,'','','{Enter}')
	endif


	sleep(500)
WEnd

func _winclose($win)
	ConsoleWrite(' ������� ������� ����: ' & $win) ; StringLeft($win,10))
	for $i=0 to 99
		if WinExists($win)=0 then
			ConsoleWrite(' ; ������� ����: ' & StringLeft($win,10) &"..." &@CRLF)
			Return
		EndIf
		WinClose($win)
			$thwnd=0
			$thwnd='[TITLE:1�:�����������;CLASS:V8NewLocalFrameBaseWnd; W:516; H:101]'
			 if WinExists($thwnd)=1 Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				WinActivate($thwnd)
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:2]')
				controlsend($thwnd,'','',"{Enter}")
				sleep($slp*1000)
			EndIf
			$thwnd='[TITLE:1�:�����������;CLASS:V8NewLocalFrameBaseWnd; W:224; H:101]'
			 if WinExists($thwnd)=1 Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
				controlsend($thwnd,'','',"{Enter}")
			EndIf
		sleep(100)
	Next
EndFunc


func _CloseConfigurator()
;~ 	sleep($slp*3000)
;~ 		$thwnd='������������ - ����������� �����������, �������� 2.0'
;~ 		$thwnd2='������������ - ����������� �����������, �������� 2.0'
;~ 		Opt("WinTitleMatchMode", 1)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
;~ 		$thwnd = WinGetTitle ( "������������ - " )
;~ 		Opt("WinTitleMatchMode", 3)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase

	;~ 		$thwnd3='������������ - ����������� �����������, �������� 2.0'
	;~ 		$thwnd4='������������ - ����������� �����������, �������� 2.0'
;~ 			if  WinExists($thwnd2)=1 then $thwnd=$thwnd2
;~ 			if  WinExists($thwnd3)=1 then $thwnd=$thwnd3
;~ 			if  WinExists($thwnd4)=1 then $thwnd=$thwnd4
;~ 		_winclose($thwnd)
;~ 		sleep(1000)
;~ 		$thwnd = '1�:�����������'
;~ 		if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
;~ 		sleep($slp*2000)
;~ 		Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 		$Startchange = 1
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
EndFunc

func _runConfigurator()
;~ 		sleep($slp*2000)
;~ 		Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 		$Startchange = 2
;~ 		$CloseWinPp=1
;~ 		ConsoleWrite('@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
EndFunc

func _ClosePp($slpCpp=$slp)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _ClosePp() = ' &'>Error code: ' & @error & @CRLF) ;### Debug Console

	sleep($slpCpp*5000)

		Opt("WinTitleMatchMode", 1)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
		$thwnd = WinGetTitle ( $namePp )
		Opt("WinTitleMatchMode", 3)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase

			_winclose($thwnd)
	;~ 			_winclose('1�:����������� - �������� � ���������� ����������, �������� 2.5')
		sleep(1000)
		$thwnd = '1�:�����������'
		if WinExists($thwnd) then controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:3]')
		$Startchange=2


				sleep($slp*1000)
		Opt("WinTitleMatchMode", 1)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
		$thwnd = WinGetTitle ( "������������ - " )
		Opt("WinTitleMatchMode", 3)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
		winactivate($thwnd)
	$timerExitPp=0
	EndFunc

		func _runPp()
		sleep($slp*1000)
		Opt("WinTitleMatchMode", 1)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
		$thwnd = WinGetTitle ( "������������ - " )
		Opt("WinTitleMatchMode", 3)     ;1=� �������, 2=��������, 3=�����, 4=���������, -1 to -4=Nocase
		winactivate($thwnd)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $thwnd = ' & $thwnd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		send('^{F5}')


;~ 			sleep($slp*2000)
;~ 			Run("C:\Program Files\1cv82\common\1cestart.exe")
;~ 			$Startchange = 1
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Startchange = ' & $Startchange& @CRLF) ;### Debug Console
		EndFunc

func _startFromStartWindow()
;~ 			 WinActivate($thwnd)
;~ 		 if timerdiff($timeoutStart) > 15000 then
;~ 			 $timeoutStart= Timerinit()
;~ 			if $Startchange = 1 then
;~ 				$CloseWinPp=0
;~ 				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:10]')
;~ 				send('{Enter}')
;~ 				ConsoleWrite(" ������ 1� �����������" & @CRLF)
;~ 			Else
;~ 				controlclick($thwnd,'','[CLASS:V8FormElement; INSTANCE:11]')
;~ 				send('{Enter}')
;~ 				ConsoleWrite(" ������ 1� ������������" & @CRLF)
;~ 			endif
;~ 		endif
EndFunc


