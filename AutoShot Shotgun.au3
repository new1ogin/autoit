#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=autoshot.ico
#AutoIt3Wrapper_Outfile=AutoShot - shotgun2 (zvezdochka).exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <WinAPI.au3>
#Include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <TabConstants.au3>
#Include <Icons.au3>
#Include <PixelSearchEx.au3>
#include <MouseOnEvent.au3>
#include <GUIConstantsEx.au3>
#include <GUIHotKey.au3>
#Include <HotKey.au3>

Opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 2)

global $command=0,$winx,$winy,$hWnD,$starttime,$MAP,$Paused,$Pos1x=0,$Pos1y=0,$xcor=1001,$ycor=1001,$timeout,$pricelx,$pricely,$4y,$sArray
global $getcolordcC,$getcolordcM,$getcolordcB,$getcolordcL,$schet=0,$posy,$schet2=0,$schet3=0,$sArray[2],$sArray,$BulletCoord=0,$Num_cycles=16,$timedown=24,$timeSleepMacros=660,$numDetect=0
global $coordbulletx,$coordbullety

;~ HotKeySet("{NUMPADMULT}", "_DetectWindow_and_start")
;~ HotKeySet("{F7}", "_Ctrl_Win")
;~ HotKeySet("{F8}", "_macros")
;~ HotKeySet("{F9}", "_testmacros")
;~ HotKeySet("{End}", "Terminate")
;~ HotKeySet("{home}", "_Pause")





Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=d:\vitaliy\programs\autoitv3.3.8.1\koda\form1_4.kxf
$Form1_2_1_1 = GUICreate("Autoshot Shotgun", 271, 238, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
GUISetOnEvent($GUI_EVENT_CLOSE, "_Pro_Exit")
$Tab1 = GUICtrlCreateTab(0, 0, 265, 185)
$TabSheet1 = GUICtrlCreateTabItem("���������")
$timeoutI = GUICtrlCreateInput("32", 156, 41, 97, 21)
GUICtrlSetTip(-1, "����� ��������� ��� ���� ����� �� ������,"&@CRLF&"��� ��������� ����� ������� ���������� �������.")
$Label3 = GUICtrlCreateLabel("�������� ����������", 12, 41, 118, 17)
GUICtrlSetTip(-1, "����� ��������� ��� ���� ����� �� ������,"&@CRLF&"��� ��������� ����� ������� ���������� �������.")
$Checkbox1 = GUICtrlCreateCheckbox("������������ ������ '������� �����'?", 17, 73, 241, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
$timeSleepMacrosI = GUICtrlCreateInput("620", 156, 97, 97, 21)
GUICtrlSetTip(-1, "��� ������ �������� ��� ������� �� ������ ������ ��������� �������."&@CRLF&"�� ������� ��������� �������� ������� � ����, �������� ����� ��������"&@CRLF&"�� ���������. ���������� ���� �������� ��� ������ ����������"&@CRLF&"��������� ���� ������� � ���� �������� �� ���������(W+D)"&@CRLF&"� ��� �� ��������, ������ ������� �� ���������.")
$timedownI = GUICtrlCreateInput("24", 156, 129, 97, 21)
GUICtrlSetTip(-1, "����� ������ �� ������. ������� ��������� ��������"&@CRLF&"����� �������� � '�� �����������' �����.")
$Label1 = GUICtrlCreateLabel("�������� �������", 12, 97, 102, 17)
GUICtrlSetTip(-1, "��� ������ �������� ��� ������� �� ������ ������ ��������� �������."&@CRLF&"�� ������� ��������� �������� ������� � ����, �������� ����� ��������"&@CRLF&"�� ���������. ���������� ���� �������� ��� ������ ����������"&@CRLF&"��������� ���� ������� � ���� �������� �� ���������(W+D)"&@CRLF&"� ��� �� ��������, ������ ������� �� ���������.")
$Label2 = GUICtrlCreateLabel("�������� �� ����", 12, 129, 97, 17)
GUICtrlSetTip(-1, "����� ������ �� ������. ������� ��������� ��������"&@CRLF&"����� �������� � '�� �����������' �����.")
$TabSheet2 = GUICtrlCreateTabItem("�������")
$Label4 = GUICtrlCreateLabel("����� �������� � ���� ��", 8, 32, 139, 17)
$Input1 = GUICtrlCreateInput("Input1", 160, 32, 97, 21)
$Input2 = GUICtrlCreateInput("Input2", 160, 56, 97, 21)
$Label5 = GUICtrlCreateLabel("�����", 8, 56, 35, 17)
$Input3 = GUICtrlCreateInput("Input3", 160, 80, 97, 21)
$Label6 = GUICtrlCreateLabel("��������� ���� �������", 8, 80, 128, 17)
$Input4 = GUICtrlCreateInput("Input4", 160, 104, 97, 21)
$Label7 = GUICtrlCreateLabel("��������� �������� ����.", 8, 104, 147, 17)
$Label8 = GUICtrlCreateLabel("��������� �������� ����.", 8, 126, 142, 17)
$Input5 = GUICtrlCreateInput("Input5", 160, 126, 97, 21)
$TabSheet3 = GUICtrlCreateTabItem("����������")
GUICtrlCreateEdit("", 4, 33, 249, 145, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY,$WS_VSCROLL))
GUICtrlSetData(-1, StringFormat("��� ������� ��������:\r\n-��������� ������ ������(������ �����)\r\n-� ���� �� ������� ������� Insert,\r\n��� �� ���������, �� ���. ����������\r\n-���� �� ������� �������� ����, �\r\n������� ������ "&Chr(39)&"���������� �������.."&Chr(39)&"\r\n������ ������� ����� ��������\r\n-���� �� �������� ������� ������� ����\r\n���������� ��� ��� ���� �����\r\n\r\n��� ������ �������:\r\n-�� ������ ��������� ��������� �����,\r\n��� ����� ������� �������� ��� ����.\r\n-��� ����������� �������� �������\r\n����������� � ���� ������� PageDown.\r\n-�������� ����� �� ���������, ��� ��\r\n���������� ��������.\r\n\r\n���������\r\n-�� ������ ������� ������� �������\r\n��� ������ �������� �� �������\r\n"&Chr(39)&"�������"&Chr(39)&".\r\n-��� ��������� ���������� � ����������\r\n�������� ����� �� ���������, ��� ��\r\n���������� ��������.\r\n\r\n"))
GUICtrlCreateTabItem("")
$Button1 = GUICtrlCreateButton("��", 8, 200, 75, 25)
GUICtrlSetOnEvent(-1, "_apply")
$Button2 = GUICtrlCreateButton("�����", 96, 200, 75, 25)
$Button3 = GUICtrlCreateButton("�����", 184, 200, 75, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###







Func Terminate()
TrayTip("���������", "��������� �������, ����� �������� :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

Func _Pro_Exit()
TrayTip("���������", "��������� �������, ����� �������� :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		Sleep(100)
		If $trayP = 1 Then TrayTip("���������", "�����", 1000)
	WEnd
	ToolTip("")
EndFunc   ;==>_Pause

;~ msgbox(0,'�������',''

;~ $timeSleepMacros=InputBox('�������','��������� ������ ������ (������ �����)'&@CRLF&'����� �������� ����, � ���� ������� ������� "*" �� ���.����������'&@CRLF&'����� �� ������� Home'&@CRLF&'������� �� ������� End'&@CRLF&'���� ������� �������� ������� � ������������'&@CRLF&'������ ������� ��, ��������� �����',600,'',250,210)

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func _apply()

$timeout=GUICtrlRead($timeoutI)
$timeSleepMacros=GUICtrlRead($timeSleepMacrosI)
$timedown=GUICtrlRead($timedownI)


EndFunc



Func _DetectWindow_and_start()
	$numDetect+=1
	;��������� ������� �������� �������� ����
	$hWnD = WinGetHandle("[ACTIVE]")
	$sControl = ControlGetFocus($hWnD)
	$aPos = ControlGetPos($hWnD, "", $sControl)
;~ 	MsgBox(0,'',$hWnD& "   "&$sControl& "   "&$aPos& "   ")
	$winx = $aPos[2]
	$winy = $aPos[3]
;~ MsgBox(0,'',$winx& "   "&$winy& "   "&$aPos& "   ")

	;����������� ������ ���� � ������ �������� ���������� x
	Dim $coord[2]
	$Xcoordinat_detected_YES = 0
;~ 	$xcor = 0
;~ 	$ycor = 0
	$getcolor = 0
ConsoleWrite($winx&'  '&$winy&@CRLF)

;����������� ����� ���� � ������ R (��� ������� ����� �������� ���-�� ��������)
_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "_Mouse")
;~ _HotKeyAssign(0x52, '_r',$HK_FLAG_NOBLOCKHOTKEY)


	;������� ����� ���������� - � ���
;~ 	$coord = PixelSearch(0, 0, $winx, $winy, 0x9C9A9C, 1, 1, $hWnD)
;~ 	If Not @error Then $getcolor = Hex(PixelGetColor($coord[0] + 1, $coord[1], $hWnD), 6)
;~ 	If Not @error And $getcolor = "D9E0E7" Then
;~ 		$Xcoordinat_detected_YES = 1
;~ 		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", '���������� � ���������� "X" ������� ������������ ' & $Xcoordinat_detected_YES, 100)
;~ 		$xcor = $coord[0] - 150

;~ 	Else
;~ 		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "���������� � ����������� �� ������������ :(", 100)
;~ 		$xcor = 0
;~ 	EndIf



;~ 	0x67635C
;~ 	0x5C5954

;~ 0x9C9A9C
;~ 0x969496

;~ _func1()

	;������� ����� ���������� - �� ��� � ����
	$coord = PixelSearch(0, 0, $winx, $winy, 0x2A344D, 10, 1, $hWnD)
;~ 	If Not @error Then $getcolor = Hex(PixelGetColor($coord[0] + 1, $coord[1], $hWnD), 6)
;~ 	If Not @error And $getcolor = "D9E0E7" Then
	If Not @error and $coord[0]<100 and $coord[1]<100 Then
		$Xcoordinat_detected_YES = 1
		$xcor = $coord[0]
		$ycor = $coord[1]
		if $xcor<>1001 or $ycor<>1001 then
			TrayTip("���������", '���������� � ����������� ������� ������������ !' & $xcor&'  '&$ycor, 1000)
			Beep(1000, 200)
			sleep(1500)
		Else
			sleep(1500)
			if $numDetect<5 then _DetectWindow_and_start()
		EndIf


	Else
		;����� ���������� � ���� �� ��������� �����
;~ 		$xcor = 0
		$Array=PixelSearchEx(0, 0, $winx, $winy, 0x9C9A9C, 1, 13, 1, $hWnD)
		if @error then
		TrayTip("���������", "���������� � ����������� �� ������������ :(", 1000)
		Beep(3500,900)
		sleep(1500)
		endif
;~ 	$Array[0] = x, $Array[1] = y
;~ 	0x9C9A9C
		$xcor = $Array[0] -135
		$ycor = $Array[1] -170
		$Xcoordinat_detected_YES = 1
		if $xcor<>1001 or $ycor<>1001 then
			TrayTip("���������", '���������� � ����������� ������� ������������ !' & $xcor&'  '&$ycor, 1000)
			Beep(1000, 200)
			sleep(1500)
		Else
			sleep(1500)
			if $numDetect<5 then _DetectWindow_and_start()
		EndIf

	EndIf

ConsoleWrite($xcor&'  '&$ycor&@CRLF)

if $ycor<>0 then
	$4y=($winy*0.0102)
Else
	$4y=0
EndIf


$pricelx=Round (($winx/2)-$xcor) + $xcor
$pricely=Round (($winy/2)-$ycor+$4y) + $ycor
ConsoleWrite($pricelx&'  '&$pricely&@CRLF)
ConsoleWrite($hwnd&@CRLF)
;~ $sArray[0]=$pricelx
;~ $sArray[1]=$pricely




if $Xcoordinat_detected_YES = 1 Then
	if  GUICtrlRead($CheckBox1) = 1 then
		_func2()
	Else
		_func0()
	EndIf

Else
		TrayTip("���������", "���������� � ����������� �� ������������ :(", 1000)
		Beep(3500,900)
		sleep(1500)
EndIf

 _Ctrl_Win()

;~ 0x2A344D

;~ 	while 1
;~ $cx = random(-500,500,1)+500
;~ 	$cy = random(-300,300,1)+300
$cx=870
$cy=770-20
;~ mousemove($cx,$cy)
;~ MouseDown ( "left" )
;~ sleep(64)
;~ Mouseup ( "left" )
;~ sleep(200)


;~ MouseClick('left',870,770-20)
;~ sleep(200)
;~ MouseClick('left',870,770-20)

;~ while 1

;~ 					;������� ~92%
;~ 					$schet=$schet+1
;~ 					$aPos = MouseGetPos()
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aPosx = ' & $aPos[0]) ;### Debug Console
;~ 					ConsoleWrite('       $aPosy = ' & $aPos[1]  & @crlf) ;### Debug Console

;~ 					if $schet=1 then $posy=$aPos[1]
;~ 												ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $schet = ' & $schet & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 					if $schet=1 then
;~ 					mousemove($aPos[0]+1	,$aPos[1],10)
;~ 					else
;~ 					mousemove($Pos1x+(($aPos[0]-$Pos1x)/50)+1	,$Pos1y+(($aPos[1]-$Pos1y)/50),10)
;~ 					endif
;~ 					if $schet=1 then
;~ 					$Pos1x=$aPos[0]
;~ 					$Pos1y=$aPos[1]
;~ 					endif

;~ 					sleep(1000)

										;������� ~92%
;~ 					$schet=$schet+1
;~ 					$aPos = MouseGetPos()
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aPosx = ' & $aPos[0]) ;### Debug Console
;~ 					ConsoleWrite('    $aPosy = ' & $aPos[1]  & @crlf) ;### Debug Console

;~ 					if $schet=1 then $posy=$aPos[1]
;~ 					mousemove($aPos[0]-1	,$aPos[1],10)

;~ 					sleep(1000)
;~ 					wend

;~ ;������� � ������� ������� W
;~ _WinAPI_Keybd_Event(0x57, 0)
;~ sleep(1500)
;~ _WinAPI_Keybd_Event(0x57, 2)

;~ ;������� � ������� ������� M
;~ _WinAPI_Keybd_Event(57, 0)
;~ sleep(1500)
;~ _WinAPI_Keybd_Event(57, 2)

;������
;~ _WinAPI_Keybd_Event(Number($a[0]), $iFlags)
;~ _WinAPI_keybd_event ($vkCode, $iScanCode, $iFlag, $iExtraInfo) (required: #include <WinAPIEx.au3>)

;~ $getcolorL = Hex(PixelGetColor(511 + $xcor, 383 + $ycor, $hWnD), 6)
;~ $getcolorL = Hex(PixelGetColor(523 + $xcor, 484 + $ycor), 6/)
;~ consolewrite($getcolorL)

;~ 0x35FF35

;~ MsgBox(0,'',$getcolorL)
;~ traytip('',$getcolorL	,100)
;~ sleep(300)
;~ wend

traytip('','� ��������',500)

EndFunc



func _func1()
;~ $i=0

while 1
$sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,0,1,$hWnD)
;~ if not @error then ConsoleWrite('Est1-'&$sArray[0]&'-'&$sArray[1]&'  ')
;~ $sArray=pixelsearch($winx, 0,0 , $winy,0xABA8A3,0,1,$hWnD)
;~ $sArray=pixelsearch(130,24, 130,24,0x394051,1,1,$hWnD)
if @error then
	ConsoleWrite('No'&@CRLF)
Else
	$BulletCoord=1
	$coordbulletx=$sArray[0]
	$coordbullety=$sArray[1]
;~ 	ConsoleWrite('Est2 '&$sArray[0]&'  '&$sArray[1]&'  ')
EndIf

;~ if not @error then

;~ endif
for $r=0 to $Num_cycles						;�������� �������� ��� ���������!!!!!!!!!!!!!!
;~ $i+=1
;~ ������� 0x61FF40
;~ ������� 0xFF573B 0xFF1617 0xFF0000

$getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);������ � ������ ��������
;~ $getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)
IF $getcolorL = 'FFFFFF' Then
sleep(64)
_func1()
endif
;~ $getcolorL = Hex(PixelGetColor(523 + $xcor, 484 + $ycor), 6)
;~ (1030/2)-$xcor       (793/2)-$ycor+8
;~ 512 383
;~ 576 432

;~ 1024  768
;~ 0  0
;~ 512  392
;~ 516 389
;~ consolewrite($getcolorL& '  ')
;~ 0x00050494
$getcolorLs=StringLeft ( $getcolorL, 2 );������ � ������ ��������

;~ if $getcolorL = 0xFF0000 Then
;~ if $getcolorL = 'FF0000' Then
if $getcolorLs = 'FF' Then  ;������ � ������ ��������
;~ 	consolewrite('SHOT'&@CRLF)
	MouseDown ( "left" )
	sleep(50)
	if $BulletCoord=1 Then
		$BulletCoord=0
		$timeccle=TimerInit()
		while 1
	$getcolorBullet = PixelGetColor($coordbulletx,$coordbullety, $hWnD)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $getcolorBullet = ' & hex($getcolorBullet,6) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 	ConsoleWrite ('$getcolorBullet = '&$getcolorBullet&@CRLF)
	if $getcolorBullet<>0xABA8A3 then _macros()
	if TimerDiff($timeccle)>500 then ExitLoop
		wend
	endif
	Mouseup ( "left" )
	_func1()
;~ 	consolewrite($getcolorL& '  ')
else
	sleep ($timeout)
endif
;~ consolewrite($getcolorL& '  ')
;~ consolewrite($getcolorLs& '  ')
next
wend
endfunc


func _func0()
;~ $i=0

while 1
;~ $sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,0,1,$hWnD)
;~ if not @error then ConsoleWrite('Est1-'&$sArray[0]&'-'&$sArray[1]&'  ')
;~ $sArray=pixelsearch($winx, 0,0 , $winy,0xABA8A3,0,1,$hWnD)
;~ $sArray=pixelsearch(130,24, 130,24,0x394051,1,1,$hWnD)
;~ if @error then
;~ 	ConsoleWrite('No'&@CRLF)
;~ Else
;~ 	$BulletCoord=1
;~ 	ConsoleWrite('Est2 '&$sArray[0]&'  '&$sArray[1]&'  ')
;~ EndIf

