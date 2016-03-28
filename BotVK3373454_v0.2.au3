#include <WinAPI.au3>
#include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Icons.au3>
#region
#AutoIt3Wrapper_Res_File_Add="primer.bmp", 2, 200
#endregion

Opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 2)

Global $hWnD, $sControl, $xcor, $ycor, $nstart, $sleepclick, $loc, $CheckBox1, $Paused
Global $wait_for_battle = 1 ;����� � ������ � ���� 1�1 ��� �������� ���������� ���
Global $testdelay = 0, $sleepclick = 1000, $menudelay = 1000

#region ### Coords
;���������� ����� � ���
Global $cx_attack = 360, $cy_attack = 470
;���������� ������������� ��������� � ���
Global $cx_helper = 700, $cy_helper = 470
;���������� ����� �� ������� ������ �������
Global $cx_loc[10][6 + 1], $cy_loc[10][6 + 1]
$cx_loc[1][1] = 665
$cy_loc[1][1] = 100
$cx_loc[1][2] = 370
$cy_loc[1][2] = 300
$cx_loc[1][3] = 630
$cy_loc[1][3] = 370
$cx_loc[1][4] = 440
$cy_loc[1][4] = 525
$cx_loc[1][5] = 650
$cy_loc[1][5] = 570
$cx_loc[1][6] = 270
$cy_loc[1][6] = 650
;���������� ����� �� ������� �������� �����
$cx_loc[2][1] = 500
$cy_loc[2][1] = 120
$cx_loc[2][2] = 759
$cy_loc[2][2] = 135
$cx_loc[2][3] = 817
$cy_loc[2][3] = 355
$cx_loc[2][4] = 407
$cy_loc[2][4] = 290
$cx_loc[2][5] = 750
$cy_loc[2][5] = 520
$cx_loc[2][6] = 400
$cy_loc[2][6] = 690
;���������� ����� �� ������� 3 ��������
$cx_loc[3][1] = 790
$cy_loc[3][1] = 165
$cx_loc[3][2] = 660
$cy_loc[3][2] = 340
$cx_loc[3][3] = 430
$cy_loc[3][3] = 405
$cx_loc[3][4] = 193
$cy_loc[3][4] = 430
$cx_loc[3][5] = 773
$cy_loc[3][5] = 550
$cx_loc[3][6] = 320
$cy_loc[3][6] = 695
#endregion ### Coords

HotKeySet("{ScrollLock}", "Terminate")
Func Terminate()
	If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "��������� �������, ����� �������� :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

HotKeySet("{F1}", "_DetectWindow_and_start") ;�������� ���� �� ������ �������
HotKeySet("{F2}", "_DetectWindow_and_start") ;�������� ���� �� ������ �������
HotKeySet("{F3}", "_local_detect") ;������ � ��������� ���
HotKeySet("{F4}", "_CloseClick")
;~ HotKeySet("{F4}", "_pause") ;������ � ��������� ���
HotKeySet("{F6}", "_DetectWindow_and_start2")


Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		Sleep(100)
		If $trayP = 1 And GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "�����", 1000)
	WEnd
	ToolTip("")
EndFunc   ;==>_Pause


