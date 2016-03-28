$iProc = ProcessExists("nacl64.exe")
Global $fSuspended = 0
$iProc=1668
global $manyProc[5] = [1668,784,980,1184,1580]
global $UboundmanyProc=ubound($manyProc)-1
ConsoleWrite($iProc &@CRLF)

	HotKeySet("{End}", "Terminate")
;~ _ProcessResume($iProc) ;"Разморозка" процесса
_WhileMany()
Func _WhileMany()

	while 1
		for $i=0 to $UboundmanyProc
			$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $manyProc[$i])
            $i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
            DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
		next
		sleep(2500)
		for $i=0 to $UboundmanyProc
			$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $manyProc[$i])
            $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
            DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
		next
		sleep(2500)


	WEnd
EndFunc



Func _While1()
while 1
;~ 	$testtime=TimerInit()
;~ 	;~ _ProcessSuspend($iProc) ;"Заморозка" процесса
;~ 	_ProcSuspendResume($iProc)
            $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iProc)
            $i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
            DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
	Sleep(500)
;~ 	$test1=TimerDiff($testtime)
;~ 	;~ _ProcessResume($iProc) ;"Разморозка" процесса
;~ 	_ProcSuspendResume($iProc)
            $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iProc)
            $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
            DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
;~ 	$test2=TimerDiff($testtime)
	Sleep(10)
wend
EndFunc
;~ sleep(10000)





;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $test1 = ' & $test1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $test2 = ' & $test2 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
;~ _ProcessResume($iProc) ;"Разморозка" процесса
;~ 	Sleep(1000)
;~ _ProcessResume($iProc) ;"Разморозка" процесса
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $test1 = ' & $test1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $test2 = ' & $test2 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
            $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $iProc)
            $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
            DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
		for $i=0 to $UboundmanyProc
			$ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $manyProc[$i])
            $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
            DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
		next
	Exit 0
EndFunc   ;==>Terminate


Func _ProcSuspendResume($process)
	$processid = $process
;~     $processid = ProcessExists($process)
    If $processid Then
        If $fSuspended Then
            $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
            $i_sucess = DllCall("ntdll.dll","int","NtResumeProcess","int",$ai_Handle[0])
            DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
            If IsArray($i_sucess) Then
                $fSuspended = 0
                Return 1
            Else
                SetError(1)
                Return 0
            Endif
        Else
            $ai_Handle = DllCall("kernel32.dll", 'int', 'OpenProcess', 'int', 0x1f0fff, 'int', False, 'int', $processid)
            $i_sucess = DllCall("ntdll.dll","int","NtSuspendProcess","int",$ai_Handle[0])
            DllCall('kernel32.dll', 'ptr', 'CloseHandle', 'ptr', $ai_Handle)
            If IsArray($i_sucess) Then
                $fSuspended = 1
                Return 1
            Else
                SetError(1)
                Return 0
            Endif
        EndIf
    Else
        SetError(2)
        Return 0
    Endif
EndFunc




