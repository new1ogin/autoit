#include <WinAPI.au3>
#include <WinAPIEx.au3>
   #Include <WinAPIEx.au3>
   #include <Encoding.au3>
   #include <Date.au3>
#include <Misc.au3>
#include <File.au3>
#include <Array.au3>
#include <Zip.au3>


   Global $pidFS,$pid2

   Global $Rus = 0x00000419; Раскладка русского языка
   Global $Eng = 0x00000409; Раскладка английского языка
   Global $Title1, $Full1, $HWnDTextPipe, $sLayoutID, $WM_INPUTLANGCHANGEREQUEST, $aRet, $hWnd
global $schet=0


HotKeySet("{INSERT}", "_start_capture")
HotKeySet("{END}", "Terminate")
;~ HotKeySet("{HOME}","_test")

Func Terminate()
	TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	ProcessClose ( $pidFS )
	ProcessClose ( $pid2 )
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate



_start()

While 1
sleep(100)
WEnd

func _start()

If FileExists(@ProgramFilesDir & "\MacroRecorder\MacroRecorder.exe") Then
	_start_macro_FS_Arch()
else
		If FileExists(@ProgramFilesDir & "\MacroRecorder\MacroRecorder.exe") Then
			msgbox(0,'','ваша операционная система не является 64 битной, и не подходит')
			Exit
		EndIf
	_install_macroRecorder()
	_start()
EndIf
TrayTip("Подсказка", "Программа запущена, можете преступать к работе", 1500)
endfunc

func _test()
	_WinAPI_LoadKeyboardLayoutEx($Eng); переводим раскладку в АНГЛ иначе не будут работать сочетания клавиш
	_SendEx("^"&"R") ;обход залипания клавиш
;~ 		send("^"&"R")
EndFunc


