#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Ярлык для(s='0.5'd='10').exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <GUIListBox.au3>
#include <array.au3>
#include <GuiEdit.au3>
#Include <WinAPIEx.au3>
#Include <FileOperations.au3>
HotKeySet("^+{F7}", "_Quit") ;Это вызов
Opt("WinTitleMatchMode", -1)   ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
TrayTip("Подсказка", "Пожалйста дождитесь когда сообщения о готовности",5000)

;Сбор параметров из имени файла
$temppatch = 'C:\ChEn_64Port_' ; @TempDir & '\' & @ScriptName
if not FileExists($temppatch & "\cheatengine-i386 (PORTABLE).exe") Then
	msgbox(0,"Ошибка", " Файл " & $temppatch & "\cheatengine-i386 (PORTABLE).exe" & ' Не найден. Убедитесь, что программа Cheat Enginie Portable 6.4 распакована в эту папку')
EndIf

;~ $AutoItExe = "Ярлык для(s='0.5'd='10')"
$speed = _GetParamsOfFileName('speed', 's', '0.5', 1)
$FileName = _GetParamsOfFileName('process', 'p', -1, 1)
if $FileName = -1 then
	$Name = _PathSplitByRegExp(@AutoItExe)
	$Name = $Name[6]
	$FileName = StringRegExpReplace($Name, '\(.*', '')
	_FO_FileSearch ( @ScriptDir, '*'&$FileName&'*' ,True , 0 )
	if @error then
		$FileName = InputBox("Ввод данных","Пожалуйста введите имя процесса для поиска",'')
		if $FileName = "" or @error then exit
	EndIf
EndIf
$FilePatch = _FO_FileSearch ( @ScriptDir, '*'&$FileName&'*' ,True , 0 )
$FileParams = ''
if not @error Then
	$FilePatch=$FilePatch[1]
	if StringInStr($FilePatch,'.lnk') Then
		$t1 = FileGetShortcut ( $FilePatch )
		$FilePatch = $t1[0]
		$FileParams = $t1[2]
	EndIf
	if not StringInStr($FilePatch,'.exe') then
		MsgBox(0,'Ошибка','файл не является исполняемым или ярлыком на исполняемый')
		Exit
	EndIf
Else
	exit
EndIf
$delay = _GetParamsOfFileName('delay', 'd', 10, 1) * 1000
$process = _PathSplitByRegExp($FilePatch)
$process = $process[5]

;проверка на работает ли уже приложение
$HwndProcess = ''
$aListProcess = ProcessList ($process)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $process = ' & $process & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aListProcess[0][0] = ' & $aListProcess[0][0] & @CRLF) ;### Debug Console

For $i = 1 to $aListProcess[0][0]
	$ThisPatch = _WinAPI_GetProcessFileNameEx($aListProcess[$i][1])
	if $ThisPatch = '' then $ThisPatch = _WinAPI_GetProcessFileName($aListProcess[$i][1])
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ThisPatch = ' & $ThisPatch & @CRLF) ;### Debug Console
	if $ThisPatch = $FilePatch Then
		$HwndProcess = $aListProcess[$i][1]
		$HwndProcess = _WinGetHandleEx($aListProcess[$i][1])
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetProcess ($aListProcess[$i][0]) = ' & $HwndProcess & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	EndIf
Next
if $HwndProcess = '' then
	;Запуск взламываемого приложения
	ShellExecute ($FilePatch, $FileParams)
	;Получение Hendle Запущеного процесса
	$aListProcess = ProcessList ($process)
	if @error then
		msgbox(0, "Ошибка", "Приложение "&$FilePatch&" не удалось запустить")
		Exit
	EndIf
	For $i = 1 to $aListProcess[0][0]
		$ThisPatch = _WinAPI_GetProcessFileNameEx($aListProcess[$i][1])
		if $ThisPatch = '' then $ThisPatch = _WinAPI_GetProcessFileName($aListProcess[$i][1])
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ThisPatch = ' & $ThisPatch & @CRLF) ;### Debug Console
		if $ThisPatch = $FilePatch Then
			$HwndProcess = $aListProcess[$i][1]
			$HwndProcess = _WinGetHandleEx($aListProcess[$i][1])
		EndIf
	Next
EndIf
if $HwndProcess = '' then
	$HwndProcess = $aListProcess[$i][1]
	$HwndProcess = _WinGetHandleEx($aListProcess[$aListProcess[0][0]][1])
