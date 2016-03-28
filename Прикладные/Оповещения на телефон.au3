#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Виталя Оповещения по СМС с Net Speakerphone.exe
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

$UrlSendSMS = 'http://sms.ru/sms/send?api_id=5e928b5a-21d9-cc94-bd17-513e32d3548d&to=79131042000&text='
$UrlSendSMS = 'http://sms.ru/sms/send?api_id=4271eeca-1f9d-4764-1d29-3a191ee93abf&to=79138425749&text='
$maxSymbols = 158
$TrReg = 1
$sPath = 'HKEY_CURRENT_USER\Software\AutoIt v3'
$section = 'Aut2Exe'

; Чтение из реестра
;~ $sPath = 'HKEY_CURRENT_USER\Software\AutoIt v3'
$LastInputURL = _Setting_Read($sPath, $section, 'LastInputURL', 'http://sms.ru/?panel=api&subpanel=method&show=sms/send', 1)
$prompt = 'Ниже введите URL с сайта sms.ru в формате "http://sms.ru/sms/send?api_id=****&to=ВАШ_НОМЕР&text=", получить эту ссылку вы можете по адресу "http://sms.ru/?panel=api&subpanel=method&show=sms/send"'&@CRLF&'Закрыть программу Вы можете щелкнув в трее правой кнопкой по иконке и выбрав Exit, либо сочетанием клавишь Alt+Ins.'
$UrlSendSMS = InputBox("Введите URL для отправки",$prompt,$UrlSendSMS,'',600,220)
$UserActiv = 0

if @error >=1 and @error<=5 then
	ConsoleWrite("Отменено пользователем !  "& $UrlSendSMS)
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
					; Символы # & убираються из-за несовместимоси со тсракой адреса HTTP. По данным другого сайта, это тоже недопустимые символы, но это бред уже какой то, < > ‘ ; ” | [ ] { } ^ &
					$Buffer = StringRegExpReplace($Buffer,$LatimSymbols,'')
					$site = $UrlSendSMS & $Buffer
					ConsoleWrite('site = '&$site & @CRLF)
					$HTML = _INetGetSource($site)
					ConsoleWrite('$HTML = ' & $HTML & @CRLF)
exit

; проверка URL
if StringRight($UrlSendSMS,6) <> '&text=' then
	msgbox(0,'Внимание!','URL введён неверно!')
	Exit
EndIf

; запись в реестр
;~ if $LastInputURL<>$UrlSendSMS Then
;~ 	_Setting_Write($sPath, $section, 'LastInputURL', $UrlSendSMS, 1) ; записывает
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
					; Символы # & убираються из-за несовместимоси со тсракой адреса HTTP. По данным другого сайта, это тоже недопустимые символы, но это бред уже какой то, < > ‘ ; ” | [ ] { } ^ &
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
						ConsoleWrite('Пользователь активен окно будет задействовано ещё раз.' & @CRLF)
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