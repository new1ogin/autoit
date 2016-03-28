#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)

_GuiCreae()

Func _GuiCreae()
	#Region ### START Koda GUI section ### Form=d:\autoitv3.3.8.1\Прикладные\backup\form1.kxf
$Form1 = GUICreate("Оповещение", 316, 334, 192, 114)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1Close")
GUISetOnEvent($GUI_EVENT_MINIMIZE, "Form1Minimize")
GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Form1Maximize")
GUISetOnEvent($GUI_EVENT_RESTORE, "Form1Restore")
$Group1 = GUICtrlCreateGroup("Опции отправки оповещения", 16, 8, 281, 121)
$InputEmail = GUICtrlCreateInput("Введите Ваш Email", 23, 48, 265, 21)
GUICtrlSetOnEvent($InputEmail, "InputEmailChange")
$InputSMSapi_id = GUICtrlCreateInput("Ваш api_id с сайта sms.ru", 23, 96, 241, 21)
GUICtrlSetOnEvent($InputSMSapi_id, "InputSMSapi_idChange")
$CheckboxEmail = GUICtrlCreateCheckbox("Отправлять Email", 24, 32, 241, 17)
GUICtrlSetState($CheckboxEmail, $GUI_CHECKED)
GUICtrlSetOnEvent($CheckboxEmail, "CheckboxEmailClick")
$CheckboxSMSapi_id = GUICtrlCreateCheckbox("Отправить СМС", 24, 80, 241, 17)
GUICtrlSetOnEvent($CheckboxSMSapi_id, "CheckboxSMSapi_idClick")
$ButtonQuestion = GUICtrlCreateButton("?", 272, 94, 17, 25)
GUICtrlSetOnEvent($ButtonQuestion, "ButtonQuestionClick")
GUICtrlCreateGroup("", -99, -99, 1, 1)
$Label1 = GUICtrlCreateLabel("Ручное управление", 16, 136, 101, 17)
GUICtrlSetOnEvent($Label1, "Label1Click")
$Label2 = GUICtrlCreateLabel("Shift+F2 - Следить за точкой", 16, 152, 146, 17)
GUICtrlSetTip($Label2, "Слежение за изменением цвета пикселя на котором находится курсор")
GUICtrlSetOnEvent($Label2, "Label2Click")
$Label3 = GUICtrlCreateLabel("Shift+Esc - Выход", 16, 216, 90, 17)
GUICtrlSetTip($Label3, "Заканчивает работу с приложением, также для этого вы можете использовать правый клик по значку в трее")
GUICtrlSetOnEvent($Label3, "Label3Click")
$Label4 = GUICtrlCreateLabel("Shift+F5 - Отодвинуть окно*", 16, 200, 142, 17)
GUICtrlSetTip($Label4, "Отодвинуть окно за которым начато слежение, или начать слежение за всем окном"&@CRLF&"Окно отодвигается за границу экрана до того как слежение не будет закончено.")
GUICtrlSetOnEvent($Label4, "Label4Click")
$Label5 = GUICtrlCreateLabel("Shift+F4 - Следить за загрузкой процесса", 16, 184, 215, 17)
GUICtrlSetTip($Label5, "Слежение за загрженностью процессора определеным процессом")
GUICtrlSetOnEvent($Label5, "Label5Click")
$Label6 = GUICtrlCreateLabel("Shift+F3 - Следить за областью в окне*", 16, 168, 201, 17)
GUICtrlSetTip($Label6, "Слежение за прямоугольной областью в определенном окне")
GUICtrlSetOnEvent($Label6, "Label6Click")
$OK = GUICtrlCreateButton("Ручное упр", 224, 296, 75, 25)
GUICtrlSetFont($OK, 8, 800, 0, "MS Sans Serif")
GUICtrlSetOnEvent($OK, "OKClick")
$ButtonDot = GUICtrlCreateButton("Следить за точкой", 112, 296, 107, 25)
GUICtrlSetOnEvent($ButtonDot, "ButtonDotClick")
$ButtonWindowDrag = GUICtrlCreateButton("Отодвин. окно", 16, 296, 91, 25)
GUICtrlSetOnEvent($ButtonWindowDrag, "ButtonWindowDragClick")
$ButtonArea = GUICtrlCreateButton("Следить за областью", 16, 264, 139, 25)
GUICtrlSetOnEvent($ButtonArea, "ButtonAreaClick")
$ButtonProc = GUICtrlCreateButton("Следить за процессом", 160, 264, 139, 25)
GUICtrlSetOnEvent($ButtonProc, "ButtonProcClick")
$Label7 = GUICtrlCreateLabel("* Функции ещё не реализованы", 14, 236, 167, 17)
GUICtrlSetOnEvent($Label7, "Label7Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

	While 1
		Sleep(100)
	WEnd
EndFunc   ;==>_GuiCreae

Func ButtonAreaClick()

EndFunc   ;==>ButtonAreaClick
Func ButtonDotClick()

EndFunc   ;==>ButtonDotClick
Func ButtonProcClick()

EndFunc   ;==>ButtonProcClick
Func ButtonWindowDragClick()

EndFunc   ;==>ButtonWindowDragClick
Func OKClick()
	Exit
EndFunc   ;==>OKClick
Func CheckboxEmailClick()

EndFunc   ;==>CheckboxEmailClick
Func CheckboxSMSapi_idClick()

EndFunc   ;==>CheckboxSMSapi_idClick
Func ButtonQuestionClick()

EndFunc   ;==>ButtonQuestionClick

Func Form1Close()
	Exit
EndFunc   ;==>Form1Close
Func Form1Maximize()

EndFunc   ;==>Form1Maximize
Func Form1Minimize()

EndFunc   ;==>Form1Minimize
Func Form1Restore()

EndFunc   ;==>Form1Restore
Func InputEmailChange()

EndFunc   ;==>InputEmailChange
Func InputSMSapi_idChange()

EndFunc   ;==>InputSMSapi_idChange
Func Label1Click()

EndFunc   ;==>Label1Click
Func Label2Click()

EndFunc   ;==>Label2Click
Func Label3Click()

EndFunc   ;==>Label3Click
Func Label4Click()

EndFunc   ;==>Label4Click
Func Label5Click()

EndFunc   ;==>Label5Click
Func Label6Click()

EndFunc   ;==>Label6Click
Func Label7Click()

EndFunc   ;==>Label7Click





HotKeySet("{ESC}", "_quite") ;Р­С‚Рѕ РІС‹Р·РѕРІ
HotKeySet("{ins}", "_Go") ;Р­С‚Рѕ РІС‹Р·РѕРІ
HotKeySet("{scrolllock}", "_Proc") ;Р­С‚Рѕ РІС‹Р·РѕРІ
HotKeySet("{Down}", "_Pause") ;Р­С‚Рѕ РІС‹Р·РѕРІ


While 1
	Sleep(100)
WEnd


Func _go()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_повещение", Default, Default, "_go", 0, 0)
EndFunc   ;==>_go

Func _Pause()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_повещение", Default, Default, "_Pause", 0, 0)
EndFunc   ;==>_Pause

Func _Proc()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_повещение", Default, Default, "_Proc", 0, 0)
EndFunc   ;==>_Proc

Func _quite()
	If Not IsDeclared("sToolTipAnswer") Then Local $sToolTipAnswer
	$sToolTipAnswer = ToolTip("gui_повещение", Default, Default, "_quite", 0, 0)
	Exit
EndFunc   ;==>_quite
