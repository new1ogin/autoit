#include <IE.au3>
#include <Array.au3>
#include <crc.au3>
#include <Date.au3>

;~ Opt('MustDeclareVars',      1)
Opt('TrayIconDebug', 1)
$iHide = 1 ; 0 - ������� 1 - �������
HotKeySet('{ESC}', '_Exit')
Global $oIE
Global $OldPass = 'xp42DF#&*()', $NewPass = 'xp42DF#&*()'
global $ShingleLen = 7
global $MonNames = '���|���|���|���|���|���|���|���|���|���|���|���', $aMonNames
dim $aMonNames[12] = ['���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���']

$oIE = _IECreate('http://vk.com', 0, $iHide)
If @error Then
	ConsoleWrite('@@ ' & @HOUR & ':' & @MIN & ' Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
EndIf
Sleep(2000)
$errorLogin = 0
_VK_Login('newlogin8@gmail.com', 'murena31', $iHide)
If @error Then
	$errorLogin = 1
	ConsoleWrite('�����������' & '������ �����������: ' & @TAB & @error & @CRLF & '������ �������: ' & @TAB & @TAB & @extended)
	$oDivs = _IETagNameGetCollection($oIE, 'a')
	If Not @error Then
		For $oDiv In $oDivs
			$sPropDiv = _IEPropertyGet($oDiv, 'outerhtml')
			If Not @error Then
				If StringInStr($sPropDiv, '�����') Then
					ConsoleWrite(' �� ������������ ������� ��� ����� ������')
					$errorLogin = 0
;~ 						_VK_LogOut()
;~ 						_IEQuit ( $oIE )
;~ 						_VK_Pass_change()
;~ 						return
;~ 						ExitLoop

				EndIf
			EndIf
		Next
	EndIf
EndIf

$pagen = 300
_IENavigate($oIE, "http://vk.com/horror_tales#/wall-40529013?offset=" & $pagen * 20 & "&own=1")

Local $oHTML = _IEBodyReadHTML($oIE)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $oHTML = ' & $oHTML & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$aArticles = StringRegExp($oHTML, '<div id="wpt-40529013_([0-9]*?)"><div class="wall_post_text">(.*?)</div>(?s).*?(?-s)' & _
		'<span class="post_like_count fl_l" id="like_count-40529013_[0-9]*?">(.*?)</span>(?s).*?(?-s)' & _
		'<span class="post_share_count fl_l" id="share_count-40529013_[0-9]*?">(.*?)</span>(?s).*?(?-s)' & _
		'<span class="rel_date(.*?)</span>.*?��������</a>(?s)(.*?)(?-s)<div class="post_table">', 3)
;~ _ArrayDisplay($aArticles)
;������ ������
local $iHours, $iMins, $iSecs, $mon

For $i=0 to (UBound($aArticles)-1) step 6
	$id = $aArticles[$i+0]
	$text = _HTMLTransSymb($aArticles[$i+1])
	$like = $aArticles[$i+2]
	$repost = $aArticles[$i+3]
	$date = $aArticles[$i+4]
	$other = $aArticles[$i+5]
	if StringInStr($date,'�������') then
		$aTemp = StringRegExp($date,'������� � (\d+):(\d+)',2)
;~ 		$date = @YEAR&'/'&@MON&'/'&@MDAY&' '&StringRight('0'&$aTemp[1],2)&':'&StringRight('0'&$aTemp[2],2)&':'&'00'
		$date = StringFormat("%04d/%02d/%02d %02d:%02d:%02d", @YEAR, @MON, @MDAY, $aTemp[1], $aTemp[2], 0)
	Elseif StringInStr($date,'�����') then
		$aTemp = StringRegExp($date, '����� � (\d+):(\d+)',2)
;~ 		$date = @YEAR&'/'&@MON&'/'&@MDAY&' '&StringRight('0'&$aTemp[1],2)&':'&StringRight('0'&$aTemp[2],2)&':'&'00'
		$date = StringFormat("%04d/%02d/%02d %02d:%02d:%02d", @YEAR, @MON, @MDAY, $aTemp[1], $aTemp[2], 0)
		$date = _DateAdd('D', -1, $date)
	Elseif StringRegExp($date,'(\d+) ('&$MonNames&') � (\d+):(\d+)') Then
		$aTemp = StringRegExp($date,'(\d+) ('&$MonNames&') � (\d+):(\d+)',2)
		for $m=0 to 11
			if StringInStr($aTemp[2],$aMonNames[$m]) then
				$mon = $m+1
			EndIf
		Next
;~ 		$date = @YEAR&'/'&$mon&'/'&StringRight('0'&$aTemp[1],2)&' '&StringRight('0'&$aTemp[3],2)&':'&StringRight('0'&$aTemp[4],2)&':'&'00'
		$date = StringFormat("%04d/%02d/%02d %02d:%02d:%02d", @YEAR, $mon, $aTemp[1], $aTemp[3], $aTemp[4], 0)
	Elseif StringRegExp($date,'(\d+) ('&$MonNames&') (\d{4})') Then
		$aTemp = StringRegExp($date,'(\d+) ('&$MonNames&') (\d{4})',2)
		for $m=0 to 11
			if StringInStr($aTemp[2],$aMonNames[$m]) then
				$mon = $m+1
			EndIf
		Next
		;����������� ����� ����������� �������, �� �� ���������� �����
		$iTicks = StringRight($id,3)&'000'
		_TicksToTime($iTicks*60, $iHours, $iMins, $iSecs)
		$date = StringFormat("%04d/%02d/%02d %02d:%02d:%02d", $aTemp[3], $mon, $aTemp[1], $iHours, $iMins, $iSecs)
	Else
		$date = StringRegExpReplace($date,'[^0-9]','')&' '&$date
	EndIf


	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $other = ' & $other & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	$aArticles[$i+1] = $text
	$aArticles[$i+4] = $date
