#include <FTPEx.au3>
#include <array.au3>

$server = 'new1ogin.ucoz.com'
$username = 'dnew1ogin'
$password = 'iopthn'
HotKeySet("{Enter}", "_F") ;Это вызовет _Podmena1
HotKeySet("{Esc}", "_Quit") ;Это вызовет _Podmena1


	$hOpen = _FTP_Open('MyFTP Control')

	_f()
	while 1
		sleep(100)
	WEnd

Func _f()
	$hConn = _FTP_Connect($hOpen, $server, $username, $password, 1)
	ConsoleWrite('FTP ' & $hConn  & @CRLF)

	ConsoleWrite(_FTP_DirGetCurrent ($hConn) & @CRLF)
	$aFile = _FTP_ListToArray($hConn, 2)
	if not @error then
		ConsoleWrite('$NbFound = ' & $aFile[0] & '  -> Error code: ' & @error & @crlf)
		;~ ConsoleWrite('$Filename = ' & $aFile[1] & @crlf)
		For $i = 0 To UBound($aFile) - 1
			 ConsoleWrite( "$aFile[" & $i & "] = " & $aFile[$i] & @CRLF)
		 Next
	 Else
		 ConsoleWrite('Ошибка получения списка файлов' & @error & @crlf)
	 EndIf

EndFunc


Func _Quit()
	$Ftpc = _FTP_Close($hOpen)
    Exit
EndFunc