;����������� ��������� ������������
Opt("GUIOnEventMode", 1)
#region ### START Koda GUI section ### Form=e:\vitaliy\programs\autoitv3.3.8.1\form1_3.kxf
$Form1_2 = GUICreate("��� �� ������� ���� � ��", 362, 453, -1, -1, BitOR($GUI_SS_DEFAULT_GUI, $WS_SIZEBOX, $WS_THICKFRAME))
$sleepclick = GUICtrlCreateInput("1000", 232, 320, 121, 21)
$Label3 = GUICtrlCreateLabel("������� �������� ����� ������� � ��.", 8, 320, 210, 17)
$Bossnumber = GUICtrlCreateCombo("�������", 208, 352, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "���������|������")
$Label4 = GUICtrlCreateLabel("�������� ����� ��� ���������� ���", 8, 352, 190, 17)
$WorkEnergynumber = GUICtrlCreateCombo("�������", 208, 384, 145, 25, BitOR($CBS_DROPDOWN, $CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "�� ������������")
$Label5 = GUICtrlCreateLabel("����� ��� ������������� �������", 8, 384, 182, 17)
$Button1 = GUICtrlCreateButton("�����", 143, 416, 105, 25)
GUICtrlSetOnEvent(-1, "_Pro_Exit")
$CheckBox1 = GUICtrlCreateCheckbox("���������� ����������� ���������?", 8, 296, 241, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateEdit("", 8, 8, 329, 193, BitOR($ES_AUTOVSCROLL, $ES_AUTOHSCROLL, $ES_READONLY))
GUICtrlSetData(-1, StringFormat("�������� ���������� � ��������� ���� (�� ����������), \r\n��������� �� ������ ������� � ������� ������� " & Chr(34) & "F2" & Chr(34) & "\r\n��� ���� �� ������ ������ ��������.\r\n�� ������ ������ ��� ��������� ��������� �������:\r\n1. ��� � ������������ �� 1 � 2 ������� ���������, �����\r\n� ���� ���������\r\n2. �������� ������� � ��������� ���� � ���������� �� �����\r\n3. ��������� ������ ��������� �������\r\n" & Chr(34) & "F3" & Chr(34) & " - ������� � ��������� �� ����� �� �������\r\n" & Chr(34) & "F4" & Chr(34) & " - �����, ��� ����������� ����� ������� " & Chr(34) & "F4" & Chr(34) & "\r\n" & Chr(34) & "F6" & Chr(34) & " - ��� �������� ��������� ���� ����� ������ � ���\r\n\r\n���� ������ �������� ������ ����, �� ������� ��� ���, �����\r\n������� ���� ���������� ��� �����"))
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###
#region ### GUI


;~ $Pic2 = GUICtrlCreatePic("C:\TEMP\autoitv3.3.8.1\primer.bmp", 8, 160, 204, 82)
$Pic = GUICtrlCreatePic("", 8, 165 + 24 + 16, 204, 82)
$hInstance = _WinAPI_GetModuleHandle(0)
$hBitmap = _WinAPI_LoadBitmap($hInstance, 200)
_SetHImage($Pic, $hBitmap)
_WinAPI_DeleteObject($hBitmap)


While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd
#endregion ### GUI

;����� �� ���� �� ������� ������ �����
Func _Pro_Exit()
	Exit
EndFunc   ;==>_Pro_Exit

;������� ����������� ����, ��� ���������� �� ������
Func _whats_wrong()

	$B_Close_Wrong = 0
	$B_Close_Wrong = PixelSearch(490 + $xcor, 340 + 77 + $ycor, 545 + $xcor, 350 + 77 + $ycor, 0x6EAD55, 1, 1, $hWnD)
	If $B_Close_Wrong <> 0 Then _Click($B_Close_Wrong[0] - $xcor, $B_Close_Wrong[1] - 77 - $ycor)
	If $B_Close_Wrong <> 0 Then _F5_Reload()


EndFunc   ;==>_whats_wrong

;������� ������ �� ���������� ����������� ControlClick
Func _Click($cx, $cy, $mod = 0)
	;��������� ��������
	If $mod = 0 Then ;$cx<>360 or
		$sleepD = Random(GUICtrlRead($sleepclick), GUICtrlRead($sleepclick) * 1.5, 1)
		Sleep($sleepD)
	Else
		$sleepH = Random(0, 10, 1)
		Sleep($sleepH)
	EndIf

;~ ControlFocus ( $hWnD, "", '' )

;~ 			$mousePos = MouseGetPos()

;~ 			MouseMove ( $cx+$xcor, $cy+77+$ycor ,0 )

	ControlClick($hWnD, '', $sControl, "left", 1, $cx + $xcor + Random(-4, 4, 1), $cy + $ycor + Random(-4, 4, 1))

;~ 			 MouseMove ( $mousePos[0], $mousePos[1] ,0 )

EndFunc   ;==>_Click

;������� ���������� ������ � ���� �� �������
Func _CloseClick()

;���� �� �������� ��������
	$B_Close_Wrong2 = 0
	$B_Close_Wrong2 = PixelSearch(0, 0, 920, 790, 0xFF7425, 0, 1, $hWnD)
	If Not @error Then
		$getcol1 = Hex(PixelGetColor($B_Close_Wrong2[0], $B_Close_Wrong2[1] + 1, $hWnD), 6)
		$getcol2 = Hex(PixelGetColor($B_Close_Wrong2[0], $B_Close_Wrong2[1] + 2, $hWnD), 6)
		If $getcol1 = 'FF7425' And $getcol2 = 'FF7425' Then _Click($B_Close_Wrong2[0] + 6, $B_Close_Wrong2[1] + 6 - 77)
	EndIf

;���� �� �������� ��������� ���
	$B_Close_Wrong3 = 0
	$B_Close_Wrong3 = PixelSearch(0, 0, 920, 790, 0xEC9292, 0, 1, $hWnD)
	If Not @error Then
		$getcol1 = Hex(PixelGetColor($B_Close_Wrong3[0]+8, $B_Close_Wrong3[1], $hWnD), 6)
		$getcol2 = Hex(PixelGetColor($B_Close_Wrong3[0]+16, $B_Close_Wrong3[1], $hWnD), 6)
		If $getcol1 = 'EC9292' And $getcol2 = 'EC9292' Then _Click($B_Close_Wrong3[0] + 9, $B_Close_Wrong3[1] + 9 - 77)
	EndIf

EndFunc   ;==>_CloseClick

;����������� ������� �������� � ������ ������
Func _local_detect($Targetloc = 0)
	;����������� �������
	Dim $locLD
;~    $loc=2
	Sleep(1500) ;�������� �� ������ �������� �������
	$noloc = 0
	$noloc = $loc
	$getcolorL = Hex(PixelGetColor(776 + $xcor + 5, 133 + 77 + $ycor, $hWnD), 6)
	If $getcolorL = '615B4D' Then $locLD = 1
	If $getcolorL = '171C08' Then $locLD = 2
	If $getcolorL = '221914' Then $locLD = 3
	Global $loc = $locLD
	If $nstart = 0 Then
		If @HotKeyPressed = "{F1}" Then $loc = 1
		If @HotKeyPressed = "{F2}" Then $loc = 2
		$nstart = 1
	EndIf
	If $loc = 0 Then $loc = $noloc ;����������� � ����������� ��������� ������� �� ������ ������

	If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", '�� �� ' & $loc & '-� �������', 100)
	Sleep(2000) ;�������
	Sleep($testdelay)
	Return $loc
EndFunc   ;==>_local_detect


;����������� ���� � ����� � ������ ������ ��� �� �������
Func _DetectWindow_and_start()
	$nstart = 0 ;�������

	;��������� ������� �������� �������� ����
	$hWnD = WinGetHandle("[ACTIVE]")
	$sControl = ControlGetFocus($hWnD)
	$aPos = ControlGetPos($hWnD, "", $sControl)
	$winx = $aPos[2]
	$winy = $aPos[3]

	;����������� ������ ���� � ������ �������� ���������� x
	Dim $coord[2]
	$Xcoordinat_detected_YES = 0
	$xcor = 0
	$getcolor = 0
	$coord = PixelSearch(140, 125, 700, 156, 0xF2F2F2, 1, 1, $hWnD)
	If Not @error Then $getcolor = Hex(PixelGetColor($coord[0] + 1, $coord[1], $hWnD), 6)
	If Not @error And $getcolor = "D9E0E7" Then
		$Xcoordinat_detected_YES = 1
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", '���������� � ���������� "X" ������� ������������ ' & $Xcoordinat_detected_YES, 100)
		$xcor = $coord[0] - 150

	Else
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "���������� � ����������� �� ������������ :(", 100)
		$xcor = 0
	EndIf

	;����������� ������ ���� � ������ �������� ���������� Y
	Dim $coord2[2]
	$ycor = 0
	$getcolor = 0
	$coord2 = PixelSearch($winx / 2, 0, ($winx / 2) + 1, $winy, 0xDAE1E8, 1, 1, $hWnD)
	If Not @error Then $getcolor = Hex(PixelGetColor($coord2[0], $coord2[1] + 1, $hWnD), 6)
	If Not @error And $getcolor = "F7F7F7" Then
		If $Xcoordinat_detected_YES = 1 Then
			$ycor = $coord2[1] - 147
			If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", '���������� � ���������� "X" ������� ������������ = ' & $xcor & @CR & '���������� � ���������� "Y" ������� ������������ = ' & $ycor, 1000)
		Else
			If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", '���������� � ���������� "Y" ������� ������������', 1000)
		EndIf
	Else
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "���������� � ���������� Y �� ������������ :(", 1000)
		$ycor = 0
	EndIf

	Sleep($testdelay)


	Global $Q = 12000
	_local_detect()
	_thinks_loc()


