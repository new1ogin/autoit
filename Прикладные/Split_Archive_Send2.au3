#Region *;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #RequireAdmin ;это для семерки, в XP не надо
FileInstall('7za.exe', @TempDir, 1)
#include <Encoding.au3>
#include <array.au3>
#include <FTPEx.au3>

global $sPath,$bytes,$sPathTemp,$part,$bytesStep,$steps
$7zaexe = @ScriptDir&'\7za.exe'
if not FileExists($7zaexe) Then $7zaexe = @tempdir&'\7za.exe'
$t1 = Timerinit() ;
HotKeySet("^+{F7}", "_Quit")

; упорядочивание данных переданных из коммандной строки
dim $CmdLineN[Ubound($CmdLine)]
$CmdLineN=$CmdLine
dim $CmdLineN[6]
$CmdLineN[0] = 5
;~ $CmdLineN[1] = '-h'
$CmdLineN[1] = 'd:\WindowsImageBackup\Windows XP Professional-s001.vmdk'
if not FileExists($CmdLineN[1]) Then $CmdLineN[1] = 'D:\Мультимедиа\пластика видео уроки\Kak_sdelat_Imitatciiu_kamnia_Malahit_iz_Polimernoi_Gliny.mp4'
$CmdLineN[2] = '-temp'
$CmdLineN[3] = 'D:\temp'
$CmdLineN[4] = '-b'
$CmdLineN[5] = '100'
;установка начальных значений внутри функции
$aCmd = _cmdGet($CmdLineN)
$sPathName = _PathSplitByRegExp($sPath)
$sPathlName = $sPathName[6]
$sPathName = $sPathName[5]
$ftpdir = '/pub/temp/' & @ComputerName & '-' & DriveGetSerial(@HomeDrive)
$LastFile = ''
$sPathTemp = $sPathTemp & '\'
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sPath = ' & $sPath & @CRLF ) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $bytes = ' & $bytes & @CRLF ) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sPathTemp = ' & $sPathTemp & @CRLF ) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $part = ' & $part & @CRLF ) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $bytesStep = ' & $bytesStep & @CRLF ) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $steps = ' & $steps & @CRLF ) ;### Debug Console

;~ _arrayDisplay($aCmd)

$server = 'proff.scalpnet.ru'
$username = 'proff'
$pass = 'proff'
$dwError = ''
$szMessage = ''
;Вывод справки в cmd
if $aCmd[5] == 0 or $aCmd[5] == '' then
else
	ConsoleWrite(_Encoding_ANSIToOEM('Справка: ') & @LF)
	_Quit()
endif

;определение части (продолжить, или начать с начала)
$Open = _FTP_Open('MyFTP Control')
$Conn = _FTP_Connect($Open, $server, $username, $pass, 1)
;~ if _FTP_GetLastResponseInfo($dwError,$szMessage) then ConsoleWrite('err= '&$dwError&'. '&'msg= '&$szMessage&'. ' &@CRLF)
if $Conn = 0 Then ConsoleWrite('Подключение к фтп произошло с ошибкой' & @CRLF)
_FTP_DirCreate($Conn, $ftpdir)
_FTP_DirSetCurrent($Conn,  $ftpdir)
$ftpCurrDir = _FTP_DirGetCurrent ($Conn)
ConsoleWrite($ftpCurrDir & @CRLF)
$aFile = _FTP_ListToArray($Conn, 2)
;if $ftpCurrDir = $ftpdir then
if ubound($aFile)>0 then
_ArrayDisplay($aFile) ; Отладка
For $i=1 to $aFile[0]
	if StringInStr($aFile[$i],$sPathlName) and $aFile[$i] > $LastFile Then
		$LastFile = $aFile[$i]
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $LastFile = ' & $LastFile & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	EndIf
Next
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $LastFile = ' & $LastFile & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
endif
if stringlen($LastFile) >1 Then
	$LastFile = _PathSplitByRegExp($LastFile)
	$LastFile = $LastFile[7]
else
	$LastFile = 0
EndIf

$Ftpc = _FTP_Close($Open)
exit
; ---- Здесь должна быть проверка на имебющиеся на FTP файлы -----


$hRead = FileOpen($sPath, 16)
$iSize = FileGetSize($sPath)
;~ _Split_n(2)

;Чтение
FileSetPos($hRead, 0, 0)
$i = $LastFile + 1
While 1
	$t2 = Timerinit()
	$FileW = $sPathTemp & $sPathName ; & 'file_' & $i & '.small'
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileW = ' & $FileW & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	$FileA = $sPathTemp & 'file_' & $i &'.7z'
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileA = ' & $FileA & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	_Split_n($i, $FileW)
	RunWait(@ComSpec & " /c " & ''&$7zaexe&' a "'&$FileA&'" -mx=1 "'&$FileW&'"', "", @SW_HIDE)
	if FileGetSize($FileA) > 64 Then FileDelete($FileW)
	if $iSize < $bytes*$i Then Exitloop
	$i += 1
	ConsoleWrite('время одной части номр '& $i-1 & ' вно =  '  & timerdiff($t2) &@CRLF)
	exit
WEnd
FileClose($hRead)

	ConsoleWrite('время всех частей = '  & timerdiff($t1) &@CRLF)



