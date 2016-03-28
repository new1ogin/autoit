#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Connection_Emulator_fast.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****

$testdelay=10
$WinOK = "[TITLE:SoftPerfect Connection Emulator;CLASS:#32770]"
$winConnEmu = "[TITLE:SoftPerfect Connection Emulator [Trial Version];CLASS:TSimulatorForm]"

$name = @AutoItExe
$TimeToWork = StringRegExp($name,"\((.*?)\).exe",2)
if UBound($TimeToWork) > 1 Then
	$TimeToWork = $TimeToWork[1] * 1000
Else
	$TimeToWork = 300 * 1000
EndIf

;~ $timer=TimerInit()
;~ While TimerDiff($timer) < $TimeToWork
;~ 	if WinExists($WinOK) Then
;~ 		$OldHandle = WinGetHandle('[ACTIVE]')
;~ 		WinActivate($WinOK)
;~ 		ControlClick($WinOK,"","[CLASS:Button; INSTANCE:1]")
;~ 		sleep($testdelay)
;~ 		WinActivate($winConnEmu)
;~ 		ControlClick($winConnEmu,"","[CLASS:TButton; INSTANCE:1]")
;~ 		WinActivate($OldHandle)
;~ 	EndIf
;~ 	sleep(50)
;~ WEnd



$timer=TimerInit()
While TimerDiff($timer) < $TimeToWork
	if WinExists($WinOK) Then
;~ 		$OldHandle = WinGetHandle('[ACTIVE]')
;~ 		WinActivate($WinOK)
		ControlClick($WinOK,"","[CLASS:Button; INSTANCE:1]")
;~ 		sleep($testdelay)
;~ 		WinActivate($winConnEmu)
		ControlClick($winConnEmu,"","[CLASS:TButton; INSTANCE:1]")
		sleep($testdelay)
		ControlClick($winConnEmu,"&Start","[CLASS:TButton; INSTANCE:1]")
;~ 		WinActivate($OldHandle)
	EndIf
	sleep(5)
WEnd


