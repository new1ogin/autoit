#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Запуск обновления антивируса в сети MAIN_(d15).exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

$sleep = _GetParamsOfFileName('delay', 'd', "15") ;Получения значения задержки из имени файла
sleep($sleep*1000)

$folder = '\\main\backup\eset_upd\'
;~ $folder = '\\server2003\Distrib\Antivirus\eset_upd\AllUpdates4Main_23.10.2014\'
dim $file
Dim $AntivirusList[7][2] = [['MsMpEng','Microsoft Security Essentials'],['msseces','Microsoft Security Essentials'],['AvastSvc','avast!'],['AvastUI','avast!'],['AvastEm','avast!'],['ekrn','ESET NOD32'],['egui','ESET NOD32']] ;,['','']
$AviableAntivirus = ''
$proclist = ProcessList ( ) ;ProcessExists ( "MsMpEng" )
For $i=1 to $proclist[0][0]
	for $a=0 to Ubound($AntivirusList)-1
		if StringInStr($proclist[$i][0], $AntivirusList[$a][0]) > 0 then
			ConsoleWrite($proclist[$i][0] & @CRLF)
			$AviableAntivirus &= $AntivirusList[$a][1]
		EndIf
	Next
Next

for $a=0 to Ubound($AntivirusList)-1
	$AviableAntivirus = StringRegExpReplace($AviableAntivirus, '('&$AntivirusList[$a][1]&')'&'+',$AntivirusList[$a][1])
Next
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $AviableAntivirus = ' & $AviableAntivirus & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

if $AviableAntivirus <> 'Microsoft Security Essentials' and $AviableAntivirus <> 'avast!' and $AviableAntivirus <> 'ESET NOD32' Then
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $AviableAntivirus = ' & $AviableAntivirus & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Msgbox(0," Ошибка",' Определить Антивирус не удалось, обновление Антивируса не будет выполнено!',5)
	exit
EndIf
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $AviableAntivirus = ' & $AviableAntivirus & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Switch $AviableAntivirus
	Case 'Microsoft Security Essentials'
		if @OSArch = "X86" then $file = 'mpam-fe.exe'
		if @OSArch = "IA64" or @OSArch = "X64" Then $file = 'mpam-fex64.exe'
	Case 'avast!'
		$file = 'vpsupd.exe'
	Case 'ESET NOD32'
		ConsoleWrite(" Действия по обновлению не требуются" &@CRLF)
EndSwitch

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $AviableAntivirus = ' & $AviableAntivirus & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileExists($folder & $file) = ' & FileExists($folder & $file) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

if FileExists($folder & $file) and $AviableAntivirus <> 'ESET NOD32' Then
	$timerUpdate = TimerInit()
	RunWait($folder & $file)
	TrayTip("Обновление","Обновление Вашего Антивируса завершено. Длительность "&Round(TimerDiff($timerUpdate)/1000)&" сек.",3000)
	sleep(3000)
Elseif FileExists($folder & $file) Then
	ConsoleWrite(" Действия по обновлению не требуются" &@CRLF)
Else
	TrayTip("Обновление","Обновление Вашего Антивируса не было произведено",3000)
EndIf

exit


 ;Функция получения параметров из имени файла
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
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Default = ' & $Default & @CRLF) ;### Debug Console
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