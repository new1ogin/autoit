;~ #AutoIt3Wrapper_Run_AU3Check=n
#include <array.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
;~ #include <Crypt.au3>
#include <INet.au3>

global $NumberSplits = 1001, $aMemoryImage, $Struct
Dim $aMemoryImage[$NumberSplits+1][10] ; массив для хранения информации для сравнения
global $hwnd, $posWin, $title = '', $emailUser, $URL_smsruUser, $sleepForCheckImage, $func=0, $IndexCompare, $MaxIndexCompare = 1
HotKeySet("{F7}", "_GetWindow") ;Это вызов
HotKeySet("{^F7}", "_quite") ;Это вызов
$sleepForCheckImage=750
_GUI()
;~ exit
While 1
	Sleep(100)
	if $func=1 then _func()
WEnd



;~ _ArrayDisplay($posWin)
dim $array[10]
dim $array2[10]
For $i=0 to 9
	$array[$i] = PixelChecksum ( $posWin[0], $posWin[1], $posWin[0]+$posWin[2], $posWin[1]+$posWin[3], 1, $hwnd, 1)
	sleep($sleepForCheckImage)
Next
For $i=0 to 9
;~ 	$array[$i]
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $array[$i] = ' & $array[$i] & @CRLF) ;### Debug Console
Next


