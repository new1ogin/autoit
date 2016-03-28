#include <Excel.au3>
#include <Array.au3>
#include<File.au3>
$ExcelProc = ProcessList ( 'EXCEL.EXE' )
if Ubound($ExcelProc)>2 Then
	$tMsg = Msgbox(1,"Возможны ошибки","Обнаружено большое количество процессов Excel, желаете их закрыть перед применением")
	if $tMsg<>2 then
		For $i=1 to Ubound($ExcelProc)-1
			ProcessClose ( $ExcelProc[$i][1] )
		Next
	EndIf
EndIf

;~ $oExcel = _ExcelBookNew() ; Создает новую рабочую книгу Excel
If StringInStr(@OSVersion,'XP')=0 Then
	$DownloadsDir = @UserProfileDir & '\Downloads'
Else
	$DownloadsDir = @UserProfileDir & '\Мои документы\Downloads'
	If not FileExists ( $DownloadsDir ) Then
		if FileExists ( 'D:\Documents and Settings\Преподаватель\Мои документы\Downloads' ) then $DownloadsDir='D:\Documents and Settings\Преподаватель\Мои документы\Downloads'
	EndIf
EndIf
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $DownloadsDir = ' & $DownloadsDir & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

$oEvent = ObjEvent('AutoIt.Error', '_error')
$SearchWord = '310'
$PatchXLS = FileSelectFolder('Выбери директорию с файлами MS Excel', '', 0, $DownloadsDir)
If @error then $PatchXLS = $DownloadsDir
$aPatchXLS = _FileDirList($PatchXLS, "*.xls;*.xlsx", 1, 0, 0)

$ClipPut = ''
For $f=1 to  $aPatchXLS[0]
	$fVisible = 0
	$oExcel = _ExcelBookOpen($PatchXLS & '\' & $aPatchXLS[$f] , $fVisible )
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $PatchXLS' & '\' & '$aPatchXLS[$i] = ' & $PatchXLS & '\' & $aPatchXLS[$f] & @CRLF ) ;### Debug Console
	$aSheets = _ExcelSheetList($oExcel)
	$t7 = _ExcelBookSaveAs($oExcel,@ScriptDir & "\Test.txt",'txt')
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t7 = ' & $t7 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	exit
	If not @error then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : 	$aSheets = ' & 	$aSheets & ') : Ubound($aSheets) = ' & Ubound($aSheets)& @CRLF ) ;### Debug Console
;~ 		_ArrayDisplay($aSheets)
		For $s=1 to $aSheets[0]
			_ExcelSheetActivate($oExcel, $aSheets[$s])
			$timer=TimerInit()
			$aActiveSheet = _ExcelReadSheetToArray($oExcel)
;~ 			$aActiveSheet = _ExcelReadSheetToArray($oExcel,1,1,10,10)
;~ 			_ArrayDisplay($aActiveSheet)
;~ 			exit
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer)  & @CRLF) ;### Debug Console

;~ 	 		_ArraySort($aActiveSheet)
;~ 	 		$iKeyIndex = _ArrayBinarySearch($aActiveSheet, $SearchWord)
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iKeyIndex = ' & $iKeyIndex & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

			Dim $resultSearch[1][2]
			$DimResult=Ubound($resultSearch)
			$timer=TimerInit()
			For $i = 0 To UBound($aActiveSheet) - 1
				For $j = 0 To Ubound($aActiveSheet,2) - 1
					$t4 = StringRegExp( $aActiveSheet[$i][$j], $SearchWord)
					if $t4=1 Then
						$DimResult=Ubound($resultSearch)
						Redim $resultSearch[$DimResult+1][2]
						$resultSearch[$DimResult][0]=$i
						$resultSearch[$DimResult][1]=$j
					EndIf

				Next
			Next
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer)  & @CRLF) ;### Debug Console

			;поиск для Определения строки номера группы
			For $i = 0 To UBound($aActiveSheet) - 1
				For $j = 0 To Ubound($aActiveSheet,2) - 1
					$t4 = StringRegExp( $aActiveSheet[$i][$j], 'группа ')
					if $t4=1 Then
;~ 						$NumberGroupString = 14
						$NumberGroupString = $i
					EndIf

				Next
			Next

;~ 				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($resultSearch) = ' & Ubound($resultSearch) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			For $i=1 to Ubound($resultSearch)-1
				$res =  $aActiveSheet[$resultSearch[$i][0]-1][$resultSearch[$i][1]-1] & '; ' & $aActiveSheet[$resultSearch[$i][0]-1][$resultSearch[$i][1]] & '; ' & $aActiveSheet[$resultSearch[$i][0]][$resultSearch[$i][1]]
				$Predmet = $aActiveSheet[$resultSearch[$i][0]-1][$resultSearch[$i][1]-1]
				$Teacher = $aActiveSheet[$resultSearch[$i][0]-1][$resultSearch[$i][1]]
				$Auditorya = $aActiveSheet[$resultSearch[$i][0]][$resultSearch[$i][1]]