EndFunc   ;==>_DetectWindow_and_start


;��� � ������������ �� ������� ���������, ����� � ���� ���������
Func _thinks_loc()

	If GUICtrlRead($CheckBox1) = 1 Then TrayTip('', '������� � ������ ����� ' & $loc, 1000)
	Sleep($testdelay)

	For $thin = 1 To $Q
		$aRandom = _RandomEx(1, 6, 1, 6, 1)


		For $i = 1 To 6

			If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "� ��� ����", 100);�������
			_local_detect()
			_pause_battle() ;����� � ������ � ���� 1�1 ��� �������� ���������� ���
			_whats_wrong()

			$t = $aRandom[$i]
			_Click($cx_loc[$loc][$t], $cy_loc[$loc][$t])
			$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 444 + 77 + $ycor, $hWnD), 6)
			If $getcolor_attack = 'A7A7A7' Then $i = 6 ;������ ��� �����!!!!!!!������ ��� �����!!!!!!!������ ��� �����!!!!!!!
			;��������� ��������� � ������
			$B_Close = 0
			$B_Close = PixelSearch(460 + $xcor, 560 + 77 + $ycor, 470 + $xcor, 570 + 77 + $ycor, 0x6EAD55, 1, 1, $hWnD)
			If $B_Close <> 0 Then _Click($B_Close[0] - $xcor, $B_Close[1] - 77 - $ycor)
			;������� ��� �� ��� � ��������� �� ���
			$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
			If $getcolor_attack = 'A7A7A7' Then _fight()
