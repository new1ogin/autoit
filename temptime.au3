#RequireAdmin

#Include <WinAPI.au3>
#Include <array.au3>

#include <File.au3>
#include <Array.au3>
$diff =  _DateDiff('s', _GetYoungTimeSystemFiles(2,2),_NowCalc()) ; _DateDiff('n', _NowCalc(), _GetYoungTimeSystemFiles(2,2))
;~ 						'11/04/2014 17:50:28'
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $diff = ' & $diff & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ _GetYoungTimeSystemFiles(2)
$t99=TimerInit()
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GetYoungTimeSystemFiles(1) = ' & _GetYoungTimeSystemFiles(1) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($t99) = ' & TimerDiff($t99) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ $t99=TimerInit()
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GetYoungTimeSystemFiles(1) = ' & _GetYoungTimeSystemFiles(2,1) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($t99) = ' & TimerDiff($t99) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ $t99=TimerInit()
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GetYoungTimeSystemFiles(1) = ' & _GetYoungTimeSystemFiles(2,2) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($t99) = ' & TimerDiff($t99) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GetYoungTimeSystemFiles(2) = ' & _GetYoungTimeSystemFiles(2) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Func _GetYoungTimeSystemFiles($DateFormat=2,$FoldeFile=0)
$sDir_Where_Search = @WindowsDir& '\System32'
$sFile_To_Write = @ScriptDir & '\Youngest_Folder.txt'
$sYoungest_Folder = ''
$sTime = ''

$aTemp = _FileListToArray($sDir_Where_Search, '*', $FoldeFile)
If @error Then Exit 13
Dim $aDir_and_Time[$aTemp[0] + 1][2] = [[$aTemp[0]]]
For $i = 1 To $aDir_and_Time[0][0]
    $aDir_and_Time[$i][0] = $aTemp[$i]
    $aDir_and_Time[$i][1] = FileGetTime($sDir_Where_Search & '\' & $aTemp[$i], $DateFormat, 1)
Next
$aTemp = 0
_ArraySort($aDir_and_Time, 1, 1, 0, 1)
For $i = 1 To $aDir_and_Time[0][0]
    If $aDir_and_Time[$i][1] Then
        $sYoungest_Folder = $sDir_Where_Search & '\' & $aDir_and_Time[$i][0]
        $sTime = StringRegExpReplace($aDir_and_Time[$i][1], '^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})', '$1/$2/$3 $4:$5:$6')
        ExitLoop
    EndIf
Next
return $sTime
endfunc
;~ If $sYoungest_Folder Then
;~     $aTemp = _FileListToArray($sYoungest_Folder)
;~     If @error Then Exit 13
;~     $sYoungest_Folder &= @TAB & 'Created: ' & $sTime & @CRLF
;~     For $i = 1 To $aTemp[0]
;~         $sYoungest_Folder &= $aTemp[$i] & @CRLF
;~     Next
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sYoungest_Folder = ' & $sYoungest_Folder & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		msgbox(0,'',$sYoungest_Folder)
;~ 	exit
;~     $hFile = FileOpen($sFile_To_Write, 2)
;~     If $hFile = -1 Then Exit 13
;~     FileWrite($hFile, StringTrimRight($sYoungest_Folder, 2))
;~     FileClose($hFile)
;~ Else
;~     ConsoleWrite('error' & @LF)
;~ EndIf



exit
$Timer = TimerInit()
$Status = _IsInternet()
$Diff = TimerDiff($Timer)
ConsoleWrite('Статус: ' & $Status & '   (' & Round($Diff / 1000, 3) & ' сек)' & @CR)
_NowTime()
$patch = 'C:\Windows\System32\config\SYSTEM.LOG'
$t =  FileGetTime($patch , 2)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$hFile = _WinAPI_CreateFile('"C:\Windows\System32\config\SYSTEM.LOG"', 1)
$t3=_Date_Time_GetFileTime($hFile)
;~ _ArrayDisplay($t3)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t3 = ' & $t3[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _NowTime() = ' & _NowCalcDate() & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
Func _IsInternet()
    Local $Ret = DllCall('wininet.dll', 'int', 'InternetGetConnectedState', 'dword*', 0x20, 'dword', 0)
    If @error Then
        Return SetError(1, 0, 0)
    EndIf
    Local $Error = _WinAPI_GetLastError()
    Return SetError((Not ($Error = 0)), $Error, $Ret[0])
EndFunc   ;==>_IsInternet


exit



Run(@ComSpec & ' /C TIME 00:00:00', '', @SW_HIDE)

	#include <Date.au3>

;~ 	_Date_Time_SetSystemTime

_SetTime(@HOUR + 1, @MIN)