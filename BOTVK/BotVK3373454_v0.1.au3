#include <WinAPI.au3>
#Include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <Icons.au3>
#Region
#AutoIt3Wrapper_Res_File_Add="primer.bmp", 2, 200
#EndRegion

opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 2)

global $hWnD, $sControl, $xcor, $ycor,$nstart,$sleepclick, $loc, $CheckBox1, $Paused
global $wait_for_battle=1 ;����� � ������ � ���� 1�1 ��� �������� ���������� ���
global $testdelay=0, $sleepclick=1000, $menudelay=1000

#Region ### Coords
    ;���������� ����� � ���
	global $cx_attack=360, $cy_attack=470
	;���������� ������������� ��������� � ���
	global $cx_helper=700, $cy_helper=470
	;���������� ����� �� ������� ������ �������
	global $cx_loc[10][6+1], $cy_loc[10][6+1]
	$cx_loc[1][1]=665
	$cy_loc[1][1]=100
	$cx_loc[1][2]=370
	$cy_loc[1][2]=300
	$cx_loc[1][3]=630
	$cy_loc[1][3]=370
	$cx_loc[1][4]=440
	$cy_loc[1][4]=525
	$cx_loc[1][5]=650
	$cy_loc[1][5]=570
	$cx_loc[1][6]=270
	$cy_loc[1][6]=650
	;���������� ����� �� ������� �������� �����
	$cx_loc[2][1]=500
	$cy_loc[2][1]=120
	$cx_loc[2][2]=759
	$cy_loc[2][2]=135
	$cx_loc[2][3]=817
	$cy_loc[2][3]=355
	$cx_loc[2][4]=407
	$cy_loc[2][4]=290
	$cx_loc[2][5]=750
	$cy_loc[2][5]=520
	$cx_loc[2][6]=400
	$cy_loc[2][6]=690
	;���������� ����� �� ������� 3 ��������
	$cx_loc[3][1]=790
	$cy_loc[3][1]=165
	$cx_loc[3][2]=660
	$cy_loc[3][2]=340
	$cx_loc[3][3]=430
	$cy_loc[3][3]=405
	$cx_loc[3][4]=193
	$cy_loc[3][4]=430
	$cx_loc[3][5]=773
	$cy_loc[3][5]=550
	$cx_loc[3][6]=320
	$cy_loc[3][6]=695
#EndRegion ### Coords

HotKeySet("{ScrollLock}", "Terminate")
Func Terminate()
   if Guictrlread($CheckBox1)=1 then Traytip ("���������","��������� �������, ����� �������� :)",1500)
   sleep (1000)
    Exit 0
EndFunc

HotKeySet("{F1}", "_DetectWindow_and_start") ;�������� ���� �� ������ �������
HotKeySet("{F2}", "_DetectWindow_and_start") ;�������� ���� �� ������ �������
HotKeySet("{F3}", "_local_detect") ;������ � ��������� ���
HotKeySet("{F4}", "_pause") ;������ � ��������� ���
HotKeySet("{F6}", "_DetectWindow_and_start2")


Func _Pause()
    $Paused = Not $Paused
	$trayP=0
    While $Paused
		$trayP+=1
        Sleep(100)
        if $trayP=1 and Guictrlread($CheckBox1)=1 then Traytip ("���������","�����",1000)
    WEnd
    ToolTip("")
EndFunc