Next
_ArrayDisplay($aArticles)
;~ ;�������� ������ ������
;~ $BadArticle='486399'
;~ $SearchWall='40529013'
;~ $oLinks = _IELinkGetCollection($oIE)
;~ $sMyString = 'http://vk.com'
;~ Dim $aResult[1]
;~ For $i = 0 To 1
;~   For $oLink in $oLinks
;~ 	;���� ������ �� ������
;~ 	if StringRegExp($oLink.href, 'http://vk.com/wall-'&$SearchWall&'_[0-9]*$') Then
;~ 		if $oLink.href <> 'http://vk.com/wall-'&$SearchWall&'_'&$BadArticle Then _ArrayAdd($aResult, $oLink.href)
;~     EndIf
;~   Next
;~ Next
;~ $aResult = _ArrayUnique($aResult)
;~ _ArrayDisplay($aResult) ; ������� ������ � ���������� ��������



Exit


If @ComputerName = "server" Then
	Sleep(3 * 60000)

	If ProcessExists("PingPlotter.exe") = 0 Then
;~ 		MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & 'ProcessExists("PingPlotter.exe")' & @CRLF & @CRLF & 'Return:' & @CRLF & ProcessExists("PingPlotter.exe")) ;### Debug MSGBOX
		Run('"' & @ProgramFilesDir & '\PingPlotter Pro\PingPlotter.exe"', '', @SW_HIDE)