;~ 				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $res = ' & $res & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 				$t5 = _PathSplitByRegExp($aPatchXLS[$f])
;~ 				_ArrayDisplay($t5)
				$fileName = $aPatchXLS[$f]
				$SheetName = $aSheets[$s]
				$NumberGroup = $aActiveSheet[$NumberGroupString][$resultSearch[$i][1]]
				If StringLen($NumberGroup)<2 Then $NumberGroup = $aActiveSheet[$NumberGroupString][$resultSearch[$i][1]-1]
				$DayWeek = $aActiveSheet[$resultSearch[$i][0]][1]
				If StringLen($DayWeek)<2 Then
					For $d=1 to 20
						$DayWeek = $aActiveSheet[$resultSearch[$i][0]-$d][1]
						If StringLen($DayWeek)>=2 Then ExitLoop
					Next
				Endif
				$TimeLesson = $aActiveSheet[$resultSearch[$i][0]][2]
				If StringLen($TimeLesson)<2 Then $TimeLesson = $aActiveSheet[$resultSearch[$i][0]-1][1+1]
				$ClipPut &= $fileName & @TAB & $SheetName & @TAB & $NumberGroup & @TAB & $DayWeek & @TAB & $TimeLesson & @TAB & $res &@CRLF
				$ClipPut &= $fileName & @TAB & $SheetName & @TAB & $NumberGroup & @TAB & $DayWeek & @TAB & $TimeLesson & @TAB & $res &@CRLF
;~ 				$ClipPut &= StringLen($fileName) & @TAB & StringLen($SheetName) & @TAB & StringLen($NumberGroup) & @TAB & StringLen($DayWeek) & @TAB & StringLen($TimeLesson) & @TAB & StringLen($res) & @TAB &$resultSearch[$i][0]&':'&$resultSearch[$i][1] &@CRLF
;~ 				ConsoleWrite($resultSearch[$i][0]&':'&$resultSearch[$i][1]&' - '&$aActiveSheet[$resultSearch[$i][0]][$resultSearch[$i][1]] & @CRLF)

			Next
			ClipPut($ClipPut)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ClipPut($ClipPut) = ' & ClipPut($ClipPut) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			_ArrayDisplay($aActiveSheet)
		Next
	EndIf
	_ExcelBookClose($oExcel)
Next







;~ 	$t1=_ExcelBookSaveAs($oExcel,$PatchXLS & '\' & "\SaveAsExample" ,'xlsx')
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	$t2=_ExcelBookSaveAs($oExcel,$PatchXLS & '\' & "\SaveAsExample" ,51)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t2 = ' & $t2 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;~ 			$sFile = @ScriptDir & "\Test.txt"
;~ 			; Записывает первый массив в файл содержащий строки имён файлов
;~ 			_FileWriteFromArray($sFile, $aActiveSheet)
;~ 			Dim $aSaveSheet[Ubound($aActiveSheet)][Ubound($aActiveSheet,2)]
;~ 			_FileReadToArray($sFile, $aSaveSheet)

;~ 			$timer=TimerInit()
;~ 			_ExcelBookClose($oExcel)
;~ 			; Записываем
;~ 			Dim $Col[Ubound($aActiveSheet,2)]
;~ 			For $i = 0 To Ubound($aActiveSheet,2)-1
;~ 				For $j = 0 To UBound($aActiveSheet) - 1
;~ 					$Col[$i] &= $aActiveSheet[$j][$i] & @TAB
;~ 				Next
;~ 				$Col[$i] = StringTrimRight($Col[$i], 1)
;~ 			Next
;~ 			$WriteText=''
;~ 			For $i=0 to Ubound($Col)-1
;~ 				$WriteText&=$Col[$i] & @CRLF
;~ 			Next
;~ 			$sFile = @ScriptDir & "\Test.txt"
;~ 			$hFile = FileOpen ( $sFile ,2)
;~ 			$t3=FileWrite ( $hFile, $WriteText )
;~ 			FileClose($hFile)
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t3 = ' & $t3 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 			$ColRead = FileRead ( $sFile )
;~ 			$ColRead = StringSplit($ColRead,@CRLF)
;~ 			; Загружаем
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : @TAB = ' & @TAB & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 			$CountColums = Ubound(StringRegExp($ColRead[1], @TAB, 3))
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $CountColums = ' & $CountColums & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 			for $i=0 to Ubound($ColRead)-1
;~ 				$ColRead[$i] = StringSplit($ColRead[$i], @TAB, 2)
;~ 			Next
;~ 			Dim $aSaveSheet[UBound($ColRead)][$CountColums]
;~ 			_ArrayDisplay($ColRead,'$ColRead')
;~ 			_ArrayDisplay($ColRead[1],'$ColRead[1]')
;~ 			For $i = 0 To $CountColums - 1
;~ 				For $j = 0 To UBound($aSaveSheet) - 1
;~ 					$aTemp=$ColRead[$j]
;~ 					$aSaveSheet[$j][$i] = $aTemp[$i]
;~ 				Next
;~ 			Next
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer)  & @CRLF) ;### Debug Console








