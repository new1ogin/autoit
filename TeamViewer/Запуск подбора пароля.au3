#Include <WinAPIEx.au3>
#include <Inet.au3>
#include <File.au3>
#include <log.au3>
#include <array.au3>
HotKeySet("{End}", "Terminate") ;забиваем клавиши для функций
HotKeySet("{Ins}", "_Pause")
Func Terminate() ;функция выхода
TrayTip("Подсказка", "Программа закрыта, Всего хорошего :)", 1500)
	Sleep(1000)
	_EndWindow()
	Exit 0
EndFunc   ;==>Terminate
global $Paused
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
Opt("WinTitleMatchMode", -1)     ;1=с началом, 2=частично, 3=точно, 4=расширено, -1 to -4=Nocase
$SmtpServer = "smtp.mail.ru"    ; адрес SMTP сервера
;~ $Port = "2525"                  ; Порт SMTP сервера
$FromAddress = "teamviewer.print@mail.ru"   ; адрес отправителя
$ToAddress = "new1ogin@mail.ru"     ; адрес назначения
$Subject = """Отчет о Проверке"""    ; тема письма
$Body = """Ошибка, запуск не удался"""    ; тело письма (сам текст письма)
$AttachFiles = '' ; "C:\boot.ini"    ; прикреплённые файлы к письму
$sAttach=''
;~ $Username = "test@mail.ru"      ; имя пользователя аккаунта, с которого отправляется
$Password = "iopTHN1!"               ; Пароль
$sPath_ini=@ScriptDir & "\StartSettings.ini"
global $IDtv ='Не удалось получить ID', $passtv ='Не удалось получить Pаsswоrd',$PublicIP,$PIDtv=0,$EmailSendError=0
Global $iError, $oEvent = ObjEvent('AutoIt.Error', '__cdo_error'), $ReportTcpSend=0, $TrySendEmail,$HandleTVChoise=0
global $VisibleTV=1,$NotCloseTV=0
$TrySendEmail = IniRead($sPath_ini, "User_Settings", "TrySendEmail", "3")
; полуаем путь для поиска исходного архива и имя файла из которого можно извлечь Email\
;~ $sPath = @AutoItExe
;~ $aPathArr = _PathSplitByRegExp($sPath)
;~ $aPathArr = _PathSplitByRegExp($aPathArr[2])
;~ $FileName = _GetFileName($aPathArr[2])
;~ $sPath = _PathSplitByRegExp($NameProcParent)
;~ $FileName = $sPath[6]


$hwnd = WinActivate('[CLASS:#32770]')
$PidPassChanger = 'autoit3.exe'
;~ $PidPassChanger = Run(@ScriptDir & '\Подборпароля.exe')
$SleepWhile = 2*60*1000
$Wait1=0
dim $passtv[2]
_ArrayPush($passtv, _GetPassFast() )

_Proverka()

Sleep(1000*60*5)

_ArrayPush($passtv, _GetPassFast() )
$Body = 'Проверка завершилась неудачей. Последние подобранные пароли: ' & $passtv[0] & ' = ' & $passtv[1]
_SendEmail()
If $passtv[0] <> $passtv[1] then _Proverka()
exit

Func _Proverka()
;Проверка корректности подбора пароля
$schet = 0
While 1
	$schet += 1
	sleep($SleepWhile)
	If ProcessExists ( $PidPassChanger ) = 0 then exitloop
	_ArrayPush($passtv, ControlGetText ( $hwnd, "", "[CLASS:Edit; INSTANCE:3]" ) )
	If $passtv[0] = $passtv[1] then
		If $Wait1=2 then exitloop
		$Body = 'Последние подобранные пароли: ' & $passtv[0] & ' = ' & $passtv[1]
		_SendEmail()
		$Wait1+=1
	Else
		$Wait1=0
	EndIf
	ConsoleWrite(@HOUR&':'&@MIN&' '& 'Проверка продолжается.' & 'Последние подобранные пароли: ' & $passtv[0] & ' = ' & $passtv[1] & @CRLF)
	if $schet =4 Then
		$Body = 'Проверка успешно запущенна. ' & 'Последние подобранные пароли: ' & $passtv[0] & ' = ' & $passtv[1]
		_SendEmail()
	EndIf
WEnd

EndFunc
Func _GetPassFast()
 Return ControlGetText ( $hwnd, "", "[CLASS:Edit; INSTANCE:3]" )
