#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=D:\Temp\test\Shukurov\temp.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

HotKeySet('{ESC}', '_Exit')
Sleep(1500)
;~ #include <File.au3>
#include <Array.au3>
;~ #include <FileOperations.au3>
$k=0.2
Opt("SendKeyDelay", 64*$k)             ;5 миллисекунд
Opt("SendKeyDownDelay", 5*$k)     ;1 миллисекунда


HotKeySet('{Pgdn}', '_run')
HotKeySet('{F10}', '_Exit')
$sleepclip = 50
$sleepactivating = 64
global $title = 'Скрипт обработки медиа-ресурсов'
global $ctrls = '[CLASS:TSynMemo; INSTANCE:1]'
global $ctrltest = '[CLASS:TCBitBtn32; INSTANCE:2]'
global $ctrlrun = '[CLASS:TCBitBtn32; INSTANCE:3]'


While 1
	Send('{Right}')
;~ 	Send('{Down}')
	Send('{Up}')
	sleep($sleepclip*$k)
WEnd
exit


while 1
	sleep(100)
WEnd

exit
Func _run()
	$old = ClipGet()
	Send('^a')
	Send('^{INS}')
	sleep($sleepclip)
	$clip = Clipget()
	WinActivate($title)
	sleep($sleepactivating)
	ControlClick($title,'',$ctrls)
	Send('^a')
	Send('{del}')
	Send('+{INS}')
	sleep($sleepactivating)
	ControlClick($title,'',$ctrltest)
	ClipPut($old)
EndFunc



func _Exit()
	exit
EndFunc




$fileini = @ScriptDir & '\settings.ini'
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $fileini = ' & $fileini & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ if not FileExists($fileini) then FileWrite($fileini,'')
$StartSleep = _IniReadWrite($fileini, 'global', '$StartSleep', 1500)
$SendKeyDelay = _IniReadWrite($fileini, 'global', '$SendKeyDelay', 100)
$SendKeyDownDelay = _IniReadWrite($fileini, 'global', '$SendKeyDownDelay', 20)
$sleepClip = _IniReadWrite($fileini, 'global', '$sleepClip', 100)
$OldClips = _IniReadWrite($fileini, 'global', '$OldClips', 10)
$DoubleRight = _IniReadWrite($fileini, 'global', '$DoubleRight', 0)
Func _IniReadWrite($fileini,$section,$key,$default)
	$return = IniRead($fileini, $section, $key, $default)
	if $return = $default Then
		IniWrite($fileini, $section, $key, $default)
	EndIf
	return $return
EndFunc
sleep($StartSleep)

Opt("SendKeyDelay", $SendKeyDelay) ; 5 миллисекунд
Opt("SendKeyDownDelay", 20) ; 1 миллисекунда
$sleepClip = 100
While 1
	Send('{Right}')
	if $DoubleRight>0 Then Send('{Right}')
	Send('{Down}')
	Sleep($sleepClip)
WEnd

;~ global $title = 'Скрипт обработки медиа-ресурсов'
;~ WinActivate($title)
;~ global $ctrlf = '[CLASS:TGroupPanel; INSTANCE:8]'
;~ 	;~ ControlClick($title,'',$ctrlf,'left',1,75, 20)
;~ 	;~ Send('{Down}')
;~ global $ctrls = '[CLASS:TSynMemo; INSTANCE:1]'
;~ 	;~ ControlClick($title,'',$ctrls,'left',1,835-20, 456-20)
;~ 	;~ Send('{home}')

;~ ControlClick($title,'',$ctrlf,'left',2, 100, 352)
;~ For $i=1 to 5000
;~ 	Send('{Right}')
;~ 	sleep(1)
;~ 	Send('{Down}')
;~ 	sleep(1)
;~ Next
;~ exit

;~ For $i=1 to 10000
;~ 	;~ 	ControlClick($title,'',$ctrlf,'left',1, 100, 352)
;~ 	MouseClick('left',1073, 519)
;~ 	Send('{Down}')
;~ 	sleep(400)
;~ 	;~ Send('{Right}')
;~ 	;~ 	ControlClick($title,'',$ctrlf,'left',2, 100, 352)
;~ 	MouseClick('left',1073, 519)
;~ 	sleep(40)
;~ 	MouseClick('left',1073, 519)
;~ 	sleep(10)
;~ 	sleep(1000)
;~ 	ControlClick($title,'',$ctrls,'left',1,835-20, 456-20)
;~ 	Send('{End}')
;~ 	Send('{Enter}')
;~ 	sleep(100)
;~ Next

