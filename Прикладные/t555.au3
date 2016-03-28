#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile_x64=t555_x64.exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #include <WinAPIEx.au3>
;~ #include <ListViewConstants.au3>
;~ #include <GUIConstantsEx.au3>
;~ #include <GuiListView.au3>
;~ #include <WindowsConstants.au3>
;~ #include <GUIConstantsEx.au3>
;~ #include <StaticConstants.au3>
#include <array.au3>
;~ #RequireAdmin
$testsleep=64
HotKeySet("^{F7}", "Terminate")
Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
;~ $t = WinList ("[CLASS:#32770]" )
;~ _ArrayDisplay($t)
;~ for $i=1 to $t[0][0]
;~ 	WinActivate($t[$i][1])
;~ 	ControlClick($t[$i][1],'','[CLASS:Button; INSTANCE:2]')
;~ runas /user:user C:\Windows\system32\cmd.exe
;~ runas /user:Виталий C:\Windows\system32\cmd.exe
;~ C:\temp\psexec.exe \\localhost "C:\Windows\system32\cmd.exe"
;~ C:\temp\psexec.exe -l -d "c:\program files\internet explorer\iexplore.exe"


$alltext = ''
sleep(3000)
For $i=1 to 199
	Send('{left}')
	sleep($testsleep*2)
	Send('{left}')
	sleep($testsleep*2)
	Send('{CtrlDown}')
	sleep($testsleep)
	Send('{INS}')
	sleep($testsleep)
	Send('{CtrlUP}')
	sleep($testsleep)
	$alltext &= StringReplace(StringReplace(StringReplace(Clipget(),@CRLF,@LF),@CR,@LF),@LF,' ;  ') & @TAB
	Send('{right}')
	sleep($testsleep)
	Send('{CtrlDown}')
	sleep($testsleep)
	Send('{INS}')
	sleep($testsleep)
	Send('{CtrlUP}')
	sleep($testsleep)
	$alltext &= StringReplace(StringReplace(StringReplace(Clipget(),@CRLF,@LF),@CR,@LF),@LF,' ;  ') & @TAB
	Send('{right}')
	sleep($testsleep)
	Send('{CtrlDown}')
	sleep($testsleep)
	Send('{INS}')
	sleep($testsleep)
	Send('{CtrlUP}')
	sleep($testsleep)
	Send('{down}')
	sleep($testsleep)
	$alltext &= StringReplace(StringReplace(StringReplace(Clipget(),@CRLF,@LF),@CR,@LF),@LF,' ;  ') & @CRLF
Next
ClipPut($alltext)
ConsoleWrite($alltext)
FileWrite(@AutoItExe&'.log',$alltext)
Exit

$moveFolder = "D:\Зараженные файлы\"
$files = ClipGet()
$files = StringSplit(StringReplace($files,@CRLF,@LF),@CRLF)
;~ _ArrayDisplay($files)
for $i=1 to $files[0]
;~ 	$files[$i] = _correctFileSpace($files[$i])
	If FileExists($moveFolder&$files[$i]) then FileMove($moveFolder&$files[$i],$moveFolder&$files[$i]&Chr(Random(97, 122, 1))&Chr(Random(65, 90, 1)))
	FileCopy(StringStripWS($files[$i],3),$moveFolder,8)
	FileDelete(StringStripWS($files[$i],3))
	ConsoleWrite('(' & StringStripWS($files[$i],3) & ')' & '(' & $moveFolder&$files[$i]& ')' & @CRLF) ;### Debug Console
Next