;~  Return 'testpass'
 EndFunc


$hwnd = WinActivate('[CLASS:#32770]')
;~ WinMove($hwnd,'',1980,1080)

$aPosWindow = WinGetPos ( $hwnd )
WinMove($hwnd,'',@DesktopWidth-$aPosWindow[2]/2+100,@DesktopHeight/2-$aPosWindow[3]/2)
;~ exit
$timerEAPM = TimerInit()
Opt("MouseCoordMode", 2)        ;1=абсолютные, 0=относительные, 2=клиентские
;~ ControlClick($hwnd,'','','left',1,211,246)
;~ _EndWindow()
;~ exit
For $i=0 to 10*10000

	MouseClick('left',165,246)
;~ 	sleep(150)
	Send('{DOWN}')
	Send('{ENTER}')
;~ 	sleep(100)
	;~ MouseClick('left',165,246)
	;~ sleep(100)

	MouseClick('left',165,258)
;~ 	MouseMove(165,264,0)
	;~ 165,246
	global $passtv, $PIDtv=0,$NotCloseTV=1, $VisibleTV=1, $HandleTVChoise=0
;~ 	_WaitAndGetPassTV()
	$passtv=ControlGetText ( $hwnd, "", "[CLASS:Edit; INSTANCE:3]" )
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $passtv = ' & $passtv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	ConsoleWrite($passtv & ' ')
	If Mod($i,20)=0 then
		$hwnd = WinActivate('[CLASS:#32770]')
		ConsoleWrite( @CRLF & @HOUR&':'&@MIN&':'&@SEC &" ")
	EndIf
;~ 	sleep(100)
	if $passtv = 1441 Then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $passtv = ' & $passtv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		msgbox(0,'','')
		exitloop
	EndIf

;~ exitloop
;~ 	if TimerDiff($timerEAPM) > 30*60000 Then
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $timerEAPM = ' & $timerEAPM & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		Run('"C:\Shared\TeamViewerT#new1ogin@mail.ru.exe"')
;~ 		exit
;~ 	EndIf



Next

_EndWindow()


Func _EndWindow()
	$aPosWindow = WinGetPos ( $hwnd )
	WinMove($hwnd,'',@DesktopWidth/2-$aPosWindow[2]/2,@DesktopHeight/2-$aPosWindow[3]/2)
	WinSetState($hWND, "", @SW_MINIMIZE )
EndFunc


Func _WaitAndGetPassTV()
	if $PIDtv<>0 then
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $PIDtv = ' & $PIDtv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		$arrayHwnds = _WinGetHandleEx($PIDtv, "", "", "", 1)
		for $i=0 to 299
			;закрытие всех лишних окон TeamViewer
			if $NotCloseTV=0 then
				For $i=0 to ubound($arrayHwnds)-1
					Opt("WinTitleMatchMode", 3)
					$t=0
					$tClose=0
					if WinGetTitle($arrayHwnds[$i])<>'TeamViewer' Then
						Opt("WinTitleMatchMode", -1)
						if WinGetTitle($arrayHwnds[$i])<>'Панель TeamViewer' then
							$t = WinClose($arrayHwnds[$i])
							ConsoleWrite('-->>')
							$tClose+=1
						EndIf
					EndIf
				;~ 	if ubound($arrayHwnds)>$tClose then
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & ' : WinGetTitle($arrayHwnds[$i]) = ' & WinGetTitle($arrayHwnds[$i])  & @CRLF ) ;### Debug Console
				;~ 	sleep(1000)
				Next
				Opt("WinTitleMatchMode", -1)
			EndIf

			$arrayHwnds = _WinGetHandleEx($PIDtv, "", "", "", $VisibleTV)
			; алгоритм выбора разных окон TV
			if not @error then
				if ubound($arrayHwnds)>1 Then
	;~ 				switch ubound($arrayHwnds)
	;~ 					case 1
					if $HandleTVChoise=0 then
						$HandleTV=$arrayHwnds[ubound($arrayHwnds)-1]
						$HandleTVChoise=ubound($arrayHwnds)-1
					Else
						$HandleTV=$arrayHwnds[$HandleTVChoise-1]
					EndIf
				Else
					$HandleTV=$arrayHwnds[0]
				EndIf
			Else
				$VisibleTV=0
				$HandleTV='TeamViewer'
				$NotCloseTV=1
			EndIf

			;		  sleep(1000)
			_MinimizeTV($HandleTV)
			;		  sleep(1000)
			$IDtv=ControlGetText ( $HandleTV, "", "[CLASS:Edit; INSTANCE:2]" )
			;		  sleep(1000)
			$passtv=ControlGetText ( $HandleTV, "", "[CLASS:Edit; INSTANCE:3]" )
			;		  sleep(1000)
			if StringRegExp ($passtv,'[0-9]')<>0 then ExitLoop
			if $i>0 and MOD($i,99)=0 then
				ConsoleWrite( ' Продолжаю ожидать окна TeamViewer... '&@CRLF)
				WinActivate("TeamViewer")
				For $i=0 to ubound($arrayHwnds)-1
					WinActivate($arrayHwnds[$i])
				Next
			endif
			sleep(100)
		Next
	Else
		for $i=0 to 299
			WinClose("Компьютеры и контакты")
			WinClose("TeamViewer - ")
			;		  sleep(1000)
			if $PIDtv<>0 then _MinimizeTV("TeamViewer")
			;		  sleep(1000)
			$IDtv=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:2]" )
			;		  sleep(1000)
			$passtv=ControlGetText ( "TeamViewer", "", "[CLASS:Edit; INSTANCE:3]" )
			;		  sleep(1000)
			if StringRegExp ($passtv,'[0-9]')<>0 then ExitLoop
			if $i>0 and MOD($i,23)=0 then WinActivate("TeamViewer")
			if $i>0 and MOD($i,49)=0 then
				ConsoleWrite( ' Продолжаю ожидать окна TeamViewer, попытка получить PID... '&@CRLF)
				$PIDtv = ProcessExists("TeamViewer.exe")
				return _WaitAndGetPassTV()
			endif
			sleep(100)
		Next
	EndIf
