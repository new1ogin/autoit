;~ #include <Crypt.au3>
;~ #include <ComboConstants.au3>
;~ #include <EditConstants.au3>
;~ #include <GUIConstantsEx.au3>
;~ #include <WinAPI.au3>
;~ #include <WindowsConstants.au3>
#include <array.au3>
#include "crc.au3"



;~ #Include <FileOperations.au3>
$BadArticle = '486399'
$SearchWall = '40529013'
;~ $oLinks = _IELinkGetCollection($oIE)
$sMyString = 'http://vk.com'
$oLink = 'http://vk.com/wall-40529013_486399?reply=602361'
;~ $oLink = 'http://vk.com/wall-40529013_603636'

;~ if StringRegExp($oLink, 'http://vk.com/wall-'&$SearchWall&'_[0-9]*$') Then ConsoleWrite(9087948359437598437)
$CLEAR = 'p|span|div|body|br|table|td|tr|b|img|html'
$DELETE = 'm:|o:|/o:|w:|v:|/v:|!\[endif\]|!\[if|head|/head|meta|link|!--'
$TWIN = 'xml|style'



global $ShingleLen = 7, $aPolinom

$text = '����� ����� �������� ������, �� ������ ���������� ������� � ��������� ��������. ��������� � ���������� ��� �������  � ������ ��������� � ���������!' & @CRLF & _
		'�������! ��������� � ���������� ���� ���������. � ��� ����� ���������� � ������� �����������, ������� ��������� ��� ��� ���������� ������� � ��������� ��������, ����� ����� �������� ������ � ������ ���.' & @CRLF & _
		'a &#161; b &iexcl; The ?? federal government on Wednesday said Apple has agreed to pay at least $32.5 million in refunds to parents who didn�t authorize hefty purchases racked up by their children on their iPhones and iPads.'
$text &= _htmltext()

$aText = _ClearText($text)
_ArrayDisplay($aText)
 $aText = _GenShingle($aText)
_ArrayDisplay($aText)

;~ 	$TEXT=_StringStripTags($TEXT,$CLEAR,$DELETE,$TWIN)
;~ $text=StringRegExpReplace($text, '</?\w+((\s+\w+(\s*=\s*(?:".*?"|''.*?''|[^''">\s]+))?)+\s*|\s*)/?>', '')
;~ 	$text=StringRegExpReplace($text,'<(?!/?pre).*?>','')


;~  $text = ClipGet()
;~  $atext = StringSplit($text,' ')
;~  _ArraySort($atext,0,1)
;~ $atext = _ArrayUnique($atext,0,1)
;~  $text =''
;~  For $i=1 to UBound($atext)-1
;~ 	 $text&=$atext[$i]&' '
;~  Next
;~  ClipPut($text)
;~  exit
Func _GenShingle($aText)
	if UBound($aPolinom) < 3 Then _GetPolinom()
	$timer = TimerInit()
;~ 	_Crypt_Startup()
	local $aHash[$aText[0] - $ShingleLen + 1]
	$aHash[0] = $aText[0] - $ShingleLen
	local $aHash84[UBound($aPolinom)]
	For $i = 1 to $aText[0] - $ShingleLen ; ������� ����
		$stringForHash = ''
		For $st=0 to $ShingleLen-1 ; ���������� � �����
			$stringForHash &= $aText[$i+$st]
		Next
		; ������ �����
		For $h = 0 to 83
			$aHash84[$h] = _CRC32($stringForHash, -1, $aPolinom[$h])
		Next
		$aHash[$i] = _ArrayMin($aHash84)
	Next
;~ 	_Crypt_Shutdown()
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
	return $aHash
EndFunc

Func _GetPolinom()
;~ 	Dim $aPolinom[84] = [0x6D17013A, 0xB7A830D3, 0xD599A47D, 0x103C8A7C, 0xFA9653FE, 0xB98463E8, 0x93024E24, 0xCB66D972, 0xB100EC72, _
;~ 0xE98AAB9A, 0xA23A4071, 0xF8A23A92, 0x432C87EC, 0xDC9107FB, 0xD2F1E532, 0x3958BAAE, 0x425037A4, 0xBCA620D8, 0x1005D274, 0x0FB2B299, 0x0CD70468, _
;~ 0x4F5BE045, 0xF84859C2, 0xBC1D1CF7, 0xD007E223, 0xDFFE6762, 0x64CC74AF, 0x27F56D1F, 0x84F47616, 0x3CBAC8C8, 0x3E1DD92B, 0x8ED5E6B4, 0x33F53677, _
;~ 0xC4CB135F, 0xED84C9DA, 0xE251E891, 0x019A5D90, 0x11B09F8F, 0x0AD5368A, 0x8B7EB305, 0xF8B0E6EC, 0x3A921839, 0x9D07BEB5, 0x1923CB38, 0xAEC4178E, _
;~ 0xCA3842A8, 0xC5921496, 0x4FC486C6, 0xF209F307, 0xB80838AD, 0x81404ED8, 0xD5518F63, 0x365B0DF8, 0xAB333DBB, 0x8B1D14B4, 0x56EBC511, 0x28748A60, _
;~ 0x8DA0CDEF, 0xA9E08A27, 0xACB52402, 0xBAEE0390, 0xAF1085C6, 0xF4E61845, 0x487337DA, 0xCBA0B410, 0x2BD60084, 0xDA0746B0, 0x851263B4, 0x3B3AF655, _
;~ 0x0FABE25D, 0x3347FDE6, 0xFB33F6C9, 0x20819DCD, 0xADCF3EEB, 0xEB20BA52, 0xA028FF25, 0xD358B926, 0x627F0BD7, 0xCEDD8D17, 0xA2E7E951, 0x07BD4D36, _
;~ 0x6AC6955F, 0x94F0263D, 0x98ED53B1]
	Dim $aPolinom[16] = [0x6D17013A, 0xB7A830D3, 0xD599A47D, 0x103C8A7C, 0xFA9653FE, 0xB98463E8, 0x93024E24, 0xCB66D972, 0xB100EC72, _
0xE98AAB9A, 0xA23A4071, 0xF8A23A92, 0x432C87EC, 0xDC9107FB, 0xD2F1E532, 0x3958BAAE]
EndFunc
Func _ClearText($fulltext)
;~ 	$timer = TimerInit()
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($text) = ' & StringLen($text) & @CRLF) ;### Debug Console

	local $text = _ClearHTML($fulltext)
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


return $atext2

EndFunc


Func _StringStripTags($sStr, $CLEAR = '', $DELETE = '', $TWIN = '')
	If $CLEAR <> '' Then $sStr = StringRegExpReplace($sStr, '(?s)<(' & $CLEAR & ')(.*?)>', '<\1>')
	If $DELETE <> '' Then $sStr = StringRegExpReplace($sStr, '(?s)<(' & $DELETE & ')(.*?)>', '')
	If $TWIN <> '' Then $sStr = StringRegExpReplace($sStr, '(?s)<(' & $TWIN & ')>(.*)</(' & $TWIN & ')>', '')
	Return $sStr
EndFunc   ;==>_StringStripTags

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
	return $text
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

Func _htmltext()
	$htmltext = '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Strict//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-strict.dtd">' & @CRLF & _
