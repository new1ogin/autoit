#include <Array.au3>
;~ $hWin = _WinGetHandleEx(@AutoItPID, "", "", "", 0)
$sProcess = 'AkelPad.exe'
$sUserSearch = 'ёзер'
$sUser = ''
$j = 0
Dim $aUser[$j + 1][3]
$sUser = _ProcessGetOwner(@AutoItPID)
MsgBox(16, $sProcess, $sUser )
$aList = ProcessList($sProcess)
If $aList[0][0] Then
    For $i = 1 To $aList[0][0]
        $sUser = _ProcessGetOwner($aList[$i][1])
        If $sUser = $sUserSearch Then
            $j += 1
            ReDim $aUser[$j + 1][3]
            $aUser[$j][0] = $aList[$i][0]
            $aUser[$j][1] = $aList[$i][1]
            $aUser[$j][2] = $sUser
            $aUser[0][0] = $j
        EndIf
    Next
    If $j Then
        _ArrayDisplay($aUser)
    Else
        MsgBox(16, $sProcess, 'No User ' & $sUserSearch)
    EndIf
Else
    MsgBox(16, $sUserSearch, 'No Process ' & $sProcess)
EndIf

Func _ProcessGetOwner($PID, $sComputer = ".")
    Local $objWMI, $colProcs, $sUserName, $sUserDomain
    $objWMI = ObjGet("winmgmts:\\" & $sComputer & "\root\cimv2")
    If IsObj($objWMI) Then
        $colProcs = $objWMI.ExecQuery("Select ProcessId From Win32_Process Where ProcessId=" & $PID)
        If IsObj($colProcs) Then
            For $Proc In $colProcs
                If $Proc.GetOwner($sUserName, $sUserDomain) = 0 Then Return $sUserName
            Next
        EndIf
    EndIf
EndFunc   ;==>_ProcessGetOwner