;����������� ��������� ������������
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=e:\vitaliy\programs\autoitv3.3.8.1\form1_3.kxf
$Form1_2 = GUICreate("��� �� ������� ���� � ��", 362, 453, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
$sleepclick = GUICtrlCreateInput("1000", 232, 320, 121, 21)
$Label3 = GUICtrlCreateLabel("������� �������� ����� ������� � ��.", 8, 320, 210, 17)
$Bossnumber = GUICtrlCreateCombo("�������", 208, 352, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "���������|������")
$Label4 = GUICtrlCreateLabel("�������� ����� ��� ���������� ���", 8, 352, 190, 17)
$WorkEnergynumber = GUICtrlCreateCombo("�������", 208, 384, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "�� ������������")
$Label5 = GUICtrlCreateLabel("����� ��� ������������� �������", 8, 384, 182, 17)
$Button1 = GUICtrlCreateButton("�����", 143, 416, 105, 25)
GUICtrlSetOnEvent(-1, "_Pro_Exit")
$Checkbox1 = GUICtrlCreateCheckbox("���������� ����������� ���������?", 8, 296, 241, 17)
GUICtrlSetState(-1, $GUI_CHECKED)
GUICtrlCreateEdit("", 8, 8, 329, 193, BitOR($ES_AUTOVSCROLL,$ES_AUTOHSCROLL,$ES_READONLY))
GUICtrlSetData(-1, StringFormat("�������� ���������� � ��������� ���� (�� ����������), \r\n��������� �� ������ ������� � ������� ������� "&Chr(34)&"F2"&Chr(34)&"\r\n��� ���� �� ������ ������ ��������.\r\n�� ������ ������ ��� ��������� ��������� �������:\r\n1. ��� � ������������ �� 1 � 2 ������� ���������, �����\r\n� ���� ���������\r\n2. �������� ������� � ��������� ���� � ���������� �� �����\r\n3. ��������� ������ ��������� �������\r\n"&Chr(34)&"F3"&Chr(34)&" - ������� � ��������� �� ����� �� �������\r\n"&Chr(34)&"F4"&Chr(34)&" - �����, ��� ����������� ����� ������� "&Chr(34)&"F4"&Chr(34)&"\r\n"&Chr(34)&"F6"&Chr(34)&" - ��� �������� ��������� ���� ����� ������ � ���\r\n\r\n���� ������ �������� ������ ����, �� ������� ��� ���, �����\r\n������� ���� ���������� ��� �����"))
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###



;~ $Pic2 = GUICtrlCreatePic("C:\TEMP\autoitv3.3.8.1\primer.bmp", 8, 160, 204, 82)
$Pic = GUICtrlCreatePic("", 8, 165+24+16, 204, 82)
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

;����� �� ���� �� ������� ������ �����
Func _Pro_Exit()
    Exit
EndFunc

;������� ����������� ����, ��� ���������� �� ������
Func _whats_wrong()

   		 $B_Close_Wrong = 0
		 $B_Close_Wrong = PixelSearch ( 490+$xcor, 340+77+$ycor, 545+$xcor, 350+77+$ycor, 0x6EAD55,1,1, $hWnd )
	  if $B_Close_Wrong<>0 then _Click($B_Close_Wrong[0]-$xcor, $B_Close_Wrong[1]-77-$ycor)
		 if $B_Close_Wrong<>0 then _F5_Reload()


EndFunc

;������� ������ �� ���������� ����������� ControlClick
Func _Click($cx, $cy,$mod=0)
	;��������� ��������
if $mod=0 Then ;$cx<>360 or
	$sleepD=random(GUICtrlRead($sleepclick),GUICtrlRead($sleepclick)*1.5,1)
   sleep($sleepD)
Else
	$sleepH=random(0,10,1)
   sleep($sleepH)
endif

;~ ControlFocus ( $hWnD, "", '' )

;~ 			$mousePos = MouseGetPos()

;~ 			MouseMove ( $cx+$xcor, $cy+77+$ycor ,0 )

   ControlClick ($hWnD, '',$sControl, "left", 1, $cx+$xcor+random(-4,4,1), $cy+$ycor+random(-4,4,1))

;~ 			 MouseMove ( $mousePos[0], $mousePos[1] ,0 )

EndFunc

;������� ���������� ������ � ���� �� �������
func _CloseClick()

   		 $B_Close_Wrong2 = 0
		 $B_Close_Wrong2 = PixelSearch ( 0, 0, 920, 790, 0xFF7425,0,1, $hWnd )
		 if not @error then
			$getcol1=Hex (PixelGetColor ($B_Close_Wrong2[0],$B_Close_Wrong2[1]+1,$hwnd),6)
			$getcol2=Hex (PixelGetColor ($B_Close_Wrong2[0],$B_Close_Wrong2[1]+2,$hwnd),6)
			if $getcol1='FF7425' and $getcol2='FF7425' then _Click($B_Close_Wrong2[0]+6, $B_Close_Wrong2[1]+6-77)
		 EndIf

EndFunc

;����������� ������� �������� � ������ ������
func _local_detect($Targetloc=0)
   ;����������� �������
dim $locLD
;~    $loc=2
sleep(1500) ;�������� �� ������ �������� �������
$noloc=0
$noloc=$loc
   $getcolorL=Hex(PixelGetColor ( 776+$xcor+5 , 133+77+$ycor , $hWnd ), 6)
   if $getcolorL='615B4D' then $locLD=1
   if $getcolorL='171C08' then $locLD=2
   if $getcolorL='221914' then $locLD=3
	  global $loc=$locLD
	     if $nstart=0 then
			if @HotKeyPressed="{F1}" then $loc=1
			if @HotKeyPressed="{F2}" then $loc=2
			$nstart=1
		 endif
 if $loc=0 then $loc=$noloc ;����������� � ����������� ��������� ������� �� ������ ������

	if Guictrlread($CheckBox1)=1 then Traytip ("���������",'�� �� ' & $loc & '-� �������', 100)
	sleep(2000) ;�������
	Sleep($testdelay)
return $loc
endfunc


;����������� ���� � ����� � ������ ������ ��� �� �������
Func _DetectWindow_and_start()
   $nstart=0 ;�������

   ;��������� ������� �������� �������� ����
   $hWnd = WinGetHandle("[ACTIVE]")
    $sControl = ControlGetFocus($hWnd)
    $aPos = ControlGetPos($hWnd, "", $sControl)
   $winx=$aPos[2]
   $winy=$aPos[3]

   ;����������� ������ ���� � ������ �������� ���������� x
   dim $coord[2]
   $Xcoordinat_detected_YES=0
   $xcor=0
$getcolor=0
$coord = PixelSearch ( 140, 125, 700, 156, 0xF2F2F2,1,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord[0]+1 , $coord[1] , $hWnd ), 6)
if Not @error and $getcolor="D9E0E7" then
$Xcoordinat_detected_YES=1
   if Guictrlread($CheckBox1)=1 then Traytip ("���������",'���������� � ���������� "X" ������� ������������ '& $Xcoordinat_detected_YES, 100)
   $xcor=$coord[0]-150

