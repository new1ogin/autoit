#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <INet.au3> ;���������� ����������
;~ #include <GuiComboBox.au3>
;~ #include <GUIConstantsEx.au3>
#include <array.au3>
#include <Timers.au3>

HotKeySet("!{Ins}", "Terminate")
Func Terminate()
	 TrayTip("���������", "��������� �������, ����� �������� :)", 1500)
	sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
$ip = InputBox("���� ����������","������� IP ����� ������� ���������� ���������","192.168.1.0")

$LastInputURL = 'http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text='
$maxSymbols = 158
$TrReg = 1
$sPath = 'HKEY_CURRENT_USER\Software\AutoIt v3'
$section = 'Aut2Exe'

; ������ �� �������
;~ $sPath = 'HKEY_CURRENT_USER\Software\AutoIt v3'
;~ $LastInputURL = _Setting_Read($sPath, $section, 'LastInputURL', 'http://sms.ru/?panel=api&subpanel=method&show=sms/send', 1)
$prompt = '���� ������� URL � ����� sms.ru � ������� "http://sms.ru/sms/send?api_id=****&to=���_�����&text=", �������� ��� ������ �� ������ �� ������ "http://sms.ru/?panel=api&subpanel=method&show=sms/send"'&@CRLF&'������� ��������� �� ������ ������� � ���� ������ ������� �� ������ � ������ Exit, ���� ���������� ������� Alt+Ins.'
$UserEmail = InputBox("������� e-mail","������� e-mail ��� ����������",'newlogin7@gmail.com','',600,220)
$UrlSendSMS = InputBox("������� URL ��� ��������",$prompt,$LastInputURL,'',600,220)
$sleeps = InputBox("������� ����� ������",'������� ����� ������ � ���.',60,'',600,220)
;~ $UserActiv = 0

if @error >=1 and @error<=5 then
	ConsoleWrite("�������� ������������� !  "& $UrlSendSMS)
	exit
EndIf
while 1
	$ping = ping($ip)
	ConsoleWrite('@@ Debug(' & @Hour&':'&@MIN & ') : $ping = ' & $ping & @CRLF) ;### Debug Console
	if $ping<>0 then ExitLoop
	sleep($sleeps*1000)

WEnd

$Buffer =  "ip "&$ip&" online"
_SendMail($UserEmail, '�����', $Buffer)
If msgbox (1,"C��������","ip "&$ip&" online. Send SMS?",10) = 2 Then exit
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
	$text = StringReplace($text,@CRLF," ") ;������ �������� ��������
	$text = _Tras($text) ; �������������� ���������
	;������ ���� ������� ����� ����������
	$LatimSymbols = "[^'" & '~$^[{}@_"=+!%*(),.?;abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890:-]'
	; ������� # & ���������� ��-�� �������������� �� ������� ������ HTTP. �� ������ ������� �����, ��� ���� ������������ �������, �� ��� ���� ��� ����� ��, < > � ; � | [ ] { } ^ &
	$text = StringRegExpReplace($text,$LatimSymbols,'')
	;�������� ������ ������
	if StringLen($text) > $maxSymbols then
		$text = Stringmid($text,1,$maxSymbols)
	EndIf
	; ���������� ����� ������ �� ���� ���� �������� ������ � ��� �� ��� �������
	$countSpecSymbols = StringSplit($text,'~^[]{}\|')
	$maxSymbols = $maxSymbols-($countSpecSymbols[0]-1)
	if StringLen($text) > $maxSymbols then
		$text = Stringmid($text,1,$maxSymbols)
	EndIf

	ConsoleWrite ("'"&$text&"'"&@CRLF)
	$text = StringReplace($text,"+","plus") ; ������ ������� + ������ plus
	$text = StringReplace($text," ","+")
	_sendSMStext($UrlSendSMS, $text, $params, $MaxCost)

;~ 	_ArrayDisplay($aReplyHTML)
EndFunc


Func _TestCostSMS($UrlSendSMS, $text, $params) ;��������������� ��������
	$CostUrlSendSMS = StringReplace($UrlSendSMS,'sms/send','sms/cost')
	$site = $CostUrlSendSMS & $text & $params
	$HTML = _INetGetSource($site)
	$aReplyHTML = StringSplit(StringReplace($HTML,@CR,''),@LF)
	return $aReplyHTML