;===============================================================================
;
; Description:      Suspend all Threads in a Process
; Parameter(s):     $vProcess - Name or PID of Process
; Requirement(s):   3.1.1.130, Win ME/2k/XP
; Return Value(s):  On Success - Returns Nr. of Threads Suspended and Set @extended to Nr. of Threads Processed
;                   On Failure - Returns False and Set
;                                               @error to:  1 - Process not Found
;                                                           2 - Error Calling 'CreateToolhelp32Snapshot'
;                                                           3 - Error Calling 'Thread32First'
;                                                           4 - Error Calling 'Thread32Next'
;                                                           5 - Not all Threads Processed
; Author(s):        Florian 'Piccaso' Fida
; Note(s):          Ported from: http://www.codeproject.com/threads/pausep.asp
;                   Better read the article (and the warnings!) if you want to use it :)
;
;===============================================================================
Func _ProcessSuspend($vProcess, $iReserved = 0)
    Local $iPid, $vTmp, $hThreadSnap, $ThreadEntry32, $iThreadID, $hThread, $iThreadCnt, $iThreadCntSuccess, $sFunction
    Local $TH32CS_SNAPTHREAD = 0x00000004
    Local $INVALID_HANDLE_VALUE = 0xFFFFFFFF
    Local $THREAD_SUSPEND_RESUME = 0x0002
    Local $THREADENTRY32_StructDef = "int;" _; 1 -> dwSize
             & "int;" _; 2 -> cntUsage
             & "int;" _; 3 -> th32ThreadID
             & "int;" _; 4 -> th32OwnerProcessID
             & "int;" _; 5 -> tpBasePri
             & "int;" _; 6 -> tpDeltaPri
             & "int" ; 7 -> dwFlags
    $iPid = ProcessExists($vProcess)
    If Not $iPid Then Return SetError(1, 0, False) ; Process not found.
    $vTmp = DllCall("kernel32.dll", "ptr", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPTHREAD, "int", 0)
    If @error Then Return SetError(2, 0, False) ; CreateToolhelp32Snapshot Failed
    If $vTmp[0] = $INVALID_HANDLE_VALUE Then Return SetError(2, 0, False) ; CreateToolhelp32Snapshot Failed
    $hThreadSnap = $vTmp[0]
    $ThreadEntry32 = DllStructCreate($THREADENTRY32_StructDef)
    DllStructSetData($ThreadEntry32, 1, DllStructGetSize($ThreadEntry32))
    $vTmp = DllCall("kernel32.dll", "int", "Thread32First", "ptr", $hThreadSnap, "long", DllStructGetPtr($ThreadEntry32))
    If @error Then Return SetError(3, 0, False) ; Thread32First Failed
    If Not $vTmp[0] Then
        DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hThreadSnap)
        Return SetError(3, 0, False) ; Thread32First Failed
    EndIf
    While 1
        If DllStructGetData($ThreadEntry32, 4) = $iPid Then
            $iThreadID = DllStructGetData($ThreadEntry32, 3)
            $vTmp = DllCall("kernel32.dll", "ptr", "OpenThread", "int", $THREAD_SUSPEND_RESUME, "int", False, "int", $iThreadID)
            If Not @error Then
                $hThread = $vTmp[0]
                If $hThread Then
                    If $iReserved Then
                        $sFunction = "ResumeThread"
                    Else
                        $sFunction = "SuspendThread"
                    EndIf
                    $vTmp = DllCall("kernel32.dll", "int", $sFunction, "ptr", $hThread)
                    If $vTmp[0] <> -1 Then $iThreadCntSuccess += 1
                    DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $hThread)
                EndIf
            EndIf
            $iThreadCnt += 1
        EndIf
        $vTmp = DllCall("kernel32", "int", "Thread32Next", "ptr", $hThreadSnap, "long", DllStructGetPtr($ThreadEntry32))
        If @error Then Return SetError(4, 0, False) ; Thread32Next Failed
        If Not $vTmp[0] Then ExitLoop
    WEnd
    DllCall("kernel32.dll", "int", "CloseToolhelp32Snapshot", "ptr", $hThreadSnap) ; CloseHandle
    If Not $iThreadCntSuccess Or $iThreadCnt > $iThreadCntSuccess Then Return SetError(5, $iThreadCnt, $iThreadCntSuccess)
    Return SetError(0, $iThreadCnt, $iThreadCntSuccess)
EndFunc

;===============================================================================
;
; Description:      Resume all Threads in a Process
; Parameter(s):     $vProcess - Name or PID of Process
; Requirement(s):   3.1.1.130, Win ME/2k/XP
; Return Value(s):  On Success - Returns Nr. of Threads Resumed and Set @extended to Nr. of Threads Processed
;                   On Failure - Returns False and Set
;                                               @error to:  1 - Process not Found
;                                                           2 - Error Calling 'CreateToolhelp32Snapshot'
;                                                           3 - Error Calling 'Thread32First'
;                                                           4 - Error Calling 'Thread32Next'
;                                                           5 - Not all Threads Processed
; Author(s):        Florian 'Piccaso' Fida
; Note(s):          Ported from: http://www.codeproject.com/threads/pausep.asp
;                   Better read the article (and the warnings!) if you want to use it :)
;
;===============================================================================
Func _ProcessResume($vProcess)
    Local $fRval = _ProcessSuspend($vProcess, True)
    Return SetError(@error, @extended, $fRval)
EndFunc