;~ if not @error then

;~ endif
;~ for $r=0 to 9						;�������� �������� ��� ���������!!!!!!!!!!!!!!
;~ $i+=1
;~ ������� 0x61FF40
;~ ������� 0xFF573B 0xFF1617 0xFF0000

;~ $getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);������ � ������ ��������
$getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)
;~ IF $getcolorL = 'FFFFFF' Then
;~ sleep(64)
;~ _func0()
;~ endif
;~ $getcolorL = Hex(PixelGetColor(523 + $xcor, 484 + $ycor), 6)
;~ (1030/2)-$xcor       (793/2)-$ycor+8
;~ 512 383
;~ 576 432

;~ 1024  768
;~ 0  0
;~ 512  392
;~ 516 389
;~ consolewrite($getcolorL& '  ')
;~ 0x00050494
;~ $getcolorLs=StringLeft ( $getcolorL, 2 );������ � ������ ��������

if $getcolorL = 0xFF0000 Then
;~ if $getcolorL = 'FF0000' Then
;~ if $getcolorLs = 'FF' Then  ;������ � ������ ��������
;~ 	consolewrite('SHOT'&@CRLF)
	MouseDown ( "left" )
	sleep($timedown)
;~ 	if $BulletCoord=1 Then
;~ 		$BulletCoord=0
;~ 	$getcolorBullet = PixelGetColor($sArray[0],$sArray[1], $hWnD)
;~ 				ConsoleWrite ('$getcolorBullet = '&$getcolorBullet&@CRLF)
;~ 	if $getcolorBullet=0xABA8A3 then _macros()

