#cs
MIMIC MICROSOFT WINDOWS PING PAYLOADS
Original AutoIt source from German AutoIt forum:  (which was based on Visual Basic source below)
<a href='http://www.autoit.de/index.php?page=Thread&postID=57929' class='bbc_url' title='External link' rel='nofollow external'>http://www.autoit.de/index.php?page=Thread&postID=57929</a>
Original Visual Basic source:
<a href='http://vbnet.mvps.org/index.html?code/internet/ping.htm' class='bbc_url' title='External link' rel='nofollow external'>http://vbnet.mvps.org/index.html?code/internet/ping.htm</a>
MSDN - IcmpSendEcho function
<a href='http://msdn.microsoft.com/en-us/library/windows/desktop/aa366050%28v=vs.85%29.aspx' class='bbc_url' title='External link' rel='nofollow external'>http://msdn.microsoft.com/en-us/library/windows/desktop/aa366050%28v=vs.85%29.aspx</a>
AutoIt forum: Identical problem with McAfee IPS where it blocks AutoIt's own pings, which are seen as a Nachi-like attack:
<a href='http://www.autoitscript.com/forum/topic/129525-ping-help/' class='bbc_url' title=''>http://www.autoitscript.com/forum/topic/129525-ping-help/</a>

;#################
; EXAMPLE - begin
;#################
#include "PingLikeMicrosoft.au3"
$pingresult = _PingLikeMicrosoft("hostname.somewhere.com", 4000)
;  When the function fails, @error contains extended information:
;    1 = Host is offline
;    2 = Host is unreachable
;    3 = Bad destination
;    4 = Other errors
If @error Then
MsgBox(0, "Ping Result", "Failed" & @CRLF & "Error code: " & @extended)
Else
MsgBox(0, "Ping Result", "Success" & @CRLF & $pingresult & " milliseconds")
EndIf
Exit
;#################
; EXAMPLE - end
;#################
#ce
#include-once
#include <WinAPI.au3>
Global Const $IP_SUCCESS = 0
Global Const $IP_STATUS_BASE = 11000
Global Const $IP_BUF_TOO_SMALL = ($IP_STATUS_BASE + 1)
Global Const $IP_DEST_NET_UNREACHABLE = ($IP_STATUS_BASE + 2)
Global Const $IP_DEST_HOST_UNREACHABLE = ($IP_STATUS_BASE + 3)
Global Const $IP_DEST_PROT_UNREACHABLE = ($IP_STATUS_BASE + 4)
Global Const $IP_DEST_PORT_UNREACHABLE = ($IP_STATUS_BASE + 5)
Global Const $IP_NO_RESOURCES = ($IP_STATUS_BASE + 6)
Global Const $IP_BAD_OPTION = ($IP_STATUS_BASE + 7)
Global Const $IP_HW_ERROR = ($IP_STATUS_BASE + 8)
Global Const $IP_PACKET_TOO_BIG = ($IP_STATUS_BASE + 9)
Global Const $IP_REQ_TIMED_OUT = ($IP_STATUS_BASE + 10)
Global Const $IP_BAD_REQ = ($IP_STATUS_BASE + 11)
Global Const $IP_BAD_ROUTE = ($IP_STATUS_BASE + 12)
Global Const $IP_TTL_EXPIRED_TRANSIT = ($IP_STATUS_BASE + 13)
Global Const $IP_TTL_EXPIRED_REASSEM = ($IP_STATUS_BASE + 14)
Global Const $IP_PARAM_PROBLEM = ($IP_STATUS_BASE + 15)
Global Const $IP_SOURCE_QUENCH = ($IP_STATUS_BASE + 16)
Global Const $IP_OPTION_TOO_BIG = ($IP_STATUS_BASE + 17)
Global Const $IP_BAD_DESTINATION = ($IP_STATUS_BASE + 18)
Global Const $IP_ADDR_DELETED = ($IP_STATUS_BASE + 19)
Global Const $IP_SPEC_MTU_CHANGE = ($IP_STATUS_BASE + 20)
Global Const $IP_MTU_CHANGE = ($IP_STATUS_BASE + 21)
Global Const $IP_UNLOAD = ($IP_STATUS_BASE + 22)
Global Const $IP_ADDR_ADDED = ($IP_STATUS_BASE + 23)
Global Const $IP_GENERAL_FAILURE = ($IP_STATUS_BASE + 50)
Global Const $MAX_IP_STATUS = ($IP_STATUS_BASE + 50)
Global Const $IP_PENDING = ($IP_STATUS_BASE + 255)
Global Const $PING_TIMEOUT = 500
Global Const $WS_VERSION_REQD = 0x101
Global Const $MIN_SOCKETS_REQD = 1
Global Const $SOCKET_ERROR = -1
Global Const $INADDR_NONE = 0xFFFFFFFF
Global Const $MAX_WSADescription = 256
Global Const $MAX_WSASYSStatus = 128
;~ If @AutoItX64 Then Exit 0 * MsgBox(16, @ScriptName & " - Error", "ICMP structures only designed for 32-Bit Version")
Global Const $ICMP_OPTIONS = _
"ubyte Ttl;" & _
"ubyte Tos;" & _
"ubyte Flags;" & _
"ubyte OptionsSize;" & _
"ptr OptionsData" ; Options Data
Global Const $tagICMP_ECHO_REPLY = _
"ulong Address;" & _ ; IPAddr
"ulong Status;" & _
"ULONG RoundTripTime;" & _
"USHORT DataSize;" & _
"USHORT Reserved;" & _
"ptr Data;" & _
$ICMP_OPTIONS