;~ 		MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & 'Run(''"''&@ProgramFilesDir&''\PingPlotter Pro\PingPlotter.exe"'','''',@SW_HIDE)' & @CRLF & @CRLF & 'Return:' & @CRLF & Run('"'&@ProgramFilesDir&'\PingPlotter Pro\PingPlotter.exe"','',@SW_HIDE)) ;### Debug MSGBOX
	EndIf
EndIf

;~ MsgBox(262144, 'Debug line ~' & @ScriptLineNumber, 'Selection:' & @CRLF & '@ComputerName' & @CRLF & @CRLF & 'Return:' & @CRLF & @ComputerName) ;### Debug MSGBOX


While 1

	If @WDAY <> 1 And @WDAY <> 7 Then
		If @HOUR < 8 Or @HOUR > 16 Then
			_VK_Pass_change()
			Sleep((10 * 60000) + Random(765, (5 * 60000)))
		Else
			Sleep(60 * 60000)
		EndIf
	Else
		_VK_Pass_change()
		Sleep((10 * 60000) + Random(765, (5 * 60000)))
	EndIf

WEnd


Func _VK_Pass_change()

	$oIE = _IECreate('http://vk.com', 0, $iHide)
	If @error Then
		ConsoleWrite('@@ ' & @HOUR & ':' & @MIN & ' Debug(' & @ScriptLineNumber & ') : @error = ' & @error & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	EndIf
	Sleep(2000)
	$errorLogin = 0
	_VK_Login('newlogin7@gmail.com', 'xp42DF#&*()', $iHide)
	If @error Then
		$errorLogin = 1
		ConsoleWrite('�����������' & '������ �����������: ' & @TAB & @error & @CRLF & '������ �������: ' & @TAB & @TAB & @extended)
		$oDivs = _IETagNameGetCollection($oIE, 'a')
		If Not @error Then
			For $oDiv In $oDivs
				$sPropDiv = _IEPropertyGet($oDiv, 'outerhtml')
				If Not @error Then
					If StringInStr($sPropDiv, '�����') Then
						ConsoleWrite(' �� ������������ ������� ��� ����� ������')
						$errorLogin = 0
						_VK_LogOut()
						_IEQuit($oIE)
						_VK_Pass_change()
						Return
						ExitLoop

					EndIf
				EndIf
			Next
		EndIf
	EndIf

	If $errorLogin = 0 Then
		_VKPassChange($OldPass, $NewPass)
		If @error Then ConsoleWrite('���� �������' & '������ : ' & @TAB & @error & @CRLF & '������ �������: ' & @TAB & @TAB & @extended)

		_VK_LogOut()

		_IEQuit($oIE)
	Else
		_VK_LogOut()
		_IEQuit($oIE)
		Sleep(5000)
		_VK_Pass_change()
		Return

	EndIf
EndFunc   ;==>_VK_Pass_change

Func _VK_LogOut()
	Sleep(1000)


	Local $oButtons, $oDivs, $oBtns, $sPropDiv, $sPropBtn
;~ 	$oButtons = _IETagNameGetCollection($oIE, 'button')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oButtons = ' & $oButtons & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	For $oButton In $oButtons
;~ 		If $oButton.classname == 'button' And $oButton.innertext == '�����' Then
;~ 			_IEAction($oButton, 'click')
;~ 			_IELoadWait($oIE)
;~ 		EndIf
;~ 	Next
;~ 	sleep(5000)
;~ 	$oDivs=_IETagNameGetCollection($oIE, 'div')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oDivs = ' & $oDivs & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	If Not @error Then
;~ 		For $oDiv In $oDivs
;~ 			$sPropDiv=_IEPropertyGet($oDiv, 'outerhtml')
;~ 			If Not @error Then
;~ 				If StringInStr($sPropDiv, 'button') And StringInStr($sPropDiv, '�����') Then
;~ 					_IEAction($oDiv, 'click')
;~ 					ExitLoop
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	EndIf
;~ 	sleep(5000)
;~ 		$oBtns=_IETagNameGetCollection($oIE, 'button')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oBtns = ' & $oBtns & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	If Not @error Then
;~ 		For $oBtn In $oBtns
;~ 			$sPropBtn=_IEPropertyGet($oBtn, 'outerhtml')
;~ 			If Not @error Then
;~ 				If StringInStr($sPropBtn, 'button') And StringInStr($sPropBtn, '�����') Then
;~ 					_IEAction($oBtn, 'click')
;~ 					ExitLoop
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	EndIf

;~ 	$oButtons = _IETagNameGetCollection($oIE, 'a')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oButtons = ' & $oButtons & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	For $oButton In $oButtons
;~ 		If $oButton.innertext == '�����' Then
;~ 			_IEAction($oButton, 'click')
;~ 			_IELoadWait($oIE)
;~ 		EndIf
;~ 	Next
;~ 	sleep(5000)
	$oDivs = _IETagNameGetCollection($oIE, 'a')
	ConsoleWrite('@@ ' & @HOUR & ':' & @MIN & ' Debug(' & @ScriptLineNumber & ') : $oDivs = ' & $oDivs & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If Not @error Then
		For $oDiv In $oDivs
			$sPropDiv = _IEPropertyGet($oDiv, 'outerhtml')
			If Not @error Then
				If StringInStr($sPropDiv, '�����') Then
					_IEAction($oDiv, 'click')
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf
;~ 	sleep(5000)
;~ $oBtns=_IETagNameGetCollection($oIE, 'a')
;~ 	ConsoleWrite('@@ '&@HOUR&':'&@MIN&' Debug(' & @ScriptLineNumber & ') : $oBtns = ' & $oBtns & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	If Not @error Then
;~ 		For $oBtn In $oBtns
;~ 			$sPropBtn=_IEPropertyGet($oBtn, 'outerhtml')
;~ 			If Not @error Then
;~ 				If StringInStr($sPropBtn, '�����') Then
;~ 					_IEAction($oBtn, 'click')
;~ 					ExitLoop
;~ 				EndIf
;~ 			EndIf
;~ 		Next
;~ 	EndIf
;~ sleep(5000)
;~ $oButtons = _IETagNameGetCollection($oIE, 'a')
;~ For $oButton In $oButtons
;~     If $oButton.classname == "top_nav_link" Then
;~         $oButton.Click()
;~         ExitLoop
;~     EndIf
;~ Next
	Sleep(500)
EndFunc   ;==>_VK_LogOut


Func _VK_Login($sEmail, $sPass, $iHide = 1)
	Local $oLoginForm, $oEmail, $oPass

	$oLoginForm = _IEFormGetObjByName($oIE, 'login')
	If @error Then
		SetError(2, @error)
		Return 0
	EndIf

	$oEmail = _IEFormElementGetObjByName($oLoginForm, 'email')
	If @error Then
		SetError(3, @error)
		Return 0
	EndIf

	$oPass = _IEFormElementGetObjByName($oLoginForm, 'pass')
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oEmail, $sEmail)
	If @error Then
		SetError(5, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oPass, $sPass)
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf

	_IEFormSubmit($oLoginForm)
	If @error Then
		SetError(5, @error)
		Return 0
	EndIf


	If $iHide Then _IEAction($oIE, 'visible')
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf

	SetError(0, 0)
	Return 1
EndFunc   ;==>_VK_Login

Func _Exit()
	Exit
EndFunc   ;==>_Exit


Func _VKPassChange($OldPassL, $NewPassL)
	Local $oButtons, $oDivs, $oBtns, $oOldPass, $oNewPass, $oNewConfPass, $sPropBtn

	_IENavigate($oIE, "http://vk.com/settings")
	ConsoleWrite('@@ ' & @HOUR & ':' & @MIN & ' Debug(' & @ScriptLineNumber & ') : _IENavigate($oIE, "http://vk.com/settings") = ' & _IENavigate($oIE, "http://vk.com/settings") & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Sleep(2000)
;~     $oPass      = _IEFormElementGetObjByName($oLoginForm, 'old_password')
	$oOldPass = _IEGetObjByName($oIE, "settings_old_pwd")
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oOldPass, $OldPassL)
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf


	$oNewPass = _IEGetObjByName($oIE, "settings_new_pwd")
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oNewPass, $NewPassL)
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf


	$oNewConfPass = _IEGetObjByName($oIE, "settings_confirm_pwd")
	If @error Then
		SetError(4, @error)
		Return 0
	EndIf

	_IEFormElementSetValue($oNewConfPass, $NewPassL)
	If @error Then
		SetError(6, @error)
		Return 0
	EndIf

	$oBtns = _IETagNameGetCollection($oIE, 'button')
	ConsoleWrite('@@ ' & @HOUR & ':' & @MIN & ' Debug(' & @ScriptLineNumber & ') : $oBtns = ' & $oBtns & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	If Not @error Then
		For $oBtn In $oBtns
			$sPropBtn = _IEPropertyGet($oBtn, 'outerhtml')
			If Not @error Then
				If StringInStr($sPropBtn, 'button') And StringInStr($sPropBtn, '�������� ������') Then
					_IEAction($oBtn, 'click')
					ExitLoop
				EndIf
			EndIf
		Next
	EndIf

EndFunc   ;==>_VKPassChange

Func _GenShingle($aText)
;~ 	if UBound($aPolinom) < 3 Then _GetPolinom()
	$timer = TimerInit()
;~ 	_Crypt_Startup()
	local $aHash[$aText[0] - $ShingleLen + 1]
	$aHash[0] = $aText[0] - $ShingleLen
;~ 	local $aHash84[UBound($aPolinom)]
	For $i = 1 to $aText[0] - $ShingleLen ; ������� ����
		$stringForHash = ''
		For $st=0 to $ShingleLen-1 ; ���������� � �����
			$stringForHash &= $aText[$i+$st]
		Next
		; ������ �����
		$aHash[$i] = _CRC32($stringForHash, -1, StringToBinary(StringLeft($aText[$i],1)&StringLeft($aText[$i+1],1)&StringLeft($aText[$i+2],1)&StringLeft($aText[$i+3],1)))
	Next
;~ 	_Crypt_Shutdown()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
	return $aHash
EndFunc

Func _ClearText($fulltext)
;~ 	$timer = TimerInit()
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($text) = ' & StringLen($text) & @CRLF) ;### Debug Console

	Local $text = _ClearHTML($fulltext)
	$text = _HTMLTransSymb($text)



	$text = StringLower($text) ; ������ � ������ ��������
	$text = StringReplace($text, @CR, ' ')
	$text = StringReplace($text, @LF, ' ')
	$text = StringReplace($text, '�', '�') ; �������� ��� � �� �
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($text) = ' & StringLen($text) & @CRLF) ;### Debug Console
	$text = _deleteStopwordsBigDic($text)
	$text = StringRegExpReplace($text, '[^a-z�-�� ]', '') ; ��� ��������, ��� ����, � 1 ������
	; �������� ����-���� (����� �������)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($text) = ' & StringLen($text) & @CRLF) ;### Debug Console
	$text = StringRegExpReplace($text, '(?m)( |^)(�|���|�����|��|���|����|����|����|����|�|���|���|����|��|���|���|�����|����|��|���|��|����|���|��|���|��|����|����' & _
			'|���|��|��|�����|�|��|��-��|���|��|��|�|���|���-��|��|�����|���|��|����|���|�����|��|��|����|���|��|����|��|���|��' & _
			'|���|��|��|�|��|������|��|���|���|���|��|�����|��|���|���|�|��|���|�����|�����|���|��|���|��|����|����|���|������|���' & _
			'|��|�|���|����|����|���|���|���|�����|���|���|���|���|���|�|���|�|�|�������|�������|����|��������|���|���|�����|�������' & _
			'|����|���|����|����|���|����|����|�������|��|���|����|����|�����|������|���|����|�����|������|������|������|�����|������' & _
			'|����������|�|�� �����������|�����|�����|���|���|��������|������|�����|������|������ ���|�����|���|�����|�����|���|����-��)( |$)', ' ')
	$text = StringRegExpReplace($text, '(?m)( |^)[^ ]{0,2}( |$)', ' ') ; ������� �� ��� ������ ���� ��������
	$text = StringRegExpReplace($text, '(?m)( |^)[^ ]{0,2}( |$)', ' ') ; ������� �� ��� ������ ���� ��������
	$text = StringRegExpReplace($text, '(?m)( |^)[^ ]{0,2}( |$)', ' ') ; ������� �� ��� ������ ���� ��������

	$text = StringRegExpReplace($text, '( ){2}', ' ')

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console

	ConsoleWrite($text & @CRLF)
;~ ClipPut($text)

	; ����� �� http://www.cyberforum.ru/algorithms/thread55.html ������������� ���������� ����� �� �������� ����� (������� �������).
;~ 	$ADJECTIVE = '(?m)( |^)([a-z�-��]*?(��|��|��|��|���|���|��|��|��|��|��|��|��|��|���|���|���|���|��|��|��|��|��|��|��|��))( |$)'; ��������������
	$ADJECTIVE = '(?m)( |^)([a-z�-��]*?(��|��|��|��|���|���|��|��|��|��|��|��|��|���|���|���|���|��|��|��|��|��|��|��|��))( |$)'; ��������������
;~ $PARTICIPLE = '(?m)( |^)((���|���|���)|(([��])(��|��|��|��|�)))( |$)'; ���������
	$PARTICIPLE = '(?m)( |^)([a-z�-��]*?((���|���|���)|[��](��|��|��|��|�)))( |$)'; ���������
	;������
;~ 	$VERB = '(?m)( |^)([a-z�-��]*?((���|���|���|����|����|���|���|���|��|��|��|��|��|��|��|���|���|���|��|���|���|��|��|���|���|���|���|��|�)|([��](��|��|���|���|��|�|�|��|�|��|��|��|��|��|��|���|���))))( |$)';
	$VERB = '(?m)( |^)([a-z�-��]*?((���|���|���|����|����|���|���|���|��|��|��|��|��|��|���|���|���|��|���|���|��|��|���|���|���|���|��)|([��](��|��|���|���|��|�|�|��|��|��|��|��|��|���|���))))( |$)';
	$NOUN = '(?m)( |^)([a-z�-��]*?(�|��|��|��|��|�|����|���|���|��|��|�|���|��|��|��|�|���|��|���|��|��|��|�|�|��|���|��|�|�|��|��|�|��|��|�))( |$)'; ���������������
;~ $RVRE = '/^(.*?[���������])(.*)$/'; ���� �� ����� ����� ���� �������
;~ $DERIVATIONAL = '(?m)( |^)([a-z�-��]*?[^��������� ][���������]+[^��������� ]+[���������][^ ]*?�?���?)( |$)'; �������

	StringSplit($text, ' ')

	$aADJECTIVE = StringRegExp($text, $ADJECTIVE, 3)
	$aADJECTIVE = _ClearStrregexpArray($aADJECTIVE, 1, 4)
	$aVERB = StringRegExp($text, $VERB, 3)
	$aVERB = _ClearStrregexpArray($aVERB, 1, 7)
	$aNOUN = StringRegExp($text, $NOUN, 3)
	$aNOUN = _ClearStrregexpArray($aNOUN, 1, 4)

	; ��������� �� �������������� � �������� ���� ������� �����
	$aText = StringSplit($text, ' ')
	Local $atext2[$aText[0] + 1]
	$schet = 1
	For $i = 1 To $aText[0]
		If StringLen($aText[$i]) <= 3 Then
			If StringRegExp($aText[$i], $NOUN) Then
				$atext2[$schet] = $aText[$i]
				$schet += 1
			ElseIf StringRegExp($aText[$i], $ADJECTIVE) Then
				;���������� ��������������
			ElseIf StringRegExp($aText[$i], $VERB) Then
				;���������� ������
			Else
				; ���� �� ���������� ����� ���� ������ ��� �����
				$atext2[$schet] = $aText[$i]
				$schet += 1
			EndIf
		Else
			; ������ ��� �������� �����, �.�. ���������� �� ����� ���� �� ��� ������
			$atext2[$schet] = $aText[$i]
			$schet += 1
		EndIf

	Next
	$atext2 = _ArrayClearEmpty($atext2, 0, 1)
	$atext2[0] = UBound($atext2) - 1
;~ _ArrayDisplay($atext2)

	;������� ���������
	$endings = "(?m)( |^)([a-z�-��]*?)(�|�|��|��|��|��|��|���|��|�|��|��|��|��|��|���|�|�|�|�|���|���|�|��|��|��|��|�|�|��|��|��)( |$)"
	For $i = 1 To $atext2[0]
		$temp = StringRegExpReplace($atext2[$i], $endings, '$1$2$4')
		If StringLen($temp) > 2 Then $atext2[$i] = $temp
	Next
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console


	Return $atext2

EndFunc   ;==>_ClearText


Func _ClearStrregexpArray($array, $num, $step)
	Local $newArray[(UBound($array)) / $step]
	$s = 0
	For $i = 0 To (UBound($array) - 1) Step $step
		$newArray[$s] = $array[$i + $num]
		$s += 1
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $array[$i+1] = ' & $array[$i+1] & @CRLF) ;### Debug Console
	Next
	Return $newArray
EndFunc   ;==>_ClearStrregexpArray

Func _deleteStopwordsBigDic($text)
	Local $aStopwordsBigDic[479] = ['������ �� ��������������� ���������� ��������', '������ �� ��������������� ���������� �������', _
			'������ �� ��������������� ����� ��������', '������ �� ��������������� ����� �������', _
			'������ �� ��������������� �������� ��', '�������� �� ������� ������������', '���� ����� ���������� ���������', _
			'���������� ����������� ������', '������ �� ��� �� ��� ������', '�� ����� ������������� ����', '������ �� ����������� � ���', _
			'� ����� ������������ �����', '����� �������� �� ��������', '�������� �� ����� �������', '�� �������������� ������', _
			'�� ��� ������� ���������', '��� �� ��������� �����', '����� ������� ��������', '����� ������� ��������', _
			'�� ������ �����������', '���� ����� ����������', '������ �� �����������', '�� ��� ���� �� ������', _
			'������ �� �����������', '��� ������� ��������', '��� ������� ��������', '��� ������� ��������', _
			'������ ����� �������', '� ���������� �������', '������ ��� ���������', '����� ����� ��������', _
			'����� ����� ��������', '����� ����� ��������', '����� ����� ��������', '����� ����� �������', _
			'�� ���� �����������', '�� ����� ����������', '� ������ ����������', '� ������ ����������', '� ���� ����� ������', _
			'� ������ ����������', '� ������ ����������', '� ��������� �������', '������ �� ���������', '�� ������ ���������', _
			'���������� ��������', '����� ���� ��������', '�������� �� �������', '��� �� ��� �� ����', '��� ��� �� �������', _
			'���������� �������', '�� ������� �������', '�� �������� ������', '���������� �������', '���������� �������', _
			'������ �����������', '������� �� �������', '������ �� ��������', '������ �����������', '������������ ����', _
			'� �������� ������', '���� ������ �����', '���� ������ �����', '� ������ ��������', '� ������� �������', '� ������ ��������', _
			'��� �� �� �� ����', '����� ���� ������', '������ �� �������', '���������� ������', '�� ���� ���������', '�� ������ �������', _
			'�� ������� ������', '�� ��������������', '���������� ������', '������� �� ������', '���������� ������', '� ��������� �����', _
			'���������� ������', '������ �� �������', '����� ����� �����', '������� ���������', '���������� ������', '��� �� ����������', _
			'���� ������������', '� ������ �������', '� ������ �������', '�� ������ ������', '��� ��� ��������', '�� ����� �������', _
			'�� ������ ������', '�� ������ ������', '�� ������ ������', '�� ������ ������', '�� ����� �������', '�������� �������', _
			'����������������', '����������� ����', '� ������ �������', '������� �� �����', '�� ����� �������', '����� �� �������', _
			'��� ����� ������', '�� ����� �� ����', '����������������', '������� ��������', '������� ��������', '� ����� �������', _
			'� �������������', '��������� �����', '���������� ����', '�� � �� �������', '������� �������', '� ����� �������', _
			'� ������� �����', '� ����� �������', '��� �� ��������', '��� �����������', '��� ����� �����', '����� ���������', _
			'�� ������� ����', '�� ����� ������', '�� ����� ������', '�������� ������', '�������� ������', '� ����� �������', _
			'��� �� ��������', '��� �����������', '������� �������', '���� �������� �', '�������� �� ���', '������ ��������', _
			'������� �������', '� ����� ������', '� ����� ������', '� ���� �������', '������ �������', '��� ��� ������', '���� ���������', _
			'���� ���������', '��� ���� �����', '� ����� ������', '��� ����������', '��� ����������', '��� ����������', '��� ����������', _
			'��� �� �������', '��� ����������', '������� ������', '������ �������', '����� ��������', '�� ���� ������', '�� ����� �����', _
			'������ �������', '�� �����������', '�� �����������', '�� ���� ������', '������ �������', '��������� ����', '� ����� ������', _
			'��������������', '������ �������', '��� � ��������', '��� ����������', '� ����� ������', '� ����� � ����', '�� �����������', _
			'����� �� �����', '����� ��������', '������ ������', '�������� ����', '������ ������', '������� �����', '������� �����', _
			'�������������', '������ ������', '��� ���� ����', '����� �������', '��� ���������', '��� �� ������', '��� ���������', _
			'��� �� ������', '��� ���������', '������ ������', '������ ������', '����� �������', '����� �������', '����� �������', _
			'����� �������', '�� ��� ������', '�� ��� ������', '�� ����� ����', '���� ��������', '�� ����� ����', '�� ����������', _
			'�������� ����', '������ ������', '����� �������', '�������������', '������ ������', '���� �� �����', '��� ��� �����', _
			'����� �������', '������ ������', '��� �� ������', '����� �������', '������ ������', '� �� �� �����', '���� ��������', _
			'������ ������', '�� ����� ����', '� ����� ����', '��� ��������', '� ����� ����', '��� ��������', '������� ����', '����� ������', _
			'� ����� ����', '� ����� ����', '� ���� �����', '����� ������', '�������� ���', '� ����������', '��� ��������', '��� �� �����', _
			'��� ��������', '��� ��������', '���� �������', '����� ������', '����� ������', '�� ���������', '�� ������-��', '����� ������', _
			'�� ���������', '�� ���������', '�� ���������', '�� ���������', '�� ���� ����', '������ �����', '������ �����', '������ �����', _
			'����� ������', '������ �����', '������������', '���� �������', '� ���� �����', '������ �����', '�� ���������', '�� ��� �����', _
			'������������', '��� �� �����', '��� ��������', '������ ����', '� ���������', '������ ����', '���� ������', '���� ������', _
			'���� ������', '�����������', '� ���� ����', '� ���� ����', '� ���������', '� ���������', '� ���������', '� ���������', '�������� ��', _
			'��� �������', '��� �������', '��� �������', '��� �������', '��� �������', '��� �������', '��� �������', '����� �����', '����� �����', _
			'���� ������', '�����������', '�����������', '�� ��������', '�� ��������', '��-��������', '�������� ��', '�������� ��', '������ ����', _
			'����� �����', '�����������', '�����������', '�����������', '��� �������', '����� �����', '�����������', '�����������', '� ��������', _
			'� ��������', '����������', '����� ����', '���� �����', '� �����-��', '� ��������', '� ��������', '����������', '����� ����', _
			'� ��������', '��� ������', '��� ������', '��� ������', '��� ������', '��� ������', '��� ������', '����� ����', '����� ����', _
			'����� ����', '�� �������', '����������', '����������', '����������', '����������', '�� �������', '�� �������', '�� �������', _
			'����������', '����������', '����������', '����������', '����������', '���� �����', '����� ����', '����� ����', '����������', _
			'����� ����', '����� ����', '������� ��', '����������', '������ ���', '��� ������', '� �������', '� �������', '��� �����', '���������', _
			'�-�������', '������ ��', '������ ��', '����� ���', '������ ��', '������ ��', '��-������', '��-������', '���� ����', '���� ����', _
			'������-��', '��� �����', '������ ��', '������ ��', '� �������', '� �������', '� �������', '��� �����', '��� �����', '��� �����', _
			'���� ����', '���� ����', '������ ��', '�� ������', '�� ������', '�� ������', '�� ������', '�� ������', '�� ������', '��-������', _
			'��-������', '��-������', '��-������', '���������', '���������', '���������', '���������', '���������', '���������', '����� ���', _
			'���������', '���������', '� ������', '� ������', '� ������', '��� ����', '��������', '��������', '��������', '��������', '��������', _
			'��� ����', '��������', '� ������', '� ������', '� ������', '��������', '��������', '��������', '��������', '��������', '��������', _
			'��� ����', '��������', '��-�����', '��������', '��������', '��������', '���� ���', '��������', '����� ��', '����� ��', '��������', _
			'���� ��', '��� ����', '� �����', '�������', '�������', '�������', '�������', '�������', '� �����', '� �����', '� �����', '� �����', _
			'�������', '�������', '�� ����', '�������', '�������', '�������', '�� ����', '�� ����', '�������', '�������', '�������', '�������', _
			'�������', '�������', '�������', '�������', '� �����', '������', '������', '������', '������', '������', '������', '������', '������', _
			'������', '������', '������', '������', '������', '������', '�� ���', '������', '������', '������', '������', '������', '������', _
			'������', '� ����', '�����', '�����', '�����', '�����', '�����', '�����', '�����', '�����', '�����', '�����', '����', '����', '����', _
			'����', '���']
	Local $aPlaguewordsExp = ['������ �� ��������������� �������� [�-���]*?', '(������|������) (���� )?(�����������|����������)', _
			'(��, ��� |�� ��� |��� )?��� �������', '��� ��� (������� / ��� )?��������', '��� ���( � ���� ��� �������)?', _
			'� ������ ������( �������)?', '���������(-��|��| ��)?����', '(� )?�� �����( ������)?', '(������|������)( ��)?', _
			'� �����(-��|��| ��)?', '(�����|�����) ������', '����������( ������)?', '������(-��|��| ��)?', '(��, |�� )?�� ����', _
			'(�� �� )?���������', '(��� )?������(��)?', '(��, |�� )?������', '(�� )?�����(��)?', '���� ����( ���)?', _
			'���������( ��)?', '�� ����( ����)?', '��� ���( ���)?', '(� )?�� ������', '������(��|��)?', '(�� )? �������', _
			'(�������|�) ���', '�� (��� )?���', '������( ���)?', '���-��( ���)?', '������( ���)?', '������( ��)?', '(� )?� �����', _
			'(��� )?����', '(��� )?����', '(�� )?�� ���', '���( ���)?', '(�� )?���']
	Local $aPlaguewords = ['���� ����� ��� �������', '��������� ����� ����', '��� �� ��� �������', '��� � ���� �������', '�� ��� ��� �������', _
			'� ��������� ����', '���� ���������', '��� ���������', '�� ����� ����', '� ���� ����� ', '� ����� ����', '���� ������', '��� ��������', _
			'�����������', '������� ���', '�����������', '�����������', '� �� ������', '��� �������', '� ��������', '���� � ���', '����� ����', _
			'������� ��', '�� � �����', '������ ���', '����������', '���������', '���������', '����� ���', '�-��-����', '���������', '� �������', _
			'��-������', '���������', '��� �����', '��� �����', '��������', '� ��� ��', '��������', '��������', '��������', '��������', '��������', _
			'��������', '��-�-��', '��� ���', '�������', '�������', '�� ����', '������', '������', '������', '������', '��� ��', '������', '������', _
			'�� ���', '������', '������', '������', '������', '��, ��', '�����', '�����', '�����', '�� ��', '�����', '����', '����', '����', '��-�', _
			'��-�', '����', '����', '����', '�-��', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', _
			'��', '��', '��']

	;��������� ������
	$text = ' ' & $text & ' '
	For $i = 0 To UBound($aStopwordsBigDic) - 1
		$text = StringReplace($text, ' ' & $aStopwordsBigDic[$i] & ' ', ' ')
	Next
	For $i = 0 To UBound($aPlaguewordsExp) - 1
		$text = StringRegExpReplace($text, '(?m)( |^)' & $aPlaguewordsExp[$i] & '( |$)', ' ')
	Next
	For $i = 0 To UBound($aPlaguewords) - 1
		$text = StringReplace($text, ' ' & $aPlaguewords[$i] & ' ', ' ')
	Next
	Return $text
EndFunc   ;==>_deleteStopwordsBigDic

Func _ClearHTML($sText)
	Local $0, $DelAll, $DelTag, $i, $Rep, $teg, $Tr
	$Tr = 0
	$teg = 'p|div|span|html|body|b|table|td|tr|th|font|img|br'
	$sText = StringRegExpReplace($sText, '(?s)<!--.*?-->', '') ; �������� ������������

	; ============= ���� colspan, rowspan
	$0 = Chr(0)
	$Rep = StringRegExp($sText, '(?s)(<[^<>]+?(?:colspan|rowspan)[^<>]+?>)', 3) ; � ������
	If Not @error Then
		$Tr = 1
		$sText = StringRegExpReplace($sText, '(?s)(<[^<>]+?(?:colspan|rowspan)[^<>]+?[^/]>)', $0) ; ��������� �������
	EndIf
	$sText = StringRegExpReplace($sText, '(?s)(<(?:' & $teg & '))[\r\n]* [^<>]*?(>)', '\1\2') ; �������

	If $Tr Then
		For $i = 0 To UBound($Rep) - 1
			$Rep[$i] = _Replace($Rep[$i])
			$sText = StringReplace($sText, $0, $Rep[$i], 1)
		Next
	EndIf
	; =============

	$sText = StringReplace($sText, '<p><o:p>&nbsp;</o:p></p>', '<br><br>') ; ������ ��������� �����
	; $sText=StringRegExpReplace($sText, '(?s)(<('&$teg&').*?>)(.*?)</\2>(\s*)\1', '\1\3\4') ; ������� ������������
	$sText = StringRegExpReplace($sText, '(?s)<(' & $teg & ')[^<>]*?>[\x{A0}\s]*?</\1>', '') ; ������� ����� ��� ��������

	$DelAll = 'xml|style|script'
	$sText = StringRegExpReplace($sText, '(?s)<(' & $DelAll & ')[^<>]*>(.*?)</\1>', '') ; �������� � ����������

	$DelTag = 'span'
;~ 	$sText = StringRegExpReplace($sText, '(?s)</?(' & $DelTag & ')[^<>]*>', '') ; �������� ����� �����

	Return $sText
EndFunc   ;==>_ClearHTML

Func _Replace($Rep)
	$teg = 'table|td|tr|th'
	$aRep = StringRegExp($Rep, '((?:colspan|rowspan)\h*=\h*"?\d+"?)', 3)
	$Rep = StringRegExpReplace($Rep, '(?s)(<(?:' & $teg & ')) .*?(>)', '\1') ; �������
	For $i = 0 To UBound($aRep) - 1
		$Rep &= ' ' & $aRep[$i]
	Next
	$Rep &= '>'
	Return $Rep
EndFunc   ;==>_Replace


Func _HTMLTransSymb($text)

	$text = StringRegExpReplace($text, '(?s)<script[^>]*?>.*?</script>', '')
	$text = StringRegExpReplace($text, '(?s)<[\/\!]*?[^<>]*?>', @CRLF)
	$text = StringRegExpReplace($text, '&quot;', '"')
	$text = StringRegExpReplace($text, '&raquo;', '"')
	$text = StringRegExpReplace($text, '&laquo;', '"')
	$text = StringRegExpReplace($text, '&amp;', '&')
	$text = StringRegExpReplace($text, '&lt;', '<')
	$text = StringRegExpReplace($text, '&gt;', '>')
	$text = StringRegExpReplace($text, '&nbsp;', ' ')
	$text = StringRegExpReplace($text, '&iexcl;', '&#161;')
	$text = StringRegExpReplace($text, '&cent;', '&#162;')
	$text = StringRegExpReplace($text, '&pound;', '&#163;')
	$text = StringRegExpReplace($text, '&copy;', '&#169;')

	; ������� �������� ��� ������� �� ��� ������
	$a = StringRegExp($text, '&#(\d+);', 3)
	If Not @error Then
		$a = _ArrayUnique($a)
		For $i = 1 To $a[0]
			$a[$i] = Number($a[$i])
		Next
		_ArraySort($a, 1, 1)
		For $i = 1 To $a[0]
			$text = StringReplace($text, '&#' & $a[$i] & ';', ChrW($a[$i]))
		Next
	EndIf
;~ 	$text = StringRegExpReplace($text, '([\r\n])[\s]+', @CRLF)

	; ���� ����������� ������� ����������. ���� ���� � UTF8 �� � �� ����� ���� ��������� �������, ������� ��� ���������� � ASCI ����� ���������
	$text = StringRegExpReplace($text, '[��]', '"') ; ������������ �������
	$text = StringReplace($text, ChrW(160), ' ') ; �������� ������ 160 �� ������ 32
	$text = StringReplace($text, ChrW(8226), '') ; ������� ���������
	$text = StringReplace($text, ChrW(8211), '-') ; ������� ���� �� ���������� �����
	$text = StringReplace($text, ChrW(8230), '...') ; ��������� �� ��� �����
	$text = StringReplace($text, ChrW(8212), '-') ; ����� ������� ���� �� ��������

	Return $text
EndFunc   ;==>_HTMLTransSymb

Func _ArrayClearEmpty($a_Array, $i_SubItem = 0, $i_Start = 0)
	If Not IsArray($a_Array) Or UBound($a_Array, 0) > 2 Then Return SetError(1, 0, 0)

	Local $i_Index = -1
	Local $i_UBound_Row = UBound($a_Array, 1) - 1
	Local $i_UBound_Column = UBound($a_Array, 2) - 1

	If $i_UBound_Column = -1 Then $i_UBound_Column = 0
	If $i_SubItem > $i_UBound_Column Then $i_SubItem = 0
	If $i_Start < 0 Or $i_Start > $i_UBound_Row Then $i_Start = 0

	Switch $i_UBound_Column + 1
		Case 1
			Dim $a_TempArray[$i_UBound_Row + 1]
			If $i_Start Then
				For $i = 0 To $i_Start - 1
					$a_TempArray[$i] = $a_Array[$i]
				Next
				$i_Index = $i_Start - 1
			EndIf
			For $i = $i_Start To $i_UBound_Row
				If String($a_Array[$i]) Then
					$i_Index += 1
					$a_TempArray[$i_Index] = $a_Array[$i]
				EndIf
			Next
			If $i_Index > -1 Then
				ReDim $a_TempArray[$i_Index + 1]
			Else
				Return SetError(2, 0, 0)
			EndIf
		Case 2 Or 3 Or 4 Or 5 Or 6 Or 7
			Dim $a_TempArray[$i_UBound_Row + 1][$i_UBound_Column + 1]
			If $i_Start Then
				For $i = 0 To $i_Start - 1
					For $j = 0 To $i_UBound_Column
						$a_TempArray[$i][$j] = $a_Array[$i][$j]
					Next
				Next
				$i_Index = $i_Start - 1
			EndIf
			For $i = $i_Start To $i_UBound_Row
				If String($a_Array[$i][$i_SubItem]) Then
					$i_Index += 1
					For $j = 0 To $i_UBound_Column
						$a_TempArray[$i_Index][$j] = $a_Array[$i][$j]
					Next
				EndIf
			Next
			If $i_Index > -1 Then
				ReDim $a_TempArray[$i_Index + 1][$i_UBound_Column + 1]
			Else
				Return SetError(2, 0, 0)
			EndIf
	EndSwitch
	Return $a_TempArray
EndFunc   ;==>_ArrayClearEmpty