Func _GUI()
	#include <ButtonConstants.au3>
	#include <EditConstants.au3>
	#include <GUIConstantsEx.au3>
	#include <StaticConstants.au3>
	#include <WindowsConstants.au3>
	Opt("GUIOnEventMode", 1)
	#Region ### START Koda GUI section ### Form=D:\autoitv3.3.8.1\Koda\Forms\Window_Change.kxf
	$Window_Change = GUICreate("Изменение в окне и оповещение", 530, 357, 751, 336)
	GUISetOnEvent($GUI_EVENT_CLOSE, "Window_ChangeClose")
	GUISetOnEvent($GUI_EVENT_MINIMIZE, "Window_ChangeMinimize")
	GUISetOnEvent($GUI_EVENT_MAXIMIZE, "Window_ChangeMaximize")
	GUISetOnEvent($GUI_EVENT_RESTORE, "Window_ChangeRestore")
	$Info1 = GUICtrlCreateLabel("Выберите окно за которым надо следить и нажмите F7", 8, 8, 287, 17)
	GUICtrlSetOnEvent(-1, "Info1Click")
	$Info2 = GUICtrlCreateLabel("Выбранное окно:", 8, 24, 132, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetOnEvent(-1, "Info2Click")
	global $SelectWindowInfo = GUICtrlCreateLabel("Ещё не выбрано", 8, 49, 128, 24)
	GUICtrlSetFont(-1, 12, 400, 0, "MS Sans Serif")
	GUICtrlSetOnEvent(-1, "SelectWindowInfoClick")
	$Group1 = GUICtrlCreateGroup("Способы оповещения", 8, 80, 513, 145)
	$Info3 = GUICtrlCreateLabel("По e-mail адресу:", 16, 104, 89, 17)
	GUICtrlSetOnEvent(-1, "Info3Click")
	global $email = GUICtrlCreateInput("newlogin7@gmail.com", 16, 124, 497, 21)
	GUICtrlSetOnEvent(-1, "emailChange")
	$Info4 = GUICtrlCreateLabel("По SMS (sms.ru)", 15, 150, 83, 17)
	GUICtrlSetOnEvent(-1, "Info4Click")
	global $URL_smsru = GUICtrlCreateInput("http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text=", 15, 170, 497, 21)
	GUICtrlSetOnEvent(-1, "URL_smsruChange")
	$Label2 = GUICtrlCreateLabel("Максимальная стоимость отправки SMS сообщения:", 16, 196, 277, 17)
	GUICtrlSetOnEvent(-1, "Label2Click")
	$Cost = GUICtrlCreateInput("0", 296, 192, 49, 21)
	GUICtrlSetOnEvent(-1, "CostChange")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Start = GUICtrlCreateButton("Начать", 56, 320, 160, 25)
	GUICtrlSetOnEvent(-1, "StartClick")
	$Group2 = GUICtrlCreateGroup("Настройки", 8, 232, 513, 73)
	$Info5 = GUICtrlCreateLabel("Частота обновления в мс:", 16, 252, 138, 17)
	GUICtrlSetOnEvent(-1, "Info5Click")
	global $Sleep = GUICtrlCreateInput("1000", 160, 248, 121, 21)
	GUICtrlSetOnEvent(-1, "SleepChange")
	$Label1 = GUICtrlCreateLabel("Количество вариантов изображения:", 290, 252, 193, 17)
	GUICtrlSetOnEvent(-1, "Label1Click")
	global $QCheckSummsImage = GUICtrlCreateLabel("0", 487, 252, 10, 17)
	GUICtrlSetOnEvent(-1, "QCheckSummsImageClick")
	$Label3 = GUICtrlCreateLabel("Минимальный процент изменений для реагирования:", 16, 280, 278, 17)
	GUICtrlSetOnEvent(-1, "Label3Click")
	global $IndexCompar = GUICtrlCreateInput("3", 296, 276, 41, 21)
	GUICtrlSetOnEvent(-1, "IndexComparChange")
	$Label4 = GUICtrlCreateLabel("%", 340, 280, 12, 17)
	GUICtrlSetOnEvent(-1, "Label4Click")
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$Cancel = GUICtrlCreateButton("Отменить", 310, 320, 160, 25)
	GUICtrlSetOnEvent(-1, "CancelClick")
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

EndFunc

Func _getWindow()
	$hwnd = WinGetHandle("[ACTIVE]")
	$posWin = WinGetPos($hwnd)
	$title = WinGetTitle($hwnd)
	GUICtrlSetData($SelectWindowInfo,"" & StringLeft($title,50) & '...')
EndFunc

Func StartClick()
	if $title == '' Then
		Msgbox(0,"Ошибка"," Сначала выберите окно за которым надо следить и нажмите F7")
	Else

	$emailUser = GUICtrlRead($email)
	$URL_smsruUser = GUICtrlRead($URL_smsru)
	$sleepForCheckImage = GUICtrlRead($Sleep)
	$MaxIndexCompare = GUICtrlRead($IndexCompar)
	$func = 1
	Endif
EndFunc

Func _func()

	$schet = 0

	; генерируем строку для создание структуры
	$Struct = ''
	For $i=1 to $NumberSplits
		$Struct &= 'byte[' & Ceiling(($posWin[2] * $posWin[3] * 4)/$NumberSplits) & '];'
	Next
	$Struct &= 'byte[' & ($posWin[2] * $posWin[3] * 4)-Ceiling(($posWin[2] * $posWin[3] * 4)/$NumberSplits)*($NumberSplits-1) & ']'
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($Struct) = ' & StringLen($Struct) & @CRLF) ;### Debug Console
	;цикл поиска/сравнения

	While 1
;~ 		$IndexCompare = 0
		$posWin = WinGetPos($hwnd)
		$timer = TimerInit()
;~ 		if $schet = 0 then
;~ 			$IndexCompare = _CompareImage($hWnd,$posWin,0)
;~ 		Else
;~ 			$IndexCompare = _CompareImage($hWnd,$posWin)
;~ 		EndIf
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd, $posWin[2], $posWin[3]))
	$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $posWin[2], $posWin[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$tData = DllStructCreate($Struct, DllStructGetData($tMap, 'Scan0'))
	if $schet = 0 then
		For $i = 1 To $NumberSplits
			$aMemoryImage[$i][0] = DllStructGetData($tData, $i)
		Next
	Else
		For $i = 1 To $NumberSplits
			if $aMemoryImage[$i][0] <> DllStructGetData($tData, $i) Then $IndexCompare += 1
		Next
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tMap)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()

	$IndexCompare = 100*$IndexCompare/$NumberSplits
		$t_End = Round(TimerDiff($timer),2)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $IndexCompare = ' & $IndexCompare & '%' & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t_End = ' & $t_End & "   Len="&0 & "   DATA="&0 & @CRLF) ;### Debug Console
		$schet+=1
		if $IndexCompare > $MaxIndexCompare Then exitloop
		sleep($sleepForCheckImage)
	WEnd
		_SendMail($emailUser,  'Отчёт', 'Внимание! В Окне '&$title&' произошли изменения! Процент изменений составил: '&$IndexCompare&'%')
;~ 		_sendSMS('В Окне '&StringLeft($title,70)&' произошли изменения! Процент изменений составил: '&$IndexCompare&'%',$URL_smsruUser)
		exit
EndFunc

#include <WinAPI.au3>
#include <ScreenCapture.au3>
global $NumberSplits = 100, $aMemoryImage, $Struct, $NumTables=0
Dim $aMemoryImage[$NumberSplits+1][10] ; массив для хранения информации для сравнения. Вторая размерность массива [10] - максимальное число сравнений