EndIf

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $HwndProcess = ' & $HwndProcess & @CRLF) ;### Debug Console

;Ожидание загрузки приложения
ConsoleWrite('Ожидание загрузки приложения '& @CRLF) ;### Debug Console
Sleep($delay)
;Запуск Cheat
if not WinExists("Cheat Engine") then Run ( $temppatch & "\cheatengine-i386 (PORTABLE).exe")
;Отменяет вопрос о Tutorial
RegWrite("HKEY_CURRENT_USER\Software\Cheat Engine", "First Time User", "REG_DWORD", 00000000)


While 1
	ConsoleWrite('Ожидание Появление окна Cheat Engine '& @CRLF) ;### Debug Console
	if WinExists("Confirmation","&Yes") then
		WinActivate("Confirmation","&Yes")
		ControlClick("Confirmation","&Yes",'[CLASS:Button; INSTANCE:2]',"left",1)
	EndIf

	if WinExists("Cheat Engine") = 1 Then
		Sleep(500)
		$hWndCheat = WinGetHandle("Cheat Engine")
		WinActivate($hWndCheat)
		WinWaitActive($hWndCheat)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hWndCheat = ' & "Cheat Engine" & @CRLF) ;### Debug Console
;~ 		ControlClick($hWndCheat,"",'[CLASS:Window; INSTANCE:3]',"left",1,15,15)
		ControlSend($hWndCheat,'','',"{alt}")
		ControlSend($hWndCheat,'','',"{down}")
		ControlSend($hWndCheat,'','',"{down}")
		ControlSend($hWndCheat,'','',"{down}")
		ControlSend($hWndCheat,'','',"{Enter}")
		if WinWait("Process List",'',1) then exitloop
		sleep(64)
	EndIf
WEnd

$hWin =WinWait("Process List")
sleep(500)
If Not $hWin Then Exit -1
$hList = ControlGetHandle($hWin, '', '[CLASS:LCLListBox; INSTANCE:1]')
If Not $hList Then Exit -2
$iCountString = _GUICtrlListBox_GetCount($hList)
ConsoleWrite('CountString: ' & $iCountString & @LF)
 ;Поиска пункта перебором
;~ Dim $aListbox[$iCountString]
;~ $IndexListBox=0
;~ For $t=0 to 9
;~ 	For $i = 0 To $iCountString - 1
;~ 		$sString = _GUICtrlListBox_GetText($hList, $i)
;~ 		$aListbox[$i] = $sString
;~ 	;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sString = ' & $sString & @CRLF) ;### Debug Console
;~ 		if StringInStr($sString,$FileName) then
;~ 			$IndexListBox = $i
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $IndexListBox = ' & $IndexListBox & @CRLF) ;### Debug Console
;~ 			exitloop 2
;~ 		EndIf
;~ 	Next
;~ 	sleep(100)
;~ Next
 ;Поиска пункта функцией
$IndexListBox = _GUICtrlListBox_FindInText($hList, $process )
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $IndexListBox = ' & $IndexListBox & @CRLF) ;### Debug Console

;Выбор пункта клавиатурой
;~ $textProcessClick = "{Home}"
;~ For $i=1 to $IndexListBox
;~ 	$textProcessClick &= '{Down}'
;~ Next
;~ ControlSend($hWin,"","[CLASS:LCLListBox; INSTANCE:1]",$textProcessClick)

;Выбор пункта мышкой
;~ _GUICtrlListBox_ClickItem($hList, $IndexListBox, "left")

;Выбор пункта мышкой2
_GUICtrlListBox_SetCurSel($hList, $IndexListBox)

;~ sleep(1500)
ControlClick($hWin,'','[CLASS:Button; INSTANCE:3]',"left",1)
;~ sleep(1500)

_WaitAndClick($hWndCheat, 'Enable Speedhack', 1)

_WaitAndClick($hWndCheat, 'Apply', 0) ;Ожидание появления кнопки

sleep(100)
$hListEdit = ControlGetHandle($hWndCheat, '', '[CLASS:Edit; INSTANCE:1]')
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hListEdit = ' & $hListEdit & @CRLF) ;### Debug Console
_GUICtrlEdit_SetText($hListEdit, $speed)
_WaitAndClick($hWndCheat, 'Apply', 1)

Msgbox(0,"Выполнено", "Замедление уже должно быть применено. Можете нажать ОК, чтобы попасть в окно игры.",5)
WinSetState ( $hWndCheat, "", @SW_MINIMIZE  )
WinActivate ($HwndProcess)

