#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <ImageSearch.au3>

opt('PixelCoordMode', 0)
;~ Opt("CaretCoordMode", 0) 
Opt("MouseCoordMode", 2)

global $hWnD, $sControl, $xcor, $ycor, $loc
global $wait_for_battle=1 ;����� � ������ � ���� 1�1 ��� �������� ���������� ���

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
HotKeySet("{F3}", "_doit2") ;������ � ��������� ���
HotKeySet("{F4}", "pause") ;������ � ��������� ���

Func pause()
While 1
   TrayTip ("���������","�����",100)
    Sleep(10000)
WEnd
EndFunc   ;==>pause


While 1
    Sleep(100)
WEnd


Func _Click($cx, $cy)
;~    if $cx<$centerx*2 AND $cy<$centery*2 and $cx>0 and $cy>0 then

;~    Mousemove($cx, $cy+77+$ycor)
if $cx<>360 or $cx<>482 Then
   sleep(random(500,900,1))
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
;~ TrayTip('','������� '&$loc,1000)
;~ Sleep(500)
;~ TrayTip('','X: '&$cx+$xcor+random(-4,4,1)&'   Y: '&$cy+$ycor+random(-4,4,1),1000)
;~ Sleep(1000)

;~    Else
;~    EndIf
EndFunc


func _local_detect($Targetloc=0)
   ;����������� �������
;~ if @HotKeyPressed="{F1}" then $loc=1
$noloc=0
$noloc=$loc
;~ if @HotKeyPressed="{F2}" then $loc=2
   $getcolorL=Hex(PixelGetColor ( 776+$xcor+5 , 133+77+$ycor , $hWnd ), 6)
   if $getcolorL='615B4D' then $loc=1
   if $getcolorL='171C08' then $loc=2
	  TrayTip ("���������",'�� �� ' & $loc & '-� �������', 100)
   if $Targetloc=0 then
	  if $loc=0 then $loc=$noloc ;����������� � ����������� ��������� ������� �� ������ ������
	  Return $loc
   Else
	  if $Targetloc=1 then _Change_loc(1)
	  if $Targetloc=2 then _Change_loc(2)
	  endif
	  TrayTip('','������� � ������� ����� ������ '&$loc,1000)
Sleep(1500)
 if $loc=0 then $loc=$noloc ;����������� � ����������� ��������� ������� �� ������ ������
return $loc
endfunc



Func _doit()
   

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

$loc=_local_detect(0)

;~ TrayTip('','������� ������������ '&$loc,1000)
;~ Sleep(1500)
;~ sleep(3000);�������
; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!
; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!
; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!; ������ HOME � ������� ������!!!!


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
   
   TrayTip('','������� � ������ ����� '&$loc,1000)
Sleep(1500)

for $thin=1 to $Q
$aRandom = _RandomEx(1, 6, 1, 6, 1)
;~ 						$hTimer = TimerInit() 
   for $i=1 to 6
	  global $loc=_local_detect(0)
	  TrayTip ("���������","� ��� ����", 100);�������
	  _pause_battle() ;����� � ������ � ���� 1�1 ��� �������� ���������� ���
	  
	  
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
				  $testdelay=300
   			   TrayTip('','������� ����� � ���, ������: '&@MIN,100)
				  sleep($testdelay)
;~ 	  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=15 or @MIN=00 or @MIN=30 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then _fight_detect()
		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then 
;~ 		  if @MIN=14 or @MIN=59 or @MIN=29 or @MIN=13 or @MIN=58 or @MIN=28 and $wait_for_battle=1 then 
			   TrayTip('','������� ����� � ���, �������: '&$loc&"   ����� �������� �����������   ",100)
				  sleep($testdelay)
			 _fight_detect()
		  Else
			 				TrayTip('','������� ����� � ���, �������: '&$loc&"  ��� ����� ����� �������   ",100)
							sleep($testdelay)
;~ 				If @MIN>=45 and @MIN<=57 or @MIN>=20 and @MIN<=27 then 
			    If  @MIN>=20 and @MIN<=27 or @MIN>=45 and @MIN<=57 then 
					  if $loc=2 then 
						 _Change_loc(1)
						TrayTip('','������� ����� � ���, �������: '&$loc&"   �������� ������� �� ������   ",100)
						sleep($testdelay)
						_thinks_loc()
						
						Else
						TrayTip('','������� ����� � ���, �������: '&$loc&"   �����   ",100)
						sleep($testdelay)
						return
						endif
				Else
				EndIf
				TrayTip('','������� ����� � ���, �������: '&$loc&"  ������ � �� �����(((   ",100)
						sleep($testdelay)
		  EndIf

EndFunc


;����� �������
Func _Change_loc($location)
   global $loc=$location
   
   _Click(882, 299) ;�������� �� ����� ��� ����� �������
	  sleep (1000)
	  if $loc=1 then _Click(556, 349) ;������ �������
	  if $loc=2 then _Click(740, 326) ;������ �������
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
;~ 		 _Click(614, 145) ;����� ���������
		 _Click(745, 610) ;����� ���������

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
			_thinks_loc($loc)
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