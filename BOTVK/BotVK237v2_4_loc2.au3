#include <WinAPI.au3>
#Include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <Icons.au3>
#Region
#AutoIt3Wrapper_Res_File_Add="CrashXP.bmp", 2, 200
#EndRegion

opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0)
Opt("MouseCoordMode", 2)

global $hWnD, $sControl, $xcor, $ycor,$nstart,$sleepclick, $loc
global $wait_for_battle=1 ;����� � ������ � ���� 1�1 ��� �������� ���������� ���
$sleepclick=1000
;~ AutoItSetOption("WinTitleMatchMode",1)
;~ $Title = '��������� 2013 - ������� ����' ; The Name Of The Game...
;~ $Full = WinGetTitle ($Title) ; Get The Full Title..
;~ $HWnD = WinGetHandle ($Full) ; Get The Handle

HotKeySet("{ScrollLock}", "Terminate")
Func Terminate()
   TrayTip ("���������","��������� �������, ����� �������� :)",1500)
   sleep (1000)
    Exit 0
EndFunc

HotKeySet("{F1}", "_doit") ;�������� ���� �� ������ �������
HotKeySet("{F2}", "_doit") ;�������� ���� �� ������ �������
HotKeySet("{F3}", "_F5_Reload") ;������ � ��������� ���
HotKeySet("{F4}", "pause") ;������ � ��������� ���

Func pause()
While 1
   TrayTip ("���������","�����",100)
    Sleep(10000)