Exit

Func _Quit($message = 0)
	Exit
EndFunc

Func _WaitAndClick($hWndCheat, $text,$clicks=1)
	local $aData,  $t1
	$aData = _WinGetControls($hWndCheat)
	For $t=0 to 39
		For $i = 1 to $aData[0][0]
			$t1 = ControlGetText($hWndCheat,'',$aData[$i][0])
			if StringInStr($t1,$text) Then
				if $clicks <> 0 then ControlClick($hWndCheat,'',$aData[$i][0],"left",$clicks)
				ConsoleWrite($t1&' = '&$aData[$i][0] &@CRLF)
				exitloop 2
			EndIf
		Next
		Sleep(100)
		if $clicks = 0 then $aData = _WinGetControls($hWndCheat)
	Next
EndFunc

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

; #DEMOFUNCTION# ================================================================================================================
; Name...........:  _WinGetControls
; Description ...:  Liefert ein 2D-Array fur die Controls eines Fensters.
;                   Das Array enhalt fur jedes Control die folgenden Informationen:
;                   |[0] HWND    - HWND des Controls
;                   |[1] Class   - Klasse des Controls
;                   |[2] NN      - ClassNN des Controls
;                   |[3] ID      - ID des Controls
;                   |[4] Visible - Sichtbar? 1 = ja, 0 = nein
;                   Das Feld Array[0][0] enthalt die Anzahl der Controls.
; Syntax.........:  _WinGetControls($hWnd)
; Parameters ....:  $hWnd   - HWND des Fensters (z.B. Ruckgabewert von GUICreate)
; Return values .:  Erfolg: Controlarray
;                   Fehler: False, @error = 1
; Author ........:  Gro?vater (www.autoit.de)
; Modified.......:
; Remarks .......:
; Related .......:
; Link ..........:
; Example .......:
; ===============================================================================================================================
Func _WinGetControls($hWnd)
    Local $hCB
    If Not IsHWnd($hWnd) Then Return SetError(1, 0, False)
    __WinGetControlsAddControl("Init", 0)
    $hCB = DLLCallbackRegister("__WinGetControlsAddControl", "Int", "HWND;LPARAM")
    DllCall("User32.dll", "Int", "EnumChildWindows", "HWND", $hWnd, "Ptr", DllCallbackGetPtr($hCB), "LPARAM", $hWnd)
    If @error Then Return SetError(DllCallbackFree($hCB), 0, False)
    DllCallbackFree($hCB)
    Return __WinGetControlsAddControl("Result", 0)
EndFunc

; #INTERNAL_USE_ONLY# ===========================================================================================================
; Name...........:  __WinGetControlsAddControl
; Description ...:  Callback-Funktion fur DLLCall "EnumChildWindows" in _WinGetControls
; Remarks .......:  Weil ich globale Variable fur die Ruckgabe von Funktionswerten nicht mag und die Implementierung
;                   der statischen Arrays recht rudimentar ist, sind die maximale Anzahl von Controls auf 1024
;                   und die maximale Anzahl von Klassen auf 256 begrenzt.
; ===============================================================================================================================
Func __WinGetControlsAddControl($hWnd, $lParam)
    Local Static $UControls = 1024
    Local Static $UClasses = 256
    Local Static $aControls[$UControls + 1][5]
    Local Static $aClasses[$UClasses + 1][2]
    Local $aResult, $C, $Class, $ClassExist, $ID, $NN
    Switch $hWnd
        Case "Init"
            $aControls[0][0] = 0
            $aClasses[0][0] = 0
            Return
        Case "Result"
            $C = $aControls[0][0] + 1
            $aResult = $aControls
            Redim $aResult[$C][5]
            Return $aResult
    EndSwitch
    $aResult = DllCall("User32.dll", "Int", "GetClassNameW", "HWND", $hWnd, "WStr", "", "Int", 260)
    If @error Or $aResult[0] = 0 Then Return True
    $Class = $aResult[2]
    $aResult = DllCall("User32.dll", "Int", "GetDlgCtrlID", "HWND", $hWnd)
    If @error Or $aResult[0] = 0 Then Return True
    $ID = $aResult[0]
    $ClassExist = False
    $C = $aClasses[0][0]
    For $I = 1 To $C
        If $aClasses[$I][0] = $Class Then
            $NN = $aClasses[$I][1] + 1
            $aClasses[$I][1] = $NN
            $ClassExist = True
            ExitLoop
        EndIf
    Next
    If Not $ClassExist Then
        $NN = 1
        $C += 1
        If $C > $UClasses Then Return False
        $aClasses[0][0] = $C
        $aClasses[$C][0] = $Class
        $aClasses[$C][1] = $NN
    EndIf
    $C = $aControls[0][0] + 1
    If $C > $UControls Then Return False
    $aControls[0][0]  = $C
    $aControls[$C][0] = $hWnd
    $aControls[$C][1] = $Class
    $aControls[$C][2] = $NN
    $aControls[$C][3] = $ID
    $aControls[$C][4] = ControlCommand(HWnd($lParam), "", $ID, "IsVisible", "")
    Return True