'<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="ru" lang="ru">' & @CRLF & _
'<head>' & @CRLF & _
'<meta http-equiv="X-UA-Compatible" content="IE=edge" />' & @CRLF & _
'<link rel="shortcut icon" href="/images/icons/pinbar_favicon.ico?3" />' & @CRLF & _
'' & @CRLF & _
'<link rel="apple-touch-icon" href="/images/safari_60.png">' & @CRLF & _
'<link rel="apple-touch-icon" sizes="76x76" href="/images/safari_76.png">' & @CRLF & _
'<link rel="apple-touch-icon" sizes="120x120" href="/images/safari_120.png">' & @CRLF & _
'<link rel="apple-touch-icon" sizes="152x152" href="/images/safari_152.png">' & @CRLF & _
'' & @CRLF & _
'<meta http-equiv="content-type" content="text/html; charset=windows-1251" />' & @CRLF & _
'<meta name="description" content="" />' & @CRLF & _
'' & @CRLF & _
'<title>�����</title>' & @CRLF & _
'' & @CRLF & _
'<noscript><meta http-equiv="refresh" content="0; URL=/badbrowser.php"></noscript>' & @CRLF & _
'' & @CRLF & _
'<script type="text/javascript">' & @CRLF & _
'var vk = {' & @CRLF & _
'  ads_rotate_interval: 120000,' & @CRLF & _
'  al: parseInt('&"'"&'3'&"'"&') || 4,' & @CRLF & _
'  id: 196112742,' & @CRLF & _
'  intnat: '&"'"&''&"'"&' ? true : false,' & @CRLF & _
'  host: '&"'"&'vk.com'&"'"&',' & @CRLF & _
'  lang: 0,' & @CRLF & _
'  rtl: parseInt('&"'"&''&"'"&') || 0,' & @CRLF & _
'  version: 18765,' & @CRLF & _
'  stDomains: 0,' & @CRLF & _
'  zero: false,' & @CRLF & _
'  contlen: 183055,' & @CRLF & _
'  loginscheme: '&"'"&'https'&"'"&',' & @CRLF & _
'  ip_h: '&"'"&'05723882eac569957b'&"'"&',' & @CRLF & _
'  vc_h: '&"'"&'5a8f5d5dd754797074cec01277e9f947'&"'"&',' & @CRLF & _
'  navPrefix: '&"'"&'/'&"'"&',' & @CRLF & _
'  dt: parseInt('&"'"&'0'&"'"&') || 0,' & @CRLF & _
'  fs: parseInt('&"'"&'11'&"'"&') || 11,' & @CRLF & _
'  ts: 1447816825,' & @CRLF & _
'  tz: 10800,' & @CRLF & _
'  pd: 0,' & @CRLF & _
'  pads: 1,' & @CRLF & _
'  vcost: 7,' & @CRLF & _
'  time: [2015, 11, 18, 6, 20, 25],' & @CRLF & _
'  sampleUser: -1, spentLastSendTS: new Date().getTime(),' & @CRLF & _
'}' & @CRLF & _
'' & @CRLF & _
'window.locDomain = vk.host.match(/[a-zA-Z]+\.[a-zA-Z]+\.?$/)[0];' & @CRLF & _
'var _ua = navigator.userAgent.toLowerCase();' & @CRLF & _
'if (/opera/i.test(_ua) || !/msie 6/i.test(_ua) || document.domain != locDomain) document.domain = locDomain;' & @CRLF & _
'var ___htest = (location.toString().match(/#(.*)/) || {})[1] || '&"'"&''&"'"&', ___to;' & @CRLF & _
'if (vk.al != 1 && ___htest.length && ___htest.substr(0, 1) == vk.navPrefix) {' & @CRLF & _
'  if (vk.al != 3 || vk.navPrefix != '&"'"&'!'&"'"&') {' & @CRLF & _
'    ___to = ___htest.replace(/^(\/|!)/, '&"'"&''&"'"&');' & @CRLF & _
'    if (___to.match(/^([^\?]*\.php|login|mobile)([^a-z0-9\.]|$)/)) ___to = '&"'"&''&"'"&';' & @CRLF & _
'    location.replace(location.protocol + '&"'"&'//'&"'"&' + location.host + '&"'"&'/'&"'"&' + ___to);' & @CRLF & _
'  }' & @CRLF & _
'}' & @CRLF & _
'' & @CRLF & _
'var StaticFiles = {' & @CRLF & _
'  '&"'"&'common.js'&"'"&' : {v: 1128},' & @CRLF & _
'  '&"'"&'common.css'&"'"&': {v: 508},' & @CRLF & _
'  '&"'"&'ie6.css'&"'"&'   : {v: 26},' & @CRLF & _
'  '&"'"&'ie7.css'&"'"&'   : {v: 18}' & @CRLF & _
'  ,'&"'"&'lang0_0.js'&"'"&':{v:6675},'&"'"&'page.js'&"'"&':{v:916},'&"'"&'page.css'&"'"&':{v:775},'&"'"&'wall.js'&"'"&':{v:80},'&"'"&'wall.css'&"'"&'' & _
':{v:76},'&"'"&'pagination.js'&"'"&':{v:19},'&"'"&'notifier.js'&"'"&':{v:373},'&"'"&'notifier.css'&"'"&':{v:151}' & @CRLF & _
'}' & @CRLF & _
'</script>' & @CRLF & _
'' & @CRLF & _
'<link rel="stylesheet" type="text/css" href="/css/al/common.css?508" />' & @CRLF & _
'<!--[if lte IE 6]><style type="text/css" media="screen">/* <![CDATA[ */ @import url(/css/al/ie6.css?26); /* ]]> */</style><![endif]-->' & @CRLF & _
'<!--[if IE 7]><style type="text/css" media="screen">/* <![CDATA[ */ @import url(/css/al/ie7.css?18); /* ]]> */</style><![endif]-->' & @CRLF & _
'<link type="text/css" rel="stylesheet" href="/css/al/page.css?775"></link><link type="text/css" rel="stylesheet" href="/css/al/wall.css?76"></link><l' & _
'ink type="text/css" rel="stylesheet" href="/css/al/notifier.css?151"></link><script type="text/javascript" src="/js/loader_nav18765_0.js"></script><sc' & _
'ript type="text/javascript" src="/js/al/common.js?1128_177"></script><script type="text/javascript" src="/js/lang0_0.js?6675"></script><link rel="alte' & _
'rnate" media="only screen and (max-width: 640px)" href="http://m.vk.com/wall-40529013" /><link rel="alternate" href="android-app://com.vkontakte.andro' & _
'id/vkontakte/m.vk.com/wall-40529013" /><script type="text/javascript" src="/js/al/page.js?916"></script><script type="text/javascript" src="/js/al/wal' & _
'l.js?80"></script><script type="text/javascript" src="/js/al/pagination.js?19"></script><script type="text/javascript" src="/js/al/notifier.js?373"></' & _
'script>' & @CRLF & _
'' & @CRLF & _
'</head>' & @CRLF & _
'' & @CRLF & _
'<body onresize="onBodyResize()" class="is_rtl font_default pads ">' & @CRLF & _
'  <div id="system_msg" class="fixed"></div>' & @CRLF & _
'  <div id="utils"></div>' & @CRLF & _
'' & @CRLF & _
'  <div id="layer_bg" class="fixed"></div><div id="layer_wrap" class="scroll_fix_wrap fixed"><div id="layer"></div></div>' & @CRLF & _
'  <div id="box_layer_bg" class="fixed"></div><div id="box_layer_wrap" class="scroll_fix_wrap fixed"><div id="box_layer"><div id="box_loader"><div cla' & _
'ss="loader"></div><div class="back"></div></div></div></div>' & @CRLF & _
'' & @CRLF & _
'  <div id="stl_left"></div><div id="stl_side"></div>' & @CRLF & _
'' & @CRLF & _
'  <script type="text/javascript">domStarted();</script>' & @CRLF & _
'' & @CRLF & _
'  <div class="scroll_fix_wrap" id="page_wrap">' & @CRLF & _
'<div><div class="scroll_fix">' & @CRLF & _
'  <div id="page_layout" style="width: 791px;">' & @CRLF & _
'    <div id="page_header" class="p_head p_head_l0">' & @CRLF & _
'      <div class="back"></div>' & @CRLF & _
'      <div class="left"></div>' & @CRLF & _
'      <div class="right"></div>' & @CRLF & _
'      <div class="content">' & @CRLF & _
'        <div id="top_nav" class="head_nav">' & @CRLF & _
'  <table cellspacing="0" cellpadding="0" id="top_links">' & @CRLF & _
'    <tr>' & @CRLF & _
'      <td class="top_home_link_td">' & @CRLF & _
'        <div id="top_logo_down"></div>' & @CRLF & _
'        <a class="top_home_link" href="/feed" onmousedown="addClass('&"'"&'top_logo_down'&"'"&','&"'"&'tld_d'&"'"&');" onclick="return nav.go(this, e' & _
'vent);"></a>' & @CRLF & _
'      </td>' & @CRLF & _
'      <td class="top_back_link_td">' & @CRLF & _
'        <a class="top_nav_link fl_l" href="" id="top_back_link" onclick="if (nav.go(this, event, {back: true}) === false) { showBackLink(); return fa' & _
'lse; }" onmousedown="tnActive(this)"></a>' & @CRLF & _
'      </td>' & @CRLF & _
'      <td style=""><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="head_people" href="/search?c[section]=people" onclick="return nav.go(this, event, {search: true, noframe: true});' & _
'" onmousedown="tnActive(this)">����</a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td style=""><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="head_communities" href="/search?c[section]=communities" onclick="return nav.go(this, event, {search: true, nofram' & _
'e: true});" onmousedown="tnActive(this)">����������</a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td style=""><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="head_games" href="/apps" onclick="return nav.go(this, event, {noback: true});" onmousedown="tnActive(this)">����<' & _
'/a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td style=""><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="head_music" href="/audios196112742?act=popular" onclick="return Pads.show('&"'"&'mus'&"'"&', event);" onmousedown' & _
'="tnActive(this)">' & @CRLF & _
'          <span id="head_music_text">������</span>' & @CRLF & _
'          <div id="head_play_btn" onmouseover="addClass(this, '&"'"&'over'&"'"&');" onmouseout="removeClass(this, '&"'"&'over'&"'"&'); removeClass(th' & _
'is, '&"'"&'down'&"'"&')" onmousedown="addClass(this, '&"'"&'down'&"'"&'); addClass(ge('&"'"&'head_music'&"'"&'), '&"'"&'head_play_down'&"'"&');" onmou' & _
'seup="removeClass(this, '&"'"&'down'&"'"&')" onclick="headPlayPause(event); return Pads.show('&"'"&'mus'&"'"&', event);"></div>' & @CRLF & _
'        </a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td id="support_link_td" style=""><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="top_support_link" href="/support?act=home" onclick="return nav.go(this, event, {noback: true});" onmousedown="tnA' & _
'ctive(this)">������</a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td id="logout_link_td"><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="logout_link" href="https://login.vk.com/?act=logout&hash=122ba0536ee27df72e&_origin=http://vk.com" onclick="if (c' & _
'heckEvent(event) === false) { window.Notifier && Notifier.lcSend('&"'"&'logged_off'&"'"&'); location.href = this.href; return cancelEvent(event); }" o' & _
'nmousedown="tnActive(this)">�����</a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'    </tr>' & @CRLF & _
'  </table>' & @CRLF & _
'  <div id="ts_wrap" class="clear_fix">' & @CRLF & _
'    <div id="ts_input_wrap" class="ts_input_wrap fl_r" onmouseover="TopSearch.highlightInput(true); TopSearch.initFriendsList();" onmouseout="TopSear' & _
'ch.highlightInput(false)">' & @CRLF & _
'      <div class="ts" onmousedown="event.cancelBubble = true;">' & @CRLF & _
'        <div class="ts_input_wrap2"><div>' & @CRLF & _
'          <input type="text" onmousedown="event.cancelBubble = true;" ontouchstart="event.cancelBubble = true;" class="text" id="ts_input" autocomple' & _
'te="off" placeholder="�����" />' & @CRLF & _
'        </div></div>' & @CRLF & _
'      </div>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>' & @CRLF & _
'  <span style="display: none" id="top_new_msg"> &nbsp;<b>(</b><span>47</span><b>)</b></span>' & @CRLF & _
'</div>' & @CRLF & _
'<div id="ts_cont_wrap" ontouchstart="event.cancelBubble = true;" onmousedown="event.cancelBubble = true;"></div>' & @CRLF & _
'      </div>' & @CRLF & _
'    </div>' & @CRLF & _
'' & @CRLF & _
'    <div id="side_bar" class="fl_l" style="">' & @CRLF & _
'      <ol>' & @CRLF & _
'  <li>' & @CRLF & _
'  <table id="myprofile_table" cellspacing="0" cellpadding="0"><tr>' & @CRLF & _
'    <td id="myprofile_wrap">' & @CRLF & _
'      <a href="/id196112742" onclick="return nav.go(this, event, {noback: true})" id="myprofile" class="left_row"><span class="left_label inl_bl">���' & _
' ��������</span></a>' & @CRLF & _
'    </td>' & @CRLF & _
'    <td id="myprofile_edit_wrap">' & @CRLF & _
'      <a href="/edit" id="myprofile_edit" class="left_row"><span class="left_label inl_bl">���.</span></a>' & @CRLF & _
'    </td>'
$htmltext &= '  </tr></table>' & @CRLF & _
'</li><li id="l_fr"><a href="/friends" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row">' & _
'<span class="left_count_pad" onmouseover="Pads.preload('&"'"&'fr'&"'"&')" onmousedown="return Pads.show('&"'"&'fr'&"'"&', event)" onclick="return (che' & _
'ckEvent(event) || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_wrap  fl_r"><span class="inl_bl left_count">+2</span></span></sp' & _
'an><span class="left_label inl_bl">��� ������</span></a></li><li id="l_ph"><a href="/albums196112742" onclick="return nav.go(this, event, {noback: tru' & _
'e, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_pad" onmouseover="Pads.preload('&"'"&'ph'&"'"&')" onmousedown="' & _
'return Pads.show('&"'"&'ph'&"'"&', event)" onclick="return (checkEvent(event) || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_w' & _
'rap  left_void fl_r"><span class="inl_bl left_plus">+</span></span></span><span class="left_label inl_bl">��� ����������</span></a></li><li id="l_vid"' & _
'><a href="/video" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_cou' & _
'nt_pad" onmouseover="Pads.preload('&"'"&'vid'&"'"&')" onmousedown="return Pads.show('&"'"&'vid'&"'"&', event)" onclick="return (checkEvent(event) || b' & _
'rowser.msie6) ? true : cancelEvent(event)"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span></span><span cl' & _
'ass="left_label inl_bl">��� �����������</span></a></li><li><a href="/audios196112742" onclick="return nav.go(this, event, {noback: true, params: {_ref' & _
': '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class' & _
'="left_label inl_bl">��� �����������</span></a></li><li id="l_msg"><a href="/im" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'" & _
'left_nav'&"'"&'}});" class="left_row"><span class="left_count_pad left_count_persist" onmouseover="Pads.preload('&"'"&'msg'&"'"&')" onmousedown="r' & _
'eturn Pads.show('&"'"&'msg'&"'"&', event)" onclick="return (checkEvent(event) || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_w' & _
'rap  fl_r"><span class="inl_bl left_count">+47</span></span></span><span class="left_label inl_bl">��� ���������</span></a></li><li style="display: no' & _
'ne" id="l_nts"><a href="/notes" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span c' & _
'lass="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class="left_label inl_bl">��� �������</span></a></li><li id' & _
'="l_gr"><a href="/groups" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="' & _
'left_count_pad" onmouseover="Pads.preload('&"'"&'gr'&"'"&')" onmousedown="return Pads.show('&"'"&'gr'&"'"&', event)" onclick="return (checkEvent(event' & _
') || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_wrap  fl_r"><span class="inl_bl left_count">+1</span></span></span><span clas' & _
's="left_label inl_bl">��� ������</span></a></li><li style="display: none" id="l_ev"><a href="/events" onclick="return nav.go(this, event, {noback: tru' & _
'e, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></' & _
'span><span class="left_label inl_bl">��� �������</span></a></li><li id="l_nwsf"><a href="/feed" onclick="return nav.go(this, event, {noback: true, par' & _
'ams: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><' & _
'span class="left_label inl_bl">��� �������</span></a></li><li id="l_nws"><a href="/feed?section=notifications" onclick="return nav.go(this, event, {no' & _
'back: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_pad left_count_persist" onmouseover="Pads.preload('&"'" & _
'nws'&"'"&')" onmousedown="return Pads.show('&"'"&'nws'&"'"&', event)" onclick="return (checkEvent(event) || browser.msie6) ? true : cancelEvent(eve' & _
'nt)"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span></span><span class="left_label inl_bl">��� ������</sp' & _
'an></a></li><li id="l_set"><a href="/settings" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="le' & _
'ft_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class="left_label inl_bl">��� ���������</spa' & _
'n></a></li><div class="more_div"></div><li id="l_ap"><a href="/apps" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav' & _
''&"'"&'}});" class="left_row"><span class="left_count_pad left_count_persist" onmouseover="Pads.preload('&"'"&'ap'&"'"&')" onmousedown="return Pads.sh' & _
'ow('&"'"&'ap'&"'"&', event)" onclick="return (checkEvent(event) || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_wrap  fl_r"><sp' & _
'an class="inl_bl left_count">+22</span></span></span><span class="left_label inl_bl">����������</span></a></li><li><a href="/docs" onclick="return nav' & _
'.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class=' & _
'"inl_bl left_plus">+</span></span><span class="left_label inl_bl">���������</span></a></li><li style="display: none" id="l_ads"><a href="/ads?act=offi' & _
'ce&last=1" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap' & _
'  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class="left_label inl_bl">�������</span></a></li><div class="more_div"></div><li' & _
' id="l_app3373454"><a href="/app3373454_196112742" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&', ref: 1}})' & _
';" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class="left_label inl_bl">������' & _
'� ����</span></a></li>' & @CRLF & _
'</ol>' & @CRLF & _
'<div id="left_blocks"></div><div id="left_ads"></div>' & @CRLF & _
'    </div>' & @CRLF & _
'' & @CRLF & _
'    <div id="page_body" class="fl_r" style="width: 631px;">' & @CRLF & _
'      <div id="header_wrap2">' & @CRLF & _
'        <div id="header_wrap1">' & @CRLF & _
'          <div id="header" style="display: none">' & @CRLF & _
'            <h1 id="title"></h1>' & @CRLF & _
'          </div>' & @CRLF & _
'        </div>' & @CRLF & _
'      </div>' & @CRLF & _
'      <div id="wrap_between"></div>' & @CRLF & _
'      <div id="wrap3"><div id="wrap2">' & @CRLF & _
'  <div id="wrap1">' & @CRLF & _
'    <div id="content"><div class="full_wall_tabs t_bar clear_fix">' & @CRLF & _
'  <div class="fl_r progress" id="full_wall_progress"></div>' & @CRLF & _
'  <ul id="full_wall_filters" class="t0"><li id="wall_own_filter" class="active_link">' & @CRLF & _
'  <a href="/wall-40529013?own=1" onclick="return checkEvent(event)" onmousedown="return FullWall.go(this, event)">' & @CRLF & _
'    <b class="tl1"><b></b></b>' & @CRLF & _
'    <b class="tl2"></b>' & @CRLF & _
'    <b class="tab_word">������ ����������</b>' & @CRLF & _
'  </a>' & @CRLF & _
'</li><li id="fw_search_toggler" class="t_r"><a href="/wall-40529013?search=1">������� � ������</a></li></ul>' & @CRLF & _
'</div>' & @CRLF & _
'<div class="big_wall_post"><div class="wall_module"></div></div>' & @CRLF & _
'<div class="summary_wrap" id="fw_summary_wrap"><div class="pg_pages fl_r" id="fw_pages"><a class="pg_lnk_sel fl_l" href="/wall-40529013?own=1&offset=' & _
'0"><div class="pg_in">1</div></a><a class="pg_lnk fl_l" href="/wall-40529013?own=1&offset=20" onclick="return nav.go(this, event)"><div class="pg_in"' & _
'>2</div></a><a class="pg_lnk fl_l" href="/wall-40529013?own=1&offset=40" onclick="return nav.go(this, event)"><div class="pg_in">3</div></a><a class="' & _
'pg_lnk fl_l" href="/wall-40529013?own=1&offset=12080" onclick="return nav.go(this, event)"><div class="pg_in">&raquo;</div></a></div>' & @CRLF & _
'<div class="summary" id="fw_summary">����� 12<span class="num_delim"> </span>093 ������</div></div>' & @CRLF & _
'<div class="wall_wrap clear_fix">' & @CRLF & _
'  <div class="big_wall wide_wall_module">' & @CRLF & _
'    <div class="wall_module">' & @CRLF & _
'      <div id="page_wall_posts"><div id="post-40529013_486399" class="post post_fixed" onmouseover="wall.postOver('&"'"&'-40529013_486399'&"'"&');"on' & _
'mouseout="wall.postOut('&"'"&'-40529013_486399'&"'"&');"onclick="wall.postClick('&"'"&'-40529013_486399'&"'"&', event);" >' & @CRLF & _
'  <div class="post_table">' & @CRLF & _
'    <div class="post_image">' & @CRLF & _
'      <a class="post_image" href="/horror_tales"><img src="http://cs311631.vk.me/v311631388/5b9c/8e72T_IF54c.jpg" width="50" height="50"/></a>' & @CRLF & _
'    </div>' & @CRLF & _
'    <div class="post_info">' & @CRLF & _
'      <div class="fl_r post_actions_wrap"><div class="post_actions"><div id="post_delete-40529013_486399" class="post_delete_button fl_r" onclick="wa' & _
'll.markAsSpam('&"'"&'-40529013_486399'&"'"&', '&"'"&'f79555c17d41fcfbc1'&"'"&');" onmouseover="wall.activeDeletePost('&"'"&'-40529013_486399'&"'"&', ' & _
"'"&'������������'&"'"&', '&"'"&'post_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_486399'&"'"&', '&"'"&'post_delete'&"'"&')"' & _
'></div></div></div>' & @CRLF & _
'      <div class="wall_text"><div class="wall_text_name"><a class="author" href="/horror_tales" data-from-id="-40529013" data-post-id="-40529013_4863' & _
'99">�������� �������</a> <span class="explain">&nbsp;������ ����������</span></div> <div id="wpt-40529013_486399"><div class="page_post_sized_thumbs  ' & _
'clear_fix" style="width: 537px; height: 313px;"><a  href="/page-40529013_46371765" onclick="return showWiki({oid: -40529013, id: 46371765, hide_title:' & _
' 1}, false, event, {queue: 1});" style="width: 537px; height: 313px;" class="page_post_thumb_wrap  page_post_thumb_last_column page_post_thumb_last_ro' & _
'w"><img src="http://cs7054.vk.me/c540102/v540102388/1164e/TRPGWGKXKko.jpg" width="537" height="313" style=""  class="page_post_thumb_sized_photo" /></' & _
'a></div><div class="media_desc media_desc__">' & @CRLF & _
'  <a class="lnk"  id="post_media_lnk-40529013_486399_2" href="/page-40529013_46371765" onclick="return showWiki({oid: -40529013, id: 46371765, hide_t' & _
'itle: 1}, false, event, {queue: 1});" onmouseover="wall.postTooltip(this, '&"'"&'-40529013_486399'&"'"&', {i: '&"'"&'2'&"'"&'})">' & @CRLF & _
'    <b class="fl_l "></b>��������' & @CRLF & _
'    <span class="a">����� �������� �������</span></a><div class="post_media_link_preview_wrap inl_bl"><button class="flat_button" onclick="showWiki({' & _
'w: '&"'"&'page-40529013_46371765'&"'"&', hide_title: 1}, false, event, {queue: 1});"><span class="wall_postlink_preview_btn_label">�����������</span><' & _
'/button></div>' & @CRLF & _
'</div></div></div>' & @CRLF & _
'      <div class="post_full_like_wrap sm fl_r">' & @CRLF & _
'  <div class="post_full_like">' & @CRLF & _
'    <div class="post_like fl_r"  onmouseover="wall.postLikeOver('&"'"&'-40529013_486399'&"'"&')" onmouseout="wall.postLikeOut('&"'"&'-40529013_486399' & _
''&"'"&')" onclick="wall.like('&"'"&'-40529013_486399'&"'"&', '&"'"&'8f5ab1088baf28db9c'&"'"&'); event.cancelBubble = true;">' & @CRLF & _
'      <span class="post_like_link fl_l" id="like_link-40529013_486399">��� ��������</span>' & @CRLF & _
'      <i class="post_like_icon sp_main  fl_l" id="like_icon-40529013_486399"></i>' & @CRLF & _
'      <span class="post_like_count fl_l" id="like_count-40529013_486399">44436</span>' & @CRLF & _
'    </div>' & @CRLF & _
'    <div class="post_share fl_r "  onmouseover="wall.postShareOver('&"'"&'-40529013_486399'&"'"&')" onmouseout="wall.postShareOut('&"'"&'-40529013_48' & _
'6399'&"'"&', event)" onclick="wall.likeShareCustom('&"'"&'-40529013_486399'&"'"&'); event.cancelBubble = true;">' & @CRLF & _
'      <span class="post_share_link fl_l" id="share_link-40529013_486399">����������</span>' & @CRLF & _
'      <i class="post_share_icon sp_main fl_l" id="share_icon-40529013_486399"></i>' & @CRLF & _
'      <span class="post_share_count fl_l" id="share_count-40529013_486399">5875</span>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>' & @CRLF & _
'</div>' & @CRLF & _
'      <div class="replies"><div class="reply_link_wrap sm" id="wpe_bottom-40529013_486399">' & @CRLF & _
'  <small><a  href="/wall-40529013_486399" onclick="return showWiki({w: '&"'"&'wall-40529013_486399'&"'"&'}, false, event);" ><span class="rel_date">3' & _
'1 ��� 2013</span></a></small><span class="divide">|</span><a class="reply_link" onclick="Wall.likeShareCustom('&"'"&'-40529013_486399'&"'"&')">�������' & _
'�</a>' & @CRLF & _
'</div>' & @CRLF & _
'<div class="replies_wrap clear" id="replies_wrap-40529013_486399" style="">' & @CRLF & _
'  <div id="replies-40529013_486399"><a class="wr_header" onclick="return wall.showReplies('&"'"&'-40529013_486399'&"'"&', false, false, event);" offs' & _
'="3/79" href="/wall-40529013_486399?offset=last&f=replies">' & @CRLF & _
'  <div class="wrh_text" id="wrh_text-40529013_486399">�������� ��� 79 ������������</div>' & @CRLF & _
'  <div class="progress wrh_prg" id="wrh_prg-40529013_486399"></div>' & @CRLF & _
'</a><input type="hidden" id="start_reply-40529013_486399" value="600826" /><div id="post-40529013_600826" class="reply reply_dived clear " onmouseove' & _
'r="wall.replyOver('&"'"&'-40529013_600826'&"'"&')" onmouseout="wall.replyOut('&"'"&'-40529013_600826'&"'"&')" >' & @CRLF & _
'  <div class="reply_table">' & @CRLF & _
'    <a class="reply_image" href="/id251721594">' & @CRLF & _
'      <img src="http://cs628216.vk.me/v628216594/22bea/vkNgHQ_gHgM.jpg" width="50" height="50" class="reply_image" />' & @CRLF & _
'    </a>' & @CRLF & _
'    <div class="reply_info" >' & @CRLF & _
'      <div class="fl_r post_actions_wrap"><div class="post_actions"><div id="reply_delete-40529013_600826" class="reply_delete_button fl_r" onclick="' & _
'wall.markAsSpam('&"'"&'-40529013_600826'&"'"&', '&"'"&'63da73e4e9ae556072'&"'"&')" onmouseover="wall.activeDeletePost('&"'"&'-40529013_600826'&"'"&', ' & _
''&"'"&'������������'&"'"&', '&"'"&'reply_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_600826'&"'"&', '&"'"&'reply_delete'&"'" & _
')"></div></div></div>' & @CRLF & _
'      <div class="reply_text" >' & @CRLF & _
'        <a class="author" href="/id251721594" data-from-id="251721594">����� ������</a> <div id="wpt-40529013_600826"><div class="wall_reply_text">&q' & _
'uot;��������� ��������, �������&#33;&quot; � &quot;���: �����������&quot; ������ �������� �������&#33; ���� ������, ���, ��� ������&#33; ���))</div></' & _
'div>' & @CRLF & _
'      </div>' & @CRLF & _
'      <div class="info_footer sm" id="wpe_bottom-40529013_600826">' & @CRLF & _
'        <div class="like_wrap fl_r" onclick="wall.like('&"'"&'-40529013_wall_reply600826'&"'"&', '&"'"&'2e4941fb337156ec29'&"'"&'); event.cancelBubbl' & _
'e = true;" onmouseover="wall.likeOver('&"'"&'-40529013_wall_reply600826'&"'"&')" onmouseout="wall.likeOut('&"'"&'-40529013_wall_reply600826'&"'"&')">' & _
'  <span class="like_link fl_l" id="like_link-40529013_wall_reply600826">��� ��������</span>' & @CRLF & _
'  <i class=" fl_l" id="like_icon-40529013_wall_reply600826"></i>' & @CRLF & _
'  <span class="like_count fl_l" id="like_count-40529013_wall_reply600826">58</span>' & @CRLF & _
'</div>'
$htmltext &= '        <a class="wd_lnk"  href="/wall-40529013_486399?reply=600826" onclick="return showWiki({w: '&"'"&'wall-40529013_486399'&"'"&', reply: '&"'"&'6' & _
'00826'&"'"&'}, false, event);" ><span class="rel_date">10 ��� � 19:29</span></a>' & @CRLF & _
'      </div>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>' & @CRLF & _
'</div><div id="post-40529013_600849" class="reply reply_dived clear " onmouseover="wall.replyOver('&"'"&'-40529013_600849'&"'"&')" onmouseout="wall.r' & _
'eplyOut('&"'"&'-40529013_600849'&"'"&')" >' & @CRLF & _
'  <div class="reply_table">' & @CRLF & _
'    <a class="reply_image" href="/id155008242">' & @CRLF & _
'      <img src="http://cs624222.vk.me/v624222242/54c6a/6fbF613FY-s.jpg" width="50" height="50" class="reply_image" />' & @CRLF & _
'    </a>' & @CRLF & _
'    <div class="reply_info" >' & @CRLF & _
'      <div class="fl_r post_actions_wrap"><div class="post_actions"><div id="reply_delete-40529013_600849" class="reply_delete_button fl_r" onclick="' & _
'wall.markAsSpam('&"'"&'-40529013_600849'&"'"&', '&"'"&'f84c6e249783893f0f'&"'"&')" onmouseover="wall.activeDeletePost('&"'"&'-40529013_600849'&"'"&', ' & _
''&"'"&'������������'&"'"&', '&"'"&'reply_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_600849'&"'"&', '&"'"&'reply_delete'&"'"& _
')"></div></div></div>' & @CRLF & _
'      <div class="reply_text" >' & @CRLF & _
'        <a class="author" href="/id155008242" data-from-id="155008242">������ �������</a> <div id="wpt-40529013_600849"><div class="wall_reply_text">' & _
'� � ���������&#33;^�^� ��������� ��� ������� ���������� ��������&#33;&#33;&#33;</div></div>' & @CRLF & _
'      </div>' & @CRLF & _
'      <div class="info_footer sm" id="wpe_bottom-40529013_600849">' & @CRLF & _
'        <div class="like_wrap fl_r" onclick="wall.like('&"'"&'-40529013_wall_reply600849'&"'"&', '&"'"&'98d43e5825426b7dbf'&"'"&'); event.cancelBubbl' & _
'e = true;" onmouseover="wall.likeOver('&"'"&'-40529013_wall_reply600849'&"'"&')" onmouseout="wall.likeOut('&"'"&'-40529013_wall_reply600849'&"'"&')">' & _
'  <span class="like_link fl_l" id="like_link-40529013_wall_reply600849">��� ��������</span>' & @CRLF & _
'  <i class=" fl_l" id="like_icon-40529013_wall_reply600849"></i>' & @CRLF & _
'  <span class="like_count fl_l" id="like_count-40529013_wall_reply600849">210</span>' & @CRLF & _
'</div>' & @CRLF & _
'        <a class="wd_lnk"  href="/wall-40529013_486399?reply=600849" onclick="return showWiki({w: '&"'"&'wall-40529013_486399'&"'"&', reply: '&"'"&'6' & _
'00849'&"'"&'}, false, event);" ><span class="rel_date">10 ��� � 19:36</span></a>' & @CRLF & _
'      </div>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>' & @CRLF & _
'</div><div id="post-40529013_602361" class="reply reply_dived clear " onmouseover="wall.replyOver('&"'"&'-40529013_602361'&"'"&')" onmouseout="wall.r' & _
'eplyOut('&"'"&'-40529013_602361'&"'"&')" >' & @CRLF & _
'  <div class="reply_table">' & @CRLF & _
'    <a class="reply_image" href="/id166275243">' & @CRLF & _
'      <img src="http://cs309827.vk.me/v309827243/98ef/NyLRy9ik1_g.jpg" width="50" height="50" class="reply_image" />' & @CRLF & _
'    </a>' & @CRLF & _
'    <div class="reply_info" >' & @CRLF & _
'      <div class="fl_r post_actions_wrap"><div class="post_actions"><div id="reply_delete-40529013_602361" class="reply_delete_button fl_r" onclick="' & _
'wall.markAsSpam('&"'"&'-40529013_602361'&"'"&', '&"'"&'918d02adf0c2058c75'&"'"&')" onmouseover="wall.activeDeletePost('&"'"&'-40529013_602361'&"'"&', ' & _
''&"'"&'������������'&"'"&', '&"'"&'reply_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_602361'&"'"&', '&"'"&'reply_delete'&"'" & _
')"></div></div></div>' & @CRLF & _
'      <div class="reply_text" >' & @CRLF & _
'        <a class="author" href="/id166275243" data-from-id="166275243">��� �������</a> <div id="wpt-40529013_602361"><div class="wall_reply_text">���' & _
'��� � ������� ������ ��� ������� ���� ���)) revenge 1,2 �����</div></div>' & @CRLF & _
'      </div>' & @CRLF & _
'      <div class="info_footer sm" id="wpe_bottom-40529013_602361">' & @CRLF & _
'        <div class="like_wrap fl_r" onclick="wall.like('&"'"&'-40529013_wall_reply602361'&"'"&', '&"'"&'ca4a1783c47f5d14f7'&"'"&'); event.cancelBubbl' & _
'e = true;" onmouseover="wall.likeOver('&"'"&'-40529013_wall_reply602361'&"'"&')" onmouseout="wall.likeOut('&"'"&'-40529013_wall_reply602361'&"'"&')">' & _
'  <span class="like_link fl_l" id="like_link-40529013_wall_reply602361">��� ��������</span>' & @CRLF & _
'  <i class=" fl_l" id="like_icon-40529013_wall_reply602361"></i>' & @CRLF & _
'  <span class="like_count fl_l" id="like_count-40529013_wall_reply602361">21</span>' & @CRLF & _
'</div>' & @CRLF & _
'        <a class="wd_lnk"  href="/wall-40529013_486399?reply=602361" onclick="return showWiki({w: '&"'"&'wall-40529013_486399'&"'"&', reply: '&"'"&'6' & _
'02361'&"'"&'}, false, event);" ><span class="rel_date">15 ��� � 2:26</span></a>' & @CRLF & _
'      </div>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>' & @CRLF & _
'</div></div>' & @CRLF & _
'  ' & @CRLF & _
'</div></div>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>' & @CRLF & _
'  ' & @CRLF & _
'</div><div id="post-40529013_603875" class="post" onmouseover="wall.postOver('&"'"&'-40529013_603875'&"'"&');"onmouseout="wall.postOut('&"'"&'-405290' & _
'13_603875'&"'"&');"onclick="wall.postClick('&"'"&'-40529013_603875'&"'"&', event);" >' & @CRLF & _
'  <div class="post_table">' & @CRLF & _
'    <div class="post_image">' & @CRLF & _
'      <a class="post_image" href="/horror_tales"><img src="http://cs311631.vk.me/v311631388/5b9c/8e72T_IF54c.jpg" width="50" height="50"/></a>' & @CRLF & _
'      ' & @CRLF & _
'    </div>' & @CRLF & _
'    <div class="post_info">' & @CRLF & _
'      <div class="fl_r post_actions_wrap"><div class="post_actions"><div id="post_delete-40529013_603875" class="post_delete_button fl_r" onclick="wa' & _
'll.markAsSpam('&"'"&'-40529013_603875'&"'"&', '&"'"&'6a96264a8999e6ff7b'&"'"&');" onmouseover="wall.activeDeletePost('&"'"&'-40529013_603875'&"'"&', ' & _
"'"&'������������'&"'"&', '&"'"&'post_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_603875'&"'"&', '&"'"&'post_delete'&"'"&')"' & _
'></div></div></div>' & @CRLF & _
'      <div class="wall_text"><div class="wall_text_name"><a class="author" href="/horror_tales" data-from-id="-40529013" data-post-id="-40529013_6038' & _
'75">�������� �������</a></div> <div id="wpt-40529013_603875"><div class="wall_post_text">������ ����������<br><br>����� � ������ ����� ���� ���� �����' & _
'����, ��������� � � �������. ��� � � ����� ��������� ������� ����� �������� ������ �������, ��� 15-�� ����� ������� ������� ������ ����� � ����� ����' & _
'���� �������� ���� � ��������, ��� � ������ �������� ����� ��������� �����, ����� �������� � ���������� ������� ��������, � ������������ �� ������ ��' & _
'���� ���� �������� ���� �����.<br><a class="wall_post_more" onclick="hide(this, domPS(this)); show(domNS(this));">�������� ���������..</a><span style=' & _
'"display: none"> �����&#33;<br><br></span></div><div class="page_post_sized_thumbs  clear_fix" style="width: 537px; height: 231px;"><a  onclick="retur' & _
'n showPhoto('&"'"&'-40529013_387714054'&"'"&', '&"'"&'wall-40529013_603875'&"'"&', {&quot;temp&quot;:{&quot;base&quot;:&quot;http://cs627516.vk.me/v62' & _
'7516342/&quot;,&quot;x_&quot;:[&quot;26f4e/aOEZBrUSFXA&quot;,604,260]},queue:1}, event)" style="width: 537px; height: 231px;" class="page_post_thumb_w' & _
'rap  page_post_thumb_last_column page_post_thumb_last_row"><img src="http://cs627516.vk.me/v627516342/26f4e/aOEZBrUSFXA.jpg" width="537" height="231" ' & _
'style=""  class="page_post_thumb_sized_photo" /></a></div></div></div>' & @CRLF & _
'      <div class="post_full_like_wrap sm fl_r">' & @CRLF & _
'  <div class="post_full_like">' & @CRLF & _
'    <div class="post_like fl_r"  onmouseover="wall.postLikeOver('&"'"&'-40529013_603875'&"'"&')" onmouseout="wall.postLikeOut('&"'"&'-40529013_603875' & _
''&"'"&')" onclick="wall.like('&"'"&'-40529013_603875'&"'"&', '&"'"&'2c26a44d2f5f36046c'&"'"&'); event.cancelBubble = true;">' & @CRLF & _
'      <span class="post_like_link fl_l" id="like_link-40529013_603875">��� ��������</span>' & @CRLF & _
'      <i class="post_like_icon sp_main  fl_l" id="like_icon-40529013_603875"></i>' & @CRLF & _
'      <span class="post_like_count fl_l" id="like_count-40529013_603875">294</span>' & @CRLF & _
'    </div>' & @CRLF & _
'    <div class="post_share fl_r "  onmouseover="wall.postShareOver('&"'"&'-40529013_603875'&"'"&')" onmouseout="wall.postShareOut('&"'"&'-40529013_60' & _
'3875'&"'"&', event)" onclick="wall.likeShareCustom('&"'"&'-40529013_603875'&"'"&'); event.cancelBubble = true;">' & @CRLF & _
'      <span class="post_share_link fl_l" id="share_link-40529013_603875">����������</span>' & @CRLF & _
'      <i class="post_share_icon sp_main fl_l" id="share_icon-40529013_603875"></i>' & @CRLF & _
'      <span class="post_share_count fl_l" id="share_count-40529013_603875">23</span>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>' & @CRLF & _
'</div>' & @CRLF & _
'      <div class="replies"><div class="reply_link_wrap sm" id="wpe_bottom-40529013_603875">' & @CRLF & _
'  <small><a  href="/wall-40529013_603875" onclick="return showWiki({w: '&"'"&'wall-40529013_603875'&"'"&'}, false, event);" ><span class="rel_date">�' & _
'������ � 3:04</span></a></small><span class="divide">|</span><a class="reply_link" onclick="Wall.likeShareCustom('&"'"&'-40529013_603875'&"'"&')">����' & _
'����</a>' & @CRLF & _
'</div>' & @CRLF & _
'<div class="replies_wrap clear" id="replies_wrap-40529013_603875" style="display: none">' & @CRLF & _
'  <div id="replies-40529013_603875"><input type="hidden" id="start_reply-40529013_603875" value="" /></div>' & @CRLF & _
'  ' & @CRLF & _
'</div></div>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>'
$htmltext &='�������' & @CRLF & _
			'' & @CRLF & _
			'� ������ �� ������� � ������� 1988 ���� �� 18-� ����������� ������� ������� ������������� ������, � ����� ������������ ������ �����, ��� � ������� ����. � ��� ����, ����� � ������� ����� �������� �������, ���� ����� ���� ���� �������� �� �ϻ. � ������ ����� �ϸ��.' & @CRLF & _
			'' & @CRLF & _
			'ϸ�� ����� �������� � ������ ����������. ����� ���, ��� ���� ��������. �� ��� ����� � ��� �� ������� ����������� �������� ����. ������� ��� �������, ������� �������� � ������ ������ ��������. ��� ��������� ���������� ������, ������� ����. �� ������ ���� ������ ������� ������ ����� �������� � ������� �� ���. �������, ���� ������ � ������������, �� ����� �� �������������.' & @CRLF & _
			'' & @CRLF & _
			'� ��� ���-�� ������� ������� � �������� ��������������� ������� ����! ����� ���� ������ ������� ���� ��� ���������� ����������. ����-69� ������ ����� ���� ��������� ������ �� ������� ����. � ��� ������� ����������, ϸ�� � ���� ������ ��� ����������. �� �������, ���, ������ �����, ����� ������� ������� � ������� �� �� ��� ��� ����������. �� ���� ���� ���������.' & @CRLF & _
			'' & @CRLF & _
			'�� ������ ����� ���� ������ ����� ��������. �� ������ �����������: � ����� ���� �� ���� � ������� ��������, ������� � ������. ������ �� ���-�� �������� �� ������� ����, ��� ����� ������ ����� ����. ���� ��������� ����� ��� � ������� ������� ����. �� � ϸ��� ����� ����� �� �������� (��� ����� ��� ��������� �� ����), � ��� � ������ ����� �� ������� ���� ���������� ������. �������. �������, ����������� ������������, ������ ������, �� ����� ��������� ������. ���-�� ���� ���� �� ��� � ��� ������ ��� ������... ����� � �� ���� ����������� �����, � ��� ����.' & @CRLF & _
			'' & @CRLF & _
			'������� �������� ����� �� ���� � ����� � ������ ������-�� ������� ������ (��� ���������� ���� ��������� ��������� �������), ��� ���������, �� ���� �� ����������� � ���� �� ���� �������������. � ����������� � ������ ������ � �������� �� ���. ϸ�� ����� � ��� � ����� �����. � ������, ��� ������� ��� ������� ��� �������, �� ������ ��������� �� ���������. ������� �������� ������ �� ��������� � ���� �������������. �� ����� � ���� ���� ���-��, ������� �� ������ �� ��������� ���, ��� ���� ������ ���������� �������� ����. �� ������� �� ������ ������� ������� �������, ������, �� ����� ����� �� �������������. ������ �� ��������� ����� � ������. ����, ����������.' & @CRLF & _
			'' & @CRLF & _
			'���� � �������������� �������, � ����� ��-�� ������ � ������ ��������:' & @CRLF & _
			'' & @CRLF & _
			'� ����! ������ � �� �����!' & @CRLF & _
			'' & @CRLF & _
			'� ���� �� �������, ��� � ��� ����� ��������� ������, ������� ��� ������ ��������. ������� �� ��������� � �����, �� �� ��� ������ ��� ����� ��� �����, � ϸ��. ������ ��������� ������� ������ � ���� �� ����������� ��� ������� �� ������ ��� ������. ���� ��� ��������. ���� ���� ������� ��� ���� ������� � ���� �����������, �� �����������, � � ��� ������ ������ � ������. �������� �� �������, ������� ���������� ���������� �� ����� � ������� ��� �� �����, ���� � �� ������� � �������� ����� �� ������ ��� ��������� �� �����. �� ���������.' & @CRLF & _
			'' & @CRLF & _
			'�������� �����, � ���-��� ������ ���� ��������� ���� � ��������� ��������� ������. ����� ��� ����� ����. ������ � ������ �����. ���� ���� ���� ���������� ������, �� ������, ������, ������� ������. �� ���������� � ������ ��� ����������� ������ � ��������� ���������� �� �������. ��� ������ ���� ��������� �����������. ��� �� ��� ������ ������� �����. �� � ϸ�� ��� ��� ������ � ���� ���, ���� ������ ��������� ��� � ���������. ������� � �������� ���� ������� ��� ����, ������ ���������� �, ��������, ������� ���� ������? ���. �� ���� ����� � ��.' & @CRLF & _
			'' & @CRLF & _
			'������ ������ ������ (� ��� ���� ������ ���������� �����, ���� �� ��� ��������� ��������� ���������; � �����, ��� ��, ��������, ����������, �� ��� ������� ����), � ����������� �������� ���������� ������ ��� � �������. �� ����� ��������� �� ����, ����� ��������� ����� �����, �� ������ ��� ������ � ����� � ���������� ���.' & @CRLF & _
			'' & @CRLF & _
			'� ����������? � ������� �.' & @CRLF & _
			'' & @CRLF & _
			'� ���, ����������, ��***, � �� �������.' & @CRLF & _
			'' & @CRLF & _
			'������� ��-������ �� ��������� ��� �������. � ����� �����������, �� ����� ����� ����� �������� � ��� � ������ ���� ��� ����� ����, �������� �����.' & @CRLF & _
			'' & @CRLF & _
			'� �����!' & @CRLF & _
			'' & @CRLF & _
			'� ��� � �����?' & @CRLF & _
			'' & @CRLF & _
			'� �� ���� �������, � ������� �������? ������� ������ �������?!!' & @CRLF & _
			'' & @CRLF & _
			'�� �������� �� �� ��� �� ����, � ���� �� ����. �����, ���������? ��� �������������, ����� �������� ������������? �� ���� ���-���� ��������� ��� ������ ����������...' & @CRLF & _
			'' & @CRLF & _
			'� ��, ����� ����������, ��������. ����-�� ���?' & @CRLF & _
			'' & @CRLF & _
			'� �������, ���� ����, �������! � ��� � ������ ������ ��� � ����� ������� ����, ����� �� ��������! ������, ������ ������!!!' & @CRLF & _
			'' & @CRLF & _
			'� � �� ���� ������������-��? � ��� ������ ������ �� �����. ������ ��������, ��� �� �����, ����� � ������. ����� � ���� ���, ������� ������, ��� ����� ������ ��������� ������.' & @CRLF & _
			'' & @CRLF & _
			'� �� ���������, ��? � �� �������, ���� ���� ������ ����� �� �����! �� ���� ������, ��� �� ���������?' & @CRLF & _
			'' & @CRLF & _
			'� ����� �����-�� ��������, � ���?' & @CRLF & _
			'' & @CRLF & _
			'� �����������! ������ �����������?! �� �� ������ ����������! ������ �� ����� � �� ����� �� ����, �� ����, �� ����� ��������� �����! ��� ����� ���������, ��� ������! ����� ���� ����� ��� ��� �����������... ������!!!' & @CRLF & _
			'' & @CRLF & _
			'� � ��� ���� ��� ������. � ���� ������ ��� �� ���������.' & @CRLF & _
			'' & @CRLF & _
			'� �� �����, ������, ������! ���� �� � �� ���� ������ �����, ���� �� ��� �� ����� �������� ���� � ����� ���. ����� �� ���� ������ �� �����! ������, ������, ��������� ��, ����� ����� �������� ����! � ��� �� ������� ���������, ��?! � ����! �������, � �� ����, ��� �� ����� ���-��? ���! ��� ���� ����������� ����� � ������ ��� ��������! ������ ���, ��� ��, �� �����! ��� � ����... � ������ ��, ��... �� ����� �� ������, �� ������ ���� � ����� ���������! � ��� ��������, ������, ������ �� ���� �������� ���������� �����, ��� ��� �����... ������ ������!' & @CRLF & _
			'' & @CRLF & _
			'����� ����� ��������� � ���������, ����������� �����-�� �� �����, ���� ��������. � ��� � ����������... �����, ����������� �����. ������� ������ �������, � � ����������� � ��� ��� � �������, �� ����� ������ ������������� ����� ��������� ����������. ����� ������, ������ ������ ������ ����, ��� ���������� � ���� ����������. � ��������� �������� ϸ�� �� �����. ���� ������ ��-�� ����������� � � ����� �� ��� ����� ������ � ������� �� ������� ������. �� ���� ���� �������. � �� �� ����� ������� ���, �� ������� ������� ��� ���������. ���� ������ ���� ���������, ���� �����-�� �� �����. � ��� ������ �� ����������� � �� � ���� �� ���� ����� ����������...' & @CRLF & _
			'' & @CRLF & _
			'� ���� ������! � ����� ������� ������ ��������� ����.' & @CRLF & _
			'' & @CRLF & _
			'� �����, ���� ��� � ������� ����? ��� �����������?' & @CRLF & _
			'' & @CRLF & _
			'� ����. ������. �. ������. ������, � �� ������� ���, ��� ����� ���������� �����.' & @CRLF & _
			'' & @CRLF & _
			'� ���� ����� ������ �� ����. ����� ��� ������, ���������� � � ϸ�� ����� �������� �������.' & @CRLF & _
			'' & @CRLF & _
			'� ��������� ������ ������. ����� ��������� ���� ������ �� ����� � ����� � ������� ����.' & @CRLF & _
			'' & @CRLF & _
			'� ����, ���� ��� ��������� � ���������. � ��� ������ �� ����������.' & @CRLF & _
			'' & @CRLF & _
			'� �� ��, ��� � �������. ������ ��� � ����� ������... ��� ���� ���� ������. �� ���� ������, ������� ���� ��������� �� ���������� ���������? �� ���� ������� ������. �, ����, ������, � �� �������. � ���� ���� �� ��������.' & @CRLF & _
			'' & @CRLF & _
			'� ���� �����. ��������� �� ���� ����.' & @CRLF & _
			'' & @CRLF & _
			'�� �������� ��� � ������� ����. ������ ����� �����������, ����� ����� ������� � �����. ������ ����� ����������� ��� ������ � �����, ��� ������� ���������� �� ����� ���. � �����, ��� ��� �� ����. � �����, � ��� �������, � ������� �����, ��� ����� ��������� ������� ������� ��������� ��������� �������. � �� ��� ��������� ����, �� ��� ����� �������� ��������, ������������, ����� � ��� � � �������, ������� �� ������ �����. ������� �������, � ������� ���������� � ������, ��� ����� ��� ����� � ������� ����. � �� ���� ��� ��������, � ������� ����� �� ���.' & @CRLF & _
			'' & @CRLF & _
			'�� ������������ ������� �� �������, ϸ�� ������� ��������, ��� ���� ���������. ���������� ��� ���� ���������... � ����� ����������� � ����, � ������. ������, � 35 ��� ���� ��������� �� �����, ���� � � ��������� �������. �� �� �����...' & @CRLF & _
			'' & @CRLF & _
			'� ��� ��� ������ ��� ����� ���. ������ ���� � ������, ������� �� ������ �����, �������. ����� ������: �, ���� � ϸ�� � �� ���������� ���.' & @CRLF & _
			'' & @CRLF & _
			'� ����� (� ��� � �� ����� ��� ���������� �����) ���������� �� ��������������, �� ���� ������������� �������, ����� ����� �� ������ � ������ ������������ ������� ��������. �� ��, ��� �� ��� ��������... � ���� ���-�� ����������� � ���, �������� � ����, ������ �����, ������������ �����. ����� � ��� ��� ��������� ��������, �� ������ � ����� ����� ���-�� �����:' & @CRLF & _
			'' & @CRLF & _
			'� ������ ������� ���� ���� ������, ���� ��� ����.' & @CRLF & _
			'' & @CRLF & _
			'� ���, �������� �������� ����, ��������... ����� ���������� ���������� �� ����� �� � ����?' & @CRLF & _
			'' & @CRLF & _
			'�� ����������. ��� ����� ���-�� �� ������ ��� �������� �� ��� ����. �� ���� �� ���� �� � ��������� �� ��������, ��� ����� � �� ���� ��� ��������.' & @CRLF & _
			'' & @CRLF & _
			'� ����� ��� �����, ��������� �� ����. � ������� �������. ����� � ���� ������ � � � ����������� ����� �� ��� ���������, ������� ������� � ���� ������ ��� ��� ����. � ������ ������. ����� �� ����� ��� �����.' & @CRLF & _
			'' & @CRLF & _
			'P. S. ������� ��������, �� ����� � ��������� ��������.'
	Return $htmltext
