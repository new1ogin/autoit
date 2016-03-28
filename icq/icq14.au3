#include <GUIConstants.au3>
#include <EditConstants.au3>
#Include <GuiEdit.au3>
#include <WindowsConstants.au3>
AutoItSetOption ("TrayIconDebug" ,1)


Const $ICQMOD_DLL = 'IcqMod.dll'
Const $PROXY_TYPE_SOCKS_4 = 1
Const $PROXY_TYPE_SOCKS_5 = 2
Const $ICQ_CONNECT_STATUS_OK = 0xFFFFFFFF
Const $ICQ_CONNECT_STATUS_RECV_ERROR = 0xFFFFFFFE
Const $ICQ_CONNECT_STATUS_SEND_ERROR = 0xFFFFFFFD
Const $ICQ_CONNECT_STATUS_CONNECT_ERROR = 0xFFFFFFFC
Const $ICQ_CONNECT_STATUS_AUTH_ERROR = 0xFFFFFFFB
Const $ICQ_CLIENT_STATUS_CONNECTED = 1
Const $ICQ_CLIENT_STATUS_DISCONNECTED = 2
Const $stICQ_CLIENT = DllStructCreate("byte status;ushort sequence;ulong sock")
Const $stPROXY_INFO = 0 ;DllStructCreate("ulong ProxyType;ulong ProxyIp;ushort ProxyPort")

;~ DllStructSetData($stPROXY_INFO, "ProxyType", $PROXY_TYPE_SOCKS_4)
;~ DllStructSetData($stPROXY_INFO, "ProxyIp", @IPAddress1)
;~ DllStructSetData($stPROXY_INFO, "ProxyPort", 8080)

global $icq_server,$sLogin,$sPass, $uin, $pass

$icq_server = ''
$uin = $sLogin = 'uin'
$pass = $sPass = 'pass'

$aRet = DllCall($ICQMOD_DLL, "dword", "ICQConnect", _
    "ptr", DllStructGetPtr($stICQ_CLIENT), _
    "str", "login.icq.com", _
    "word", "5190", _
    "str", $sLogin, _
    "str", $sPass, _
    "ptr", $stPROXY_INFO)

$begin = 0 ; переменная таймера



;~ Func _sendICQMSG($ICQmessage)
;~ $ICQmessage = GUICtrlRead ($Edit2)
;~ If $ICQmessage = "" Then
;~     GUICtrlSetData ($Edit1, "System: nothing to send!"&@CRLF, 1)
;~     GUICtrlSetState ($Edit2, $GUI_FOCUS)
;~     Return
;~ EndIf
;~ $ICQmessageBin = StringToBinary($ICQmessage, 4); преобразуем в UTF-8
;~ $ICQmessageUtf = BinaryToString ($ICQmessageBin , 1)
;~ ICQSendMsg($master,$ICQmessageUtf)
;~ GUICtrlSetData ($Edit2, ""); очищаем поле ввода
;~ GUICtrlSetData ($Edit1, "You: "&$ICQmessage&@CRLF, 1); записываем в историю
;~ GUICtrlSetState ($Edit2, $GUI_FOCUS)
;~ EndFunc

Func __ReadMsg()
    If $stICQ_CLIENT = 0 Then
        If TimerDiff($begin) >= 10000 Then
            $status = ICQConnect($icq_server, $uin, $pass,0)
            If $status = 0 Then
                $begin = TimerInit()
                Return "System: could not connect!"
            Else
                Return "System: connected!"
            EndIf
        EndIf
    EndIf
    If DllStructGetData ($ICQ_CLIENT_STATUS_CONNECTED, "status") = 1 Then
        $sMsg = ICQReadMsg()
        If $sMsg<>0 Then
            If $sMsg[0] = $master Then
                $otvet = "Master: "&$sMsg[1]
                Return $otvet
            EndIf
        EndIf
    ElseIf $ICQ_CLIENT_STATUS_CONNECTED = 1 Then
        $status = 0
        Return "Disconnected!"
    EndIf
    Return ""
 EndFunc

    While DllStructGetData($stICQ_CLIENT, "status") = $ICQ_CLIENT_STATUS_CONNECTED
        If __ReadMsg() = 1 Then
            $RecvMsg = DllStructGetData($sMsg, "msg")
            Select
                Case $sMsg == "1"
                ICQ_Send_Msg(DllStructGetData($RecvInfo,"UIN"), "Ready to work")
                Case $RecvMsg == "2"
                ICQ_Send_Msg(DllStructGetData($RecvInfo,"UIN"), "Good bye")
                ICQ_Close()
            EndSelect
        EndIf
    WEnd



;~ есть icqmod.dll с функциями:
;~ Код: [Выделить]

;~ ICQAuth
;~ ICQClose
;~ ICQConnect
;~ ICQReadMsg
;~ ICQSendAuth
;~ ICQSendMsg


;~ так же нашел еще одну библиотеку icq_socket.dll с большим кол-вом функций:
;~ (нажмите для показа/скрытия)
;~ Код: [Выделить]