EndFunc

Func _sendSMStext($UrlSendSMS, $text, $params, $MaxCost)
	$origtext = $text
	;��������������� ��������
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
		; ��������
		$site = $UrlSendSMS & $text & $params
		$HTML = _INetGetSource($site)
		$aReplyHTML = StringSplit(StringReplace($HTML,@CR,''),@LF)
		ConsoleWrite('$HTML = ' & $HTML & @CRLF)
	Else
		$aReplyHTML = _TestCostSMS($UrlSendSMS, $origtext, $params)
		Msgbox(0," �������� ", " ��� �� ����������, ��� ��� ��������� ����������� ���������� ��������� ��������. ��������� ����� ���:"&@CRLF&$origtext&@CRLF&" �������� ��: "&$aReplyHTML[2]&' ���.')
	EndIf
	if $aReplyHTML[1] <> 100 Then Msgbox(0," �������� ", " ��� ���������� � �������! ��� ������: "&$aReplyHTML[1])


EndFunc



Func _Tras($iText)
Dim $aLetters[136][2] = [['��','ia'],['��','ia'],['��','iA'],['��','iA'],['�� ','iy '],['�� ','oy '],['�� ','eye '],['�� ','oye '],['�� ','aya '],['�� ','yaya '],['�� ','iya '],['�� ','iye '],['�� ','yye '],['�� ','iy '],['�� ','IY '],['�� ','OY '],['�� ','EYE '],['�� ','OYE '],['�� ','AYA '],['�� ','YAYA '],['�� ','IYA '],['�� ','IYE '],['�� ','YYE '],['�� ','IY '],[' �',' Ye'],[' �',' ye'],['��','YYe'],['��','"Ye'],['��',"'Ye"],['��','AYe'],['��','UYe'],['��','OYe'],['��','yYe'],['��','IYe'],['��','EYe'],['��','YaYe'],['��','YuYe'],['��','yye'],['��','"ye'],['��',"'ye"],['��','aye'],['��','uye'],['��','oye'],['��','yye'],['��','iye'],['��','eye'],['��','yaye'],['��','yuye'],['��','Yye'],['��','"ye'],['��',"'ye"],['��','Aye'],['��','Uye'],['��','Oye'],['��','yye'],['��','Iye'],['��','Eye'],['��','Yaye'],['��','Yuye'],['��','yYe'],['��','"Ye'],['��',"'Ye"],['��','aYe'],['��','uYe'],['��','oYe'],['��','yYe'],['��','iYe'],['��','eYe'],['��','yaYe'],['��','yuYe'],['�','A'],['�','B'],['�','V'],['�','G'],['�','D'],['�','E'],['�','Yo'],['�','Zh'],['�','Z'],['�','I'],['�','Y'],['�','K'],['�','L'],['�','M'],['�','N'],['�','O'],['�','P'],['�','R'],['�','S'],['�','T'],['�','U'],['�','F'],['�','Kh'],['�','Ts'],['�','Ch'],['�','Sh'],['�','Shch'],['�','"'],['�','y'],['�',"'"],['�','E'],['�','Yu'],['�','Ya'],['�','a'],['�','b'],['�','v'],['�','g'],['�','d'],['�','e'],['�','e'],['�','zh'],['�','z'],['�','i'],['�','y'],['�','k'],['�','l'],['�','m'],['�','n'],['�','o'],['�','p'],['�','r'],['�','s'],['�','t'],['�','u'],['�','f'],['�','kh'],['�','ts'],['�','ch'],['�','sh'],['�','shch'],['�','"'],['�','y'],['�',"'"],['�','e'],['�','yu'],['�','ya']]
$sBuffer = $iText
For $i = 0 To UBound($aLetters)-1
    $sBuffer = StringRegExpReplace($sBuffer, $aLetters[$i][0], $aLetters[$i][1])
Next
$sBuffer = StringRegExpReplace($sBuffer,'[�-���-ߨ]','')
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