;~ Func _correctFileSpace($file, $mod = 0)
;~ 	if FileExists($file) then return $file
;~ 	$aFilePatch = StringSplit($file,'\')
;~ 	$ThisFilePatch = ''
;~ 	for $i=1 to $aFilePatch[0]
;~ 		$ThisFilePatch &= $aFilePatch[$i]
;~ 		if not FileExists($aFilePatch[$i]) Then
;~ 			$aFilePatch[$i] = StringReplace ( $aFilePatch[$i], " ", "",1)
;~ 			if @error then return


;~ EndFunc

;~ Func _CorrectSpace($text)

Exit


While 1
	ConsoleWrite(@HOUR&':'&@MIN&':'&@SEC&' - '&Ping('192.168.8.1')&' _' & @extended & @CRLF)
	sleep(1000)
WEnd


;Переворачивание каждой строки
$string = ClipGet()
$array=StringSplit(StringReplace($string,@CRLF,@LF),@CRLF)
For $i=1 to $array[0]
	$letters = StringSplit($array[$i],'')
	$array[$i]=''
	For $j=$letters[0] to 1 step -1
		$array[$i] &= $letters[$j]
	Next
Next
$return = ''
For $i=1 to $array[0]
	$return &= $array[$i] & @CRLF
Next

ClipPut($return)
exit

$PID1 = 'crome.exe' ;Название процеса
;run($PID) ;запускаем блокнот
;ProcessWait($PID) ;ждём появдение процеса
$Mem = MemGetStats() ;Узнаём о памяти процеса
MsgBox(0, 'PID', $Mem[5] / 1024 & ' Kб')
exit
;~ IsNumber ( variable )
$pid='6'
if $pid>0 Then ConsoleWrite(12341234234324)
exit

$string = ''
$astring = StringSplit(ClipGet(),"")

Func _SendConvert($string)
	Opt("SendKeyDelay", 32)             ;5 миллисекунд
	Opt("SendKeyDownDelay", 8)     ;1 миллисекунда
	$astring = StringSplit($string,"")
	For $i=1 to $astring[0]
		Switch $astring[$i]
			Case ' '
				$string &= '{SPACE}'
			Case '.'
				$string &= '{NUMPADDOT}'
			Case '/'
				$string &= '{NUMPADDIV}'
			Case ':'
				$string &= '{ASC 058}'
			Case Else
				$string &= '{' & $astring[$i] & '}'
		EndSwitch
	Next
	return $string
EndFunc
Send($string)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $string = ' & $string & @CRLF) ;### Debug Console
exit

;~ #include <Process.au3>
#include <Array.au3>

$t = ProcessList ("iexplore.exe" )
_ArrayDisplay($t)
for $i=1 to $t[0][0]
	$iParent_ProcID = _ProcessGetParent($t[$i][1]) ; PID родительсого процесса
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iParent_ProcID = ' & $iParent_ProcID & @CRLF) ;### Debug Console
Next
$iParent_ProcID = _ProcessGetParent(@AutoItPID) ; PID родительсого процесса
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @AutoItPID = ' & @AutoItPID & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iParent_ProcID = ' & $iParent_ProcID & @CRLF) ;### Debug Console
$sParent_ProcID_Path = _ProcessGetPath($iParent_ProcID) ; Полный адрес исполняемоего файла родительсого процесса
$sParent_ProcID_Disc_Path = StringLeft($sParent_ProcID_Path, 3) ; Диск, на котором расположен исполняемый файл родительсого процесса
$sParent_ProcID_Disc_Type = DriveGetType($sParent_ProcID_Disc_Path) ; Тип диска, на котором расположен исполняемый файл родительсого процесса
$sParent_ProcID_Disc_Name = DriveGetLabel($sParent_ProcID_Disc_Path) ; Название диска, на котором расположен исполняемый файл родительсого процесса

MsgBox(64,  'Родительский процесс', _
            'PID:'  & @TAB & @TAB & $iParent_ProcID & @CRLF & _
            'Путь:' & @TAB & @TAB & $sParent_ProcID_Path & @CRLF & _
            'Диск:' & @TAB & @TAB & $sParent_ProcID_Disc_Path & @CRLF & _
            'Тип диска:' & @TAB & $sParent_ProcID_Disc_Type & @CRLF & _
            'Название диска:' & @TAB & $sParent_ProcID_Disc_Name)
 exit
;=================================================================
; Function Name:    _ProcessGetParent()
;
; Description:      Retrieve parent process for a child process
;
; Parameter(s):     $i_pid: The process identifier of the process you want to get the parent
;                       process identifier for
;
; Return Value(s):
;                 On Success:
;                   Parent PID (process identifier)
;
;                 On Failure:
;                   PID of process passed (Check @error to make sure it is a parent and didn't
;                       fail)
;
;                 @Error:
;                   (1): CreateToolhelp32Snapshot failed
;                   (2): Process32First failed
;
; Remark(s):        Tested on Windows XP SP2
;
; Author(s):        SmOke_N (Ron Nielsen)
;
;==========================================================================
Func _ProcessGetParent($i_Pid)
    Local Const $TH32CS_SNAPPROCESS = 0x00000002

    Local $a_tool_help = DllCall("Kernel32.dll", "long", "CreateToolhelp32Snapshot", "int", $TH32CS_SNAPPROCESS, "int", 0)
    If IsArray($a_tool_help) = 0 Or $a_tool_help[0] = -1 Then Return SetError(1, 0, $i_Pid)

    Local $tagPROCESSENTRY32 = DllStructCreate( _
            "dword dwsize;" & _
            "dword cntUsage;" & _
            "dword th32ProcessID;" & _
            "uint th32DefaultHeapID;" & _
            "dword th32ModuleID;" & _
            "dword cntThreads;" & _
            "dword th32ParentProcessID;" & _
            "long pcPriClassBase;" & _
            "dword dwFlags;" & _
            "char szExeFile[260]")

    DllStructSetData($tagPROCESSENTRY32, 1, DllStructGetSize($tagPROCESSENTRY32))

    Local $p_PROCESSENTRY32 = DllStructGetPtr($tagPROCESSENTRY32)

    Local $a_pfirst = DllCall("Kernel32.dll", "int", "Process32First", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
    If IsArray($a_pfirst) = 0 Then Return SetError(2, 0, $i_Pid)

    Local $a_pnext, $i_return = 0

    If DllStructGetData($tagPROCESSENTRY32, "th32ProcessID") = $i_Pid Then
        $i_return = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
        DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])

        If $i_return Then Return $i_return
        Return $i_Pid
    EndIf

    While 1
        $a_pnext = DllCall("Kernel32.dll", "int", "Process32Next", "long", $a_tool_help[0], "ptr", $p_PROCESSENTRY32)
        If IsArray($a_pnext) And $a_pnext[0] = 0 Then ExitLoop
        If DllStructGetData($tagPROCESSENTRY32, "th32ProcessID") = $i_Pid Then
            $i_return = DllStructGetData($tagPROCESSENTRY32, "th32ParentProcessID")
            If $i_return Then ExitLoop
            $i_return = $i_Pid
            ExitLoop
        EndIf
    WEnd

    If $i_return = "" Then $i_return = $i_Pid

    DllCall("Kernel32.dll", "int", "CloseHandle", "long", $a_tool_help[0])
    Return $i_return