; Извлечение из файла части $n
Func _Split_n($n, $FileW='')
	if FileExists($FileW) Then FileDelete($FileW)
	if $bytes > $bytesStep Then
		$hWrite = FileOpen($FileW, 16 + 1)
		FileSetPos($hRead, $bytes*($n-1), 0)
		for $s=1 to Ceiling($steps)
			if $s=Ceiling($steps) Then
				$xChunk = FileRead($hRead, $bytes-($bytesStep*Floor($steps))) ; добавить не ровный шагу конец файла
			Else
				$xChunk = FileRead($hRead, $bytesStep)
			EndIf
			FileWrite($hWrite, $xChunk)
			if Mod ($s,10) = 0 then ConsoleWrite('|') ; Для наблюдения за ходом процесса
		next
	else ; На случай если файл меньше шага
		$hWrite = FileOpen($FileW, 16 + 2)
		FileSetPos($hRead, $bytes*($n-1), 0)
		$xChunk = FileRead($hRead, $bytes)
		FileWrite($hWrite, $xChunk)
	endif
	FileClose($hWrite)
EndFunc









Func _cmdGet($CmdLineN)
	local $aCmd, $t3, $s1, $s2, $pn
	dim $aCmd[10]
	$t3 = ''
	for $i=1 to $CmdLineN[0]
		; получение первых символов параметров
		$s1 = StringLeft($CmdLineN[$i],1)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $s1 = ' & $s1 &  @CRLF) ;### Debug Console
		if Ubound($CmdLineN) > $i + 1 Then
			$s2 = StringLeft($CmdLineN[$i+1],1)
		Else
			$s2 = ''
		Endif
		; проверка первого параметра
		if $i=1 Then
			if not FileExists($CmdLineN[1]) Then
				 if $s1 = '-' or $s1 = '/' Then
					 if StringMid($CmdLineN[$i], 2) = '?' or StringMid($CmdLineN[$i], 2) = 'h' or StringMid($CmdLineN[$i], 2) = 'help' Then
						 $aCmd[5] = $CmdLineN[$i]
					 Else
						 _Quit("Файл "& $CmdLineN[1] &" не доступен!")
					 Endif
				 Else
					 _Quit("Файл "& $CmdLineN[1] &" не доступен!")
				 Endif
			Else
				 $sPath = $CmdLineN[1]
			Endif
		Endif
		;Присваение параметрам значений
		if $s1 = '-' or $s1 = '/' Then
			$pn = StringMid($CmdLineN[$i], 2)
			if $pn = 'temp' or $pn = 't' Then
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then
					$aCmd[0] = $CmdLineN[$i+1]
				Endif
			Endif
			if $pn = 'bytes' or $pn = 'b' Then
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then
					$aCmd[1] = $CmdLineN[$i+1]
				Endif
			Endif
			if $pn = 'part' or $pn = 'p' Then
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then $aCmd[2] = $CmdLineN[$i+1]
			Endif
			if $pn = 'ftp' Then
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then $aCmd[3] = $CmdLineN[$i+1]
			Endif
			if $pn = 'ftpmode' or $pn = 'fm' Then
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then $aCmd[4] = $CmdLineN[$i+1]
			Endif

		Endif
	next

	if StringLen($aCmd[1]) > 1 Then
		$bytes = $aCmd[1]*1024*1024
	Else
		$bytes = 1024*1024*1024
	EndIf

	if StringLen($aCmd[0]) > 1 Then
		$sPathTemp = $aCmd[0]
	Else
	;~ 	$size = (FileGetSize ($sPath)/1048576)*2
		$size = 2*$bytes/1048576
		$sPathTemp = _GetTemp($size)
	EndIf
	if StringLen($aCmd[2]) > 1 Then
		$part = $aCmd[2]
	Else
		$part = 'auto'
	EndIf
	$bytesStep = 16 *1024*1024
	$steps = $bytes/$bytesStep

	return $aCmd
Endfunc

Func _GetTemp($size)
	$tempdir = ''
	$FreeSpace = DriveSpaceFree ( @TempDir )
	if $size > $FreeSpace Then
		$aDriveList = DriveGetDrive ( "FIXED" )
;~ 		Dim $aFreeSpaces[$aDriveList[0]]
		For $i=1 to $aDriveList[0]
			$FreeSpace =DriveSpaceFree ( $aDriveList[$i] )
;~ 			ConsoleWrite('@@ Debug(' & $aDriveList[$i] & ') : $FreeSpace = ' & $FreeSpace & @CRLF ) ;### Debug Console
			if $size < $FreeSpace Then
				$tempdir = $aDriveList[$i] & '\Temp\Split_n_Archive'
				ExitLoop
			EndIf
		Next
	Else
		$tempdir = @TempDir & '\Split_n_Archive'
	EndIf
	if $tempdir = '' Then
		_Quit('Не найденно достаточно свободноо места на дисках')
	EndIf

	Return $tempdir
EndFunc


Func _Quit($message = '')
	if $message <> '' Then ConsoleWrite(_Encoding_ANSIToOEM($message) & @LF)
	Exit
EndFunc

Func _PathSplitByRegExp($sPath,$pDelim='')
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"

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