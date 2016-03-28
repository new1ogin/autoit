#RequireAdmin

HotKeySet("^+{F7}", "_Quit") ;Это вызов

#include <array.au3>
;~ $a = WinList("Ammyy Admin - удаленный доступ и удаленный рабочий стол - купить. - Internet Explorer")
;~ _ArrayDisplay($a)
;~ exit

$sleep = 3000
$desktopW = 1024
$desktopH = 768
$CheckRD = 0
$TVCommer = "[TITLE:Предполагается коммерческое использование; CLASS:#32770]"
$TVCommer2 = "[TITLE:Обнаружено коммерческое использование; CLASS:#32770]"
$TVSponser = "[TITLE:Спонсируемый сеанс; CLASS:#32770]"
$titleGoogleRD = '[CLASS:#32770]'
$textGoogleRD = 'В настоящее время доступ к вашему рабочему столу предоставлен пользователю'
$titleTVRD = "[TITLE:Панель TeamViewer (свёрнута); CLASS:TV_ControlWinMinimized]"
$titleTVRD2 = "[TITLE:Панель TeamViewer; CLASS:TV_ControlWin]"
$AmmytBuy = "[TITLE:Ammyy Admin - удаленный доступ и удаленный рабочий стол - купить. - Internet Explorer; CLASS:IEFrame]"
$AmmytBuy2 = "[TITLE:http://www.ammyy.com/ru/buy.html?aa=1 - Internet Explorer; CLASS:IEFrame]"
;~ $titleTVRD = "[TITLE:; CLASS:]"

;бесконечный цикл проверок
;~ Sleep(5000)
While 1
if $CheckRD = 0 and Winexists($titleGoogleRD, $textGoogleRD) Then
	$oldDesktopW = @DesktopWidth
	$oldDesktopH = @DesktopHeight
	$oldDesktopR = @DesktopRefresh
	$hwndRDG = WingetHandle($titleGoogleRD, $textGoogleRD)
	$vRes = _ChangeScreenRes($desktopW, $desktopH, 16, 60)
	$CheckRD = 1
;~ 	msgbox(0,'','$CheckRD = ' & $CheckRD & @CRLF & Winexists($titleGoogleRD, $textGoogleRD))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $vRes = ' & $vRes & @CRLF) ;### Debug Console
EndIf
if Winexists($titleTVRD) Then ; определение действующего подключения по положению окна
	$titleTVRDpos = WinGetPos($titleTVRD)
	if not @error Then
		if @DesktopHeight - $titleTVRDpos[1] > 135 Then
			$TVRD = 1
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TVRD = ' & $TVRD & @CRLF) ;### Debug Console
		Else
			$TVRD = 0
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TVRD = ' & $TVRD & @CRLF) ;### Debug Console
		EndIf
	EndIf
EndIf
if Winexists($titleTVRD2) Then ; определение действующего подключения по положению окна
	$titleTVRD2pos = WinGetPos($titleTVRD2)
	if not @error Then
		if $titleTVRD2pos[3] > 180 Then
			$TVRD = 1
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TVRD = ' & $TVRD & @CRLF) ;### Debug Console
		Else
			$TVRD = 0
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TVRD = ' & $TVRD & @CRLF) ;### Debug Console
		EndIf
	EndIf
EndIf


if $CheckRD = 0 and $TVRD = 1 Then
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TVRD = ' & $TVRD & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $CheckRD = ' & $CheckRD & @CRLF) ;### Debug Console
		$oldDesktopW = @DesktopWidth
		$oldDesktopH = @DesktopHeight
		$oldDesktopR = @DesktopRefresh
		$vRes = _ChangeScreenRes($desktopW, $desktopH, 16, 60)
		$CheckRD = 1
;~ 		msgbox(0,'','$CheckRD = ' & $CheckRD & @CRLF & Winexists($titleTVRD) & Winexists($titleTVRD2))
EndIf

; Возврат разрешения экрана
If $CheckRD = 1 and not Winexists($titleGoogleRD, $textGoogleRD) and $TVRD = 0 Then
	$vRes = _ChangeScreenRes($oldDesktopW, $oldDesktopH, 32, $oldDesktopR)
	$CheckRD = 0
EndIf
if $CheckRD = 1 Then
	if not Winexists($titleTVRD) or not Winexists($titleTVRD2) or $TVRD = 0 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Winexists($titleTVRD2) = ' & Winexists($titleTVRD2) & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Winexists($titleTVRD) = ' & Winexists($titleTVRD) & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TVRD = ' & $TVRD & @CRLF) ;### Debug Console
		$vRes = _ChangeScreenRes($oldDesktopW, $oldDesktopH, 32, $oldDesktopR)
		$CheckRD = 0
		$TVRD = 0
	EndIf
EndIf