Else
   if Guictrlread($CheckBox1)=1 then Traytip ("���������","���������� � ����������� �� ������������ :(", 100)
   $xcor=0
endif

   ;����������� ������ ���� � ������ �������� ���������� Y
   dim $coord2[2]
   $ycor=0
$getcolor=0
$coord2 = PixelSearch ( $winx/2, 0, ($winx/2)+1, $winy, 0xDAE1E8,1,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord2[0] , $coord2[1]+1 , $hWnd ), 6)
if Not @error and $getcolor="F7F7F7" then
   if $Xcoordinat_detected_YES=1 then
	   $ycor=$coord2[1]-147
	  if Guictrlread($CheckBox1)=1 then Traytip ("���������",'���������� � ���������� "X" ������� ������������ = ' &$xcor& @CR &'���������� � ���������� "Y" ������� ������������ = ' &$ycor, 1000)
	  Else
	  if Guictrlread($CheckBox1)=1 then Traytip ("���������",'���������� � ���������� "Y" ������� ������������', 1000)
	  endif
Else
   if Guictrlread($CheckBox1)=1 then Traytip ("���������","���������� � ���������� Y �� ������������ :(", 1000)
   $ycor=0
EndIf

sleep($testdelay)


global $Q=12000
   _local_detect()
_thinks_loc()


EndFunc   ;==>doit


;��� � ������������ �� ������� ���������, ����� � ���� ���������
func _thinks_loc()

   if Guictrlread($CheckBox1)=1 then Traytip('','������� � ������ ����� '&$loc,1000)
Sleep($testdelay)

for $thin=1 to $Q
$aRandom = _RandomEx(1, 6, 1, 6, 1)
_CloseClick() ;�� ������ ������

   for $i=1 to 6

	  if Guictrlread($CheckBox1)=1 then Traytip ("���������","� ��� ����", 100);�������
	  _local_detect()
	  _pause_battle() ;����� � ������ � ���� 1�1 ��� �������� ���������� ���
	  _whats_wrong()

	  $t=$aRandom[$i]
	  _Click($cx_loc[$loc][$t], $cy_loc[$loc][$t])
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 444+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then $i=6 ;������ ��� �����!!!!!!!������ ��� �����!!!!!!!������ ��� �����!!!!!!!
		 ;��������� ��������� � ������
		 $B_Close = 0
		 $B_Close = PixelSearch ( 460+$xcor, 560+77+$ycor, 470+$xcor, 570+77+$ycor, 0x6EAD55,1,1, $hWnd )
	  if $B_Close<>0 then _Click($B_Close[0]-$xcor, $B_Close[1]-77-$ycor)
		 ;������� ��� �� ��� � ��������� �� ���
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()
;~ 		 MsgBox(0, '���������', ' �� � ��� ' & $getcolor_attack) ;�������
						;������� ����������� ������ �����
;~ 						$iDiff = TimerDiff($hTimer) ;$hTimer = TimerInit()
;~ 						if $iDiff<15000 then
;~ 						   $Q=1
;~ 						else
;~ 						   exit ; ��������� ������ ����
;~ 						endif
	  next
next

EndFunc

;������� ���
func _fight()
   if Guictrlread($CheckBox1)=1 then Traytip ("���������","� � ���!", 100) ;�������
   $hTimer_f = TimerInit() ;����� ������� �� ������ ������ � "������� ���"


;~    _Click($cx_helper, $cy_helper,1)
;~    sleep(10)
;~    _Click($cx_helper, $cy_helper,1)
;~    sleep(10)
   _Click($cx_helper, $cy_helper,1)
   sleep(10)
   _Click($cx_attack, $cy_attack)
   	sleep(200)

	if TimerDiff($hTimer_f) > 600000 then return ;����� ������� �� ������ ������ � "������� ���"

			 ;��������� ��������� � ������
		 $B_Close = 0
		 $B_Close = PixelSearch ( 460+$xcor, 560+77+$ycor, 470+$xcor, 570+77+$ycor, 0x6EAD55,10,1, $hWnd )
	  if $B_Close=0 then
		 _fight()
		 else
		 _Click($B_Close[0]-$xcor, $B_Close[1]-77-$ycor)
		 sleep(500)
		 _Click($B_Close[0]-$xcor+10, $B_Close[1]-77-$ycor+10) ;������ ���� �� ������ �� ������������ (������)
		 if Guictrlread($CheckBox1)=1 then Traytip ("���������","����� �� ���", 100);�������
;~ 		 _thinks_loc($loc)
	  EndIf


endfunc


;����� � ������ � ���� 1�1 ��� �������� ���������� ���
func _pause_battle()
				  $testdelay=0
   			   if Guictrlread($CheckBox1)=1 then Traytip('','������� ����� � ���, ������: '&@MIN,100)
				  sleep($testdelay)
;~ 	  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=15 or @MIN=00 or @MIN=30 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then _fight_detect()
		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then
;~ 		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then
			   if Guictrlread($CheckBox1)=1 then Traytip('','������� ����� � ���, �������: '&$loc&"   ����� �������� �����������   ",100)
				  sleep($testdelay)
			 _fight_detect()
		  Else
			 				if Guictrlread($CheckBox1)=1 then Traytip('','������� ����� � ���, �������: '&$loc&"  ��� ����� ����� �������   ",100)
							sleep($testdelay)
;~ 				If @MIN>=45 and @MIN<=57 or @MIN>=20 and @MIN<=27 then
			    If  @MIN>=20 and @MIN<=27 or @MIN>=45 and @MIN<=57 then
					 if $loc=1 then return
					  if $loc=2 then
						 _Change_loc(1)
						if Guictrlread($CheckBox1)=1 then Traytip('','������� ����� � ���, �������: '&$loc&"   �������� ������� �� ������   ",100)
						sleep($testdelay)
						_thinks_loc()

						Else
						if Guictrlread($CheckBox1)=1 then Traytip('','������� ����� � ���, �������: '&$loc&"   �����   ",100)
						sleep($testdelay)
						return
						endif
				Else
				EndIf
				;if Guictrlread($CheckBox1)=1 then Traytip('','������� ����� � ���, �������: '&$loc&"  ������ � �� �����(((   ",100)
						sleep($testdelay)
		  EndIf

EndFunc


;����� �������
Func _Change_loc($location)
;~    global $loc=$location

   _Click(882, 299) ;�������� �� ����� ��� ����� �������
	  sleep (1000)
	  if $location=1 then
		 _Click(556, 349) ;������ �������
		 global $loc=1
	  EndIf
	  if $location=2 then
		 _Click(740, 326) ;������ �������
		  global $loc=2
	  EndIf
	  if $location=3 then
		 _Click(470, 420) ;������ �������
		  global $loc=2
	  EndIf
	  sleep (1000)

endfunc

;������� �������� ���������� ��� � �������� ������ �� ����� �����
func _fight_detect()

   $hTimer_fd = TimerInit() ;����� ������� �� ������ ������ � "������� ���"

for $fight_detect=0 to 1
   _Change_loc(2)
      if Guictrlread($CheckBox1)=1 then Traytip ("���������","������ ���������� ���", 100) ;�������
   sleep($menudelay)

   	  ;������� ��� �� ��� � ��������� �� ���
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()

   ;�������� ���
   if @MIN=59 or @MIN=58 or @MIN=29 or @MIN=28 then