;~ 		 MsgBox(0, '���������', ' �� � ��� ' & $getcolor_attack) ;�������
			;������� ����������� ������ �����
;~ 						$iDiff = TimerDiff($hTimer) ;$hTimer = TimerInit()
;~ 						if $iDiff<15000 then
;~ 						   $Q=1
;~ 						else
;~ 						   exit ; ��������� ������ ����
;~ 						endif
			_CloseClick() ;�� ������ ������
		Next
	Next

EndFunc   ;==>_thinks_loc

;������� ���
Func _fight()
	If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "� � ���!", 100) ;�������
	$hTimer_f = TimerInit() ;����� ������� �� ������ ������ � "������� ���"


;~    _Click($cx_helper, $cy_helper,1)

	_Click($cx_helper, $cy_helper, 1)
	Sleep(64)
	_Click($cx_attack, $cy_attack)
	Sleep(200)

	If TimerDiff($hTimer_f) > 600000 Then Return ;����� ������� �� ������ ������ � "������� ���"

	;��������� ��������� � ������
	$B_Close = 0
	$B_Close = PixelSearch(440 + $xcor, 550 + 77 + $ycor, 600 + $xcor, 570 + 77 + $ycor, 0x6EAD55, 10, 1, $hWnD)
;~ 		 $B_Close = PixelSearch ( 460+$xcor, 560+77+$ycor, 470+$xcor, 570+77+$ycor, 0x6EAD55,10,1, $hWnd )
	If $B_Close = 0 Then
		_fight()
	Else
		_Click($B_Close[0] - $xcor, $B_Close[1] - 77 - $ycor)
		Sleep(500)
		_Click($B_Close[0] - $xcor + 10, $B_Close[1] - 77 - $ycor + 10) ;������ ���� �� ������ �� ������������ (������)
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "����� �� ���", 100);�������
;~ 		 _thinks_loc($loc)
	EndIf


EndFunc   ;==>_fight


;����� � ������ � ���� 1�1 ��� �������� ���������� ���
Func _pause_battle()
	If GUICtrlRead($CheckBox1) = 1 Then TrayTip('', '������� ����� � ���, ������: ' & @MIN, 100)
	Sleep($testdelay)
