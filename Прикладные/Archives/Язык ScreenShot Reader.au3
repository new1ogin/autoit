#include <Encoding.au3>
#include <string.au3>

Const $LANG_RUS = 0x0419 ;Русский
Opt("WinTitleMatchMode", -1)   ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
HotKeySet("^{F7}", "Terminate")
HotKeySet("{F7}", "_SendInf")
HotKeySet("{F8}", "_Translate")
;~ HotKeySet("{home}", "_Pause")
$testsleep = 10
Func Terminate()
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate



;~ $sANSI_String = "home sweet home"
;~ $StringToHex = _StringToHex($sANSI_String)
;~ $aStringToHex = Stringsplit($StringToHex,"")
;~ $URLString='https://translate.google.ru/#auto/ru/'
;~ For $i=1 to $aStringToHex[0] step 2
;~ 	$URLString &= '%'&$aStringToHex[$i]&$aStringToHex[$i+1]
;~ Next

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $URLString = ' & $URLString & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;~ ShellExecute('http://autoit-script.ru/')


;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $StringToHex = ' & $StringToHex & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ $sANSI_String = "%E7%BB%A7%E7%BB%AD%E7%A6%BB%E7%BA%BF"
;~ $sUTF8_String = _Encoding_URLToHex($sANSI_String)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sUTF8_String = ' & $sUTF8_String & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ $sUTF8_String = _Encoding_HexToURL($sANSI_String)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sUTF8_String = ' & $sUTF8_String & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ exit

While 1
	sleep(100)

WEnd

Func _Translate()
	$sBuffer = ClipGet()
	$StringToHex = _StringToHex(_Encoding_ANSIToUTF8($sBuffer))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $StringToHex = '   & ($StringToHex) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	$aStringToHex = Stringsplit($StringToHex,"")
	$URLString='https://translate.google.ru/#auto/ru/'
	For $i=1 to $aStringToHex[0] step 2
		$URLString &= '%'&$aStringToHex[$i]&$aStringToHex[$i+1]
	Next
	ShellExecute($URLString)
EndFunc

Func _SendInf()
$title = '[TITLE:ABBYY Screenshot Reader; CLASS:#32770]'
$class = '[CLASS:AWL:2EE50000:80:0:0:0:0; INSTANCE:2]'
$title2 = '[TITLE:Редактор языков; CLASS:#32770]'
$sendtime=100
$minsleep=10
;~ $class = '[CLASS:Button; INSTANCE:1]'
$hwnd = WinGetHandle($title)
WinActivate($hwnd)
Sleep($sendtime)
ControlSend($hwnd,'',$class,'!я')
ControlSend($hwnd,'',$class,'!z')
Sleep($sendtime)
For $i=1 to 7
	ControlSend($hwnd,'',$class,'{down}')
	sleep($minsleep)
Next
ControlSend($hwnd,'',$class,'{Enter}')
WinWait($title2,"",10)
Sleep($sendtime)
WinActivate($title2)
ControlClick($title2,'','[CLASS:Button; INSTANCE:4]')
ControlClick($title2,'','[CLASS:SysTreeView32; INSTANCE:1]','left',1,135, 10)
sleep($minsleep)
ControlSend($title2,'','[CLASS:SysTreeView32; INSTANCE:1]',"Конго")
Sleep($sendtime)
ControlSend($title2,'','[CLASS:SysTreeView32; INSTANCE:1]',"{UP}")
sleep($minsleep)
ControlSend($title2,'','[CLASS:SysTreeView32; INSTANCE:1]',"{Space}")
sleep($minsleep)
ControlSend($title2,'','[CLASS:SysTreeView32; INSTANCE:1]',"{Enter}")
sleep($minsleep)
;~ ControlClick($title,'',$class)
;~ sleep(1000)
;~ ControlClick($hwnd,'',$class,'left',1,135, 10)

;~ sleep(1000)
;~ Send('!я')
Endfunc