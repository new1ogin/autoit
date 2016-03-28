#include <WindowsConstants.au3>
#include <GDIPlus.au3>
#include <GUIConstantsEx.au3>
#include <WinAPIEx.au3>

HotKeySet('{F10}', 'Terminate')

$hGUI = GUICreate('', 900, 900, 0, 0, $WS_POPUP, BitOR($WS_EX_LAYERED, $WS_EX_TOPMOST))
GUISetBkColor(0xABABAB)
GUISetState()
_WinAPI_SetLayeredWindowAttributes($hGUI, 0xABABAB, 0, $LWA_COLORKEY)
_GDIPlus_Startup()
$hGraphic = _GDIPlus_GraphicsCreateFromHWND($hGUI)
$hPenBlueThin = _GDIPlus_PenCreate(0xFF0000FF,5) ; ручка для синей линии
;~ $hPenRedBold = _GDIPlus_PenCreate(0xFFFF0000, 2) ; ручка для красной точки
;~ $hPenGreenBold = _GDIPlus_PenCreate(0xFF00FF00, 2) ; ручка для зеленой точки
;~ $hEraser = _GDIPlus_PenCreate(0xFFABABAB, 2) ; стирающая ручка
;~ $hBrushYellow = _GDIPlus_BrushCreateSolid(0xFFFFFF00) ; желтая кисть
;~ $hBrushEraser = _GDIPlus_BrushCreateSolid(0xFFABABAB) ; стирающая кисть
;~ $hFormat = _GDIPlus_StringFormatCreate() ; формат текста
;~ $hFamily = _GDIPlus_FontFamilyCreate('Tahoma') ; шрифт текста
;~ $hFont = _GDIPlus_FontCreate($hFamily, 10) ; размер шрифта


	While 1
;~ 		_WinAPI_DrawLine($hDC, @DesktopWidth/2+$i-2, @DesktopHeight / 2+$i-2, @DesktopWidth/2+$i, @DesktopHeight / 2+$i)
		$aPos = MouseGetPos()
;~ 		_DrawLine(@DesktopWidth/2+$i-2, @DesktopHeight / 2+$i-2, @DesktopWidth/2+$i, @DesktopHeight / 2+$i) ; рисуем
		_DrawLine($aPos[0]+3, $aPos[1]+3, $aPos[0]+6, $aPos[1]+6) ; рисуем
		Sleep(50)
		_Erase() ; стираем
	Wend

Func _DrawLine($iStartX, $iStartY, $iEndX, $iEndY)
    $iLineLength = Sqrt(($iStartX - $iEndX) ^ 2 + ($iStartY - $iEndY) ^ 2) ; длина отрезка по теореме Пифагора :D
    $tLayout = _GDIPlus_RectFCreate($iStartX + 10, $iStartY + 10, 0, 0) ; координаты для надписи с длиной отрезка
;~     _GDIPlus_GraphicsDrawStringEx($hGraphic, Round($iLineLength, 3) & ' pixel(s)', $hFont, $tLayout, $hFormat, $hBrushYellow) ; вывод надписи с длиной отрезка
;~     _GDIPlus_GraphicsDrawEllipse($hGraphic, $iStartX - 2, $iStartY - 2, 4, 4, $hPenRedBold) ; точка СТАРТ
;~     _GDIPlus_GraphicsDrawEllipse($hGraphic, $iEndX - 2, $iEndY - 2, 4, 4, $hPenGreenBold) ; точка ФИНИШ
    _GDIPlus_GraphicsDrawLine($hGraphic, $iStartX, $iStartY, $iEndX, $iEndY, $hPenBlueThin) ; линия отрезка
EndFunc   ;==>_DrawLine



Func _EraseLine($iStartX, $iStartY, $iEndX, $iEndY)
    _GDIPlus_GraphicsClear($hGraphic, 0xFFABABAB)
EndFunc
Func _Erase()
    _GDIPlus_GraphicsClear($hGraphic, 0xFFABABAB)
EndFunc

; удаление ресурсов
;~ _GDIPlus_FontDispose($hFont)
;~ _GDIPlus_FontFamilyDispose($hFamily)
;~ _GDIPlus_StringFormatDispose($hFormat)
;~ _GDIPlus_BrushDispose($hBrushEraser)
;~ _GDIPlus_BrushDispose($hBrushYellow)
_GDIPlus_PenDispose($hPenBlueThin)
;~ _GDIPlus_PenDispose($hPenRedBold)
;~ _GDIPlus_PenDispose($hPenGreenBold)
;~ _GDIPlus_PenDispose($hEraser)
_GDIPlus_GraphicsDispose($hGraphic)
_GDIPlus_Shutdown()

Func Terminate()
    Exit
EndFunc   ;==>Terminate

