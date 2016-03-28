#include <array.au3>
#include <Encoding.au3>
#include <String.au3>
#include <date.au3>

$sMegaCmdPatch = @ScriptDir & '\megacmd.exe'
$sMegaCmdPatchJson = @ScriptDir & '\.megacmd.json'
$sMegaCmdPatchJson = StringReplace($sMegaCmdPatchJson, '\', '\\')
$iMaxSizeCloud = 49000000000
$sPatchToDelete = 'Backup'
$sCommand = 'delete ' & 'mega:/foo/bar/megacmd.exe'
$hDir = RunWait(@ComSpec & " /k " & $sMegaCmdPatch & ' -conf="' & $sMegaCmdPatchJson & '" ' & $sCommand, @ScriptDir, @SW_MAXIMIZE, 8)
Exit

if $CmdLine[0] > 0 Then
	$NCmdLine[1] = $CmdLine[1]
Else
	$NCmdLine[1] = 0
EndIf


; œŒÀ”◊¿≈Ã —œ»—Œ  ¬—≈’ ‘¿…ÀŒ¬ — Œ¡À¿ ¿
$sCommand = '-force -recursive list mega:/'
$hDir = Run(@ComSpec & " /k " & $sMegaCmdPatch & ' -conf="' & $sMegaCmdPatchJson & '" ' & $sCommand, @ScriptDir, @SW_MAXIMIZE, 8)

$sOut = ''
While 1
	$sRead = StdoutRead($hDir, False, True)

	If @error Then
		ExitLoop
	EndIf

	If $sRead <> "" Then
		$sOut &= _Encoding_CyrillicTo1251(_HexToString($sRead))
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sOut = ' & $sOut & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	EndIf
	Sleep(10)
WEnd

ConsoleWrite($sOut)
; Œ¡–¿¡¿“€¬¿≈Ã —œ»—Œ  ‘¿…ÀŒ¬
$aOut = StringSplit(StringReplace($sOut, @CRLF, @LF), @CRLF)
Local $aListFiles[$aOut[0]][3]
$aListFiles[0][0] = $aOut[0]
;~ _ArrayDisplay($aOut)
For $i = 1 To $aOut[0]
	$aString = StringRegExp($aOut[$i], "(.*) +?(\d+?) +?(\d\d\d\d)-(\d\d)-(\d\d).*?(\d\d):(\d\d):(\d\d).*?(\d\d):(\d\d)", 3)
	If Not @error Then
		$aListFiles[$i][0] = $aString[0]
		$aListFiles[$i][2] = $aString[1]
		$ConvertDate = $aString[2] & '/' & $aString[3] & '/' & $aString[4] & ' ' & StringRight('0' & ($aString[5] - $aString[8]), 2) & ':' & StringRight('0' & ($aString[6] - $aString[9]), 2) & ':' & $aString[7]
		$aListFiles[$i][1] = _DateDiff("s", "1970/01/01 00:00:00", $ConvertDate)
		$aListFiles[0][2] += $aListFiles[$i][2]
	EndIf
Next

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _ArrayMax($aListFiles,0,1,0,2) = ' & _ArrayMax($aListFiles,1,1,0,2) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
; ”‰‡ÎÂÌËÂ ÒÚ‡˚ı Ù‡ÈÎÓ‚
$iNextFilesSize = $aListFiles[0][2] + 2*_ArrayMax($aListFiles,0,1,0,2)
If $iNextFilesSize > $iMaxSizeCloud Then
	if StringInStr($NCmdLine[1],'2') then exit
	$iDelSize=0
	$timer=TimerInit()
	While 1
		$OldFileIndex = _ArrayMinIndex($aListFiles,0,1,0,1)
		if StringInStr($aListFiles[$OldFileIndex][0],'/'&$sPatchToDelete&'/') Then
			$sCommand = 'delete ' & $aListFiles
			$hDir = RunWait(@ComSpec & " /k " & $sMegaCmdPatch & ' -conf="' & $sMegaCmdPatchJson & '" ' & $sCommand, @ScriptDir, @SW_MAXIMIZE, 8)
			$iDelSize+=$aListFiles[$OldFileIndex][2]
			if $iNextFilesSize-$iDelSize < $iMaxSizeCloud then exitloop
		EndIf
		if TimerDiff($timer) > 1200000 Then exitloop ; 20 ÏËÌÛÚ
	WEnd

EndIf




_ArrayDisplay($aListFiles)
