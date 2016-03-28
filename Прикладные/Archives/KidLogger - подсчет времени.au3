#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
#include <Date.au3>



$cmdline1 = $cmdline[1]
;~ $cmdline1 = 'C:\Program Files (x86)\KidLogger\logs\Виталий\20150319\19 March,Thursday.html'
$filecontent = Fileread($cmdline1)
;~ StringLen($filecontent)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($filecontent) = ' & StringLen($filecontent) & @CRLF) ;### Debug Console
$regexp = StringRegExp($filecontent,'<p class="app" time="([0-9:]*)" name="(.*?)">.*? (.*?)</p>',3)
;~ _ArrayDisplay($regexp)

Dim $newArray[1][3]
$ArrInd = 1


; по процессу приложения
;~ For $i=0 to Ubound($regexp)-1 step 3
;~ 	$ind = _ArraySearch($newArray, $regexp[$i+1], 0, 0, 0, 0, 0, 1)
;~ 	if $ind = -1 Then ; добовляем новый элемент
;~ 		$ArrInd+=1
;~ 		Redim $newArray[$ArrInd][3]
;~ 		$newArray[$ArrInd-1][0] = 0
;~ 		$newArray[$ArrInd-1][1] = $regexp[$i+1]
;~ 	Else
;~ 		if $i+3<Ubound($regexp) Then $newArray[$ind][0] += _DateDiff("s",'2000/01/01 '&$regexp[$i],'2000/01/01 '&$regexp[$i+3])
;~ 	EndIf
;~ Next

;по имени окна приложения
For $i=0 to Ubound($regexp)-1 step 3
	$ind = _ArraySearch($newArray, $regexp[$i+2], 0, 0, 0, 0, 0, 1)
	if $ind = -1 Then ; добовляем новый элемент
		$ArrInd+=1
		Redim $newArray[$ArrInd][3]
		$newArray[$ArrInd-1][0] = 0
		$newArray[$ArrInd-1][1] = $regexp[$i+2]
	Else
		if $i+3<Ubound($regexp) Then $newArray[$ind][0] += _DateDiff("s",'2000/01/01 '&$regexp[$i],'2000/01/01 '&$regexp[$i+3])
	EndIf
Next

;Приводи массив в приятный вид
$newArray[0][0]=$ArrInd-1
_ArraySort($newArray,1,1)
Dim $iS, $iM, $iH
For $i=1 to $newArray[0][0]
	_TicksToTime($newArray[$i][0] * 1000, $iH, $iM, $iS)
	$newArray[$i][0] = StringFormat("%02i:%02i:%02i", $iH, $iM, $iS)
Next

_ArrayDisplay($newArray)