WEnd
EndFunc   ;==>pause


Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=C:\TEMP\autoitv3.3.8.1\Form1_2.kxf
$Form1_2 = GUICreate("��� �� ������� ���� � ��", 413, 395, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
$sleepclick = GUICtrlCreateInput("1000", 280, 264, 121, 21)
$Label1 = GUICtrlCreateLabel("���� ������ �������� ������ ���� �� ������� ��� ���, �����", 8, 128, 319, 17)
$Label2 = GUICtrlCreateLabel("��������� �� ������ ������� � ������� ������� �F2�", 8, 24, 288, 17)
$Label3 = GUICtrlCreateLabel("������� �������� ����� ������� � (��)", 8, 264, 213, 17)
$Bossnumber = GUICtrlCreateCombo("�������", 256, 296, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "���������|������")
$Label4 = GUICtrlCreateLabel("�������� ����� ��� ���������� ���", 8, 296, 190, 17)
$WorkEnergynumber = GUICtrlCreateCombo("�������", 256, 328, 145, 25, BitOR($CBS_DROPDOWN,$CBS_AUTOHSCROLL))
GUICtrlSetData(-1, "�� ������������")
$Label5 = GUICtrlCreateLabel("����� ��� ������������� �������", 8, 328, 182, 17)
$Label6 = GUICtrlCreateLabel("������� ���� ���������� ��� �����", 8, 144, 191, 17)
$Label7 = GUICtrlCreateLabel("�������� ���������� � ��������� ���� (�� ����������),", 8, 8, 304, 17)
$Label8 = GUICtrlCreateLabel("�� ������ ������ ��� ��������� ��������� �������:", 8, 56, 289, 17)
GUICtrlSetFont(-1, 8, 400, 4, "MS Sans Serif")
$Label9 = GUICtrlCreateLabel("1.��� � ������������ �� 1 � 2 ������� ���������, ����� � ���� ���������", 8, 72, 399, 17)
$Label10 = GUICtrlCreateLabel("2.�������� ������� � ��������� ���� � ��������� �� ������", 8, 88, 315, 17)
$Label11 = GUICtrlCreateLabel("3.���������� ������ ��������� �������", 8, 104, 218, 17)
$Label12 = GUICtrlCreateLabel("��� ���� �� ������ ������ ��������.", 8, 40, 198, 17)
$Button1 = GUICtrlCreateButton("�����", 143, 360, 105, 25)
GUICtrlSetOnEvent(-1, "_Pro_Exit")

$Pic2 = GUICtrlCreatePic("C:\TEMP\autoitv3.3.8.1\primer.bmp", 8, 160, 204, 82)
$Pic = GUICtrlCreatePic("", 8, 160, 204, 82)
$hInstance = _WinAPI_GetModuleHandle(0)
$hBitmap = _WinAPI_LoadBitmap($hInstance, 200)
_SetHImage($Pic, $hBitmap)
_WinAPI_DeleteObject($hBitmap)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit

	EndSwitch
WEnd

Func _Pro_Exit()
    Exit
EndFunc


Func _whats_wrong()

   		 $B_Close_Wrong = 0
		 $B_Close_Wrong = PixelSearch ( 490+$xcor, 340+77+$ycor, 545+$xcor, 350+77+$ycor, 0x6EAD55,1,1, $hWnd )
	  if $B_Close_Wrong<>0 then _Click($B_Close_Wrong[0]-$xcor, $B_Close_Wrong[1]-77-$ycor)
		 if $B_Close_Wrong<>0 then _F5_Reload()


EndFunc


Func _Click($cx, $cy)
;~    if $cx<$centerx*2 AND $cy<$centery*2 and $cx>0 and $cy>0 then

;~    Mousemove($cx, $cy+77+$ycor)
if $cx<>360 or $cx<>482 Then
   sleep(random($sleepclick,$sleepclick*1.5,1))
Else
   sleep(random(0,10,1))
endif

;~ ControlFocus ( $hWnD, "", '' )
;~ 			$mousePos = MouseGetPos()
;~ 			MouseMove ( $cx+$xcor, $cy+77+$ycor ,0 )
;~ sleep(64)
   ControlClick ($hWnD, '',$sControl, "left", 1, $cx+$xcor+random(-4,4,1), $cy+$ycor+random(-4,4,1))
;~       ControlClick ($hWnD, '','', "left", 1, $cx+random(-4,4,1), $cy+random(-4,4,1))

;~ 			 MouseMove ( $mousePos[0], $mousePos[1] ,0 )\
;~ ;traytip('','������� '&$loc,1000)
;~ Sleep(500)
;~ ;traytip('','X: '&$cx+$xcor+random(-4,4,1)&'   Y: '&$cy+$ycor+random(-4,4,1),1000)
;~ Sleep(1000)

;~    Else
;~    EndIf
EndFunc

func _CloseClick()

   		 $B_Close_Wrong2 = 0
		 $B_Close_Wrong2 = PixelSearch ( 0, 0, 920, 790, 0xFF7425,0,1, $hWnd )
		 if not @error then
			$getcol1=Hex (PixelGetColor ($B_Close_Wrong2[0],$B_Close_Wrong2[1]+1,$hwnd),6)
			$getcol2=Hex (PixelGetColor ($B_Close_Wrong2[0],$B_Close_Wrong2[1]+2,$hwnd),6)
			if $getcol1='FF7425' and $getcol2='FF7425' then _Click($B_Close_Wrong2[0]+6, $B_Close_Wrong2[1]+6-77)
		 EndIf

EndFunc

func _local_detect($Targetloc=0)
   ;����������� �������
dim $locLD
;~    $loc=2
sleep(1500)
$noloc=0
$noloc=$loc
   $getcolorL=Hex(PixelGetColor ( 776+$xcor+5 , 133+77+$ycor , $hWnd ), 6)
   if $getcolorL='615B4D' then $locLD=1
   if $getcolorL='171C08' then $locLD=2
	  global $loc=$locLD
;~    if $Targetloc=0 then
;~ 	  if $loc=0 then $loc=$noloc ;����������� � ����������� ��������� ������� �� ������ ������
;~ 	  Return $loc
;~    Else
;~ 	  if $Targetloc=1 then _Change_loc(1)
;~ 	  if $Targetloc=2 then _Change_loc(2)
;~ 	  endif
	  ;traytip('','������� � ������� ����� ������ '&$loc,1000)
	     if $nstart=0 then
			if @HotKeyPressed="{F1}" then $loc=1
			if @HotKeyPressed="{F2}" then $loc=2
			$nstart=1
		 endif
 if $loc=0 then $loc=$noloc ;����������� � ����������� ��������� ������� �� ������ ������

	TrayTip ("���������",'�� �� ' & $loc & '-� �������', 100)
	Sleep(1500)
return $loc
endfunc



Func _doit()
   $nstart=0

;~ 	   msgbox(0,'',$getcolorL)
;~ 	  msgbox(0,'',$loc)



   ;��������� ������� �������� �������� ����
   $hWnd = WinGetHandle("[ACTIVE]")
    $sControl = ControlGetFocus($hWnd)
    $aPos = ControlGetPos($hWnd, "", $sControl)
;~     $aPos = ControlGetPos($hWnd, "", "")
   $winx=$aPos[2]
   $winy=$aPos[3]

   $x1=0
   $y1=0

   ;����������� ������ ���� � ������ �������� ���������� x
   dim $coord[2]
   $Xcoordinat_detected_YES=0
   $xcor=0
$getcolor=0
$coord = PixelSearch ( 140, 125, 700, 156, 0xF2F2F2,10,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord[0]+1 , $coord[1] , $hWnd ), 6)

