Opt("WinTitleMatchMode", -2)

HotKeySet("{Ins}", "Terminate")
Func Terminate()
;~    ProcessClose("slenfbot.ex*e")
    Exit 0
EndFunc

$Title = 'Интернет-Банк' ; The Name Of The Game...
$Full = WinGetTitle ($Title) ; Get The Full Title..
$HWnD = WinGetHandle ($Full) ; Get The Handle
;~ WinActivate($HWnD)
while 1
	$phwnd=WinGetHandle("[ACTIVE]")
	controlsend($HWnD,'','',"^+{к}")
	controlsend($HWnD,'','',"^+{r}")
	WinActivate($phwnd)
	sleep(100000+Random(-20,20))
WEnd



