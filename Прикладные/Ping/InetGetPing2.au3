#include <Constants.au3>
#include <Encoding.au3>
#include <array.au3>
global $Patchqwinsta
$RetText = ''
$address = '192.168.0.111'
$address = '137.255.255.255'

$t1 = _Ping($address, $RetText,6000)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $RetText = ' & $RetText & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

exit

$iPID = Run(@ComSpec & ' /C ' & 'ping' & ' '& $address &' -n 1', '', @SW_HIDE, $STDOUT_CHILD)
	While 1
		$sRead &= StdoutRead($iPID)
		If @error Then ExitLoop
		Sleep(10)
	WEnd
	$sRead = _Encoding_866To1251($sRead)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sRead = ' & $sRead & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;
Func _Ping($address, byref $RetText,$timerlim=6000)
	local $sRead, $iPID, $timer, $tReturn, $sString
	$sRead = ''
	$iPID = Run(@ComSpec & ' /C ' & 'ping' & ' '& $address &' -n 1', '', @SW_HIDE, $STDOUT_CHILD)
	If Not $iPID Then
		ProcessClose($iPID)
		if $timerlim <> 180000 Then
			$tReturn = _Ping($address,20000)
			if $tReturn <> 0 Then Return $tReturn
		Else
			Return 0
		EndIf
	EndIf
	$timer = TimerInit()
	While 1
		$sRead &= StdoutRead($iPID)
		If @error Then ExitLoop
		Sleep(10)
		if TimerDiff($timer) > $timerlim Then
			ProcessClose($iPID)
			if $timerlim <> 180000 Then
				$tReturn = _Ping($address,180000)
				if $tReturn <> 0 Then Return $tReturn
			Else
				Return 0
			EndIf
		EndIf
	WEnd
	$sRead = _Encoding_866To1251($sRead)
	$aStrings = StringSplit($sRead,@LF)
	$RetText = $aStrings[3]

	if StringInStr($aStrings[3], 'число байт') or StringInStr($aStrings[3], 'bytes') Then
		return 1
	Else
		return 0
	EndIf

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sRead = ' & $sRead & @CRLF) ;### Debug Console
;~ 	$sString = StringRegExp(StringLower($sRead),'('&StringLower($FindUser)&') +(\d+) +([а-яёА-ЯЁa-zA-Z]+)',2)
;~ 	_ArrayDisplay($aStrings)

;~ 	return $sString
EndFunc