#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=ОповещениеMail.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <array.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <File.au3>
#include <INet.au3>
#include <WinAPIEx.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <Constants.au3>
;~ Opt("GUIOnEventMode", 1)

HotKeySet("+{ESC}", "_quite")
HotKeySet("+{F2}", "_Go")
HotKeySet("+{F2}", "_Proc")
HotKeySet("+{F2}", "_Pause")
Global $NumberSplits = 1001, $aMemoryImage, $Struct
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Dim $aMemoryImage[$NumberSplits + 1][10] ; массив для хранения информации для сравнения
Global $hwnd, $posWin, $title = '', $emailUser, $URL_smsruUser, $sleepForCheckImage, $func = 0, $IndexCompare, $MaxIndexCompare = 1
Global $Form1 = 0, $paus = 0, $exitFunc = 0, $startFunc = '', $workFunc = ''
Global $PID = 0, $Prev1 = 0, $Prev2 = 0
;~ $UrlSendSMS = "http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text="
;~ $UrlSendSMS = "http://sms.ru/sms/send?api_id=124104f6-e803-4934-ad08-066e8b9493ea&to=79131042000&text="
Global $textMSG = 'Внимание, сработало событие! '
$sleepTrack = 1000
Opt("TrayMenuMode", 1 + 2)
Opt("TrayOnEventMode", 1)
$iExit = TrayCreateItem("Выйти")
TrayItemSetOnEvent(-1, "_quite")
$iMenu = TrayCreateItem("Меню")
TrayItemSetOnEvent(-1, "_GuiCreate")

_GuiCreate()
ConsoleWrite('действие выбрано '&$startFunc & @CRLF)
If $startFunc <> '' Then ConsoleWrite('действие выбрано '&$startFunc & @CRLF)
While 1
	Sleep(100)
	If $startFunc <> '' Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $startFunc = ' & $startFunc & @CRLF ) ;### Debug Console
		$workFunc = _getFuncDiscription($startFunc)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $workFunc = ' & $workFunc & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$nowFunc = $startFunc
		$startFunc = 0
		Execute($nowFunc)

	EndIf
WEnd



Func _Area()
	$i = 0
	While 1
		Sleep(100)
		$i += 1
		If Mod($i, 10) = 0 Then ConsoleWrite($i / 10 & @CRLF)
		if $exitFunc=1 then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $exitFunc = ' & $exitFunc & @CRLF ) ;### Debug Console
			$exitFunc=0
			return
		EndIf
	WEnd

EndFunc   ;==>_Area

Func _Dot()

	$i = 0
	While 1
		Sleep(100)
		$i += 1
		If Mod($i, 10) = 0 Then ConsoleWrite('DotClick' & $i / 10 & @CRLF)
		if $exitFunc=1 then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $exitFunc = ' & $exitFunc & @CRLF ) ;### Debug Console
			$exitFunc=0
			return
		EndIf
	WEnd
EndFunc   ;==>_Dot


Func _quite()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _quite() = ' & @CRLF) ;### Debug Console
	GUIDelete($Form1)
	Exit
EndFunc   ;==>_quite

Func _getFuncDiscription($func)
	Switch $func
		Case '_AreaClick()'
			Return '"Следить за областью"'
		Case '_Dot()'
			Return '"Следить за точкой"'
		Case '_WindowDrag()'
			Return '"Отодвинуть окно"'
		Case '_Area()'
			Return '"Следить за областью"'
		Case '_Proc()'
			Return '"Следить за загрузкой процесса"'
		Case '_Folder()'
			Return '"Следить за папкой"'
	EndSwitch
	if $func=0 then $func=''
	return $func
EndFunc   ;==>_getFuncDiscription

;~ Func _GuiShow()
;~ 	$exitFunc=1
;~ 	_GuiCreate()
;~ EndFunc

