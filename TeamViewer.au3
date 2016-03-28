;~ $dir='D:\temp\Version8'
;~ ShellExecute($dir)
;~ sleep(500)
Run('"D:\temp\Version8\TeamViewer.exe" --noInstallation',"",@SW_HIDE)


WinWaitActive("TeamViewer")
WinWait("TeamViewer")
$hwnd2=WinWaitActive("TeamViewer")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $hwnd2 = ' & $hwnd2 & @CRLF ) ;### Debug Console

;~ sleep(2000)
for $i=0 to 99
WinClose("Компьютеры и контакты")
WinSetState("TeamViewer", "", @SW_MINIMIZE )
$ID=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:2]" )
$password=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:3]" )
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $password = ' & $password & @CRLF ) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ID = ' & $ID & @CRLF ) ;### Debug Console
if StringRegExp ($password,'[0-9]')<>0 then ExitLoop
sleep(10)
Next
WinGetHandle("TeamViewer")
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : WinGetHandle("TeamViewer") = ' & WinGetHandle("TeamViewer") & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
WinSetState("TeamViewer", "", @SW_MINIMIZE )