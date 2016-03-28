#include <Inet.au3>
#include <array.au3>
ConsoleWrite(@ComputerName)
ConsoleWrite(@CRLF)
ConsoleWrite(@IPAddress1)
ConsoleWrite(@CRLF)
ConsoleWrite(@IPAddress2)
ConsoleWrite(@CRLF)
ConsoleWrite(@IPAddress3)
ConsoleWrite(@CRLF)
ConsoleWrite(_fgetIP())
ConsoleWrite(@CRLF)
ConsoleWrite(@UserName)
ConsoleWrite(@CRLF)
;~ ConsoleWrite(@IPAddress2)
;~ ConsoleWrite(@CRLF)
ConsoleWrite(_CopmInf() & @CRLF)

;Функции для вывода информации о компьютере
Func _CopmInf()
	Local $iptext = @IPAddress1
	If @IPAddress2 <> '0.0.0.0' Then $iptext &= _CompareIPs(@IPAddress1, @IPAddress2)
	If @IPAddress3 <> '' And @IPAddress3 <> '0.0.0.0' Then $iptext &= _CompareIPs(@IPAddress2, @IPAddress3)
	If @IPAddress4 <> '' And @IPAddress4 <> '0.0.0.0' Then $iptext &= _CompareIPs(@IPAddress3, @IPAddress4)

	$resulttext = 'PC_Name:' & @ComputerName & ' Ext_IP:' & _fgetIP() & ' Local_IP:' & $iptext & ' User_name:' & @UserName
	Return $resulttext
EndFunc   ;==>_CopmInf
Func _CompareIPs($IP1, $IP2)
	Local $resulttext = ''
	$aIP1 = StringSplit($IP1, ".")
	$aIP2 = StringSplit($IP2, ".")
	For $i = 1 To $aIP1[0]
		If $aIP1[$i] <> $aIP2[$i] Then
			$num = $i
			ExitLoop
		EndIf
	Next
	Switch $num
		Case 1
			$resulttext &= ';' & $aIP2[1] & '.' & $aIP2[2] & '.' & $aIP2[3] & '.' & $aIP2[4]
		Case 2
			$resulttext &= ';' & '.' & $aIP2[2] & '.' & $aIP2[3] & '.' & $aIP2[4]
		Case 3
			$resulttext &= ';' & '.' & $aIP2[3] & '.' & $aIP2[4]
		Case 4
			$resulttext &= ';' & '.' & $aIP2[4]
	EndSwitch
	Return $resulttext
EndFunc   ;==>_CompareIPs
Func _fgetIP()
	$sUrl = 'http://internet.yandex.ru'
	$oHTTP = ObjCreate('WinHttp.WinHttpRequest.5.1')
	$oHTTP.Open('GET', $sUrl, False)
	$oHTTP.Send('')
	$oHTTP.WaitForResponse
	$sHTML = $oHTTP.ResponseText
	$sResult = StringRegExp($sHTML, '(?s).*?IP.*?([0-9]+.[0-9]+.[0-9]+.[0-9]+)<', 3) ; Узнаем IP
	If Not @error Then
		Return $sResult[0]
	Else
		Return _GetIP()
	EndIf
EndFunc   ;==>_fgetIP
