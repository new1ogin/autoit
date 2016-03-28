#include <Array.au3>




;~ $MyDrive = _PathSplitByRegExp(@AutoItExe)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $MyDrive[1] = ' & $MyDrive[1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$aRemovableDrives = DriveGetDrive ( "REMOVABLE" )
;удаляем из результатов диск А:
If _ArrayDelete($aRemovableDrives, _ArraySearch($aRemovableDrives, 'a:')) <> 0 then $aRemovableDrives[0]=$aRemovableDrives[0]-1
_ArrayDisplay( $aRemovableDrives)

$IndexMyDrive = _ArraySearch($aRemovableDrives, StringLeft(@AutoItExe,1)&':')
if $IndexMyDrive >= 0 then
	Msgbox(0,'',$IndexMyDrive)
EndIf









Func _PathSplitByRegExp($sPath)
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8], $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

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

