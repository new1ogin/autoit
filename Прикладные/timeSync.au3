#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=timeSync(add24delay15).exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <Date.au3>
#include <GUIConstantsEx.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
;~ #include <GIFAnimation.au3>
#include <File.au3>
#include <Array.au3>
Opt("mustdeclarevars",1)

Dim $NTP_Server[4] = ['time.nist.gov', 'pool.ntp.org', 'ntp.amnic.net', 'ntp.stairweb.de'], $NTP_IP[4], $NTPIP[4]

Global $gui_sync, $x, $y, $label_sync, $label_sync_status, $gif, $noSync=0

global $height = 240
global $width = 180
global $width_sync = 180
global $height_sync = 48

global $speed = 25
global $count_end = (@DesktopWidth / 2 + ($width_sync / 2)) / $speed
global $count = (@DesktopWidth / 2 - ($width_sync / 2)) / $speed


global $ScriptFileName = _PathSplitByRegExp(@AutoItExe)
global $AddHour = StringRegExp($ScriptFileName[6],'\(add(\d+)',2)
if not @error then
	$AddHour = $AddHour[1]
Else
	$AddHour = 1
EndIf
global $Delay = StringRegExp($ScriptFileName[6],'delay(\d+)\)',2)
if not @error then
	$Delay = $Delay[1]*1000
Else
	$Delay = 1
EndIf

Sleep($Delay)
global $settings = my_GetConfFromFile()
dim $StatusInternet = _IsInternet()
if $StatusInternet = 1 then
	if _startmy_SyncTime() = 0 Then
		_SyncTimeOffLine()
	EndIf

Else
	_SyncTimeOffLine()
	_startmy_SyncTime()
EndIf
global $timerSync
if $noSync=1 Then
	$timerSync=Timerinit()
	while TimerDiff($timerSync)>(10*60000)
		if _startmy_SyncTime() = 1 then ExitLoop
		sleep(2*60000)
	wend
EndIf

exit

Func _startmy_SyncTime()
	local $UTC
;~ 	if $mod = 1 then
;~ 		$timeBefor = _NowCalc()
;~ 		$timerStart = TimerInit()
;~ 		my_SyncTime()
;~ 		$TimePost = _NowCalc()
;~ 		$timeDiff = _DateDiff('s', $timeBefor, $TimePost)*1000
;~ 		if abs(TimerDiff($timerStart)-$timeDiff)<60000 then
;~ 			$settings[0] = "HTTP"
;~ 			my_SyncTime()
;~ 		EndIf
;~ 	Else
;~ 	my_SyncTime()
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : my_SyncTime() = ' & my_SyncTime() & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	EndIf
$UTC = my_SyncTime()
if Ubound(StringRegExp($UTC, '(\d+)/(\d+)/(\d+) (\d+):(\d+):(\d+)', 2)) < 6 Then
	ConsoleWrite( ' Попытка синхронизации 1 из интернета не удалась ' & @CRLF)
	$settings[0] = "HTTP"
	$UTC = my_SyncTime()
	if Ubound(StringRegExp($UTC, '(\d+)/(\d+)/(\d+) (\d+):(\d+):(\d+)', 2)) < 6 Then
		ConsoleWrite( ' Попытка синхронизации 2 из интернета не удалась ' & @CRLF)
		Return 0
		$noSync =1
	Else
		return 1
	EndIf
Else
	return 1
EndIf


;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : 	TimerDiff($timerStart) = ' & 	TimerDiff($timerStart) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $timeDiff = ' & $timeDiff & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

EndFunc


func _SyncTimeOffLine()
	local $TimeSystemFiles,$diff,$sDir_Where_Search,$TimeSystemFiles1,$TimeSystemFiles2,$TimeSystemFiles3
	$sDir_Where_Search = @WindowsDir&'\System32'
	$TimeSystemFiles1 = _GetYoungTimeSystemFiles(0,2,$sDir_Where_Search)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TimeSystemFiles = ' & $TimeSystemFiles1 & @CRLF) ;### Debug Console
	$sDir_Where_Search = @WindowsDir&'\Prefetch'
	$TimeSystemFiles2 = _GetYoungTimeSystemFiles(0,1,$sDir_Where_Search)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TimeSystemFiles = ' & $TimeSystemFiles2 & @CRLF) ;### Debug Console
	$sDir_Where_Search = @WindowsDir&'\System32\config'
	$TimeSystemFiles3 = _GetYoungTimeSystemFiles(0,1,$sDir_Where_Search)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TimeSystemFiles = ' & $TimeSystemFiles3& @CRLF) ;### Debug Console
