#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=quick_restart_9379.ico
#AutoIt3Wrapper_Outfile=C:\Users\Anya\Desktop\restartWIFI.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <FileOperations.au3>
#include <array.au3>
Global $hwndDiag, $titleDiag
$ndfile = _FO_FileSearch(@ScriptDir, 'ND*.tmp', True, 1)
If UBound($ndfile) >= 2 Then $ndfile = $ndfile[1]
$titleDiag = 'Диагностика сетей Windows'
$sleepwait = 500

HotKeySet('{ESC}', '_Exit')

_DiagnostAdapterStart()
_DiagnostAdapterWait()
_WIFIhostednetworkRestartCMD()
Exit


Func _DiagnostAdapterStart()
	If Not WinExists($titleDiag) Then Run("C:\Windows\System32\msdt.exe -skip TRUE -path C:\Windows\diagnostics\system\networking -af " & _
			'"' & $ndfile & '" -ep NetworkDiagnosticsGenericNetConnection')
	WinWait($titleDiag, '', 20)
	$hwndDiag = WinGetHandle($titleDiag)
	Sleep($sleepwait)
EndFunc   ;==>_DiagnostAdapterStart

Func _DiagnostAdapterWait()
	While WinExists($hwndDiag)
		WinActivate($hwndDiag)
;~ 		ConsoleWrite(StringStripWS(WinGetText($hwndDiag), 3) & @CRLF)
		$WinText = StringStripWS(WinGetText($hwndDiag), 3)
		If StringLen(StringStripWS(StringReplace(WinGetText($hwndDiag), 'Отмена', ''), 3)) < 3 Then
			;ждать
			Sleep(1000)
		EndIf
		$text = 'Проверьте, устранена ли проблема'
		$class = '[CLASS:Button; INSTANCE:4]'
		If StringInStr($WinText, $text) Then
			ConsoleWrite($text & @CRLF)
			ControlClick($hwndDiag, $text, '')
			ControlClick($hwndDiag, '', $class)
			Sleep(500)
		EndIf
		$text = '&Далее'
		$class = '[CLASS:Button; INSTANCE:1]'
		If StringInStr($WinText, $text) Then
			ConsoleWrite($text & @CRLF)
			ControlClick($hwndDiag, $text, '')
			ControlClick($hwndDiag, '', $class)
			ControlSend($hwndDiag, '', $class, '{TAB}')
			Sleep(500)
		EndIf
		$text = 'Внести это исправление'
		$class = '[CLASS:Button; INSTANCE:4]'
		If StringInStr($WinText, $text) Then
			ConsoleWrite($text & @CRLF)
			ControlClick($hwndDiag, $text, '')
			ControlClick($hwndDiag, '', $class)
			ControlSend($hwndDiag, '', $class, '{TAB}')
			Sleep(500)
		EndIf
		$text = 'Закрыть модуль устранения неполадок'
		$class = '[CLASS:Button; INSTANCE:8]'
		If StringInStr($WinText, $text) Then
			ConsoleWrite($text & @CRLF)
			ControlClick($hwndDiag, $text, '')
			ControlClick($hwndDiag, '', $class)
			Sleep(1000)
			ExitLoop
		EndIf
		Sleep(100)
		If WinExists('[TITLE:Дополнительные сведения; CLASS:CabinetWClass]') Then WinClose('[TITLE:Дополнительные сведения; CLASS:CabinetWClass]')
	WEnd
	If WinExists('[TITLE:Дополнительные сведения; CLASS:CabinetWClass]') Then WinClose('[TITLE:Дополнительные сведения; CLASS:CabinetWClass]')

EndFunc   ;==>_DiagnostAdapterWait

Func _WIFIhostednetworkRestartCMD()
	$text = 'netsh wlan disconnect' & @CRLF & _
	'netsh wlan stop hostednetwork' & @CRLF & _
	'netsh wlan set hostednetwork mode=disallow' & @CRLF & _
	'netsh wlan show hostednetwork' & @CRLF & _
	'netsh wlan set hostednetwork ssid="Notebook2" key="Vitalya1Anya2Doma3" keyUsage=persistent' & @CRLF & _
	'netsh wlan set hostednetwork mode=allow' & @CRLF & _
	'netsh wlan show hostednetwork' & @CRLF & _
	'netsh wlan start hostednetwork ' & @CRLF & _
	'timeout /t 15'
	$file = @TempDir & '\WIFIhostednetworkRestart.cmd'
	if FileExists($file) Then FileDelete($file)
	FileWrite($file,$text)
	sleep(500)
	RunWait($file)
EndFunc


Func _Exit()
	Exit
EndFunc   ;==>_Exit
