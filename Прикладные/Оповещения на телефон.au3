#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=������ ���������� �� ��� � Net Speakerphone.exe
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

$UrlSendSMS = 'http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text='
$UrlSendSMS = 'http://sms.ru/sms/send?api_id=4271eeca-1f9d-4764-1d29-3a191ee93abf&to=79138425749&text='
$maxSymbols = 158
$TrReg = 1
$sPath = 'HKEY_CURRENT_USER\Software\AutoIt v3'
$section = 'Aut2Exe'

; ������ �� �������
;~ $sPath = 'HKEY_CURRENT_USER\Software\AutoIt v3'
$LastInputURL = _Setting_Read($sPath, $section, 'LastInputURL', 'http://sms.ru/?panel=api&subpanel=method&show=sms/send', 1)
$prompt = '���� ������� URL � ����� sms.ru � ������� "http://sms.ru/sms/send?api_id=****&to=���_�����&text=", �������� ��� ������ �� ������ �� ������ "http://sms.ru/?panel=api&subpanel=method&show=sms/send"'&@CRLF&'������� ��������� �� ������ ������� � ���� ������ ������� �� ������ � ������ Exit, ���� ���������� ������� Alt+Ins.'
$UrlSendSMS = InputBox("������� URL ��� ��������",$prompt,$UrlSendSMS,'',600,220)
$UserActiv = 0

if @error >=1 and @error<=5 then
	ConsoleWrite("�������� ������������� !  "& $UrlSendSMS)
	exit
EndIf
while 1
	$ping = ping($ip,60)
	ConsoleWrite('@@ Debug(' & @Hour&':'&@MIN & ') : $ping = ' & $ping & @CRLF) ;### Debug Console
	if $ping<>0 then ExitLoop

WEnd
$Buffer =  "ip "&$ip&" online"
					$Buffer = StringReplace($Buffer,@CRLF," ")
					$Buffer = _Tras($Buffer)
					$LatimSymbols = "[^'" & '~$^[{}@_"=+!%*(),.?;abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890:-]'
					; ������� # & ���������� ��-�� �������������� �� ������� ������ HTTP. �� ������ ������� �����, ��� ���� ������������ �������, �� ��� ���� ��� ����� ��, < > � ; � | [ ] { } ^ &
					$Buffer = StringRegExpReplace($Buffer,$LatimSymbols,'')
					$site = $UrlSendSMS & $Buffer
					ConsoleWrite('site = '&$site & @CRLF)
					$HTML = _INetGetSource($site)
					ConsoleWrite('$HTML = ' & $HTML & @CRLF)
exit

; �������� URL
if StringRight($UrlSendSMS,6) <> '&text=' then
	msgbox(0,'��������!','URL ����� �������!')
	Exit
EndIf

; ������ � ������
;~ if $LastInputURL<>$UrlSendSMS Then
;~ 	_Setting_Write($sPath, $section, 'LastInputURL', $UrlSendSMS, 1) ; ����������
;~ EndIf

dim $OldHwnds[1]=['']
;~ dim $OldHwnds

;~ WinGetState($hwnd  )
;~ while 1
	$hwnd = WinGetHandle('[CLASS:TFormText]')
	$chwnd = '[CLASS:TFrameMyRich]'
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState($hwnd  ) = ' & WinGetState($hwnd  )  & @CRLF) ;### Debug Console
;~ WinSetState($hwnd,'',@SW_SHOW)
;~ WinFlash ( $hwnd  )
;~ WinSetState($hwnd,'',@SW_ENABLE)

;~ ControlShow ( $hwnd, "", $chwnd )
;~ sleep(1000)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState($hwnd  ) = ' & WinGetState($hwnd  )  & @CRLF) ;### Debug Console



while 1
	sleep(2000)
;~ 	if _Timer_GetIdleTime() > 5000 then
;~ 		$pos = mousegetpos()
;~ 		MouseMove($pos[0]+1,$pos[1]+1)
;~ 		MouseMove($pos[0],$pos[1])
;~ 	EndIf
	$aList = WinList('[Class:TFormText]')
	$hwnd=0

		For $l=1 to Ubound($aList)-1
			$listfind=0
			For $h=0 to Ubound($OldHwnds)-1
				if $aList[$l][1] = $OldHwnds[$h] then
					$listfind=1
				EndIf
			Next
			if $listfind=0 Then
				$hwnd = $aList[$l][1]
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hwnd = ' & $hwnd & @CRLF ) ;### Debug Console
			EndIf
		Next

	if Ubound($OldHwnds) = 1 then $hwnd = WinGetHandle('[CLASS:TFormText]')

	if $hwnd<>0 Then

;~ 		$hwnd = WinGetHandle('[CLASS:TFormText]')
		_ArrayAdd($OldHwnds,$hwnd)
