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

HotKeySet("+{ESC}", "_quite")
HotKeySet("+{F2}", "_Dot") ;'"Следить за точкой"'
HotKeySet("+{F3}", "_Area") ; '"Следить за областью"'
HotKeySet("+{F4}", "_Proc") ;'"Следить за загрузкой процесса"'
HotKeySet("+{F5}", "_WindowDrag") ;'"Отодвинуть окно"'
HotKeySet("+{F6}", "_Folder") ;'"Следить за папкой"'

Global $NumberSplits = 1001, $aMemoryImage, $Struct
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Dim $aMemoryImage[$NumberSplits + 1][10] ; массив для хранения информации для сравнения
Global $hwnd, $posWin, $title = '', $emailUser, $sleepForCheckImage, $func = 0, $IndexCompare, $MaxIndexCompare = 1
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
ConsoleWrite('действие выбрано ' & $startFunc & @CRLF)
If $startFunc <> '' Then ConsoleWrite('действие выбрано ' & $startFunc & @CRLF)
While 1
	Sleep(100)
	If $startFunc <> '' Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $startFunc = ' & $startFunc & @CRLF) ;### Debug Console
		$workFunc = _getFuncDiscription($startFunc)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $workFunc = ' & $workFunc & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$nowFunc = $startFunc
		$startFunc = 0
		Execute($nowFunc)

	EndIf
WEnd



Func _Area()
	TrayTip('Подсказка', 'Эта функция ещё не реалиязована, запустите другую', 5000)
	$i = 0
	While 1
		Sleep(100)
		$i += 1
		If Mod($i, 10) = 0 Then ConsoleWrite($i / 10 & @CRLF)
		If $exitFunc = 1 Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $exitFunc = ' & $exitFunc & @CRLF) ;### Debug Console
			$exitFunc = 0
			Return
		EndIf
	WEnd

EndFunc   ;==>_Area

Func _Dot()

	$i = 0
	While 1
		Sleep(100)
		$i += 1
		If Mod($i, 10) = 0 Then ConsoleWrite('DotClick' & $i / 10 & @CRLF)
		If $exitFunc = 1 Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $exitFunc = ' & $exitFunc & @CRLF) ;### Debug Console
			$exitFunc = 0
			Return
		EndIf
	WEnd
EndFunc   ;==>_Dot

Func _WindowDrag()
	TrayTip('Подсказка', 'Эта функция ещё не реалиязована, запустите другую', 5000)
EndFunc   ;==>_WindowDrag
Func _Proc()
	TrayTip('Подсказка', 'Эта функция ещё не реалиязована, запустите другую', 5000)
EndFunc   ;==>_Proc
Func _Folder()
	TrayTip('Подсказка', 'Эта функция ещё не реалиязована, запустите другую', 5000)
EndFunc   ;==>_Folder

#Region ; Функции слежения за занрузкой процесса
Func _Proc()
	$sleepProc = 1000 ; частота проверки загруженности в мс.
	$CPUMin = 5 ; Минимальный парог процента нагрузки CPU для срабатывания
	$q = 60000 ; время в течении которого должен сохранятся минимальный парог
	$mod = 0 ; Режим любой из процессов = 0, все процессы = 1
	$ID = InputBox('Введите', 'Введите PID (номер) процесса, можно несколько через "|"', '8040') ; Запрос на ID процесса
	If @error > 0 Then Exit
	$aId = StringSplit($ID, '|')
	_ArrayDisplay($aId)
	Local $schet[$aId[0] + 1], $t[$aId[0] + 1], $exit[$aId[0] + 1]
	For $i = 1 To $aId[0]
		$schet[$i] = 0
		$t[$i] = TimerInit()
		$exit[$i] = 0
		$p = _CPU($aId[$i])
	Next
	Sleep($sleepProc)
	While 1
		For $i = 1 To $aId[0]
			$p = _CPU($aId[$i])
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : 	$p' & $i & ' = ' & $p & @CRLF) ;### Debug Console
			If $p < $CPUMin Then
				If $schet[$i] = 0 Then $t[$i] = TimerInit()
				$schet[$i] += 1
			Else
				$schet[$i] = 0
			EndIf
			If Not ProcessExists($aId[$i]) Then $exit[$i] = 1
			If $schet > 1 And TimerDiff($t[$i]) > $q Then $exit[$i] = 1
			If $mod = 0 And $exit[$i] = 1 Then ExitLoop 2
		Next
		If _arraysumm($exit) >= $aId[0] Then ExitLoop
		Sleep($sleepProc)
	WEnd
	_SendMail('newlogin7@gmail.com', 'Сообщение из файла: Оповещение', $textMSG)
	$t = MsgBox(1, 'Внимание', $textMSG, 30)
	If $t = 2 Then Return 1
	_sendSMS($textMSG, $UrlSendSMS, 2)
	ConsoleWrite($textMSG & @CRLF)
