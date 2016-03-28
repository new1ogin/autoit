#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Add_Constants=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <IE.au3>
#include <Encoding.au3>
#include <array.au3>
#include <Date.au3>

;~ #RequireAdmin
Opt("WinTitleMatchMode", -1)   ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
HotKeySet("^{F7}", "Terminate")
;~ "[CLASS:]"


#Include <array.au3>
;~ #include <WinAPI.au3>
;~ #include <WinAPIEx.au3>
;~ #include <APIConstants.au3>
;~ #include <WindowsConstants.au3>
#include <WinAPIEx.au3>
#include <Process.au3>
$1cProcess = ProcessList('1cv8.exe')

Run("cmd /k whoami")
for $i=1 to $1cProcess[0][0]
	$tUser = _ProcessGetOwner($1cProcess[$i][1])
	ConsoleWrite($tUser & ' ' & $1cProcess[$i][1] & @CRLF)
	    $aProcessInfo = ProcessGetStats($1cProcess[$i][1])
    if IsArray($aProcessInfo) then ConsoleWrite($aProcessInfo[0]/1024 & ' Kb' & @CRLF)
	    $aData = _WinAPI_GetProcessMemoryInfo($1cProcess[$i][1])
    If IsArray($aData) Then
         ConsoleWrite($aData[2] & ' Kb' & @CRLF)
	 EndIf
;~ 	 $Mem = MemGetStats($1cProcess[$i][1]) ;Узнаём о памяти процеса
;~ 	 ConsoleWrite( "Размер общей физической памяти (KB):" & $mem[1] & @CRLF)
Next
$text = ''
for $i=1 to $1cProcess[0][0]
	$tUser = _ProcessGetOwner($1cProcess[$i][1])
	$text &= $tUser & ' ' & $1cProcess[$i][1] & @CRLF
	    $aProcessInfo = ProcessGetStats($1cProcess[$i][1])
    if IsArray($aProcessInfo) then $text &= $aProcessInfo[0]/1024 & ' Kb' & @CRLF
	    $aData = _WinAPI_GetProcessMemoryInfo($1cProcess[$i][1])
    If IsArray($aData) Then
         $text &= $aData[2] & ' Kb' & @CRLF
	 EndIf
;~ 	 $Mem = MemGetStats($1cProcess[$i][1]) ;Узнаём о памяти процеса
;~ 	 ConsoleWrite( "Размер общей физической памяти (KB):" & $mem[1] & @CRLF)
Next
FileWrite(@ScriptDir & '\test444.txt', $text)
MsgBox(0,'',$text )

Func _ProcessGetOwner($PID, $sComputer = ".")
    Local $objWMI, $colProcs, $sUserName, $sUserDomain
    $objWMI = ObjGet("winmgmts:\\" & $sComputer & "\root\cimv2")
    If IsObj($objWMI) Then
        $colProcs = $objWMI.ExecQuery("Select ProcessId From Win32_Process Where ProcessId=" & $PID)
        If IsObj($colProcs) Then
            For $Proc In $colProcs
                If $Proc.GetOwner($sUserName, $sUserDomain) = 0 Then Return $sUserName
            Next
        EndIf
    EndIf
EndFunc   ;==>_ProcessGetOwner

Exit

Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate


$timer = Timerinit()
$t = _DateDiff("s",'1000/01/01 09:04:11','1000/01/01 09:04:15')
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Exit
$titleTVRD = "[TITLE:Панель TeamViewer (свёрнута); CLASS:TV_ControlWinMinimized]"
$titleTVRD2 = "[TITLE:Панель TeamViewer; CLASS:TV_ControlWin]"
 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Winexists($titleTVRD2) = ' & Winexists($titleTVRD2) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Winexists($titleTVRD) = ' & Winexists($titleTVRD) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$titleTVRD = "Панель TeamViewer (свёрнута)"
$titleTVRD2 = "Панель TeamViewer"
 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Winexists($titleTVRD2) = ' & Winexists($titleTVRD2) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
 ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Winexists($titleTVRD) = ' & Winexists($titleTVRD) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
  $hwnd = WinActivate($titleTVRD)

;~   WinGetTitle($hwnd)
  ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinActivate($titleTVRD) = ' & WinActivate($titleTVRD) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~   WinActive($titleTVRD)
  ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinActive($titleTVRD) = ' & WinActive($titleTVRD) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $hwnd2 = WinActivate($titleTVRD2)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinActivate($titleTVRD2) = ' & WinActivate($titleTVRD2) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
  ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinActive($titleTVRD2) = ' & WinActive($titleTVRD2) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

  ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetTitle($hwnd) = ' & WinGetTitle($hwnd) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
  ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetTitle($hwnd) = ' & WinGetTitle($hwnd2) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

$hwnd = WinActivate($titleTVRD)
WinSetState($hwnd,'',@SW_HIDE)
sleep(500)
WinSetState($hwnd,'',@SW_SHOW)
sleep(500)
WinSetState($hwnd,'',@SW_RESTORE)
sleep(500)
WinSetState($hwnd,'',@SW_MINIMIZE)
sleep(500)
WinSetState($hwnd,'',@SW_RESTORE)
sleep(500)
WinSetState($hwnd,'',@SW_MAXIMIZE)
sleep(500)
WinSetState($hwnd,'',@SW_RESTORE)
sleep(500)

