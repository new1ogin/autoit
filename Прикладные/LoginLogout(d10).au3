;~ $sleep = _GetParamsOfFileName('delay', 'd', "60")*1000
;~ Sleep($sleep)
$timer = Timerinit()
$Answer=Msgbox(1,'Предупреждение','Выполнить автоматический вход в систему с последующим выходом?' & TimerDiff($timer),15)
MsgBox(0,'',$Answer)

Send("tshi2013")
Sleep(1000)
Send("{Enter}")
Sleep(1000)
Send("{Enter}")
Sleep(1000)
Send("еырш2013")
Sleep(1000)
Send("{Enter}")
Sleep(1000)
Send("{Enter}")
Sleep(1000)
Send("{Altdown}")
Send("{Shiftdown}")
sleep(128)
Send("{Altup}")
Send("{Shiftup}")
Sleep(1000)
Send("еырш2013")
Sleep(1000)
Send("{Enter}")
Sleep(1000)
Send("{Enter}")
Sleep(1000)
Send("tshi2013")
Sleep(1000)
Send("{Enter}")




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
