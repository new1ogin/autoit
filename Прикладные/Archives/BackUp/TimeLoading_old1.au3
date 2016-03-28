#Include <FileOperations.au3>
#include <Array.au3>
#include <WinAPIEx.au3>
$qGets = 30 * 10 ; количество замеров и одновременно время слежения за процессом = 30 сек
Global $PID = 0, $Prev1 = 0, $Prev2 = 0, $CPU, $memr, $CPUPrev, $memrPrev, $aCPU[$qGets], $amemr[$qGets], $timercurrent


;~ $1Cv8iPath = @LocalAppDataDir & '\1C\1CEStart\ibases.v8i'
;~ if FileExists($1Cv8iPath) Then
;~
;~ Else
;~ 	MsgBox(0,' Ошбика','базы 1с не найдены')
;~ EndIf
Global $ResultTest[100][2],$irt=0
;~ $1cPath = 'D:\1сОтчетность\Отчетность|D:\Base1C\отчетность МН|D:\Base1C\ООО Гарант|D:\Base1C\ЗУП ГАРАНТ'
;~ $login = 'Администратор|Администратор|Маргарита|'
;~ $passwords = '|||'
$1cPath = '\\server01\1C_Base\ПРОФФ|\\Sergus\наши базы\__ПРОФФ'
$login = 'Виталий|Виталий'
$passwords = 'Zydfhm15|123'
$procCPU_Min = 1 ;минимальный процент изменения частоты процессора для определения процесса как закончевшого загрузку
$procMEM_Min = 1 ;минимальный процент изменения занимаемой памяти для определения процесса как закончевшого загрузку

$1CestartPath = ''
if FileExists('C:\Program Files (x86)\1cv8\common\1cestart.exe') Then
	$1CestartPath = 'C:\Program Files (x86)\1cv8\common\1cestart.exe'
Else
	if FileExists('C:\Program Files\1cv8\common\1cestart.exe') Then
		$1CestartPath = 'C:\Program Files\1cv8\common\1cestart.exe'
	Else
		$t1 = _FO_FileSearch ( @ProgramFilesDir ,'1cestart.exe')
		if @error Then $t1 = _FO_FileSearch ( StringLeft(@WindowsDir,3)&'Program Files (x86)' ,'1cestart.exe')
		if @error Then $t1 = _FO_FileSearch ( StringLeft(@WindowsDir,3) ,'1cestart.exe')
		if @error Then MsgBox(0,' Ошбика','установленная 1С не найдена (1cestart.exe)')
		$1CestartPath = $t1[1]
	EndIf
EndIf


;~ @LocalAppDataDir
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @LocalAppDataDir = ' & @LocalAppDataDir & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @AppDataDir = ' & @AppDataDir & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

$a1cPath = StringSplit($1cPath,'|')
$alogin = StringSplit($login,'|')
ReDim $alogin[UBound($a1cPath)]
$apasswords = StringSplit($passwords,'|')
ReDim $apasswords[UBound($a1cPath)]
For $i=1 to $a1cPath[0]
	if StringLen(StringStripWS($apasswords[$i],3)) < 1 Then
		$p = ''
	Else
		$p = ' /P"'&$apasswords[$i]&'"'
	EndIf
	if StringLen(StringStripWS($alogin[$i],3)) < 1 Then
		$n = ''
	Else
		$n = ' /N"'&$alogin[$i]&'"'
	EndIf
	$BasePath = $a1cPath[$i]
	$path =  '"'&$1CestartPath&'" ENTERPRISE  /F"'&$BasePath&'"'&$n&$p
	$ipid = _TestStartTime($path)
	ProcessClose($ipid)

Next

_ArrayDisplay($ResultTest)

Func _TestStartTime($path)
	$timer = TimerInit()
	$ipid = Run($path)
	$schet=1
	While 1
		_GetCPUnMEM($ipid) ;получаем текущие значения загрузки процессора и оперативной памяти
		_ArrayPush($aCPU, $CPU) ; записываем значения в массив
		_ArrayPush($amemr, $memr)
		$procCPU = 100*_ArrayMax($aCPU)/_ArrayMin($aCPU)
		$procMEM = 100*_ArrayMax($amemr)/_ArrayMin($amemr)
		if $procCPU < $procCPU_Min and $procMEM < $procMEM_Min Then

			ExitLoop
		EndIf
		sleep((100*$schet)-TimerDiff($timer))
		$schet+=1
	WEnd

	$ResultTest[$irt][0] = $path
	$ResultTest[$irt][1] = Round(TimerDiff($timer) - $qGets*100,2)
;~ 		$CPUPrev = $CPU
;~ 		$memrPrev = $memr

	return $ipid
EndFunc



Func _GetCPUnMEM($sProcess)
    Local $ID, $Time1, $Time2, $mem
    $ID = ProcessExists($sProcess)
    If $ID Then
        $Time1 = _WinAPI_GetProcessTimes($ID)
        $Time2 = _WinAPI_GetSystemTimes()
        If(IsArray($Time1)) And(IsArray($Time2)) Then
            $Time1 = $Time1[1] + $Time1[2]
            $Time2 = $Time2[1] + $Time2[2]
            If($Prev1) And($Prev2) And($PID = $ID) Then
                $CPU = Round(($Time1 - $Prev1) / ($Time2 - $Prev2) * 100,2)
            EndIf
            $Prev1 = $Time1
            $Prev2 = $Time2
            $PID = $ID
			$mem = _WinAPI_GetProcessMemoryInfo($ID)
;~ 			_ArrayDisplay($mem)
			$memr = Round($Mem[9] / 1024) + Round($Mem[2] / 1024) ; память неразделяемый байт + рабочий набор

            Return 1
        EndIf
    EndIf
    $Prev1 = 0
    $Prev2 = 0
    $PID = 0
EndFunc   ;==>_CPU