EndFunc   ;==>_Proc

Func _arraysumm(ByRef $array)
	Local $summ = 0
	For $i = 0 To UBound($array) - 1
		$summ += $array[$i]
	Next
	Return $summ
EndFunc   ;==>_arraysumm


Func _CPU($sProcess)
	Local $ID, $Time1, $Time2, $CPU
	$ID = ProcessExists($sProcess)
	If $ID Then
		$Time1 = _WinAPI_GetProcessTimes($ID)
		$Time2 = _WinAPI_GetSystemTimes()
		If (IsArray($Time1)) And (IsArray($Time2)) Then
			$Time1 = $Time1[1] + $Time1[2]
			$Time2 = $Time2[1] + $Time2[2]
			If ($Prev1) And ($Prev2) And ($PID = $ID) Then
				$CPU = Round(($Time1 - $Prev1) / ($Time2 - $Prev2) * 100)
			EndIf
			$Prev1 = $Time1
			$Prev2 = $Time2
			$PID = $ID
			Return $CPU
		EndIf
	EndIf
	$Prev1 = 0
	$Prev2 = 0
	$PID = 0
EndFunc   ;==>_CPU

#EndRegion  ; Функции слежения за занрузкой процесса

Func _quite()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _quite() = ' & @CRLF) ;### Debug Console
	GUIDelete($Form1)
	Exit
EndFunc   ;==>_quite

#Region ; Графический интерфейс GUI и всё что ему необходимо

Func _GuiCreate()

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GuiCreate() = ' & @CRLF) ;### Debug Console
	;Если запуск в первый раз то нарисовать GUI, далее оно будет просто прятаться и показыаться
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
		GUISetState(@SW_SHOW, $Form1) ;Показать GUI

	EndIf

	If $workFunc <> '' Then GUICtrlSetData($OK, 'Продолж. выполнение') ;Изменение текста кнопки

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
				If _startFromGUI('_Dot()') = 1 Then Return
			Case $ButtonWindowDrag
			Case $ButtonArea
				If _startFromGUI('_Area()') = 1 Then Return
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

;Вспомогательная функция для GUI, помогает запуску функций после выбора кнопки
Func _startFromGUI($func)
	$t = 1
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $workFunc = ' & $workFunc & @CRLF) ;### Debug Console
	If $workFunc <> '' Then
		$t = MsgBox(1, 'Предупреждение', 'В данные момент выполняется функция ' & $workFunc & @CRLF & 'Если продолжить её выполнение остановиться')
	EndIf
	If $t = 1 Then
		If $workFunc <> '' Then
			$exitFunc = 1
		EndIf
		$startFunc = $func
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $startFunc = ' & $startFunc & @CRLF) ;### Debug Console
		GUISetState(@SW_HIDE, $Form1)
		TrayTip('Подсказка', 'Слежение запущено' & @CRLF & 'Вы также можете использовать сочетания клавиш, или вызвать меню на значек в трее', 5000)
		Return 1
	Else
		Return 0
	EndIf
EndFunc   ;==>_startFromGUI

;Получение осмысленного описания по имени функции
Func _getFuncDiscription($func)
	Switch $func
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
	If $func = 0 Then $func = ''
	Return $func
EndFunc   ;==>_getFuncDiscription

#EndRegion ; Графический интерфейс GUI и всё что ему необходимо

#Region ; Функции отправки смс и email

