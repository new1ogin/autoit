#include <array.au3>
HotKeySet("{Esc}", "_Quit") ;Это вызов
$sFile=@ScriptDir & "\DB\"&'User.dat'
$sFile="D:\Мультимедиа\5 чувств страха.2013. WEB-DLRip.avi"
;~ global $timeConnect=Timerinit()
;~ _MD5ForFile($sFile)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Подключился к FTP. Время подключения (в мс) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

#include <Constants.au3>

Local $iPID = Run("StartOrientirFastFTP-2.exe", @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
Local $sOutput
;~ While 1
;~     $sOutput = StdoutRead($iPID)
;~     If @error Then ; Выход из цикла, если процесс завершён или StdoutRead возвращает ошибку.
;~         ExitLoop
;~     EndIf
;~     MsgBox(4096, "Stdout прочитано:", $sOutput)
;~ WEnd

While 1
    $sOutput = StderrRead($iPID)
    If @error Then ; Выход из цикла, если процесс завершён или StdoutRead возвращает ошибку.
        ExitLoop
    EndIf
    MsgBox(4096, "Stderr прочитано:", $sOutput)
WEnd


;~ #include <Array.au3>
;~ #include <Constants.au3>

;~ $sPath = @ScriptDir ; Каталог для поиска.
;~ $sFileMask = '*.*' ; Маска. Поиск всех файлов в текущем каталоге. Правильный формат маски поиска смотрите в описании к функции FileFindFirstFile.
;~ $sOut = '' ; Переменная для хранения вывода StdoutRead.

;~ ; Если указанный путь не является каталогом, то выход
;~ If Not StringInStr(FileGetAttrib($sPath), "D") Then Exit

;~ $sOut = StringToBinary('0' & @CRLF, 2)
;~ $sPath = StringRegExpReplace($sPath, '\\+$', '') ; Удаляет завершающие слэши

;~ #cs
;~     Параметры ком-строки для DIR:
;~     /B - вывод только имен.
;~     /A-D - поиск всех файлов, без папок.
;~     /S - поиск в подкаталогах.
;~ #ce
;~ $iPID = Run(@ScriptDir&"\StartOrientirFastFTP-2.exe",'', @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)

;~ While 1
;~     $sOut &= StdoutRead($iPID, False, True)
;~ 	ConsoleWrite(StdoutRead($iPID, False, True))
;~     If @error Then ExitLoop
;~ 	sleep(100)
;~ Wend

;~ $aOut = StringRegExp(BinaryToString($sOut, 2), '[^\r\n]+', 3)

;~ If @error Or UBound($aOut) < 2 Then Exit

;~ $aOut[0] = UBound($aOut)-1
;~ _ArrayDisplay($aOut, 'все файлы')


Func _MD5ForFile($sFile)

    Local $a_hCall = DllCall("kernel32.dll", "hwnd", "CreateFileW", _
            "wstr", $sFile, _
            "dword", 0x80000000, _ ; GENERIC_READ
            "dword", 1, _ ; FILE_SHARE_READ
            "ptr", 0, _
            "dword", 3, _ ; OPEN_EXISTING
            "dword", 0, _ ; SECURITY_ANONYMOUS
            "ptr", 0)

    If @error Or $a_hCall[0] = -1 Then
        Return SetError(1, 0, "")
    EndIf

    Local $hFile = $a_hCall[0]

    $a_hCall = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", _
            "hwnd", $hFile, _
            "dword", 0, _ ; default security descriptor
            "dword", 2, _ ; PAGE_READONLY
            "dword", 0, _
            "dword", 0, _
            "ptr", 0)

    If @error Or Not $a_hCall[0] Then
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
        Return SetError(2, 0, "")
    EndIf

    DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)

    Local $hFileMappingObject = $a_hCall[0]

    $a_hCall = DllCall("kernel32.dll", "ptr", "MapViewOfFile", _
            "hwnd", $hFileMappingObject, _
            "dword", 4, _ ; FILE_MAP_READ
            "dword", 0, _
            "dword", 0, _
            "dword", 0)

    If @error Or Not $a_hCall[0] Then
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(3, 0, "")
    EndIf

    Local $pFile = $a_hCall[0]
    Local $iBufferSize = FileGetSize($sFile)

    Local $tMD5_CTX = DllStructCreate("dword i[2];" & _
            "dword buf[4];" & _
            "ubyte in[64];" & _
            "ubyte digest[16]")

    DllCall("advapi32.dll", "none", "MD5Init", "ptr", DllStructGetPtr($tMD5_CTX))

    If @error Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(4, 0, "")
    EndIf

    DllCall("advapi32.dll", "none", "MD5Update", _
            "ptr", DllStructGetPtr($tMD5_CTX), _
            "ptr", $pFile, _
            "dword", $iBufferSize)

    If @error Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(5, 0, "")
    EndIf

    DllCall("advapi32.dll", "none", "MD5Final", "ptr", DllStructGetPtr($tMD5_CTX))

    If @error Then
        DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
        DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
        Return SetError(6, 0, "")
    EndIf

    DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
    DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)

    Local $sMD5 = Hex(DllStructGetData($tMD5_CTX, "digest"))

    Return SetError(0, 0, $sMD5)

EndFunc   ;==>_MD5ForFile


;~ $schet=0
;~ dim $result[10][2]
;~ $sFile1=@ScriptDir & "\DB\"&'User.dat'
;~ $sFile2=@ScriptDir & "\DB\"&'User.idx'
;~ $t=TimerInit
;~ $sModified1 = FileGetTime($sFile1, 0, 1)
;~ $result[0][0]=$sModified1
;~ $sModified2 = FileGetTime($sFile2, 0, 1)
;~ $result[0][1]=$sModified2
;~ While 1
;~ $sModified1n = FileGetTime($sFile1, 0, 1)
;~ $sModified2n = FileGetTime($sFile2, 0, 1)
;~ if $sModified1<>$sModified1n Then
;~ 	$schet+=1
;~ 	$result[$schet][0]=TimerDiff($t)
;~ 	$sModified1=$sModified1n
;~ EndIf
;~ if $sModified2<>$sModified2n Then
;~ 	$schet+=1
;~ 	$result[$schet][1]=TimerDiff($t)
;~ 	$sModified2=$sModified2n
;~ EndIf
;~ wend


Func _Quit()

;~ 	_ArrayDisplay($result)
	    Exit
EndFunc