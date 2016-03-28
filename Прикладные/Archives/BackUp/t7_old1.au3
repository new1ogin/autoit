#include <Crypt.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <WinAPI.au3>
#include <WindowsConstants.au3>
#include <array.au3>
#include "crc.au3"

#include <Array.au3>
$newName = 'one+two+tree'
$oneName = StringLeft($newName,StringInStr($newName,"+")-1)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oneName = ' & $oneName & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


exit
Func _gf_lev_distance($a_vsource, $a_vtarget);

local $l_nlength_vsource
local $l_nlength_vtarget
local $v_cost

local $column_to_left[0],$current_column[0]
local $i,$j

$v_cost = 0
$l_nlength_vsource = Stringlen($a_vsource)
$l_nlength_vtarget = Stringlen($a_vtarget)

if $l_nlength_vsource = 0 then
 return $l_nlength_vtarget
elseif $l_nlength_vtarget = 0 then
  return $l_nlength_vsource
ELSE
 FOR $j = 1 to ($l_nlength_vtarget + 1)
  $column_to_left[$j] = $j
 next
 FOR $i = 1 to $l_nlength_vsource
   $current_column[1] = $i
   FOR $j = 2 to ($l_nlength_vtarget + 1)
    If Stringmid($a_vsource, $i, 1) = Stringmid($a_vtarget, $j - 1, 1) THEN
        $v_cost = 0
    ELSE
        $v_cost = 1
    Endif
    $current_column[$j] = $current_column[$j - 1] + 1
    If ($column_to_left[$j] + 1) < $current_column[$j] then
     $current_column[$j] = $column_to_left[$j] + 1
    Endif
    If ($column_to_left[$j - 1] + $v_cost) < $current_column[$j] then
     $current_column[$j] = $column_to_left[$j - 1] + $v_cost
    Endif
   next
   FOR $j = 1 to ($l_nlength_vtarget + 1)
    $column_to_left[$j] = $current_column[$j]
   next
 next

Endif

return $current_column[$l_nlength_vtarget + 1] - 1

EndFunc
Func _distance($source, $dest)
    if ($source = $dest) Then return 0;
	$aSource = StringSplit($source,'')
	_ArrayDelete($aSource,1)
    $slen = StringLen($source);
    $dlen = StringLen($dest);

    if ($slen == 0) Then
        return $dlen;
    elseif ($dlen == 0) Then
        return $slen;
    EndIf

	local $dist[$dlen+1]
	For $i=0 to $dlen
		$dist[$i] = $i
	Next

	$i = 0
    While $i < $slen
		local $_dist[$dlen+1]
;~         $_dist = array($i + 1);
        $char = $aSource[$i];
		$j = 0
        While $j < $dlen
;~             $cost = $char == $dest{$j} ? 0 : 1;
;~             $_dist[$j + 1] = min(
;~                 $dist[$j + 1] + 1,   ; deletion
;~                 $_dist[$j] + 1,      ; insertion
;~                 $dist[$j] + $cost    ; substitution
;~             );
			$j+=1
		WEnd

        $dist = $_dist;
		$i+=1
    Wend
    return $dist[$j];
EndFunc

$timer = TimerInit()
$file = 'C:\v77_v8\testokt1.xml'
$string = FileRead($file)
$file2 = 'C:\v77_v8\testokt2.xml'
$string2 = FileRead($file2)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
$FindID1 = StringRegExp($string,'(?s)[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(.*?)([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})(.*?)[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',4)
$FindID2 = StringRegExp($string2,'(?s)[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}(.*?)([0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})(.*?)[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}',4)
local $t
ConsoleWrite(UBound($t) & @CRLF)
_ArrayDisplay($t)
$temp = $t[0]
_ArrayDisplay($temp)
$temp = $t[1]
_ArrayDisplay($temp)
Exit
$timer = TimerInit()
$file = 'C:\v77_v8\Exp77_80(new1)_.xml'
$string = FileRead($file)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
ConsoleWrite(StringLen($string) & @CRLF)
$at = StringSplit($string,'</')
ConsoleWrite(UBound($at) & @CRLF)
;~ $t = StringRegExp($string,'(<[^>]*?>)([^<]*?)(<\/[^>]*?>)',2)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
;~ _ArrayDisplay($t)
exit
$0crc = _CRC32(0)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _CRC32(0) = ' & _CRC32(0) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

$raschet = 100000
local $array[$raschet+1][2]
$schet = 1
$timer = TimerInit()
While 1
	$array[$schet][0] = _CRC16($schet)
	$array[$schet][1] = $schet
;~ 	if _CRC32($schet) = $0crc then ExitLoop
	if mod($schet,5000)=0 then
		ConsoleWrite($schet & @CRLF)
		if mod($schet,$raschet)=0 then
			_arraysort($array)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
			For $a=0 to Ubound($array)-1-1
				if $array[$a][0] = $array[$a+1][0] then
					ConsoleWrite('@@ Debug(' & $array[$a+1][1] & ') : $array[$a+1][0] = ' & $array[$a+1][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
					ConsoleWrite('@@ Debug(' & $array[$a][1] & ') : $array[$a][0] = ' & $array[$a][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
					ConsoleWrite(@CRLF & $schet & @CRLF)
					Exit
				EndIf
			Next
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
			redim $array[UBound($array)+$raschet][2]
			$timer = TimerInit()
		EndIf
	EndIf

	$schet+=1
WEnd

;~ $raschet = 100000
;~ local $array[$raschet+1]
;~ $schet = 1
;~ $timer = TimerInit()
;~ While 1
;~ 	$array[$schet] = _CRC32($schet)
;~ 	if mod($schet,5000)=0 then
;~ 		ConsoleWrite($schet & @CRLF)
;~ 		if mod($schet,$raschet)=0 then
;~ 			_arraysort($array)
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
;~ 			For $a=0 to Ubound($array)-1-1
;~ 				if $array[$a] = $array[$a+1] then
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $array[$a+1] = ' & $array[$a+1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $array[$a] = ' & $array[$a] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 					ConsoleWrite(@CRLF & $schet & @CRLF)
;~ 					Exit
;~ 				EndIf
;~ 			Next
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
;~ 			redim $array[UBound($array)+$raschet]
;~ 			$timer = TimerInit()
;~ 		EndIf
;~ 	EndIf

;~ 	$schet+=1
;~ WEnd


ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $schet = ' & $schet & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
