#include <GUIConstantsEx.au3>
#include <Misc.au3>
#include <Inet.au3>
;
;~ Global $sAppUpdate_Page = "http://creator-lab.ucoz.ru/Testing_Zone/MyApp_Update.inf"
;~ Global $sAppUpdate_Page = "http://www.new1ogin.guru-hosting.ru/files/MyApp_Update.inf"
Global $sAppUpdate_Page = "http://www.new1ogin.guru-hosting.ru/files/Autoshot_Update.inf"
Global $sApp_Version = "0.1"

Global $hGUI = 0

;Here we checking in quiet mode (only if new version available there will be a message).
_AppCheckUpdates_Proc($sAppUpdate_Page, $sApp_Version, 1)

#Region GUI Part
$hGUI = GUICreate("My Application", 300, 200)

$CheckUpdates_Button = GUICtrlCreateButton("Check Updates", 200, 170, 90, 20)
$Exit_Button = GUICtrlCreateButton("Exit", 20, 170, 60, 20)

GUISetState(@SW_SHOW, $hGUI)
#EndRegion GUI Part
;

While 1
    Switch GUIGetMsg()
        Case $GUI_EVENT_CLOSE, $Exit_Button
            Exit
        Case $CheckUpdates_Button
            _AppCheckUpdates_Proc($sAppUpdate_Page, $sApp_Version)
    EndSwitch
WEnd

Func _AppCheckUpdates_Proc($sServer_Page, $sCurrent_AppVersion, $iMode=-1) ;$iMode <> -1 to check quitly
    Local $sUpdate_Info = _INetGetSource($sServer_Page)

    If Not StringInStr($sUpdate_Info, "[Info]") Then
        If $iMode = -1 Then MsgBox(48, "Update check", _
            StringFormat("There was an error (%i) to check update, please contact with the author.", 1), 0, $hGUI)

        Return SetError(1, 0, 0)
    EndIf

    Local $sUpdate_Version = StringRegExpReplace($sUpdate_Info, "(?s)(?i).*Update Version=(.*?)(\r|\n).*", "\1")
    Local $sUpdate_File = StringRegExpReplace($sUpdate_Info, "(?s)(?i).*Update File=(.*?)(\r|\n).*", "\1")

    If _VersionCompare($sUpdate_Version, $sCurrent_AppVersion) = 1 Then
        Local $iUpdate_Ask = MsgBox(36, "Update check", _
            StringFormat("There is new version available (%s).\n\nWould you like to download the update?", $sUpdate_Version), _
            0, $hGUI)

        If $iUpdate_Ask <> 6 Then Return 0

        Local $sScript_Name = StringTrimRight(@ScriptName, 4) & ".efe"

        Local $iInetGet = InetGet($sUpdate_File, @TempDir & "\" & $sScript_Name)

        If @error Or Not $iInetGet Then
            If $iMode = -1 Then MsgBox(48, "Update check", _
                StringFormat("There was an error (%i) to download the update, please contact with the author.", 2), 0, $hGUI)

            Return SetError(2, 0, 0)
        EndIf

        Run(@ComSpec & ' /c Ping -n 2 localhost > nul & Move /y "' & _
            @TempDir & '\' & $sScript_Name & '" "' & @ScriptFullPath & '" & Start "" "' & @ScriptFullPath & '"', '', @SW_HIDE)

        Exit
    EndIf

    If $iMode = -1 Then MsgBox(48, "Update check", "You are using the newest version of this software.", 0, $hGUI)
    Return 1
EndFunc