;~ 	endif
	Mouseup ( "left" )
;~ 	consolewrite($getcolorL& '  ')
else
	sleep ($timeout)
endif
;~ consolewrite($getcolorL& '  ')
;~ consolewrite($getcolorLs& '  ')
;~ next
wend
endfunc

func _macros()

;~ 	5 10010 1005
;~ 60 780	720
;~ 915
;~ 720
;~ 0xABA8A3
;~ consolewrite( '_macros  '&@CRLF)
;~ $sArray=pixelsearch(1005, 720, 915, 720,0xABA8A3,$hWnD)
;~ $getcolorBullet = PixelGetColor($sArray[0],$sArray[1], $hWnD)
;~ if $getcolorBullet=0xABA8A3 then _macros()
;~ sleep(124)
_WinAPI_Keybd_Event(0x33, 0) ;������� 3
sleep($timedown)
_WinAPI_Keybd_Event(0x33, 2) ;������� 3
;~ sleep(124)
_WinAPI_Keybd_Event(0x31, 0) ;������� 1
sleep($timedown)
_WinAPI_Keybd_Event(0x31, 2) ;������� 1
Mouseup ( "left" )
sleep($timeSleepMacros)											;�������� �������


endfunc


func _testmacros($mode=0)
;~ 	$sArray=pixelsearch(1005+$ycor, 716+$xcor , 915+$ycor , 725+$xcor ,0xABA8A3,5,1,$hWnD)
while 1
	MouseDown ( "left" )
	sleep($timedown)