EndFunc   ;==>_htmltext



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
	$text = StringRegExpReplace($text, '([\r\n])[\s]+', @CRLF)

	; ���� ����������� ������� ����������. ���� ���� � UTF8 �� � �� ����� ���� ��������� �������, ������� ��� ���������� � ASCI ����� ���������
	$text = StringRegExpReplace($text, '[��]', '"') ; ������������ �������
	$text = StringReplace($text, ChrW(160), ' ') ; �������� ������ 160 �� ������ 32
	$text = StringReplace($text, ChrW(8226), '') ; ������� ���������
	$text = StringReplace($text, ChrW(8211), '-') ; ������� ���� �� ���������� �����
	$text = StringReplace($text, ChrW(8230), '...') ; ��������� �� ��� �����
	$text = StringReplace($text, ChrW(8212), '-') ; ����� ������� ���� �� ��������

	Return $text
EndFunc   ;==>_HTMLTransSymb

Func _HTMLTransSymbOld($text)
	; ������ ��������� ����� ������������ ������������, � �� �� ����� ���� ������
	$text = StringRegExpReplace($text, '&quot;', '"')
;~ If Not @error Then $log &= @extended & '   quot' & @CRLF

	$text = StringRegExpReplace($text, '&amp;', '&')
;~ If Not @error Then $log &= @extended & '   amp;' & @CRLF

	$text = StringRegExpReplace($text, '&lt;', '<')
