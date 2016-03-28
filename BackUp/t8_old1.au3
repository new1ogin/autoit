#Include <array.au3>
#Include <Encoding.au3>
#include <String.au3>
#include <date.au3>

$sMegaCmdPatch = @ScriptDir&'\megacmd.exe'
$sMegaCmdPatchJson = @ScriptDir&'\.megacmd.json'
$sAttrib = '-force -recursive'
$sMegaCmdPatchJson = StringReplace($sMegaCmdPatchJson,'\','\\')
$iMaxSizeCloud = 49000000000

; œŒÀ”◊¿≈Ã —œ»—Œ  ¬—≈’ ‘¿…ÀŒ¬ — Œ¡À¿ ¿
$sCommand = 'list mega:/'
$hDir = Run(@ComSpec &  " /k " & $sMegaCmdPatch & ' -conf="' & $sMegaCmdPatchJson & '" ' & $sAttrib & ' ' & $sCommand, 'C:\1', @SW_MAXIMIZE, 8)
;~ $hDir = Run(@ComSpec &  " /c " & 'ping 127.0.0.1', @SystemDir, @SW_HIDE, 6)
ConsoleWrite(@ComSpec &  " /k " & $sMegaCmdPatch & ' -conf="' & $sMegaCmdPatchJson & '" ' & $sAttrib & ' ' & $sCommand & @CRLF)
$sOut=''
While 1
	$sRead = StdoutRead($hDir, False, True)

	If @error Then
		ExitLoop
	EndIf

	If $sRead <> "" Then
		$sOut &= _Encoding_CyrillicTo1251(_HexToString($sRead))
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sOut = ' & $sOut & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	EndIf
	sleep(10)
Wend

ConsoleWrite($sOut)
; Œ¡–¿¡¿“€¬¿≈Ã —œ»—Œ  ‘¿…ÀŒ¬
$aOut = StringSplit(StringReplace($sOut,@CRLF,@LF),@CRLF)
Local $aListFiles[$aOut[0]][3]
$aListFiles[0][0]=$aOut[0]
;~ _ArrayDisplay($aOut)
For $i=1 to $aOut[0]
	$aString=StringRegExp($aOut[$i],"(.*) +?(\d+?) +?(\d\d\d\d)-(\d\d)-(\d\d).*?(\d\d):(\d\d):(\d\d).*?(\d\d):(\d\d)",3)
	if not @error then
		$aListFiles[$i][0]=$aString[0]
		$aListFiles[$i][2]=$aString[1]
		$ConvertDate=$aString[2]&'/'&$aString[3]&'/'&$aString[4]&' '&StringRight('0'&($aString[5]-$aString[8]),2)&':'&StringRight('0'&($aString[6]-$aString[9]),2)&':'&$aString[7]
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ConvertDate = ' & $ConvertDate & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$aListFiles[$i][1]=_DateDiff("s", "1970/01/01 00:00:00", $ConvertDate)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aListFiles[ = ' & $aListFiles[$i][1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$aListFiles[0][2]+=$aListFiles[$i][2]
	EndIf
Next

_ArrayDisplay($aListFiles)