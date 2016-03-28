HotKeySet('{f6}','_tt')

While 1
	sleep(50)
WEnd


Func _tt()
	$hwnd = WinGetHandle('[ACTIVE]')
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hwnd = ' & $hwnd & @CRLF) ;### Debug Console
	$cl = WinGetClassList($hwnd)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $cl = ' & $cl & @CRLF) ;### Debug Console
	$ti = WinGetTitle($hwnd)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ti = ' & $ti & @CRLF) ;### Debug Console


EndFunc




