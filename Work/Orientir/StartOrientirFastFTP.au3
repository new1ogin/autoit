#include <GuiToolbar.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <BlockInputEx.au3>
;~ #include <FTPEx.au3>
#include <array.au3>
#include <myFTPEx.au3>
#include <String.au3>

Global $X, $Y, $podmena1=0, $fSuspended, $hOpen, $hConn
global $server = 'new1ogin.ucoz.com'
global $username = 'dnew1ogin'
global $password = 'iopthn'
global $HotKeyPressed=''

;~ _load_from_FTP()
;~ sleep(2500)
;~ _Put_on_FTP()
;~ $Ftpc = _FTP_Close($hOpen)
;~ exit

;�������� ��������� ����
ConsoleWrite(" ������ ��������� ���� - �������� ������ �����������"&' '&@ScriptLineNumber&@CRLF)
global $HwndWin1=WinWaitActive("�������� ������ �����������")
HotKeySet("{Enter}", "_Podmena1") ;��� ������� _Podmena1
ConsoleWrite(" ������ ������ ������� ��� ����� ����"&' '&@ScriptLineNumber&@CRLF)
For $i=0 to 37000
	If $podmena1=1 then _WaitNewWindow()
	$controlID='[CLASS:TBitBtn; INSTANCE:2]'
	ControlDisable ( $HwndWin1, "", $controlID )
	_BlockInputEx(3, '', "{TAB}")
	_CreateButton($HwndWin1)
	if $i=0 then
		;����������� � Ftp
		global $timeConnect=Timerinit()
		global $hOpen = _FTP_Open('Total Commander (UTF-8)')
		If not $hOpen Then
			ConsoleWrite("�� ���� ������� ��� ������" &' '&@ScriptLineNumber&@CRLF)
			Exit
		EndIf

		global $hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
		If not $hConn Then
			ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
			Exit
		EndIf
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timeConnect) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Else
		sleep(100)
	EndIf
next

Func _WaitNewWindow()
	While 1
		sleep(100)
	wend
EndFunc

Func _Podmena1()

	_ProcSuspendResume('Orientir.exe')
	ConsoleWrite(" ���� ������ �������: " & $HotKeyPressed & @HotKeyPressed &' '&@ScriptLineNumber&@CRLF)
	$podmena1=1
	_load_from_FTP()
	;���������� ����� ���������� �����
	$sFile1=@ScriptDir & "\DB\"&'User.dat'
	$sModified1 = FileGetTime($sFile1, 0, 1)
	; -����� �� ���������� �� ��������
	$controlID='[CLASS:TBitBtn; INSTANCE:2]'
	_ProcSuspendResume('Orientir.exe')
	ControlEnable ( $HwndWin1, "", $controlID )
	ControlClick($HwndWin1,'',$controlID)
	_BlockInputEx(0)
	while 1 ;
		If $sModified1<>FileGetTime($sFile1, 0, 1) then ; ������� ������ ������ ������ ����� �� ����������
			ExitLoop
		EndIf
		sleep(10)
	WEnd
	_Put_on_FTP()
	HotKeySet("{Enter}")
	_podmena2()
EndFunc

Func _podmena2()
	ConsoleWrite("���������� - ������������ ���������"&' '&@ScriptLineNumber&@CRLF)
	;���������� ����� ���������� �����
	$sFile1=@ScriptDir & "\DB\"&'User.dat'
	$sModified1 = FileGetTime($sFile1, 0, 1)
	global $HwndWin2=WinWait("����������")
	_ProcSuspendResume('Orientir.exe')
	$controlID='[CLASS:Button; INSTANCE:1]'
	_load_from_FTP()
	_ProcSuspendResume('Orientir.exe')
	WinActivate("����������")
	global $HwndWin2=WinWaitActive("����������")
	ControlClick($HwndWin2,'',$controlID)
	while 1 ;
		If $sModified1<>FileGetTime($sFile1, 0, 1) then ; ������� ������ ������ ������ ����� �� ����������
			ExitLoop
		EndIf
		sleep(10)
	WEnd
	_Put_on_FTP()

EndFunc

Func _load_from_FTP()

	; �������
;~ 	$Filename = 'User.dat'
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileCopy("\\server2003\Shared" & "\"&$Filename, @ScriptDir & "\DB\"&$Filename, 1) = ' & FileCopy("\\server2003\Shared" & "\"&$Filename, @ScriptDir & "\DB\"&$Filename, 1) & @CRLF & '>Error code: ' & @error &' '&@ScriptLineNumber&@CRLF) ;### Debug Console
;~ 	$Filename = 'User.idx'
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileCopy("\\server2003\Shared" & "\"&$Filename, @ScriptDir & "\DB\"&$Filename, 1) = ' & FileCopy("\\server2003\Shared" & "\"&$Filename, @ScriptDir & "\DB\"&$Filename, 1) & @CRLF & '>Error code: ' & @error &' '&@ScriptLineNumber&@CRLF) ;### Debug Console

;~ 	;����������� � FtpSetProxy
;~ 	global $timeConnect=Timerinit()
;~ 		$hOpen = _FTP_Open('Total Commander (UTF-8)')
;~ 		If not $hOpen Then
;~ 			ConsoleWrite("�� ���� ������� ��� ������" &' '&@ScriptLineNumber&@CRLF)
;~ 			Exit
;~ 		EndIf

;~ 		$hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
;~ 		If not $hConn Then
;~ 			ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
;~ 			Exit
;~ 		EndIf
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timeConnect) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	_Busy_FTP($hConn,1)


	ConsoleWrite('FTP ' & $hConn  &' '&@ScriptLineNumber&@CRLF)

	$Filename = 'User.dat'
	FileDelete(@ScriptDir & "\"&$Filename)
	If not _FTP_FileGet($hConn, "/"&$Filename, @ScriptDir & "\"&$Filename) Then
		ConsoleWrite("�� ���� ������� ���� � FTP ������� "& $Filename &' '&@ScriptLineNumber&@CRLF)
		Exit
	EndIf
	;������ ���������� 1 �����
	$handle1 = FileOpen(@ScriptDir & "\"&$Filename, 0)
	$file1 = FileRead($handle1)
	FileClose($handle1)
	; ���������� � ���� 2
	$handle2 = FileOpen(@ScriptDir & "\DB\"&$Filename, 2)
	FileWrite($handle2, $file1)
	FileClose($handle2)
	$Filename = 'User.idx'
	FileDelete(@ScriptDir & "\"&$Filename)
	If not _FTP_FileGet($hConn, "/"&$Filename, @ScriptDir & "\"&$Filename) Then
		ConsoleWrite("�� ���� ������� ���� � FTP ������� "& $Filename &' '&@ScriptLineNumber&@CRLF)
		Exit
	EndIf
	;������ ���������� 1 �����
	$handle1 = FileOpen(@ScriptDir & "\"&$Filename, 0)
	$file1 = FileRead($handle1)
	FileClose($handle1)
	; ���������� � ���� 2
	$handle2 = FileOpen(@ScriptDir & "\DB\"&$Filename, 2)
	FileWrite($handle2, $file1)
	FileClose($handle2)

EndFunc

Func _Busy_FTP0($state)
	$timeWait=0
	If $state=1 then
		; �������� ��������� �������
		while $state=1
			Local $hFind
			$hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
			If not $hConn Then
				ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
				Exit
			EndIf
			$aData = _FTP_FindFileFirst($hConn, 'Status', $hFind) ; ��������� ������� ����� busy
			if not @error Then
				$Size=_WinAPI_MakeQWord($aData[9], $aData[8])
				if $Size >= 4 or $Size = 0 or $Size < 0  then
					sleep(50)
					$timeWait+=0.3
					ConsoleWrite(' �������� '&$timeWait&'c. '); &"Size="&$Size&' ')
				Else
					ConsoleWrite("Size = "&$Size &' '&@ScriptLineNumber&@CRLF)
					$state=2
				EndIf
			EndIf
			_FTP_FindFileClose($hConn)
		WEnd
		;������ �� ��������� �������
		 $Filename = 'Busy.txt'
		$hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
		If not $hConn Then
			ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
			Exit
		EndIf
		If not _FTP_FilePut($hConn, @ScriptDir & "\"&$Filename, "/Status/"&$Filename) Then
			ConsoleWrite("�� ���� �������� ���� �� ftp ������" &' '&@ScriptLineNumber&@CRLF)
			Exit
		EndIf
		; ��������
		Local $hFind
		$hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
		If not $hConn Then
			ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
			Exit
		EndIf
		$aData = _FTP_FindFileFirst($hConn, 'Status', $hFind) ; ��������� ������� ����� busy
		if not @error Then
			if _WinAPI_MakeQWord($aData[9], $aData[8]) >= 4 then
				ConsoleWrite( ' ������� FTP ������� ����������� ��������� "������" ' &' '&@ScriptLineNumber&@CRLF)
			Else
				ConsoleWrite( ' ������. C�������� "������" FTP ������� ���������� �� ������� ' &' '&@ScriptLineNumber&@CRLF)
			EndIf
		EndIf
		_FTP_FindFileClose($hConn)
		return 1
	EndIf
	If $state=0 then
		; �������� ��������� �������
		Local $hFind
		$hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
		If not $hConn Then
			ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
			Exit
		EndIf
		$aData = _FTP_FindFileFirst($hConn, 'Status', $hFind) ; ��������� ������� ����� busy
		if not @error Then
			if _WinAPI_MakeQWord($aData[9], $aData[8]) >= 4 then
				; ������������ �������
				$Filename = 'Busy.txt'
				If not _FTP_FilePut($hConn, @ScriptDir & "\No"&$Filename, "/Status/"&$Filename) Then
					ConsoleWrite("�� ���� �������� ���� �� ftp ������" &' '&@ScriptLineNumber&@CRLF)
					Exit
				EndIf
				ConsoleWrite( ' C�������� "������" � FTP ������� ������� ����� ' &' '&@ScriptLineNumber&@CRLF)
				_FTP_FindFileClose($hConn)
			Else
				ConsoleWrite("������! ������ �� ��� �����! ���� ������ ��� ����." &' '&@ScriptLineNumber&@CRLF)
				_FTP_FindFileClose($hConn)
				exit
			EndIf
		EndIf
	EndIf
EndFunc

Func _Busy_FTP($hConn,$state)
	$timeWait=0
	If $state=1 then
		; �������� ��������� �������
		$s=1
		while $s=1
			$aFile = _FTP_ListToArrayEx($hConn , 2, $INTERNET_FLAG_RELOAD)
			$s=2
;~ 			ConsoleWrite('$NbFound = ' & $aFile[0] & '  -> Error code: ' & @error &' '&@ScriptLineNumber&@CRLF)
			;~ ConsoleWrite('$Filename = ' & $aFile[1] &' '&@ScriptLineNumber&@CRLF)
			For $i = 0 To UBound($aFile) - 1
	;~ 			 ConsoleWrite( "$aFile[" & $i & "] = " & $aFile[$i] &' '&@ScriptLineNumber&@CRLF)
				 If StringInStr($aFile[$i][0],'busy')<>0 then
					 $s=1
				 EndIf
			 Next
			 If $s=1 then
				sleep(300)
				$timeWait+=0.3
				ConsoleWrite(' �������� '&$timeWait&'c. ')
			EndIf
		 WEnd
		 ;������ �� ��������� �������
		 $Filename = 'Busy.txt'
		If not _FTP_FilePut($hConn, @ScriptDir & "\"&$Filename, "/"&$Filename) Then
			ConsoleWrite(@CRLF&"�� ���� �������� ���� �� ftp ������" &' '&@ScriptLineNumber&@CRLF)
			Exit
		EndIf
		ConsoleWrite( @CRLF&' ������� FTP ������� ����������� ��������� "������" ' &' '&@ScriptLineNumber&@CRLF)
		return 1
	EndIf
	If $state=0 then
				; �������� ��������� �������
		$aFile = _FTP_ListToArray($hConn, 2)

		ConsoleWrite('$NbFound = ' & $aFile[0] & '  -> Error code: ' & @error &' '&@ScriptLineNumber&@CRLF)
		;~ ConsoleWrite('$Filename = ' & $aFile[1] &' '&@ScriptLineNumber&@CRLF)
		; �������� ���� ������ 'Busy' � �������
		For $i = 0 To UBound($aFile) - 1
;~ 			 ConsoleWrite( "$aFile[" & $i & "] = " & $aFile[$i] &' '&@ScriptLineNumber&@CRLF)
			 If StringInStr($aFile[$i],'Busy') then ; ����� ���� �������� ����� � �������
					$__ghWinInet_FTP = DllOpen('wininet.dll')
					If $__ghWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
				 	Local $ai_FTPPutFile = DllCall($__ghWinInet_FTP, 'bool', 'FtpDeleteFileW', 'handle', $hConn, 'wstr', "/"&$aFile[$i])
					If @error Or $ai_FTPPutFile[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)
					DllClose('wininet.dll')
				 ConsoleWrite( ' C�������� "������" � FTP ������� ������� ����� ' &' '&@ScriptLineNumber&@CRLF)
				 Return 0
			 EndIf
		 Next
		 ; ������� �������� ������ ����� 'Busy.txt'
		 $Filename = 'Busy.txt'
		If _FTP_FileGet($hConn, "/"&$Filename, @TempDir & "\"&$Filename) Then
			$__ghWinInet_FTP = DllOpen('wininet.dll')
			If $__ghWinInet_FTP = -1 Then Return SetError(-2, 0, 0)
			Local $ai_FTPPutFile = DllCall($__ghWinInet_FTP, 'bool', 'FtpDeleteFileW', 'handle', $hConn, 'wstr', "/"&$Filename)
			If @error Or $ai_FTPPutFile[0] = 0 Then Return SetError(-1, _WinAPI_GetLastError(), 0)
			DllClose('wininet.dll')
			 If not _FTP_FileGet($hConn, "/"&$Filename, @TempDir & "\"&$Filename) Then
				 ConsoleWrite( ' C�������� "������" � FTP ������� ����� �� ������� ' &' '&@ScriptLineNumber&@CRLF)
				 Return -1
			 EndIf
			 ConsoleWrite( ' C�������� "������" � FTP ������� ������� ����� ' &' '&@ScriptLineNumber&@CRLF)
			 Return 0
		EndIf
		ConsoleWrite("������! ������ �� ��� �����! ���� ������ ��� ����." &' '&@ScriptLineNumber&@CRLF)
	EndIf
EndFunc


Func _Put_on_FTP()
	; �������
;~ 	$Filename = 'User.dat'
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileCopy(@ScriptDir & "\DB\"&$Filename, "\\server2003\Shared" & "\"&$Filename, 1) = ' & FileCopy(@ScriptDir & "\DB\"&$Filename, "\\server2003\Shared" & "\"&$Filename, 1) & @CRLF & '>Error code: ' & @error &' '&@ScriptLineNumber&@CRLF) ;### Debug Console
;~ 	$Filename = 'User.idx'
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileCopy(@ScriptDir & "\DB\"&$Filename, "\\server2003\Shared" & "\"&$Filename, 1) = ' & FileCopy(@ScriptDir & "\DB\"&$Filename, "\\server2003\Shared" & "\"&$Filename, 1) & @CRLF & '>Error code: ' & @error &' '&@ScriptLineNumber&@CRLF) ;### Debug Console

	ConsoleWrite('FTP ' & $hConn  &' '&@ScriptLineNumber&@CRLF)
	$Filename = 'User.dat'
	If not FileCopy ( @ScriptDir & "\DB\"&$Filename, @ScriptDir & "\"&$Filename, 1) Then
		ConsoleWrite("�� ���� ����������� ����" &' '&@ScriptLineNumber&@CRLF)
		Exit
	EndIf
	If not _FTP_FilePut($hConn, @ScriptDir & "\"&$Filename, "/"&$Filename) Then
		ConsoleWrite("�� ���� �������� ���� �� FTP ������ "& $Filename &' '&@ScriptLineNumber&@CRLF)
		Exit
	EndIf
	$Filename = 'User.idx'
	If not FileCopy ( @ScriptDir & "\DB\"&$Filename, @ScriptDir & "\"&$Filename, 1) Then
		ConsoleWrite("�� ���� ����������� ����" &' '&@ScriptLineNumber&@CRLF)
		Exit
	EndIf
	If not _FTP_FilePut($hConn, @ScriptDir & "\"&$Filename, "/"&$Filename) Then
		ConsoleWrite("�� ���� �������� ���� �� FTP ������ "& $Filename &' '&@ScriptLineNumber&@CRLF)
		Exit
	EndIf
	_Busy_FTP($hConn,0)

	$Ftpc = _FTP_Close($hOpen)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timeConnect) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

EndFunc

Func _CreateButton($hWnd)

	$hForm = GUICreate('', 100, 31, -1, -1, $WS_POPUP, -1, $hWnd)
	$Button = GUICtrlCreateButton('OK', 0, 0, 100, 31)
	GUISetState(@SW_SHOWNOACTIVATE)

	While 1
		$Pos = WinGetPos($hWnd)
		If @error Then
			Exit
		EndIf
		If ($X <> $Pos[0]) Or ($Y <> $Pos[1]) Then
			$X = $Pos[0]
			$Y = $Pos[1]
			WinMove($hForm, '', $X + 105, $Y + 227)
		EndIf
		$Msg = GUIGetMsg()
		Switch $Msg
			Case $Button
				$HotKeyPressed=' ������ �� '
				GUIDelete ($hForm )
				_Podmena1()
		EndSwitch
	WEnd

EndFunc

Func _ProcSuspendResume($process)
      $processid = ProcessExists($process)
      If $processid Then
          If $fSuspended Then
              $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
              $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
              DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
              If IsArray($i_sucess) Then
                  $fSuspended = 0
                  Return 1
              Else
                  SetError(1)
                  Return 0
              Endif
          Else
              $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
              $i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
              DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
              If IsArray($i_sucess) Then
                  $fSuspended = 1
                  Return 1
              Else
                  SetError(1)
                  Return 0
              Endif
          EndIf
      Else
          SetError(2)
          Return 0
      Endif
EndFunc