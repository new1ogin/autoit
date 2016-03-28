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
	local $iptext = @IPAddress1
	if @IPAddress2 <> '0.0.0.0' then $resulttext &= _CompareIPs(@IPAddress1,@IPAddress2)
	if @IPAddress3 <> '' and @IPAddress3 <> '0.0.0.0' then $resulttext &= _CompareIPs(@IPAddress2,@IPAddress3)
	if @IPAddress4 <> '' and @IPAddress4 <> '0.0.0.0' then $resulttext &= _CompareIPs(@IPAddress3,@IPAddress4)

	$resulttext = 'PC_Name:'&@ComputerName&' Ext_IP:'&_fgetIP()&' Local_IP:'&$iptext&' User_name:'&@UserName
	return $resulttext
EndFunc
Func _CompareIPs($IP1,$IP2)
	local $resulttext = ''
	$aIP1=StringSplit($IP1,".")
	$aIP2=StringSplit($IP2,".")
	For $i=1 to $aIP1[0]
		if $aIP1[$i] <> $aIP2[$i] Then
			$num=$i
			exitloop
		EndIf
	Next
	Switch $num
		Case 1
			$resulttext &= ';'& $aIP2[1] & '.' & $aIP2[2] & '.' & $aIP2[3] & '.' & $aIP2[4]
		Case 2
			$resulttext &= ';'& '.' & $aIP2[2] & '.' & $aIP2[3] & '.' & $aIP2[4]
		Case 3
			$resulttext &= ';'& '.' & $aIP2[3] & '.' & $aIP2[4]
		Case 4
			$resulttext &= ';' & '.' & $aIP2[4]
	EndSwitch
	return $resulttext
EndFunc
Func _fgetIP()
	$sUrl = 'http://internet.yandex.ru'
	$oHTTP = ObjCreate('WinHttp.WinHttpRequest.5.1')
	$oHTTP.Open('GET', $sUrl, False)
	$oHTTP.Send('')
	$oHTTP.WaitForResponse
	$sHTML = $oHTTP.ResponseText
	$sResult = StringRegExp($sHTML, '(?s).*?IP.*?([0-9]+.[0-9]+.[0-9]+.[0-9]+)<', 3) ; Узнаем IP
	if not @error Then
		return $sResult[0]
	Else
		return _GetIP()
	EndIf
EndFunc

Opt('MustDeclareVars', 1)

Global Const $_RAS_API_WINVER = _RAS_API_Ver()

Global $aConnections, $sError, $sMyIP, $sServerIP

If Not _RAS_API_EnumConnections($aConnections, $sError) Then
    ConsoleWrite('Error _RAS_API_EnumConnections: ' & $sError & @LF)
    Exit 1
EndIf
If @extended Then
    ConsoleWrite('Name: ' & $aConnections[1] & @LF)
Else
    ConsoleWrite('Not Connections' & @LF)
    Exit 2
EndIf
If Not _RAS_API_GetProjectionInfo($aConnections[0], $sMyIP, $sServerIP, $sError) Then
    ConsoleWrite('Error _RAS_API_GetProjectionInfo: ' & $sError & @LF)
    Exit 3
EndIf
ConsoleWrite('My IP: ' & $sMyIP & @LF)
ConsoleWrite('Server IP: ' & $sServerIP & @LF)


Func _RAS_API_GetProjectionInfo($h_RasConn, ByRef $s_MyIP, ByRef $s_ServerIP, ByRef $s_Error)
    Local Const $tag_RASPPPIP = 'dword dwSize;dword dwError;char szIpAddress[16];char szServerIpAddress[16];dword dwOptions;dword dwServerOptions', _
            $_RASP_PppIp = 0x8021
    Local $t_RasPPPIP, $i_Size, $p_RasPPPIP, $a_Res

    $s_MyIP = ''
    $t_RasPPPIP = DllStructCreate($tag_RASPPPIP)
    $i_Size = DllStructGetSize($t_RasPPPIP)
    DllStructSetData($t_RasPPPIP, 'dwSize', $i_Size)
    $p_RasPPPIP = DllStructGetPtr($t_RasPPPIP)
    $s_Error = 'Error DllCall'
    $a_Res = DllCall('rasapi32.dll', 'dword', 'RasGetProjectionInfo', 'ptr', $h_RasConn, 'dword', $_RASP_PppIp, 'ptr', $p_RasPPPIP, 'int*', $i_Size)
    If @error Then Return False
    If $a_Res[0] Then
        $s_Error = _RAS_API_GetErrorString($a_Res[0])
        Return False
    EndIf
    $s_Error = 'Success'
    $s_MyIP = DllStructGetData($t_RasPPPIP, 'szIpAddress')
    $s_ServerIP = DllStructGetData($t_RasPPPIP, 'szServerIpAddress')
    Return True
