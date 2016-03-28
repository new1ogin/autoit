#Region *;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #RequireAdmin ;это для семерки, в XP не надо
$p = '\Split_n_Archive'
if not FileExists(@TempDir & $p &'\7za.exe') then
FileInstall('7za.exe', @TempDir & $p &'\7za.exe', 1)
EndIf
if not FileExists(@TempDir & $p & '\WinSCP.com') then
FileInstall('WinSCP.com', @TempDir & $p & '\WinSCP.com', 1)
EndIf
if not FileExists(@TempDir & $p & '\WinSCP.exe') then
FileInstall('WinSCP.exe', @TempDir & $p & '\WinSCP.exe', 1)
EndIf
#include <Encoding.au3>
#include <array.au3>
#include <FTPEx.au3>
#Include <Constants.au3>

global $sPath,$bytes,$sPathTemp,$part,$bytesStep,$steps
$7zaexe = @ScriptDir&'\7za.exe'
$Winscpexe = @ScriptDir&'\WinSCP.com'
if not FileExists($7zaexe) Then $7zaexe = @tempdir&'\7za.exe'
if not FileExists($Winscpexe) Then $Winscpexe = @tempdir&'\WinSCP.com'
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
$speedFTp = ''
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

; ---- Здесь должна быть проверка на имебющиеся на FTP файлы -----


$hRead = FileOpen($sPath, 16)
$iSize = FileGetSize($sPath)
;~ _Split_n(2)

;Чтение
FileSetPos($hRead, 0, 0)
$i = $LastFile + 1
While 1
;~ 	; Проверка не работает ли уже архиватор
;~ 	$findProc = _searchCildrenProcess('7za')
;~ ; Позволяет протестировать скорость на тестовом файле "C:\1MB.txt"
;~ $convTestSpeed = Run ( @ComSpec & " /c " & _
;~ 'C:\Programs\winscp.com /command "option batch abort" "option confirm off" "open ftp://proff:proff@proff.scalpnet.ru/" "put ""C:\1MB.txt"" /pub/temp/" "exit"', _
;~ "", @SW_HIDE, $STDERR_MERGED )
;~ $t = _speed($convTestSpeed)

	; Проверка на завершение закачки на сервер
	$findProc = 1
	While $findProc <> 0
		$findProc = _searchCildrenProcess('WinSCP')
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $findProc = ' & $findProc & @CRLF ) ;### Debug Console
		sleep(500)
	WEnd

	$t2 = Timerinit()
	$FileW = $sPathTemp & $sPathName ; & 'file_' & $i & '.small'
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileW = ' & $FileW & @CRLF ) ;### Debug Console
	$FileA = $sPathTemp & 'file_' & $i &'.7z'
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileA = ' & $FileA & @CRLF ) ;### Debug Console
	_Split_n($i, $FileW)
	RunWait(@ComSpec & " /c " & ''&$7zaexe&' a -ssw "'&$FileA&'" -mx=1 "'&$FileW&'" >> log_file.%date%.txt', "", @SW_HIDE)
	if FileGetSize($FileA) > 64 Then FileDelete($FileW)
	; Загрузка на FTP
	$speedFTP = '-speed=4000'
	$conv = Run ( @ComSpec & " /c " & $Winscpexe & _
	' /command "option batch abort" "option confirm off" "open ftp://proff:proff@proff.scalpnet.ru/" "put ""' & _
	$FileA & '"" ' & $ftpdir & '/ ' & $speedFTP & '" "exit"', "", @SW_HIDE, $STDERR_MERGED )
	_speed($conv, 3)
	if $iSize < $bytes*$i Then Exitloop
	$i += 1
	ConsoleWrite('время одной части номр '& $i-1 & ' вно =  '  & timerdiff($t2) &@CRLF)
;~ 	exit
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

;установка начальных значений внутри функции
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

; Находит подходящую временную директорию
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

; выход
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

