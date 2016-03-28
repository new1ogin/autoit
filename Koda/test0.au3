#Include <WinAPIEx.au3>
#include <Inet.au3>
#include <File.au3>
#include <log.au3>
#include <array.au3>
HotKeySet("{End}", "Terminate") ;забиваем клавиши для функций
HotKeySet("{Ins}", "_Pause")
Func Terminate() ;функция выхода
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
;~ 	_EndWindow()
	Exit 0
EndFunc   ;==>Terminate
global $Paused
Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		If $trayP = 1 Then
			TrayTip("Подсказка", "Пауза", 1000)
		EndIf
		Sleep(100)
	WEnd
EndFunc   ;==>_Pause

$TestFileName = "WakeOnLanGet(d300)"
$sleepWakeOnLanGet = _GetParamsOfFileName('delay', 'd', "Введите количество секунд задержки в имя файла в формате (delay300)")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sleepWakeOnLanGet = ' & $sleepWakeOnLanGet & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
exit
$hLog = _Log_Open(@ScriptDir & '\WakeMeOnLan.log', '### Лог программы WakeMeOnLan ###')

$hwnd = WinGetHandle('WakeMeOnLan')
$iState = WinGetState($hwnd, "")
While 1

	_SendF5($iState)

	$ItemCount=ControlListView( $hwnd, "",'SysListView321',"GetItemCount")
	$SubItemCount=ControlListView( $hwnd, "",'SysListView321',"GetSubItemCount")
	$Content=''
	For $i=0 to $ItemCount
		For $j=0 to $SubItemCount
			$Content&=ControlListView( $hwnd, "",'SysListView321',"GetText", $i, $j) & '|'
		Next
		$Content&=@CRLF
	Next
	;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Content = ' & $Content & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	_Log_Report($hLog, '$Content = ' & @CRLF& $Content & @CRLF & @CRLF) ;### Debug Console

	sleep($sleepWakeOnLanGet)
Wend


_Log_Close($hLog)

Func _SendF5($iState)
	If BitAND($iState, 16) Then
		If BitAND($iState, 32) Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : BitAND($iState, 16) = ' & BitAND($iState, 16) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			ControlSend($hwnd,'','','{F5}')
		Else
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : BitAND($iState, 16) = ' & BitAND($iState, 16) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			WinSetState ( $hwnd, "", @SW_RESTORE)
			$iState2='1'
			While BitAND($iState2, 16)
				sleep(50)
				$iState2 = WinGetState($hwnd, "")
			WEnd
			ControlSend($hwnd,'','','{F5}')
			WinSetState ( $hwnd, "", @SW_MINIMIZE)
		EndIf
	Else
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : BitAND($iState, 16) = ' & BitAND($iState, 16) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		ControlSend($hwnd,'','','{F5}')
	EndIf
EndFunc

;~ WinMove($hwnd,'',1980,1080)

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

Func _WinGetHandleEx($iPID, $sClassNN="", $sPartTitle="", $sText="", $iVisibleOnly=1)
    If IsString($iPID) Then $iPID = ProcessExists($iPID)
	Dim $ResultList[1]
    Local $sWList_Str = "[CLASS:" & $sClassNN & ";REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"
    If $sClassNN = "" Then $sWList_Str = "[REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"

    Local $aWList = WinList($sWList_Str, $sText)
    If @error Then Return SetError(1, 0, "")
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aWList[0][0] = ' & $aWList[0][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    For $i = 1 To $aWList[0][0]
        If WinGetProcess($aWList[$i][1]) = $iPID Then
            If Not $iVisibleOnly Or ($iVisibleOnly And BitAND(WinGetState($aWList[$i][1]), 2)) Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($ResultList) = ' & Ubound($ResultList) & ') : WinGetTitle($aWList[$i][1]) = ' & WinGetTitle($aWList[$i][1]) & ') : $aWList[$i][1] = ' & $aWList[$i][1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				if $ResultList[0]>0 then  Redim $ResultList[Ubound($ResultList)+1]
				$ResultList[Ubound($ResultList)-1]=$aWList[$i][1]
;~ 				Return $aWList[$i][1]
			EndIf
        EndIf
    Next
;~ 	_ArrayDisplay($ResultList)
	if not @error and Ubound($ResultList)>0 and $ResultList[0]>0 then Return $ResultList
    Return SetError(2, 0, "")
EndFunc