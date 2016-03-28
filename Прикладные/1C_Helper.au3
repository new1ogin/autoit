#include <array.au3>
#include <WinAPISys.au3>
;~ #Include <WinAPIEx.au3>
;~ #include <IE.au3>

Const $LANG_RUS = 0x0419 ;Русский
Opt("WinTitleMatchMode", 1)
HotKeySet("^{F7}", "Terminate")
HotKeySet("{F7}", "_SendInf")
;~ HotKeySet("{F4}", "_AVC_Media_set")
;~ HotKeySet("{F3}", "_AVC_Wait_Browse")
HotKeySet("{F9}", "_HMS_Copy")
;~ HotKeySet("{home}", "_Pause")
$testsleep = 10
$ftpMediaFolder = '\\192.168.0.1\ftp\pub\temp\t3'
$titleAVC = 'Any Video Converter'
Opt("WinTitleMatchMode", -1)   ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase

Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate

While 1
	sleep(100)

WEnd

Func _HMS_Copy()
	$title = 'Скрипт обработки медиа-ресурсов'
	$testsleep = 200
	$oldBuffer = ClipGet()
	Send('^ф')
	Send('^{INS}')
	sleep($testsleep)
	$newBuffer = ClipGet()
	if $oldBuffer == $newBuffer or StringLen($newBuffer < 10) Then
;~ 		Send('{Left}')
;~ 		Send('^a')
;~ 		Send('^{INS}')
;~ 		sleep($testsleep)
;~ 		$newBuffer = ClipGet()
	EndIf
;~ 	ConsoleWrite($newBuffer & @CRLF)
	WinActivate($title)
	if StringInStr($newBuffer,'end.'&@CRLF,0,-1) then $newBuffer = StringLeft($newBuffer,StringInStr($newBuffer,'end.'&@CRLF,0,-1)+5)
	$newBuffer = StringReplace($newBuffer,@tab,'    ')
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringInStr($newBuffer,''end.'',0,-1) = ' & StringInStr($newBuffer,'end.',0,-1) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringInStr($newBuffer,''end.'',0,1) = ' & StringInStr($newBuffer,'end.',0,1) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $newBuffer = ' & $newBuffer & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ControlClick($title,'','[CLASS:TSynMemo; INSTANCE:1]')
	ClipPut($newBuffer)
	Send('^ф')
	Send('{Del}')
	Send('+{INS}')
	sleep($testsleep)
	ControlClick($title,'','[CLASS:TPanel; INSTANCE:2]','left',1,198,10)

EndFunc




Func _AVC_Media_set()
	WinActivate($titleAVC)
;~ 	Opt("MouseCoordMode", 0)          ;1=абсолютные, 0=относительные, 2=клиентские
;~ 	ControlClick($titleAVC,'',
	MouseMove(1005,385)
	MouseClick('left')

EndFunc

Func _AVC_Wait_Browse()
	While 1
		if WinExists('Обзор папок') then
			ControlSetText($titleAVC,'','[CLASS:Edit; INSTANCE:1]',$ftpMediaFolder)
			ControlSend($titleAVC,'','[CLASS:Edit; INSTANCE:1]','{DEL}')
		EndIf
	WEnd
EndFunc



Func _SendInf()
	$title = "1С:Предприятие"
	$text = "Обслуживание клиента: Визит. Новый"

	;переключение языков
	_WinAPI_SetKeyboardLayout(WinGetHandle(AutoItWinGetTitle()), 0x0419)
	$hWnd = WinGetHandle($title,$text)
	$hCtrl = ControlGetHandle($hWnd, "","[CLASS:V8MDILocalFrame; INSTANCE:2]")
	_WinAPI_SetKeyboardLayout($hCtrl, 0x0419)
	_WinAPI_LoadKeyboardLayoutEx($LANG_RUS, $hWnd)

	$clip = ClipGet()
	$aClipS = StringSplit($clip,@CRLF)
	$textClip1 = _textFromArray($aClipS, 1)

	$st = StringRegexp($clip,"\d{2}\.\d{2}\.2\d{3}",3)
	$st = _mass($st)
	$st2 = StringRegexp($clip,"\d{2}\.\d{2}\.1\d",3)
	$st2 = _mass($st2)
	if $st2 <> 0 and $st2[0][1] > $st[0][1] Then
		$st=$st2
		$st[0][0] = StringRegExpReplace($st[0][0],'(\d{2}\.\d{2})\.(1\d)','\1\.20\2')
	EndIf


If WinActive($title, $text) Then
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:28]')
	sleep($testsleep)
	ControlSend($title, $text, '[CLASS:V8FormElement; INSTANCE:28]', 'ООО "Профф"')
	$t1 = ControlGetText($title, $text, '[CLASS:V8FormElement; INSTANCE:28]')
	sleep($testsleep)

	;проверка введённого
	$OldClip = ClipGet()
	Send('+{home}')
	sleep($testsleep)
	Send('^{INS}')
	if ClipGet() <> 'ООО "Профф"' Then return 0 ; проверка введенного
	ClipPut($OldClip)
	$OldClip = ''

	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:26]')
	sleep($testsleep)
	ControlSend($title, $text, '[CLASS:V8FormElement; INSTANCE:26]', 'Зюзин Виталий Дмитриевич')
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:16]')
	sleep($testsleep)
	ControlSend($title, $text, '[CLASS:V8FormElement; INSTANCE:16]', '1000,00')
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:15]')
	sleep($testsleep)
	Send('+{ins}')
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:30]')
	sleep($testsleep)
	if $st <> 0 Then ControlSend($title, $text, '[CLASS:V8FormElement; INSTANCE:30]', $st[0][0])
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:15]')
	sleep($testsleep)
	$pos = ControlGetPos ($title, $text, '[CLASS:V8FormElement; INSTANCE:24]')
	sleep($testsleep)
	ControlClick($title, $text, '[CLASS:V8FormElement; INSTANCE:24]', 'left', 2, $pos[2]-24, $pos[3]/2)
	sleep($testsleep)