; Поиск в дочерних процессах
Func _searchCildrenProcess($SeacrchWord,$pid = @AutoItPID)
	local $t1
	$a_children = _ProcessGetChildren($pid)
	if not @error Then
		for $i=1 to $a_children[0][0]
;~ 			ConsoleWrite('@@ Debug(' & $pid & ') : $i = ' & $i & @CRLF ) ;### Debug Console
			if StringInStr($a_children[$i][1], $SeacrchWord) Then
				Return $a_children[$i][0] & '|' & $a_children[$i][1]
			Else
				$t1 = _searchCildrenProcess($SeacrchWord,$a_children[$i][0])
				if $t1 == 0 Then
				Else
					return $t1
				EndIf
			EndIf
		Next
	Else
		return 0
	EndIf
	return 0
EndFunc

; Возвращаяет дочерние процессы
Func _ProcessGetChildren($i_Pid) ; First level children processes only
    If IsString($i_Pid) Then $i_Pid = ProcessExists($i_Pid)
    If Not $i_Pid Then Return SetError(-1, 0, $i_Pid)

    Local Const $TH32CS_SNAPPROCESS = 0x00000002

    Local $a_tool_help = DllCall("Kernel32.dll", "long", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPPROCESS, "int", 0)
    If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_Pid)

    Local $tagPROCESSENTRY32 = _
            DllStructCreate( _
            "dword dwsize;" & _
            "dword cntUsage;" & _
            "dword th32ProcessID;" & _
            "uint th32DefaultHeapID;" & _
            "dword th32ModuleID;" & _
            "dword cntThreads;" & _
            "dword th32ParentProcessID;" & _
            "long pcPriClassBase;" & _
            "dword dwFlags;" & _
            "char szExeFile[260]")

    DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))

    Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)
    Local $a_pfirst = DllCall("Kernel32.dll", "int", "Process32First", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
    If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_Pid)

    Local $a_pnext, $a_children[11][2] = [[10]], $i_child_pid, $i_parent_pid, $i_add = 0
    $i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")

    If $i_child_pid <> $i_Pid Then
        $i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")

        If $i_parent_pid = $i_Pid Then
            $i_add += 1
            $a_children[$i_add][0] = $i_child_pid
            $a_children[$i_add][1] = DllStructGetData($tagPROCESSENTRY32, "szExeFile")
        EndIf
    EndIf

    While 1
        $a_pnext = DllCall("Kernel32.dll", "int", "Process32Next", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
        If IsArray($a_pnext) And $a_pnext[0] = 0 Then ExitLoop

        $i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")

        If $i_child_pid <> $i_Pid Then
            $i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")

            If $i_parent_pid = $i_Pid Then
                If $i_add = $a_children[0][0] Then
                    ReDim $a_children[$a_children[0][0] + 11][2]
                    $a_children[0][0] = $a_children[0][0] + 10
                EndIf

                $i_add += 1
                $a_children[$i_add][0] = $i_child_pid
                $a_children[$i_add][1] = DllStructGetData($tagPROCESSENTRY32, "szExeFile")
            EndIf
        EndIf
    WEnd

    If $i_add <> 0 Then
        ReDim $a_children[$i_add + 1][2]
        $a_children[0][0] = $i_add
    EndIf

    DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])

    If $i_add Then Return $a_children
    Return SetError(3, 0, 0)
EndFunc   ;==>_ProcessGetChildren

; Ожидание вывода скорости для загрузки одного файла
Func _speed($conv, $times=86400)
	$t = Timerinit()
	While (Timerdiff($t)/1000) < $times
		$Read = StdoutRead ( $conv, false, false )
		If @error Then ExitLoop
		If $Read <> '' Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Read = ' & $Read & @CRLF ) ;### Debug Console
			$speed = StringRegExp($Read, " ([0-9,]+) KiB/s", 2 )
			if Ubound($speed)>0 Then
				return $speed[1]
				exitloop
			EndIf
		EndIf
		Sleep ( 500 )
	WEnd
Endfunc