#include <array.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <File.au3>
#include <INet.au3>
HotKeySet("{^F7}", "_quite") ;Это вызов
HotKeySet("{F6}", "_Go") ;Это вызов
HotKeySet("{F7}", "_Pause") ;Это вызов
Global $NumberSplits = 1001, $aMemoryImage, $Struct
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Dim $aMemoryImage[$NumberSplits + 1][10] ; массив для хранения информации для сравнения
Global $hwnd, $posWin, $title = '', $emailUser, $URL_smsruUser, $sleepForCheckImage, $func = 0, $IndexCompare, $MaxIndexCompare = 1
$UrlSendSMS = "http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text="
$UrlSendSMS = "http://sms.ru/sms/send?api_id=124104f6-e803-4934-ad08-066e8b9493ea&to=79131042000&text="
Global $textMSG = 'Внимание, сработало событие! '
$sleepTrack = 1000


_pause()


Func _pause()
	TrayTip('Подсказка', 'Пожалуйста выберете точку для слежения и нажмите F6, для начала слежения', 5000)
	;Ожидание
	While 1
		Sleep(100)
	WEnd
EndFunc   ;==>_pause

Func _go()
	$posTrack = MouseGetPos()
	$colorTrack = PixelGetColor($posTrack[0], $posTrack[1])
	$q = 0
	ConsoleWrite("Начало слежения " & $posTrack[0] & ' ' & $posTrack[1] & ' ' & Hex($colorTrack, 6) & @CRLF)
	TrayTip('Подсказка', "Начало слежения " & $posTrack[0] & ' ' & $posTrack[1] & ' ' & Hex($colorTrack, 6) & @CRLF & _
			'Для остановки слежения нажмите F7', 5000)
	While 1
		$t = PixelSearch($posTrack[0], $posTrack[1], $posTrack[0], $posTrack[1], $colorTrack, 10)
		If @error Then
			$q += 1
			ConsoleWrite('Цвет в точке не был найден' & @CRLF)
		Else
			$q = 1
		EndIf
		If $q >= 10 Then ExitLoop
		Sleep($sleepTrack)
	WEnd
	_SendMail('newlogin7@gmail.com','Сообщение из файла: Оповещение',$textMSG)
	$t = MsgBox(1, 'Внимание', $textMSG, 30)
	If $t = 2 Then Return 1
	_sendSMS($textMSG,$UrlSendSMS, 2)
	ConsoleWrite($textMSG & @CRLF)
EndFunc   ;==>_go


Func _quite()
	_GDIPlus_Shutdown()
	Exit
EndFunc   ;==>_quite

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

Func _sendSMS($text, $UrlSendSMS, $MaxCost = 0)
	$maxSymbols = 160
	$params = '&translit=1'
	$text = StringReplace($text, @CRLF, " ") ;Замена перевода картетки
	$text = _Tras($text) ; Транслитерация сообщения
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


Func _TestCostSMS($UrlSendSMS, $text, $params) ;Предварительная проверка
	$CostUrlSendSMS = StringReplace($UrlSendSMS, 'sms/send', 'sms/cost')
	$site = $CostUrlSendSMS & $text & $params
	$HTML = _INetGetSource($site)
	$aReplyHTML = StringSplit(StringReplace($HTML, @CR, ''), @LF)
	Return $aReplyHTML
EndFunc   ;==>_TestCostSMS

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



