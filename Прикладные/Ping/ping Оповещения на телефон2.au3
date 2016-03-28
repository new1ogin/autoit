#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <INet.au3> ;Подключаем библиотеку
;~ #include <GuiComboBox.au3>
;~ #include <GUIConstantsEx.au3>
#include <array.au3>
#include <Timers.au3>

HotKeySet("!{Ins}", "Terminate")
Func Terminate()
	 TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
$ip = InputBox("Ввод информации","Введите IP адрес который необходимо проверять","192.168.1.0")

$LastInputURL = 'http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text='
$maxSymbols = 158
$TrReg = 1
$sPath = 'HKEY_CURRENT_USER\Software\AutoIt v3'
$section = 'Aut2Exe'

; Чтение из реестра
;~ $sPath = 'HKEY_CURRENT_USER\Software\AutoIt v3'
;~ $LastInputURL = _Setting_Read($sPath, $section, 'LastInputURL', 'http://sms.ru/?panel=api&subpanel=method&show=sms/send', 1)
$prompt = 'Ниже введите URL с сайта sms.ru в формате "http://sms.ru/sms/send?api_id=****&to=ВАШ_НОМЕР&text=", получить эту ссылку вы можете по адресу "http://sms.ru/?panel=api&subpanel=method&show=sms/send"'&@CRLF&'Закрыть программу Вы можете щелкнув в трее правой кнопкой по иконке и выбрав Exit, либо сочетанием клавишь Alt+Ins.'
$UserEmail = InputBox("Введите e-mail","Введите e-mail для оповещений",'newlogin7@gmail.com','',600,220)
$UrlSendSMS = InputBox("Введите URL для отправки",$prompt,$LastInputURL,'',600,220)
$sleeps = InputBox("Введите время опроса",'Введите время опроса в сек.',60,'',600,220)
;~ $UserActiv = 0

if @error >=1 and @error<=5 then
	ConsoleWrite("Отменено пользователем !  "& $UrlSendSMS)
	exit
EndIf
while 1
	$ping = ping($ip)
	ConsoleWrite('@@ Debug(' & @Hour&':'&@MIN & ') : $ping = ' & $ping & @CRLF) ;### Debug Console
	if $ping<>0 then ExitLoop
	sleep($sleeps*1000)

WEnd

$Buffer =  "ip "&$ip&" online"
_SendMail($UserEmail, 'Отчёт', $Buffer)
If msgbox (1,"Cообщение","ip "&$ip&" online. Send SMS?",10) = 2 Then exit
_sendSMS($Buffer,$UrlSendSMS)


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



Func _Setting_Read($sPath, $sSection, $sValueName, $sDefault, $iReg = 0)
	Local $sValue
	If $iReg Then
		$sValue = RegRead($sPath & '\' & $sSection, $sValueName)
		If @error Then $sValue = $sDefault
	Else
		$sValue = IniRead($sPath, $sSection, $sValueName, $sDefault)
	EndIf
	Return $sValue
EndFunc

Func _Setting_Write($sPath, $sSection, $sValueName, $sValue, $iReg = 0)
	If $iReg Then
		$sValue = StringRegExpReplace($sValue, '^"(.*?)"$', '\1')
		$iRes = RegWrite($sPath & '\' & $sSection, $sValueName, "REG_SZ", $sValue)
	Else
		$iRes = IniWrite($sPath, $sSection, $sValueName, $sValue)
	EndIf
	Return SetError(Not $iRes, 0, $iRes)
EndFunc