; другие условия работы с всплывающими окнами
if WinExists($TVSponser) Then ControlClick($TVSponser,'','[CLASS:Button; INSTANCE:4]')
if WinExists($TVCommer) Then WinClose($TVCommer)
if WinExists($TVCommer2) Then WinClose($TVCommer2)
if WinExists($AmmytBuy) or 1 Then
	$ammyProcess=ProcessList('AA_v3.5.exe')
	_ArrayDisplay($ammyProcess)
	For $i=1 to $ammyProcess[0][0]
		$a_children = _ProcessGetChildren($ammyProcess[$i][1]) ;Тут вместо $iParent_ProcID можно указать любой другой процесс
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ammyProcess[$i][1] = ' & $ammyProcess[$i][1] & @CRLF) ;### Debug Console
		_ArrayDisplay($a_children)
	Next
	ProcessClose('iexplore.exe')
	ProcessClose('iexplore.exe')
;~ 	_ArrayDisplay($a_children)

;~ 	$thwnd = WinGetHandle($AmmytBuy)
;~ 	ProcessClose('IEXPLORE.EXE')
;~ 	$a = WinList("Ammyy Admin - удаленный доступ и удаленный рабочий стол - купить. - Internet Explorer")

;~ 	WinActivate($a[1][1])
;~ 	Send('!{F4}')
;~ 	WinKill($thwnd)
;~ 	WinKill($a[1][1])
;~ 	WinKill($a[2][1])
;~ 	WinClose($a[1][1])
;~ 	WinClose($a[2][1])
;~ 	WinSetState($a[1][1],'',@SW_ENABLE)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState ($a[1][1]) = ' & WinGetState ($a[1][1]) & @CRLF) ;### Debug Console
;~ 	WinSetState($a[1][1],'',@SW_SHOW)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState ($a[1][1]) = ' & WinGetState ($a[1][1]) & @CRLF) ;### Debug Console
;~ 	WinSetState($a[1][1],'',@SW_RESTORE)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState ($a[1][1]) = ' & WinGetState ($a[1][1]) & @CRLF) ;### Debug Console
;~ 	WinSetState($a[1][1],'',@SW_MAXIMIZE)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState ($a[1][1]) = ' & WinGetState ($a[1][1]) & @CRLF) ;### Debug Console
;~ 	WinSetState($a[1][1],'',@SW_UNLOCK)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState ($a[1][1]) = ' & WinGetState ($a[1][1]) & @CRLF) ;### Debug Console
;~ 	WinClose("[CLASS:IEFrame]")
;~ 	sleep(3000)
;~ 	WinActivate($a[2][1])
;~ 	Send("^w")
;~ 	Send("^ц")
;~ 	WinClose($a[2][1])
;~ 	WinClose($a[2][1])
;~ 	WinSetState($a[2][1],'',@SW_ENABLE)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState ($a[1][1]) = ' & WinGetState ($a[1][1]) & @CRLF) ;### Debug Console
;~ 	WinSetState($a[2][1],'',@SW_ENABLE)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState ($a[1][1]) = ' & WinGetState ($a[1][1]) & @CRLF) ;### Debug Console
;~ 	WinSetState($a[2][1],'',@SW_ENABLE)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState ($a[1][1]) = ' & WinGetState ($a[1][1]) & @CRLF) ;### Debug Console
;~ 	WinSetState($a[2][1],'',@SW_UNLOCK)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetState ($a[1][1]) = ' & WinGetState ($a[1][1]) & @CRLF) ;### Debug Console

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinExists($AmmytBuy) = ' & WinExists($thwnd) & @CRLF) ;### Debug Console
;~ 	WinClose($thwnd)

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinClose($TVCommer2) = ' & WinClose($thwnd) & @CRLF) ;### Debug Console
;~ 	WinSetState($thwnd,'',@SW_MINIMIZE)

EndIf




sleep($sleep)
wend



Func _Quit($message = 0)
	Exit
EndFunc


