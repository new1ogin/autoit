
sleep(1500)

Opt("SendKeyDelay", 64)             ;5 миллисекунд
Opt("SendKeyDownDelay", 10)     ;1 миллисекунда
$sleepClip = 100
$list = ''
$file = @ScriptDir & '\TextFromTree.txt'
ClipPut('')
;~ $oldClip = ClipGet()
;~ Send('^{Ins}') ; Ctrl+C
;~ sleep($sleepClip)
;~ $Clip = ClipGet()
;~ ; обнаружение дерева
;~ Send('{Right}')
;~ Send('{Right}')
;~ sleep($sleepClip)
;~ $tClip = ClipGet()
;~ if $tClip <> $Clip Then ;если обнаружено дерево
;~ 	;свернуть его
;~ 	Send('{Left}')
;~ 	Send('{Left}')

For $i = 0 to 5
	Send('^{Ins}') ; Ctrl+C
	$oldClip = ClipGet()
	sleep($sleepClip)
	Send('{Right}')
	Send('^{Ins}') ; Ctrl+C
	$Clip = ClipGet()
	if $oldClip <> $Clip Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Clip = ' & $Clip & @CRLF ) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oldClip = ' & $oldClip & @CRLF ) ;### Debug Console
		$list &= $oldClip & @CRLF
		$list &= $Clip & @CRLF
	Else
		$list &= $Clip & @CRLF
	EndIf
	Send('{Down}')
	sleep($sleepClip)
Next

FileWrite($file,$list)
ConsoleWrite($list)