Func _CompareImageWin($hWnd,$mod=-1)
	$IndexCompare=0
	$posWin = WinGetPos($hwnd)

	;генерируем строку для создание структуры
	if not $Struct Then
		$Struct = ''
		For $i=1 to $NumberSplits
			$Struct &= 'byte[' & Ceiling(($posWin[2] * $posWin[3] * 4)/$NumberSplits) & '];'
		Next
		$Struct &= 'byte[' & ($posWin[2] * $posWin[3] * 4)-Ceiling(($posWin[2] * $posWin[3] * 4)/$NumberSplits)*($NumberSplits-1) & ']'
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($Struct) = ' & StringLen($Struct) & @CRLF) ;### Debug Console
	EndIf

	;цикл поиска/сравнения
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd, $posWin[2], $posWin[3]))
	$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $posWin[2], $posWin[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$tData = DllStructCreate($Struct, DllStructGetData($tMap, 'Scan0'))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : DllStructGetData($tData, $i) = ' & StringLeft(DllStructGetData($tData, 2),1000) & @CRLF) ;### Debug Console

	; проверка на пустое возвращение
;~ 	For $i = 1 To $NumberSplits
;~ 		$timer = Timerinit()
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen(DllStructGetData($tData, $i)) = ' & StringLen(DllStructGetData($tData, $i)) & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : TimerDiff($timer)1 = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
;~ 		$timer = Timerinit()
;~ 		StringReplace(DllStructGetData($tData, $i),'000000',"")
;~ 		ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : TimerDiff($timer)1 = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen(DllStructGetData($tData, $i)) = ' & StringLen(DllStructGetData($tData, $i)) & @CRLF) ;### Debug Console
;~ 		exit
;~ 	Next
	if $mod = 0 then
		$test=0
		For $i = 1 To $NumberSplits ; Заполняем таблицу уникальными данными
			$tempData = DllStructGetData($tData, $i)
			if $aMemoryImage[$i][0] <> $tempData Then
				$aMemoryImage[$i][$NumTables] = $tempData
				$test+=1
			EndIf
		Next
		if $test<>0 Then $NumTables +=1
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $test = ' & $test & @CRLF) ;### Debug Console
	Else
		For $i = 1 To $NumberSplits
			$test=0
			For $j = 0 to $NumTables
				if $aMemoryImage[$i][$j] Then ;Если ячейка заполнена, то сравниваем
					if $aMemoryImage[$i][$j] <> DllStructGetData($tData, $i) Then $test += 1
					$test-=1
				EndIf
			Next
			if $test=0 Then $IndexCompare += 1
		Next
;~ 		_ArrayDisplay($aMemoryImage)
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tMap)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()

	$IndexCompare = 100*$IndexCompare/$NumberSplits
	return $IndexCompare
EndFunc

Func _CompareImage($hWnd,$posWin,$mod=-1)
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd, $posWin[2], $posWin[3]))
	$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $posWin[2], $posWin[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$tData = DllStructCreate($Struct, DllStructGetData($tMap, 'Scan0'))
	if $mod = 0 then
		For $i = 1 To $NumberSplits
			$aMemoryImage[$i][0] = DllStructGetData($tData, $i)
		Next
	Else
		For $i = 1 To $NumberSplits
			if $aMemoryImage[$i][0] <> DllStructGetData($tData, $i) Then $IndexCompare += 1
		Next
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tMap)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()

	return $IndexCompare = 100*$IndexCompare/$NumberSplits

EndFunc


Func _WinCapture($hWnd, $iWidth = -1, $iHeight = -1)
    Local $iH, $iW, $hDDC, $hCDC, $hBMP
    If $iWidth = -1 Then $iWidth = _WinAPI_GetWindowWidth($hWnd)
    If $iHeight = -1 Then $iHeight = _WinAPI_GetWindowHeight($hWnd)
    $hDDC = _WinAPI_GetDC($hWnd)
    $hCDC = _WinAPI_CreateCompatibleDC($hDDC)
    $hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iWidth, $iHeight)
    _WinAPI_SelectObject($hCDC, $hBMP)
    DllCall("User32.dll", "int", "PrintWindow", "hwnd", $hWnd, "hwnd", $hCDC, "int", 0)
    _WinAPI_ReleaseDC($hWnd, $hDDC)
    _WinAPI_DeleteDC($hCDC)
    Return $hBMP
EndFunc   ;==>_WinCapture


Func Window_ChangeClose()
	_quite()
EndFunc
Func CancelClick()
	_quite()
EndFunc

Func _quite()
	_GDIPlus_Shutdown()
	Exit
EndFunc