;~ 	$sDir_Where_Search = @TempDir
;~ 	$TimeSystemFiles = _GetYoungTimeSystemFiles(2,1,$sDir_Where_Search)
	if StringRegExpReplace($TimeSystemFiles1,'[^0-9]','') > StringRegExpReplace($TimeSystemFiles2,'[^0-9]','') Then
		if StringRegExpReplace($TimeSystemFiles1,'[^0-9]','') > StringRegExpReplace($TimeSystemFiles3,'[^0-9]','') Then
			$TimeSystemFiles = $TimeSystemFiles1
		Else
			$TimeSystemFiles = $TimeSystemFiles3
		EndIf
	Else
		if StringRegExpReplace($TimeSystemFiles2,'[^0-9]','') > StringRegExpReplace($TimeSystemFiles3,'[^0-9]','') Then
			$TimeSystemFiles = $TimeSystemFiles2
		Else
			$TimeSystemFiles = $TimeSystemFiles3
		EndIf
	EndIf

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TimeSystemFiles = ' & $TimeSystemFiles & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	$diff =  _DateDiff('s', $TimeSystemFiles,_NowCalc())
	if $diff=0 or $diff>(24*3600) Then
		$TimeSystemFiles = _GetYoungTimeSystemFiles(2,1)
		$diff =  _DateDiff('s', $TimeSystemFiles,_NowCalc())
		if $diff=0 or $diff>(24*3600) Then
			ConsoleWrite( ' Ошибка получения даты из системных файлов. РАзница = ' &$diff& ' время файлов: ' & _GetYoungTimeSystemFiles(2,2) & @CRLF)
			return -1
		EndIf
	EndIf
	if $diff<(3600*24) Then
		ConsoleWrite( ' Необходимо изменить системное время ' & @CRLF)
		$TimeSystemFiles = _DateAdd('h', $AddHour, $TimeSystemFiles)
		$TimeSystemFiles = StringRegExp($TimeSystemFiles, '(\d+)/(\d+)/(\d+) (\d+):(\d+):(\d+)', 2)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($TimeSystemFiles) = ' & Ubound($TimeSystemFiles) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		_SetDate($TimeSystemFiles[3], $TimeSystemFiles[2], $TimeSystemFiles[1])
		_SetTime($TimeSystemFiles[4], $TimeSystemFiles[5], $TimeSystemFiles[6])
		Return 1
	Else
		ConsoleWrite( ' В изменении системного времени нет необходимлсти ' & @CRLF)
	EndIf

EndFunc

exit
;~ func _TimeSyncGO()
;~ If $settings[3] = 'YES' Or $settings[3] = '~~~' Then
;~     If Not FileExists('ajax.gif') Then FileInstall('ajax.gif', 'ajax.gif')

;~     $Form1 = GUICreate("TimeSync", $width, $height, -1, -1, $WS_POPUP)
;~     _GuiRoundCorners($Form1, 0, 0, 20, 20)
;~     GUISetBkColor(0x000000)

;~     GUICtrlCreatePic('',0,0,$width,20,-1,$GUI_WS_EX_PARENTDRAG)

;~     $label_caption = GUICtrlCreateLabel("TimeSync v2.0", 60, 8, 160, 17)
;~     GUICtrlSetColor(-1, 0xFFFFFF)

;~     $group_connect = GUICtrlCreateGroup('Тип соединения', 6, 35, 168, 40)
;~     GUICtrlSetColor(-1, 0xFFFFFF)
;~     $label_connect = GUICtrlCreateLabel('Тип соединения', 14, 35)
;~     GUICtrlSetColor(-1, 0xFFFFFF)

;~     $radio_ntp = GUICtrlCreateRadio('NTP', 10, 52, 12, 20)
;~     $label_ntp = GUICtrlCreateLabel('NTP', 24, 56, 30, 17)
;~     GUICtrlSetColor(-1, 0xFFFFFF)