if Not @error and $getcolor="D9E0E7" then
   TrayTip ("���������",'���������� � ���������� "X" ������� ������������', 100)
   $xcor=$coord[0]-150
   $Xcoordinat_detected_YES=1
;~    msgbox(0,'',$coord[0])
Else
   TrayTip ("���������","���������� � ����������� �� ������������ :(", 100)
   $xcor=0
endif

   ;����������� ������ ���� � ������ �������� ���������� Y
   dim $coord2[2]
   $ycor=0
$getcolor=0
$coord2 = PixelSearch ( $winx/2, 0, ($winx/2)+1, $winy, 0xDAE1E8,1,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord2[0] , $coord2[1]+1 , $hWnd ), 6)
;~ msgbox(0,'',$coord2[1] & 'wdtn ���������� �������: ' & $getcolor);�������
if Not @error and $getcolor="F7F7F7" then
   if $Xcoordinat_detected_YES=1 then
	  TrayTip ("���������",'���������� � ���������� "X" ������� ������������ = ' &$xcor& @CR &'���������� � ���������� "Y" ������� ������������ = ' &$ycor, 1000)
	  Else
	  TrayTip ("���������",'���������� � ���������� "Y" ������� ������������', 1000)
	  endif
   $ycor=$coord2[1]-147
;~    msgbox(0,'',$coord2[1]);�������
Else
   TrayTip ("���������","���������� � ���������� Y �� ������������ :(", 1000)
   $xcor=0
EndIf

sleep(1000)

;~ $loc=_local_detect(0)

;~ ;traytip('','������� ������������ '&$loc,1000)
;~ Sleep(1500)
;~ sleep(3000);�������


;�������
;~ MsgBox(0, "X � Y �����:", WinGetTitle ($hWnd))
;~ 	If Not @error Then
;~ 	   $getcolor=PixelGetColor ( $coord[0]+1 , $coord[1] , $hWnd )
;~     MsgBox(0, "X � Y �����:", $coord[0] & "," & $coord[1] & '  getcolor=' & Hex($getcolor, 6))
;~  Else
;~ 	MsgBox(0, "erorr","erorr")
;~ EndIf



    ;���������� ����� � ���
	global $cx_attack=360, $cy_attack=470
;~ 	_Click($cx_attack, $cy_attack)
	;���������� ������������� ��������� � ���
	global $cx_helper=700, $cy_helper=470
;~ 	_Click($cx_helper, $cy_helper)


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
;~ 	_Click($cx_loc1_3, $cy_loc1_3)

global $Q=12000
   _local_detect()
_thinks_loc()


;~ 		 $B_Close = 0
;~ 		 $B_Close = PixelSearch ( 460, 560+77+$ycor, 470, 570+77+$ycor, 0x6EAD55,1,1, $hWnd )
;~ 	  if $B_Close<>0 then
;~ 	MsgBox(0, '���������', ' �� � ��� ')
;~ 	  Else
;~ 	  EndIf


;~ 	;������������� ����� ������� ���
;~ 	$getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
;~ 	if $getcolor_attack='A7A7A7' then MsgBox(0, '���������', ' �� � ��� ' & $i)
;~
;~
;~ 	for $i=1 to 2
;~     _Click($coordx, $coordy)
;~    sleep(10)
;~    next


EndFunc   ;==>doit


;�������� ����
func _thinks_loc()

   traytip('','������� � ������ ����� '&$loc,1000)
Sleep(1500)

for $thin=1 to $Q
$aRandom = _RandomEx(1, 6, 1, 6, 1)
;~ 						$hTimer = TimerInit()
   for $i=1 to 6

	  TrayTip ("���������","� ��� ����", 100);�������
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