Func _Tras($iText)
	Dim $aLetters[136][2] = [['ья', 'ia'], ['Ья', 'ia'], ['ьЯ', 'iA'], ['ЬЯ', 'iA'], ['ий ', 'iy '], ['ой ', 'oy '], ['ее ', 'eye '], ['ое ', 'oye '], ['ая ', 'aya '], ['яя ', 'yaya '], ['ия ', 'iya '], ['ие ', 'iye '], ['ые ', 'yye '], ['ый ', 'iy '], ['ИЙ ', 'IY '], ['ОЙ ', 'OY '], ['ЕЕ ', 'EYE '], ['ОЕ ', 'OYE '], ['АЯ ', 'AYA '], ['ЯЯ ', 'YAYA '], ['ИЯ ', 'IYA '], ['ИЕ ', 'IYE '], ['ЫЕ ', 'YYE '], ['ЫЙ ', 'IY '], [' Е', ' Ye'], [' е', ' ye'], ['ЙЕ', 'YYe'], ['ЪЕ', '"Ye'], ['ЬЕ', "'Ye"], ['АЕ', 'AYe'], ['УЕ', 'UYe'], ['ОЕ', 'OYe'], ['ЫЕ', 'yYe'], ['ИЕ', 'IYe'], ['ЭЕ', 'EYe'], ['ЯЕ', 'YaYe'], ['ЮЕ', 'YuYe'], ['йе', 'yye'], ['ъе', '"ye'], ['ье', "'ye"], ['ае', 'aye'], ['уе', 'uye'], ['ое', 'oye'], ['ые', 'yye'], ['ие', 'iye'], ['эе', 'eye'], ['яе', 'yaye'], ['юе', 'yuye'], ['Йе', 'Yye'], ['Ъе', '"ye'], ['Ье', "'ye"], ['Ае', 'Aye'], ['Уе', 'Uye'], ['Ое', 'Oye'], ['Ые', 'yye'], ['Ие', 'Iye'], ['Эе', 'Eye'], ['Яе', 'Yaye'], ['Юе', 'Yuye'], ['йЕ', 'yYe'], ['ъЕ', '"Ye'], ['ьЕ', "'Ye"], ['аЕ', 'aYe'], ['уЕ', 'uYe'], ['оЕ', 'oYe'], ['ыЕ', 'yYe'], ['иЕ', 'iYe'], ['эЕ', 'eYe'], ['яЕ', 'yaYe'], ['юЕ', 'yuYe'], ['А', 'A'], ['Б', 'B'], ['В', 'V'], ['Г', 'G'], ['Д', 'D'], ['Е', 'E'], ['Ё', 'Yo'], ['Ж', 'Zh'], ['З', 'Z'], ['И', 'I'], ['Й', 'Y'], ['К', 'K'], ['Л', 'L'], ['М', 'M'], ['Н', 'N'], ['О', 'O'], ['П', 'P'], ['Р', 'R'], ['С', 'S'], ['Т', 'T'], ['У', 'U'], ['Ф', 'F'], ['Х', 'Kh'], ['Ц', 'Ts'], ['Ч', 'Ch'], ['Ш', 'Sh'], ['Щ', 'Shch'], ['Ъ', '"'], ['Ы', 'y'], ['Ь', "'"], ['Э', 'E'], ['Ю', 'Yu'], ['Я', 'Ya'], ['а', 'a'], ['б', 'b'], ['в', 'v'], ['г', 'g'], ['д', 'd'], ['е', 'e'], ['ё', 'e'], ['ж', 'zh'], ['з', 'z'], ['и', 'i'], ['й', 'y'], ['к', 'k'], ['л', 'l'], ['м', 'm'], ['н', 'n'], ['о', 'o'], ['п', 'p'], ['р', 'r'], ['с', 's'], ['т', 't'], ['у', 'u'], ['ф', 'f'], ['х', 'kh'], ['ц', 'ts'], ['ч', 'ch'], ['ш', 'sh'], ['щ', 'shch'], ['ъ', '"'], ['ы', 'y'], ['ь', "'"], ['э', 'e'], ['ю', 'yu'], ['я', 'ya']]
	$sBuffer = $iText
	For $i = 0 To UBound($aLetters) - 1
		$sBuffer = StringRegExpReplace($sBuffer, $aLetters[$i][0], $aLetters[$i][1])
	Next
	$sBuffer = StringRegExpReplace($sBuffer, '[а-яёА-ЯЁ]', '')
	Return $sBuffer
EndFunc   ;==>_Tras


; Com Error Handler
Func MyErrFunc()
	$HexNumber = Hex($oMyError.number, 8)
	$oMyRet[0] = $HexNumber
	$oMyRet[1] = StringStripWS($oMyError.description, 3)
	ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
	SetError(1); something to check for when this function returns
	Return
EndFunc   ;==>MyErrFunc
