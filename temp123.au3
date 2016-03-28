#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=autoshot.ico
#AutoIt3Wrapper_Outfile=AutoShot - shotgun 0.1.exe
#AutoIt3Wrapper_Outfile_x64=AutoShot - shotgun 0.1_64.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <APIConstants.au3>
#include <WinAPI.au3>
#Include <WinAPIEx.au3>
#include <ImageSearch.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#Include <Icons.au3>
#Include <PixelSearchEx.au3>
#include <MouseOnEvent.au3>
#include <ButtonConstants.au3>
#include <TabConstants.au3>
#include <GUIHotKey.au3>
#Include <HotKey.au3>
#include <Inet.au3>
#include <Misc.au3>

Global $sApp_Version,$sAppUpdate_Page = "http://www.new1ogin.guru-hosting.ru/files/Autoshot_Update.txt"
Global $sCurrent_AppVersion=$sApp_Version = "0.1"
Global $hGUI = 0
;Here we checking in quiet mode (only if new version available there will be a message).
;~ _AppCheckUpdates_Proc($sAppUpdate_Page, $sApp_Version, 1)
Global $WindowWidth=1024, $WindowHeight=768


Global $HK, $VK,$OldCode,$Code=0,$oldCode2,$Code2=0, $UseM =0, $UseM_=5
$timeout=5
$timeSleepMacros=650

	Opt('PixelCoordMode', 1)
	Opt("MouseCoordMode", 1)
	Opt("CaretCoordMode", 1)

global $command=0,$winx,$winy,$hWnD,$starttime,$MAP,$Paused,$Pos1x=0,$Pos1y=0,$xcor=1001,$ycor=1001,$timeout,$pricelx,$pricely,$4y,$sArray
global $getcolordcC,$getcolordcM,$getcolordcB,$getcolordcL,$schet=0,$posy,$schet2=0,$schet3=0,$sArray[2],$sArray,$BulletCoord=0,$Num_cycles=16,$timedown=24,$timeSleepMacros=660,$numDetect=0
global $exit=0, $FirstShot=0, $FirstShotTimer=0,$NextShotTimer=0, $Time2macros,$Time1macros,$resolutionDesktop

HotKeySet("{End}", "Terminate")
Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
HotKeySet("{F9}", "_DetectWindowPB")
HotKeySet("{F10}", "_DetectWindowCoords")
; TimerDiff

ConsoleWrite(' Готов'&@CRLF)

While 1
	Sleep(100)
WEnd


