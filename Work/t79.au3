#Include <FTPEx.au3>

$server = 'new1ogin.ucoz.com'
$username = 'dnew1ogin'
$password = 'iopthn'

$Filename = '1.rar'
$filepath = "C:\"&$Filename
$ftppath = "/"&$Filename

$hOpen = _FTP_Open('Total Commander (UTF-8)')
If not $hOpen Then
    ConsoleWrite("�� ���� ������� ��� ������" & @CRLF)
    Exit
EndIf

$hConn = _FTP_Connect($hOpen, $server, $username, $password,1)
If not $hConn Then
    ConsoleWrite("�� ���� ������������ � ftp �������" & @CRLF)
    Exit
EndIf
If not _FTP_FilePut($hConn, $filepath, $ftppath) Then
    ConsoleWrite("�� ���� �������� ���� �� ftp ������" & @CRLF)
    Exit
EndIf

ConsoleWrite("���� ������� ������� �� ��� ������" & @CRLF)

_FTP_Close($hOpen)