;~ 	  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=15 or @MIN=00 or @MIN=30 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then _fight_detect()
	If @MIN = 14 Or @MIN = 59 Or @MIN = 29 Or @MIN = 13 Or @MIN = 58 Or @MIN = 28 And $wait_for_battle = 1 Then
;~ 		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip('', '������� ����� � ���, �������: ' & $loc & "   ����� �������� �����������   ", 100)
		Sleep($testdelay)
		_fight_detect()
	Else
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip('', '������� ����� � ���, �������: ' & $loc & "  ��� ����� ����� �������   ", 100)
		Sleep($testdelay)

		;������� ��� ����� �� ������ �������
;~ 				If @MIN>=45 and @MIN<=57 or @MIN>=20 and @MIN<=27 then
		If @MIN >= 20 And @MIN <= 27 Or @MIN >= 39 And @MIN <= 49 Then
			If $loc = 1 Then Return
			If $loc = 2 or $loc = 3 Then
				_Change_loc(1)
				If GUICtrlRead($CheckBox1) = 1 Then TrayTip('', '������� ����� � ���, �������: ' & $loc & "   �������� ������� �� ������   ", 100)
				Sleep($testdelay)
				_thinks_loc()

			Else
				If GUICtrlRead($CheckBox1) = 1 Then TrayTip('', '������� ����� � ���, �������: ' & $loc & "   �����   ", 100)
				Sleep($testdelay)
				Return
			EndIf
		Else
		EndIf

		;������� ��� ����� �� ������ �������
;~ 				If @MIN>=45 and @MIN<=57 or @MIN>=20 and @MIN<=27 then
		If @MIN >= 50 And @MIN <= 57 Then
			If $loc = 3 Then Return
			If $loc = 2 or $loc = 1 Then
				_Change_loc(3)
				If GUICtrlRead($CheckBox1) = 1 Then TrayTip('', '������� ����� � ���, �������: ' & $loc & "   �������� ������� �� ������   ", 100)
				Sleep($testdelay)
				_thinks_loc()

			Else
				If GUICtrlRead($CheckBox1) = 1 Then TrayTip('', '������� ����� � ���, �������: ' & $loc & "   �����   ", 100)
				Sleep($testdelay)
				Return
			EndIf
		Else
		EndIf

		;if Guictrlread($CheckBox1)=1 then Traytip('','������� ����� � ���, �������: '&$loc&"  ������ � �� �����(((   ",100)
		Sleep($testdelay)
	EndIf

EndFunc   ;==>_pause_battle


;����� �������
Func _Change_loc($location)
;~    global $loc=$location

	_Click(882, 299) ;�������� �� ����� ��� ����� �������
	Sleep(1000)
	If $location = 1 Then
		_Click(556, 349) ;������ �������
		Global $loc = 1
	EndIf
	If $location = 2 Then
		_Click(740, 326) ;������ �������
		Global $loc = 2
	EndIf
	If $location = 3 Then
		_Click(470, 420) ;������ �������
		Global $loc = 2
	EndIf
	Sleep(1000)

EndFunc   ;==>_Change_loc

;������� �������� ���������� ��� � �������� ������ �� ����� �����
Func _fight_detect()

	$hTimer_fd = TimerInit() ;����� ������� �� ������ ������ � "������� ���"

	For $fight_detect = 0 To 1
		_Change_loc(2)
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "������ ���������� ���", 100) ;�������
		Sleep($testdelay)

		;������� ��� �� ��� � ��������� �� ���
		$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
		If $getcolor_attack = 'A7A7A7' Then _fight()

		;�������� ���
		If @MIN = 59 Or @MIN = 58 Or @MIN = 29 Or @MIN = 28 Then
;~    if @MIN=59 or @MIN=00 or @MIN=29 or @MIN=30 then
			_bossSelect()

			; �������� ��������� �������
			_WorkEnergy()

		Else
			If @MIN = 14 Or @MIN = 13 Then
				_Select30x30()

			Else
				_thinks_loc()
			EndIf


		EndIf

		;������� ��� �� ��� � ��������� �� ���
		$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
		If $getcolor_attack = 'A7A7A7' Then _fight()
	Next

	While 1
		;������� ��� �� ��� � ��������� �� ���
		$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
		If $getcolor_attack = 'A7A7A7' Then _fight()
		If TimerDiff($hTimer_fd) > 180000 Then Return ;����� ������� �� ������ ������ � "������� �������� ���"
	WEnd
