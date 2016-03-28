#include <Array.au3>

;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Random() = ' & Random() & @CRLF) ;### Debug Console

global $NumberSplits = 1000, $aMemoryImage, $Struct
Dim $aMemoryImage[$NumberSplits+1][10] ; массив для хранения информации для сравнения
$razmer = 10000
For $nn=0 to 1
	For $n=0 to $NumberSplits
		$aMemoryImage[$n][$nn]=''
		For $i=0 to $razmer-1
			$aMemoryImage[$n][$nn] &= Chr(Random(65,122,1))
		Next
	Next
	ConsoleWrite(@MIN&@SEC&"Окончено генерирование "&$nn&" столбца" &@CRLF)
Next

$IndexCompare=0
	For $nn=0 to 4
		$timer = Timerinit()
		For $i = 1 To $NumberSplits
			if $aMemoryImage[$i][$nn] <> $aMemoryImage[$i][$nn] Then $IndexCompare += 1
		Next
		ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : TimerDiff($timer)1 = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
		$timer = Timerinit()
		For $i = 1 To $NumberSplits
			if $aMemoryImage[$i][$nn] <> $aMemoryImage[$i][$nn+1] Then $IndexCompare += 1
		Next
		ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : TimerDiff($timer)2 = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
	Next

ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : $IndexCompare = ' & $IndexCompare & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
Exit

$razmer = 10000
Dim $array[$razmer][2]
$t = 0
For $j=1 to 20
	$t &= Chr(Random(65,122,1))
Next
For $i=0 to $razmer-1
	$array[$i][0] = ''
	For $j=1 to 20
		$array[$i][0] &= Chr(Random(65,122,1))
	Next
	if $i=Round($razmer/2) then $t=$array[$i][0]
Next
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

$timer = Timerinit()
;~ _ArraySort($array)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
$timer = Timerinit()
;~ _ArrayBinarySearch($array, Random())
_ArraySearch($array, $t)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console

Redim $array[$razmer+100][2]

For $i=$razmer-1 to $razmer+100-1
;~ 	$array[$i][0] = Random()
	$array[$i][0] = ''
	For $j=1 to 20
		$array[$i][0] &= Chr(Random(65,122,1))
	Next
Next

$timer = Timerinit()
;~ _ArraySort($array)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
$timer = Timerinit()
;~ _ArrayBinarySearch($array, Random())
_ArraySearch($array, $t)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console