func _start_capture()
	$schet=$schet+1

	if $schet=1 then
		_WinAPI_LoadKeyboardLayoutEx($Eng); переводим раскладку в АНГЛ иначе не будут работать сочетания клавиш
		_SendEx("!"&"{PRINTSCREEN}") ;обход залипания клавиш
		sleep(300)
			_WinAPI_Keybd_Event(0xA2, 0) ;клавиша левый CONTROL
			_WinAPI_Keybd_Event(0x52, 0) ;R
			sleep(64)
			_WinAPI_Keybd_Event(0x52, 2)
			_WinAPI_Keybd_Event(0xA2, 2)
		Else
			_WinAPI_Keybd_Event(0xA2, 0) ;клавиша левый CONTROL
			_WinAPI_Keybd_Event(0x51, 0) ;Q
			sleep(64)
			_WinAPI_Keybd_Event(0x51, 2)
			_WinAPI_Keybd_Event(0xA2, 2)
		_WinAPI_LoadKeyboardLayoutEx($Eng); переводим раскладку в АНГЛ иначе не будут работать сочетания клавиш
		_SendEx("!"&"{PRINTSCREEN}") ;обход залипания клавиш
			_WinAPI_Keybd_Event(0x5B, 0) ;Win
			sleep(64)
			_WinAPI_Keybd_Event(0x5B, 2)
			sleep(64)
		WinActivate($HWnD)
		WinWaitActive($HWnD,'',5)
			_WinAPI_Keybd_Event(0xA2, 0) ;клавиша левый CONTROL
			_WinAPI_Keybd_Event(0x10, 0) ;SHIFT
			_WinAPI_Keybd_Event(0x53, 0) ;S
			sleep(64)
			_WinAPI_Keybd_Event(0x53, 2)
			_WinAPI_Keybd_Event(0x10, 2)
			_WinAPI_Keybd_Event(0xA2, 2)
		$HWnD1=WinWaitActive('Сохранить как','',5)
		ControlSetText ( $HWnD1, "", '[CLASS:Edit; INSTANCE:1]', @DesktopDir&"\для ПБ скриншоты\"&@MDAY&'-'&@HOUR&'-'&@MIN&'-'&@SEC)
		controlclick ( $HWnD1, "", '[CLASS:Button; INSTANCE:1]')
		WinActivate('Point Blank')
		_SendEx("!"&"{PRINTSCREEN}") ;обход залипания клавиш
			_WinAPI_Keybd_Event(0xA2, 0) ;клавиша левый CONTROL
			_WinAPI_Keybd_Event(0x52, 0) ;R
			sleep(64)
			_WinAPI_Keybd_Event(0x52, 2)
			_WinAPI_Keybd_Event(0xA2, 2)
	EndIf


EndFunc



Func _install_macroRecorder()

	$pid=run("MacroRecorderSetup.exe")
	WinWait("Setup - Macro Recorder",'',5)
		$handle = WinGetHandle("Setup - Macro Recorder")
	;~ $handle=WinWait("Setup - Macro Recorder",'',5)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $handle = ' & $handle & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
	;~ $handle = _GetHwnd($pid)
	;~ $handle=_WinAPI_EnumProcessWindows($pid)
	;~ TrayTip('',$handle,500)
	;~ WinWaitActive("Setup - Macro Recorder")
	;~ winactivate ($handle)
	sleep(1000)

	ControlFocus($handle,'','')
	ControlClick($handle,'&Next >','','main',1,	39, 11)
	sleep(200)
	ControlClick($handle,'','[CLASS:TNewRadioButton; INSTANCE:1]','main')
	sleep(300)
	;~ ControlClick($handle,'&Next >','','main',1,	39, 11)
	ControlClick($handle,'','[CLASS:TNewButton; INSTANCE:2]','main')
	sleep(200)
	ControlClick($handle,'&Next >','','main',1,	39, 11)
	ControlClick($handle,'','[CLASS:TNewButton; INSTANCE:3]','main')
	sleep(2000)
	;~ ControlClick($handle,'&Finish','','main',1,	39, 11)
	ControlClick($handle,'','[CLASS:TNewButton; INSTANCE:3]','main')
	sleep(1000)
	AutoItSetOption("WinTitleMatchMode",1)
	WinWait("Jitbit Macro Recorder",'',5)
	if @error then
	run('%PROGRAMFILES(x86)%\MacroRecorder\MacroRecorder.exe')
	WinWait("Jitbit Macro Recorder",'',5)
	EndIf

	$Title1 = 'Jitbit Macro Recorder' ; The Name Of The Game...
	$Full1 = WinGetTitle ($Title1) ; Get The Full Title..
	$HWnD1 = WinGetHandle ($Full1) ; Get The Handle

	ControlFocus($HWnD1,'','')
	ControlSend ( $HWnD1, "", '', "{TAB}" )
	sleep(50)
	ControlSend ( $HWnD1, "", '', "{TAB}" )
	sleep(50)
	ControlSend ( $HWnD1, "", '', "NiCkkkDoN" )
	sleep(50)
	ControlSend ( $HWnD1, "", '', "{TAB}" )
	sleep(50)
	ControlSend ( $HWnD1, "", '', "1434-6374-6424-1504" )
	sleep(50)
	ControlSend ( $HWnD1, "", '', "{TAB}" )
	sleep(50)
	ControlSend ( $HWnD1, "", '', "{ENTER}" )
	sleep(50)

	;~ WinGetHandle("[ACTIVE]")
	send("{ENTER}")

	;использовать относительные координаты
	RegWrite('HKEY_CURRENT_USER\SOFTWARE\Jitbit\Macro Recorder','RecordRelativeMouseCoords',"REG_SZ",'True')
	;не показывать стартап экран
	RegWrite('HKEY_CURRENT_USER\SOFTWARE\Jitbit\Macro Recorder','DisableStartupScreen',"REG_SZ",'True')
	;не запрашивать подтверждение на перезапись
	RegWrite('HKEY_CURRENT_USER\SOFTWARE\Jitbit\Macro Recorder','HideRecordingConfimation',"REG_SZ",'True')


EndFunc
;~ sleep(5000)

func _start_macro_FS_Arch()

	;использовать относительные координаты
	RegWrite('HKEY_CURRENT_USER\SOFTWARE\Jitbit\Macro Recorder','RecordRelativeMouseCoords',"REG_SZ",'True')
	;не показывать стартап экран
	RegWrite('HKEY_CURRENT_USER\SOFTWARE\Jitbit\Macro Recorder','DisableStartupScreen',"REG_SZ",'True')
	;не запрашивать подтверждение на перезапись
	RegWrite('HKEY_CURRENT_USER\SOFTWARE\Jitbit\Macro Recorder','HideRecordingConfimation',"REG_SZ",'True')

$pid2=Run(@ProgramFilesDir & "\MacroRecorder\MacroRecorder.exe",'',@SW_MINIMIZE)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $pid2 = ' & $pid2 & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
;~ run(@ProgramFilesDir & "\MacroRecorder\MacroRecorder.exe")
	WinWait("Macro Recorder",'',5)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinWait("Macro Recorder",'''',5) = ' & WinWait("Macro Recorder",'',5) & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console
	if @error then
	run(@ProgramFilesDir & "\MacroRecorder\MacroRecorder.exe")
	WinWait("Macro Recorder",'',5)
	EndIf
AutoItSetOption("WinTitleMatchMode",1)
$Title = 'Macro Recorder' ; The Name Of The Game...
$Full = WinGetTitle ($Title) ; Get The Full Title..
$HWnD = WinGetHandle ($Full) ; Get The Handle
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $HWnD = ' & $HWnD & @crlf & '>Error code: ' & @error & @crlf) ;### Debug Console

If FileExists(@DesktopDir&"\для ПБ скриншоты\") Then
	$pidFS=Run ("FSCapture.exe -Silent")
else
	DirCreate ( @DesktopDir&"\для ПБ скриншоты\")
	$pidFS=Run ("FSCapture.exe -Silent")
endif

$nameArchive=@DesktopDir&"\для ПБ скриншоты\" & @MDAY&'-'&@HOUR&'-'&@MIN&'-'&@SEC& ".zip"
$filetoarchive=@DesktopDir&"\для ПБ скриншоты"
_archive_and_delite($nameArchive,$filetoarchive)

endfunc


func _archive_and_delite($nameArchive,$filetoarchive)

$nameArchive=@DesktopDir&"\для ПБ скриншоты\" & @MDAY&'-'&@HOUR&'-'&@MIN&'-'&@SEC& ".zip"
$zip=_Zip_Create($nameArchive)
$arrayFile=_FileListToArray($filetoarchive,'*',1)
For $a=1 To $arrayFile[0]
    If $arrayFile[$a] <> @ScriptName AND _FileGetExt($arrayFile[$a]) <> ".zip" Then _Zip_AddFile($zip,@DesktopDir&"\для ПБ скриншоты\"&$arrayFile[$a])
	if not @error AND _FileGetExt($arrayFile[$a]) <> ".zip" AND $arrayFile[$a] <> @ScriptName then FileDelete(@DesktopDir&"\для ПБ скриншоты\"&$arrayFile[$a])
Next

EndFunc







Func _FileGetExt($sPath)
    Local $NULL, $sExt
    _PathSplit($sPath, $NULL, $NULL, $NULL, $sExt)
    Return $sExt
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

	EndFunc

Func _SendEx($sSend_Data)
    Local $hUser32DllOpen = DllOpen("User32.dll")

    While _IsPressed("10", $hUser32DllOpen) Or _IsPressed("11", $hUser32DllOpen) Or _IsPressed("12", $hUser32DllOpen)
        Sleep(10)
    WEnd

    Send($sSend_Data)

    DllClose($hUser32DllOpen)
EndFunc