;~ 	if Ubound($arrayHwnds)>0 Then
;~ 		_MinimizeTV($arrayHwnds)
;~ 	Else
;~ 		_MinimizeTV("TeamViewer")
;~ 	EndIf
EndFunc

Func _MinimizeTV($hWND)
;~ 	if Ubound($hWND)>0 Then
;~ 		For $i=0 to ubound($hWND)-1
;~ 			WinSetState($hWND[$i], "", @SW_MINIMIZE )
;~ 		Next
;~ 	Else
;~ 		WinSetState($hWND, "", @SW_MINIMIZE )
;~ 	EndIf
EndFunc


Func _WinGetHandleEx($iPID, $sClassNN="", $sPartTitle="", $sText="", $iVisibleOnly=1)
    If IsString($iPID) Then $iPID = ProcessExists($iPID)
	Dim $ResultList[1]
    Local $sWList_Str = "[CLASS:" & $sClassNN & ";REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"
    If $sClassNN = "" Then $sWList_Str = "[REGEXPTITLE:(?i).*" & $sPartTitle & ".*]"

    Local $aWList = WinList($sWList_Str, $sText)
    If @error Then Return SetError(1, 0, "")
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aWList[0][0] = ' & $aWList[0][0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    For $i = 1 To $aWList[0][0]
        If WinGetProcess($aWList[$i][1]) = $iPID Then
            If Not $iVisibleOnly Or ($iVisibleOnly And BitAND(WinGetState($aWList[$i][1]), 2)) Then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($ResultList) = ' & Ubound($ResultList) & ') : WinGetTitle($aWList[$i][1]) = ' & WinGetTitle($aWList[$i][1]) & ') : $aWList[$i][1] = ' & $aWList[$i][1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				if $ResultList[0]>0 then  Redim $ResultList[Ubound($ResultList)+1]
				$ResultList[Ubound($ResultList)-1]=$aWList[$i][1]
;~ 				Return $aWList[$i][1]
			EndIf
        EndIf
    Next
;~ 	_ArrayDisplay($ResultList)
	if not @error and Ubound($ResultList)>0 and $ResultList[0]>0 then Return $ResultList
    Return SetError(2, 0, "")
EndFunc


Func _SendEmail()