;~     $radio_http = GUICtrlCreateRadio('HTTP', 64, 52, 12, 20)
;~     $label_http = GUICtrlCreateLabel('HTTP', 78, 54, 80, 17)
;~     GUICtrlSetColor(-1, 0xFFFFFF)

;~     $label_proxy = GUICtrlCreateLabel('Прокси: (если нет - пусто)', 8, 84)
;~     GUICtrlSetColor(-1, 0xFFFFFF)
;~     $input_proxy = GUICtrlCreateInput('', 6, 100, 168)
;~     GUICtrlSetColor(-1, 0xFFFFFF)
;~     GUICtrlSetBkColor(-1, 0x000000)

;~     $check_sound = GUICtrlCreateCheckbox('Звук в конце обновления', 6, 130, 12)
;~     $label_sound = GUICtrlCreateLabel('Звук в конце обновления', 22, 134, 156)
;~     GUICtrlSetColor(-1, 0xFFFFFF)

;~     $check_gui = GUICtrlCreateCheckbox('Показывать статус', 6, 150, 12)
;~     $label_gui = GUICtrlCreateLabel('Показывать статус', 22, 154, 156)
;~     GUICtrlSetColor(-1, 0xFFFFFF)

;~     $check_settings = GUICtrlCreateCheckbox('Показывать настройки', 6, 170, 12)
;~     $label_settings = GUICtrlCreateLabel('Показывать настройки', 22, 174, 156)
;~     GUICtrlSetColor(-1, 0xFFFFFF)

;~     $button_start = GUICtrlCreateButton('Старт', 6, 200, 80)
;~     GUICtrlSetColor(-1, 0xFFFFFF)
;~     GUICtrlSetBkColor(-1, 0x000000)

;~     $button_cancel = GUICtrlCreateButton('Отмена', 90, 200, 80)
;~     GUICtrlSetColor(-1, 0xFFFFFF)
;~     GUICtrlSetBkColor(-1, 0x000000)
;~     ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

;~     If $settings[0] = 'NTP' Or $settings[0] = '~~~' Then
;~         GUICtrlSetState($radio_ntp, $gui_checked)
;~         GUICtrlSetColor($label_proxy, 0x999999)
;~         GUICtrlSetColor($input_proxy, 0x999999)
;~         GUICtrlSetBkColor($input_proxy, 0x555555)
;~         GUICtrlSetStyle($input_proxy, $ES_READONLY)
;~     ElseIf $settings[0] = "HTTP" Then
;~         GUICtrlSetState($radio_http, $gui_checked)
;~     EndIf
;~     If $settings[1] <> 'NONE' Then
;~         GUICtrlSetData($input_proxy, $settings[1])
;~     EndIf
;~     If $settings[2] = 'NO' Or $settings[2] = '~~~' Then
;~         GUICtrlSetState($check_gui, $gui_checked)
;~     EndIf
;~     If $settings[3] = 'YES' Or $settings[3] = '~~~' Then
;~         GUICtrlSetState($check_settings, $gui_checked)
;~     EndIf
;~     If $settings[4] = 'YES' Or $settings[4] = '~~~' Then
;~         GUICtrlSetState($check_sound, $gui_checked)
;~     EndIf
;~     ;-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-

;~     WinSetTrans($Form1, '', 0)
;~     GUISetState(@SW_SHOW)
;~     For $i = 1 To 255 Step 5
;~         WinSetTrans($Form1, '', $i)
;~         Sleep(10)
;~     Next

;~     While 1
;~         $msg = GUIGetMsg()
;~         Select
;~             Case $msg = $button_cancel
;~                 For $i = 1 To 255 Step 5
;~                     WinSetTrans($Form1, '', 255 - $i)
;~                     Sleep(10)
;~                 Next
;~                 GUIDelete($Form1)
;~                 Exit


;~             Case $msg = $button_start
;~                 $conf = my_GetConfFromGUI()
;~                 my_SaveConf($conf)
;~                 $settings = my_GetConfFromFile()
;~                 If $settings[2] = 'NO' Then
;~                     my_GuiCreate(1)
;~                 Else
;~                     For $i = 1 To 255 Step 5
;~                         WinSetTrans($Form1, '', 255 - $i)
;~                         Sleep(10)
;~                     Next
;~                     GUIDelete($Form1)
;~                 EndIf
;~                 my_SyncTime()
;~                 If $settings[2] = 'NO' Then my_GuiDelete()
;~                 Exit


