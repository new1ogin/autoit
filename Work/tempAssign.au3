

$t=0
Dim $a[1]
Assign ( "t", 'data' )
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($t) = ' & Ubound($t) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ IsArray(Eval('t'))
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : IsArray(Eval(''t'')) = ' & IsArray(Eval('t')) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

