#include<IE.au3>
#include <INet.au3>
#include <array.au3>
;~ #include <IE2.au3>
HotKeySet("{F7}", "Terminate")
Func Terminate()
	Exit
EndFunc   ;==>Terminate
local $t2[2]
global $ie9 = 0, $ie9Save = '[TITLE:Windows Internet Explorer; CLASS:#32770]'
$sUrl = 'https://www.megaindex.ru/'

$fileread = FileRead(@ScriptDir&'\Franch_list.txt')
$arraySites = StringSplit($fileread,@CRLF,1)
For $i=$arraySites[0] to 1 step -1 ; $i=$arraySites[0]
	$t2 = StringRegExp($arraySites[$i],'//(.*)',2)
	If @error Then
	   dim $t2[2]
	   $t2[1] = $arraySites[$i]
	EndIf
	ConsoleWrite($i & ' ' & $t2[1] & ' ')
	;~ $Site = StringRegExp($arraySites[$i],'//(.*)',2) ; $Site[1]
	$4MIsite = $t2[1];'garantsoft.com'
	$date = '2015-04-11'
	$sMIsite_URL = 'https://www.megaindex.ru/index.php?region_id=0&tab=siteAnalyze&count=1000&site='&$4MIsite&'&date='&$date&'&count=1000'
	$sMIcsv_URL = 'https://www.megaindex.ru/csv.php?region_id=0&tab=siteAnalyze&count=1000&site='&$4MIsite&'&date='&$date&'&col[1]=1&col[2]=2' & _
	'&col[4]=4&col[18]=18&col[5]=5&col[6]=6&col[7]=7&col[11]=11&col[13]=13&col[9]=9&col[12]=12&col[10]=10&col[14]=14&col[16]=0&col[17]=0&sort=13d'
;~ 	  ConsoleWrite($sMIcsv_URL & @CRLF)
			ConsoleWrite(" Начало " )
			$timeToLoadIE = 15000
			; создание обьекта
			$oIE = _IECreate("about:blank")
			If @error Then Exit 11
			$timerLoad = TimerInit()
			_IENavigate($oIE, $sMIsite_URL, 0) ;переход по ссылке
				Sleep(500)
				$hWnd = _IEPropertyGet($oIE, 'hwnd') ; получение хендела окна
				While _IELoadWait($oIE, 0, 1) = 0 And TimerDiff($timerLoad) < $timeToLoadIE
					Sleep(100)
				WEnd
				sleep(Random(7000,10000))
			_IENavigate($oIE, $sMIcsv_URL, 0) ;переход по ссылке
				Sleep(500)
				While _IELoadWait($oIE, 0, 1) = 0 And TimerDiff($timerLoad) < $timeToLoadIE
					Sleep(100)
				WEnd

	; ожидане начала загрузки файла
	ConsoleWrite(" ожидане  " )
	$waitstartload = TimerInit()
	While TimerDiff($waitstartload) < $timeToLoadIE
		$bar = ControlGetHandle($hWnd, "", "[CLASS:Frame Notification Bar]")
		If $bar And ControlCommand($hWnd, "", $bar, "IsVisible") Then ExitLoop
		if WinExists($ie9Save) Then
			$ie9 = 1
			ExitLoop
		Endif
		sleep(1000)
	WEnd
	if $ie9 = 1 Then
		ControlClick($ie9Save,'','[CLASS:Button; INSTANCE:2]')
	Else
		_SaveChoise($hWnd)
	EndIf

	ConsoleWrite($t2[1] & @CRLF)
	FileWriteLine(@ScriptDir&'\alreadyFiish.txt',$arraySites[$i])
	sleep(2000)
	_IEQuit($oIE)
	WinClose($hWnd)
	sleep(Random(15000,30000))
Next
exit
;~ ConsoleWrite($i&' '& StringLen(_INetGetSource($s_Text_URL)) & @CRLF)
;~ exit
$fileread = FileRead(@ScriptDir&'\data1234.txt')
$arraySites = StringSplit($fileread,@CRLF,1)
;~ $t2 = StringRegExp($t,'//(.*)',2)
$s_Text_URL = 'http://www.liveinternet.ru/stat/udobno43.ru/searches.html'
For $i=350 to $arraySites[0]

	$t2 = StringRegExp($arraySites[$i],'//(.*)',2)
	$s_URL = 'http://www.liveinternet.ru/stat/'&$t2[1]&'/queries.html'
	if StringLen(_INetGetSource($s_URL)) > 10000 Then
		ConsoleWrite($arraySites[$i]& @CRLF)
	EndIf

	if Mod($i, 50) = 0 Then
		ConsoleWrite($i&' '& StringLen(_INetGetSource($s_Text_URL)) & @CRLF)
	EndIf
	sleep(random(100,1000))
Next



;~ For $i=1 to 120
;~ 	; получение списка франчайзи
;~ 	$s_URL = 'http://www.1c.ru/rus/partners/franch-citylist.jsp?reg=&city=&partv8='&$i
;~ 	$sText = _INetGetSource($s_URL)
;~ 	ConsoleWrite(StringLen($sText) & '   ')
;~ 	$a = StringRegExp($sText,'(?s)\Q<!-- </pre> -->\E(.*?)\Q</form>\E',2)
;~ 	$a = StringRegExp($a[1],'<small>(.*?)</small>',3)

;~ 	ConsoleWrite(Ubound($a) & @CRLF)
;~ 	FileWrite ( @ScriptDir&'\data1234.txt', _ArrayToString($a, @CRLF) )

;~ Next

Func _SaveChoise($iehandle)
Opt("SendKeyDelay", 10)
;~ $iehandle = WinGetHandle("[CLASS:IEFrame]")
$delay=500
$a = ControlGetHandle($iehandle, "", "[CLASS:Frame Tab]")
$b = ControlGetHandle($a, "", "[CLASS:TabWindowClass]")
$c = ControlGetHandle($b, "", "[CLASS:Shell DocObject View]")
$iecontrol = ControlGetHandle($c, "", "[CLASS:Internet Explorer_Server]")

ControlSend($iehandle,"",$iecontrol,"{F6}")

sleep($delay)
;Поиск notification bar
$notbar =  ControlGetHandle($iehandle, "", "[CLASS:Frame Notification Bar]")
$notbarcontrol = ControlGetHandle($notbar, "", "[CLASS:DirectUIHWND]")


sleep($delay)
ControlSend($iehandle,"",$notbarcontrol,"{TAB}")
sleep($delay)
ControlSend($iehandle,"",$notbarcontrol,"{ENTER}")


;~ WinWait ("[CLASS:#32768; INSTANCE:1]")
;~ $popup = WinGetHandle("[CLASS:#32768; INSTANCE:1]")
;~ Sleep($delay)
;~ ControlSend("","",$popup,"{DOWN}")
;~ sleep($delay)
;~ ControlSend("","",$popup,"{ENTER}")
EndFunc