;~             Case $msg = $radio_ntp
;~                 GUICtrlSetState($radio_ntp, $gui_checked)
;~                 GUICtrlSetColor($label_proxy, 0x999999)
;~                 GUICtrlSetColor($input_proxy, 0x999999)
;~                 GUICtrlSetBkColor($input_proxy, 0x555555)
;~                 GUICtrlSetStyle($input_proxy, $ES_READONLY)
;~             Case $msg = $radio_http
;~                 GUICtrlSetState($radio_http, $gui_checked)
;~                 GUICtrlSetColor($label_proxy, 0xffffff)
;~                 GUICtrlSetColor($input_proxy, 0xffffff)
;~                 GUICtrlSetBkColor($input_proxy, 0x000000)
;~                 GUICtrlSetStyle($input_proxy, $ES_LEFT)

;~         EndSelect
;~         Sleep(50)
;~     WEnd
;~ ElseIf $settings[3] = 'NO' Then
;~     If $settings[2] = 'NO' Then my_GuiCreate(0)
;~     my_SyncTime()
;~     If $settings[2] = 'NO' Then my_GuiDelete()
;~     Exit
;~ EndIf

Func _GuiRoundCorners($h_win, $i_x1, $i_y1, $i_x3, $i_y3)
    Dim $pos, $ret, $ret2
    $pos = WinGetPos($h_win)
    $ret = DllCall("gdi32.dll", "long", "CreateRoundRectRgn", "long", $i_x1, "long", $i_y1, "long", $pos[2], "long", $pos[3], "long", $i_x3, "long", $i_y3)
    If $ret[0] Then
        $ret2 = DllCall("user32.dll", "long", "SetWindowRgn", "hwnd", $h_win, "long", $ret[0], "int", 1)
        If $ret2[0] Then
            Return 1
        Else
            Return 0
        EndIf
    Else
        Return 0
    EndIf
EndFunc   ;==>_GuiRoundCorners

;~ Func my_GuiCreate($flag)
;~     If $flag = 1 Then
;~         $pos = WinGetPos($Form1)
;~         $x = $pos[0]
;~         $y = $pos[1] + $height / 2 - $height_sync / 2
;~         $gui_sync = GUICreate('', $width_sync, $height_sync, $x, $y, $WS_POPUP)
;~     ElseIf $flag = 0 Then
;~         $x = 0 - $width_sync
;~         $y = @DesktopHeight / 2 - $height_sync / 2
;~         $gui_sync = GUICreate('', $width_sync, $height_sync, $x, $y, $WS_POPUP)
;~     EndIf

;~     _GuiRoundCorners($gui_sync, 0, 0, 20, 20)
;~     GUISetBkColor(0x000000)
;~     $label_sync = GUICtrlCreateLabel("", 8, 8, 41, 17)
;~     GUICtrlSetColor($label_sync, 0xFFFFFF)
;~     $label_sync_status = GUICtrlCreateLabel("", 8, 24, 228, 17)
;~     GUICtrlSetColor($label_sync_status, 0xFFFFFF)
;~     $gif = _GUICtrlCreateGIF("ajax.gif", "", 145, 8)
;~     _GUICtrlSetGIF($gif, '', '')

;~     If $flag = 1 Then
;~         WinSetTrans($gui_sync, '', 0)
;~         GUISetState(@SW_SHOW, $gui_sync)
;~         For $i = 1 To 255 Step 5
;~             WinSetTrans($gui_sync, '', $i)
;~             WinSetTrans($Form1, '', 255 - $i)
;~             Sleep(10)
;~         Next
;~         GUISetState(@SW_HIDE, $Form1)
;~     ElseIf $flag = 0 Then
;~         GUISetState(@SW_SHOW, $gui_sync)
;~         For $i = 1 To $count Step 1
;~             WinMove($gui_sync, '', $i * $speed, $y)
;~             Sleep(10)
;~         Next
;~     EndIf
;~ EndFunc   ;==>my_GuiCreate


