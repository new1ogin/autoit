#Include <FTPEx.au3>

$server = 'new1ogin.ucoz.com'
$username = 'dnew1ogin'
$password = 'iopthn'

$Filename = '1.rar'
$filepath = "C:\"&$Filename
$ftppath = "/"&$Filename

$hOpen = _FTP_Open('Total Commander (UTF-8)')
If not $hOpen Then
    ConsoleWrite("Не могу открыть фтп сессию" & @CRLF)
    Exit
EndIf

$hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
If not $hConn Then
    ConsoleWrite("Не могу подключиться к ftp серверу" & @CRLF)
    Exit
EndIf
If not _FTP_FilePut($hConn, $filepath, $ftppath) Then
    ConsoleWrite("Не могу закачать файл на ftp сервер" & @CRLF)
    Exit
EndIf

ConsoleWrite("Файл успешно закачан на фтп сервер" & @CRLF)

_FTP_Close($hOpen)