; Отправка Email
if $sAttach='' then
	for $i=1 to $TrySendEmail
		$timerSendMailTCP=TimerInit()
		$SendMailTCP=SendMailTCP($ToAddress, $FromAddress , $Password, $Subject, $Body)
		ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $SendMailTCP = ' & $SendMailTCP & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerSendMailTCP) = ' & TimerDiff($timerSendMailTCP) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		if $SendMailTCP=0 Then
			ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $EmailSendError = ' & $EmailSendError & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			$EmailSendError=1
			$timerSendMailCDO=TimerInit()
			$SendMailCDO = __cdo_Message($ToAddress, $FromAddress, $FromAddress, $Password, $Subject, $Body , $sAttach, $SmtpServer)
			ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerSendMailCDO) = ' & TimerDiff($timerSendMailCDO) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			if $SendMailCDO<>1 then
				ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $EmailSendError = ' & $EmailSendError & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				$EmailSendError=2
				ConsoleWrite(  " Почта отправлена с ошибкой, ожидание и повторная попытка " & @CRLF )
				sleep(5000)
			Else
				ExitLoop
			EndIf
		Else
			ExitLoop
		EndIf
	Next
Else
	for $i=1 to $TrySendEmail
		$timerSendMailCDO=TimerInit()
;~ 		_Log_Close($hLog)
		$SendMailCDO = __cdo_Message($ToAddress, $FromAddress, $FromAddress, $Password, $Subject, $Body , $sAttach, $SmtpServer)
;~ 		$hLog = _Log_Open(@ScriptDir & '\Start.log', '### Лог программы для запуска TeamViewer ###')
		ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $SendMailCDO = ' & $SendMailCDO & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerSendMailCDO) = ' & TimerDiff($timerSendMailCDO) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		if $SendMailCDO<>1 Then
			ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $EmailSendError = ' & $EmailSendError & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			$EmailSendError=1
			$timerSendMailTCP=TimerInit()
			$SendMailTCP=SendMailTCP($ToAddress, $FromAddress , $Password, $Subject, $Body)
			ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $SendMailTCP = ' & $SendMailTCP & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timerSendMailTCP) = ' & TimerDiff($timerSendMailTCP) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			if $SendMailTCP<>1 then
				ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $EmailSendError = ' & $EmailSendError & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				$EmailSendError=2
				ConsoleWrite(  " Почта отправлена с ошибкой, ожидание и повторная попытка " & @CRLF )
				sleep(5000)
			Else
				ExitLoop
			EndIf
		Else
			ExitLoop
		EndIf
	Next
EndIf
Endfunc


Func SendMailTCP($To, $sFrom, $sPassw, $sSubject, $sMessage)
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $sMessage = ' & $sMessage & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $sSubject = ' & $sSubject & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $sPassw = ' & $sPassw & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $sFrom = ' & $sFrom & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $To = ' & $To & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $tTCPStartup=TCPStartup()
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $tTCPStartup = ' & $tTCPStartup & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

    $iSocket = TCPConnect(TCPNameToIP('smtp.mail.ru'), 25)
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $iSocket = ' & $iSocket & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $tTCPSend=TCPSend($iSocket, 'HELO ' & @LogonDomain & @CRLF)
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $tTCPSend = ' & $tTCPSend & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	local $TimeOut = TimerInit()
    While 1
        $sRecv = TCPRecv($iSocket, 2048)
		;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $sRecv = ' & $sRecv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
        If $sRecv <> '' Then
            If StringRegExp($sRecv, '250 smtp(.*).mail.ru') Then TCPSend($iSocket, 'AUTH LOGIN' & @CRLF)
            If StringInStr($sRecv, 'VXNlcm5hbWU6') Then TCPSend($iSocket, _Base64_Encode($sFrom))
            If StringInStr($sRecv, 'UGFzc3dvcmQ6') Then TCPSend($iSocket, _Base64_Encode($sPassw))
            If StringInStr($sRecv, 'Authentication succeeded') Then
                TCPSend($iSocket, 'MAIL FROM: ' & $sFrom & @CRLF)
				;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : TCPSend($iSocket, ''MAIL FROM: '' & $sFrom & @CRLF) = ' & TCPSend($iSocket, 'MAIL FROM: ' & $sFrom & @CRLF) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
                TCPSend($iSocket, 'RCPT TO: ' & $To & @CRLF)
				;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : TCPSend($iSocket, ''RCPT TO: '' & $To & @CRLF) = ' & TCPSend($iSocket, 'RCPT TO: ' & $To & @CRLF) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			EndIf