func _fight()
   TrayTip ("���������","� � ���!", 100) ;�������
   $hTimer_f = TimerInit() ;����� ������� �� ������ ������ � "������� ���"


   _Click($cx_helper, $cy_helper)
   sleep(10)
   _Click($cx_helper, $cy_helper)
   sleep(10)
   _Click($cx_helper, $cy_helper)
   sleep(10)
   _Click($cx_attack, $cy_attack)
   	sleep(100)

	if TimerDiff($hTimer_f) > 600000 then return ;����� ������� �� ������ ������ � "������� ���"

			 ;��������� ��������� � ������
		 $B_Close = 0
		 $B_Close = PixelSearch ( 460+$xcor, 560+77+$ycor, 470+$xcor, 570+77+$ycor, 0x6EAD55,10,1, $hWnd )
	  if $B_Close=0 then
		 _fight()
		 else
		 _Click($B_Close[0]-$xcor, $B_Close[1]-77-$ycor)
		 sleep(500)
		 _Click($B_Close[0]-$xcor+10, $B_Close[1]-77-$ycor+10)
		 TrayTip ("���������","����� �� ���", 100);�������
;~ 		 _thinks_loc($loc)
	  EndIf


endfunc

;����������� ������� ������� ���� �������;����������� ������� ������� ���� �������
func _PxSr_and_click($px1,$py1,$px2,$py2,$color,$variation)
;~
	  for $i=0 to 2 ;������������ ����� ��� ;�������� ������ ���������� ������;�������� ������ ���������� ������;�������� ������ ���������� ������;�������� ������ ���������� ������
		 $B_Select = 0
		 $B_Select = PixelSearch ( $px1+$xcor, $py1+77+$ycor, $px2+$xcor, $py2+77+$ycor, 0x6EAD55,$variation,1, $hWnd )
		 if $B_Select=0 then
			$i=0
			else
			_Click($B_Select[0]-$xcor, $B_Select[1]-77-$ycor)
			TrayTip ("���������","���� ������, ���� ��������", 100);�������
			$i=2
			sleep (1000)
			_Click(604, 310) ;���� � ���� ���
			sleep (1000)
			_Click(755, 180) ;��������� ���� ������
		 EndIf
	  next

EndFunc


;����� � ������ � ���� 1�1 ��� �������� ���������� ���
func _pause_battle()
				  $testdelay=0
   			   traytip('','������� ����� � ���, ������: '&@MIN,100)
				  sleep($testdelay)
;~ 	  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=15 or @MIN=00 or @MIN=30 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then _fight_detect()
		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then
;~ 		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then
			   traytip('','������� ����� � ���, �������: '&$loc&"   ����� �������� �����������   ",100)
				  sleep($testdelay)
			 _fight_detect()
		  Else
			 				traytip('','������� ����� � ���, �������: '&$loc&"  ��� ����� ����� �������   ",100)
							sleep($testdelay)
;~ 				If @MIN>=45 and @MIN<=57 or @MIN>=20 and @MIN<=27 then
			    If  @MIN>=20 and @MIN<=27 or @MIN>=45 and @MIN<=57 then
					 if $loc=1 then return
					  if $loc=2 then
						 _Change_loc(1)
						traytip('','������� ����� � ���, �������: '&$loc&"   �������� ������� �� ������   ",100)
						sleep($testdelay)
						_thinks_loc()

						Else
						traytip('','������� ����� � ���, �������: '&$loc&"   �����   ",100)
						sleep($testdelay)
						return
						endif
				Else
				EndIf
				;traytip('','������� ����� � ���, �������: '&$loc&"  ������ � �� �����(((   ",100)
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
	  sleep (1000)

endfunc

;������� �������� ���������� ��� � �������� ������ �� ����� �����
func _fight_detect()

   $hTimer_fd = TimerInit() ;����� ������� �� ������ ������ � "������� ���"

