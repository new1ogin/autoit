
;~ #include<Process.au3>
;~ _RunDOS('netsh interface set interface "Local Area Connection" DISABLE') ; выкл "Local Area Connection"
;~ sleep(5000)
;~ _RunDOS('netsh interface set interface "Local Area Connection" ENABLE') ; вкл "Local Area Connection"

; Отключение устройства (сетевой карты)
;~ RunWait(@ScriptDir & '\devcon.exe disable @PCI\VEN_10EC&DEV_8168*', '', @SW_HIDE)
;~ sleep(5000)
; Включение устройства (сетевой карты)
;~ RunWait(@ScriptDir & '\devcon.exe enable @PCI\VEN_10EC&DEV_8168*', '', @SW_HIDE)

;~ USB\VID_0DB0&PID_6877&REV_0001


Run(@ComSpec & " /c " & "devcon disable =net *PCI*", "", @SW_HIDE)
Run(@ComSpec & " /c " & "devcon disable =net *USB*", "", @SW_HIDE)
; Ждем 3 секунды
Sleep (500)
; Запускаем сетевые подключения сново
Run(@ComSpec & " /c " & "devcon enable =net *PCI*", "", @SW_HIDE)
Run(@ComSpec & " /c " & "devcon enable =net *USB*", "", @SW_HIDE)


;~ 	 _NetConnection_Verb("Подключение по локальной сети", "&Отключить")
;~ 	;_NetConnection_Verb("Local Area Connection", "Disa&ble")

;~ 	MsgBox (48, "Сообщение", "Адаптер отключен!")

;~ 	;_NetConnection_Verb("Local Area Connection", "En&able")
;~ 	 _NetConnection_Verb("Подключение по локальной сети", "&Включить")

;~ 	MsgBox (64, "Сообщение", "Адаптер включен!")

;~ 	Func _NetConnection_Verb($sConnectionName, $sVerb)
;~ 	;   Local $sFolderName = "Network Connections"
;~ 		Local $sFolderName = "Сетевые подключения"
;~ 		Local $oNetConnections, $oConnection
;~ 		Local $oShellApp = ObjCreate("Shell.Application")
;~ 		Local $oControlPanel = $oShellApp.Namespace(3)
;~ 		For $oFolderItem In $oControlPanel.Items
;~ 			If $oFolderItem.Name = $sFolderName Then
;~ 				$oNetConnections = $oFolderItem.GetFolder
;~ 				ExitLoop
;~ 			EndIf
;~ 		Next
;~ 		If Not(IsObj($oNetConnections)) Then Return SetError(1, 0, False)
;~ 		For $oFolderitem In $oNetConnections.Items
;~ 			If StringInStr($oFolderitem.Name, $sConnectionName) Then
;~ 				$oConnection = $oFolderitem
;~ 				ExitLoop
;~ 			EndIf
;~ 		Next
;~ 		If Not(IsObj($oConnection)) Then Return SetError(2, 0, False)
;~ 		$oConnection.InvokeVerb($sVerb)
;~ 		Sleep(1000)
;~ 	EndFunc