;~ 	if $BulletCoord=1 Then
;~ 		$BulletCoord=0
;~ 	$getcolorBullet = PixelGetColor($sArray[0],$sArray[1], $hWnD)
;~ 				ConsoleWrite ('$getcolorBullet = '&$getcolorBullet&@CRLF)
;~ 	if $getcolorBullet=0xABA8A3 then _macros()
	_macros()
;~ 	endif
;~ 	Mouseup ( "left" )

wend
EndFunc


func _Ctrl_Win()

	;~ ;������� � ������� ������� CTRL
	_WinAPI_Keybd_Event(0xA2, 0)
	;~ sleep(1500)
	;~ _WinAPI_Keybd_Event(0xA2, 2)

	;~ ;������� � ������� ������� Win
;~ 	_WinAPI_Keybd_Event(0x5B, 0)
;~ 	sleep(64)
;~ 	_WinAPI_Keybd_Event(0x5B, 2)
WinActivate("������")

EndFunc



func _func2()
;~ $i=0
_shot()

;~ while 1
;~ $sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,0,1,$hWnD)
;~ 	;~ if not @error then ConsoleWrite('Est1-'&$sArray[0]&'-'&$sArray[1]&'  ')
;~ 	;~ $sArray=pixelsearch($winx, 0,0 , $winy,0xABA8A3,0,1,$hWnD)
;~ 	;~ $sArray=pixelsearch(130,24, 130,24,0x394051,1,1,$hWnD)
;~ if @error then
;~ 	;~ 	ConsoleWrite('No'&@CRLF)
;~ Else
;~ 	;~ 	$BulletCoord=1
;~ $coordbulletx=$sArray[0]
;~ $coordbullety=$sArray[1]
;~ _shot()
;~ 	;~ 	ConsoleWrite('Est2 '&$sArray[0]&'  '&$sArray[1]&'  ')
;~ EndIf

