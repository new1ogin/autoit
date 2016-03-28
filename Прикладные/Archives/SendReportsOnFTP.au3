#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=\\192.168.0.1\ftp\pub\temp\AIDA64-Business\SendReportsOnFTP.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FTPEx.au3>
#include <File.au3>
#include <array.au3>
#include <Inet.au3>
Opt("MustDeclareVars", 1)
Global $7zaexe = @ScriptDir & '\7za.exe'
Global $aFilesFTP[1][6]
exit 3
Global $server, $login, $password, $filepath, $ftppath, $FileA
$server = "proff.scalpnet.ru"
$login = "proff"
$password = "proff"

$filepath = @ScriptDir & '\Reports'
;~ $filepath = 'D:\BackUp`s\BackUpFlash\Others\AIDA64\Reports' ;строка для отладки ЁЁ УДАЛИТЬ!!!!!
$ftppath = "/pub/Reports"

If $cmdline[0] > 0 Then $filepath = $cmdline[1]

SendReportsOnFTP($server, $login, $password, $filepath, $ftppath)

Func SendReportsOnFTP($server, $login, $password, $filepath, $ftppath)

	Local $hOpen, $hConn, $aFiles, $iFilesLoad, $Filename, $Filesize

	$hOpen = _FTP_Open('Total Commander (UTF-8)')
	If Not $hOpen Then _error("Не могу открыть фтп сессию" & @CRLF)

	$hConn = _FTP_Connect($hOpen, $server, $login, $password, 1)
	If Not $hConn Then _error("Не могу подключиться к ftp серверу" & @CRLF)

	; получение списка файлов отчетов
	If StringInStr(FileGetAttrib($filepath), 'D') Then
		$aFiles = _FileListToArray($filepath, '*', 1)
	Else
		$aFiles[0] = 1
		$aFiles[0] = $filepath
	EndIf

;~ $aFilesFTP = _FTP_ListToArray2D($hConn, 2) ;не рекурсивный поиск на FTP
;~ $aFilesFTP[0][0] = 'Filename'
;~ $aFilesFTP[0][1] = 'Filesize'
;~ $aFilesFTP[0][2] = 'FileAttr'
;~ $aFilesFTP[0][3] = 'DateModif'
;~ $aFilesFTP[0][4] = 'DateCreate'
;~ $aFilesFTP[0][5] = 'DateAccess'
	_FTP_GetList($hConn, $ftppath, $aFilesFTP, 0) ;рекурсивный поиск на FTP
	_FTP_DirSetCurrent($hConn, $ftppath)

;~ _ArrayDisplay($aFilesFTP)
;~ _ArrayDisplay($aFiles)
;~ StringRegExpReplace($aFiles[$i], '\.[^.]*$', '')

	;загрузка файлов на FTP
	$iFilesLoad = 0
	For $i = 1 To $aFiles[0]
		$Filename = $filepath & '\' & $aFiles[$i]
		$Filesize = FileGetSize($Filename)
		If _PathSplitByRegExp($Filename, '', 7) = '7z' Then ContinueLoop 1

		;проверка на наличие этого файла на FTP
		For $j = 1 To UBound($aFilesFTP) - 1
