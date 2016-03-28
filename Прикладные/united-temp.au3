#include <Misc.au3>
#include <Array.au3>

global $Shet=0
$sleep=200

$newBuffer = ClipGet()
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($newBuffer) = ' & StringLen($newBuffer)  & @CRLF) ;### Debug Console
$newBuffer = StringLeft($newBuffer, StringInStr($newBuffer, 'end.' & @CRLF, 0, -1) + 5)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringInStr($newBuffer,''end.''&@CRLF,0,-1)+5 = ' & StringInStr($newBuffer,'end.'&@CRLF,0,-1)+5  & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringInStr($newBuffer,''end.'',0,-1) = ' & StringInStr($newBuffer,'end.',0,-1)  & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringInStr($newBuffer,''end.'',0,1) = ' & StringInStr($newBuffer,'end.',0,1)  & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $newBuffer = ' & $newBuffer  & @CRLF) ;### Debug Console
HotKeySet('{ESC}', '_Exit')
HotKeySet('{f5}', '_go')
HotKeySet('{f6}', '_go2')
HotKeySet('{f7}', '_go3')
HotKeySet('{f8}', '_gofile')

_File()
Exit

While 1
	Sleep(100)

	If _IsPressed(04) Then _Exit()
;~ 	If _IsPressed(02) Then _GO2()
;~ 	$hwndOld=WinGetHandle('[ACTIVE]')
;~ 	WinActivate('UNI77 - TeamViewer')
;~ 	ControlSend('UNI77 - TeamViewer','','[CLASS:TV_REMOTEDESKTOP_CLASS; INSTANCE:1]','{UP}')
;~ 	WinActivate($hwndOld)
;~ 	Sleep(Random(5000,30000))
WEnd


Func _GO3()
	sleep(2000)
;~ Send('{END}')
While 1
	Send('^{Down}')
	Sleep($sleep)
	Send('{UP}')
	Send('{UP}')
	Sleep($sleep)
WEnd
EndFunc

Func _gofile()
	$file = @ScriptDir & '/fileout.txt'
	$hFile = FileOpen($file, 9)
	$bufferold = ClipGet()
	While 1
		If _IsPressed(04) Then exitloop
		Send('^{INS}')
		sleep($sleep)
		Send('{DOWN}')
		FileWriteLine($hFile, ClipGet())
	WEnd
	FileClose($hFile)
EndFunc



Func _GO()
	_MouseMove()
	ConsoleWrite($Shet&' ')
	$Shet+=1
	Send('{APPSKEY}')
	Send('{DOWN}')
	Send('{DOWN}')
	Send('{DOWN}')
	Send('{ENTER}')
EndFunc   ;==>_GO

Func _GO2()
	_MouseMove()
	Send('+{ESC}')
	Send('{DOWN}')
EndFunc   ;==>_GO2

Func _MouseMove()
	$cor=MouseGetPos()
	MouseMove($cor[0],$cor[1]-2)
EndFunc

Func _File()
	$path = 'C:\Users\Виталий\Documents\1C\Retail1\1Cv8.1CD'
	$pathnew = $path&'.new'
	$stepread=16
	FileDelete($pathnew)
	$hfw = FileOpen($pathnew, 17)
	$hf = FileOpen($path, 16)

	$shet=0
	While $shet < 5
		$filewrite=0
		$Filecontent = StringTrimLeft(FileRead($hf, $stepread), 2)
		ConsoleWrite($Filecontent&@CRLF)
;~ 		if StringInStr($Filecontent,'0000') Then
;~ 			FileWrite($hfw,$Filecontent)
;~ 			ContinueLoop
;~ 		EndIf
;~ 		For $i=0 to $stepread step 2
;~ 			StringMid



		$shet+=1
	WEnd

EndFunc




;~ Func FileWrite($hfw,$text)
;~ 	FileWrite($hfw,$text)

#include <WinAPIEx.au3>

Global $PID = 0, $Prev1 = 0, $Prev2 = 0

While 1
	ConsoleWrite(_CPU('palemoon.exe') & @CRLF)
	Sleep(1000)
WEnd

Func _CPU($sProcess)
	Local $ID, $Time1, $Time2, $CPU
	$ID = ProcessExists($sProcess)
	If $ID Then
		$Time1 = _WinAPI_GetProcessTimes($ID)
		$Time2 = _WinAPI_GetSystemTimes()
		If (IsArray($Time1)) And (IsArray($Time2)) Then
			$Time1 = $Time1[1] + $Time1[2]
			$Time2 = $Time2[1] + $Time2[2]
			If ($Prev1) And ($Prev2) And ($PID = $ID) Then
				$CPU = Round(($Time1 - $Prev1) / ($Time2 - $Prev2) * 100)
			EndIf
			$Prev1 = $Time1
			$Prev2 = $Time2
			$PID = $ID
			Return $CPU
		EndIf
	EndIf
	$Prev1 = 0
	$Prev2 = 0
	$PID = 0
EndFunc   ;==>_CPU

Func _exit()
	Exit
EndFunc   ;==>_exit
