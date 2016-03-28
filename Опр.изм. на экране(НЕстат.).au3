;~ #include <GuiConstantsEx.au3>
;~ #include <WindowsConstants.au3>
;~ #include <GDIPlus.au3>
#include <ScreenCapture.au3>
;~ #include <WinAPI.au3>

Global $hTimer

$maxy = 1024
$maxx = 1280
$minx = 99
$miny = 99

$timedetect=2000 ;минимальное время запоминания изменений
$minprocent=15 ;минимальный процент изменений
$detect=0 ;эта переменная станет равна 1 в случае, если изменения будут больше чем минимальные

$step=10
$numberblockx=Floor(($maxx-$minx) /$step)
$numberblocky=Floor(($maxy-$miny) /$step)
$numberblocks=$numberblockx*$numberblocky
$numberC=($timedetect/($numberblocks*0.3))+10

Global $blocks[$numberC][$numberblockx][$numberblocky], $blocks2[$numberC][$numberblockx][$numberblocky], $Cblocks[$numberblockx][$numberblocky]
ConsoleWrite("X : "&$numberblockx& @LF)
ConsoleWrite("X : "&$numberblocky& @LF)


$summ=0

 ;ОТЛАДКА
 $summ1=0
 $summ2=0
;~ for $i=0 to $numberblocks-1
;~    
;~ if $Cblocks[$i][$t]=1 Then
;~    $summ=$summ+1
;~ Else
;~ EndIf
;~ next

 ;ОТЛАДКА
;~  for $t=0 to $numberblocky-1

;~ 	  for $i=0 to $numberblockx-1
;~ $Cblocks[$i][$t]=1
;~ 	  next
;~    next

;~ MsgBox(0, "$summ" ,$numberblock) ;отладка
$hTimer = TimerInit() 
_scan()
;~ MsgBox(0, "$summ" ,$numberblock) ;отладка
;~ Sleep(1000)
;~ _scan2()
;~ 	  for $i=0 to 100
;~ 	_scan()
;~ 	  next
$iDiff = TimerDiff($hTimer)

;запуск цикла на повтореное отсеивание пока минимальное время запоминания изменений не будет достигнуто
;~ $exit=0
;~ while $exit<>1
;~ $iDiff = TimerDiff($hTimer)
;~ if $iDiff<$timedetect then 
;~    _scan2()
;~    Else
;~    $exit=1
;~ endif
;~ wend



; расчёт несошедшихся блоков
for $c=0 to $summa_c
   for $t=0 to $numberblocky-1

	  for $i=0 to $numberblockx-1
	  if $Cblocks[$c][$i][$t]=1 Then
   $summ=$summ+1
   Else
   EndIf
	  next
   next
next
;срабатывание при изменениях больше чем минимальные
$procent= $summ/$numberblocks
if $procent>$minprocent then $detect=1


MsgBox(0, "$summ" , "summ " & $summ & "   $numberblocks " &$numberblocks&"   $summ1 " & $summ1&"   $summ2 " & $summ2 & '    $iDiff ' &$iDiff ) ;отладка


;~ $hTimer = TimerInit() 
;~ _scan()
;~ $exit=0
;~ while $exit<>1
;~ $iDiff = TimerDiff($hTimer)
;~ if $iDiff<$timedetect then 
;~    _scan()
;~    Else
;~    $exit=1
;~ endif
;~ wend

;~    MsgBox(0, "Разница во времени", $iDiff)
	  
Func _scan()
   for $t=0 to $numberblocky-1

   $stroka=$t
   $ytop=$stroka*$step
   $ybottom=$stroka*$step+$step

	  for $i=0 to $numberblockx-1
	  
	  $stolbec=$i
		 if $Cblocks[$i][$t]<>1 then
			$xleft=$stolbec*$step
			$xright=$stolbec*$step+$step
			$blocks[$i][$t]=PixelChecksum ( $xleft, $ytop, $xright, $ybottom, 2)
			$summ1=$summ1+1 ;отладка
		 Else
		 EndIf
	  next
   next
   
EndFunc

Func _scan2()
   for $t=0 to $numberblocky-1

   $stroka=$t
   $ytop=$stroka*$step
   $ybottom=$stroka*$step+$step

	  for $i=0 to $numberblockx-1
	  
	  $stolbec=$i
		 if $Cblocks[$i][$t]<>1 then 
		 $xleft=$stolbec*$step
		 $xright=$stolbec*$step+$step
		 $blocks2[$i][$t]=PixelChecksum ( $xleft, $ytop, $xright, $ybottom, 2)			
			   $summ2=$summ2+1 ;отладка
		 
			if $blocks[$i][$t]<>$blocks2[$i][$t] then 
			$Cblocks[$i][$t]=1
			else
			endif
		 else
		 endif
	  next
   next
   
EndFunc


;~ Func _scan()
;~    for $t=0 to $numberblocky-1

;~    $stroka=$t
;~    $ytop=$stroka*$step
;~    $ybottom=$stroka*$step+$step

;~ 	  for $i=0 to $numberblockx-1
;~ 	  
;~ 	  $stolbec=$i
;~ 	  $numberblock=$stroka*$stolbec
;~ 	  $xleft=$stolbec*$step
;~ 	  $xright=$stolbec*$step+$step
;~ 	  $blocks[$numberblock]=PixelChecksum ( $xleft, $ytop, $xright, $ybottom, 2)
;~ 	  next
;~    next
;~    
;~ EndFunc



Func _scan_C()
$summa_c=0
$iDiff = TimerDiff($hTimer)
if $iDiff = TimerDiff($hTimer) then 
   for $c=0 to $numberC
	  $summa_c=$summa_c1+1  
	  for $t=0 to $numberblocky-1

	  $stroka=$t
	  $ytop=$stroka*$step
	  $ybottom=$stroka*$step+$step

		 for $i=0 to $numberblockx-1
		 
		 $stolbec=$i
   ;~ 		 if $Cblocks[$i][$t]<>1 then
			   $xleft=$stolbec*$step
			   $xright=$stolbec*$step+$step
			   $blocks[$c][$i][$t]=PixelChecksum ( $xleft, $ytop, $xright, $ybottom, 2)
   ;~ 			$summ1=$summ1+1 ;отладка
   ;~ 		 Else
   ;~ 		 EndIf
		 next
	  next
   next
   
EndFunc


;~    

;~    
;~    $hMemory2  = PixelChecksum ( $i-10, $i-10, $i, $i)
;~ $hMemory  = PixelChecksum ( $maxx-10, $maxy-10, $maxx, $maxy)
;~ $hMemory = _ScreenCapture_Capture("",$x-10, $y-10, $x, $y)

;~ $hMemory = _ScreenCapture_Capture("")
;~ ConsoleWrite("X : "&$Bitmap1 & @LF)

;~ #include <Clipboard.au3>
;~ _ClipBoard_SetDataEx(ByRef $hMemory, $CF_BITMAP)
;~ $Bitmap1 = _ClipBoard_SetDataEx($hMemory, $CF_BITMAP)
;~ ConsoleWrite("X : "&$Bitmap1 & @LF)
;~ ConsoleWrite("X : "&
;~ & @LF)