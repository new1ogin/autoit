#include <GuiToolbar.au3>
#include <GuiConstantsEx.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
#include <BlockInputEx.au3>
;~ #include <FTPEx.au3>
#include <array.au3>
#include <myFTPEx.au3>
#include <String.au3>

#Include  <Crypt.au3>
#Include  <WinAPI.au3>

Global Const $UHID_MB = 0x00
Global Const $UHID_BIOS = 0x01
Global Const $UHID_CPU = 0x02
Global Const $UHID_HDD = 0x04

Global $X, $Y, $podmena1=0, $fSuspended, $hOpen, $hConn, $timeConnect
global $server = 'tshi.tomsk.ru'
global $username = 'tshi'
global $password = 'aeNg9epiphei2je'
global $HotKeyPressed=''
global $patchToServer = '/sites/tshi.tomsk.ru/tmp/'&StringMid(_UniqueHardwaeIDv1(BitOR($UHID_MB, $UHID_BIOS)), 1, 8)
;~ global $perID = _UniqueHardwaeIDv1(BitOR($UHID_MB, $UHID_BIOS))

		;����������� � Ftp
		global $timeConnect=Timerinit()
		global $hOpen = _FTP_Open('Total Commander (UTF-8)')
		If not $hOpen Then
			ConsoleWrite("�� ���� ������� ��� ������" &' '&@ScriptLineNumber&@CRLF)
			_exit(@ScriptLineNumber)
		EndIf

		global $hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
		If not $hConn Then
			ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
			_exit(@ScriptLineNumber)
		EndIf
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ����������� � FTP. ����� ����������� (� ��) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	_load_from_FTP()

