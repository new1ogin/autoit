#include <array.au3>
#include <GDIPlus.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <File.au3>
#include <INet.au3>
HotKeySet("{^F7}", "_quite") ;Это вызов
HotKeySet("{F6}", "_Go") ;Это вызов
HotKeySet("{F7}", "_Pause") ;Это вызов
global $NumberSplits = 1001, $aMemoryImage, $Struct
Global $oMyRet[2]
Global $oMyError = ObjEvent("AutoIt.Error", "MyErrFunc")
Dim $aMemoryImage[$NumberSplits+1][10] ; массив для хранения информации для сравнения
global $hwnd, $posWin, $title = '', $emailUser, $URL_smsruUser, $sleepForCheckImage, $func=0, $IndexCompare, $MaxIndexCompare = 1
$UrlSendSMS = "http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text="
$UrlSendSMS = "http://sms.ru/sms/send?api_id=124104f6-e803-4934-ad08-066e8b9493ea&to=79131042000&text="
global $textMSG = 'Внимание, сработало событие! '
sleep(1000)


$FromAddress = 'teamviewer.print@mail.ru'
$Username = $FromAddress
$Password = 'iopTHN1!'
$SMTPServer = 'smtp.mail.ru'
;~ $SmtpServer = 'smtp.yandex.ru'
;~ $Username = 'логин'
;~ $Password = 'пароль'
$ToAddress = 'newlogin7@gmail.com'
$Subject = 'Privet Gdu Testa'
$Body = 'Tekst testa privet itd'
_INetSmtpMailCom($SmtpServer, '', $FromAddress, $ToAddress, $Subject, $Body, '', '', '', $Username, $Password)
if @error=2 then ConsoleWrite(43524353465564363463656)
;~ _SendMail('newlogin7@gmail.com','Privet Gdu Testa','Tekst testa privet itd')
$sleepTrack = 1000
exit
_pause()


Func _pause()
	TrayTip('Подсказка','Пожалуйста выберете точку для слежения и нажмите F6, для начала слежения',5000)
	;Ожидание
	While 1
		sleep(100)
	WEnd
EndFunc

Func _go()
	$posTrack = MouseGetPos()
	$colorTrack = PixelGetColor($posTrack[0],$posTrack[1])
	$q=0
	ConsoleWrite("Начало слежения "&$posTrack[0]&' '&$posTrack[1]&' '&Hex($colorTrack,6)& @CRLF)
	TrayTip('Подсказка',"Начало слежения "&$posTrack[0]&' '&$posTrack[1]&' '&Hex($colorTrack,6) & @CRLF & _
	'Для остановки слежения нажмите F7',5000)
	While 1
		$t = PixelSearch($posTrack[0],$posTrack[1],$posTrack[0],$posTrack[1],$colorTrack,10)
		if @error Then
			$q+=1
			ConsoleWrite('Цвет в точке не был найден' & @CRLF)
		Else
			$q=1
		EndIf
		if $q >= 10 then exitloop
		sleep($sleepTrack)
	WEnd
	$t = MsgBox(1,'Внимание',$textMSG,30)
	if $t=2 then return 1
;~ 	_sendSMS($textMSG,$UrlSendSMS, 2)
	ConsoleWrite($textMSG & @CRLF)
EndFunc


Func _quite()
	_GDIPlus_Shutdown()
	Exit
EndFunc

Func _INetSmtpMailCom($s_SmtpServer, $s_FromName, $s_FromAddress, $s_ToAddress, $s_Subject = "", $s_Body = "", $s_AttachFiles = "", $s_CcAddress = "", $s_BccAddress = "", $s_Username = "", $s_Password = "", $IPPort = 25, $ssl = 1)
	ConsoleWrite(' Используется email для отправки через функуию _INetSmtpMailCom: '&$s_ToAddress&@CRLF)
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

Func _SendMail($ToAddress,  $subject, $body)
	$error = 0
	$FromAddress = 'teamviewer.print@mail.ru'
	$Username = $FromAddress
	$Password = 'iopTHN1!'
	$SMTPServer = 'smtp.mail.ru'
	$Port = '465'
    _SendMailSimple($ToAddress, $subject, $body,$Username,$Password,$SMTPServer,$FromAddress)
	if @error=2 then _INetSmtpMailCom($SmtpServer, '', $FromAddress, $ToAddress, $Subject, $Body, '', '', '', $Username, $Password)
	; резервный email для отправки
	if @error=2 then
		$FromAddress = 'ivantea@list.ru'
		$Username = $FromAddress
		$Password = 'iopthn'
		_SendMailSimple($ToAddress, $subject, $body,$Username,$Password,$SMTPServer,$FromAddress)
		if @error=2 then _INetSmtpMailCom($SmtpServer, '', $FromAddress, $ToAddress, $Subject, $Body, '', '', '', $Username, $Password)
		; резервный email для отправки
		if @error=2 then
			$SmtpServer = 'smtp.yandex.ru'
			$FromAddress = 'new1ogin@yandex.ru'
			$Username = $FromAddress
			$Password = 'iopTHN!#'
			_SendMailSimple($ToAddress, $subject, $body,$Username,$Password,$SMTPServer,$FromAddress)
			if @error=2 then _INetSmtpMailCom($SmtpServer, '', $FromAddress, $ToAddress, $Subject, $Body, '', '', '', $Username, $Password)
			if @error=2 then $error=1
		EndIf
	EndIf
	if $error=1 Then MsgBox(0,' Ошибка','Не удалось отпрвить email на адрес: '&$ToAddress,10)

EndFunc

Func _SendMailSimple($ToAddress,  $subject, $body,$Login,$Password,$SMTPServer,$FromAddress,$Port='465', $Attachment='')
ConsoleWrite(' Используется email для отправки через функуию _SendMailSimple: '&$Login&@CRLF)
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
    If @error Then
        SetError(2)
    EndIf
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


; Com Error Handler
Func MyErrFunc()
    $HexNumber = Hex($oMyError.number, 8)
    $oMyRet[0] = $HexNumber
    $oMyRet[1] = StringStripWS($oMyError.description, 3)
    ConsoleWrite("### COM Error !  Number: " & $HexNumber & "   ScriptLine: " & $oMyError.scriptline & "   Description:" & $oMyRet[1] & @LF)
    SetError(1); something to check for when this function returns
    Return
EndFunc   ;==>MyErrFunc