EndFunc   ;==>_fight_detect

Func _bossSelect()
	$BossN = GUICtrlSendMsg($Bossnumber, $CB_GETCURSEL, 0, 0)
	If $BossN = 2 Then _Click(614, 145) ;����� ���������
	If $BossN = 1 Then _Click(745, 610) ;����� ���������
	If $BossN = 0 Then _Click(315, 350) ;����� �������

	;������������ ����� ���
	Sleep($menudelay)
	_Click(655, 420) ; ������ � ���
	If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "��� ������", 100);�������
	Sleep($menudelay)
	_Click(604, 310) ;���� � ���� ���
	Sleep($menudelay)
	_Click(755, 180) ;��������� ���� ������

EndFunc   ;==>_bossSelect

Func _WorkEnergy()
	$workE = GUICtrlSendMsg($WorkEnergynumber, $CB_GETCURSEL, 0, 0)
	If $workE <> 1 Then
		Sleep($menudelay)
		_Click(305, 165) ;����� �������
		Sleep($menudelay)
		;������������ ������ ������, ���� ������� ���� ������ ������
		For $i = 0 To 63
			$coord = PixelSearch(575 + $xcor, 310 + 77 + $ycor, 580 + $xcor, 700 + 77 + $ycor, 0x6EAD55, 5)
			If Not @error Then
				_Click($coord[0] - $xcor, $coord[1] - 77 - $ycor)
				Sleep(600) ;����� ����� ������� �� ������ ��������� �������
			Else
				;��������� ��������� � ��������
				_Click(800, 190) ;������� �� ����������� ������� �������
				Sleep($menudelay)
				_Click(782, 111) ;������� �� ���� ������

				;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				$B_Close = 0
				$B_Close = PixelSearch(520 + $xcor, 420 + 77 + $ycor, 525 + $xcor, 700 + 77 + $ycor, 0x6EAD55, 1, 1, $hWnD)
				If $B_Close <> 0 Then _Click($B_Close[0] - $xcor, $B_Close[1] - 77 - $ycor)
				ExitLoop
			EndIf

		Next
	EndIf
EndFunc   ;==>_WorkEnergy

Func _Select30x30()
	_Click(800, 190) ;����� ��� 30�30 �� ������ �������

	;������������ ����� ���
	Sleep(1000)
	_Click(410, 565) ; ������ � ��� 30�30
	If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "��� ������", 100);�������
	Sleep(1000)
	_Click(604, 310) ;���� � ���� ���
	Sleep(1000)
	_Click(775, 180) ;��������� ���� ������

EndFunc   ;==>_Select30x30

Func _F5_Reload()

;~    ControlSend ($hwnd, '','','{F5}')
	Sleep(5000)
	While 1
		$CheckColor = Hex(PixelGetColor(255 + 2, 83 + 77, $hWnD), 6)
		If $CheckColor = '9ACACC' Or $CheckColor = '4D6667' Then
			If $CheckColor = '4D6667' Then
				_CloseClick()
				Sleep(500)
			EndIf
			_Click(880, 150)
			Sleep(1000)
			ExitLoop
		EndIf

		If GUICtrlRead($CheckBox1) = 1 Then TrayTip('', '������ ��������� � ������ ', 100)
		Sleep(500)
	WEnd

EndFunc   ;==>_F5_Reload















