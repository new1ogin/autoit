;~ #include <Excel.au3>
;~ #include <Array.au3>
;~ $timer = Timerinit()

;~ $oExcel = _ExcelBookOpen(@ScriptDir&"\Test.xls",0)

;~ $aExelArray = _ExcelReadSheetToArray($oExcel)
;~ _ExcelBookClose($oExcel,0,0)
;~ TimerDiff($timer)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;~ _ArrayDisplay($aExelArray )


;~ exit





$timer = Timerinit()
Const $adOpenStatic = 3
Const $adLockOptimistic = 3
Const $adCmdText = 0x0001
Global $s_Filename=FileGetShortName(@ScriptDir&"\Test.xls")
Global $s_Tablename = "[Sheet1$]"

; Initialize COM error handler
$oMyError = ObjEvent("AutoIt.Error","MyErrFunc")

; Source XLS data
$objConnection = ObjCreate("ADODB.Connection")
$objRecordSet = ObjCreate("ADODB.Recordset")
$objConnection.Open ("Provider=Microsoft.Jet.OLEDB.4.0;" & _
                "Data Source="&$s_Filename&";" & _
                "Extended Properties=""Excel 8.0;HDR=Yes;"";")
$objRecordSet.Open ("Select Count(*) FROM"& $s_Tablename & "Order by 1 Asc" , $objConnection, $adOpenStatic, $adLockOptimistic, $adCmdText)



Do
    ConsoleWrite ($objRecordSet.Fields(0).value+1 &@CR) ; + 1 because it is 0 based
    $objRecordSet.MoveNext()
Until $objRecordSet.EOF()

ConsoleWrite ($objRecordSet.Add.Worksheets(1) &@CR)

$objConnection.Execute("INSERT INTO [Sheet1$] VALUES ('Nice one', 'Testttt', 'Hi there')")
;~ $oConn.Close()

$objConnection.Close
$objConnection = ""
$objRecordSet = ""

TimerDiff($timer)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


Func MyErrFunc()
$HexNumber=hex($oMyError.number,8)
Msgbox(0,"COM Test","We intercepted a COM Error !" & @CRLF & @CRLF & _
             "err.description is: " & @TAB & $oMyError.description & @CRLF & _
             "err.windescription:" & @TAB & $oMyError.windescription & @CRLF & _
             "err.number is: " & @TAB & $HexNumber & @CRLF & _
             "err.lastdllerror is: " & @TAB & $oMyError.lastdllerror & @CRLF & _
             "err.scriptline is: " & @TAB & $oMyError.scriptline & @CRLF & _
             "err.source is: " & @TAB & $oMyError.source & @CRLF & _
             "err.helpfile is: " & @TAB & $oMyError.helpfile & @CRLF & _
             "err.helpcontext is: " & @TAB & $oMyError.helpcontext _
            )
SetError(1) ; to check for after this function returns
Endfunc