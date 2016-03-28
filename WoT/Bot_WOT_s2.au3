#Include <WinAPIEx.au3>
Global $hListView, $PID = 0, $Prev1 = 0, $Prev2 = 0
Global Const $sProcess = 'WorldOfTanks.exe'

#Include <WinAPIEx.au3>
#include <Array.au3>
#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("PixelCoordMode", 2)
HotKeySet("{End}", "Terminate")
;~ HotKeySet("{Home}", "_Wait_Battle")
Func Terminate()
;~ TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
ProcessClose('Bot_WOT_s.exe')
;~ 	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
global $Paused


global $menuCPU, $menuMEM
#include <Constants.au3>
ProcessClose('Bot_WOT_s.exe')
$path=@ScriptDir & "\Bot_WOT_s.exe"
Global $turn = 1, $stop = 0, $TimeOutTurn = 0
global $iPID = Run($path, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
Local $sOutput, $SummmenuCPU, $SummmenuMEM, $turnd=10
global $SummmenuCPU=0,$SummmenuMEM=0
global $CruiseControl=1, $ModRadio=1, $Timeturn=1800, $TimeFightDelay=900000



Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=D:\Vitaliy\PROGRAMS\autoitv3.3.8.1\Koda\Bot_WoT.kxf
$hForm = GUICreate("Autoshot Shotgun", 279, 671, -1, -1, BitOR($GUI_SS_DEFAULT_GUI,$WS_SIZEBOX,$WS_THICKFRAME))
GUISetOnEvent($GUI_EVENT_CLOSE, "hFormClose")
$Button1 = GUICtrlCreateButton("Танк готов к бою", 8, 640, 99, 25)
GUICtrlSetOnEvent(-1, "_apply")
$Button2 = GUICtrlCreateButton("Скопировать лог", 168, 640, 99, 25)
GUICtrlSetOnEvent(-1, "_CopyLog")
$Edit1 = GUICtrlCreateEdit("", 8, 144, 257, 490, BitOR($ES_AUTOVSCROLL,$ES_READONLY,$ES_WANTRETURN,$WS_VSCROLL))
$Radio1 = GUICtrlCreateRadio("Почти не мешающий бот", 8, 8, 153, 17)
GUICtrlSetOnEvent(-1, "Radio1Click")
$Radio2 = GUICtrlCreateRadio("Имитация поворотов при остановке машины", 8, 32, 249, 17)
GUICtrlSetOnEvent(-1, "Radio2Click")
$Checkbox1 = GUICtrlCreateCheckbox("Круизконтроль", 16, 56, 97, 17)
GUICtrlSetOnEvent(-1, "Checkbox1Click")
$Input1 = GUICtrlCreateInput("1800", 144, 120, 121, 21)
GUICtrlSetOnEvent(-1, "Input1Change")
GUICtrlSetTip(-1, "Время поворота танка ~ на 90° в миллисекундах")
$Label1 = GUICtrlCreateLabel("Время поворота танка", 8, 120, 119, 17)
GUICtrlSetTip(-1, "Время поворота танка ~ на 90° в миллисекундах")
$Input2 = GUICtrlCreateInput("15", 144, 96, 121, 21)
GUICtrlSetOnEvent(-1, "Input2Change")
GUICtrlSetTip(-1, "Устанавливается на случай ошибки, мин.")
$Label2 = GUICtrlCreateLabel("Максимальное время боя", 8, 96, 137, 17)
GUICtrlSetTip(-1, "Устанавливается на случай ошибки, мин.")
$Button3 = GUICtrlCreateButton("Пауза", 112, 640, 49, 25)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

GUICtrlSetData($Edit1, 'Горячие клавши: "END" - закрыть БОТ' &@CRLF,1)
GUICtrlSetData($Edit1, '"INS" - приостановить БОТ (пауза)' &@CRLF,1)

;~ $SCHET = 599
;~ While 1
;~ 	$SCHET += 1
;~ 	Sleep(100)
;~ 	IF MOD($SCHET,600)=0 THEN GUICtrlSetData($Edit1, "Ожидаю действий пользователя.." &@CRLF,1)
;~ 	IF MOD($SCHET,100)=0 THEN _applyGUI()
;~ WEnd

Func _apply()
	_applyGUI()


EndFunc
Func _CopyLog()
	ClipPut(GUICtrlRead($Edit1))
EndFunc
Func Checkbox1Click()
	_applyGUI()
EndFunc
Func hFormClose()
	Terminate()
EndFunc
Func Input1Change()
	_applyGUI()
EndFunc
Func Input2Change()
	_applyGUI()
EndFunc
Func Radio1Click()

	GUICtrlSetState($Input1, $GUI_DISABLE)
	GUICtrlSetState($Label1, $GUI_DISABLE)
	_applyGUI()
EndFunc
Func Radio2Click()
	GUICtrlSetState($Input1, $GUI_ENABLE)
	GUICtrlSetState($Label1, $GUI_ENABLE)
	_applyGUI()
EndFunc

Func _applyGUI()
	If GUICtrlRead($Checkbox1)=1 Then
		$CruiseControl=1
	Else
		$CruiseControl=0
	EndIf
	If GUICtrlRead($Radio1)=1 Then
		$ModRadio=1
	Else
		$ModRadio=2
	EndIf
	$Timeturn=GUICtrlRead($Input1)
	$TimeFightDelay=GUICtrlRead($Input2)*60000

;~ 	GUICtrlSetData($Edit1, '$ModRadio= '&$ModRadio &@CRLF,1)
;~ 	GUICtrlSetData($Edit1, '$CruiseControl= '&$CruiseControl &@CRLF,1)
;~ 	GUICtrlSetData($Edit1, '$Timeturn= '&$Timeturn &@CRLF,1)
;~ 	GUICtrlSetData($Edit1, '$TimeFightDelay= '&$TimeFightDelay &@CRLF,1)
EndFunc

	$ID = ProcessExists($sProcess)
	$Time1 = _WinAPI_GetProcessTimes($ID)
	$Time2 = _WinAPI_GetSystemTimes()
	$Prev1 = $Time1[1] + $Time1[2]
	$Prev2 = $Time2[1] + $Time2[2]
while 1
	Dim $CPUarray[1], $memoryarray[1]
	For $i=1 to 5
		$ID = ProcessExists($sProcess)

		Local $ID, $Mem, $Time1, $Time2
;~ 			$Time1 = _WinAPI_GetProcessTimes($ID)
;~ 			$Time2 = _WinAPI_GetSystemTimes()
;~ 			If (IsArray($Time1)) And (IsArray($Time2)) Then
;~ 				$Time1 = $Time1[1] + $Time1[2]
;~ 				$Time2 = $Time2[1] + $Time2[2]
					$Mem = _WinAPI_GetProcessMemoryInfo($PID)
;~ 					$CPU=Round(($Time1 - $Prev1) / ($Time2 - $Prev2) * 100)
					$memory=_KB(Round($Mem[9] / 1024))
;~ 					GUICtrlSetData($Edit1, $CPU &'  '&$memory & @CRLF,1)
;~ 					Redim $CPUarray[$i+1], $memoryarray[$i+1]
;~ 					$CPUarray[$i]=$CPU
					;$memoryarray[$i]=$memory
;~ 				$Prev1 = $Time1
;~ 				$Prev2 = $Time2
				$PID = $ID

			EndIf
			sleep(100)

	next
;~ 	_arraydisplay($CPUarray)
	;Расчет средних значений
	$Uboundarray=UBound($CPUarray)-1
	local $CPUarraySumm=0;, $memoryarraySumm=0
	For $i=0 to $Uboundarray
		$CPUarraySumm+=$CPUarray[$i]
		;$memoryarraySumm+=$memoryarray[$i]
	Next
	$CPUarrayAver=$CPUarraySumm/$Uboundarray
	$memoryarrayAver=$memory;-$memory+$memoryarraySumm/$Uboundarray
	GUICtrlSetData($Edit1, $CPUarrayAver &'|'&$memoryarrayAver  & @CRLF,1)

wend

Func _KB($iSize)
    If StringLen($iSize) > 3 Then
        Return StringTrimRight($iSize, 3)  & ',' & StringLeft($iSize, 3) ; & ' K'
    EndIf
EndFunc   ;==>_KB