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
Global $list = ''
$file = @ScriptDir & '\TextFromTree.txt'
ClipPut('')
Global $ide = 0
Local $aDoubleElments[1000][2]
Local $aOldClips[10]

While 1
	; работа с текущим элементом
	$Clip = _GetCurrElm()
	; обнаружение дерева
	Send('{Right}')
	Send('{Right}')
	Sleep($sleepClip)
	$tClip = ClipGet()
	If $tClip <> $clip Then ; если обнаружено дерево
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : обнаружено дерево = ' & $Clip&$tclip & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		; свернуть его
		Send('{Left}')
		Send('{Left}')
		; запомнить следующих два элемента
		$aDoubleElments[$ide][0] = _GetNextElm()
		$aDoubleElments[$ide][1] = _GetNextElm()
		$ide += 1
		; вернутс€ назад
		Send('{Up}')
		Send('{Up}')
	Else
		;проверка не €вл€етс€ ли €чейка окончанием этого дерева
		If $aDoubleElments[$ide][0] = $clip Then
			$newClip = _GetNextElm()
			If $aDoubleElments[$ide][1] = $newClip Then
				; явл€етс€ окончанием этого дерева
				$ide -= 1
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
			_SaveThisElm($clip)

			_ArrayPush($aOldClips, $clip)
		EndIf
	EndIf
	Send('{Down}')
	Sleep($sleepClip)

	$tcount = _ArrayUnique($aOldClips)
	If $tcount[0] <= 1 Then ExitLoop
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
	$clip = ClipGet()
	If $oldClip <> $clip Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Clip = ' & $clip & @CRLF) ; ### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oldClip = ' & $oldClip & @CRLF) ; ### Debug Console
		$list &= $oldClip & @CRLF
		$list &= $clip & @CRLF
	Else
		$list &= $clip & @CRLF
	EndIf
	If $oldClip = $oldClip2 And $oldClip3 = $oldClip2 And $oldClip2 = $clip Then ExitLoop
	Send('{Down}')
	Sleep($sleepClip)
Next



Func _SaveThisElm($clip)
	$tabs = ''
	For $i = 1 To $ide
		$tabs &= @TAB
	Next
	$list &= $tabs & $clip & @CRLF
	ConsoleWrite($tabs & $clip & @CRLF ) ;### Debug Console
EndFunc   ;==>_SaveThisElm

Func _GetCurrElm()
	Send('^{Ins}') ; Ctrl+C
	Sleep($sleepClip)
	Return ClipGet()
EndFunc   ;==>_GetCurrElm

Func _GetNextElm()
	Send('{Down}')
	_GetCurrElm()
EndFunc   ;==>_GetNextElm
Func _exit()
	FileWrite($file, $list)
	ConsoleWrite($list)
	Exit
EndFunc   ;==>_exit