$input = InputBox('','$input')
$t1 = _PingLikeMicrosoft($input, 4000)
MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, '>Error code: ' & @error & @CRLF & '$t1' & @CRLF & @CRLF & 'Return:' & @CRLF & $t1) ;### Debug MSGBOX
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


Func _IcmpCustomPayload($sAddress, $sDataToSend, ByRef $ECHO, $PING_TIMEOUT = 4000) ; ECHO As ICMP_ECHO_REPLY
; $ECHO receives an ICMP_ECHO_REPLY on success
; by Prog@ndy, used VBSource from <a href='http://vbnet.mvps.org/index.html?code/internet/ping.htm' class='bbc_url' title='External link' rel='nofollow external'>http://vbnet.mvps.org/index.html?code/internet/ping.htm</a>
; on success return 1 , else 0
Local $return = 0, $error = 0
;~   'If Ping succeeds :
;~   '.RoundTripTime = time in ms for the ping to complete,
;~   '.Data is the data returned (NULL terminated)
;~   '.Address is the Ip address that actually replied
;~   '.DataSize is the size of the string in .Data
;~   '.Status will be 0
;~   '
;~   'If Ping fails .Status will be the error code
Local $WSOCK32DLL = DllOpen("wsock32.dll")
; use Icmp.dll for: Windows 2000 Server and Windows 2000 Professional
;Local $ICMPDLL = DllOpen("icmp.dll")
; use Iphlpapi.dll for: Windows Server 2008, Windows Vista, Windows Server 2003, and Windows XP
Local $ICMPDLL = DllOpen("Iphlpapi.dll")
Local $hPort ;As Long
Local $dwAddress ;As Long
Local $INADDR_NONE = -1
If Not StringRegExp($sAddress,"\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}") Then
  TCPStartup()
  $sAddress = TCPNameToIP($sAddress)
  TCPShutdown()
EndIf
;~   'convert the address into a long representation
$dwAddress = DllCall($WSOCK32DLL, "uint", "inet_addr", "str", $sAddress)
$dwAddress = $dwAddress[0]
;~   'if a valid address..
If $dwAddress <> $INADDR_NONE Or $sAddress = "255.255.255.255" Then
  ;~  'open a port
  $hPort = DllCall($ICMPDLL, "hwnd", "IcmpCreateFile")
  $hPort = $hPort[0]
  ;~  'and if successful,
  If $hPort Then
   $ECHO = DllStructCreate($tagICMP_ECHO_REPLY & ";char[355]")
   ;~    'ping it.
   Local $ret = _IcmpSendEcho($hPort, _
    $dwAddress, _
    $sDataToSend, _
    StringLen($sDataToSend), _
    0, _
    DllStructGetPtr($ECHO), _
    DllStructGetSize($ECHO), _
    $PING_TIMEOUT, _
    $ICMPDLL)
   ;~    'return the status as ping succes and close
   $error = DllStructGetData($ECHO, "Status")
   If $error = $IP_SUCCESS Then $return = 1
   DllCall($ICMPDLL, "uint", "IcmpCloseHandle", "hwnd", $hPort)
  EndIf