;~ ICQ_CheckVersion
;~ ICQ_ClearContactList
;~ ICQ_ClearDisconnectReason
;~ ICQ_Connect
;~ ICQ_DeleteIndexContact
;~ ICQ_DeleteSocket
;~ ICQ_DeleteUINContact
;~ ICQ_Disconnect
;~ ICQ_ForEach
;~ ICQ_GetActive
;~ ICQ_GetAffiliation
;~ ICQ_GetAffiliationRange
;~ ICQ_GetAutoConnect
;~ ICQ_GetBackground
;~ ICQ_GetBackgroundRange
;~ ICQ_GetCallback
;~ ICQ_GetConnectHost
;~ ICQ_GetConnecting
;~ ICQ_GetConnectPort
;~ ICQ_GetContactCount
;~ ICQ_GetCountry
;~ ICQ_GetCountryRange
;~ ICQ_GetDisconnectReason
;~ ICQ_GetHost
;~ ICQ_GetHostPort
;~ ICQ_GetIndexContact
;~ ICQ_GetInterest
;~ ICQ_GetInterestRange
;~ ICQ_GetLanguage
;~ ICQ_GetLanguageRange
;~ ICQ_GetLastSendUDPSequence
;~ ICQ_GetLibVersion
;~ ICQ_GetLicense
;~ ICQ_GetLogLevel
;~ ICQ_GetMaxAttempts
;~ ICQ_GetMaxPassLen
;~ ICQ_GetMaxSocketCount
;~ ICQ_GetNick
;~ ICQ_GetOccupation
;~ ICQ_GetOccupationRange
;~ ICQ_GetPacketVersion
;~ ICQ_GetPass
;~ ICQ_GetProtocolVersion
;~ ICQ_GetProxyHost
;~ ICQ_GetProxyLoginUsed
;~ ICQ_GetProxyPass
;~ ICQ_GetProxyPort
;~ ICQ_GetProxyUsed
;~ ICQ_GetProxyUser
;~ ICQ_GetRedirectCount
;~ ICQ_GetRedirectHost
;~ ICQ_GetRedirectPort
;~ ICQ_GetSocketCount
;~ ICQ_GetStatus
;~ ICQ_GetStdCallback
;~ ICQ_GetTimeout
;~ ICQ_GetUIN
;~ ICQ_GetUINContact
;~ ICQ_GetUINContactIndex
;~ ICQ_GetUserPointer
;~ ICQ_GetWait
;~ ICQ_GetWaitConnect
;~ ICQ_GetWaitPointer
;~ ICQ_GetWaitTimeout
;~ ICQ_NewSocket
;~ ICQ_Poll
;~ ICQ_PollSocket
;~ ICQ_RemoveIndexContact
;~ ICQ_RemoveUINContact
;~ ICQ_Send_AllowRequest
;~ ICQ_Send_Authorize
;~ ICQ_Send_ContactList
;~ ICQ_Send_DeniedRequest
;~ ICQ_Send_FullSearch
;~ ICQ_Send_FullSearch2
;~ ICQ_Send_GetExtInfo
;~ ICQ_Send_GetInfo
;~ ICQ_Send_GetMetaInfo
;~ ICQ_Send_InvisibleList
;~ ICQ_Send_KeepAlive
;~ ICQ_Send_Message
;~ ICQ_Send_Search
;~ ICQ_Send_SetAuth
;~ ICQ_Send_SetMetaInfo
;~ ICQ_Send_SetMetaInfo2
;~ ICQ_Send_SetMetaInfoAbout
;~ ICQ_Send_SetMetaInfoHome
;~ ICQ_Send_SetMetaInfoMore
;~ ICQ_Send_SetMetaInfoSecurity
;~ ICQ_Send_SetUserInfo
;~ ICQ_Send_Url
;~ ICQ_Send_VisibleList
;~ ICQ_SetActive
;~ ICQ_SetAutoConnect
;~ ICQ_SetCallback
;~ ICQ_SetContact
;~ ICQ_SetContact2
;~ ICQ_SetHost
;~ ICQ_SetHostPort
;~ ICQ_SetLogLevel
;~ ICQ_SetMaxAttempts
;~ ICQ_SetMaxPassLen
;~ ICQ_SetNick
;~ ICQ_SetPass
;~ ICQ_SetProtocolVersion
;~ ICQ_SetProxyHost
;~ ICQ_SetProxyLoginUsed
;~ ICQ_SetProxyPass
;~ ICQ_SetProxyPort
;~ ICQ_SetProxyUsed
;~ ICQ_SetProxyUser
;~ ICQ_SetStatus
;~ ICQ_SetStdCallback
;~ ICQ_SetTimeout
;~ ICQ_SetUIN
;~ ICQ_SetUserPointer
;~ ICQ_SetWaitConnect
;~ ICQ_SetWaitPointer
;~ ICQ_Wait
;~ ICQ_WaitTimeout