;~    if @MIN=59 or @MIN=00 or @MIN=29 or @MIN=30 then
		$BossN = GUICtrlSendMsg($Bossnumber, $CB_GETCURSEL, 0, 0)
 		 if $BossN=2 then _Click(614, 145) ;����� ���������
 		 if $BossN=1 then _Click(745, 610) ;����� ���������
		 if $BossN=0 then _Click(315, 350) ;����� �������

	  ;������������ ����� ���
	   sleep($menudelay)
	  _Click(655, 420) ; ������ � ���
	  if Guictrlread($CheckBox1)=1 then Traytip ("���������","��� ������", 100);�������
	  sleep ($menudelay)
	  _Click(604, 310) ;���� � ���� ���
	  sleep ($menudelay)
	  _Click(755, 180) ;��������� ���� ������

      	  ;������� ��� �� ��� � ��������� �� ���
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()

	  ; �������� ��������� �������
	  $workE = GUICtrlSendMsg($WorkEnergynumber, $CB_GETCURSEL, 0, 0)
	if $workE<>1 then
		  sleep ($menudelay)
		  _Click(305, 165) ;����� �������
		  sleep ($menudelay)
		  ;������������ ������ ������, ���� ������� ���� ������ ������
		  for $i=0 to 63
			 $coord = PixelSearch( 575+$xcor, 310+77+$ycor, 580+$xcor, 700+77+$ycor, 0x6EAD55, 5 )
			 If Not @error Then
				 _Click($coord[0]-$xcor, $coord[1]-77-$ycor)
				 sleep(600) ;����� ����� ������� �� ������ ��������� �������
			  Else
				;��������� ��������� � ��������
				_Click(800, 190) ;������� �� ����������� ������� �������
				sleep($menudelay)
				_Click(782, 111) ;������� �� ���� ������

				;!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				$B_Close = 0
				$B_Close = PixelSearch ( 520+$xcor, 420+77+$ycor, 525+$xcor, 700+77+$ycor, 0x6EAD55,1,1, $hWnd )
			 if $B_Close<>0 then _Click($B_Close[0]-$xcor, $B_Close[1]-77-$ycor)
				 ExitLoop
			 EndIf


	  ;������� ��� �� ��� � ��������� �� ���
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()
		Next
  EndIf

;~ 	  for $i=0 to 2 ;������������ ����� ��� ;�������� ������ ���������� ������;�������� ������ ���������� ������;�������� ������ ���������� ������;�������� ������ ���������� ������
;~ 		 $B_Select = 0
;~ 		 $B_Select = PixelSearch ( 565, 400+77+$ycor, 720, 415+77+$ycor, 0x6EAD55,10,1, $hWnd )
;~ 		 if $B_Select=0 then
;~ 			$i=0
;~ 			else
;~ 			_Click($B_Select[0]-$xcor, $B_Select[1]-77-$ycor)
;~ 			if Guictrlread($CheckBox1)=1 then Traytip ("���������","��� ������", 100);�������
;~ 			$i=2
;~ 			sleep (1000)
;~ 			_Click(604, 310) ;���� � ���� ���
;~ 			sleep (1000)
;~ 			_Click(755, 180) ;��������� ���� ������
;~ 		 EndIf
;~ 	  next
   Else
		 if @MIN=14 or @MIN=13 Then
		 _Click(800, 190) ;����� ��� 30�30 �� ������ �������

			;������������ ����� ���
		  sleep(1000)
		 _Click(410, 565) ; ������ � ��� 30�30
		 if Guictrlread($CheckBox1)=1 then Traytip ("���������","��� ������", 100);�������
		 sleep (1000)
		 _Click(604, 310) ;���� � ���� ���
		 sleep (1000)
		 _Click(775, 180) ;��������� ���� ������

;~ 	  	  for $i=0 to 2 ;������������ ����� ���
;~ 		 $B_Select = 0
;~ 		 $B_Select = PixelSearch ( 325, 550+77+$ycor, 495, 565+77+$ycor, 0x6EAD55,10,1, $hWnd )
;~ 			if $B_Select=0 then
;~ 			   $i=0
;~ 			   else
;~ 			   _Click($B_Select[0]-$xcor, $B_Select[1]-77-$ycor)
;~ 			   if Guictrlread($CheckBox1)=1 then Traytip ("���������","��� ������", 100);�������
;~ 			   $i=2
;~ 			   sleep (1000)
;~ 			   _Click(605, 310) ;���� � ���� ���
;~ 			   sleep (1000)
;~ 			   _Click(775, 180) ;��������� ���� ������
;~ 			EndIf
;~ 		  next
		 Else
			_thinks_loc()
		 endif
	  ;������� ��� �� ��� � ��������� �� ���
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()


   EndIf

	;������� ��� �� ��� � ��������� �� ���
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()
next

   while 1
