#include <File.au3>
#include <array.au3>
#include <WinAPIProc.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
#include <String.au3>
#include <Date.au3>
;~ _StringToHex($strChar)
;~ YYYY/MM/DD HH:MM:SS
HotKeySet("{F7}", "_Exit") ;Это вызов
HotKeySet("{F6}", "_pause") ;Это вызов
global $pause=0

Func _exit()
	Exit
EndFunc
Func _pause()
	TrayTip('Подсказка', 'Пауза', 2000)
	if $pause=0 Then
		$pause=1
	Else
		$pause=0
	EndIf
	;Ожидание
	While 1
		if $pause=1 then Return
		Sleep(100)
	WEnd
EndFunc   ;==>_pause


global $hwnd
$sleep = 30*60*1000
$screensleep= 2*60*1000
$ftpressleep = 15*1000
$timerestart = 1*60*60*1000
global $ftppath = '/SYS/temp'
global $exe = "C:\Program Files\CoreFTP\coreftp.exe"
global $title ='Core FTP Pro - 95.170.158.122:2121'
global $schet =0
;~ _start()
;~ exit
;~ _restart()

_getHwnd()
;~ $titlefs ='FastStone Capture'
;~ $titlefs = WinGetTitle($titlefs)
;~ $hwndfs = WinGetHandle($titlefs)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hwndfs = ' & $hwndfs & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ WinActivate($hwndfs)
;~ ControlSend($hwndfs,'','[CLASS:TTBXToolbar; INSTANCE:1]','{PRINTSCREEN}')

;~ ControlClick($hwndfs,'','[CLASS:TTBXToolbar; INSTANCE:1]','left',1, 128, 12)
$timer = Timerinit()
While 1

	sleep($sleep-6*$screensleep)
	if TimerDiff($timer) > $timerestart then _restart()

	WinActivate($hwnd)
	Send('{PRINTSCREEN}')
	sleep(1000)
	ControlClick($hwnd,'','[CLASS:ToolbarWindow32; INSTANCE:1]','left',1, 674, 32)
	sleep($ftpressleep/2)
	Send('{PRINTSCREEN}')
	sleep($ftpressleep/2)
	ControlClick($hwnd,'','[CLASS:ToolbarWindow32; INSTANCE:1]','left',1, 674, 32)

	sleep($screensleep)
	Send('{PRINTSCREEN}')
	sleep($screensleep)
	Send('{PRINTSCREEN}')


Wend

Func _getHwnd()
	$schet+=1
;~ 	$title = WinGetTitle($title)
	$hwnd = WinGetHandle($title)
	if not WinExists($title) then
		_restart()
	Else
		$schet = 0
	EndIf
Endfunc

Func _start()
	run($exe)
	sleep(10000)
	$hwnd2 = WinGetHandle('Site Manager')
	WinActivate($hwnd2)
;~ 	Controlsend($hwnd2,'',
	ControlClick($hwnd2,'','[CLASS:Button; INSTANCE:18]')
;~ 	ControlClick($hwnd2,'','[CLASS:Button; ID:1]')
	sleep(3000)
	if $schet=3 then
		WinClose($title)
		sleep(60*1000)
		_getHwnd()
	EndIf
;~ 	if $schet=6 then exit
	_getHwnd()
	;переход в папку фтп
	for $i=1 to 20
		ControlSend($hwnd,'','[CLASS:Edit; INSTANCE:5]','{DEL}')
		sleep(50)
	Next
	WinActivate($hwnd)
	ControlSend($hwnd,'','[CLASS:Edit; INSTANCE:5]',$ftppath)
	sleep(100)
	ControlClick($hwnd,'','[CLASS:Edit; INSTANCE:5]')
;~ 	sleep(500)
;~ 	ControlSend($hwnd,'','[CLASS:Edit; INSTANCE:5]','{ENTER}')
	sleep(500)
	Send('{ENTER}')
	;копирование всех файлов
	sleep(1000)
	ControlClick($hwnd,'','[CLASS:SysHeader32; INSTANCE:2]')
	sleep(100)
	ControlClick($hwnd,'','[CLASS:SysHeader32; INSTANCE:2]')
	sleep(1000)
	ControlSend($hwnd,'','[CLASS:Static; INSTANCE:11]','^a')
	ControlSend($hwnd,'','[CLASS:Static; INSTANCE:11]','^ф')
	sleep(100)
	ControlClick($hwnd,'','[CLASS:Button; INSTANCE:31]')

EndFunc


Func _restart()
;~ 	Send('{PRINTSCREEN}')
;~ 	if not $hwnd then _getHwnd()
;~ 	sleep(1000)
	if WinExists($hwnd) then
		ControlClick($hwnd,'','[CLASS:ToolbarWindow32; INSTANCE:1]','left',1, 674, 32)
		sleep(5000)
		WinClose($hwnd)
	EndIf
	$t = TimerInit
	While TimerDiff($t) > 10000 and ProcessExists('coreftp.exe')
		sleep(2000)
		ProcessClose('coreftp.exe')
	WEnd
	_start()
EndFunc
