#Include <GUIConstantsEx.au3>
#Include <WinAPIEx.au3>
#include <WinAPI.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
#include <EditConstants.au3>

$winx=1280
$winy=1024

$hForm = GUICreate('', $winx, $winy, -1, -1, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST))
GUISetBkColor(0xABABAB)
_WinAPI_SetLayeredWindowAttributes($hForm, 0xABABAB, 0, $LWA_COLORKEY)
GUIRegisterMsg($WM_PAINT, 'WM_PAINT')
GUIRegisterMsg($WM_SIZE, 'WM_SIZE')
GUISetState(@SW_SHOWNOACTIVATE)

Sleep(1000)
;~ WinMove($hForm, '', 200, 200, 400, 400)
;~ Sleep(1000)
;~ WinMove($hForm, '', 500, 500, 100, 100)
;~ GUISetState(@SW_MAXIMIZE, $hForm)

Do
Until GUIGetMsg() = -3

Func _Draw($hWnd)
    Local $hDC = _WinAPI_GetDC($hWnd)
    Local $hPen = _WinAPI_SelectObject($hDC, _WinAPI_CreatePen($PS_SOLID, 1, 0x0000FF))
    Local $hBrush = _WinAPI_SelectObject($hDC, _WinAPI_GetStockObject($NULL_BRUSH))
    Local $tRect = _WinAPI_GetClientRect($hWnd)
;~     _WinAPI_Ellipse($hDC, $tRect)
;~ 	   _WinAPI_DrawLine($hDC, 100, 200, 300, 400)
;~    _WinAPI_DrawLine($hDC, $winx*1/4, 0, $winx*1/4+1, $winy)
;~    sleep (200)
;~    _WinAPI_DrawLine($hDC, $winx*2/4, 0, $winx*2/4+1, $winy)
;~    sleep (200)
;~    _WinAPI_DrawLine($hDC, $winx*3/4, 0, $winx*3/4+1, $winy)
;~    sleep (200)
;~    _WinAPI_DrawLine($hDC, 0, $winy*1/4, $winx, $winy*1/4+1)
;~    sleep (200)
;~    _WinAPI_DrawLine($hDC, 0, $winy*2/4, $winx, $winy*2/4+1)
;~    sleep (200)
;~    _WinAPI_DrawLine($hDC, 500, 500, 600, 600)
;~    sleep (200)
   
   
   
			$maxy = 1024
		 $maxx = 1280
		 $minx = 0
		 $miny = 0

		 ;~ $maxy =  Random ( 10 , 10241 )

		 $step=100
		 $numberblockx=Floor(($maxx-$minx) /$step)
		 $numberblocky=Floor(($maxy-$miny) /$step)
		 
;~ 		  $numberblockx=($maxx-$minx) /$step
;~ 		 $numberblocky=($maxy-$miny) /$step

		 Global $blocks[$numberblockx][$numberblocky]

		 ConsoleWrite("X : "&$numberblockx& @LF)
		 ConsoleWrite("X : "&$numberblocky& @LF)

		 for $t=0 to $numberblocky-1

		 $stroka=$t
		 $ytop=$stroka*$step
		 $ybottom=$stroka*$step+$step

			for $i=0 to $numberblockx-1

			$stolbec=$i
			$xleft=$stolbec*$step
			$xright=$stolbec*$step+$step
		 ;~ Dim $blocks2[$numberblockx][$numberblocky]
		 ;~ $sss=0
		 ;~ ConsoleWrite("y : "&$stroka& @LF)
		 ;~ ConsoleWrite("y : "&$stolbec& @LF)
		 
		 _WinAPI_DrawLine($hDC, $xleft, $ytop, $xright, $ybottom)
		 sleep(10)
;~ 			$blocks[$stolbec][$stroka]=PixelChecksum ( $xleft, $ytop, $xright, $ybottom)
		 ;~    $blocks[$stolbec][$stroka]=_ScreenCapture_Capture("",$stolbec*$step, $stroka*$step, $stolbec*$step+10, $stroka*$step+10)

			next

		 next
   
   
   
    _WinAPI_DeleteObject(_WinAPI_SelectObject($hDC, $hBrush))
    _WinAPI_DeleteObject(_WinAPI_SelectObject($hDC, $hPen))
    _WinAPI_ReleaseDC($hWnd, $hDC)
EndFunc   ;==>_Draw

Func WM_PAINT($hWnd, $iMsg, $wParam, $lParam)
    Switch $hWnd
        Case $hForm
            _Draw($hWnd)
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_PAINT

Func WM_SIZE($hWnd, $iMsg, $wParam, $lParam)
    Switch $hWnd
        Case $hForm
            _Draw($hWnd)
            Return 0
    EndSwitch
    Return $GUI_RUNDEFMSG
EndFunc   ;==>WM_SIZE