#include <WinAPI.au3>
HotKeySet("^+{F7}", "_Quit") ;Это вызов
$sPath = 'C:\100MB.txt'
$sPathNew = 'D:\temp\'
$newFileName = "File"
$t = timerinit()
$iSize = FileGetSize($sPath)
;~ $hRead = FileOpen($sPath, 16)
Global $sFile, $hFile, $sText, $nBytes, $tBuffer
$hFile = _WinAPI_CreateFile($sPath, 2, 2)
$bytes = 5*1024*1024
$i = 0
While 1
;~     $hWrite = FileOpen($sPathNew & 'file_' & $i & '.small', 16 + 2)
;~     $xChunk = FileRead($hRead, 5*1024*1024)
;~     If @error = -1 Then ExitLoop
;~     FileWrite($hWrite, $xChunk)
;~     FileClose($hWrite)


	if $iSize > $bytes*$i Then
		_WinAPI_SetFilePointer($hFile, $bytes*$i)
	Else
		ExitLoop
	Endif
	if $iSize > $bytes*$i+1 Then
		$tBuffer = DllStructCreate("byte[" & $bytes & "]")
		_WinAPI_ReadFile($hFile, DllStructGetPtr($tBuffer), $bytes, $nBytes)
	Else
		$tBuffer = DllStructCreate("byte[" & $iSize-$bytes*$i & "]")
		_WinAPI_ReadFile($hFile, DllStructGetPtr($tBuffer), $iSize-$bytes*$i, $nBytes)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iSize-$bytes*$i = ' & $iSize-$bytes*$i & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Endif


	$hNewFile = FileOpen ( $sPathNew & $newFileName & "_" &$i,  )
	FileWrite (  , DllStructGetData($tBuffer, 1) )
    $i += 1
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $i = ' & $i & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
WEnd
_WinAPI_CloseHandle($hFile)
;~ FileClose($hRead)

;~ Timerdiff($t)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Timerdiff($t) = ' & Timerdiff($t) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console













Func _Quit($message = 0)
	Exit
EndFunc