EndFunc

;===============================================================================
;
; Function Name:    _ProcessGetPath()
; Description:      Get the executable path of certain process.
;
; Parameter(s):     $vProcess - PID or name of a process.
;
; Requirement(s):   AutoIt v3.2.8.1 or higher.
;                   Kernel32.dll (included with Windows)
;                   Psapi.dll (included with most Windows versions)
;
; Return Value(s):  On Success - Returns full path to the executed process.
;                   On Failure - Returns -1 and sets @Error to:
;                                                               1 - Given process not exists.
;                                                               2 - Error to call Kernel32.dll.
;                                                               3 - Error to open Psapi.dll.
;                                                               4 - Unable to locate path of executed process,
;                                                                   (or can be other error related to DllCall).
;
; Author(s):        G.Sandler (a.k.a CreatoR) - CreatoR's Lab (http://creator-lab.ucoz.ru)
;
;===============================================================================
Func _ProcessGetPath($vProcess)
    Local $iPID = ProcessExists($vProcess)
    If Not $iPID Then Return SetError(1, 0, -1)

    Local $aProc = DllCall('kernel32.dll', 'hwnd', 'OpenProcess', 'int', BitOR(0x0400, 0x0010), 'int', 0, 'int', $iPID)
    If Not IsArray($aProc) Or Not $aProc[0] Then Return SetError(2, 0, -1)

    Local $vStruct = DllStructCreate('int[1024]')

    Local $hPsapi_Dll = DllOpen('Psapi.dll')
    If $hPsapi_Dll = -1 Then $hPsapi_Dll = DllOpen(@SystemDir & '\Psapi.dll')
    If $hPsapi_Dll = -1 Then $hPsapi_Dll = DllOpen(@WindowsDir & '\Psapi.dll')
    If $hPsapi_Dll = -1 Then Return SetError(3, 0, '')

    DllCall($hPsapi_Dll, 'int', 'EnumProcessModules', _
        'hwnd', $aProc[0], _
        'ptr', DllStructGetPtr($vStruct), _
        'int', DllStructGetSize($vStruct), _
        'int_ptr', 0)
    Local $aRet = DllCall($hPsapi_Dll, 'int', 'GetModuleFileNameEx', _
        'hwnd', $aProc[0], _
        'int', DllStructGetData($vStruct, 1), _
        'str', '', _
        'int', 2048)

    DllClose($hPsapi_Dll)

    If Not IsArray($aRet) Or StringLen($aRet[3]) = 0 Then Return SetError(4, 0, '')
    Return $aRet[3]
EndFunc

While 1
$title = 'Домашний медиа-сервер (UPnP, DLNA, HTTP)'
WinActivate($title)
ControlClick($title,'','[CLASS:TcxGridSite; INSTANCE:2]','right',1,	91, 75)
sleep(500)
For $i=1 to 15
Send('{down}')
sleep(12)
next
Send('{right}')
sleep(12)
Send('{enter}')
sleep(12)
sleep(60*60*1000)
wend
;~ Send('{down}')
;~ ControlSend("[CLASS:TCustomActionPopupMenuEx]",'','','{down}')
;~ sleep(100)
;~ ControlSend("[CLASS:TCustomActionPopupMenuEx]",'','','{down}')













