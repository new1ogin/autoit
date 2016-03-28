#RequireAdmin
Const $ICQMOD_DLL = @ScriptDir & '\ICQ.dll'
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ICQMOD_DLL = ' & $ICQMOD_DLL & @CRLF ) ;### Debug Console

Const $PROXY_TYPE_SOCKS_4 = 1
Const $PROXY_TYPE_SOCKS_5 = 2

Const $AUTH_OK = 1
Const $AUTH_NO = 0

Const $ICQ_CONNECT_STATUS_OK = 4294967295
Const $ICQ_CONNECT_STATUS_RECV_ERROR = 4294967294
Const $ICQ_CONNECT_STATUS_SEND_ERROR = 4294967293
Const $ICQ_CONNECT_STATUS_CONNECT_ERROR = 4294967292
Const $ICQ_CONNECT_STATUS_AUTH_ERROR = 4294967291

Const $ICQ_CLIENT_STATUS_CONNECTED = 1
Const $ICQ_CLIENT_STATUS_DISCONNECTED = 2

Const $stICQ_CLIENT = DllStructCreate("byte status;ushort sequence;ulong sock")
$stPROXY_INFO = 0

;~ $t = ICQConnect('login.icq.com:5190',"675190233",'iopTHN123','0')
$t = ICQConnect('login.icq.com:5190',"login:675190233","pass:iopTHN123",'0')
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF ) ;### Debug Console
$t = ICQSendMsg('393467316','re rf he re')
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t = ' & $t & @CRLF ) ;### Debug Console

Func ICQConnect($server,$login,$password,$proxy,$proxytype=2)
	if String($proxy) <> '0' Then
		$proxy = StringSplit($proxy,":",2)
		$stPROXY_INFO = DllStructCreate("ulong ProxyType;ulong ProxyIp;ushort ProxyPort")
		DllStructSetData($stPROXY_INFO, "ProxyType", $proxytype)
		DllStructSetData($stPROXY_INFO, "ProxyIp", $proxy[0])
		DllStructSetData($stPROXY_INFO, "ProxyPort", Int($proxy[1]))
	EndIf
	$srv = StringRegExp($server,"(.*):(.*)",3)
	if not @error Then
		$server = "host:login.icq.com";$srv[0]
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $server = ' & $server & @CRLF ) ;### Debug Console
		$port = "port:5190";$srv[1]
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $port = ' & $port & @CRLF ) ;### Debug Console
	Else
		Return 0
	EndIf
	$aRet = DllCall($ICQMOD_DLL, "dword", "ICQConnect", "ptr", DllStructGetPtr($stICQ_CLIENT), "str", $server, "word", $port, "str", $login, "str", $password, "ptr", $stPROXY_INFO)
	if IsArray($aRet) And $aRet[0] = $ICQ_CONNECT_STATUS_OK Then
		Return 1
	Else
		if IsArray($aRet) Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aRet[0] = ' & $aRet[0] & @CRLF ) ;### Debug Console
		Return 0
	EndIf
EndFunc

Func ICQSendMsg($to,$msg)
	return DllCall($ICQMOD_DLL, "dword", "ICQSendMsg", "ptr", DllStructGetPtr($stICQ_CLIENT), "str", String($to), "str", $msg)
EndFunc

Func ICQAuth($who,$auth)
	DllCall($ICQMOD_DLL, "dword", "ICQAuth", "ptr", DllStructGetPtr($stICQ_CLIENT), "str", String($who), "str", $auth)
EndFunc

Func ICQAskAuth($who,$msg)
	DllCall($ICQMOD_DLL, "dword", "ICQSendAuth", "ptr", DllStructGetPtr($stICQ_CLIENT), "str", String($who), "str", $msg)
EndFunc

Func ICQClose()
	DllCall($ICQMOD_DLL, "dword", "ICQClose", "ptr", DllStructGetPtr($stICQ_CLIENT))
EndFunc

Func ICQReadMsg()
	$Call = DllCall($ICQMOD_DLL, "dword", "ICQReadMsg", "ptr", DllStructGetPtr($stICQ_CLIENT), "str", "UIN", "str", "msg", "int", "msglen")
	if $Call[0]=0 Then
		Return 0
	Else
		Local $a[2]
		$a[0] = $Call[2]
		$a[1] = $Call[3]
		Return $a
	EndIf
EndFunc