$t1=TimerInit()
	ConsoleWrite('FTP ' & $hConn  &' '&@ScriptLineNumber&@CRLF)
	$Filename = 'User.dat'
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $patchToServer&$Filename = ' & $patchToServer&$Filename & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	If not FileCopy ( @ScriptDir & "\DB\"&$Filename, @ScriptDir & "\"&$Filename, 1) Then
		ConsoleWrite("�� ���� ����������� ����" &' '&@ScriptLineNumber&@CRLF)
		_exit(@ScriptLineNumber)
	EndIf
	If not _FTP_FilePut($hConn, @ScriptDir & "\"&$Filename, $patchToServer&$Filename) Then
		ConsoleWrite("�� ���� �������� ���� �� FTP ������ "& $Filename &' '&@ScriptLineNumber&@CRLF)
		_exit(@ScriptLineNumber)
	EndIf



	ConsoleWrite('FTP ' & $hConn  &' '&@ScriptLineNumber&' '&TimerDiff($t1)&@CRLF)

	$Filename = 'User.dat'
	FileDelete(@ScriptDir & "\"&$Filename)
	If @error Then _exit(@ScriptLineNumber,'FileDelete, @error = '&@error)
	If not _FTP_FileGet($hConn, $patchToServer&$Filename, @ScriptDir & "\"&$Filename) Then
		ConsoleWrite("�� ���� ������� ���� � FTP ������� "& $Filename &' '&@ScriptLineNumber&@CRLF)
		_exit(@ScriptLineNumber)
	EndIf
	ConsoleWrite('FTP ' & $hConn  &' '&@ScriptLineNumber&' '&TimerDiff($t1)&@CRLF)
	Exit


;~ 			;����������� � Ftp
;~ 			global $timeConnect=Timerinit()
;~ 			global $hOpen = _FTP_Open('Total Commander (UTF-8)')
;~ 			If not $hOpen Then
;~ 				ConsoleWrite("�� ���� ������� ��� ������" &' '&@ScriptLineNumber&@CRLF)
;~ 				_exit(@ScriptLineNumber)
;~ 			EndIf

;~ 			global $hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
;~ 			If not $hConn Then
;~ 				ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
;~ 				_exit(@ScriptLineNumber)
;~ 			EndIf
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ����������� � FTP. ����� ����������� (� ��) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;~ 	global $time
;~ 	$time=TimerInit()
;~ 		; �������� ��������� �������
;~ 		Local $hFind
;~ 			$aData = _FTP_FindFileFirst($hConn, 'Status', $hFind) ; ��������� ������� ����� busy
;~ 			if not @error Then
;~ 				$Size=_WinAPI_MakeQWord($aData[9], $aData[8])
;~ 				if $Size >= 4 or $Size = 0 or $Size < 0  then
;~ 				Else
;~ 					ConsoleWrite("Size = "&$Size &' '&@ScriptLineNumber&@CRLF)
;~ 					$state=2
;~ 				EndIf
;~ 			EndIf
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($time) = ' & TimerDiff($time) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ $Ftpc = _FTP_Close($hOpen)
;~ _exit(@ScriptLineNumber, ' ���������� ����� ')

;�������� ��������� ����
ConsoleWrite(" ������ ��������� ���� - �������� ������ �����������"&' '&@ScriptLineNumber&@CRLF)
global $HwndWin1=WinWaitActive("�������� ������ �����������")
HotKeySet("{Enter}", "_Podmena1") ;��� ������� _Podmena1
ConsoleWrite(" ������ ������ ������� ��� ����� ����"&' '&@ScriptLineNumber&@CRLF)
	If $podmena1=1 then _WaitNewWindow()
	$controlID='[CLASS:TBitBtn; INSTANCE:2]'
	ControlDisable ( $HwndWin1, "", $controlID )
	_BlockInputEx(3, '', "{TAB}")
	_CreateButton($HwndWin1) ; �������� ������, �������� � �������� � ����������� � FTP �������



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
	;����������  ����
	$sFile1=@ScriptDir & "\DB\"&'User.dat'
	$sModified1 = _MD5ForFile($sFile1)
	; -����� �� ���������� �� ��������
	$controlID='[CLASS:TBitBtn; INSTANCE:2]'
	_ProcSuspendResume('Orientir.exe')
	ControlEnable ( $HwndWin1, "", $controlID )
	ConsoleWrite(' ������� �� ������ �� ������������� ����, ���� ���� �� �������� '&@CRLF)
	While 1
		ControlClick($HwndWin1,'',$controlID)
		if WinExists("�������� ������ �����������")=0 then ExitLoop
		if WinExists('��������������') then
			ConsoleWrite(' �������� ���� "��������������" '&@CRLF)
			While 1
				if WinExists('��������������')=0 then ExitLoop
			WEnd
			$HwndWin1=WinWaitActive("�������� ������ �����������")
			_Busy_FTP($hConn,0)
			$controlID='[CLASS:TBitBtn; INSTANCE:2]'
			ControlDisable ( $HwndWin1, "", $controlID )
			_BlockInputEx(3, '', "{TAB}")
			_CreateButton($HwndWin1) ; �������� ������, �������� � �������� � ����������� � FTP �������
			exitloop
		endif
		sleep(10)
	WEnd

	_BlockInputEx(0)
	ConsoleWrite(' ������ ���� ���� ���� ������ �� ��������� '&@CRLF)
	while 1 ;
		If $sModified1<>_MD5ForFile($sFile1) then ; ������� ������ ������ ������ ����� �� ����������
			ExitLoop
		EndIf
		sleep(10)
	WEnd
	_Put_on_FTP()
	HotKeySet("{Enter}")
	_podmena2()
EndFunc

Func _podmena2()
	ConsoleWrite(' ������ ��������� ���� - "���������� - ������������ ���������"'&' '&@ScriptLineNumber&@CRLF)
	;���������� ����� ���������� �����
	$sFile1=@ScriptDir & "\DB\"&'User.dat'
	$sModified1 = FileGetTime($sFile1, 0, 1)
;~ 	global $HwndWin2=WinWait("����������")
	while 1 ; ������ ������� �������� ����
		if WinExists("����������")=1 then exitloop
		sleep(10)
	WEnd

	_ProcSuspendResume('Orientir.exe')
		;����������� � Ftp
		global $timeConnect=Timerinit()
		global $hOpen = _FTP_Open('Total Commander (UTF-8)')
		If not $hOpen Then
			ConsoleWrite("�� ���� ������� ��� ������" &' '&@ScriptLineNumber&@CRLF)
			_exit(@ScriptLineNumber)
		EndIf

		global $hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
		If not $hConn Then
			ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
			_exit(@ScriptLineNumber)
		EndIf
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ����������� � FTP. ����� ����������� (� ��) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	_load_from_FTP()
	_ProcSuspendResume('Orientir.exe')
	WinActivate("����������")
	global $HwndWin2=WinWaitActive("����������")
	$controlID='[CLASS:Button; INSTANCE:1]'
	ConsoleWrite(' ������� �� ������ �� ������������� ����, ���� ���� �� �������� '&@CRLF)
	While 1
		ControlClick($HwndWin1,'',$controlID)
		if WinExists("����������")=0 then ExitLoop
		sleep(10)
	WEnd
	ConsoleWrite(' ������ ���� ���� ���� ������ �� ��������� '&@CRLF)
	while 1 ;
		If $sModified1<>FileGetTime($sFile1, 0, 1) then ; ������� ������ ������ ������ ����� �� ����������
			ExitLoop
		EndIf
		sleep(10)
	WEnd
	_Put_on_FTP()

EndFunc

Func _load_from_FTP()
	global $timeConnect=Timerinit()
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
;~ 			_exit(@ScriptLineNumber)
;~ 		EndIf

;~ 		$hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
;~ 		If not $hConn Then
;~ 			ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
;~ 			_exit(@ScriptLineNumber)
;~ 		EndIf
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timeConnect) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	_Busy_FTP($hConn,1)


	ConsoleWrite('FTP ' & $hConn  &' '&@ScriptLineNumber&@CRLF)

	$Filename = 'User.dat'
;~ 	FileDelete(@ScriptDir & "\"&$Filename)
	If @error Then _exit(@ScriptLineNumber,'FileDelete, @error = '&@error)
	If not _FTP_FileGet($hConn, "/"&$Filename, @ScriptDir & "\"&$Filename) Then
		ConsoleWrite("�� ���� ������� ���� � FTP ������� "& $Filename &' '&@ScriptLineNumber&@CRLF)
		_exit(@ScriptLineNumber)
	EndIf
	;������ ���������� 1 �����
	$handle1 = FileOpen(@ScriptDir & "\"&$Filename, 0)
	$file1 = FileRead($handle1)
	If @error = -1 Then _exit(@ScriptLineNumber,'FileRead')
	FileClose($handle1)
	; ���������� � ���� 2
	$handle2 = FileOpen(@ScriptDir & "\DB\"&$Filename, 2)
	FileWrite($handle2, $file1)
	If @error Then _exit(@ScriptLineNumber,'FileWrite, @error = '&@error)
	FileClose($handle2)
	If $handle1 = -1 or $handle2 = -1 Then
		MsgBox(4096, "������", "���������� ������� ����.")
		_exit(@ScriptLineNumber)
	EndIf
	$Filename = 'User.idx'
	FileDelete(@ScriptDir & "\"&$Filename)
	If @error Then _exit(@ScriptLineNumber,'FileDelete, @error = '&@error)
	If not _FTP_FileGet($hConn, "/"&$Filename, @ScriptDir & "\"&$Filename) Then
		ConsoleWrite("�� ���� ������� ���� � FTP ������� "& $Filename &' '&@ScriptLineNumber&@CRLF)
		_exit(@ScriptLineNumber)
	EndIf
	;������ ���������� 1 �����
	$handle1 = FileOpen(@ScriptDir & "\"&$Filename, 0)
	$file1 = FileRead($handle1)
	If @error = -1 Then _exit(@ScriptLineNumber,'FileRead')
	FileClose($handle1)
	; ���������� � ���� 2
	$handle2 = FileOpen(@ScriptDir & "\DB\"&$Filename, 2)
	FileWrite($handle2, $file1)
	If @error Then _exit(@ScriptLineNumber,'FileWrite, @error = '&@error)
	FileClose($handle2)
	If $handle1 = -1 or $handle2 = -1 Then
		MsgBox(4096, "������", "���������� ������� ����.")
		_exit(@ScriptLineNumber)
	EndIf

	ConsoleWrite(' ������ ��������� � FTP ������� ' &@CRLF)


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
				_exit(@ScriptLineNumber)
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
			_exit(@ScriptLineNumber)
		EndIf
		If not _FTP_FilePut($hConn, @ScriptDir & "\"&$Filename, "/Status/"&$Filename) Then
			ConsoleWrite("�� ���� �������� ���� �� ftp ������" &' '&@ScriptLineNumber&@CRLF)
			_exit(@ScriptLineNumber)
		EndIf
		; ��������
		Local $hFind
		$hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
		If not $hConn Then
			ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
			_exit(@ScriptLineNumber)
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
			_exit(@ScriptLineNumber)
		EndIf
		$aData = _FTP_FindFileFirst($hConn, 'Status', $hFind) ; ��������� ������� ����� busy
		if not @error Then
			if _WinAPI_MakeQWord($aData[9], $aData[8]) >= 4 then
				; ������������ �������
				$Filename = 'Busy.txt'
				If not _FTP_FilePut($hConn, @ScriptDir & "\No"&$Filename, "/Status/"&$Filename) Then
					ConsoleWrite("�� ���� �������� ���� �� ftp ������" &' '&@ScriptLineNumber&@CRLF)
					_exit(@ScriptLineNumber)
				EndIf
				ConsoleWrite( ' C�������� "������" � FTP ������� ������� ����� ' &' '&@ScriptLineNumber&@CRLF)
				_FTP_FindFileClose($hConn)
			Else
				ConsoleWrite("������! ������ �� ��� �����! ���� ������ ��� ����." &' '&@ScriptLineNumber&@CRLF)
				_FTP_FindFileClose($hConn)
				_exit(@ScriptLineNumber)
			EndIf
		EndIf
	EndIf
EndFunc

Func _Busy_FTP($hConn,$state)
	$timeWait=0
	Switch $state
	Case 1
		; �������� ��������� �������
		$s=1
		while $s=1
			$aFile = _FTP_ListToArrayEx($hConn , 2, $INTERNET_FLAG_RELOAD)
			$s=0
;~ 			ConsoleWrite('$NbFound = ' & $aFile[0] & '  -> Error code: ' & @error &' '&@ScriptLineNumber&@CRLF)
			;~ ConsoleWrite('$Filename = ' & $aFile[1] &' '&@ScriptLineNumber&@CRLF)
			; ���� ������ ������ �� �����
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
		 $Filename2 = 'Busy0_'&Stringleft(@ComputerName,8)&'-'&hex(_DriveCod(),8)
		If not _FTP_FilePut($hConn, @ScriptDir & "\"&$Filename, "/"&$Filename2) Then
			ConsoleWrite(@CRLF&"�� ���� �������� ���� �� ftp ������" &' '&@ScriptLineNumber&@CRLF)
			_exit(@ScriptLineNumber)
		EndIf
		ConsoleWrite( @CRLF&' ������� FTP ������� ����������� ��������� "������" ' &' '&@ScriptLineNumber&@CRLF)
		return 1

	Case 0

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
			sleep(10) ; �� � ����� �� ������ ���������? ���� 10 �� ����� ���� �� ��������..
			 If _FTP_FileGet($hConn, "/"&$Filename, @TempDir & "\"&$Filename) Then
				 ConsoleWrite( ' C�������� "������" � FTP ������� ����� �� ������� ' &' '&@ScriptLineNumber&@CRLF)
				 Return -1
			 EndIf
			 ConsoleWrite( ' C�������� "������" � FTP ������� ������� ����� ' &' '&@ScriptLineNumber&@CRLF)
			 Return 0
		EndIf
		ConsoleWrite("������! ������ �� ��� �����! ���� ������ ��� ����." &' '&@ScriptLineNumber&@CRLF)
	EndSwitch

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
		_exit(@ScriptLineNumber)
	EndIf
	If not _FTP_FilePut($hConn, @ScriptDir & "\"&$Filename, "/"&$Filename) Then
		ConsoleWrite("�� ���� �������� ���� �� FTP ������ "& $Filename &' '&@ScriptLineNumber&@CRLF)
		_exit(@ScriptLineNumber)
	EndIf
	$Filename = 'User.idx'
	If not FileCopy ( @ScriptDir & "\DB\"&$Filename, @ScriptDir & "\"&$Filename, 1) Then
		ConsoleWrite("�� ���� ����������� ����" &' '&@ScriptLineNumber&@CRLF)
		_exit(@ScriptLineNumber)
	EndIf
	If not _FTP_FilePut($hConn, @ScriptDir & "\"&$Filename, "/"&$Filename) Then
		ConsoleWrite("�� ���� �������� ���� �� FTP ������ "& $Filename &' '&@ScriptLineNumber&@CRLF)
		_exit(@ScriptLineNumber)
	EndIf
	_Busy_FTP($hConn,0)

	$Ftpc = _FTP_Close($hOpen)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ������ �� ������ ������� ���������. ����� ����� ��������, �������� = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

EndFunc

Func _CreateButton($hWnd)

	$hForm = GUICreate('', 100, 31, -1, -1, $WS_POPUP, -1, $hWnd)
	$Button = GUICtrlCreateButton('OK', 0, 0, 100, 31)
	GUISetState(@SW_SHOWNOACTIVATE)
	local $i=0
	While 1
		$Pos = WinGetPos($hWnd)
		If @error Then
			_exit(@ScriptLineNumber)
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
		if $i=0 then
			;����������� � Ftp
			global $timeConnect=Timerinit()
			global $hOpen = _FTP_Open('Total Commander (UTF-8)')
			If not $hOpen Then
				ConsoleWrite("�� ���� ������� ��� ������" &' '&@ScriptLineNumber&@CRLF)
				_exit(@ScriptLineNumber)
			EndIf

			global $hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
			If not $hConn Then
				ConsoleWrite("�� ���� ������������ � ftp �������" &' '&@ScriptLineNumber&@CRLF)
				_exit(@ScriptLineNumber)
			EndIf
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ����������� � FTP. ����� ����������� (� ��) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		Else
			sleep(10)
		EndIf
		$i+=1
	WEnd

EndFunc

Func _exit($ScrptLine,$message=0)
	if $message<>0 then
		$messageWrite= @CRLF & ' ��������� �� ������: ' & $message
	Else
		$messageWrite= ''
	EndIf
	ConsoleWrite( ' ������! ����� ����: '& $ScrptLine & $messageWrite)
	Exit
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




Func _MD5ForFile($sFile)

    Local $a_hCall = DllCall("kernel32.dll", "hwnd", "CreateFileW", _
            "wstr", $sFile, _
            "dword", 0x80000000, _ ; GENERIC_READ
            "dword", 1, _ ; FILE_SHARE_READ
            "ptr", 0, _
            "dword", 3, _ ; OPEN_EXISTING
            "dword", 0, _ ; SECURITY_ANONYMOUS
            "ptr", 0)

    If @error Or $a_hCall[0] = -1 Then
        Return SetError(1, 0, "")
    EndIf

    Local $hFile = $a_hCall[0]

    $a_hCall = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", _
            "hwnd", $hFile, _
            "dword", 0, _ ; default security descriptor
            "dword", 2, _ ; PAGE_READONLY
            "dword", 0, _
            "dword", 0, _
            "ptr", 0)

    If @error Or Not $a_hCall[0] Then
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
        Return SetError(2, 0, "")
    EndIf

    DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)

    Local $hFileMappingObject = $a_hCall[0]

    $a_hCall = DllCall("kernel32.dll", "ptr", "MapViewOfFile", _
            "hwnd", $hFileMappingObject, _
            "dword", 4, _ ; FILE_MAP_READ
            "dword", 0, _
            "dword", 0, _
            "dword", 0)

    If @error Or Not $a_hCall[0] Then
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(3, 0, "")
    EndIf

    Local $pFile = $a_hCall[0]
    Local $iBufferSize = FileGetSize($sFile)

    Local $tMD5_CTX = DllStructCreate("dword i[2];" & _
            "dword buf[4];" & _
            "ubyte in[64];" & _
            "ubyte digest[16]")

    DllCall("advapi32.dll", "none", "MD5Init", "ptr", DllStructGetPtr($tMD5_CTX))

    If @error Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(4, 0, "")
    EndIf

    DllCall("advapi32.dll", "none", "MD5Update", _
            "ptr", DllStructGetPtr($tMD5_CTX), _
            "ptr", $pFile, _
            "dword", $iBufferSize)

    If @error Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(5, 0, "")
    EndIf

    DllCall("advapi32.dll", "none", "MD5Final", "ptr", DllStructGetPtr($tMD5_CTX))

    If @error Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(6, 0, "")
    EndIf

    DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
    DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)

    Local $sMD5 = Hex(DllStructGetData($tMD5_CTX, "digest"))

    Return SetError(0, 0, $sMD5)

EndFunc   ;==>_MD5ForFile



Func _DriveCod()
	Local $Drive = DriveGetDrive('FIXED')
	if Not IsArray($Drive) Then
		_exit(@ScriptLineNumber)
	EndIf
	Return DriveGetSerial($Drive[$Drive[0]]&'\')
EndFunc


Func _UniqueHardwaeIDv1($iFlags = 0)

    Local $oService = ObjGet('winmgmts:\\.\root\cimv2')

    If Not IsObj($oService) Then
        Return SetError(1, 0, '')
    EndIf

    Local $tSPQ, $tSDD, $oItems, $hFile, $Hash, $Ret, $Str, $Hw = '', $Result = 0

    $oItems = $oService.ExecQuery('SELECT * FROM Win32_ComputerSystemProduct')
    If Not IsObj($oItems) Then
        Return SetError(2, 0, '')
    EndIf
    For $Property In $oItems
        $Hw &= $Property.IdentifyingNumber
        $Hw &= $Property.Name
        $Hw &= $Property.SKUNumber
        $Hw &= $Property.UUID
        $Hw &= $Property.Vendor
        $Hw &= $Property.Version
    Next
    $Hw = StringStripWS($Hw, 8)
    If Not $Hw Then
        Return SetError(3, 0, '')
    EndIf
    If BitAND($iFlags, 0x01) Then
        $oItems = $oService.ExecQuery('SELECT * FROM Win32_BIOS')
        If Not IsObj($oItems) Then
            Return SetError(2, 0, '')
        EndIf
        $Str = ''
        For $Property In $oItems
            $Str &= $Property.IdentificationCode
            $Str &= $Property.Manufacturer
            $Str &= $Property.Name
            $Str &= $Property.SerialNumber
            $Str &= $Property.SMBIOSMajorVersion
            $Str &= $Property.SMBIOSMinorVersion
;           $Str &= $Property.Version
        Next
        $Str = StringStripWS($Str, 8)
        If $Str Then
            $Result += 0x01
            $Hw &= $Str
        EndIf
    EndIf
    If BitAND($iFlags, 0x02) Then
        $oItems = $oService.ExecQuery('SELECT * FROM Win32_Processor')
        If Not IsObj($oItems) Then
            Return SetError(2, 0, '')
        EndIf
        $Str = ''
        For $Property In $oItems
            $Str &= $Property.Architecture
            $Str &= $Property.Family
            $Str &= $Property.Level
            $Str &= $Property.Manufacturer
            $Str &= $Property.Name
            $Str &= $Property.ProcessorId
            $Str &= $Property.Revision
            $Str &= $Property.Version
        Next
        $Str = StringStripWS($Str, 8)
        If $Str Then
            $Result += 0x02
            $Hw &= $Str
        EndIf
    EndIf
    If BitAND($iFlags, 0x04) Then
        $oItems = $oService.ExecQuery('SELECT * FROM Win32_PhysicalMedia')
        If Not IsObj($oItems) Then
            Return SetError(2, 0, '')
        EndIf
        $Str = ''
        $tSPQ = DllStructCreate('dword;dword;byte[4]')
        $tSDD = DllStructCreate('ulong;ulong;byte;byte;byte;byte;ulong;ulong;ulong;ulong;dword;ulong;byte[512]')
        For $Property In $oItems
            $hFile = _WinAPI_CreateFile($Property.Tag, 2, 0, 0)
            If Not $hFile Then
                ContinueLoop
            EndIf
            $Ret = DllCall('kernel32.dll', 'int', 'DeviceIoControl', 'ptr', $hFile, 'dword', 0x002D1400, 'ptr', DllStructGetPtr($tSPQ), 'dword', DllStructGetSize($tSPQ), 'ptr', DllStructGetPtr($tSDD), 'dword', DllStructGetSize($tSDD), 'dword*', 0, 'ptr', 0)
            If (Not @error) And ($Ret[0]) And (Not DllStructGetData($tSDD, 5)) Then
                Switch DllStructGetData($tSDD, 11)
                    Case 0x03, 0x0B ; ATA, SATA
                        $Str &= $Property.SerialNumber
                EndSwitch
            EndIf
            _WinAPI_CloseHandle($hFile)
        Next
        $Str = StringStripWS($Str, 8)
        If $Str Then
            $Result += 0x04
            $Hw &= $Str
        EndIf
    EndIf
    $Hash = _Crypt_HashData($Hw, $CALG_MD5)
    If @error Then
        Return SetError(4, 0, '')
    EndIf
    $Hash = StringTrimLeft($Hash, 2)
    Return SetError(0, $Result,  StringMid($Hash, 1, 8) & '-' & StringMid($Hash, 9, 4) & '-' & StringMid($Hash, 13, 4) & '-' & StringMid($Hash, 17, 4) & '-' & StringMid($Hash, 21, 12))
EndFunc   ;==>_UniqueHardwaeIDv1