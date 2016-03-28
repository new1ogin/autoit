#include <FileOperations.au3>
#include <Array.au3>
#include <WinAPIEx.au3>
$qGets = 10 * 10 ; количество замеров и одновременно время слежения за процессом = 10 сек
Global $PID = 0, $Prev1 = 0, $Prev2 = 0, $CPU, $memr, $CPUPrev, $memrPrev, $aCPU[$qGets], $amemr[$qGets], $timercurrent


;~ $1Cv8iPath = @LocalAppDataDir & '\1C\1CEStart\ibases.v8i'
;~ if FileExists($1Cv8iPath) Then
;~
;~ Else
;~ 	MsgBox(0,' Ошбика','базы 1с не найдены')
;~ EndIf
Global $ResultTest[100][2], $irt = 0
;~ $1cPath = 'D:\1сОтчетность\Отчетность|D:\Base1C\отчетность МН|D:\Base1C\ООО Гарант|D:\Base1C\ЗУП ГАРАНТ'
;~ $login = 'Администратор|Администратор|Маргарита|'
;~ $passwords = '|||'
$1cPath = '\\server01\1C_Base\ПРОФФ|\\Sergus\наши базы\__ПРОФФ'
$login = 'Виталий|Виталий'
$passwords = 'Zydfhm15|123'
$procCPU_Min = 1 ;минимальный процент изменения частоты процессора для определения процесса как закончевшого загрузку
$procMEM_Min = 1 ;минимальный процент изменения занимаемой памяти для определения процесса как закончевшого загрузку

$1CestartPath = ''
global $1CTrackProcess = '1cv8.exe'
If FileExists('C:\Program Files (x86)\1cv8\common\1cestart.exe') Then
	$1CestartPath = 'C:\Program Files (x86)\1cv8\common\1cestart.exe'
Else
	If FileExists('C:\Program Files\1cv8\common\1cestart.exe') Then
		$1CestartPath = 'C:\Program Files\1cv8\common\1cestart.exe'
	Else
		$t1 = _FO_FileSearch(@ProgramFilesDir, '1cestart.exe')
		If @error Then $t1 = _FO_FileSearch(StringLeft(@WindowsDir, 3) & 'Program Files (x86)', '1cestart.exe')
		If @error Then $t1 = _FO_FileSearch(StringLeft(@WindowsDir, 3), '1cestart.exe')
		If @error Then MsgBox(0, ' Ошбика', 'установленная 1С не найдена (1cestart.exe)')
		$1CestartPath = $t1[1]
	EndIf
EndIf


;~ @LocalAppDataDir
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @LocalAppDataDir = ' & @LocalAppDataDir & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @AppDataDir = ' & @AppDataDir & @CRLF) ;### Debug Console

$a1cPath = StringSplit($1cPath, '|')
$alogin = StringSplit($login, '|')
ReDim $alogin[UBound($a1cPath)]
$apasswords = StringSplit($passwords, '|')
ReDim $apasswords[UBound($a1cPath)]
For $i = 1 To $a1cPath[0]
	If StringLen(StringStripWS($apasswords[$i], 3)) < 1 Then
		$p = ''
	Else
		$p = ' /P"' & $apasswords[$i] & '"'
	EndIf
	If StringLen(StringStripWS($alogin[$i], 3)) < 1 Then
		$n = ''
	Else
		$n = ' /N"' & $alogin[$i] & '"'
	EndIf
	$BasePath = $a1cPath[$i]
	$path = '"' & $1CestartPath & '" ENTERPRISE  /F"' & $BasePath & '"' & $n & $p
	$ipid = _TestStartTime($path)
	ProcessClose($ipid)

Next

_ArrayDisplay($ResultTest)

Func _TestStartTime($path)
	$timer = TimerInit()
	; запуск и поиск процесса
	$FindProc1 = ProcessList($1CTrackProcess)
	$ipid = Run($path)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $path = ' & $path & @CRLF) ;### Debug Console
	$ipid = _findPid1C($FindProc1)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ipid = ' & $ipid & @CRLF) ;### Debug Console
	if $ipid = 0 Then
		$ResultTest[$irt][0] = 'error'
		$irt+=1
		return $ipid
	EndIf
	$schet = 1
	While 1
		_GetCPUnMEM($ipid) ;получаем текущие значения загрузки процессора и оперативной памяти
		_ArrayPush($aCPU, $CPU) ; записываем значения в массив
		_ArrayPush($amemr, $memr)
		$procCPU = 100 * _ArrayMax($aCPU) - _ArrayMin($aCPU)
		if @error or StringInStr($procCPU,'#IND')>0 then $procCPU = 0
		$procMEM = 100 * _ArrayMax($amemr) / _ArrayMin($amemr)
		if @error or StringInStr($procMEM,'#IND')>0 then $procMEM = 0
		if Mod($schet,10)=0 then ConsoleWrite('('&Round($procCPU,4)&' '&Round($procMEM,4)&')'&' _MxC='&_ArrayMax($aCPU)&' _MiC='&_ArrayMin($aCPU)&' _MxM='&_ArrayMax($amemr)&' _MiM='&_ArrayMin($amemr)&@CRLF)
		If $procCPU < $procCPU_Min And $procMEM < $procMEM_Min Then

			ExitLoop
		EndIf
		Sleep((100 * $schet) - TimerDiff($timer))
		$schet += 1
	WEnd

	$ResultTest[$irt][0] = $path
	$ResultTest[$irt][1] = Round(TimerDiff($timer) - $qGets * 100, 2)
	$irt+=1
;~ 		$CPUPrev = $CPU
;~ 		$memrPrev = $memr

	Return $ipid
EndFunc   ;==>_TestStartTime

Func _findPid1C($FindProc1)
	For $i=0 to 200
		$FindProc2 = ProcessList($1CTrackProcess)
		if $FindProc2[0][0] > $FindProc1[0][0] then ExitLoop
		sleep(100)
	Next
	if $FindProc2[0][0] <= $FindProc1[0][0] then return 0
	For $i=1 to $FindProc1[0][0]
		_ArrayDelete($FindProc2,_ArraySearch($FindProc2,$FindProc1[$i][1],1,0,0,0,1,1))
	Next
	_ArrayDisplay($FindProc2)
	Return $FindProc2[1][1]
EndFunc



Func _GetCPUnMEM($sProcess)
	Local $ID, $Time1, $Time2, $mem
	$ID = ProcessExists($sProcess)
	If $ID Then
		$Time1 = _WinAPI_GetProcessTimes($ID)
		$Time2 = _WinAPI_GetSystemTimes()
		If (IsArray($Time1)) And (IsArray($Time2)) Then
			$Time1 = $Time1[1] + $Time1[2]
			$Time2 = $Time2[1] + $Time2[2]
			If ($Prev1) And ($Prev2) And ($PID = $ID) Then
				$CPU = Round(($Time1 - $Prev1) / ($Time2 - $Prev2) * 100, 2)
			EndIf
			$Prev1 = $Time1
			$Prev2 = $Time2
			$PID = $ID
			$mem = _WinAPI_GetProcessMemoryInfo($ID)
;~ 			_ArrayDisplay($mem)
			$memr = Round($mem[9] / 1024) + Round($mem[2] / 1024) ; память неразделяемый байт + рабочий набор
			ConsoleWrite($memr &'-'&$CPU&' ')
			Return 1
		EndIf
	EndIf
	$Prev1 = 0
	$Prev2 = 0
	$PID = 0
EndFunc   ;==>_GetCPUnMEM