Func _DetectWindow_and_start2()
	$nstart = 0 ;�������

	;��������� ������� �������� �������� ����
	$hWnD = WinGetHandle("[ACTIVE]")
	$sControl = ControlGetFocus($hWnD)
	$aPos = ControlGetPos($hWnD, "", $sControl)
	$winx = $aPos[2]
	$winy = $aPos[3]

	;����������� ������ ���� � ������ �������� ���������� x
	Dim $coord[2]
	$Xcoordinat_detected_YES = 0
	$xcor = 0
	$getcolor = 0
	$coord = PixelSearch(140, 125, 700, 156, 0xF2F2F2, 1, 1, $hWnD)
	If Not @error Then $getcolor = Hex(PixelGetColor($coord[0] + 1, $coord[1], $hWnD), 6)
	If Not @error And $getcolor = "D9E0E7" Then
		$Xcoordinat_detected_YES = 1
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", '���������� � ���������� "X" ������� ������������ ' & $Xcoordinat_detected_YES, 100)
		$xcor = $coord[0] - 150

	Else
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "���������� � ����������� �� ������������ :(", 100)
		$xcor = 0
	EndIf

	;����������� ������ ���� � ������ �������� ���������� Y
	Dim $coord2[2]
	$ycor = 0
	$getcolor = 0
	$coord2 = PixelSearch($winx / 2, 0, ($winx / 2) + 1, $winy, 0xDAE1E8, 1, 1, $hWnD)
	If Not @error Then $getcolor = Hex(PixelGetColor($coord2[0], $coord2[1] + 1, $hWnD), 6)
	If Not @error And $getcolor = "F7F7F7" Then
		If $Xcoordinat_detected_YES = 1 Then
			$ycor = $coord2[1] - 147
			If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", '���������� � ���������� "X" ������� ������������ = ' & $xcor & @CR & '���������� � ���������� "Y" ������� ������������ = ' & $ycor, 1000)
		Else
			If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", '���������� � ���������� "Y" ������� ������������', 1000)
		EndIf
	Else
		If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", "���������� � ���������� Y �� ������������ :(", 1000)
		$ycor = 0
	EndIf

	Sleep($testdelay)

	;���������� ������ ������ � ��������� ���
	Global $cx_attack1x1 = 482, $cy_attack1x1 = 313

	$q2 = 25

	For $i = 1 To $q2
		Sleep($menudelay) ;500
		$y = 0
		While $y = 0

			;����� � ������ � ���� 1�1 ��� �������� ���������� ���
;~ 	  _pause_battle()

			$mousePos = MouseGetPos()
			MouseMove(480 + $xcor, 320 + 77 + $ycor, 0)
			_Click($cx_attack1x1 + Random(-15, 15, 1), $cy_attack1x1 + Random(-15, 15, 1))
			Sleep(15)
			MouseMove($mousePos[0], $mousePos[1], 0)
			Sleep($menudelay) ;700

			$getcolor_attack = Hex(PixelGetColor(358 + $xcor, 442 + 77 + $ycor, $hWnD), 6)
			If $getcolor_attack = 'A7A7A7' Then $y = 1
			If GUICtrlRead($CheckBox1) = 1 Then TrayTip("���������", $y, 100)

		WEnd

		_fight()

	Next

EndFunc   ;==>_DetectWindow_and_start2


















Func _RandomEx($_iSNum = 0, $_iENum = 1, $_iUnique = 1, $_iRNumCount = 0, $_iRetFormat = 0, $_sRetDelimiter = ",")
	Local $sRNumStr = "`", $iNumCount = 0

	If $_iSNum >= $_iENum Then Return SetError(1, 0, 0)
	If $_iUnique And ($_iENum - $_iSNum + 1) < $_iRNumCount Then Return SetError(2, 0, 0)

	If $_iRNumCount = 0 Then $_iRNumCount = $_iENum - $_iSNum + 1

	While $iNumCount <> $_iRNumCount
		$iRNum = Random($_iSNum, $_iENum, 1)

		If $_iUnique = 1 Then
			If IsDeclared("<" & $iRNum & ">") Then ContinueLoop

			Assign("<" & $iRNum & ">", "", 1)

			$sRNumStr &= $iRNum & "`"

			$iNumCount += 1
		Else
			$sRNumStr &= $iRNum & "`"

			$iNumCount += 1
		EndIf
	WEnd
	$sRNumStr = StringTrimLeft(StringTrimRight($sRNumStr, 1), 1)

	If $_iRetFormat = 0 Then Return StringReplace($sRNumStr, "`", $_sRetDelimiter)
	If $_iRetFormat = 1 Then Return StringSplit($sRNumStr, "`")
EndFunc   ;==>_RandomEx