;~ If Not @error Then $log &= @extended & '   lt' & @CRLF

	$text = StringRegExpReplace($text, '&gt;', '>')
;~ If Not @error Then $log &= @extended & '   gt' & @CRLF

	$text = StringRegExpReplace($text, '&nbsp;', ' ')
;~ If Not @error Then $log &= @extended & '   nbsp' & @CRLF

	$text = StringRegExpReplace($text, '&iexcl;', '&#161;')
;~ If Not @error Then $log &= @extended & '   iexcl' & @CRLF

	$text = StringRegExpReplace($text, '&cent;', '&#162;')
;~ If Not @error Then $log &= @extended & '   cent' & @CRLF

	$text = StringRegExpReplace($text, '&pound;', '&#163;')
;~ If Not @error Then $log &= @extended & '   pound' & @CRLF

	$text = StringRegExpReplace($text, '&copy;', '&#169;')
;~ If Not @error Then $log &= @extended & '   copy' & @CRLF

	; ������ ������ ������� ���������� �������� �����
	$a = StringRegExp($text, '&#(\d+);', 3)
	If Not @error Then
;~     $log &= UBound($a) & '   &#(\d+);' & @CRLF
		$a = _ArrayUnique($a)
		For $i = 1 To $a[0]
			$a[$i] = Number($a[$i])
		Next
		_ArraySort($a, 1, 1) ; ����� �� ��������� � ������� ����� 853 ������ 85
		; _ArrayDisplay($a, "������ ����� ���������� �� ��������")
		For $i = 1 To $a[0]
			$text = StringReplace($text, '&#' & $a[$i] & ';', ChrW($a[$i]))
		Next
	EndIf


	; i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!

	; ���� ����������� ������� ����������. ���� ���� � UTF8 �� � �� ����� ���� ��������� �������, ������� ��� ���������� � ASCI ����� ���������
	$text = StringRegExpReplace($text, '[��]', '"') ; ������������ �������
;~ If Not @error Then $log &= @extended & '   ������� � �' & @CRLF

	$text = StringReplace($text, ChrW(160), ' ') ; �������� ������ 160 �� ������ 32
;~ If @extended Then $log &= @extended & '   ������' & @CRLF

	$text = StringReplace($text, ChrW(8226), '') ; ������� ���������
;~ If @extended Then $log &= @extended & '   � > ' & @CRLF

	$text = StringReplace($text, ChrW(8211), '-') ; ������� ���� �� ���������� �����
;~ If @extended Then $log &= @extended & '   - > -' & @CRLF

	$text = StringReplace($text, ChrW(8230), '...') ; ��������� �� ��� �����
;~ If @extended Then $log &= @extended & '   ...' & @CRLF

	$text = StringReplace($text, ChrW(8212), '-') ; ����� ������� ���� �� ��������
;~ If @extended Then $log &= @extended & '   - > -' & @CRLF

	; i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!

	Return $text
EndFunc   ;==>_HTMLTransSymbOld

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
