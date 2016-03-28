#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Ping(s='disk.tom.ru').exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

global $delay
$TestFileName = "Ping(s='4pda.ru')"
;~ $AddHour = _GetParamsOfFileName('add','a',1)
;~ $Delay = _GetParamsOfFileName('delay','d',1) * 1000
$Site = _GetParamsOfFileName('site','s',"Введите адрес сайта в имя файла в формате (Site='www.ru')",1)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Site = ' & $Site & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

MsgBox(0,' Приветствие ','Сейчас будет выполняться пинг сайта: ' & $Site & @CRLF & ' Вы всегда можете приостановить выполнение скрипта, закрыв его в трее ')

While 1
	$Ping = ping ('4pda.ru')
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Ping = ' & $Ping & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	if $Ping = 0 Then
		sleep(30000)
	Else
		BEEP()
		Msgbox(1,'Оповещение','Сайт пингуется! Время отклика = ' & $Ping,30)
		BEEP()
	EndIf

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Ping = ' & $Ping & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
WEnd

Func _GetParamsOfFileName($ParamsName, $ParamsShortName = '', $Default = 0, $textMode=0)
	if IsDeclared ('TestFileName') = 0 then local $TestFileName = ''

	Local $ScriptFileName[8], $pDelim = "\", $sPath = @AutoItExe, $params[2]
	$ScriptFileName[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
    $ScriptFileName[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename


	if Stringinstr($ScriptFileName[5],'autoit3.exe')<>0 then $ScriptFileName[6]= $TestFileName

	If $textMode=0 then
		$params = StringRegExp($ScriptFileName[6],'\(.*?' & $ParamsName & '([0-9.]+).*?\)',2)
		if @error then $params = StringRegExp($ScriptFileName[6],'\(' & $ParamsShortName & '([0-9.]+).*?\)',2)
		if @error then $params = StringRegExp($ScriptFileName[6],'\(.*?\d' & $ParamsShortName & '([0-9.]+).*?\)',2)
		if @error then
			Dim $params[2]
			$params[1] = $Default
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Default = ' & $Default & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		EndIf
	Else
		$params = StringRegExp($ScriptFileName[6],"(?i)\(.*?" & $ParamsName & "='(.+?)'.*?\)",2)
		if @error then $params = StringRegExp($ScriptFileName[6],"(?i)\(" & $ParamsShortName & "='(.+?)'.*?\)",2)
		if @error then $params = StringRegExp($ScriptFileName[6],"(?i)\(.*?\d" & $ParamsShortName & "='(.+?)'.*?\)",2)
		if @error then
			Dim $params[2]
			$params[1] = $Default
			ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : $Default = " & $Default & @CRLF & ">Error code: " & @error & @CRLF) ;### Debug Console
		EndIf
	EndIf


	Return $params[1]
EndFunc

