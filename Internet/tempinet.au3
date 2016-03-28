
$site = 'https://www.megaindex.ru/index.php?region_id=0&tab=siteAnalyze&count=1000&site=garantsoft.com&date=2015-04-11&count=1000'
$name = 'new1ogin@mail.ru'
$password = 'xp42df37'

#include <winhttp.au3>

$string =';Видимость;Запросов в месяц;показы '
$t=StringReplace($string,'Видимоть','')
ConsoleWrite(@extended & @CRLF)
exit

Opt("SendKeyDelay", 10)
;~ $iehandle = WinGetHandle("[CLASS:IEFrame]")
$testsleep=100
$delay=500
;~ $bar = ControlGetHandle($iehandle, "", "[CLASS:Frame Notification Bar]")
;~ If $bar And ControlCommand($iehandle, "", $bar, "IsVisible") Then
;~   ControlSend($iehandle, "", "Internet Explorer_Server1", "{F6}")
;~   sleep($testsleep)
;~   ControlSend($iehandle, "", "DirectUIHWND1", "{TAB}{ENTER}")
;~   sleep(5000)
;~   ControlSend($iehandle, "", "DirectUIHWND1", "{TAB}{ENTER}")
;~ 	;~   WinWait("[CLASS:#32768]")
;~ 	;~   Send("{DOWN}{ENTER}")
;~ EndIf

;~ $iehandle = hwnd("0x" & Hex($CmdLine[1]))
;~ $delay = $CmdLine[2]

$iehandle = WinGetHandle("[CLASS:IEFrame]")

;~ AutoItSetOption("SetKeyDownDelay",10)
Func _SaveChoise($iehandle)
Opt("SendKeyDelay", 10)
;~ $iehandle = WinGetHandle("[CLASS:IEFrame]")
$delay=500
$a = ControlGetHandle($iehandle, "", "[CLASS:Frame Tab]")
$b = ControlGetHandle($a, "", "[CLASS:TabWindowClass]")
$c = ControlGetHandle($b, "", "[CLASS:Shell DocObject View]")
$iecontrol = ControlGetHandle($c, "", "[CLASS:Internet Explorer_Server]")

ControlSend($iehandle,"",$iecontrol,"{F6}")

sleep($delay)
;Поиск notification bar
$notbar =  ControlGetHandle($iehandle, "", "[CLASS:Frame Notification Bar]")
$notbarcontrol = ControlGetHandle($notbar, "", "[CLASS:DirectUIHWND]")


sleep($delay)
ControlSend($iehandle,"",$notbarcontrol,"{TAB}")
sleep($delay)
ControlSend($iehandle,"",$notbarcontrol,"{ENTER}")


;~ WinWait ("[CLASS:#32768; INSTANCE:1]")
;~ $popup = WinGetHandle("[CLASS:#32768; INSTANCE:1]")
;~ Sleep($delay)
;~ ControlSend("","",$popup,"{DOWN}")
;~ sleep($delay)
;~ ControlSend("","",$popup,"{ENTER}")
EndFunc