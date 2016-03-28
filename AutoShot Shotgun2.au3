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






While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

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
	$winx = $aPos[2]
	$winy = $aPos[3]

	;����������� ������ ���� � ������ �������� ���������� x
	Dim $coord[2]
	$Xcoordinat_detected_YES = 0
	$getcolor = 0
	ConsoleWrite($winx&'  '&$winy&@CRLF)

	;����������� ����� ���� � ������ R (��� ������� ����� �������� ���-�� ��������)
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "_Mouse")
	;~ _HotKeyAssign(0x52, '_r',$HK_FLAG_NOBLOCKHOTKEY)


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
		;����� ���������� � ���� �� ������� �� �����
;~ 		$xcor = 0
		$Array=PixelSearchEx(0, 0, $winx, $winy, 0x9C9A9C, 1, 13, 1, $hWnD)
		if @error then
		TrayTip("���������", "���������� � ����������� �� ������������ :(", 1000)
		Beep(3500,900)
		sleep(1500)
		endif
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

ConsoleWrite($xcor&'  '&$ycor&@CRLF) ;�������� � ������� ���������� ���������

if $ycor<>0 then
	$4y=($winy*0.0102)
Else
	$4y=0
EndIf

;������ ��������� �������
$pricelx=Round (($winx/2)-$xcor) + $xcor
$pricely=Round (($winy/2)-$ycor+$4y) + $ycor
ConsoleWrite($pricelx&'  '&$pricely&@CRLF)
ConsoleWrite($hwnd&@CRLF)

;������ ���������������� ��������� ��������
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

EndFunc


; (�� �Ũ �������� ���������� ��-�� ���� ���������� �������) ������� ������ ��������� ���� � ������, � �������� � ������� ������� � ������ ����.
func _func1()

while 1

$sArray=pixelsearch(1005+$xcor, 720+$ycor , 915+$xcor , 720+$ycor ,0xABA8A3,0,1,$hWnD)
;~ $sArray=pixelsearch($winx, 0,0 , $winy,0xABA8A3,0,1,$hWnD)
;~ $sArray=pixelsearch(130,24, 130,24,0x394051,1,1,$hWnD)
if @error then
	ConsoleWrite('No'&@CRLF)
Else
	$BulletCoord=1
	$coordbulletx=$sArray[0]
	$coordbullety=$sArray[1]
EndIf

for $r=0 to $Num_cycles						;�������� �������� ��� ���������!!!!!!!!!!!!!!

$getcolorL = Hex(PixelGetColor($pricelx-1, $pricely-1, $hWnD), 6);������ � ������ ��������
;~ $getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)
IF $getcolorL = 'FFFFFF' Then
sleep(64)
_func1()
endif

$getcolorLs=StringLeft ( $getcolorL, 2 );������ � ������ ��������

;~ if $getcolorL = 0xFF0000 Then
;~ if $getcolorL = 'FF0000' Then
if $getcolorLs = 'FF' Then  ;������ � ������ ��������
	MouseDown ( "left" )
	sleep(50)
	if $BulletCoord=1 Then
		$BulletCoord=0
		$timeccle=TimerInit()
		while 1
	$getcolorBullet = PixelGetColor($coordbulletx,$coordbullety, $hWnD)
	if $getcolorBullet<>0xABA8A3 then _macros()
	if TimerDiff($timeccle)>500 then ExitLoop
		wend
	endif
	Mouseup ( "left" )
	_func1()
else
	sleep ($timeout)
endif
next
wend
endfunc

;������ ������� ������ �������, �������� ������� �������� ������� � �������
func _func0()

while 1

	$getcolorL = PixelGetColor($pricelx-1, $pricely-1, $hWnD)

	if $getcolorL = 0xFF0000 Then
		MouseDown ( "left" )
		sleep($timedown)
		Mouseup ( "left" )
	else
		sleep ($timeout)
	endif

wend

endfunc


;(�� ������ ������ ������������ � ��������������) ������� �������� � ��������
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

;������� ������� ������� �����
func _macros()

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

;������� ����� �������, ��� ����������� ������������ �������� ��������
func _testmacros($mode=0)

while 1
	MouseDown ( "left" )
	sleep($timedown)
	_macros()
wend
EndFunc

;������� ��������� ����� ������� CTRL (����������) � �������� �� ������ ����.
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


;������� �������� ��� Func2
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

;������� ������������ ����� ����
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
