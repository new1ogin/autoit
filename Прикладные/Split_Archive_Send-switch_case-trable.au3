#Region *;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Change2CUI=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <7Zip.au3>
#include <Encoding.au3>
#include <array.au3>
$sPathTo = @TempDir & '\7-zip32.dll'
$sPathTo64 = @TempDir & '\7-zip64.dll'
FileInstall('7-zip32.dll', $sPathTo, 1)
FileInstall('7-zip64.dll', $sPathTo64, 1)
$t1 = Timerinit() ;
HotKeySet("^+{F7}", "_Quit")

; упорядочивание данных переданных из коммандной строки
dim $CmdLineN[Ubound($CmdLine)]
$CmdLineN=$CmdLine
dim $CmdLineN[6]
$CmdLineN[0] = 5
$CmdLineN[1] = 'd:\WindowsImageBackup\Windows XP Professional-s001.vmdk'
$CmdLineN[2] = '-temp'
$CmdLineN[3] = 'D:\temp'
$CmdLineN[4] = '-b'
$CmdLineN[5] = '100'



dim $aCmd[10]
$t3 = ''
for $i=1 to $CmdLineN[0]
	; получение первых символов параметров
	$s1 = StringLeft($CmdLineN[$i],1)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $s1 = ' & $s1 &  @CRLF) ;### Debug Console
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
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $s2 = ' & $s2 &  @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringMid($CmdLineN[$i], 2) = ' & StringMid($CmdLineN[$i], 2) &  @CRLF) ;### Debug Console
		if StringMid($CmdLineN[$i], 2) = 'b' Then ConsoleWrite('@@ Debug(' & StringMid($CmdLineN[$i], 2) & ')' &  @CRLF)
		$pn = StringMid($CmdLineN[$i], 2)
		switch StringMid($CmdLineN[$i], 2)
			case 'temp' or 't'
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $s2 = ' & $s2 &  @CRLF) ;### Debug Console
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then
					$aCmd[0] = $CmdLineN[$i+1]
					ConsoleWrite('@@ Debug(' & StringMid($CmdLineN[$i], 2) & ') : $aCmd[0] = ' & $aCmd[0] &  @CRLF) ;### Debug Console
				Endif
			case 'bytes' or 'b'
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $s2 = ' & $s2 &  @CRLF) ;### Debug Console
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then
					$aCmd[1] = $CmdLineN[$i+1]
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aCmd[1] = ' & $aCmd[1] &  @CRLF) ;### Debug Console
				Endif
			case 'part' or 'p'
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then $aCmd[2] = $CmdLineN[$i+1]
			case 'ftp'
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then $aCmd[3] = $CmdLineN[$i+1]
			case 'ftpmode' or 'fm'
				if $s2 <> '-' and $s2 <> '/' and $s2 <> '' Then $aCmd[4] = $CmdLineN[$i+1]
;~ 			case '?' or 'h' or 'help'
;~ 				$aCmd[5] = $CmdLineN[$i]
		endswitch
;~ 	Elseif Ubound($aLine) = 2 then; -> Ubound($aLine) = 3
;~ 		if $aLine[1] = '?' or $aLine[1] = 'h' or $aLine[1] = 'help' Then
;~ 			$aCmd[5] = $aLine[1]
;~ 		Endif
;~ 	Endif ; -> Ubound($aLine) = 3
	Endif
next
_arrayDisplay($aCmd)
$sPathNew = 'D:\temp\'
$bytes = 1024*1024*1024
$bytesStep = 16 *1024*1024
$steps = $bytes/$bytesStep


if $aCmd[5] == 0 then
else
	ConsoleWrite(_Encoding_ANSIToOEM('Справка: ') & @LF)
endif
exit

if not FileExists($sPath) Then _Quit("Файл "& $sPath &" не доступен!")
$hRead = FileOpen($sPath, 16)
$iSize = FileGetSize($sPath)
$i = 1
;~ _Split_n(2)

FileSetPos($hRead, 0, 0)
$i = 1
While 1
	$t2 = Timerinit()
	$FileW = $sPathNew & 'file_' & $i & '.small'
	$FileA = $sPathNew & 'file_' & $i &'.7z'
	if FileExists($FileW) Then FileDelete($FileW)
	if $bytes > $bytesStep Then
		$hWrite = FileOpen($FileW, 16 + 1)
		for $s=1 to $steps
			$xChunk = FileRead($hRead, $bytesStep)
			FileWrite($hWrite, $xChunk)
			if Mod ($s,10) = 0 then ConsoleWrite('|')
		next
	else
    $hWrite = FileOpen($FileW, 16 + 2)
    $xChunk = FileRead($hRead, $bytes)
    FileWrite($hWrite, $xChunk)
	endif
    FileClose($hWrite)
;~ 	$7ZipAdd = _7ZipAdd(0, $sPathNew & 'file_' & $i &'.7z', $sPathNew & 'file_' & $i & '.small', " -hide")
	$7ZipAdd = _7ZipAdd(0, $FileA, $FileW, " -hide", 9)
	if FileGetSize($FileA) > 64 Then FileDelete($FileW)

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $7ZipAdd = ' & $7ZipAdd &  @CRLF) ;### Debug Console
;	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileGetPos ( $hRead ) = ' & FileGetPos ( $hRead ) & @CRLF ) ;### Debug Console
	if $iSize < $bytes*$i Then Exitloop
	$i += 1
	ConsoleWrite('время одной части номр '& $i-1 & ' вно =  '  & timerdiff($t2) &@CRLF)
WEnd
FileClose($hRead)

	ConsoleWrite('время всех частей =  '  & timerdiff($t1) &@CRLF)



Func _Split_n($n)
    $hWrite = FileOpen($sPathNew & 'file1_' & $n & '.small', 16 + 2)
	FileSetPos($hRead, $bytes*($n-1), 0)
    $xChunk = FileRead($hRead, $bytes)
    FileWrite($hWrite, $xChunk)
	FileClose($hWrite)
EndFunc













Func _Quit($message = '')
	if $message <> '' Then ConsoleWrite(_Encoding_ANSIToOEM($message) & @LF)
	Exit
EndFunc