;~ 	;~ if not @error then

;~ 	;~ endif

;~ wend
endfunc

func _shot()

while 1
;~ 	for $r=0 to $Num_cycles+55						;�������� �������� ��� ���������!!!!!!!!!!!!!!
;~ 	$FirstShot=1

;~ $getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);������ � ������ ��������
$getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)


if $getcolorL = 0xFF0000 Then
	MouseDown ( "left" )
	sleep($timedown)
;~ 	if $FirstShot=1 then
;~ 		$FirstShot=0
		_macros()
		_func2()
;~ 	Else
;~ 		$getcolorBullet = PixelGetColor($coordbulletx,$coordbullety, $hWnD)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $getcolorBullet = ' & hex($getcolorBullet,6) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ 		if $getcolorBullet=0xABA8A3 then _macros()
;~ 		_func2()
;~ 	EndIf
	Mouseup ( "left" )
	_func2()

else
	sleep ($timeout)
endif

;~ consolewrite($getcolorLs& '  ')
;~ next
wend

endfunc


func _Mouse()
	sleep($timeSleepMacros)
	if  GUICtrlRead($CheckBox1) = 1 then
		_func2()
	Else
		_func0()
	EndIf

EndFunc

;~ func _r()
;~ 	$KeyR=TimerInit()
;~ 	6700
;~
;~ EndFunc