Func _DetectWindowCoords()

	ConsoleWrite('----------------------------DetectWindowCoords-----------------------------' & @CRLF)
	$time_extraction=TimerInit()
	$shade=3
	$shade2=3

	$ArrayMenu=PixelSearchEx(0, 0, @DesktopWidth, @DesktopHeight, 0xD6D9DD, $shade, 77, 1, $hWnD)
	If Not @error then
		ConsoleWrite('inmenu pixelsearchex coords X= '&$ArrayMenu[0]&'; Y= '&$ArrayMenu[1]&@CR)
		$Xcoordinat_detected_YES = 1
		$xcor = $ArrayMenu[0]-117
		$ycor = $ArrayMenu[1]-12
		ConsoleWrite('corr coords X= '&$xcor&'; Y= '&$ycor &@CR)
			Beep(1000, 100)
		MouseMove($xcor,$ycor) ;отладка

		Sleep(1000)

		$ArrayRightMenu = PixelSearchEx($winx, $ycor, $xcor, $ycor, 0x2B304C, $shade, 0, 1, $hWnD, $shade2)
		If Not @error then
			ConsoleWrite('inmenu Right pixelsearchex coords X= '&$ArrayRightMenu[0]&'; Y= '&$ArrayRightMenu[1]&@CR)
				Beep(1000, 100)
				$winx=$ArrayRightMenu[0]
	 		MouseMove($ArrayRightMenu[0],$ArrayRightMenu[1]) ;отладка
		Else
			ConsoleWrite('>ERROR $ArrayRightMenu, Error code: '&@error&@CRLF)
		endif

		Sleep(1000)

		$ArrayBottomMenu = PixelSearchEx($xcor, $winy, $xcor, $ycor, 0x2B304E, $shade, 79, 1, $hWnD, $shade2)
		If Not @error then
			ConsoleWrite('inmenu Bottom pixelsearchex coords X= '&$ArrayBottomMenu[0]&'; Y= '&$ArrayBottomMenu[1]+46 &@CR)
				Beep(1000, 100)
			MouseMove($ArrayBottomMenu[0],$ArrayBottomMenu[1]+46) ;отладка
			$winy=$ArrayBottomMenu[1]+46
		Else
			$ArrayBottomMenu = PixelSearchEx($xcor, $winy, $xcor, $ycor, 0x2B304E, $shade, 0, 1, $hWnD, $shade2)
			If Not @error Then
				ConsoleWrite('inmenu Bottom pixelsearchex Alternativ coords X= '&$ArrayBottomMenu[0]&'; Y= '&$ArrayBottomMenu[1]+46 &@CR)
				MouseMove($ArrayBottomMenu[0],$ArrayBottomMenu[1]+46) ;отладка
				Beep(1000, 100)
				$winy=$ArrayBottomMenu[1]+46
			Else
				ConsoleWrite('>ERROR $ArrayBottomMenu Alternativ, Error code: '&@error&@CRLF)
			endif
		endif

		TrayTip("Подсказка", 'Вы играете с разрешением: ' & $winx-$xcor&'x'&$winy-$ycor&' ?', 1500)
		ConsoleWrite('Вы играете с разрешением: ' & $winx-$xcor&'x'&$winy-$ycor&' ?' & @CRLF)

	Else
		ConsoleWrite('>ERROR $ArrayMenu, Error code: '&@error&@CRLF)
		TrayTip("Подсказка", 'Отклонение координат не установленно :-(', 1500)
	endif




EndFunc




Func _DetectWindowPB()
		ConsoleWrite('----------------------------DetectWindowCoords-----------------------------' & @CRLF)
	$time_extraction=TimerInit()
	$shade=9
	$shade2=9

	;поиск отклонений - в меню по логотипу Поинтбланк
	$ArrayMenu=PixelSearchEx(0, 0, @DesktopWidth, @DesktopHeight, 0xD6D9DD, $shade, 77, 1, $hWnD)
	If Not @error then
		ConsoleWrite('inmenu pixelsearchex coords X= '&$ArrayMenu[0]&'; Y= '&$ArrayMenu[1]&@CR)
		$Xcoordinat_detected_YES = 1
		$xcor = $ArrayMenu[0]-117
		$ycor = $ArrayMenu[1]-12
		ConsoleWrite('corr coords X= '&$xcor&'; Y= '&$ycor &@CR)
			Beep(1000, 100)
		MouseMove($xcor,$ycor) ;отладка
		$winx=$xcor+$WindowWidth
		$winy=$ycor+$WindowHeight
		MouseMove($winx,$winy) ;отладка

		TrayTip("Подсказка", 'Окно PointBlank успешно найденно ! Координаты угла окна- x: ' & $xcor&', y: '&$ycor, 1000)
		Beep(1000, 200)
	Else
		;Поиск отклонений в игре по плюсикуна карте
		$Array=PixelSearchEx(0, 0, $winx, $winy, 0x9C9A9C, 1, 13, 1, $hWnD)
		If Not @error then
			$xcor = $Array[0] -135
			$ycor = $Array[1] -170
			$winx=$xcor+$WindowWidth
			$winy=$ycor+$WindowHeight
				TrayTip("Подсказка", 'Окно PointBlank успешно найденно ! Координаты угла окна- x: ' & $xcor&', y: '&$ycor, 1000)
				Beep(1000, 200)
				ConsoleWrite(' НАЙДЕННО ПО ПЛЮСИКУ КАРТЫ!!!' &@CRLF )
		Else
			TrayTip("Подсказка", "Окно PointBlank не найденно попробуйте позже  :(", 1000)
			Beep(9000, 1000)
			sleep(1500)
			$xcor = 0
			$ycor = 0
		endif
	endif


EndFunc

;~ C8C8C8