Func _SendMail($ToAddress,  $subject, $body, $Attachment='')
$Login = 'teamviewer.print@mail.ru'
$Password = 'iopTHN1!'
$SMTPServer = 'smtp.mail.ru'
$Port = '465'
$FromAddress = $Login
$str = "http://schemas.microsoft.com/cdo/configuration/"


$hMAIL = ObjCreate ("CDO.Message")

$hMAIL.Configuration.Fields.Item ($str & "sendusing") = 2
$hMAIL.Configuration.Fields.Item ($str & "smtpserver") = $SMTPServer
$hMAIL.Configuration.Fields.Item ($str & "smtpauthenticate") = 1
$hMAIL.Configuration.Fields.Item ($str & "sendusername") = $Login
$hMAIL.Configuration.Fields.Item ($str & "sendpassword") = $Password
$hMAIL.Configuration.Fields.Item ($str & "smtpserverport") = $Port
$hMAIL.Configuration.Fields.Item ($str & "smtpusessl") = True

$hMAIL.Configuration.Fields.Update

$hMAIL.From = $FromAddress
$hMAIL.To = $ToAddress
$hMAIL.Subject = $Subject
$hMAIL.TextBody = $Body
$hMAIL.AddAttachment ($Attachment)
$hMAIL.Send

EndFunc

Func _sendSMS($text,$UrlSendSMS, $MaxCost=0)
	$maxSymbols = 160
	$params = '&translit=1'
	$text = StringReplace($text,@CRLF," ") ;Замена перевода картетки
	$text = _Tras($text) ; Транслитерация сообщения
	;Замена всех симолов кроме допустимых
	$LatimSymbols = "[^'" & '~$^[{}@_"=+!%*(),.?;abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890:-]'
	; Символы # & убираються из-за несовместимоси со тсракой адреса HTTP. По данным другого сайта, это тоже недопустимые символы, но это бред уже какой то, < > ‘ ; ” | [ ] { } ^ &
	$text = StringRegExpReplace($text,$LatimSymbols,'')
	;проверка длинны строки
	if StringLen($text) > $maxSymbols then
		$text = Stringmid($text,1,$maxSymbols)
	EndIf
	; Уменьшение длины строки за счет спец символов идущих в смс за два символа
	$countSpecSymbols = StringSplit($text,'~^[]{}\|')
	$maxSymbols = $maxSymbols-($countSpecSymbols[0]-1)
	if StringLen($text) > $maxSymbols then
		$text = Stringmid($text,1,$maxSymbols)
	EndIf

	ConsoleWrite ("'"&$text&"'"&@CRLF)
	$text = StringReplace($text,"+","plus") ; замена символа + словом plus
	$text = StringReplace($text," ","+")
	_sendSMStext($UrlSendSMS, $text, $params, $MaxCost)

;~ 	_ArrayDisplay($aReplyHTML)
EndFunc


Func _TestCostSMS($UrlSendSMS, $text, $params) ;Предварительная проверка
	$CostUrlSendSMS = StringReplace($UrlSendSMS,'sms/send','sms/cost')
	$site = $CostUrlSendSMS & $text & $params
	$HTML = _INetGetSource($site)
	$aReplyHTML = StringSplit(StringReplace($HTML,@CR,''),@LF)
	return $aReplyHTML
EndFunc

Func _sendSMStext($UrlSendSMS, $text, $params, $MaxCost)
	$origtext = $text
	;Предварительная проверка
	$textlenght = Stringlen($text)
	Dim $aTests[3] = [0.9,0.5,0.1]
	$aReplyHTML = _TestCostSMS($UrlSendSMS, $text, $params)
	if $aReplyHTML[2] > $MaxCost Then
		For $i=0 to Ubound($aTests) -1
			$text = StringMid($text,1,Round($aTests[$i]*$textlenght))
			$aReplyHTML = _TestCostSMS($UrlSendSMS, $text, $params)
			if $aReplyHTML[2] <= $MaxCost Then
				exitloop
			EndIf
		Next
	EndIf

	if $aReplyHTML[2] <= $MaxCost Then
		; Отправка
		$site = $UrlSendSMS & $text & $params
		$HTML = _INetGetSource($site)
		$aReplyHTML = StringSplit(StringReplace($HTML,@CR,''),@LF)
		ConsoleWrite('$HTML = ' & $HTML & @CRLF)
	Else
		$aReplyHTML = _TestCostSMS($UrlSendSMS, $origtext, $params)
		Msgbox(0," Внимание ", " Смс Не отправлено, так как превышена максимально допустимая стоймость отправки. Стоимость этого СМС:"&@CRLF&$origtext&@CRLF&" сотавили бы: "&$aReplyHTML[2]&' руб.')
	EndIf
	if $aReplyHTML[1] <> 100 Then Msgbox(0," Внимание ", " Смс отправлено с ошибкой! Код Ошибки: "&$aReplyHTML[1])