;Управляющяя функция для отправки email, она начинает и завершает отправку
Func _SendMail($ToAddress, $subject, $body)
	$error = 0
	$FromAddress = 'teamviewer.print@mail.ru'
	$Username = $FromAddress
	$Password = 'iopTHN1!'
	$SMTPServer = 'smtp.mail.ru'
	$Port = '465'
	_SendMailSimple($ToAddress, $subject, $body, $Username, $Password, $SMTPServer, $FromAddress)
	If @error = 2 Then _INetSmtpMailCom($SMTPServer, '', $FromAddress, $ToAddress, $subject, $body, '', '', '', $Username, $Password)
	; резервный email для отправки
	If @error = 2 Then
		$SMTPServer = 'smtp.yandex.ru'
		$FromAddress = 'new1ogin@yandex.ru'
		$Username = $FromAddress
		$Password = 'iopTHN!#'
		_SendMailSimple($ToAddress, $subject, $body, $Username, $Password, $SMTPServer, $FromAddress)
		If @error = 2 Then _INetSmtpMailCom($SMTPServer, '', $FromAddress, $ToAddress, $subject, $body, '', '', '', $Username, $Password)
		; резервный email для отправки
		If @error = 2 Then
			$FromAddress = 'ivantea@list.ru'
			$Username = $FromAddress
			$Password = 'iopthn'
			_SendMailSimple($ToAddress, $subject, $body, $Username, $Password, $SMTPServer, $FromAddress)
			If @error = 2 Then _INetSmtpMailCom($SMTPServer, '', $FromAddress, $ToAddress, $subject, $body, '', '', '', $Username, $Password)
			If @error = 2 Then $error = 1
		EndIf
	EndIf
	If $error = 1 Then MsgBox(0, ' Ошибка', 'Не удалось отпрвить email на адрес: ' & $ToAddress, 10)

EndFunc   ;==>_SendMail

;простая функция отправки email
Func _SendMailSimple($ToAddress, $subject, $body, $Login, $Password, $SMTPServer, $FromAddress, $Port = '465', $Attachment = '')
	ConsoleWrite(' Используется email для отправки через функуию _SendMailSimple: ' & $Login & @CRLF)
	$str = "http://schemas.microsoft.com/cdo/configuration/"


	$hMAIL = ObjCreate("CDO.Message")

	$hMAIL.Configuration.Fields.Item($str & "sendusing") = 2
	$hMAIL.Configuration.Fields.Item($str & "smtpserver") = $SMTPServer
	$hMAIL.Configuration.Fields.Item($str & "smtpauthenticate") = 1
	$hMAIL.Configuration.Fields.Item($str & "sendusername") = $Login
	$hMAIL.Configuration.Fields.Item($str & "sendpassword") = $Password
	$hMAIL.Configuration.Fields.Item($str & "smtpserverport") = $Port
	$hMAIL.Configuration.Fields.Item($str & "smtpusessl") = True

	$hMAIL.Configuration.Fields.Update

	$hMAIL.From = $FromAddress
	$hMAIL.To = $ToAddress
	$hMAIL.Subject = $subject
	$hMAIL.TextBody = $body
	$hMAIL.AddAttachment($Attachment)
	$hMAIL.Send
	If @error Then
		SetError(2)
	EndIf
EndFunc   ;==>_SendMailSimple

;Запасная функция отправки email, вдруг на каких то окмпах она сработает а обычная не сработает
Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $s_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 1)
	ConsoleWrite(' Используется email для отправки через функуию _INetSmtpMailCom: ' & $s_ToAddress & @CRLF)
	$objEmail = ObjCreate("CDO.Message")
	$objEmail.From = '"' & $s_FromName & '" <' & $s_FromAddress & '>'
	$objEmail.To = $s_ToAddress
	Local $i_Error = 0
	Local $i_Error_desciption = ""
	If $s_CcAddress <> "" Then $objEmail.Cc = $s_CcAddress
	If $s_BccAddress <> "" Then $objEmail.Bcc = $s_BccAddress
	$objEmail.Subject = $s_Subject
	If StringInStr($s_Body, "<") And StringInStr($s_Body, ">") Then
		$objEmail.HTMLBody = $s_Body
	Else
		$objEmail.Textbody = $s_Body & @CRLF
	EndIf
	If $s_AttachFiles <> "" Then
		Local $S_Files2Attach = StringSplit($s_AttachFiles, ";")
		For $x = 1 To $S_Files2Attach[0]
			$S_Files2Attach[$x] = _PathFull($S_Files2Attach[$x])
			If FileExists($S_Files2Attach[$x]) Then
				$objEmail.AddAttachment($S_Files2Attach[$x])
			Else
				$i_Error_desciption = $i_Error_desciption & @LF & 'File not found to attach: ' & $S_Files2Attach[$x]
				SetError(1)
				Return 0
			EndIf
		Next
	EndIf
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusing") = 2
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserver") = $s_SmtpServer
	$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpserverport") = $IPPort
	If $s_Username <> "" Then
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpauthenticate") = 1
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendusername") = $s_Username
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/sendpassword") = $s_Password
	EndIf
	If $ssl Then
		$objEmail.Configuration.Fields.Item("http://schemas.microsoft.com/cdo/configuration/smtpusessl") = True
	EndIf
	$objEmail.Configuration.Fields.Update
	$objEmail.Send
	If @error Then
		SetError(2)
	EndIf