;~ Func my_GuiDelete()
;~     $pos = WinGetPos($gui_sync)
;~     $x = $pos[0]
;~     $y = $pos[1]
;~     For $i = 1 To $count_end + 2 Step 1
;~         WinMove($gui_sync, '', $x + ($i * $speed), $y)
;~         Sleep(10)
;~     Next
;~ EndFunc   ;==>my_GuiDelete

;~ Func my_GetConfFromGUI()
;~     Dim $arr[5]
;~     $arr[0] = GUICtrlRead($radio_ntp)
;~     $arr[1] = GUICtrlRead($input_proxy)
;~     $arr[2] = GUICtrlRead($check_gui)
;~     $arr[3] = GUICtrlRead($check_settings)
;~     $arr[4] = GUICtrlRead($check_sound)
;~     Return $arr
;~ EndFunc   ;==>my_GetConfFromGUI

Func my_GetConfFromFile()
    Dim $arr[5]
    $arr[0] = 'NTP' ; IniRead('TimeSync.ini', 'Settings', 'Type', '~~~')
    $arr[1] = 'NONE' ; IniRead('TimeSync.ini', 'Settings', 'Proxy', '~~~')
    $arr[2] = 'YES' ; IniRead('TimeSync.ini', 'Settings', 'Silent', '~~~')
    $arr[3] = 'NO' ; IniRead('TimeSync.ini', 'Settings', 'Settings', '~~~')
    $arr[4] = 'NO' ; IniRead('TimeSync.ini', 'Settings', 'Sound', '~~~')
    Return $arr
EndFunc   ;==>my_GetConfFromFile

Func my_SaveConf($arr)
	local $check
    $check = $arr[0] ; Type of connection
    If $check = $gui_checked Then
        IniWrite('TimeSync.ini', 'Settings', 'Type', 'NTP')
    Else
        IniWrite('TimeSync.ini', 'Settings', 'Type', 'HTTP')
    EndIf

    $check = $arr[1] ; proxy
    If $check = '' Then
        IniWrite('TimeSync.ini', 'Settings', 'Proxy', 'NONE')
    Else
        IniWrite('TimeSync.ini', 'Settings', 'Proxy', $check)
    EndIf

    $check = $arr[2] ; gui
    If $check = $gui_checked Then
        IniWrite('TimeSync.ini', 'Settings', 'Silent', 'NO')
    Else
        IniWrite('TimeSync.ini', 'Settings', 'Silent', 'YES')
    EndIf

    $check = $arr[3] ; settings
    If $check = $gui_checked Then
        IniWrite('TimeSync.ini', 'Settings', 'Settings', 'YES')
    Else
        IniWrite('TimeSync.ini', 'Settings', 'Settings', 'NO')
    EndIf

    $check = $arr[4] ; sound
    If $check = $gui_checked Then
        IniWrite('TimeSync.ini', 'Settings', 'Sound', 'YES')
    Else
        IniWrite('TimeSync.ini', 'Settings', 'Sound', 'NO')
    EndIf
EndFunc   ;==>my_SaveConf

