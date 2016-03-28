#include <Array.au3>
$timer = TimerInit()

$sPath ='C:\Расшифровка2'
$sMask = '*.RAr'
$iDel = 0
$iNoDel = 0
$iStart = TimerInit()
$aSearch = _FileSearch($sPath, $sMask, 1)
Dim $aSearch2[Ubound($aSearch)]
For $i=0 to Ubound($aSearch)-1
	if StringInStr ( $aSearch[$i], ".RAr", 1) Then
		$aSearch2[$i] = $aSearch[$i]
	EndIf
Next


ConsoleWrite(TimerDiff($timer) & @CRLF)
_ArrayDisplay($aSearch2)

;$iFlag = 0 - Файлы и папки (по умолчанию)
;$iFlag = 1 - Только файлы
;$iFlag = 2 - Только папки
Func _FileSearch($sPath, $sFileMask, $iFlag = 0)
    Local $sOutBin, $sOut, $aOut, $sRead, $hDir, $sAttrib

    Switch $iFlag
        Case 1
            $sAttrib = ' /A-D'
        Case 2
            $sAttrib = ' /AD'
        Case Else
            $sAttrib = ' /A'
    EndSwitch

    $sOut = StringToBinary('0' & @CRLF, 2)
    $aMasks = StringSplit($sFileMask, ';')

    For $i = 1 To $aMasks[0]
        $hDir = Run(@ComSpec & ' /U /C DIR "' & $sPath & '\' & $aMasks[$i] & '" /S /B' & $sAttrib, @SystemDir, @SW_HIDE, 6)

        While 1
            $sRead = StdoutRead($hDir, False, True)

            If @error Then
                ExitLoop
            EndIf

            If $sRead <> "" Then
                $sOut &= $sRead
            EndIf
        WEnd
    Next
    $aOut = StringRegExp(BinaryToString($sOut, 2), '[^\r\n]+', 3)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : BinaryToString($sOut, 2) = ' & BinaryToString($sOut, 2) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    If @error Then
        Return SetError(1)
    EndIf

    $aOut[0] = UBound($aOut) - 1
    Return $aOut
EndFunc   ;==>_FileSearch