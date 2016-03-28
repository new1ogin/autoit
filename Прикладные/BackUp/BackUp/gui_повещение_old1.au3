#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)

_GuiCreae()

Func _GuiCreae()
#Region ### START Koda GUI section ### Form=D:\autoitv3.3.8.1\Прикладные\BackUp\Form1.kxf
$Form1 = GUICreate("Оповещение", 301, 316, 192, 114)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
$Group1 = GUICtrlCreateGroup("Опции отправки оповещения", 8, 8, 281, 121)
$InputEmail = GUICtrlCreateInput("Введите Ваш Email", 15, 48, 265, 21)
GUICtrlSetOnEvent($InputEmail, "InputEmailChange")
$InputSMSapi_id = GUICtrlCreateInput("Ваш api_id с сайта sms.ru", 15, 96, 265, 21)
GUICtrlSetOnEvent($InputSMSapi_id, "InputSMSapi_idChange")
$CheckboxEmail = GUICtrlCreateCheckbox("Отправлять Email", 16, 32, 241, 17)
GUICtrlSetState($CheckboxEmail, $GUI_CHECKED)
GUICtrlSetOnEvent($CheckboxEmail, "CheckboxEmailClick")
$CheckboxSMSapi_id = GUICtrlCreateCheckbox("Отправить СМС", 16, 80, 241, 17)
GUICtrlSetOnEvent($CheckboxSMSapi_id, "CheckboxSMSapi_idClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label1 = GUICtrlCreateLabel("Ручное управление", 8, 136, 101, 17)
GUICtrlSetOnEvent($Label1, "Label1Click")
$Label2 = GUICtrlCreateLabel("Shift+F2 - Следить за точкой", 8, 152, 146, 17)
GUICtrlSetTip($Label2, "Слежение за изменением цвета пикселя на котором находится курсор")
GUICtrlSetOnEvent($Label2, "Label2Click")
$Label3 = GUICtrlCreateLabel("* Функции ещё не реализованы", 8, 216, 167, 17)
GUICtrlSetOnEvent($Label3, "Label3Click")
$Label4 = GUICtrlCreateLabel("Shift+F5 - Отодвинуть окно*", 8, 200, 142, 17)
GUICtrlSetTip($Label4, "Отодвинуть окно за которым начато слежение, или начать слежение за всем окном"&@CRLF&"Окно отодвигается за границу экрана до того как слежение не будет закончено.")
GUICtrlSetOnEvent($Label4, "Label4Click")
$Label5 = GUICtrlCreateLabel("Shift+F4 - Следить за загрузкой процесса", 8, 184, 215, 17)
GUICtrlSetTip($Label5, "Слежение за загрженностью процессора определеным процессом")
GUICtrlSetOnEvent($Label5, "Label5Click")
$Label6 = GUICtrlCreateLabel("Shift+F3 - Следить за областью в окне*", 8, 168, 201, 17)
GUICtrlSetTip($Label6, "Слежение за прямоугольной областью в определенном окне")
GUICtrlSetOnEvent($Label6, "Label6Click")
$OK = GUICtrlCreateButton("Ручное упр", 216, 280, 75, 25)
GUICtrlSetFont($OK, 8, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent($OK, "OKClick")
$ButtonDot = GUICtrlCreateButton("Следить за точкой", 104, 280, 107, 25)
GUICtrlSetOnEvent($ButtonDot, "ButtonDotClick")
$ButtonWindowDrag = GUICtrlCreateButton("Отодвин. окно", 8, 280, 91, 25)
GUICtrlSetOnEvent($ButtonWindowDrag, "ButtonWindowDragClick")
$ButtonArea = GUICtrlCreateButton("Следить за областью", 8, 248, 139, 25)
GUICtrlSetOnEvent($ButtonArea, "ButtonAreaClick")
$ButtonProc = GUICtrlCreateButton("Следить за процессом", 152, 248, 139, 25)
GUICtrlSetOnEvent($ButtonProc, "ButtonProcClick")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd
EndFunc

Func ButtonAreaClick()

EndFunc
Func ButtonDotClick()

EndFunc
Func ButtonProcClick()

EndFunc
Func ButtonWindowDragClick()

EndFunc
Func OKClick()
exit
EndFunc
Func CheckboxEmailClick()

EndFunc
Func CheckboxSMSapi_idClick()

EndFunc

Func Form1Close()
exit
EndFunc
Func Form1Maximize()

EndFunc
Func Form1Minimize()

EndFunc
Func Form1Restore()

EndFunc
Func InputEmailChange()

EndFunc
Func InputSMSapi_idChange()

EndFunc
Func Label1Click()

EndFunc
Func Label2Click()

EndFunc
Func Label3Click()

EndFunc
Func Label4Click()

EndFunc
Func Label5Click()

EndFunc
Func Label6Click()

EndFunc






HotKeySet("{ESC}", "_quite") ;Р­С‚Рѕ РІС‹Р·РѕРІ
HotKeySet("{ins}", "_Go") ;Р­С‚Рѕ РІС‹Р·РѕРІ
HotKeySet("{scrolllock}", "_Proc") ;Р­С‚Рѕ РІС‹Р·РѕРІ
HotKeySet("{Down}", "_Pause") ;Р­С‚Рѕ РІС‹Р·РѕРІ


While 1
	sleep(100)
WEnd


Func _go()
If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
$sToolTipAnswer = ToolTip("gui_повещение",Default,Default,"_go",0,0)
EndFunc

Func _Pause()
If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
$sToolTipAnswer = ToolTip("gui_повещение",Default,Default,"_Pause",0,0)
EndFunc

Func _Proc()
If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
$sToolTipAnswer = ToolTip("gui_повещение",Default,Default,"_Proc",0,0)
EndFunc

Func _quite()
If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
$sToolTipAnswer = ToolTip("gui_повещение",Default,Default,"_quite",0,0)
exit
EndFunc