;~ 		_ArrayDisplay($OldHwnds)
		$oldbuffer = ClipGet()
		$chwnd = '[CLASS:TFrameMyRich]'
		Controlclick($hwnd,'',$chwnd,'right')
		ControlSend($hwnd,'',$chwnd,'{down}')
		ControlSend($hwnd,'',$chwnd,'{enter}')
		sleep(500)
		$Buffer = ClipGet()
	;~ 	ConsoleWrite('len = '& StringLen($Buffer) &@CRLF)
		if StringLen($Buffer) < 2 then
			Controlclick($hwnd,'',$chwnd,'right')
			ControlSend($hwnd,'',$chwnd,'{down}')
			ControlSend($hwnd,'',$chwnd,'{down}')
			ControlSend($hwnd,'',$chwnd,'{enter}')
			$Buffer = ClipGet()
		EndIf
	;~ 	ConsoleWrite ("'"&$Buffer&"'"&@CRLF)
		if $Buffer<>$oldbuffer then
			clipput($oldbuffer)
			if _Timer_GetIdleTime() > 1000 then beep()
			if _Timer_GetIdleTime() > 15000 then
				sleep(5000)
				beep()
				sleep(5000)
				beep()
				if _Timer_GetIdleTime() > 15000 then
					$Buffer = StringRegExpReplace($Buffer,' \(\d+:\d+:\d+\)','')
					$Buffer = _doubleEnterDelete($Buffer)
					$aBuffer = StringRegExp($Buffer,'[^\n]*',2)
					if StringLen($aBuffer[0]) > 10 then
			;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aBuffer[0] = ' & $aBuffer[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringMid($aBuffer[0],0,9) = ' & StringMid($aBuffer[0],1,9) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
						$Buffer = StringReplace($Buffer,$aBuffer[0],StringMid($aBuffer[0],1,10)& ':')
					EndIf
					$Buffer = StringReplace($Buffer,@CRLF," ")
					$Buffer = _Tras($Buffer)
					$LatimSymbols = "[^'" & '~$^[{}@_"=+!%*(),.?;abcdefghijklmnopqrstuvwxyz ABCDEFGHIJKLMNOPQRSTUVWXYZ1234567890:-]'
					; ������� # & ���������� ��-�� �������������� �� ������� ������ HTTP. �� ������ ������� �����, ��� ���� ������������ �������, �� ��� ���� ��� ����� ��, < > � ; � | [ ] { } ^ &
					$Buffer = StringRegExpReplace($Buffer,$LatimSymbols,'')
					if StringLen($Buffer) > $maxSymbols then
						$Buffer = Stringmid($Buffer,1,$maxSymbols)
					EndIf
					$countSpecSymbols = StringSplit($Buffer,'~^[]{}\|')
					$maxSymbols = $maxSymbols-($countSpecSymbols[0]-1)
					if StringLen($Buffer) > $maxSymbols then
						$Buffer = Stringmid($Buffer,1,$maxSymbols)
					EndIf
					ConsoleWrite ("'"&$Buffer&"'"&@CRLF)
					$Buffer = StringReplace($Buffer,"+","plus")
					$Buffer = StringReplace($Buffer," ","+")
					$site = $UrlSendSMS & $Buffer
					ConsoleWrite('site = '&$site & @CRLF)
					$HTML = _INetGetSource($site)
					ConsoleWrite('$HTML = ' & $HTML & @CRLF)
				EndIf
			Else
				$iindex = _ArraySearch($OldHwnds,$hwnd)
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _ArraySearch($OldHwnds,$hwnd) = ' & _ArraySearch($OldHwnds,$hwnd) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 				_ArrayDisplay($OldHwnds)
				if $OldHwnds[$iindex] = $hwnd Then
					$UserActiv +=1
					if $UserActiv < 2 then
						_ArrayPop($OldHwnds)
						ConsoleWrite('������������ ������� ���� ����� ������������� ��� ���.' & @CRLF)
					EndIf
				EndIf
				sleep(5000)
			EndIf
		EndIf
	EndIf
WEnd

Func _doubleEnterDelete($BufferL)
	$BufferL = StringRegExpReplace($BufferL,@CRLF&@CRLF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CR&@CR,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@LF&@LF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CRLF&" "&@CRLF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CRLF&"  "&@CRLF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CRLF&@CRLF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CR&@CR,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@LF&@LF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CRLF&" "&@CRLF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CRLF&"  "&@CRLF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CRLF&@CRLF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CR&@CR,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@LF&@LF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CRLF&" "&@CRLF,@CRLF)
	$BufferL = StringRegExpReplace($BufferL,@CRLF&"  "&@CRLF,@CRLF)
	return $BufferL
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