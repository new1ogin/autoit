#Include <GDIPlus.au3>
#include <Array.au3>
#include <APIConstants.au3>
;~ #include <vkConstants.au3>
; *** End added by AutoIt3Wrapper ***
#include <GUIConstants.au3>
#include <ListViewConstants.au3>
#include <GuiListView.au3>

global $aArray,$aArray2,$result,$result2, $u, $sizex, $sizey
$starttime=TimerInit() ;TimerDiff($starttime)
_GDIPlus_Startup()
$hBitmap = _GDIPlus_BitmapCreateFromFile(@ScriptDir & '\test.bmp')
$Width = _GDIPlus_ImageGetWidth($hBitmap)
$Height = _GDIPlus_ImageGetHeight($hBitmap)
$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $Width, $Height, $GDIP_ILMREAD, $GDIP_PXF32ARGB)
$sizex=$Width
$sizey=$Height
$bData = DllStructGetData(DllStructCreate('byte[' & ($Width * $Height * 4) & ']', DllStructGetData($tMap, 'Scan0')), 1)
_GDIPlus_BitmapUnlockBits($hBitmap, $tMap)
_GDIPlus_BitmapDispose($hBitmap)
_GDIPlus_Shutdown()

$bData=StringRegExpReplace ( $bData, "(......)(FF)", "$1g")

$aArray = StringSplit ( $bData, "g" , 1)
$aArray[1]=StringRegExpReplace ( $aArray[1], "0x", "")
;~ if not @error then _ArrayDisplay($aArray, 'Разбор строки')

_GDIPlus_Startup()
$hBitmap2 = _GDIPlus_BitmapCreateFromFile(@ScriptDir & '\test2.bmp')
$Width2 = _GDIPlus_ImageGetWidth($hBitmap2)
$Height2 = _GDIPlus_ImageGetHeight($hBitmap2)
$tMap2 = _GDIPlus_BitmapLockBits($hBitmap2, 0, 0, $Width2, $Height2, $GDIP_ILMREAD, $GDIP_PXF32ARGB)
$bData2 = DllStructGetData(DllStructCreate('byte[' & ($Width2 * $Height2 * 4) & ']', DllStructGetData($tMap2, 'Scan0')), 1)
_GDIPlus_BitmapUnlockBits($hBitmap2, $tMap2)
_GDIPlus_BitmapDispose($hBitmap2)
_GDIPlus_Shutdown()

$bData2=StringRegExpReplace ( $bData2, "(......)(FF)", "$1g")

;~ $aArray2 = StringSplit ( $bData2, "g" , 1)
;~ $aArray2[1]=StringRegExpReplace ( $aArray2[1], "0x", "")

global $result[$aArray[0]+1]

for $i=1 to $aArray[0]

	$result2=0

;~ $result2=StringRegExp ( $bData2, $aArray[$i],3) ;скорость 35783
;~ $result2=UBound ( $result2 )
	$result2 = StringSplit ( $bData2, $aArray[$i] , 1) ;скорость 18653


;~ 	for $t=1 to $aArray2[0]-1
;~ 		ConsoleWrite($t)
;~ 		if $aArray[$i]=$aArray2[$t] then $result2=$result2+1
;~ 	Next
	$result[$i]=$result2[0]
Next
ConsoleWrite(TimerDiff($starttime))

;размерность первого изображения
;~ $sizex=1
;~ $sizey=38

Dim $massiv[$sizex+1][$sizey+1]
For $u=1 To $sizey
	For $i=1 To $sizex
		$NumResult=$i+($sizex*($u-1))
		$massiv[$i][$u]=$result[$NumResult]
	Next
next



;~ 	_ArrayDisplay($result, 'Разбор строки')
	$ListView1= _ArrayDisplay($massiv, 'Разбор строки',-1,1)
GUICtrlSendMsg($ListView1, $LVM_SETCOLUMNWIDTH, 0, 70)