Func _GuiCreate()

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GuiCreate() = ' & @CRLF) ;### Debug Console
	If $Form1 == 0 Then
		#Region ### START Koda GUI section ### Form=D:\autoitv3.3.8.1\Прикладные\BackUp\form3.kxf
		$Form1 = GUICreate("Оповещение", 316, 401, 192, 114)
		Global $Group1 = GUICtrlCreateGroup("Опции отправки оповещения", 16, 8, 281, 121)
		Global $InputEmail = GUICtrlCreateInput("Введите Ваш Email", 23, 48, 265, 21)
		Global $InputSMSapi_id = GUICtrlCreateInput("Ваш api_id с сайта sms.ru", 23, 96, 241, 21)
		Global $CheckboxEmail = GUICtrlCreateCheckbox("Отправлять Email", 24, 32, 241, 17)
		GUICtrlSetState($CheckboxEmail, $GUI_CHECKED)
		Global $CheckboxSMSapi_id = GUICtrlCreateCheckbox("Отправить СМС", 24, 80, 241, 17)
		Global $ButtonQuestion = GUICtrlCreateButton("?", 272, 94, 17, 25)
		GUICtrlSetTip($ButtonQuestion, "Помощь по получению api_id для отправки СМС")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		Global $OK = GUICtrlCreateButton("Ручное управление", 160, 360, 139, 25)
		GUICtrlSetFont($OK, 8, 800, 0, "MS Sans Serif")
		GUICtrlSetTip($OK, "Это окно свернётся в трей и останется возможность запускать слежение сочетанием клавишь")
		Global $ButtonDot = GUICtrlCreateButton("Следить за точкой", 160, 328, 139, 25)
		GUICtrlSetTip($ButtonDot, "Слежение за изменением цвета пикселя на котором находится курсор")
		Global $ButtonWindowDrag = GUICtrlCreateButton("Отодвин. окно", 16, 328, 139, 25)
		GUICtrlSetTip($ButtonWindowDrag, "Отодвинуть окно за которым начато слежение, или начать слежение за всем окном" & @CRLF & "Окно отодвигается за границу экрана до того как слежение не будет закончено.")
		Global $ButtonArea = GUICtrlCreateButton("Следить за областью", 16, 296, 139, 25)
		GUICtrlSetTip($ButtonArea, "Слежение за прямоугольной областью в определенном окне")
		Global $ButtonProc = GUICtrlCreateButton("Следить за процессом", 160, 296, 139, 25)
		GUICtrlSetTip($ButtonProc, "Слежение за загрженностью процессора определеным процессом")
		Global $Group2 = GUICtrlCreateGroup("Кнопки для ручного управления", 16, 136, 281, 153)
		Global $Label8 = GUICtrlCreateLabel("Shift+F2 - Следить за точкой", 24, 160, 146, 17)
		GUICtrlSetTip($Label8, "Слежение за изменением цвета пикселя на котором находится курсор")
		Global $Label9 = GUICtrlCreateLabel("Shift+F3 - Следить за областью в окне*", 24, 176, 201, 17)
		GUICtrlSetTip($Label9, "Слежение за прямоугольной областью в определенном окне")
		Global $Label10 = GUICtrlCreateLabel("Shift+F4 - Следить за загрузкой процесса", 24, 192, 215, 17)
		GUICtrlSetTip($Label10, "Слежение за загрженностью процессора определеным процессом")
		Global $Label11 = GUICtrlCreateLabel("Shift+F5 - Отодвинуть окно*", 24, 208, 142, 17)
		GUICtrlSetTip($Label11, "Отодвинуть окно за которым начато слежение, или начать слежение за всем окном" & @CRLF & "Окно отодвигается за границу экрана до того как слежение не будет закончено.")
		Global $Label12 = GUICtrlCreateLabel("Shift+F6 - Следить за папкой", 24, 224, 148, 17)
		GUICtrlSetTip($Label12, "Слежение за папкой на предмет начала или конеца изменений в папке, " & @CRLF & "появления/исчезновения файла(ов), изменение даты модификации файла(ов)")
		Global $Label2 = GUICtrlCreateLabel("Shift+Esc - Выход", 24, 240, 90, 17)
		GUICtrlSetTip($Label2, "Заканчивает работу с приложением, также для этого вы можете использовать правый клик по значку в трее")
		Global $Label1 = GUICtrlCreateLabel("* Функции ещё не реализованы", 24, 264, 167, 17)
		GUICtrlSetTip($Label1, "Заканчивает работу с приложением, также для этого вы можете использовать правый клик по значку в трее")
		GUICtrlCreateGroup("", -99, -99, 1, 1)
		Global $ButtonFolder = GUICtrlCreateButton("Следить за папкой", 16, 359, 139, 25)
		GUICtrlSetTip($ButtonFolder, "Слежение за папкой на предмет начала или конеца изменений в папке, " & @CRLF & "появления/исчезновения файла(ов), изменение даты модификации файла(ов)")
		GUISetState(@SW_SHOW)
		#EndRegion ### END Koda GUI section ###
	Else
		GUISetState(@SW_SHOW, $Form1)

	EndIf

	if $workFunc<>'' then GUICtrlSetData($OK, 'Продолжить выполнение')

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

			Case $Form1
			Case $InputEmail
			Case $InputSMSapi_id
			Case $CheckboxEmail
			Case $CheckboxSMSapi_id
			Case $ButtonQuestion
			Case $OK
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : OKClick() = ' & @CRLF) ;### Debug Console
				GUISetState(@SW_HIDE, $Form1)
				ExitLoop
			Case $ButtonDot
				If _startFromGUI('_Dot()') = 1 Then return
			Case $ButtonWindowDrag
			Case $ButtonArea
				If _startFromGUI('_Area()') = 1 Then return
			Case $ButtonProc
			Case $Label8
			Case $Label9
			Case $Label10
			Case $Label11
			Case $Label12
			Case $Label2
			Case $Label1
			Case $ButtonFolder
		EndSwitch
		Sleep(100)
	WEnd
EndFunc   ;==>_GuiCreate

Func _startFromGUI($func)
	$t = 1
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $workFunc = ' & $workFunc & @CRLF ) ;### Debug Console
	If $workFunc <> '' Then
		$t = MsgBox(1, 'Предупреждение', 'В данные момент выполняется функция ' & $workFunc & @CRLF & 'Если продолжить её выполнение остановиться')
	EndIf
	If $t = 1 Then
		If $workFunc <> '' Then
			$exitFunc=1
		EndIf
		$startFunc = $func
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $startFunc = ' & $startFunc & @CRLF ) ;### Debug Console
		GUISetState(@SW_HIDE, $Form1)
		TrayTip('Подсказка', 'Слежение запущено'&@CRLF&'Вы также можете использовать сочетания клавиш, или вызвать меню на значек в трее', 5000)
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_startFromGUI