Func check_internet_connectivity()
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : check_internet_connectivity() = '  & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    TCPStartup()
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TCPStartup() = ' & TCPStartup() & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    For $i = 0 To 3
        $NTPIP[$i] = TCPNameToIP($NTP_Server[$i])
		ConsoleWrite('@@ Debug(' & $i & ') : TCPNameToIP($NTP_Server[$i]) = ' & TCPNameToIP($NTP_Server[$i]) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
        Sleep(250)
    Next
    TCPShutdown()
    Return $NTPIP
EndFunc   ;==>check_internet_connectivity
Func NTP_Connect($NTP_Server)
	local $status, $data, $TimerConnect
    UDPStartup()
    Dim $socket = UDPOpen(TCPNameToIP($NTP_Server), 123)
    $status = UDPSend($socket, MakePacket("1b0e01000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"))
    $data = ""
	$TimerConnect = Timerinit()
    While $data = ""
        $data = UDPRecv($socket, 100)
		if TimerDiff($TimerConnect) > 20000 then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($TimerConnect) = ' & TimerDiff($TimerConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			exitloop
		EndIf
        Sleep(100)
    WEnd
    UDPCloseSocket($socket)
    UDPShutdown()
    Return $data
EndFunc   ;==>NTP_Connect
Func Set_Time($bdata)
	local $unsignedHexValue,$value,$TZinfo,$TZoffset,$UTC,$m,$d,$y,$h,$mi,$s
    $unsignedHexValue = StringMid($bdata, 83, 8)
    $value = UnsignedHexToDec($unsignedHexValue)
    $TZinfo = _Date_Time_GetTimeZoneInformation()
    $UTC = _DateAdd("s", $value, "1900/01/01 00:00:00")
    If $TZinfo[0] <> 2 Then ; 0 = Daylight Savings not used in current time zone / 1 = Standard Time
        $TZoffset = ($TZinfo[1]) * - 1
    Else ; 2 = Daylight Savings Time
        $TZoffset = ($TZinfo[1] + $TZinfo[7]) * - 1
    EndIf
    $UTC = _DateAdd("n", $TZoffset, $UTC)
    $m = StringMid($UTC, 6, 2)
    $d = StringMid($UTC, 9, 2)
    $y = StringMid($UTC, 1, 4)
    $h = StringMid($UTC, 12, 2)
    $mi = StringMid($UTC, 15, 2)
    $s = StringMid($UTC, 18, 2)
    _SetDate($d, $m, $y)
    _SetTime($h, $mi, $s)
	return $UTC
EndFunc   ;==>Set_Time
Func MakePacket($d)
    Local $p = ""
    While $d
        $p &= Chr(Dec(StringLeft($d, 2)))
        $d = StringTrimLeft($d, 2)
    WEnd
    Return $p
EndFunc   ;==>MakePacket
Func UnsignedHexToDec($n)
	local $ones
    $ones = StringRight($n, 1)
    $n = StringTrimRight($n, 1)
    Return Dec($n) * 16 + Dec($ones)
EndFunc   ;==>UnsignedHexToDec

Func HTTPTimeSync($proxy = 'NONE')
	local $read,$regexp,$time,$date,$date_split,$day,$mon_word,$year,$mon, $UTC,$TZoffset,$hour,$min,$sec
	dim $TZinfo
    If $proxy <> 'NONE' Then HttpSetProxy(2, $proxy)
    $read = BinaryToString(InetRead('http://www.time100.ru/gmt.html'), 4)
    $regexp = StringRegExp($read, '<span id="timenow">(.*?)</span>', 3)
    If @error Then Return -1
    $time = $regexp[0]
    $regexp = StringRegExp($read, '<b>(.*?)</b>', 3)
    If @error Then Return -2
    $date = $regexp[0]
    $date_split = StringSplit($date, ' ')
    $day = $date_split[1]
    $mon_word = $date_split[2]
    $year = $date_split[3]
    Switch $mon_word
        Case 'января'
            $mon = '01'
        Case 'февраля'
            $mon = '02'
        Case 'марта'
            $mon = '03'
        Case 'арпеля'
            $mon = '04'
        Case 'мая'
            $mon = '05'
        Case 'июня'
            $mon = '06'
        Case 'июля'
            $mon = '07'
        Case 'августа'
            $mon = '08'
        Case 'сентября'
            $mon = '09'
        Case 'октября'
            $mon = '10'
        Case 'ноября'
            $mon = '11'
        Case 'декабря'
            $mon = '12'
    EndSwitch

    $UTC = $year & '/' & $mon & '/' & $day & ' ' & $time
    $TZinfo = _Date_Time_GetTimeZoneInformation()
    If $TZinfo[0] <> 2 Then
        $TZoffset = ($TZinfo[1]) * - 1
    Else
        $TZoffset = ($TZinfo[1] + $TZinfo[7]) * - 1
    EndIf
    $UTC = _DateAdd("n", $TZoffset, $UTC)
    $mon = StringMid($UTC, 6, 2)
    $day = StringMid($UTC, 9, 2)
    $year = StringMid($UTC, 1, 4)
    $hour = StringMid($UTC, 12, 2)
    $min = StringMid($UTC, 15, 2)
    $sec = StringMid($UTC, 18, 2)
    _SetDate($day, $mon, $year)
    _SetTime($hour, $min, $sec)
    Return 1
EndFunc   ;==>HTTPTimeSync



Func my_SyncTime()
	local $beep,$beep_t, $trig,$adata,$UTC,$ret
    $beep = 500
    $beep_t = 200

;~     If $settings[2] = 'NO' Then
;~         GUICtrlSetData($label_sync, 'Статус:')
;~         GUICtrlSetData($label_sync_status, 'Соединяюсь с сервером...')
;~         _GUICtrlSetGIF($gif, "ajax.gif")
;~     EndIf
    ;-=-=-=-=-=-=-=-=-=-=-=-=-=-
    If $settings[0] = 'NTP' Then ; for NTP type
        $trig = 0
        $NTP_IP = check_internet_connectivity()
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $NTP_IP = ' & $NTP_IP & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
        If $NTP_IP[0] <> '' Then
            $adata = NTP_Connect($NTP_Server[0])
        ElseIf $NTP_IP[1] <> '' Then
            $adata = NTP_Connect($NTP_Server[1])
        ElseIf $NTP_IP[2] <> '' Then
            $adata = NTP_Connect($NTP_Server[2])
        ElseIf $NTP_IP[3] <> '' Then
            $adata = NTP_Connect($NTP_Server[3])
        Else
            $trig = 1
            If $settings[2] = 'NO' Then GUICtrlSetData($label_sync_status, 'Соединение потеряно!')
            $beep = 700
            $beep_t = 1000
        EndIf
        If $trig = 0 Then
            $UTC = Set_Time($adata)
            If $settings[2] = 'NO' Then GUICtrlSetData($label_sync_status, 'Время синхронизировано!')
        EndIf
    ElseIf $settings[0] = "HTTP" Then ; for HTTP type
        $ret = HTTPTimeSync($settings[1])
        If $ret = -1 Or $ret = -2 Then
            If $settings[2] = 'NO' Then GUICtrlSetData($label_sync_status, 'Возникла ошибка!')
            $beep = 700
            $beep_t = 1000
        EndIf
        If $settings[2] = 'NO' Then GUICtrlSetData($label_sync_status, 'Время синхронизировано!')
    EndIf
    ;-=-=-=-=-=-=-=-=-=-=-=-=-=-
;~     If $settings[2] = 'NO' Then _GUICtrlSetGIF($gif, "", '')
    Sleep(1000)
    If $settings[4] = 'YES' Then Beep($beep, $beep_t)
	return $UTC
EndFunc   ;==>my_SyncTime

Func _IsInternet()
    Local $Ret = DllCall('wininet.dll', 'int', 'InternetGetConnectedState', 'dword*', 0x20, 'dword', 0)
    If @error Then
        Return SetError(1, 0, 0)
    EndIf
    Local $Error = _WinAPI_GetLastError()
    Return SetError((Not ($Error = 0)), $Error, $Ret[0])
EndFunc   ;==>_IsInternet

Func _GetYoungTimeSystemFiles($DateFormat=2,$FoldeFile=0,$sDir_Where_Search='')
	if $sDir_Where_Search='' then $sDir_Where_Search=@WindowsDir&'\System32'

	local $sFile_To_Write,$sYoungest_Folder,$sYoungest_Folder,$sTime,$aTemp
$sFile_To_Write = @ScriptDir & '\Youngest_Folder.txt'
$sYoungest_Folder = ''
$sTime = ''

$aTemp = _FileListToArray($sDir_Where_Search, '*', $FoldeFile)
If @error Then Exit 13
Dim $aDir_and_Time[$aTemp[0] + 1][2] = [[$aTemp[0]]]
For $i = 1 To $aDir_and_Time[0][0]
    $aDir_and_Time[$i][0] = $aTemp[$i]
    $aDir_and_Time[$i][1] = FileGetTime($sDir_Where_Search & '\' & $aTemp[$i], $DateFormat, 1)
Next
$aTemp = 0
_ArraySort($aDir_and_Time, 1, 1, 0, 1)
For $i = 1 To $aDir_and_Time[0][0]
    If $aDir_and_Time[$i][1] Then
        $sYoungest_Folder = $sDir_Where_Search & '\' & $aDir_and_Time[$i][0]
        $sTime = StringRegExpReplace($aDir_and_Time[$i][1], '^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})', '$1/$2/$3 $4:$5:$6')
        ExitLoop
    EndIf
Next
return $sTime
endfunc

Func _PathSplitByRegExp($sPath)
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8], $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

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