;������� ��� �� ��� � ��������� �� ���
$getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
if $getcolor_attack='A7A7A7' then _fight()
if TimerDiff($hTimer_fd) > 180000 then return ;����� ������� �� ������ ������ � "������� ���"
wend
endfunc


func _F5_Reload()

;~    ControlSend ($hwnd, '','','{F5}')
   sleep(5000)
   while 1
   $CheckColor = Hex( PixelGetColor (255+2,83+77,$hwnd), 6)
	  if $CheckColor = '9ACACC' or $CheckColor = '4D6667' then
			   if $CheckColor = '4D6667' then
				  _CloseClick()
				  sleep(500)
			   endif
		 _Click(880,150)
		 sleep(1000)
		 ExitLoop
	  endif

	  if Guictrlread($CheckBox1)=1 then Traytip('','������ ��������� � ������ ',100)
	  sleep(500)
   wend

EndFunc















Func _DetectWindow_and_start2()
   $nstart=0 ;�������

   ;��������� ������� �������� �������� ����
   $hWnd = WinGetHandle("[ACTIVE]")
    $sControl = ControlGetFocus($hWnd)
    $aPos = ControlGetPos($hWnd, "", $sControl)
   $winx=$aPos[2]
   $winy=$aPos[3]

   ;����������� ������ ���� � ������ �������� ���������� x
   dim $coord[2]
   $Xcoordinat_detected_YES=0
   $xcor=0
$getcolor=0
$coord = PixelSearch ( 140, 125, 700, 156, 0xF2F2F2,1,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord[0]+1 , $coord[1] , $hWnd ), 6)
if Not @error and $getcolor="D9E0E7" then
$Xcoordinat_detected_YES=1
   if Guictrlread($CheckBox1)=1 then Traytip ("���������",'���������� � ���������� "X" ������� ������������ '& $Xcoordinat_detected_YES, 100)
   $xcor=$coord[0]-150

Else
   if Guictrlread($CheckBox1)=1 then Traytip ("���������","���������� � ����������� �� ������������ :(", 100)
   $xcor=0
endif

   ;����������� ������ ���� � ������ �������� ���������� Y
   dim $coord2[2]
   $ycor=0
$getcolor=0
$coord2 = PixelSearch ( $winx/2, 0, ($winx/2)+1, $winy, 0xDAE1E8,1,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord2[0] , $coord2[1]+1 , $hWnd ), 6)
if Not @error and $getcolor="F7F7F7" then
   if $Xcoordinat_detected_YES=1 then
	   $ycor=$coord2[1]-147
	  if Guictrlread($CheckBox1)=1 then Traytip ("���������",'���������� � ���������� "X" ������� ������������ = ' &$xcor& @CR &'���������� � ���������� "Y" ������� ������������ = ' &$ycor, 1000)
	  Else
	  if Guictrlread($CheckBox1)=1 then Traytip ("���������",'���������� � ���������� "Y" ������� ������������', 1000)
	  endif
Else
   if Guictrlread($CheckBox1)=1 then Traytip ("���������","���������� � ���������� Y �� ������������ :(", 1000)
   $ycor=0
EndIf

sleep($testdelay)

    ;���������� ������ ������ � ��������� ���
	global $cx_attack1x1=482, $cy_attack1x1=313

$q2=25

for $i=1 to $q2
   sleep($menudelay) ;500
$y=0
   while $y=0

	  ;����� � ������ � ���� 1�1 ��� �������� ���������� ���
	  _pause_battle()

	  $mousePos = MouseGetPos()
	  MouseMove ( 480+$xcor, 320+77+$ycor ,0 )
	  _Click($cx_attack1x1+Random(-15,15,1), $cy_attack1x1+Random(-15,15,1))
	  sleep(15)
	  MouseMove ( $mousePos[0], $mousePos[1] ,0 )
	   sleep($menudelay) ;700

   $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
		 if $getcolor_attack='A7A7A7' then $y=1
			if Guictrlread($CheckBox1)=1 then Traytip ("���������",$y,100)

	wend

_fight()

next

EndFunc   ;==>doit2


















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
EndFunc