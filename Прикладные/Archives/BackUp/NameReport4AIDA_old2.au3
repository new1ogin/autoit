#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Outfile=\\192.168.0.1\ftp\pub\temp\AIDA64-Business\NameReport4AIDA.exe
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #Include <FTPEx.au3>
#include <File.au3>
#include <array.au3>
#include <Inet.au3>
#include <FileOperations.au3>
Opt("MustDeclareVars", 1)
Global $aFilesFTP[1][6]

local $TimeToWait,$ProcessName,$FileAIDA,$FilePathReports,$FilePathMyDocReports,$FileSendReportsOnFTP,$TimeCompare
local $fileList,$fileListDoc,$fileList2,$fileListDoc2,$PublicIP,$timer,$switch,$sText
local $t,$hwnd,$fileReport

$TimeToWait = 30 * 60 * 1000
$ProcessName = 'aida64.exe'
$FileAIDA = @ScriptDir & '\aida64.exe'
$FilePathReports = @ScriptDir & '\Reports'
$FilePathMyDocReports = @MyDocumentsDir & '\AIDA64 Reports'
$FileSendReportsOnFTP = @ScriptDir & '\SendReportsOnFTP.exe'
$TimeCompare = 5000 ;время сравнения списка файлов отчетов
$Kslp = 1 ;коэффициент задержки на различные действия

Sleep(500*$Kslp)
; проверка на запущенность aida
If Not ProcessExists($ProcessName) Then
	If Not FileExists($FileAIDA) Then _error('Программа AIDA64 не запущена и не найдена в папке программы.')
	Run($FileAIDA)
	Sleep(2000*$Kslp)
EndIf
;создаём массив для проверки новых файлов отчетов
$fileList = _FO_FileSearch($FilePathReports, '*', True, 3)
If IsArray($fileList) And $fileList[0] > 0 Then
	$fileList = $fileList[0]
Else
	$Kslp=2
	sleep(2000*$Kslp)
	$fileList = _FO_FileSearch($FilePathReports, '*', True, 3)
	If IsArray($fileList) And $fileList[0] > 0 Then
		$fileList = $fileList[0]
	Else
		$fileList = 0
	EndIf
EndIf
If FileExists($FilePathMyDocReports) Then
	$fileListDoc = _FO_FileSearch($FilePathMyDocReports, '*', True, 3)
	If IsArray($fileListDoc) And $fileListDoc[0] > 0 Then
		$fileListDoc = $fileListDoc[0]
	Else
		$fileListDoc = 0
	EndIf
EndIf


$PublicIP = _getPublicIP()
$timer = TimerInit()
$switch = 2
$t = 1
While 1

	If Not ProcessExists($ProcessName) Then Exit

	If WinExists('[TITLE:Сохранить отчёт; CLASS:#32770]') Then
		$hwnd = WinGetHandle("[TITLE:Сохранить отчёт; CLASS:#32770]")
;~ 		ConsoleWrite('@@ Debug(' & $switch & ') : $hwnd = ' & $hwnd & @CRLF) ;### Debug Console
		If $switch = 0 Then
			$switch = 1
			$hwnd = WinGetHandle("[TITLE:Сохранить отчёт; CLASS:#32770]")
			WinActivate($hwnd)
			Sleep(200)
			$sText = ControlGetText($hwnd, "", "[CLASS:Edit; INSTANCE:1]")
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sText = ' & $sText & @CRLF) ;### Debug Console
			If $sText = "Report" Then
				$sText = $PublicIP & '_' & @ComputerName & '.htm'
				If StringLen(StringStripWS($sText, 3)) > 1 Then
;~ 				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sText = ' & $sText & @CRLF) ;### Debug Console
					ControlSetText($hwnd, "", "[CLASS:Edit; INSTANCE:1]", $sText)
				Else
					$switch = 0
				EndIf
			EndIf

;~ 			ConsoleWrite($sText & @CRLF)
		EndIf
	Else
		$switch = 0
	EndIf
	;сравнение списка файлов отчетов с начальным
	local $timerDiff = TimerDiff($timer)
	If $timerDiff > $Kslp * $TimeCompare * $t Then
		$t += 1
		$fileList2 = _FO_FileSearch($FilePathReports, '*', True, 3)
		If IsArray($fileList2) And $fileList2[0] > 0 Then
			$fileList2 = $fileList2[0]
		Else
			$fileList2 = 0
		EndIf
		If $fileList2 > $fileList Then
;~ 			TrayTip('Подсказка', $t & '&' & $fileList2 & '&' & $fileList2, 2000)
			RunWait($FileSendReportsOnFTP)
			$fileList = $fileList2
		EndIf

		If FileExists($FilePathMyDocReports) Then
			$fileListDoc2 = _FO_FileSearch($FilePathReports, '*', True, 3)
			If IsArray($fileListDoc2) And $fileListDoc2[0] > 0 Then
				$fileListDoc2 = $fileListDoc2[0]
			Else
				$fileListDoc2 = 0
			EndIf
			If $fileListDoc2 > $fileListDoc Then