;~ 	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]','{Down down}')
;~ 	sleep(164)
;~ 	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]','{Down up}')
;~ 	sleep($testsleep)
;~ 	sleep(64)
;~ 	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]','{Enter}')
;~ 	sleep($testsleep)
	sleep(100)
	sleep(64)
;~ 	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]',StringMid($textClip1,1,1))
	$textClip1Correct = _correctName($textClip1)
;~ 	For $i=1 to 5
;~ 		Send("{"&StringMid($textClip1Correct,$i,1)&" down}")
;~ 		sleep(64)
;~ 		sleep($testsleep)
;~ 	next
;~ 	For $i=1 to 5
;~ 		Send("{"&StringMid($textClip1Correct,$i,1)&" up}")
;~ 		sleep(64)
;~ 	Next
	For $i=1 to 5
		Send("{"&StringMid($textClip1Correct,$i,1)&" down}")
		sleep(64)
		sleep($testsleep)
		Send("{"&StringMid($textClip1Correct,$i,1)&" up}")
		sleep($testsleep)
	next
	sleep(64)
;~ 	ControlSend($title, $text,'[CLASS:V8Grid; INSTANCE:2]','{Enter}')
	sleep($testsleep)
	sleep($testsleep)
	sleep(64)

;~ 	ConsoleWrite($st[0][0] & @CRLF)



EndIf
Endfunc

Func _correctName($text)
	Dim $arrayReplace[74][2] = [['Максоторс','Медведев М.М.'],['Максм','Медведев М.М.'],['белый яр','планета'], _
	['клетчатка','сибирская клетчатка'],['предтеч','сибирская клетчатка'],['Леди','Шукюров'],['Купец','Шукюров'],['купец','Шукюров'], _
	['Щукюров','Шукюров'],['Томлад','Шукюров'],['ресторан куп','Шукюров'],['Маргарита','Павлова'],['Максмоторс','Медведев М.М.']]
;~ 	['',''],['',''],['',''], _
	$exit=0
	For $i = 0 To UBound($arrayReplace)-1
		if stringinstr($text,$arrayReplace[$i][0]) then $exit=1
		$text = StringRegExpReplace($text, '(?i)\Q'&$arrayReplace[$i][0]&'\E', $arrayReplace[$i][1])
		if $exit=1 then ExitLoop
	Next
	Return $text

EndFunc


Func _textFromArray($array, $startLine)
	For $i=$startLine to Ubound($array) -1
		$text = StringRegExpReplace($array[$i],'[^a-zA-Zа-яёА-ЯЁ]*','')
		If StringLen($text) > 2 Then
			return $text
		EndIf
	Next
EndFunc


Func _mass($array)
	if Ubound($array) = 0 Then return 0
	$uarray = UBound($array) - 1
	Dim $array2[$uarray+1][2]
	$num = 0
	For $i=0 to $uarray
		$tc = 0
		For $j=0 to $num
			if $array[$i] = $array2[$j][0] Then
				$array2[$j][1] += 1
;~ 				ConsoleWrite('@@ Debug(' & $array2[$j][1] & ') : $array2[$j][0] = ' & $array2[$j][0] & @CRLF) ;### Debug Console
				$tc = 1
			EndIf
		Next
		if $tc = 0 Then
			$array2[$num][0] = $array[$i]
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $array2[$num][0] = ' & $array2[$num][0] & @CRLF) ;### Debug Console
			$array2[$num][1] = 1
			$num += 1
		EndIf
	Next
	Redim $array2[$num][2]
	_ArraySort($array2, 1, 0, 0, 1)
	return $array2
EndFunc




Func _WinAPI_LoadKeyboardLayoutEx($sLayoutID = 0x0409, $hWnd = 0)
    Local Const $WM_INPUTLANGCHANGEREQUEST = 0x50
    Local $aRet = DllCall("user32.dll", "long", "LoadKeyboardLayoutW", "wstr", Hex($sLayoutID, 8), "int", 0)

    If Not @error And $aRet[0] Then
        If $hWnd = 0 Then
            $hWnd = WinGetHandle(AutoItWinGetTitle())
        EndIf

        DllCall("user32.dll", "ptr", "SendMessage", "hwnd", $hWnd, "int", $WM_INPUTLANGCHANGEREQUEST, "int", 1, "int", $aRet[0])
        Return 1
    EndIf

    Return SetError(1)
EndFunc   ;==>_WinAPI_LoadKeyboardLayoutEx

