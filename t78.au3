

HotKeySet("^+{F7}", "_Quit")
$sPath = 'C:\UltraVNC_1_2_05_X64_Setup.exe'
$sPathNew = 'D:\temp\'
$bytes = 1024*1024
if not FileExists($sPath) Then _Quit("Файл "& $sPath &" не доступен!")
$hRead = FileOpen($sPath, 16)
$iSize = FileGetSize($sPath)
$i = 1
_Split_n(2)

FileSetPos($hRead, 0, 0)
$i = 1
While 1
    $hWrite = FileOpen($sPathNew & 'file_' & $i & '.small', 16 + 2)
    $xChunk = FileRead($hRead, $bytes)
;~     If @error = -1 Then ExitLoop
    FileWrite($hWrite, $xChunk)
    FileClose($hWrite)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileGetPos ( $hRead ) = ' & FileGetPos ( $hRead ) & @CRLF ) ;### Debug Console
	if $iSize < $bytes*$i Then Exitloop
	$i += 1
WEnd
FileClose($hRead)




Func _Split_n($n)
    $hWrite = FileOpen($sPathNew & 'file1_' & $n & '.small', 16 + 2)
	FileSetPos($hRead, $bytes*($n-1), 0)
    $xChunk = FileRead($hRead, $bytes)
    FileWrite($hWrite, $xChunk)
	FileClose($hWrite)
EndFunc













Func _Quit($message = 0)
	Exit
EndFunc