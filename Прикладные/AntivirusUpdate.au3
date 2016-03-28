;~ #include <7Zip.au3>
;~ $sPathTo = @TempDir & '\7-zip32.dll'
;~ $sPathTo64 = @TempDir & '\7-zip64.dll'
;~ FileInstall('7-zip32.dll', $sPathTo, 1)
;~ FileInstall('7-zip64.dll', $sPathTo64, 1)
;~ _7ZipStartup()
#RequireAdmin
#Include <INet.au3> ;Подключаем библиотеку
#include <array.au3>
#include <Date.au3>
#include <File.au3>
#include <WinAPI.au3>
#Include <FileOperations.au3>
Opt("WinTitleMatchMode", -1)
$testsleep = 100
$SleepWindow = 1000
$Time4Update = 2 * 60 * 60 * 1000 ; 2часа
$Time4loading = 5 * 60 * 1000 ; 5 минут
; получение Пути до 7zip.exe
$ArchOptions = ' -mmt -ms=off'
$7z = StringReplace(RegRead('HKLM\Software\7-Zip','Path')&'\','\\','\') & '7z.exe'
If $7z = "\7z.exe" Then $7z = StringReplace(RegRead('HKLM64\Software\7-Zip','Path')&'\','\\','\') & '7z.exe'
$ver = StringReplace(FileGetVersion($7z),'.','')
If $ver > 92500 Then $ArchOptions &= ' -sdel'

$afileMvawUpd = _FO_FileSearch ( @DesktopDir, '*mvaw*.exe')
if $afileMvawUpd[0] >0 Then
	$fileMvawUpd = $afileMvawUpd[1]
EndIf

$randstr = ''
For $i=0 to 15
	$randstr &= Chr(Random(97,122,1))
Next
$tempDir = @TempDir & '\' & 'Random_autoit\' ; StringTrimRight(_TempFile(@TempDir,'',''),1) & '\'
DirCreate ($tempDir)
;~ $fileMvawUpd =
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $fileMvawUpd = ' & $fileMvawUpd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $tempDir = ' & $tempDir & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;~ $t1 = _Extract($fileMvawUpd,$tempDir)

;~ Run($tempDir & 'mwavscan.exe')

$titleMessage = "[TITLE:Утилита eScan Антивирусный и Антишпионский Сканер; CLASS:#32770]"
$titleLic = "[TITLE:Лицензионное соглашение; CLASS:TMainFrm]"
$titleUpd = "[TITLE:HTTP Update; CLASS:TFDownload]"
$titleEndUpd = "[TITLE:Update; CLASS:#32770]"
$titleFrm = "[TITLE:FrmMWAVL; CLASS:TFrmMWAVL]"
$titleMVAW = "Утилита eScan Антивирусный и Антишпионский Сканер ("

; Ждем загрузки приложения и отвечаем на сопутствующие вопросы
$TimerLoading = TimerInit()
While TimerDiff($TimerLoading) < $Time4loading
	if Winexists($titleMessage) Then
		WinActivate($titleMessage)
		ControlClick($titleMessage, '', '[CLASS:Button; INSTANCE:1]')
	EndIf
	if Winexists($titleLic) Then
		WinActivate($titleLic)
		ControlClick($titleLic, '', '[CLASS:TRadioButton; INSTANCE:2]')
		sleep($testsleep)
		ControlClick($titleLic, '', '[CLASS:TButton; INSTANCE:2]')
	EndIf
	If WinExists($titleMVAW) Then exitloop
	sleep(100)
WEnd

; Нажимаем кнопку обновить в окне MVAW
WinWait($titleMVAW,'',10)
$hwndMVAW = WinGetHandle($titleMVAW)
WinActivate($hwndMVAW)
$t2=ControlClick($hwndMVAW,'','[CLASS:Button; INSTANCE:23]',"left",1)


; ожидание завершения обновления
MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & 'ожидание завершения обновления' & @CRLF & @CRLF & 'Return:' & @CRLF ) ;### Debug MSGBOX
$TimerUpdate = TimerInit()
While WinExists($titleUpd)
	sleep(1000)
	if TimerDiff($TimerUpdate) > $Time4Update Then
		MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & 'TimerDiff($TimerUpdate)' & @CRLF & @CRLF & 'Return:' & @CRLF & TimerDiff($TimerUpdate)) ;### Debug MSGBOX
		exitloop
	EndIf
	if WinExists($titleEndUpd) Then
		MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & 'WinExists($titleEndUpd)' & @CRLF & @CRLF & 'Return:' & @CRLF & WinExists($titleEndUpd)) ;### Debug MSGBOX
		ExitLoop
	EndIf
WEnd

;закрываем окно "Обновление успешно"
MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & 'закрываем окно "Обновление успешно"' & @CRLF & @CRLF & 'Return:' & @CRLF ) ;### Debug MSGBOX
WinWait($titleEndUpd,'',10)
WinActivate($titleEndUpd)
ControlClick($titleEndUpd,'','[CLASS:Button; INSTANCE:1]')
WinWait($titleEndUpd,'',10)
WinActivate($titleEndUpd)
ControlClick($titleEndUpd,'','[CLASS:Button; INSTANCE:1]')

;Закрываем
Sleep($SleepWindow)
Winclose($titleMVAW)
Sleep($SleepWindow)
if WinExists($titleFrm) Then ; Закрываем фрейм вылезщий после закрытия
	WinClose($titleFrm)
EndIf
Sleep($SleepWindow)
ProcessClose('mwavscan.exe')

;Удаляем лишнее
_DirDelete($tempDir & 'AVCBack')
_DirDelete($tempDir & 'FtpTemp')
_DirDelete($tempDir & 'FtpTempF')
_DirDelete($tempDir & 'LOCK')
_DirDelete($tempDir & 'Log')
_DirDelete($tempDir & 'TEMP')
_DirDelete($tempDir & 'TempBK')
$afilebac = _FO_FileSearch ( $tempDir, 'BACKUP.*')
For $i=1 to $afilebac[0]
	FileDelete($afilebac[$i])
Next

; сжимаем


; Создаем SFX





Func _Archivate($File,$ArchOptions)
    $err = RunWait('"' & $7z & '" a -mx9 "' & $File & '.7z" "' & $File & '"' & $ArchOptions)
    If $err = 0 AND $ver <= 92500 Then FileDelete($File)
EndFunc

Func _Extract($File,$dir)
	RunWait( $7z & ' x ' & $File, $dir,@SW_HIDE)
;~     $err = RunWait('"' & $7z & '" a -mx9 "' & $File & '.7z" "' & $File & '"' & $ArchOptions)
;~     If $err = 0 AND $ver <= 92500 Then FileDelete($File)
EndFunc

Func _DirDelete($sPath)
    $sTemp = _TempFile(@TempDir, '~', '.bat')
    $sPath = $sPath
    $hFile = FileOpen($sTemp, 2)
    FileWriteLine($hFile, '@echo off')
    FileWriteLine($hFile, ':loop')
    FileWriteLine($hFile, 'del ' & $sPath)
    FileWriteLine($hFile, 'if exist ' & $sPath & ' goto loop')
    FileWriteLine($hFile, 'rd /q /s ' & FileGetShortName($sPath))
    FileWriteLine($hFile, 'del ' & $sTemp)
    FileClose($hFile)
    RunWait($sTemp, @TempDir, @SW_HIDE)
EndFunc   ;==>_ScriptDestroy