for $fight_detect=0 to 1
   _Change_loc(2)
      TrayTip ("���������","������ ���������� ���", 100) ;�������
   sleep(500)

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
	   sleep(1000)
	  _Click(655, 420) ; ������ � ���
	  TrayTip ("���������","��� ������", 100);�������
	  sleep (1000)
	  _Click(604, 310) ;���� � ���� ���
	  sleep (1000)
	  _Click(755, 180) ;��������� ���� ������

      	  ;������� ��� �� ��� � ��������� �� ���
	  $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
	  if $getcolor_attack='A7A7A7' then _fight()

	  ; �������� ��������� �������
	  $workE = GUICtrlSendMsg($WorkEnergynumber, $CB_GETCURSEL, 0, 0)
	if $workE<>1 then
		  sleep (1000)
		  _Click(305, 165) ;����� �������
		  sleep (1000)
		  ;������������ ������ ������, ���� ������� ���� ������ ������
		  for $i=0 to 63
			 $coord = PixelSearch( 575+$xcor, 310+77+$ycor, 580+$xcor, 700+77+$ycor, 0x6EAD55, 5 )
			 If Not @error Then
				 _Click($coord[0]-$xcor, $coord[1]-77-$ycor)
				 sleep(600)
			  Else
				;��������� ��������� � ��������
				_Click(800, 190) ;������� �� ����������� ������� �������
				sleep(300)
				_Click(782, 111) ;������� �� ���� ������
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
;~ 			TrayTip ("���������","��� ������", 100);�������
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
		 TrayTip ("���������","��� ������", 100);�������
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
;~ 			   TrayTip ("���������","��� ������", 100);�������
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

	  traytip('','������ ��������� � ������ ',100)
	  sleep(500)
   wend

EndFunc















Func _doit2()
   ;��������� ������� �������� �������� ����
   $hWnd = WinGetHandle("[ACTIVE]")
    $sControl = ControlGetFocus($hWnd)
    $aPos = ControlGetPos($hWnd, "", $sControl)
;~     $aPos = ControlGetPos($hWnd, "", "")
   $winx=$aPos[2]
   $winy=$aPos[3]

   $x1=0
   $y1=0

   ;����������� ������ ���� � ������ �������� ���������� x
   dim $coord[2]
$getcolor=0
$coord = PixelSearch ( 140, 125, 700, 156, 0xF2F2F2,10,1, $hWnd )
If Not @error Then $getcolor=Hex(PixelGetColor ( $coord[0]+1 , $coord[1] , $hWnd ), 6)

if Not @error and $getcolor="D9E0E7" then
   TrayTip ("���������","���������� � ����������� ������� ������������", 100)
   $xcor=$coord[0]-150
Else
   TrayTip ("���������","���������� � ����������� �� ������������ :(", 100)
   $xcor=0
EndIf

    ;���������� ����� � ���
	global $cx_attack=360, $cy_attack=470
;~ 	_Click($cx_attack, $cy_attack)
	;���������� ������������� ��������� � ���
	global $cx_helper=700, $cy_helper=470
;~ 	_Click($cx_helper, $cy_helper)


	;���������� ���� �� ������� ������ �������
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
	;���������� ���� �� ������� �������� �����
	$cx_loc[2][1]=500
	$cy_loc[2][1]=120
	$cx_loc[2][2]=800
	$cy_loc[2][2]=135
	$cx_loc[2][3]=817
	$cy_loc[2][3]=355
	$cx_loc[2][4]=407
	$cy_loc[2][4]=290
	$cx_loc[2][5]=750
	$cy_loc[2][5]=520
	$cx_loc[2][6]=400
	$cy_loc[2][6]=690
;~ 	_Click($cx_loc1_3, $cy_loc1_3)

    ;���������� ������ ������ � ��������� ���
	global $cx_attack1x1=482, $cy_attack1x1=313

$q2=25

for $i=1 to $q2
   sleep(500)
$y=0
   while $y=0

	  ;����� � ������ � ���� 1�1 ��� �������� ���������� ���
	  if @MIN=59 or @MIN=29 and $wait_for_battle=1 then _fight_detect()

	  $mousePos = MouseGetPos()
	  MouseMove ( 480+$xcor, 320+77+$ycor ,0 )
	  _Click($cx_attack1x1+Random(-15,15,1), $cy_attack1x1+Random(-15,15,1))
	  sleep(15)
	  MouseMove ( $mousePos[0], $mousePos[1] ,0 )
	   sleep(700)

   $getcolor_attack=Hex(PixelGetColor ( 358+$xcor , 442+77+$ycor , $hWnd ), 6)
		 if $getcolor_attack='A7A7A7' then $y=1
			TrayTip ("���������",$y,100)

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