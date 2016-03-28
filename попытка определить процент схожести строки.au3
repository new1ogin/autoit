#include <Array.au3>
global $ScetCompare=0, $timerCompare=0
$timer1=TimerInit()
$Str1 = 'Microsoft Visual C++ 2005 Redistributable - x64 8.0.50727.42 False'
$Str2 = 'Microsoft Visual C++ 2008 Redistributable - x64 9.0.30729 False [Русский (Россия)]  '
$Compare=_StringCompare($Str2,$Str1, 1)
;~ $Compare1=_StringCompare($Str2,$Str1, 1)
;~ if $Compare>$Compare1 then $Compare=$Compare1
ConsoleWrite($Compare&@CRLF)



Func _StringCompare($Str1,$Str2,$StringMode=1)

   $Str1=StringStripWS ( $Str1, 7) ;удаление пробельных символов в конце, начале строки и повторяющихся пробельных символов
   $Str2=StringStripWS ( $Str2, 7)
   If $StringMode=0 Then
	  $Split1=StringSplit($Str1, Chr(9)& Chr(10)& Chr(11)& Chr(12)& Chr(13)& Chr(32)& Chr(0)& '.'& '_'& ','& '-'& '('& ')')
	  $Split2=StringSplit($Str2, Chr(9)& Chr(10)& Chr(11)& Chr(12)& Chr(13)& Chr(32)& Chr(0)& '.'& '_'& ','& '-'& '('& ')')
   Else
	  $Split1=StringSplit($Str1, Chr(9)& Chr(10)& Chr(11)& Chr(12)& Chr(13)& Chr(32)& Chr(0))
	  $Split2=StringSplit($Str2, Chr(9)& Chr(10)& Chr(11)& Chr(12)& Chr(13)& Chr(32)& Chr(0))
   EndIf
   
   ;опредление самого длинного слова
   Global $maxLenght
   $maxLenght = _Max_Lenght($Split1)
   $maxLenght1 = _Max_Lenght($Split2)
   If $maxLenght > $maxLenght1 Then $maxLenght=$maxLenght1

   ;перебор и сравнение всех слов, для получения общего процета совпадения

   Dim $JointCompare=0, $JoinLenght=0
   Dim $CompareArray[UBound($Split2)]
   For $i=1 to UBound($Split1)-1
	  For $t=1 to UBound($Split2)-1
		 $Compare=_Compare ($Split1[$i], $Split2[$t])
		 $CompareArray[$t]=(_Compare ($Split1[$i], $Split2[$t]))
   ;~ 	  $JoinLenght+=$Lenght1/$maxLenght
	  Next
	  $JoinLenght+=StringLen($Split1[$i])/$maxLenght
	  $JointCompare+=_ArrayMax($CompareArray, 1, 1)*(StringLen($Split1[$i])/$maxLenght)
   ;~    ConsoleWrite(' ' & StringLen($Split1[$i])& '')
   Next
   ;~ ConsoleWrite(@CRLF)
   ;~ ConsoleWrite($JointCompare&@CRLF)
   ;~ ConsoleWrite($JoinLenght&@CRLF)
   $Compare=$JointCompare/$JoinLenght
   ;~ ConsoleWrite($Compare&@CRLF)
   ConsoleWrite('$timer1= ' & TimerDiff($timer1)&@CRLF)
   ConsoleWrite('$timer3= ' & $timerCompare/$ScetCompare& 'количество оригинальных сравнений: '& $ScetCompare&@CRLF)
   return $Compare
EndFunc


Func _Max_Lenght($Split1)
   $timer2=TimerInit()
   Dim $LenghtArray[UBound($Split1)]
   For $i=1 to UBound($Split1)-1
	  $LenghtArray[$i]=StringLen($Split1[$i])
   Next
   ConsoleWrite('_Max_Lenght= ' & TimerDiff($timer2)&@CRLF)
   return _ArrayMax($LenghtArray, 1, 1)
   
EndFunc


Func _Compare ($Str1, $Str2)
   $timer3=TimerInit()
   $ScetCompare+=1
   $Length = StringLen($Str1)
   If ($Length) And (StringLen($Str2) = $Length) Then
	   $Count = 0
	   For $i = 0 To $Length - 1
		   If StringLeft(StringTrimLeft($Str1, $i), 1) = StringLeft(StringTrimLeft($Str2, $i), 1) Then
			   $Count += 1
		   EndIf
		Next
		$Compare = $Count / $Length * 100
;~ 	   ConsoleWrite('Совпадение: ' & $Compare& '%' & @CR)
;~ 	  ConsoleWrite(' ' & $Compare& '%')
	  $timerCompare+=TimerDiff($timer3)
	   return $Compare
	Else
	  $Count = 0
	   For $i = 0 To $Length - 1
		   If StringLeft(StringTrimLeft($Str1, $i), 1) = StringLeft(StringTrimLeft($Str2, $i), 1) Then
			   $Count += 1
		   EndIf
		Next
		$Compare = $Count / $Length * 100
		$timerCompare+=TimerDiff($timer3)
	   return $Compare
   EndIf
 
EndFunc
 
 
;~  Chr(9), Chr(10), Chr(11), Chr(12), Chr(13), Chr(32), Chr(0), '.', '_', ',', '-', '(', ')'
;~   Chr(9)& Chr(10)& Chr(11)& Chr(12)& Chr(13)& Chr(32)& Chr(0)& '.'& '_'& ','& '-'& '('& ')'