#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=Загрузка обновлений Антивирусов(d120).exe
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#RequireAdmin ;это для семерки, в XP не надо
#include <7Zip.au3>
$sPathTo = @TempDir & '\7-zip32.dll'
$sPathTo64 = @TempDir & '\7-zip64.dll'
FileInstall('7-zip32.dll', $sPathTo, 1)
FileInstall('7-zip64.dll', $sPathTo64, 1)
_7ZipStartup()
#Include <INet.au3> ;Подключаем библиотеку
#include <array.au3>
#include <Date.au3>
#include <File.au3>
#include <WinAPI.au3>

;Получение настроек
$sleep = _GetParamsOfFileName('delay', 'd', "15") ;Получения значения задержки из имени файла
;~ sleep($sleep*1000)
$server = _GetParamsOfFileName('server', 's', "0") ;Получения значения тихого(серверного) режима из имени файла
global $SwitchSfxNeed=0

;Определение папки для загрузки
If FileExists("\\server2003\Distrib\Antivirus\eset_upd\") Then
	$folder = '\\server2003\Distrib\Antivirus\eset_upd\'
Else
	$folder = @DesktopCommonDir & '\'
EndIf

; чтение имеющегося архива с обновлениями
$ArchivList = ''
$aArchivList = ''

if FileExists($folder&'AllUpdates4Main'&'_'&_NowDate()&'.7z') then
	$aArchivList = _7ZipGetFilesList(0, $folder&'AllUpdates4Main'&'_'&_NowDate()&'.7z')
;~ 	_ArrayDisplay($aArchivList)
	if Ubound($aArchivList) > 1 then
		for $i=1 to $aArchivList[0][0]
			$ArchivList &= $aArchivList[$i][0] & '|'
		Next
	EndIf
EndIf
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ArchivList = ' & $ArchivList & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$timerText= Timerinit()


;загрузка файла обновления с оффициального сайта НОД32
$url = 'http://'&'download.eset.com/download/engine/eav/offline_update_eav.zip'
$name = _PathSplitByRegExp($url)
if not FileExists($folder&'offline_update_eav_'&_NowDate()&'.zip') then
	;Получение ссылки с триальными ключами
	$HTML = _INetGetSource('http://trial-nod32-keys.ru/')
	$site2 = StringRegExp($HTML,'http://trial-nod32-keys.ru/news/([0-9-]*?)"',3)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($site2) = ' & Ubound($site2) & @CRLF) ;### Debug Console
	_ArraySort($site2,1)
	for $i=0 to Ubound($site2)-1
		if StringLen($site2[$i])>12 and StringLen($site2[$i])<16 then
			$site2=$site2[$i]
			ExitLoop
		EndIf
	Next

	;загрузка триальных ключей
	$HTML = _INetGetSource('http://trial-nod32-keys.ru/news/'&$site2)
	$LogPass = StringRegExp($HTML,'(TRIAL-[0-9]{10})</div><div>.*?([a-z0-9]{10})',3)
	$url = 'http://'&$LogPass[(Ubound($LogPass)-1)-1]&':'&$LogPass[(Ubound($LogPass)-1)]&'@download.eset.com/download/engine/eav/offline_update_eav.zip'
	$name = _PathSplitByRegExp($url)

	for $i=Ubound($LogPass)-1 to 0 Step -2
		$url = 'http://'&$LogPass[$i-1]&':'&$LogPass[$i]&'@download.eset.com/download/engine/eav/offline_update_eav.zip'
		$name = _PathSplitByRegExp($url)
		$timeDownload = TimerInit()
		$Download = _DownloadBase($url,$name)
		if @error <> 0 or $Download=0 Then
		Else
			ExitLoop
		EndIf
	Next
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timeDownload) = ' & TimerDiff($timeDownload) & @CRLF & '$url = ' & $url & @CRLF) ;### Debug Console
EndIf
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerText) = ' & TimerDiff($timerText) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
_DeleteOldFiles($folder,$name[6] & '_' & "*." & $name[7] ,2) ;Удаление лишних файлов
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerText) = ' & TimerDiff($timerText) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;Добовление обновлений в архив
$ArchivateNod=1
if Ubound($aArchivList) > 1 then
	for $i=1 to $aArchivList[0][0]
		if StringInStr($aArchivList[$i][0],'update.ver') > 0 Then
			if StringInStr($aArchivList[$i][3] ,StringReplace(_NowDate(),'.','/')) > 0 Then
				$ArchivateNod=0
			EndIf
		EndIf
	Next