Else
  ;~     'the address format was probably invalid
  $return = 0
  $error = $INADDR_NONE
EndIf
DllClose($WSOCK32DLL)
DllClose($ICMPDLL)
Return SetError($error, 0, $return)
EndFunc   ;==>_IcmpCustomPayload
; by BugFix, modified by Prog@ndy
; fur 1000 < @error < 1004 is der error von Dllcall. Die DllCall-Fehlernummer ist dabei @error/1000
Func _IcmpSendEcho($IcmpHandle, $DestinationAddress, $RequestData, $RequestSize, $RequestOptions, $ReplyBuffer, $ReplySize, $Timeout, $ICMPDLL = "icmp.dll")
Local $ret = DllCall($ICMPDLL, "dword", "IcmpSendEcho", _
  "hwnd", $IcmpHandle, _
  "uint", $DestinationAddress, _
  "str", $RequestData, _
  "dword", $RequestSize, _
  "ptr", $RequestOptions, _
  "ptr", $ReplyBuffer, _
  "dword", $ReplySize, _
  "dword", $Timeout)
If @error Then Return SetError(@error+1000, 0, 0)
Return $ret[0]
EndFunc   ;==>_IcmpSendEcho

Func _PingLikeMicrosoft($DestinationAddress, $Timeout = 4000)
; function created by CUNNINGT
Local $ECHORet
; mimic AutoIt's ping payload, 36 byte payload = FAILED - blocked by IPS and ping timeout
;Local $pingSucess = _IcmpCustomPayload($DestinationAddress, "????????????????????????????????????", $ECHORet, $Timeout)
; mimic AutoIt's ping payload, but 32 byte payload like Microsoft's length = FAILED - blocked by IPS and ping timeout
;Local $pingSucess = _IcmpCustomPayload($DestinationAddress, "????????????????????????????????", $ECHORet, $Timeout)
; mimic Windows' ping payload, 32 bytes = SUCCESS - not blocked by IPS
Local $pingSucess = _IcmpCustomPayload($DestinationAddress, "abcdefghijklmnopqrstuvwabcdefghi", $ECHORet, $Timeout)
If @error Then
  Switch @error
   Case $IP_REQ_TIMED_OUT
    Return SetError(1, 1)
   Case $IP_DEST_HOST_UNREACHABLE
    Return SetError(1, 2)
   Case $IP_BAD_DESTINATION
    Return SetError(1, 3)
   Case Else
    Return SetError(1, 4)
  EndSwitch
Else
  Return DllStructGetData($ECHORet, "RoundTripTime")
EndIf
#cs
Func _DecIPToString($DecIP)
  Local $IPString =  DllCall("ws2_32.dll","str","inet_ntoa", "uint",$DecIP)
  If @error Then Return SetError(1,"0.0.0.0")
  Return $IPString[0]
EndFunc
$returnedText = DllStructCreate("char[" & DllStructGetData($ECHORet, "DataSize") & "]", DllStructGetData($ECHORet, "Data"))
MsgBox(0, 'Ping results' , "The ping was successful: " & ($pingSucess=1) & @CRLF & _
"The destination IP was: " & _DecIPToString(DllStructGetData($ECHORet, "Address")) & @CRLF & _
"The ping time was: " & DllStructGetData($ECHORet, "RoundTripTime") & " ms" & @CRLF & _
"The transmitted data (String): " & DllStructGetData($returnedText, 1))
#ce
EndFunc   ;==>_PingLikeMicrosoft