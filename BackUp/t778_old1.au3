
HotKeySet('{ESC}', '_Exit')
Sleep(1500)
$fileini = @ScriptDir & '\settings.ini'
$SendKeyDelay = IniRead($fileini,'global','SendKeyDelay',100)
if @error then IniWrite($fileini,'global','SendKeyDelay',100)
$SendKeyDownDelay = IniRead($fileini,'global','SendKeyDownDelay',20)
if @error then IniWrite($fileini,'global','SendKeyDownDelay',20)
$sleepClip= IniRead($fileini,'global','sleepClip',100)
if @error then IniWrite($fileini,'global','sleepClip',100)
$OldClips = IniRead($fileini,'global','OldClips',10)
if @error then IniWrite($fileini,'global','OldClips',10)

Opt("SendKeyDelay", $SendKeyDelay) ; 5 миллисекунд
Opt("SendKeyDownDelay", 20) ; 1 миллисекунда
$sleepClip = 100
While 1
	Send('{Right}')
	Send('{Down}')
	sleep($sleepClip)
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

Func _Exit()
	Exit

endfunc