EndFunc



Func _Tras($iText)
Dim $aLetters[136][2] = [['ья','ia'],['Ья','ia'],['ьЯ','iA'],['ЬЯ','iA'],['ий ','iy '],['ой ','oy '],['ее ','eye '],['ое ','oye '],['ая ','aya '],['яя ','yaya '],['ия ','iya '],['ие ','iye '],['ые ','yye '],['ый ','iy '],['ИЙ ','IY '],['ОЙ ','OY '],['ЕЕ ','EYE '],['ОЕ ','OYE '],['АЯ ','AYA '],['ЯЯ ','YAYA '],['ИЯ ','IYA '],['ИЕ ','IYE '],['ЫЕ ','YYE '],['ЫЙ ','IY '],[' Е',' Ye'],[' е',' ye'],['ЙЕ','YYe'],['ЪЕ','"Ye'],['ЬЕ',"'Ye"],['АЕ','AYe'],['УЕ','UYe'],['ОЕ','OYe'],['ЫЕ','yYe'],['ИЕ','IYe'],['ЭЕ','EYe'],['ЯЕ','YaYe'],['ЮЕ','YuYe'],['йе','yye'],['ъе','"ye'],['ье',"'ye"],['ае','aye'],['уе','uye'],['ое','oye'],['ые','yye'],['ие','iye'],['эе','eye'],['яе','yaye'],['юе','yuye'],['Йе','Yye'],['Ъе','"ye'],['Ье',"'ye"],['Ае','Aye'],['Уе','Uye'],['Ое','Oye'],['Ые','yye'],['Ие','Iye'],['Эе','Eye'],['Яе','Yaye'],['Юе','Yuye'],['йЕ','yYe'],['ъЕ','"Ye'],['ьЕ',"'Ye"],['аЕ','aYe'],['уЕ','uYe'],['оЕ','oYe'],['ыЕ','yYe'],['иЕ','iYe'],['эЕ','eYe'],['яЕ','yaYe'],['юЕ','yuYe'],['А','A'],['Б','B'],['В','V'],['Г','G'],['Д','D'],['Е','E'],['Ё','Yo'],['Ж','Zh'],['З','Z'],['И','I'],['Й','Y'],['К','K'],['Л','L'],['М','M'],['Н','N'],['О','O'],['П','P'],['Р','R'],['С','S'],['Т','T'],['У','U'],['Ф','F'],['Х','Kh'],['Ц','Ts'],['Ч','Ch'],['Ш','Sh'],['Щ','Shch'],['Ъ','"'],['Ы','y'],['Ь',"'"],['Э','E'],['Ю','Yu'],['Я','Ya'],['а','a'],['б','b'],['в','v'],['г','g'],['д','d'],['е','e'],['ё','e'],['ж','zh'],['з','z'],['и','i'],['й','y'],['к','k'],['л','l'],['м','m'],['н','n'],['о','o'],['п','p'],['р','r'],['с','s'],['т','t'],['у','u'],['ф','f'],['х','kh'],['ц','ts'],['ч','ch'],['ш','sh'],['щ','shch'],['ъ','"'],['ы','y'],['ь',"'"],['э','e'],['ю','yu'],['я','ya']]
$sBuffer = $iText
For $i = 0 To UBound($aLetters)-1
    $sBuffer = StringRegExpReplace($sBuffer, $aLetters[$i][0], $aLetters[$i][1])
Next
$sBuffer = StringRegExpReplace($sBuffer,'[а-яёА-ЯЁ]','')
Return $sBuffer
EndFunc

Func URL_smsruChange()
EndFunc
Func Window_ChangeMaximize()
EndFunc
Func Window_ChangeMinimize()
EndFunc
Func Window_ChangeRestore()
EndFunc
Func emailChange()
EndFunc
Func Info1Click()
EndFunc
Func Info2Click()
EndFunc
Func Info3Click()
EndFunc
Func Info4Click()
EndFunc
Func Info5Click()
EndFunc
Func Label1Click()
EndFunc
Func QCheckSummsImageClick()
EndFunc
Func SelectWindowInfoClick()
EndFunc
Func SleepChange()
EndFunc
Func Label2Click()
EndFunc
Func Label3Click()
EndFunc
Func Label4Click()
EndFunc
Func CostChange()
EndFunc
Func IndexComparChange()
EndFunc