EndFunc

; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_GetProcessFileNameEx
; Description....: Retrieves the fully-qualified path to the executable file for the specified 32-bit or 64-bit process.
; Syntax.........: _WinAPI_GetProcessFileNameEx ( [$PID] )
; Parameters.....: $PID    - The PID of the process. Default (0) is the current process.
; Return values..: Success - The fully-qualified path to the executable file.
;                  Failure - Empty string and sets the @error flag to non-zero.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function requires Windows Vista or later.
; Related........:
; Link...........: @@MsdnLink@@ QueryFullProcessImageName
; Example........: Yes
; ===============================================================================================================================

Func _WinAPI_GetProcessFileNameEx($PID = 0)

    If Not $PID Then
        $PID = @AutoItPID
    EndIf

    Local $hProcess = DllCall('kernel32.dll', 'ptr', 'OpenProcess', 'dword', __Iif($__WINVER < 0x0600, 0x00000400, 0x00001000), 'int', 0, 'dword', $PID)

    If (@error) Or (Not $hProcess[0]) Then
        Return SetError(1, 0, '')
    EndIf

    Local $Path = _WinAPI_QueryFullProcessImageName($hProcess[0])

    _WinAPI_CloseHandle($hProcess[0])
    If Not $Path Then
        Return SetError(1, 0, '')
    EndIf
    Return $Path
EndFunc   ;==>_WinAPI_GetProcessFileNameEx

; #FUNCTION# ====================================================================================================================
; Name...........: _WinAPI_QueryFullProcessImageName
; Description....: Retrieves the full name of the executable image for the specified process.
; Syntax.........: _WinAPI_QueryFullProcessImageName ( $hProcess )
; Parameters.....: $hProcess - A handle to the process. The handle must have the $PROCESS_QUERY_INFORMATION or
;                              $PROCESS_QUERY_LIMITED_INFORMATION access right.
; Return values..: Success   - The fully-qualified path to the module.
;                  Failure   - Empty string and sets the @error flag to non-zero.
; Author.........: Yashied
; Modified.......:
; Remarks........: This function requires Windows Vista or later.
; Related........:
; Link...........: @@MsdnLink@@ QueryFullProcessImageName
; Example........: Yes
; ===============================================================================================================================

Func _WinAPI_QueryFullProcessImageName($hProcess)

    Local $Ret = DllCall('kernel32.dll', 'int', 'QueryFullProcessImageNameW', 'ptr', $hProcess, 'dword', 0, 'wstr', '', 'dword*', 4096)

    If (@error) Or (Not $Ret[0]) Then
        Return SetError(1, 0, '')
    EndIf
    Return $Ret[3]
EndFunc   ;==>_WinAPI_QueryFullProcessImageName

Func _PathSplitByRegExp($sPath,$pDelim='')
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"

    $aRetArray[0] = $sPath ;Full path
    $aRetArray[1] = StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
    $aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
    $aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
    $aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
    $aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
    $aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
    $aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file

    Return $aRetArray
EndFunc

Func _WinGetHandleEx($iPID, $sClassNN="", $sPartTitle="", $sText="", $iVisibleOnly=1)
    If IsString($iPID) Then $iPID = ProcessExists($iPID)

    Local $sWList_Str = "[CLASS:" & $sClassNN & ";REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"
    If $sClassNN = "" Then $sWList_Str = "[REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"

    Local $aWList = WinList($sWList_Str, $sText)
    If @error Then Return SetError(1, 0, "")

    For $i = 1 To $aWList[0][0]
        If WinGetProcess($aWList[$i][1]) = $iPID Then
            If Not $iVisibleOnly Or ($iVisibleOnly And BitAND(WinGetState($aWList[$i][1]), 2)) Then Return $aWList[$i][1]
        EndIf
    Next

    Return SetError(2, 0, "")
EndFunc