Func _ProcessGetChildren($i_Pid) ; First level children processes only
    If IsString($i_Pid) Then $i_Pid = ProcessExists($i_Pid)
    If Not $i_Pid Then Return SetError(-1, 0, $i_Pid)

    Local Const $TH32CS_SNAPPROCESS = 0x00000002

    Local $a_tool_help = DllCall("Kernel32.dll", "long", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPPROCESS, "int", 0)
    If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_Pid)

    Local $tagPROCESSENTRY32 = _
            DllStructCreate( _
            "dword dwsize;" & _
            "dword cntUsage;" & _
            "dword th32ProcessID;" & _
            "uint th32DefaultHeapID;" & _
            "dword th32ModuleID;" & _
            "dword cntThreads;" & _
            "dword th32ParentProcessID;" & _
            "long pcPriClassBase;" & _
            "dword dwFlags;" & _
            "char szExeFile[260]")

    DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))

    Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)
    Local $a_pfirst = DllCall("Kernel32.dll", "int", "Process32First", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
    If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_Pid)

    Local $a_pnext, $a_children[11][2] = [[10]], $i_child_pid, $i_parent_pid, $i_add = 0
    $i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")

    If $i_child_pid <> $i_Pid Then
        $i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")

        If $i_parent_pid = $i_Pid Then
            $i_add += 1
            $a_children[$i_add][0] = $i_child_pid
            $a_children[$i_add][1] = DllStructGetData($tagPROCESSENTRY32, "szExeFile")
        EndIf
    EndIf

    While 1
        $a_pnext = DllCall("Kernel32.dll", "int", "Process32Next", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
        If IsArray($a_pnext) And $a_pnext[0] = 0 Then ExitLoop

        $i_child_pid = DllStructGetData($tagPROCESSENTRY32, "th32ProcessID")

        If $i_child_pid <> $i_Pid Then
            $i_parent_pid = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")

            If $i_parent_pid = $i_Pid Then
                If $i_add = $a_children[0][0] Then
                    ReDim $a_children[$a_children[0][0] + 11][2]
                    $a_children[0][0] = $a_children[0][0] + 10
                EndIf

                $i_add += 1
                $a_children[$i_add][0] = $i_child_pid
                $a_children[$i_add][1] = DllStructGetData($tagPROCESSENTRY32, "szExeFile")
            EndIf
        EndIf
    WEnd

    If $i_add <> 0 Then
        ReDim $a_children[$i_add + 1][2]
        $a_children[0][0] = $i_add
    EndIf

    DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])

    If $i_add Then Return $a_children
    Return SetError(3, 0, 0)
EndFunc   ;==>_ProcessGetChildren

Func _ChangeScreenRes($i_Width = @DesktopWidth, $i_Height = @DesktopHeight, $i_BitsPP = @DesktopDepth, $i_RefreshRate = @DesktopRefresh)

    Local Const $DM_PELSWIDTH = 0x00080000

    Local Const $DM_PELSHEIGHT = 0x00100000

    Local Const $DM_BITSPERPEL = 0x00040000

    Local Const $DM_DISPLAYFREQUENCY = 0x00400000

    Local Const $CDS_TEST = 0x00000002

    Local Const $CDS_UPDATEREGISTRY = 0x00000001

    Local Const $DISP_CHANGE_RESTART = 1

    Local Const $DISP_CHANGE_SUCCESSFUL = 0

    Local Const $HWND_BROADCAST = 0xffff

    Local Const $WM_DISPLAYCHANGE = 0x007E

    If $i_Width = "" Or $i_Width = -1 Then $i_Width = @DesktopWidth ; default to current setting

    If $i_Height = "" Or $i_Height = -1 Then $i_Height = @DesktopHeight ; default to current setting

    If $i_BitsPP = "" Or $i_BitsPP = -1 Then $i_BitsPP = @DesktopDepth ; default to current setting

    If $i_RefreshRate = "" Or $i_RefreshRate = -1 Then $i_RefreshRate = @DesktopRefresh ; default to current setting

    Local $DEVMODE = DllStructCreate("byte[32];int[10];byte[32];int[6]")

    Local $B = DllCall("user32.dll", "int", "EnumDisplaySettings", "ptr", 0, "long", 0, "ptr", DllStructGetPtr($DEVMODE))

    If @error Then

        $B = 0

        SetError(1)

        Return $B

    Else

        $B = $B[0]

    EndIf

    If $B <> 0 Then

        DllStructSetData($DEVMODE, 2, BitOR($DM_PELSWIDTH, $DM_PELSHEIGHT, $DM_BITSPERPEL, $DM_DISPLAYFREQUENCY), 5)

        DllStructSetData($DEVMODE, 4, $i_Width, 2)

        DllStructSetData($DEVMODE, 4, $i_Height, 3)

        DllStructSetData($DEVMODE, 4, $i_BitsPP, 1)

        DllStructSetData($DEVMODE, 4, $i_RefreshRate, 5)

        $B = DllCall("user32.dll", "int", "ChangeDisplaySettings", "ptr", DllStructGetPtr($DEVMODE), "int", $CDS_TEST)

        If @error Then

            $B = -1

        Else

            $B = $B[0]

        EndIf

        Select

            Case $B = $DISP_CHANGE_RESTART

                $DEVMODE = ""

                Return 2

            Case $B = $DISP_CHANGE_SUCCESSFUL

                DllCall("user32.dll", "int", "ChangeDisplaySettings", "ptr", DllStructGetPtr($DEVMODE), "int", $CDS_UPDATEREGISTRY)

                DllCall("user32.dll", "int", "SendMessage", "hwnd", $HWND_BROADCAST, "int", $WM_DISPLAYCHANGE, _
                        "int", $i_BitsPP, "int", $i_Height * 2 ^ 16 + $i_Width)

                $DEVMODE = ""

                Return 1

            Case Else

                $DEVMODE = ""

                SetError(1)

                Return $B

        EndSelect

    EndIf

EndFunc ;==>_ChangeScreenRes