;~ 				TrayTip('Подсказка', $t & '&' & $fileListDoc2 & '&' & $fileListDoc2, 2000)
				$fileReport = _GetYoungFile($FilePathMyDocReports)
				RunWait($FileSendReportsOnFTP & ' ' & $FilePathMyDocReports & '\' & $fileReport)
				$fileListDoc = $fileListDoc2
			EndIf
		EndIf

	EndIf
	Sleep(200*$Kslp)
	If $timerDiff > $TimeToWait Then ExitLoop
WEnd

Exit

Func _GetYoungFile($sDir_Where_Search, $DateFormat = 0, $FoldeFile = 1)
	If Not FileExists($sDir_Where_Search) Then Return 0
;~ 	if $sDir_Where_Search='' then $sDir_Where_Search=@WindowsDir&'\System32'

	Local $sYoungest_Folder, $sYoungest_Folder, $sTime, $aTemp
;~ $sFile_To_Write = @ScriptDir & '\Youngest_Folder.txt'
	$sYoungest_Folder = ''
	$sTime = ''

	; получаем список
	$aTemp = _FileListToArray($sDir_Where_Search, '*', $FoldeFile)
	If @error Then Exit 13
	Dim $aDir_and_Time[$aTemp[0] + 1][2] = [[$aTemp[0]]]
	For $i = 1 To $aDir_and_Time[0][0] ;получаем время дату
		$aDir_and_Time[$i][0] = $aTemp[$i]
		$aDir_and_Time[$i][1] = FileGetTime($sDir_Where_Search & '\' & $aTemp[$i], $DateFormat, 1)
	Next
	$aTemp = 0
	_ArraySort($aDir_and_Time, 1, 1, 0, 1) ;сортируем
	_ArrayDisplay($aDir_and_Time)
;~ For $i = 1 To $aDir_and_Time[0][0]
;~     If $aDir_and_Time[$i][1] Then
;~         $sYoungest_Folder = $sDir_Where_Search & '\' & $aDir_and_Time[$i][0]
;~         $sTime = StringRegExpReplace($aDir_and_Time[$i][1], '^(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})', '$1/$2/$3 $4:$5:$6')
;~         ExitLoop
;~     EndIf
;~ Next
	If $aDir_and_Time[0][0] > 0 Then
		Return $aDir_and_Time[1][0]
	Else
		Return 0
	EndIf
EndFunc   ;==>_GetYoungFile

Func _SendPlus($send, $send2 = 0, $key = 0)
	If $key = 0 Then Send('{CTRLDOWN}')
	If $key = 1 Then Send('{SHIFTDOWN}')
	If $key = 2 Then Send('{ALTDOWN}')
	Sleep(64)
	Send($send)
	If $send2 <> 0 Then Send($send)
;~ 	  ControlSend('[CLASS:MozillaWindowClass]', '', '', $send)
;~ 	  if $send2<>0 then ControlSend('[CLASS:MozillaWindowClass]', '', '', $send2)
	Sleep(64)
	If $key = 0 Then Send('{CTRLUP}')
	If $key = 1 Then Send('{SHIFTUP}')
	If $key = 2 Then Send('{ALTUP}')
	Sleep(64)
EndFunc   ;==>_SendPlus

Func _getPublicIP()
	local $xPage,$sPage,$IP_pat
	$xPage = InetRead("http://www.whatismyip.ru")
	$sPage = BinaryToString($xPage)
	$IP_pat = '(?s).+\<font\scolor\=blue\>\<h1\>Ваш\sip\sадрес:\<br\>\n(\d+\.\d+\.\d+\.\d+)\n\</h1\>\</font\>.+'
	Return StringRegExpReplace($sPage, $IP_pat, '\1')
EndFunc   ;==>_getPublicIP


Func _error($text)
	MsgBox(0, "Ошибка помошника отчетов для AIDA64", "Ошибка помошника отчетов для AIDA64:" & @CRLF & $text, 20)
	Exit
EndFunc   ;==>_error

Func _PathSplitByRegExp($sPath, $pDelim = '', $mod = -1)
	If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

	Local $aRetArray[8] ;, $pDelim = ""

	If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
	If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

	If $pDelim = "" Then $pDelim = "/"
	If Not StringInStr($sPath, $pDelim) Then Return $sPath
	If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"
	If $mod >= 0 Then
		Switch $mod
			Case 0
				Return $sPath
			Case 1
				Return StringRegExpReplace($sPath, $pDelim & '.*', $pDelim) ;Drive letter
			Case 2
				Return StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
			Case 3
				Return StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
			Case 4
				Return StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
			Case 5
				Return StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
			Case 6
				Return StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
			Case 7
				Return StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file
		EndSwitch
	EndIf

	$aRetArray[0] = $sPath ;Full path
	$aRetArray[1] = StringRegExpReplace($sPath, $pDelim & '.*', $pDelim) ;Drive letter
	$aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
	$aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
	$aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
	$aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
	$aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
	$aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file

	Return $aRetArray
EndFunc   ;==>_PathSplitByRegExp