EndIf
if $ArchivateNod=1 Then
	; распаковка Обновления НОД32
	$ArcFile = $folder&$name[6]&'_'&_NowDate()&'.'&$name[7]
	$Output = $folder&'eset_upd\'
	$retResult = _7ZIPExtract(0, $ArcFile, $Output, 1)
	;Создание общего архива обновлений
	_Archivate($folder&'eset_upd',$folder) ;Создание общего архива обновлений
EndIf
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerText) = ' & TimerDiff($timerText) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;загрузка обновлений антивируса Microsoft security essentials x32
$url = 'http://security.tom.ru/av/mpam-fe.exe'
$name = _PathSplitByRegExp($url)
if ping('security.tom.ru') = 0 then $url = _SwitchURL($name[6])
$timeDownload = TimerInit()
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerText) = ' & TimerDiff($timerText) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
if not FileExists($folder&$name[6]&'_'&_NowDate()&'.'&$name[7]) then
	$DownloadBase = _DownloadBase($url,$name)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $DownloadBase = ' & $DownloadBase & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timeDownload) = ' & TimerDiff($timeDownload) & '   ' & '$url = ' & $url & @CRLF) ;### Debug Console
EndIf
;Добовление обновлений в архив
if StringInStr($ArchivList,$name[6]&'_'&_NowDate()&'.'&$name[7]) < 1 and FileExists($folder&$name[6]&'_'&_NowDate()&'.'&$name[7]) Then
	FileMove ( $folder&$name[6]&'_'&_NowDate()&'.'&$name[7], $folder&'eset_upd\'&$name[6]&'_'&_NowDate()&'.'&$name[7], 1)
	_Archivate($folder&'eset_upd\'&$name[6]&'_'&_NowDate()&'.'&$name[7],$folder) ;Создание общего архива обновлений
	FileMove ( $folder&'eset_upd\'&$name[6]&'_'&_NowDate()&'.'&$name[7], $folder&$name[6]&'_'&_NowDate()&'.'&$name[7], 1)
EndIf
_DeleteOldFiles($folder,$name[6] & '_' & "*." & $name[7] ,2) ;Удаление лишних файлов

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerText) = ' & TimerDiff($timerText) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;загрузка обновлений антивируса Microsoft security essentials x64
$url = 'http://security.tom.ru/av/mpam-fex64.exe'
$name = _PathSplitByRegExp($url)
if ping('security.tom.ru') = 0 then $url = _SwitchURL($name[6])
$timeDownload = TimerInit()
if not FileExists($folder&$name[6]&'_'&_NowDate()&'.'&$name[7]) then
	_DownloadBase($url,$name)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timeDownload) = ' & TimerDiff($timeDownload) & '   ' & '$url = ' & $url & @CRLF) ;### Debug Console
EndIf
;Добовление обновлений в архив
if StringInStr($ArchivList,$name[6]&'_'&_NowDate()&'.'&$name[7]) < 1 and FileExists($folder&$name[6]&'_'&_NowDate()&'.'&$name[7]) Then
	FileMove ( $folder&$name[6]&'_'&_NowDate()&'.'&$name[7], $folder&'eset_upd\'&$name[6]&'_'&_NowDate()&'.'&$name[7], 1)
	_Archivate($folder&'eset_upd\'&$name[6]&'_'&_NowDate()&'.'&$name[7],$folder) ;Создание общего архива обновлений
	FileMove ( $folder&'eset_upd\'&$name[6]&'_'&_NowDate()&'.'&$name[7], $folder&$name[6]&'_'&_NowDate()&'.'&$name[7], 1)
EndIf
_DeleteOldFiles($folder,$name[6] & '_' & "*." & $name[7] ,2) ;Удаление лишних файлов

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerText) = ' & TimerDiff($timerText) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;загрузка обновлений антивируса avast! Free Antivirus 2014
$url = 'http://security.tom.ru/av/vpsupd9x.exe'
$name = _PathSplitByRegExp($url)
if ping('security.tom.ru') = 0 then $url = _SwitchURL($name[6])
$timeDownload = TimerInit()
if not FileExists($folder&$name[6]&'_'&_NowDate()&'.'&$name[7]) then
	_DownloadBase($url,$name)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timeDownload) = ' & TimerDiff($timeDownload) & '   ' & '$url = ' & $url & @CRLF) ;### Debug Console
EndIf
;Добовление обновлений в архив
if StringInStr($ArchivList,$name[6]&'_'&_NowDate()&'.'&$name[7]) < 1 and FileExists($folder&$name[6]&'_'&_NowDate()&'.'&$name[7]) Then
	FileMove ( $folder&$name[6]&'_'&_NowDate()&'.'&$name[7], $folder&'eset_upd\'&$name[6]&'_'&_NowDate()&'.'&$name[7], 1)
	_Archivate($folder&'eset_upd\'&$name[6]&'_'&_NowDate()&'.'&$name[7],$folder) ;Создание общего архива обновлений
	FileMove ( $folder&'eset_upd\'&$name[6]&'_'&_NowDate()&'.'&$name[7], $folder&$name[6]&'_'&_NowDate()&'.'&$name[7], 1)
EndIf
_DeleteOldFiles($folder,$name[6] & '_' & "*." & $name[7] ,2) ;Удаление лишних файлов

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerText) = ' & TimerDiff($timerText) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;создание настроек для самораспаковывающегося архива
$config = ';!@Install@!UTF-8!' & @CRLF & 'InstallPath="\\\\main\\backup\\eset_upd"' & @CRLF & 'FinishMessage="Обновление антивирусов успешно распаковано!"' & @CRLF & ';!@InstallEnd@!'
if FileExists($folder&'config.txt') then FileDelete($folder&'config.txt')
$hFile = FileOpen ( $folder&'config.txt' ,138)
FileWrite ( $folder&'config.txt', $config )
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerText) = ' & TimerDiff($timerText) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;создание самораспаковывающегося файла
if $SwitchSfxNeed = 1 or not FileExists($folder&'AllUpdates4Main.exe') or _WinAPI_GetFileSizeEx($hFile) < 1048576 Then
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _WinAPI_GetFileSizeEx($hFile) = ' & _WinAPI_GetFileSizeEx($hFile) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileExists($folder&''AllUpdates4Main.exe'') = ' & FileExists($folder&'AllUpdates4Main.exe') & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $folder&''AllUpdates4Main.exe'' = ' & $folder&'AllUpdates4Main.exe' & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileExists($folder&''AllUpdates4Main''&_NowDate()&''.7z) = ' & FileExists($folder&'AllUpdates4Main'&_NowDate()&'.7z') & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $folder&''AllUpdates4Main''&_NowDate()&''.7z'' = ' & $folder&'AllUpdates4Main'&_NowDate()&'.7z' & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	$timerSFXCreat = TimerInit()
	FileDelete($folder&'AllUpdates4Main.exe')
	Run(@ComSpec & " /c " & 'COPY /b '&$folder&'7zsd_LZMA.sfx + '& _
	$folder&'config.txt + '&$folder&'AllUpdates4Main'&'_'&_NowDate()&'.7z '&$folder&'AllUpdates4Main.exe', _
	"", @SW_HIDE)
	FileExists($folder&'AllUpdates4Main.exe')
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerSFXCreat) = ' & TimerDiff($timerSFXCreat) & '   ' &  @CRLF) ;### Debug Console
EndIf
_DeleteOldFiles($folder,'AllUpdates4Main'&'*'&'.7z' ,1) ;Удаление лишних файлов




; Сообщение-напоминание в понедельник
If _DateToDayOfWeek (@YEAR, @MON, @MDAY) = 2 and $server=0 Then
	run ( "explorer " & $folder)
	sleep(1000)
	msgbox(0,"Сообщение",'Не забудьте обновить свою версию Антивируса ESET NOD32')
EndIf

_7ZipShutdown()
Exit

func _SwitchURL($name)

	Switch $name
		Case 'mpam-fe'
			If Not IsDeclared('swithURLm') Then global $swithURLm=1
		Case 'mpam-fex64'
			If Not IsDeclared('swithURL') Then global $swithURLm64=1
		Case 'vpsupd9x'
			If Not IsDeclared('swithURL') Then global $swithURLv=1
	EndSwitch

	Switch $name
		Case 'mpam-fe' and $swithURLm=1
			$swithURLm+=1
			return 'http://download.microsoft.com/download/DefinitionUpdates/mpam-fe.exe'
		Case 'mpam-fex64' and $swithURLm64=1
			$swithURLm64+=1
			return 'http://download.microsoft.com/download/DefinitionUpdates/mpam-fex64.exe'
		Case 'vpsupd9x' and $swithURLv=1
			$swithURLv+=1
			return 'http://external.comss.ru/url.php?url=http://files.avast.com/ivps9x/vpsupd.exe'
	EndSwitch
	return 0
EndFunc


;Создание общего архива обновлений
Func _Archivate($patch,$folder)
	$timerArchivate = TimerInit()
	if FileExists($patch) <> 1 then Exit
;~ 	$t = FileGetTime($patch)
;~ 	$t =  $t[0] & $t[1] & $t[2] & $t[3] & $t[4] & $t[5]
;~ 	if FileExists($folder&"AllUpdates4Main.7z") then
;~ 		$t2 = FileGetTime($folder&"AllUpdates4Main.7z")
;~ 		$t2 =  $t2[0] & $t2[1] & $t2[2] & $t2[3] & $t2[4] & $t2[5]
;~ 	Else
;~ 		$t2=0
;~ 	EndIf
	if FileExists($folder&'AllUpdates4Main'&'_'&_NowDate()&'.7z') > 0 then
		$SwitchSfxNeed = 1
		$7ZipUpdate = _7ZipUpdate(0, $folder&'AllUpdates4Main'&'_'&_NowDate()&'.7z', $patch, 1)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $7ZipUpdate = ' & $7ZipUpdate & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Else
		$SwitchSfxNeed = 1
		$7ZipAdd = _7ZipAdd(0, $folder&'AllUpdates4Main'&'_'&_NowDate()&'.7z', $patch, 1)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $7ZipAdd = ' & $7ZipAdd & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	EndIf
;~ 	TimerDiff($timerArchivate) &'  '&$patch
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerArchivate) &''  ''&$patch = ' & TimerDiff($timerArchivate) &'  '&$patch & @CRLF) ;### Debug Console
EndFunc


	;Загрузка файлов из интернета
Func _DownloadBase($url,$name=0)
	if $name=0 then $name = _PathSplitByRegExp($url)
	$hDownload = InetGet ( $url, $folder&$name[6]&'_'&_NowDate()&'.'&$name[7],1)
	if @error <> 0 Then
		$Download = 0
	Else
		$Download = 1
	EndIf
	InetClose($hDownload)
	Return $Download
EndFunc

;Удаление лишних файлов
Func _DeleteOldFiles($folder,$mask,$number=2)
	$Filelist = _FileListToArray($folder , $mask, 1)
	_ArraySort($Filelist,0,1)
	if ubound($Filelist) > ($number+1) Then
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($Filelist) = ' & Ubound($Filelist) & @CRLF) ;### Debug Console
		for $i=1 to Ubound($Filelist)-($number+1)
			FileDelete($folder & $Filelist[$i])
		Next
	EndIf
endfunc

 ;Функция получения параметров из имени файла
Func _GetParamsOfFileName($ParamsName, $ParamsShortName = '', $Default = 0, $textMode=0)
	if IsDeclared ('TestFileName') = 0 then local $TestFileName = ''

	Local $ScriptFileName[8], $pDelim = "\", $sPath = @AutoItExe, $params[2]
	$ScriptFileName[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
    $ScriptFileName[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename


	if Stringinstr($ScriptFileName[5],'autoit3.exe')<>0 then $ScriptFileName[6]= $TestFileName

	If $textMode=0 then
		$params = StringRegExp($ScriptFileName[6],'\(.*?' & $ParamsName & '([0-9.]+).*?\)',2)
		if @error then $params = StringRegExp($ScriptFileName[6],'\(' & $ParamsShortName & '([0-9.]+).*?\)',2)
		if @error then $params = StringRegExp($ScriptFileName[6],'\(.*?\d' & $ParamsShortName & '([0-9.]+).*?\)',2)
		if @error then
			Dim $params[2]
			$params[1] = $Default
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Default = ' & $Default & @CRLF) ;### Debug Console
		EndIf
	Else
		$params = StringRegExp($ScriptFileName[6],"(?i)\(.*?" & $ParamsName & "='(.+?)'.*?\)",2)
		if @error then $params = StringRegExp($ScriptFileName[6],"(?i)\(" & $ParamsShortName & "='(.+?)'.*?\)",2)
		if @error then $params = StringRegExp($ScriptFileName[6],"(?i)\(.*?\d" & $ParamsShortName & "='(.+?)'.*?\)",2)
		if @error then
			Dim $params[2]
			$params[1] = $Default
			ConsoleWrite("@@ Debug(" & @ScriptLineNumber & ") : $Default = " & $Default & @CRLF & ">Error code: " & @error & @CRLF) ;### Debug Console
		EndIf
	EndIf


	Return $params[1]
EndFunc

;===============================================================================
; Function Name:    _PathSplitByRegExp()
; Description:      Split the path to 8 elements.
; Parameter(s):     $sPath - Path to split.
; Requirement(s):
; Return Value(s):  On seccess - Array $aRetArray that contain 8 elements:
;                   $aRetArray[0] = Full path ($sPath)
;                   $aRetArray[1] = Drive letter
;                   $aRetArray[2] = Path without FileName and extension
;                   $aRetArray[3] = Full path without File Extension
;                   $aRetArray[4] = Full path without drive letter
;                   $aRetArray[5] = FileName and extension
;                   $aRetArray[6] = Just Filename
;                   $aRetArray[7] = Just Extension of a file
;
;                   On failure - If $sPath not include correct path (the path is not splitable),
;                   then $sPath returned.
;                   If $sPath not include needed delimiters, or it's emty,
;                   then @error set to 1, and returned -1.
;
; Note(s):          The path can include backslash as well (exmp: C:/test/test.zip).
;
; Author(s):        G.Sandler a.k.a CreatoR (MsCreatoR) - Thanks to amel27 for help with RegExp
;===============================================================================
Func _PathSplitByRegExp($sPath)
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8], $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

    $pDelim = "/"

    $aRetArray[0] = $sPath ;Full path
    $aRetArray[1] = StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
    $aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
    $aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
    $aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
    $aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
    $aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
    $aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file

    Return $aRetArray
EndFunc