Func _error()
	ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : __cdo_error() = '  &  @CRLF) ;### Debug Console
	$EmailSendError=2
    $iError = $oEvent.Number
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iError = ' & $iError & @CRLF ) ;### Debug Console
EndFunc



; #FUNCTION# ====================================================================================================
; Name...........:  _FileDirList
; Description....:  Search files and\or folders in a specified path (uses system Dir command)
; Syntax.........:  _FileDirList($sPath [, $sFileMask = "*" [, $iFlag = 0 [, $iSubDir = 1 [, $iSort = 0]]]])
; Parameters.....:  $sPath     - Path to search the file.
;                   $sFileMask - [Optional] Filter to use, default is "*". Search the Autoit3 helpfile for the word "WildCards" For details.
;                   $iFlag     - [Optional] Specifies whether to return files folders or both:
;                                                                                               $iFlag = 0 - Files and folders (default)
;                                                                                               $iFlag = 1 - Only files
;                                                                                               $iFlag = 2 - Only folders
;                   $iSubDir   - [Optional] Specifies whether to search in subfolders or not:
;                                                                                               $iSubDir = 1 - Search in subfolders (default). Returns full pathes.
;                                                                                               $iSubDir = 0 - Search without subfolders (only in $sPath). Returns filenames only.
;                   $iSort     - [Optional] Specifies whether to sort the output list (in alphabetic order) or not (default is 0 - do not sort).
;
; Return values..:  Success    - An array with the following elements:
;                                                                      $aArray[0] = Number of Files\Folders returned
;                                                                      $aArray[1] = 1st File\Folder
;                                                                      $aArray[2] = 2nd File\Folder
;                                                                      $aArray[3] = 3rd File\Folder
;                                                                      $aArray[n] = nth File\Folder
;                   Failure    - 0
;                      @Error:    1 = Path not found or invalid
;                                 2 = No File(s) Found
;
; Author.........:  G.Sandler (CreatoR), amel27.
; Modified.......:
; Remarks........:  This function uses system Dir command, to speed up the search.
; Related........:
; Link...........:
; Example........:
; ===============================================================================================================
Func _FileDirList($sPath, $sFileMask = "*", $iFlag = 0, $iSubDir = 1, $iSort = 0)
    Local $sOutBin, $sOut, $aOut, $aMasks, $sRead, $hDir, $sAttrib, $sFiles

    If Not StringInStr(FileGetAttrib($sPath), "D") Then
        Return SetError(1, 0, 0)
    EndIf

    If $iSubDir = 1 Then
        $sAttrib &= ' /S'
    EndIf

    If $iSort = 1 Then
        $sAttrib &= ' /O:N'
    EndIf

    Switch $iFlag
        Case 1
            $sAttrib &= ' /A-D'
        Case 2
            $sAttrib &= ' /AD'
        Case Else
            $sAttrib &= ' /A'
    EndSwitch

    $sOut = StringToBinary('0' & @CRLF, 2)
    $sPath = StringRegExpReplace($sPath, '\\+$', '')
    $sFileMask = StringRegExpReplace($sFileMask, '^;+|;+$', '')
    $sFileMask = StringRegExpReplace($sFileMask, ';{2,}', ';')
    $aMasks = StringSplit($sFileMask, ';')

    For $i = 1 To $aMasks[0]
        If StringStripWS($aMasks[$i], 8) = "" Then
            ContinueLoop
        EndIf

        $sFiles &= '"' & $sPath & '\' & $aMasks[$i] & '"'

        If $i < $aMasks[0] Then
            $sFiles &= ';'
        EndIf
    Next

    $hDir = Run(@ComSpec & ' /U /C DIR ' & $sFiles & ' /B' & $sAttrib, @SystemDir, @SW_HIDE, 6)

    While ProcessExists($hDir)
        $sRead = StdoutRead($hDir, False, True)

        If @error Then
            ExitLoop
        EndIf

        If $sRead <> "" Then
            $sOut &= $sRead
        EndIf
    Wend

    $aOut = StringRegExp(BinaryToString($sOut, 2), '[^\r\n]+', 3)

    If @error Or UBound($aOut) < 2 Then
        Return SetError(2, 0, 0)
    EndIf

    $aOut[0] = UBound($aOut)-1
    Return $aOut
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