;~ 			If StringInStr($sRecv, '250 OK') Then TCPSend($iSocket, 'DATA' & @CRLF)
            If StringInStr($sRecv, '250 Accepted') Then TCPSend($iSocket, 'DATA' & @CRLF)
            If StringInStr($sRecv, '354 Enter message') Then
                TCPSend($iSocket, 'From: ' & $sFrom & @CRLF)
                TCPSend($iSocket, 'Subject: ' & $sSubject & @CRLF & @CRLF)
                TCPSend($iSocket, $sMessage & @CRLF)
                TCPSend($iSocket, '.' & @CRLF )
            EndIf
            If StringInStr($sRecv, '250 OK id=') Then
                TCPSend($iSocket, 'QUIT' & @CRLF)
                ExitLoop
            EndIf
        EndIf
        Switch StringMid($sRecv, 1, 3)
			Case 421 To 554
				;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $sRecv = ' & $sRecv & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
				if StringInStr($sRecv,'OK',1)=0 then
					ConsoleWrite( '---->>> Ошибка отправки почты <<<----'&@CRLF)
					$EmailSendError=1
				endif
                Return SetError(-1, 0, 0)
		EndSwitch
		sleep(1)
		if TimerDiff($TimeOut)>40000 then
			ConsoleWrite( ' Ошибка отпрвки почты по TCP, время ожидания больше 40 секунд. ')
			Return SetError(-1, 0, 0)
		EndIf

    Wend

    $tTCPCloseSocket = TCPCloseSocket($iSocket)
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $tTCPCloseSocket = ' & $tTCPCloseSocket & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
    $tTCPShutdown=TCPShutdown()
	;if $ReportTcpSend=1 then ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : $tTCPShutdown = ' & $tTCPShutdown & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console



    Return 1
EndFunc

Func _Base64_Encode($sData, $iFlag = 1)
    Local $Ret, $bData, $tData, $tText
    $bData = StringToBinary($sData, $iFlag)
    $tData = DllStructCreate('byte[' & BinaryLen($bData) & ']')
    DllStructSetData($tData, 1, $bData)
    $Ret = DllCall('crypt32.dll', 'bool', 'CryptBinaryToStringW', 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword', 1, 'ptr', 0, 'dword*', 0)
    If (@error) Or (Not $Ret[0]) Then
        Return SetError(1, 0, '')
    EndIf
    $tText = DllStructCreate('wchar[' & $Ret[5] & ']')
    $Ret = DllCall('crypt32.dll', 'bool', 'CryptBinaryToStringW', 'ptr', DllStructGetPtr($tData), 'dword', DllStructGetSize($tData), 'dword', 1, 'ptr', DllStructGetPtr($tText), 'dword*', $Ret[5])
    If (@error) Or (Not $Ret[0]) Then
        Return SetError(1, 0, '')
    EndIf
    Return DllStructGetData($tText, 1)
EndFunc

Func __cdo_Message($sToAddress, $sFromName, $sFromAddress, $sPassword, $sSubject = '', $sBody = '', $sAttach = '', $sServer = 'smtp.mail.ru', $iPort = 25, $iSSL = 0)
    Local $oEmail = ObjCreate('CDO.Message')
    If (Not IsObj($oEmail)) Then
		ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & '(Not IsObj($oEmail))'& @CRLF)
        Return SetError(1, 0, 0)
    EndIf
    $oEmail.From = '"' & $sFromName & '" <' & $sFromAddress & '>'
    $oEmail.To = $sToAddress
    $oEmail.Subject = $sSubject
    $oEmail.TextBody = $sBody & @CRLF
    If ($sAttach <> '') Then
        If FileExists($sAttach) Then
            $oEmail.AddAttachment($sAttach)
        Else
            Return SetError(2, 0, 0)
        EndIf
    EndIf
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendusing') = 2
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpserver') = $sServer
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpserverport') = $iPort
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpauthenticate') = 1
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendusername') = $sFromAddress
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/sendpassword') = $sPassword
    $oEmail.Configuration.Fields.Item('http://schemas.microsoft.com/cdo/configuration/smtpusessl') = $iSSL
    $oEmail.Configuration.Fields.Update
    $oEmail.Send
    If $iError Then
        $iError = 0
        Return SetError(3, 0, 0)
    EndIf
    Return 1
EndFunc

Func __cdo_error()
	ConsoleWrite( '@@ Debug(' & @ScriptLineNumber & ') : __cdo_error() = '  &  @CRLF) ;### Debug Console
	$EmailSendError=2
    $iError = $oEvent.Number
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










