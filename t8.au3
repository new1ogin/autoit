#include <array.au3>
#include <Encoding.au3>
#include <String.au3>
#include <date.au3>

HotKeySet("^{F7}", "Terminate")
HotKeySet("{F7}", "_Detect_n_Start")
;~ HotKeySet("{F8}", "_Restart")
HotKeySet("{F9}", "_Detect4low")
HotKeySet("{F10}", "_Detect4equ")
HotKeySet("{F11}", "_Detect4high")
Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

global $StartMouse=1,$ClickMouseLow[2]=[513,572],$ClickMouseEqu[2]=[629,563],$ClickMouseHigh[2]=[783,564],$n
dim $StartMouse[2]
$StartMouse[0]=1442
$StartMouse[1]=573
$testdelay=10
;~ Func _Restart()
;~ 	$StartMouse=1
;~ EndFunc

Func _Detect4low()
	$ClickMouseLow = MouseGetPos()
	ConsoleWrite($ClickMouseLow[0]&' '&$ClickMouseLow[1]&@CRLF)
EndFunc
Func _Detect4equ()
	$ClickMouseEqu = MouseGetPos()
	ConsoleWrite($ClickMouseEqu[0]&' '&$ClickMouseEqu[1]&@CRLF)
EndFunc
Func _Detect4high()
	$ClickMouseHigh = MouseGetPos()
	ConsoleWrite($ClickMouseHigh[0]&' '&$ClickMouseHigh[1]&@CRLF)
EndFunc


Func _Detect_n_Start()
	ConsoleWrite(1)
	if $StartMouse=1 then
		$StartMouse = MouseGetPos()
		ConsoleWrite($StartMouse[0]&' '&$StartMouse[1]&@CRLF)
	EndIf

	_Click4($StartMouse)
	Send('^{INS}')
	sleep($testdelay)
	$clip = ClipGet()
	$aCards = StringRegExp($clip,'right.*?<span>(.*?)</span>.*?left.*?<span>(.*?)</span>',2)
	if @error Then
		$n+=1
		if $n=3 then return
		sleep(50)
		_Detect_n_Start()
		Return
	EndIf
	$n=0
;~ 	ConsoleWrite($clip&@CRLF)
;~ 	_ArrayDisplay($aCards)
	$left=Execute($aCards[2])
	$right=Execute($aCards[1])

	if $left>$right Then
		_Click4($ClickMouseHigh)
	ElseIf $left=$right Then
		_Click4($ClickMouseEqu)
	Else
		_Click4($ClickMouseLow)
	EndIf




;~ 	$aCards = StringRegExp($clip,'<div class="card k-right"><div><div class="value"><span>6</span></div></div></div><div class="card k-left"><div><div class="value"><span>(</span>')
;~ 	_ArrayDisplay($aCards,'22222')
EndFunc

Func _Click4($coords)
	sleep(random(0,100))
	MouseClick('left',$coords[0]+random(-5,5),$coords[1]+random(-5,5),1,random(1,3))
EndFunc


while 1
	sleep(100)
WEnd



ConsoleWrite(Execute("10 + 6"))




;~ HotKeySet("^{F7}", "Terminate")
;~ HotKeySet("{F7}", "_Detect_n_Start")
;~ HotKeySet("{F8}", "_Restart")
;~ Func Terminate()
;~ TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
;~ 	Sleep(1000)
;~ 	Exit 0
;~ EndFunc   ;==>Terminate

;~ global $StartMouse=1,$ClickMouseLow[2]=[513,572],$ClickMouseEqu[2]=[629,563],$ClickMouseHigh[2]=[783,564],$n,$n2
;~ dim $StartMouse[2]
;~ $StartMouse[0]=659
;~ $StartMouse[1]=678
;~ $testdelay=10
;~ $k=3.55

;~ while 1
;~ 	sleep(100)
;~ WEnd

;~ Func _Restart()
;~ 	$StartMouse=1
;~ EndFunc

;~ func _Detect_n_Start()
;~ 	ConsoleWrite('func start'&@CRLF)
;~ 	if $StartMouse=1 then
;~ 		$StartMouse = MouseGetPos()
;~ 		ConsoleWrite($StartMouse[0]&' '&$StartMouse[1]&@CRLF)
;~ 	EndIf

;~ 	$search1=PixelSearch($StartMouse[0]-400,$StartMouse[1]-53,$StartMouse[0]+300,$StartMouse[1]-52,0x6A4404,5)
;~ 	if @error Then
;~ 		$n+=1
;~ 		if $n=3 then return
;~ 		ConsoleWrite($n&'@error $search1'&@CRLF)
;~ 		return
;~ 	EndIf
;~ 	$n=0
;~ 	$search2=PixelSearch($search1[0]+72,$StartMouse[1]-53,$StartMouse[0]+300,$StartMouse[1]-52,0x6A4404,5)
;~ 	if @error Then
;~ 		$n2+=1
;~ 		if $n2=3 then return
;~ 		ConsoleWrite($n2&'@error $search2'&@CRLF)
;~ 		return
;~ 	EndIf
;~ 	$n2=0
;~ 	ConsoleWrite('search1 = ' & $search1[0] & ' ' & $search1[1] & '  search2 = ' & $search2[0] & ' ' & $search2[1] & @CRLF)

;~ 	$correct=0
;~ 	if ((($search2[0]-($search1[0]+70))-170)/10) > 0 then $correct=((($search2[0]-($search1[0]+70))-170)/10)
;~ 	$long = ($search2[0]-($search1[0]+70))+random(0,2)-$correct
;~ 	ConsoleWrite($long &' - long'&@CRLF)
;~ 	ConsoleWrite(($long)*$k &' - ($long)*$k'&@CRLF)
;~ 	MouseMove($StartMouse[0],$StartMouse[1],0)
;~ 	MouseDown('left')
;~ 	sleep((($long)*$k))
;~ 	MouseUp('left')
;~ EndFunc