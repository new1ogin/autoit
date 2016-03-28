
$AutoItExe = @AutoItExe

$delay = _GetParamsOfFileName('delay', 'd', 0, 0, $AutoItExe) * 1000
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $delay = ' & $delay & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$Name = _GetParamsOfFileName('name', 'n', 0, 1, $AutoItExe)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Name = ' & $Name & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$password = _GetParamsOfFileName('password', 'p', 0, 1, $AutoItExe)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $password = ' & $password & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$Start = _GetParamsOfFileName('Start', 's', 0, 1, $AutoItExe)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Start = ' & $Start & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ exit
Sleep($delay)

if $Name=0 or $password=0 Then
	Run(@ScriptDir & "\" & $Start)
Else
	RunAs($Name, @ComputerName,$password, 0, @ScriptDir & "\" & $Start)
EndIf










 ;Функция получения параметров из имени файла
Func _GetParamsOfFileName($ParamsName, $ParamsShortName = '', $Default = 0, $textMode=0, $AutoItExe = @AutoItExe)
	if IsDeclared ('TestFileName') = 0 then local $TestFileName = ''

	Local $ScriptFileName[8], $pDelim = "\", $sPath = $AutoItExe, $params[2]
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
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Default = ' & $Default & @CRLF) ;### Debug Console
		EndIf
	Else
		$params = StringRegExp($ScriptFileName[6],"(?i)\(.*?" & $ParamsName & "='(.+?)'.*?\)",2)
		if @error then $params = StringRegExp($ScriptFileName[6],"(?i)\(" & $ParamsShortName & "='(.+?)'.*?\)",2)
		if @error then $params = StringRegExp($ScriptFileName[6],"(?i)\(.*?" & $ParamsShortName & "='(.+?)'.*?\)",2)
		if @error then
			Dim $params[2]
			$params[1] = $Default
			ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : $Default = " & $Default & @CRLF & ">Error code: " & @error & @CRLF) ;### Debug Console
		EndIf
	EndIf



	Return $params[1]
EndFunc