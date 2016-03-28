#include <IsPressedEx.au3>
$apm=0
$TimerAPM = TimerInit()
$hU32_DllOpen = DllOpen("User32.dll")
$iRet1 = 0

HotKeySet("{Ins}", "Terminate") ;забиваем клавиши для функций
;~ HotKeySet("{Ins}", "_Pause")
;~ HotKeySet("{Home}", "_Wait_Battle")
Func Terminate() ;функция выхода
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
;~ ProcessClose('Bot_WOT_s.exe')
 DllClose($hU32_DllOpen)
	Sleep(1000)
	Exit 0
EndFunc   ;==>Terminate
; объявляем глобальные переменные, это те которые имеют одно значение во всех функциях
global $Paused
; Функция паузы
Func _Pause()
	$Paused = Not $Paused
	$trayP = 0
	While $Paused
		$trayP += 1
		If $trayP = 1 Then
			TrayTip("Подсказка", "Пауза", 1000)
		EndIf
		Sleep(100)
	WEnd
EndFunc   ;==>_Pause


$aNamesBrowser = 'IEFrame|Chrome|Opera|Firefox|Mozilla|Acoo Browser|Amigo|Safari|Arora|Avant Browser|BlackHawk|Browzar|Chromium|CoolNovo|Coowon|Coowon Browser|Comodo Dragon|Comodo IceDragon|Dooble|DustyNet|Epic Privacy|Epic Privacy Browser|Google Chrome|Goona|Goona Browser|GreenBrowser|Internet Surfboard|K-Meleon|Kylo|Lunascape|Maxthon|Internet Explorer|Microsoft Internet Explorer|Mozilla CometBird|Mozilla Firefox|Mozilla Flock|Mozilla SeaMonkey|Netscape Navigator|NetSurf|Nuke|Orbitum|Orca|Pale Moon|PirateBrowser|PlayFree Browser|QIP Surf|QIP Surf Browser|QtWeb|QtWeb Browser|QupZilla|RockMelt|Slepnir|Slepnir Browser|SlimBrowser|SRWare Iron|Sundance|Sundance Browser|TheWorld|Bundle|Tor Browser Bundle|Torch|Torch Browser|Yandex|YRC Weblink|Browser|Интернет|Одноклассники|Рамблер|Рамблер-Браузер|Нихром|Рамблер Нихром|Хром|Хром от Яндекса'
$aNamesBrowser = StringSplit($aNamesBrowser,'|')


;~ 	While 1
;~ 		$NowWinActive = WinGetHandle('[ACTIVE]')
;~ 		$ClassNowWinActive = WinGetClassList ( $NowWinActive )
;~ 		For $i=0 to Ubound($aNamesBrowser) - 1
;~ 			If StringInStr($ClassNowWinActive,$aNamesBrowser[$i])<>0 Then
;~ 				ConsoleWrite(@HOUR&':'&@MIN&':'&@SEC &'Title = '&WinGetTitle($NowWinActive) & '  Class = ' & $ClassNowWinActive & @CRLF)
;~ 				ExitLoop
;~ 			EndIf
;~ 		Next

;~ 	;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $NowWinActive = ' & $NowWinActive & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		sleep(1000)
;~ 	;~ 	Opt("WinTitleMatchMode", -2)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
;~ 	;~ 	$aWinList = WinList ('Chrome')
;~ 	;~ 	For $i=1 to $aWinList[0][0]
;~ 	;~ 		$ClassNowWinActive = WinGetClassList ( $aWinList[$i][1] )
;~ 	;~ 		ConsoleWrite('@@ Debug(' & $aWinList[$i][0] & ') : $ClassNowWinActive = ' & $ClassNowWinActive & @CRLF) ;### Debug Console
;~ 	;~ 	Next


;~ 	;~ 	Exit

;~ 	WEnd


While 1
	$apm=0
	$TimerAPM = TimerInit()
	$iRet1 = 0
	$timerEAPM = TimerInit()
	While TimerDiff($timerEAPM) < 60000
		$iRet = _IsPressedEx("[:ALLKEYS:]", $hU32_DllOpen)
		If $iRet Then
			If $iret1 <> $iret then
			$apm +=1
			$iRet1 = $iRet
			EndIf
;~ 			ToolTip("eAPM: " & round($APM/(TimerDiff($TimerAPM)/1000/60)),0,0)
			EndIf
		Sleep(50)
	Wend
	ConsoleWrite(@HOUR&':'&@MIN&':'&@SEC &"  eAPM: " & round($APM/(TimerDiff($TimerAPM)/1000/60)) & ' Title = ' & WinGetTitle('[ACTIVE]') & @CRLF)
WEnd




	Opt("WinTitleMatchMode", -2)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
	$aWinList = WinList ('Chrome')
	For $i=1 to $aWinList[0][0]
		$ClassNowWinActive = WinGetClassList ( $aWinList[$i][1] )
		ConsoleWrite('@@ Debug(' & $aWinList[$i][0] & ') : $ClassNowWinActive = ' & $ClassNowWinActive & @CRLF) ;### Debug Console
	Next