;~ 		ConsoleWrite('@@ Debug(' & StringRegExpReplace($aFiles[$i], '\.[^.]*$', '') & ') : StringRegExpReplace($aFilesFTP[$j][0], ''\.[^.]*$'', '''') = ' & StringRegExpReplace($aFilesFTP[$j][0], '\([0-9]*?\)\.[^.]*$|\.[^.]*$', '') & @CRLF) ;### Debug Console
			If StringRegExpReplace($aFiles[$i], '\.[^.]*$', '') = StringRegExpReplace($aFilesFTP[$j][0], '\([0-9]*?\)\.[^.]*$|\.[^.]*$', '') Then
;~ 			ConsoleWrite('@@ Debug(' & $Filesize & ')(' & _GetFtpOrigSize($aFilesFTP[$j][0]) & ')(' & $aFilesFTP[$j][1]  & ') : $aFiles[$i] = ' & $aFiles[$i] & @CRLF) ;### Debug Console
				If $Filesize = $aFilesFTP[$j][1] Or $Filesize = _GetFtpOrigSize($aFilesFTP[$j][0]) Then
					ContinueLoop 2
				Else
;~ 				ContinueLoop 1 ;если включен искать до первого сопадения имени файла без расширения
				EndIf
			EndIf
		Next

		;архивация
		$FileA = _PathSplitByRegExp($Filename, '', 3) & '(' & $Filesize & ').7z'
		RunWait(@ComSpec & " /c " & '' & $7zaexe & ' a -ssw -mx=1 -pRfnfhcbcProff123 "' & $FileA & '" "' & $Filename & '" >> C:\Temp\log_file.txt', "", @SW_HIDE)
		Sleep(5000)
		If FileGetSize($FileA) > 64 Then $Filename = $FileA

		;upload
		If Not _FTP_FilePut($hConn, $Filename, $ftppath & '/' & _PathSplitByRegExp($Filename, '', 5)) Then _error("Не могу закачать файл " & $Filename & " на ftp сервер" & @CRLF)
		$iFilesLoad += 1
		ConsoleWrite("Файл успешно закачан на фтп сервер" & @CRLF)
		FileDelete($FileA)
	Next


	If $iFilesLoad > 0 Then
		TrayTip("Подчказка", "Успешно закачено на FTP отчётов: " & $iFilesLoad, 2000)
	Else
		TrayTip("Подчказка", "Нет отчётов для закачки на FTP", 2000)
	EndIf
	Sleep(2000)
;~ 	TrayTip("Подчказка","",2000)

	_FTP_Close($hOpen)
EndFunc   ;==>SendReportsOnFTP

Func _GetFtpOrigSize($file)
	Local $FtpSize
	$FtpSize = StringRegExp($file, '\(([0-9]*?)\)\.[^.]*$', 2)
	If UBound($FtpSize) > 1 Then
		$FtpSize = $FtpSize[1]
	Else
		$FtpSize = 0
	EndIf
	Return $FtpSize
EndFunc   ;==>_GetFtpOrigSize

Func _error($text)
	MsgBox(0, "Ошибка загрузки отчетов на FTP", "Ошибка загрузки отчетов на FTP:" & @CRLF & $text, 20)
	Exit
EndFunc   ;==>_error

Func _FTP_GetList($hSession, $sPath, ByRef $aFilesFTP, $iFilesAndFolders = 1)

	Local $aFind, $iCount

;~     $sPath = StringRegExpReplace($sPath, '(^(\\|/)+|(^.+))', '\\$3')
	_FTP_DirSetCurrent($hSession, $sPath)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _FTP_DirGetCurrent($hSession) = ' & _FTP_DirGetCurrent($hSession) & @CRLF) ;### Debug Console
	$aFind = _FTP_ListToArrayEx($hSession)
;~ 	_ArrayDisplay($aFind)
	If $aFind <> 0 Then
		For $i = 1 To $aFind[0][0]
			$iCount = UBound($aFilesFTP)
			If BitAND($aFind[$i][2], $FILE_ATTRIBUTE_DIRECTORY) Then
				If $iFilesAndFolders = 1 Then
					ReDim $aFilesFTP[UBound($aFilesFTP) + 1][6]
					$aFilesFTP[$iCount][0] = $sPath & '/' & $aFind[$i][0]
					$aFilesFTP[$iCount][1] = $aFind[$i][1]
					$aFilesFTP[$iCount][2] = $aFind[$i][2]
					$aFilesFTP[$iCount][3] = $aFind[$i][3]
					$aFilesFTP[$iCount][4] = $aFind[$i][4]
					$aFilesFTP[$iCount][5] = $aFind[$i][5]
;~                     ConsoleWrite($sPath & '/' & $aFind[$i][0] & @CRLF)
				EndIf
				_FTP_GetList($hSession, $sPath & '/' & $aFind[$i][0], $aFilesFTP, $iFilesAndFolders)
			Else
				ReDim $aFilesFTP[UBound($aFilesFTP) + 1][6]
;~                 $aFilesFTP[$iCount][0] = $sPath & '/' & $aFind[$i][0] ;отключен вывод директорий за ненадобностью
				$aFilesFTP[$iCount][0] = $aFind[$i][0]
				$aFilesFTP[$iCount][1] = $aFind[$i][1]
				$aFilesFTP[$iCount][2] = $aFind[$i][2]
				$aFilesFTP[$iCount][3] = $aFind[$i][3]
				$aFilesFTP[$iCount][4] = $aFind[$i][4]
				$aFilesFTP[$iCount][5] = $aFind[$i][5]
;~                 ConsoleWrite($sPath & '/' & $aFind[$i][0] & @CRLF)
			EndIf
		Next
	EndIf
EndFunc   ;==>_FTP_GetList

Func _PathSplitByRegExp($sPath, $pDelim = '', $mod = -1)
	If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

	Local $aRetArray[8] ;, $pDelim = ""

	If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
	If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

	If $pDelim = "" Then $pDelim = "/"
	If Not StringInStr($sPath, $pDelim) Then Return $sPath
	If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"
	If $mod >= 0 Then
		Switch $mod
			Case 0
				Return $sPath
			Case 1
				Return StringRegExpReplace($sPath, $pDelim & '.*', $pDelim) ;Drive letter
			Case 2
				Return StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
			Case 3
				Return StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
			Case 4
				Return StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
			Case 5
				Return StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
			Case 6
				Return StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
			Case 7
				Return StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file
		EndSwitch
	EndIf

	$aRetArray[0] = $sPath ;Full path
	$aRetArray[1] = StringRegExpReplace($sPath, $pDelim & '.*', $pDelim) ;Drive letter
	$aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
	$aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
	$aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
	$aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
	$aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
	$aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file

	Return $aRetArray
EndFunc   ;==>_PathSplitByRegExp