Exit

$sPathTo = @TempDir & '\chkport.exe'
FileInstall('chkport.exe', $sPathTo, 1)
$TestAddress = "95.170.158.122"
;~ $TestAddress = "109.194.37.10"
$TestPort = 3389
$TestTime = 300
$t = TimerInit()
While 1
	$sServer = _CheckPort($TestAddress,$TestPort,$TestTime)
	if not stringInStr($sServer,"not") Then ExitLoop
	sleep(1000)
Wend
MsgBox(64, "Проверка сервера", $sServer)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($t) = ' & TimerDiff($t) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Func _CheckPort($IPAddress,$PortAddress, $WaitTime)
Local $pid = Run($sPathTo&' ' & $IPAddress & ' ' & $PortAddress & ' ' & $WaitTime , @ScriptDir, @SW_HIDE, 0x8)
ProcessWaitClose($pid)
Local $stdout = StdoutRead($pid)
Return $stdout
EndFunc


Exit

;~ $t11 = Ping('109.194.37.11')
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t11 = ' & $t11 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
Opt("TCPTimeout",0)              ;100 миллисекунд
TCPStartup()
Opt("TCPTimeout",0)              ;100 миллисекунд
$t11 = TCPConnect('109.194.37.11', '3391')
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t11 = ' & $t11 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
TCPCloseSocket($t11)
TCPShutdown()
;~ TCPStartup()
;~ $t0 = TimerInit()
;~ For $i=0 to 255
;~ 	$t = TimerInit()
;~ 	$address = "192.168.0." & $i
;~ 	$ping = ping($address, 450)
;~ 	ConsoleWrite(Round(TimerDiff($t0)) & '@@ Debug(' & Round(TimerDiff($t)) & ') : Ping("192.168.0."&$i,100) = ' & $ping & @CRLF ) ;### Debug Console
;~ Next

Exit

$textmsg = $CmdLineRaw & @CRLF
For $i=1 to $CmdLine[0]
	$textmsg &= $CmdLine[$i] & @CRLF
Next
MsgBox(0, "Переданная коммандная строка", $textmsg)

exit

$id ='12185426'
;~ $pos = WinGetPos($hwnd)
;~ _ArrayDisplay($pos)
 $ret = _Reload_Ammyy($id,2000)
 msgbox(0,'',$ret)
Func _Reload_Ammyy($id,$sleep)
	$AmmyHwnd = WinGetHandle("Ammyy Admin")
	WinActivate($AmmyHwnd)
	ControlClick($AmmyHwnd,"",'[CLASS:Button; INSTANCE:4]')
	$ret = ControlGetText($AmmyHwnd,"","[CLASS:Static; INSTANCE:1]")
	sleep($sleep)
;~ 	$pos = WinGetPos($hwnd)
;~ 	While $pos[2] < 640
;~ 		WinActivate($hwnd)
;~ 		MouseMove(333, 103)
;~ 		sleep(30)
;~ 		MouseClick("left",333, 103)
;~ 		ControlClick($hwnd,'','[CLASS:ToolbarWindow32; INSTANCE:1]','left',1,262, 13)
;~ 		sleep($sleep)
;~ 	WEnd
	return $ret
EndFunc



Exit

$t1 = TimerInit()
For $i=0 to 265
	$t1 = Ping("10.8.0."&$i,300)
	ConsoleWrite('@@ Debug(' & $i & ') : $t1 = ' & $t1 & '   ' & '>Error code: ' & @error & @CRLF) ;### Debug Console


Next
;~ TimerDiff($t1)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($t1) = ' & TimerDiff($t1) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Exit
Run(@ComSpec & " /c " & 'timeout /t 1 & if EXIST ' & @TempDir & '\tautoit.txt (D:\autoitv3.3.8.1\Прикладные\IEReload.exe Янд my.yota.ru)', "", @SW_HIDE)

Exit
_DelayReload(3, 'Yota', 'ya.ru')
Func _DelayReload($time, $win, $url)
	$text = 'timeout /t ' & $time & @CRLF & @ScriptDir & '\IEReload.exe ' & $win & ' ' & $url
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $text = ' & $text & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	FileWrite(@TempDir & '\DelayReload4autoit.cmd', _Encoding_ANSIToOEM($text))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @TempDir & ''\DelayReload4autoit.cmd'' = ' & @TempDir & '\DelayReload4autoit.cmd' & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Run(@TempDir & '\DelayReload4autoit.cmd', "", @SW_HIDE)
EndFunc
;~ Run(@ComSpec & " /c " & 'D:\autoitv3.3.8.1\Прикладные\IEReload.exe Yota my.yota.ru', "", @SW_HIDE)
;~ Run(@ComSpec & " /c " & 'D:\autoitv3.3.8.1\Прикладные\IEReload.exe Yota ya.ru', "", @SW_HIDE)