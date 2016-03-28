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

Opt("SendKeyDelay", 100) ; 5 миллисекунд
Opt("SendKeyDownDelay", 20) ; 1 миллисекунда
$sleepClip = 100
Global $list = ''
$file = @ScriptDir & '\TextFromTree.txt'
ClipPut('')
Global $ide = 1
Local $aDoubleElments[10000][2]
Local $aOldClips[10]
for $i=0 to UBound($aOldClips) - 1
	$aOldClips[0] = $i
Next
While 1
	; работа с текущим элементом
	$Clip = _GetCurrElm()
	; обнаружение дерева
	Send('{Right}')
	Send('{Right}')
	$tClip = _GetCurrElm()
	If $tClip <> $Clip Then ; если обнаружено дерево
		; свернуть его
		Send('{Left}')
		Send('{Left}')
		; запомнить следующих два элемента
		$aDoubleElments[$ide][0] = _GetNextElm()
		$aDoubleElments[$ide][1] = _GetNextElm()
		$ide += 1
		if $ide >=2 then ;проверка на повтор€ющеес€ определение начал дерева
			if $aDoubleElments[$ide-1][0] = $aDoubleElments[$ide-2][0] and $aDoubleElments[$ide-1][1] = $aDoubleElments[$ide-2][1] Then
				;ќбнаружено повтор€ющеес€ определение начал дерева
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ќбнаружено повтор€ющеес€ определение начал дерева = ' & $aDoubleElments[$ide-1][0] &' '& $aDoubleElments[$ide-2][0]& @CRLF ) ;### Debug Console
				$ide-=1
				Send('{Right}')
				Send('{Down}')
				Sleep($sleepClip)
				ContinueLoop
			EndIf
		EndIf
		ConsoleWrite('@@ Debug(' & $ide & ') : обнаружено дерево = ' & $Clip &' '& $tClip & @CRLF ) ;### Debug Console
		; вернутс€ назад
		Send('{Up}')
		Send('{Up}')
		Send('{Right}')
	Else
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ide = ' & $ide & @CRLF ) ;### Debug Console
		;проверка не €вл€етс€ ли €чейка окончанием этого дерева
		If $aDoubleElments[$ide-1][0] = $Clip Then
			$newClip = _GetNextElm()
			If $aDoubleElments[$ide-1][1] = $newClip Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ячейка €вл€етс€ окончанием этого дерева = ' & $Clip&' '&$newClip & @CRLF ) ;### Debug Console
				; ячейка €вл€етс€ окончанием этого дерева
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
			_SaveThisElm($Clip)
			_ArrayPush($aOldClips, $Clip)
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
	$Clip = ClipGet()
	If $oldClip <> $Clip Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Clip = ' & $Clip & @CRLF) ; ### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oldClip = ' & $oldClip & @CRLF) ; ### Debug Console
		$list &= $oldClip & @CRLF
		$list &= $Clip & @CRLF
	Else
		$list &= $Clip & @CRLF
	EndIf
	If $oldClip = $oldClip2 And $oldClip3 = $oldClip2 And $oldClip2 = $Clip Then ExitLoop
	Send('{Down}')
	Sleep($sleepClip)
Next
Func _SaveThisElm($Clip)
	$tabs = ''
	For $i = 2 To $ide
		$tabs &= @TAB
	Next
	$list &= $tabs & $Clip & @CRLF
	ConsoleWrite($tabs & $Clip & @CRLF) ;### Debug Console
EndFunc   ;==>_SaveThisElm
Func _GetCurrElm()
	Send('^{Ins}') ; Ctrl+C
	Sleep($sleepClip)
	Return ClipGet()
EndFunc   ;==>_GetCurrElm
Func _GetNextElm()
	Send('{Down}')
	$nextElm = _GetCurrElm()
;~ 	ConsoleWrite('ѕолучен следующий элемент: '&$nextElm & @CRLF)
	return $nextElm
EndFunc   ;==>_GetNextElm
Func _exit()
	FileWrite($file, $list)
	ConsoleWrite($list)
	Exit
EndFunc   ;==>_exit
