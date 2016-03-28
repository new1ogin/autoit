#Region ; **** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ; **** Directives created by AutoIt3Wrapper_GUI ****
#include <Array.au3>
HotKeySet('{ESC}', '_Exit')



;~ Local $avArray[5] = ['aa', 'bb', 'cc', 'bb', 'aa']
;~ _ArrayDisplay($avArray, "ѕоиск 'aa'") ; ѕросмотр массива, в котором поиск
;~ Local $aiResult = _ArrayFindAll($avArray, 'aa') ; ѕоиск всех
;~ _ArrayDisplay($aiResult, "»ндексы") ; –езультаты поиска 'aa' в массиве $avArray
;~ exit
Sleep(1500)

Opt("SendKeyDelay", 64) ; 5 миллисекунд
Opt("SendKeyDownDelay", 20) ; 1 миллисекунда
$sleepClip = 100
global $list = ''
$file = @ScriptDir & '\TextFromTree.txt'
ClipPut('')
global $ide=0
local $aDoubleElments[1000][2]
local $aOldClips[10]

While 1
	; работа с текущим элементом
	$Clip =_GetCurrElm()
	; обнаружение дерева
	Send('{Right}')
	Send('{Right}')
	sleep($sleepClip)
	$tClip = ClipGet()
	if $tClip <> $Clip Then ; если обнаружено дерево
		; свернуть его
		Send('{Left}')
		Send('{Left}')
		; запомнить следующих два элемента
		$aDoubleElments[$ide][0] = _GetNextElm()
		$aDoubleElments[$ide][1] = _GetNextElm()
		$ide+=1
		; вернутс€ назад
		Send('{Up}')
		Send('{Up}')
	Else
		;проверка не €вл€етс€ ли €чейка окончанием этого дерева
		if $aDoubleElments[$ide][0] = $Clip Then
			$newClip = _GetNextElm()
			if $aDoubleElments[$ide][1] = $newClip Then
				; явл€етс€ окончанием этого дерева
				$ide-=1
				; свернуть его
				Send('{Up}')
				Send('{Up}')
				Send('{Left}')
				Send('{Left}')
				; и продолжить со следующей €чейки
			Else
				; вернутс€ назад
				Send('{Up}')
			EndIf
		Else
			;записать эту €чейку на текущем уровне и прейти к следующему
			_SaveThisElm($Clip)
			_ArrayPush($aOldClips,$Clip)
		EndIf
	EndIf
	Send('{Down}')
	sleep($sleepClip)

	$tcount = _ArrayUnique($aOldClips)
	if $tcount[0] <=1 Then ExitLoop
WEnd

_exit()

$oldClip = ''
$oldClip2 = ''

For $i = 0 To 10000
	Send('^{Ins}') ; Ctrl+C
	$oldClip3 = $oldClip2
	$oldClip2 = $oldClip
	$oldClip = ClipGet()
	Sleep($sleepClip)
	Send('{Right}')
	Send('^{Ins}') ; Ctrl+C
	$Clip = ClipGet()
	If $oldClip <> $Clip Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Clip = ' & $Clip & @CRLF) ; ### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oldClip = ' & $oldClip & @CRLF) ; ### Debug Console
		$list &= $oldClip & @CRLF
		$list &= $Clip & @CRLF
	Else
		$list &= $Clip & @CRLF
	EndIf
	if $oldClip = $oldClip2 and $oldClip3 = $oldClip2 and $oldClip2 = $Clip then ExitLoop
	Send('{Down}')
	Sleep($sleepClip)
Next



Func _SaveThisElm($clip)
	$tabs = ''
	for $i=1 to $ide
		$tabs &= @TAB
	Next
	$list &= $tabs & $clip & @CRLF
EndFunc

Func _GetCurrElm()
	Send('^{Ins}') ; Ctrl+C
	sleep($sleepClip)
	Return ClipGet()
EndFunc

Func _GetNextElm()
	Send('{Down}')
	_GetCurrElm()
EndFunc
Func _exit()
	FileWrite($file, $list)
	ConsoleWrite($list)
	Exit
EndFunc
