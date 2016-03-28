#Include <FileOperations.au3>
#Include <array.au3>

$sPath = _PathSplitByRegExp(@UserProfileDir,'',2)

dim $AccFiles[3]
$timer = Timerinit()
;~ $AccFiles = _FO_FileSearch ( $sPath, 'accounts.xml', True, 125)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
;~ _ArrayDisplay($AccFiles)
$AccFiles[0] = 2
$AccFiles[1] = 'C:\Users\Виталий.PROFF\AppData\Roaming\Psi\profiles\default\accounts - копия (2).xml'



For $i=1 to $AccFiles[0]
	$fileContent = FileRead($AccFiles[$i])
	$SplitAccsInFile = StringSplit($fileContent,"<tls>",1) ; разделить на количество аккаунтов
	For $acc=2 to $SplitAccsInFile[0]
		$SplitTegA = StringSplit($SplitAccsInFile[$acc],"</a",1) ; разделить по запясям (последний и есть сам аккаунт)
;~ 		$SplitTegA[$SplitTegA[0]]
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $SplitTegA[0] = ' & $SplitTegA[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $SplitTegA[$SplitTegA[0]] = ' & $SplitTegA[$SplitTegA[0]-1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Next

;~ 	StringLen($SplitAccsInFile[2])
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($SplitAccsInFile[2]) = ' & StringLen($SplitAccsInFile[2]) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	_ArrayDisplay($SplitAccsInFile)
Next

























Func _FileDirList($sPath, $sFileMask = "*", $iFlag = 0, $iSubDir = 1, $iSort = 0)
    Local $sOutBin, $sOut, $aOut, $aMasks, $sRead, $hDir, $sAttrib, $sFiles

    If Not StringInStr(FileGetAttrib($sPath), "D") Then
        Return SetError(1, 0, 0)
    EndIf

    If $iSubDir = 1 Then
        $sAttrib &= ' /S'
    EndIf

    If $iSort = 1 Then
        $sAttrib &= ' /O:N'
    EndIf

    Switch $iFlag
        Case 1
            $sAttrib &= ' /A-D'
        Case 2
            $sAttrib &= ' /AD'
        Case Else
            $sAttrib &= ' /A'
    EndSwitch

    $sOut = StringToBinary('0' & @CRLF, 2)
    $sPath = StringRegExpReplace($sPath, '\\+$', '')
    $sFileMask = StringRegExpReplace($sFileMask, '^;+|;+$', '')
    $sFileMask = StringRegExpReplace($sFileMask, ';{2,}', ';')
    $aMasks = StringSplit($sFileMask, ';')

    For $i = 1 To $aMasks[0]
        If StringStripWS($aMasks[$i], 8) = "" Then
            ContinueLoop
        EndIf

        $sFiles &= '"' & $sPath & '\' & $aMasks[$i] & '"'

        If $i < $aMasks[0] Then
            $sFiles &= ';'
        EndIf
    Next

    $hDir = Run(@ComSpec & ' /U /C DIR ' & $sFiles & ' /B' & $sAttrib, @SystemDir, @SW_HIDE, 6)

    While ProcessExists($hDir)
        $sRead = StdoutRead($hDir, False, True)

        If @error Then
            ExitLoop
        EndIf

        If $sRead <> "" Then
            $sOut &= $sRead
        EndIf
    Wend

    $aOut = StringRegExp(BinaryToString($sOut, 2), '[^\r\n]+', 3)

    If @error Or UBound($aOut) < 2 Then
        Return SetError(2, 0, 0)
    EndIf

    $aOut[0] = UBound($aOut)-1
    Return $aOut
EndFunc


Func _PathSplitByRegExp($sPath,$pDelim='', $mod=-1)
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"
	if $mod >= 0 Then
		Switch $mod
			Case 0
				return $sPath
			Case 1
				return StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
			Case 2
				return StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
			Case 3
				return StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
			Case 4
				return StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
			Case 5
				return StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
			Case 6
				return StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
			Case 7
				return StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file
		EndSwitch
	EndIf

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