EndFunc   ;==>_INetSmtpMailCom

;Первая функция отправки смс, подготовка текста к отправке
Func _sendSMS($text, $UrlSendSMS, $MaxCost = 0)
	$maxSymbols = 160
	$params = '&translit=1'
	$text = StringReplace($text, @CRLF, " ") ;Замена перевода картетки
	$text = _Trans($text) ; Транслитерация сообщения
	;Замена всех симолов кроме допустимых
	$LatimSymbols = "[^'" & '~$^[{}@_"=+!%*(),.?;abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890:-]'
	; Символы # & убираються из-за несовместимоси со тсракой адреса HTTP. По данным другого сайта, это тоже недопустимые символы, но это бред уже какой то, < > ‘ ; ” | [ ] { } ^ &
	$text = StringRegExpReplace($text, $LatimSymbols, '')
	;проверка длинны строки
	If StringLen($text) > $maxSymbols Then
		$text = StringMid($text, 1, $maxSymbols)
	EndIf
	; Уменьшение длины строки за счет спец символов идущих в смс за два символа
	$countSpecSymbols = StringSplit($text, '~^[]{}\|')
	$maxSymbols = $maxSymbols - ($countSpecSymbols[0] - 1)
	If StringLen($text) > $maxSymbols Then
		$text = StringMid($text, 1, $maxSymbols)
	EndIf

	ConsoleWrite("'" & $text & "'" & @CRLF)
	$text = StringReplace($text, "+", "plus") ; замена символа + словом plus
	$text = StringReplace($text, " ", "+")
	_sendSMStext($UrlSendSMS, $text, $params, $MaxCost)

;~ 	_ArrayDisplay($aReplyHTML)
EndFunc   ;==>_sendSMS

;Вторая функция отправки смс, проверка стоимости и отправка
Func _sendSMStext($UrlSendSMS, $text, $params, $MaxCost)
	$origtext = $text
	;Предварительная проверка
	$textlenght = StringLen($text)
	Dim $aTests[3] = [0.9, 0.5, 0.1]
	$aReplyHTML = _TestCostSMS($UrlSendSMS, $text, $params)
	If $aReplyHTML[2] > $MaxCost Then
		For $i = 0 To UBound($aTests) - 1
			$text = StringMid($text, 1, Round($aTests[$i] * $textlenght))
			$aReplyHTML = _TestCostSMS($UrlSendSMS, $text, $params)
			If $aReplyHTML[2] <= $MaxCost Then
				ExitLoop
			EndIf
		Next
	EndIf

	If $aReplyHTML[2] <= $MaxCost Then
		; Отправка
		$site = $UrlSendSMS & $text & $params
		$HTML = _INetGetSource($site)
		$aReplyHTML = StringSplit(StringReplace($HTML, @CR, ''), @LF)
		ConsoleWrite('$HTML = ' & $HTML & @CRLF)
	Else
		$aReplyHTML = _TestCostSMS($UrlSendSMS, $origtext, $params)
		MsgBox(0, " Внимание ", " Смс Не отправлено, так как превышена максимально допустимая стоймость отправки. Стоимость этого СМС:" & @CRLF & $origtext & @CRLF & " сотавили бы: " & $aReplyHTML[2] & ' руб.')
	EndIf
	If $aReplyHTML[1] <> 100 Then MsgBox(0, " Внимание ", " Смс отправлено с ошибкой! Код Ошибки: " & $aReplyHTML[1])


EndFunc   ;==>_sendSMStext

;Функция проверки стоимости смс сообщения
Func _TestCostSMS($UrlSendSMS, $text, $params) ;Предварительная проверка
	$CostUrlSendSMS = StringReplace($UrlSendSMS, 'sms/send', 'sms/cost')
	$site = $CostUrlSendSMS & $text & $params
	$HTML = _INetGetSource($site)
	$aReplyHTML = StringSplit(StringReplace($HTML, @CR, ''), @LF)
	Return $aReplyHTML
EndFunc   ;==>_TestCostSMS

