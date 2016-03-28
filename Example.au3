#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#Include<Array.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

$sText = 'C:\Users\Application data\Application data\Application data\Application data\Application data\Application data\Application data\Application data\Application data\Application data\Desktop\Application data\Application data\Application data\Application data\input.exe'
$1 =11
$2 =2
$3 = 33
_PathSplitByRegExp('C:\input.exe')
if $1 =1 or $2 =2 and not @error then ConsoleWrite($SS_CENTER)
;~ if $3 =3 and $2 =3 or $1 = 1 then ConsoleWrite('2222222222')
dim $aLnks[20] = ['C:\Documents and Settings\Администратор\Главное меню\Программы\XAMPP for Windows\XAMPP Uninstall.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Автозагрузка\HASP License Manager.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Адресная книга.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Блокнот.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Командная строка.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Мастер совместимости программ.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Проводник.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Синхронизация.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Развлечения\Проигрыватель Windows Media.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Служебные\Internet Explorer (без надстроек).lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Специальные возможности\Диспетчер служебных программ.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Специальные возможности\Экранная клавиатура.lnk', _
'C:\Documents and Settings\Администратор\Главное меню\Программы\Стандартные\Специальные возможности\Экранная лупа.lnk', _
'C:\Documents and Settings\Администратор\Рабочий стол\ConsultantPlus -ADM (1).lnk', _
'C:\Documents and Settings\Администратор\Рабочий стол\ConsultantPlus.lnk']

For $i=0 to Ubound($aLnks)-1
	$aLnkInfo = FileGetShortcut ( $aLnks[$i] )
	_ArrayDisplay($aLnkInfo)
Next



;~ $hWndGUI = _Message(123)
;~ $Input2 = @extended
;~ Sleep(2000)
;~ GUICtrlSetData ( $Input2, 'iopthn')
;~ Sleep(2000)
;~ GUIDelete($hWndGUI)

;~ Sleep(2000)
Func _Message($Message)
	$width = 400
	$height = 100
	$hWndGUI = GUICreate("Подсказка",$width,$height,Default,Default,$WS_POPUP,$WS_EX_TRANSPARENT)
	$Input = GUICtrlCreateLabel($Message, 20, 20, $width-20, $height-20, $SS_CENTER)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	WinSetTrans($hWndGUI,"",500)
	GUISetState(@SW_SHOW)
	return SetError(0,$Input,$hWndGUI)
EndFunc

Func _PathSplitByRegExp($sPath,$pDelim = '')
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return SetError(1, 0, $sPath)
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"

    $aRetArray[0] = $sPath ;Full path
    $aRetArray[1] = StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
	if @error then SetError (1)
    $aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
	if @error then SetError (1)
    $aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
	if @error then SetError (1)
    $aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
	if @error then SetError (1)
    $aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
	if @error then SetError (1)
    $aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
	if @error then SetError (1)
    $aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file
	if @error then SetError (1)

    Return $aRetArray
EndFunc
;~ $sPattern = "(\w+?)\s+(\S*\s)*?\1"
;~ $sPattern = '\\([^\\]+)\\+\1'

;~ $aRezult = StringRegExp( $sText, $sPattern,3 )

;~ _ArrayDisplay($aRezult, ' Test Rezult ')

;~ $sPattern =  '([a-z]+) +([0-9]+) +\1\2'
;~ $sPattern =  '(.+) +\1'
;~ $sPattern = '\\([^\\]+)\\+\1'
;~ $aResult = StringRegExp($sText, $sPattern, 2)
;~ For $i = 0 To UBound($aResult) - 1
;~     ConsoleWrite($aResult[$i] & @CRLF)
;~ Next

;~ $sText = 'too too 66 66 tro tru'
;~ $sPattern =  '([a-z]+|[0-9]+)\s*?\1'
;~ $aResult = StringRegExp($sText, $sPattern, 3)
;~ For $i = 0 To UBound($aResult) - 1
;~     ConsoleWrite($aResult[$i] & @CRLF)
;~ Next

Func _ClearPatch($sText)
	$aClear = StringSplit($sText,'\')
	$searchWord = ''
	$i = 2
	while $i < $aClear[0]
		if $aClear[$i] = $aClear[$i-1] and $aClear[$i] = $aClear[$i+1] Then
			$searchWord = $aClear[$i]
			_ArrayDelete($aClear, $i-1)
			$aClear[0] -= 1
		EndIf
		if $aClear[$i] = $searchWord Then
			_ArrayDelete($aClear, $i)
			$aClear[0] -= 1
			$i -= 1
		Else
			$searchWord = ''
		EndIf
		$i += 1
	WEnd
	_ArrayDelete($aClear,0)
	$sText = _ArrayToString($aClear, '\')
	Return $sText
EndFunc