EndFunc   ;==>_RAS_API_GetProjectionInfo

Func _RAS_API_EnumConnections(ByRef $a_Connections, ByRef $s_Error)
    Local $tagRASCONN = 'dword dwSize;hwnd hRasConn;char szEntryName[257];char szDeviceType[17];char szDeviceName[129];' & _
            'char szPhonebook[260];dword dwSubEntry;byte guidEntry[16];dword dwFlags;byte luid[8]', $t_REC, $t_SizeREC, $t_Num, $i_Tmp, $a_Res

    If UBound($a_Connections) <> 2 Then Dim $a_Connections[2]
    For $i = 0 To 1
        $a_Connections[$i] = ''
    Next
    If $_RAS_API_WINVER >= 0x0600 Then $tagRASCONN &= ';byte guidCorrelationId[16]'
    $t_REC = DllStructCreate($tagRASCONN)
    $i_Tmp = DllStructGetSize($t_REC)
    $t_SizeREC = DllStructCreate('dword dwSize')
    $t_Num = DllStructCreate('dword dwCount')
    DllStructSetData($t_REC, 'dwSize', $i_Tmp)
    DllStructSetData($t_SizeREC, 'dwSize', $i_Tmp)
    $s_Error = 'Error DllCall'
    $a_Res = DllCall('rasapi32.dll', 'dword', 'RasEnumConnections', 'ptr', DllStructGetPtr($t_REC), 'ptr', DllStructGetPtr($t_SizeREC), 'ptr', DllStructGetPtr($t_Num))
    If @error Then Return False
    If $a_Res[0] Then
        $s_Error = _RAS_API_GetErrorString($a_Res[0])
        Return False
    EndIf
    $s_Error = 'Success'
    $i_Tmp = DllStructGetData($t_Num, 'dwCount')
    If Not $i_Tmp Then Return True
    For $i = 0 To 1
        $a_Connections[$i] = DllStructGetData($t_REC, $i + 2)
    Next
    Return SetExtended($i_Tmp, True)
EndFunc   ;==>_RAS_API_EnumConnections

Func _RAS_API_GetErrorString($i_Error, $i_Flag = 1, $i_Del = 0)
    Local Static $a__Error[2]
    Local $a_Res, $s_Ret

    If Not $a__Error[1] Then
        $a__Error[0] = DllStructCreate('char[512]')
        $a__Error[1] = DllStructGetPtr($a__Error[0])
    EndIf
    $a_Res = DllCall('rasapi32.dll', 'dword', 'RasGetErrorString', 'uint', $i_Error, 'ptr', $a__Error[1], 'dword', 512)
    If @error Or $a_Res[0] Then
        If $i_Flag Then $s_Ret = 'Error GetErrorString'
    Else
        $s_Ret = DllStructGetData($a__Error[0], 1)
    EndIf
    DllStructSetData($a__Error[0], 1, '')
    If $i_Del Then
        For $i = 0 To 1
            $a__Error[$i] = 0
        Next
    EndIf
    Return $s_Ret
EndFunc   ;==>_RAS_API_GetErrorString

Func _RAS_API_Ver()
    Local $t_OSVI, $a_Res

    $t_OSVI = DllStructCreate('dword Size;dword MajorVersion;dword MinorVersion;dword BuildNumber;dword PlatformId;wchar CSDVersion[128]')
    DllStructSetData($t_OSVI, 'Size', DllStructGetSize($t_OSVI))
    $a_Res = DllCall('kernel32.dll', 'int', 'GetVersionExW', 'ptr', DllStructGetPtr($t_OSVI))
    If (@error) Or (Not $a_Res[0]) Then Return 0
    Return BitOR(BitShift(DllStructGetData($t_OSVI, 'MajorVersion'), -8), DllStructGetData($t_OSVI, 'MinorVersion'))
EndFunc   ;==>_RAS_API_Ver