;Функция транслитерации текста
Func _Trans($iText)
	Dim $aLetters[136][2] = [['ья', 'ia'], ['Ья', 'ia'], ['ьЯ', 'iA'], ['ЬЯ', 'iA'], ['ий ', 'iy '], ['ой ', 'oy '], ['ее ', 'eye '], ['ое ', 'oye '], ['ая ', 'aya '], ['яя ', 'yaya '], ['ия ', 'iya '], ['ие ', 'iye '], ['ые ', 'yye '], ['ый ', 'iy '], ['ИЙ ', 'IY '], ['ОЙ ', 'OY '], ['ЕЕ ', 'EYE '], ['ОЕ ', 'OYE '], ['АЯ ', 'AYA '], ['ЯЯ ', 'YAYA '], ['ИЯ ', 'IYA '], ['ИЕ ', 'IYE '], ['ЫЕ ', 'YYE '], ['ЫЙ ', 'IY '], [' Е', ' Ye'], [' е', ' ye'], ['ЙЕ', 'YYe'], ['ЪЕ', '"Ye'], ['ЬЕ', "'Ye"], ['АЕ', 'AYe'], ['УЕ', 'UYe'], ['ОЕ', 'OYe'], ['ЫЕ', 'yYe'], ['ИЕ', 'IYe'], ['ЭЕ', 'EYe'], ['ЯЕ', 'YaYe'], ['ЮЕ', 'YuYe'], ['йе', 'yye'], ['ъе', '"ye'], ['ье', "'ye"], ['ае', 'aye'], ['уе', 'uye'], ['ое', 'oye'], ['ые', 'yye'], ['ие', 'iye'], ['эе', 'eye'], ['яе', 'yaye'], ['юе', 'yuye'], ['Йе', 'Yye'], ['Ъе', "'ye"], ['Ье', "'ye"], ['Ае', 'Aye'], ['Уе', 'Uye'], ['Ое', 'Oye'], ['Ые', 'yye'], ['Ие', 'Iye'], ['Эе', 'Eye'], ['Яе', 'Yaye'], ['Юе', 'Yuye'], ['йЕ', 'yYe'], ['ъЕ', '"Ye'], ['ьЕ', "'Ye"], ['аЕ', 'aYe'], ['уЕ', 'uYe'], ['оЕ', 'oYe'], ['ыЕ', 'yYe'], ['иЕ', 'iYe'], ['эЕ', 'eYe'], ['яЕ', 'yaYe'], ['юЕ', 'yuYe'], ['А', 'A'], ['Б', 'B'], ['В', 'V'], ['Г', 'G'], ['Д', 'D'], ['Е', 'E'], ['Ё', 'Yo'], ['Ж', 'Zh'], ['З', 'Z'], ['И', 'I'], ['Й', 'Y'], ['К', 'K'], ['Л', 'L'], ['М', 'M'], ['Н', 'N'], ['О', 'O'], ['П', 'P'], ['Р', 'R'], ['С', 'S'], ['Т', 'T'], ['У', 'U'], ['Ф', 'F'], ['Х', 'Kh'], ['Ц', 'Ts'], ['Ч', 'Ch'], ['Ш', 'Sh'], ['Щ', 'Shch'], ['Ъ', '"'], ['Ы', 'y'], ['Ь', "'"], ['Э', 'E'], ['Ю', 'Yu'], ['Я', 'Ya'], ['а', 'a'], ['б', 'b'], ['в', 'v'], ['г', 'g'], ['д', 'd'], ['е', 'e'], ['ё', 'e'], ['ж', 'zh'], ['з', 'z'], ['и', 'i'], ['й', 'y'], ['к', 'k'], ['л', 'l'], ['м', 'm'], ['н', 'n'], ['о', 'o'], ['п', 'p'], ['р', 'r'], ['с', 's'], ['т', 't'], ['у', 'u'], ['ф', 'f'], ['х', 'kh'], ['ц', 'ts'], ['ч', 'ch'], ['ш', 'sh'], ['щ', 'shch'], ['ъ', '"'], ['ы', 'y'], ['ь', "'"], ['э', 'e'], ['ю', 'yu'], ['я', 'ya']]
	$sBuffer = $iText
	For $i = 0 To UBound($aLetters) - 1
		$sBuffer = StringRegExpReplace($sBuffer, $aLetters[$i][0], $aLetters[$i][1])
	Next
	$sBuffer = StringRegExpReplace($sBuffer, '[а-яёА-ЯЁ]', '')
	Return $sBuffer
EndFunc   ;==>_Tras


#EndRegion  ; Функции отправки смс и email

; Com Error Handler
Func MyErrFunc()
	$HexNumber = Hex($oMyError.number, 8)
	$oMyRet[0] = $HexNumber
	$oMyRet[1] = StringStripWS($oMyError.description, 3)
	ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
	SetError(1); something to check for when this function returns
	Return
EndFunc   ;==>MyErrFunc
