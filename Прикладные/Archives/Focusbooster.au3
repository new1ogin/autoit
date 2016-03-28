#include <array.au3>

;~ >>>> Window <<<<
;~ Title:	focus booster mini timer
;~ Class:	Chrome_WidgetWin_0
;~ Position:	1527, 932
;~ Size:	150, 66
;~ Style:	0x160E0000
;~ ExStyle:	0x00000108
;~ Handle:	0x00000000000B05B4

;~ >>>> Control <<<<
;~ Class:	CompositorHostWindowClass
;~ Instance:	1
;~ ClassnameNN:	CompositorHostWindowClass1
;~ Name:
;~ Advanced (Class):	[CLASS:CompositorHostWindowClass; INSTANCE:1]
;~ ID:
;~ Text:
;~ Position:	0, 0
;~ Size:	150, 66
;~ ControlClick Coords:	66, 45
;~ Style:	0x5E000000
;~ ExStyle:	0x00000000
;~ Handle:	0x0000000000070890

;~ >>>> Window <<<<
;~ Title:	focus booster
;~ Class:	Chrome_WidgetWin_0
;~ Position:	489, 520
;~ Size:	708, 477
;~ Style:	0x16CF0000
;~ ExStyle:	0x00000100
;~ Handle:	0x00000000000208B8

;~ >>>> Control <<<<
;~ Class:	CompositorHostWindowClass
;~ Instance:	1
;~ ClassnameNN:	CompositorHostWindowClass1
;~ Name:
;~ Advanced (Class):	[CLASS:CompositorHostWindowClass; INSTANCE:1]
;~ ID:
;~ Text:
;~ Position:	0, 0
;~ Size:	700, 450
;~ ControlClick Coords:	353, 210
;~ Style:	0x5E000000
;~ ExStyle:	0x00000000
;~ Handle:	0x000000000008089E
#include <Color.au3>

Opt("PixelCoordMode", 2)            ;1=абсолютные, 0=относительные, 2=клиентские
$sleep=1000
$K=5
$a=WinList('focus booster')
$Fbm=0
For $i=1 to $a[0][0]
	if $a[$i][0] = 'focus booster' Then $Fb=$a[$i][1]
	if $a[$i][0] = 'focus booster mini timer' Then $Fbm=$a[$i][1]
Next
local $aColors[3]
;~ _ArrayDisplay($a)

;~ $Fb = WinGetHandle('focus booster')
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Fb = ' & $Fb & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ $Fbm = WinGetHandle('focus booster mini timer')
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Fbm = ' & $Fbm & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
_ArrayPush($aColors,_getColor($Fbm))
sleep($sleep)
_ArrayPush($aColors,_getColor($Fbm))
sleep($sleep)

$schet=0
While 1
	$schet+=1
	$a=WinList('focus booster')
	$Fbm=0
	For $i=1 to $a[0][0]
		if $a[$i][0] = 'focus booster' Then $Fb=$a[$i][1]
		if $a[$i][0] = 'focus booster mini timer' Then $Fbm=$a[$i][1]
	Next

	if not WinExists($Fb) then Exit

	_ArrayPush($aColors,_getColor($Fbm))
	if Abs($aColors[2]-$aColors[1]) > 5 Then
		if Abs($aColors[2]-$aColors[1]) > Abs($aColors[1]-$aColors[0])*$K or Abs($aColors[2]-$aColors[1]) < Abs($aColors[1]-$aColors[0])/$K Then
			WinActivate($Fb)
			ConsoleWrite('WinAct!' & @CRLF)
		EndIf
	EndIf
	if mod($schet,2)=0 Then	ConsoleWrite($aColors[2]-$aColors[1] & '  '& $aColors[1]-$aColors[0] & @CRLF)
;~ 	ConsoleWrite($aColors[0] & '  '& $aColors[1]& '  '& $aColors[2] & @CRLF)
;~ 	ConsoleWrite(_getColor($Fbm) & '  '& WinGetState($Fbm) & @CRLF)
	sleep($sleep)
WEnd

Func _getColor($Fbm)
	$nColor=PixelGetColor(10,10,$Fbm)
	$aColor=_ColorGetRGB($nColor)
	return $aColor[0]+$aColor[1]+$aColor[2]
;~ 	return $aColor
EndFunc


