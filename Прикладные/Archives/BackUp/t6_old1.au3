
#include <array.au3>
;~ #Include <FileOperations.au3>
$BadArticle = '486399'
$SearchWall = '40529013'
;~ $oLinks = _IELinkGetCollection($oIE)
$sMyString = 'http://vk.com'
$oLink = 'http://vk.com/wall-40529013_486399?reply=602361'
;~ $oLink = 'http://vk.com/wall-40529013_603636'

;~ if StringRegExp($oLink, 'http://vk.com/wall-'&$SearchWall&'_[0-9]*$') Then ConsoleWrite(9087948359437598437)
 $CLEAR='p|span|div|body|br|table|td|tr|b|img|html'
 $DELETE='m:|o:|/o:|w:|v:|/v:|!\[endif\]|!\[if|head|/head|meta|link|!--'
 $TWIN='xml|style'

$text = '����� ����� �������� ������, �� ������ ���������� ������� � ��������� ��������. ��������� � ���������� ��� �������  � ������ ��������� � ���������!' & @CRLF & _
		'�������! ��������� � ���������� ���� ���������. � ��� ����� ���������� � ������� �����������, ������� ��������� ��� ��� ���������� ������� � ��������� ��������, ����� ����� �������� ������ � ������ ���.' & @CRLF & _
		'a &#161; b &iexcl; The ?? federal government on Wednesday said Apple has agreed to pay at least $32.5 million in refunds to parents who didn�t authorize hefty purchases racked up by their children on their iPhones and iPads.'
$text &= _htmltext()
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

$text = _HTMLTransSymb($text)

;~ $text = _ClearHTML($text)
;~ $TEXT=_StringStripTags($TEXT,$CLEAR,$DELETE,$TWIN)
;~ $text=StringRegExpReplace($text, '</?\w+((\s+\w+(\s*=\s*(?:".*?"|''.*?''|[^''">\s]+))?)+\s*|\s*)/?>', '')
;~ $text=StringRegExpReplace($text,'<(?!/?pre).*?>','')
$text = StringLower($text) ; ������ � ������ ��������
$text = StringReplace($text,@CR,' ')
$text = StringReplace($text,@LF,' ')
$text = StringReplace($text,'�','�') ; �������� ��� � �� �
$text = StringRegExpReplace($text,'[^a-z�-�� ]','') ; ��� ��������, ��� ����, � 1 ������
; �������� ����-���� (����� �������)
$text = StringRegExpReplace($text, '(?m)( |^)(�|���|�����|��|���|����|����|����|����|�|���|���|����|��|���|���|�����|����|��|���|��|����|���|��|���|��|����|����'& _
'|���|��|��|�����|�|��|��-��|���|��|��|�|���|���-��|��|�����|���|��|����|���|�����|��|��|����|���|��|����|��|���|��'& _
'|���|��|��|�|��|������|��|���|���|���|��|�����|��|���|���|�|��|���|�����|�����|���|��|���|��|����|����|���|������|���'& _
'|��|�|���|����|����|���|���|���|�����|���|���|���|���|���|�|���|�|�|�������|�������|����|��������|���|���|�����|�������'& _
'|����|���|����|����|���|����|����|�������|��|���|����|����|�����|������|���|����|�����|������|������|������|�����|������'& _
'|����������|�|�� �����������|�����|�����|���|���|��������|������|�����|������|������ ���|�����|���|�����|�����|���|����-��)( |$)', ' ')
$text = StringRegExpReplace($text,'(?m)( |^)[^ ]{0,2}( |$)',' ') ; ������� �� ��� ������ ���� ��������
$text = StringRegExpReplace($text,'(?m)( |^)[^ ]{0,2}( |$)',' ') ; ������� �� ��� ������ ���� ��������
$text = StringRegExpReplace($text,'(?m)( |^)[^ ]{0,2}( |$)',' ') ; ������� �� ��� ������ ���� ��������

$text = StringRegExpReplace($text, '( ){2}', ' ')


ConsoleWrite($text & @CRLF)
;~ ClipPut($text)

; ����� �� http://www.cyberforum.ru/algorithms/thread55.html ������������� ���������� ����� �� �������� ����� (������� �������).
$ADJECTIVE = '(?m)( |^)([a-z�-��]*?(��|��|��|��|���|���|��|��|��|��|��|��|��|��|���|���|���|���|��|��|��|��|��|��|��|��))( |$)'; ��������������
$ADJECTIVE = '(?m)( |^)([a-z�-��]*?(��|��|��|��|���|���|��|��|��|��|��|��|��|���|���|���|���|��|��|��|��|��|��|��|��))( |$)'; ��������������
;~ $PARTICIPLE = '(?m)( |^)((���|���|���)|(([��])(��|��|��|��|�)))( |$)'; ���������
$PARTICIPLE = '(?m)( |^)([a-z�-��]*?((���|���|���)|[��](��|��|��|��|�)))( |$)'; ���������
;������
$VERB = '(?m)( |^)([a-z�-��]*?((���|���|���|����|����|���|���|���|��|��|��|��|��|��|��|���|���|���|��|���|���|��|��|���|���|���|���|��|�)|([��](��|��|���|���|��|�|�|��|�|��|��|��|��|��|��|���|���))))( |$)';
$VERB = '(?m)( |^)([a-z�-��]*?((���|���|���|����|����|���|���|���|��|��|��|��|��|��|���|���|���|��|���|���|��|��|���|���|���|���|��)|([��](��|��|���|���|��|�|�|��|��|��|��|��|��|���|���))))( |$)';
$NOUN = '(?m)( |^)([a-z�-��]*?(�|��|��|��|��|�|����|���|���|��|��|�|���|��|��|��|�|���|��|���|��|��|��|�|�|��|���|��|�|�|��|��|�|��|��|�))( |$)'; ���������������
;~ $RVRE = '/^(.*?[���������])(.*)$/'; ���� �� ����� ����� ���� �������
;~ $DERIVATIONAL = '(?m)( |^)([a-z�-��]*?[^��������� ][���������]+[^��������� ]+[���������][^ ]*?�?���?)( |$)'; �������

StringSplit($text,' ')

$aADJECTIVE = StringRegExp($text,$ADJECTIVE,3)
$aADJECTIVE = _ClearStrregexpArray($aADJECTIVE,1,4)
$aVERB = StringRegExp($text,$VERB,3)
$aVERB = _ClearStrregexpArray($aVERB,1,7)
$aNOUN = StringRegExp($text,$NOUN,3)
$aNOUN = _ClearStrregexpArray($aNOUN,1,4)
;~ $aDERIVATIONAL = StringRegExp($text,$DERIVATIONAL,3)
;~ $aDERIVATIONAL = _ClearStrregexpArray($aDERIVATIONAL,1,3)
;~ _ArrayDisplay($aADJECTIVE)

; ��������� �� �������������� � �������� ���� ������� �����
$aText = StringSplit($text,' ')
local $atext2[$atext[0]+1]
$schet = 1
For $i=1 to $atext[0]
	if StringLen($atext[$i])<=3 then
		if StringRegExp($atext[$i],$NOUN) then
			$atext2[$schet] = $atext[$i]
			$schet+=1
		elseif StringRegExp($atext[$i],$ADJECTIVE) then
			;���������� ��������������
		elseif StringRegExp($atext[$i],$VERB) then
			;���������� ������
		Else
			; ���� �� ���������� ����� ���� ������ ��� �����
			$atext2[$schet] = $atext[$i]
			$schet+=1
		EndIf
	Else
		; ������ ��� �������� �����, �.�. ���������� �� ����� ���� �� ��� ������
		$atext2[$schet] = $atext[$i]
		$schet+=1
	EndIf

Next
$atext2 = _ArrayClearEmpty($atext2, 0, 1)
$atext2[0] = UBound($atext2)-1
_ArrayDisplay($atext2)

;������� ���������
$endings = "(?m)( |^)([a-z�-��]*?)(�|�|��|��|��|��|��|���|��|�|��|��|��|��|��|���|�|�|�|�|���|���|�|��|��|��|��|�|�|��|��|��)( |$)"
For $i=1 to $atext2[0]
	$temp = StringRegExpReplace($atext2[$i],$endings,'$1$2$4')
	if StringLen($temp)>2 then $atext2[$i] = $temp
Next
_ArrayDisplay($atext2)



Func _StringStripTags($sStr,$CLEAR='',$DELETE='',$TWIN='')
  If $CLEAR<>'' Then $sStr=StringRegExpReplace($sStr,'(?s)<('&$CLEAR&')(.*?)>','<\1>')
  If $DELETE<>'' Then $sStr=StringRegExpReplace($sStr,'(?s)<('&$DELETE&')(.*?)>','')
  If $TWIN<>'' Then $sStr=StringRegExpReplace($sStr,'(?s)<('&$TWIN&')>(.*)</('&$TWIN&')>','')
  Return $sStr
 EndFunc

Func _ClearStrregexpArray($array,$num,$step)
	local $newArray[(ubound($array))/$step]
	$s=0
	For $i=0 to (ubound($array) -1) step $step
		$newArray[$s] = $array[$i+$num]
		$s+=1
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $array[$i+1] = ' & $array[$i+1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Next
	return $newArray
EndFunc

Func _deleteStopwordsBigDic($text)
	local $aStopwordsBigDic[479] = ['������ �� ��������������� ���������� ��������', '������ �� ��������������� ���������� �������', _
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
 local $aPlaguewordsExp = ['������ �� ��������������� �������� [�-���]*?', '(������|������) (���� )?(�����������|����������)', _
 '(��, ��� |�� ��� |��� )?��� �������', '��� ��� (������� / ��� )?��������', '��� ���( � ���� ��� �������)?', _
 '� ������ ������( �������)?', '���������(-��|��| ��)?����', '(� )?�� �����( ������)?', '(������|������)( ��)?', _
 '� �����(-��|��| ��)?', '(�����|�����) ������', '����������( ������)?', '������(-��|��| ��)?', '(��, |�� )?�� ����', _
 '(�� �� )?���������', '(��� )?������(��)?', '(��, |�� )?������', '(�� )?�����(��)?', '���� ����( ���)?', _
 '���������( ��)?', '�� ����( ����)?', '��� ���( ���)?', '(� )?�� ������', '������(��|��)?', '(�� )? �������', _
 '(�������|�) ���', '�� (��� )?���', '������( ���)?', '���-��( ���)?', '������( ���)?', '������( ��)?', '(� )?� �����', _
 '(��� )?����', '(��� )?����', '(�� )?�� ���', '���( ���)?', '(�� )?���']
 local $aPlaguewords = ['���� ����� ��� �������', '��������� ����� ����', '��� �� ��� �������', '��� � ���� �������', '�� ��� ��� �������', _
 '� ��������� ����', '���� ���������', '��� ���������', '�� ����� ����', '� ���� ����� ', '� ����� ����', '���� ������', '��� ��������', _
 '�����������', '������� ���', '�����������', '�����������', '� �� ������', '��� �������', '� ��������', '���� � ���', '����� ����', _
 '������� ��', '�� � �����', '������ ���', '����������', '���������', '���������', '����� ���', '�-��-����', '���������', '� �������', _
 '��-������', '���������', '��� �����', '��� �����', '��������', '� ��� ��', '��������', '��������', '��������', '��������', '��������', _
 '��������', '��-�-��', '��� ���', '�������', '�������', '�� ����', '������', '������', '������', '������', '��� ��', '������', '������', _
 '�� ���', '������', '������', '������', '������', '��, ��', '�����', '�����', '�����', '�� ��', '�����', '����', '����', '����', '��-�', _
 '��-�', '����', '����', '����', '�-��', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', '���', _
 '��', '��', '��']

EndFunc

Func _ClearHTML($sText)
    Local $0, $DelAll, $DelTag, $i, $Rep, $teg, $Tr
    $Tr = 0
    $teg = 'p|div|span|html|body|b|table|td|tr|th|font|img|br'
    $sText=StringRegExpReplace($sText, '(?s)<!--.*?-->', '') ; �������� ������������

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

    $sText=StringReplace($sText, '<p><o:p>&nbsp;</o:p></p>', '<br><br>') ; ������ ��������� �����
    ; $sText=StringRegExpReplace($sText, '(?s)(<('&$teg&').*?>)(.*?)</\2>(\s*)\1', '\1\3\4') ; ������� ������������
    $sText=StringRegExpReplace($sText, '(?s)<('&$teg&')[^<>]*?>[\x{A0}\s]*?</\1>', '') ; ������� ����� ��� ��������

    $DelAll='xml|style|script'
    $sText=StringRegExpReplace($sText,'(?s)<('&$DelAll&')[^<>]*>(.*?)</\1>','') ; �������� � ����������

    $DelTag='span'
    $sText=StringRegExpReplace($sText,'(?s)</?('&$DelTag&')[^<>]*>','') ; �������� ����� �����

    Return $sText
EndFunc

Func _Replace($Rep)
    $teg = 'table|td|tr|th'
    $aRep=StringRegExp($Rep, '((?:colspan|rowspan)\h*=\h*"?\d+"?)', 3)
    $Rep = StringRegExpReplace($Rep, '(?s)(<(?:' & $teg & ')) .*?(>)', '\1') ; �������
    For $i = 0 To UBound($aRep)-1
        $Rep &= ' ' & $aRep[$i]
    Next
    $Rep &= '>'
    Return $Rep
EndFunc

Func _htmltext()
	$htmltext = '<div id="post-40529013_603671" class="post" onmouseover="wall.postOver(' & "'" & '-40529013_603671' & "'" & ');"onmouseout="wall.postOut(' & "'" & '-40529013_603671' & "'" & ');"onclick="wall.postClick(' & "'" & '-40529013_603671' & "'" & ', event);" >' & @CRLF & _
			'  <div class="post_table">' & @CRLF & _
			'    <div class="post_image">' & @CRLF & _
			'      <a class="post_image" href="/horror_tales"><img src="http://cs311631.vk.me/v311631388/5b9c/8e72T_IF54c.jpg" width="50" height="50"/></a>' & @CRLF & _
			'      ' & @CRLF & _
			'    </div>' & @CRLF & _
			'    <div class="post_info">' & @CRLF & _
			'      <div class="fl_r post_actions_wrap"><div class="post_actions"><div id="post_delete-40529013_603671" class="post_delete_button fl_r" onclick="wall.markAsSpam(' & "'" & '-40529013_603671' & "'" & ', ' & "'" & '95419b6dfb8bfa13b1' & "'" & ');" onmouseover="wall.activeDeletePost(' & "'" & '-40529013_603671' & "'" & ', ' & "'" & '������������' & "'" & ', ' & "'" & 'post_delete' & "'" & ')" onmouseout="wall.deactiveDeletePost(' & "'" & '-40529013_603671' & "'" & ', ' & "'" & 'post_delete' & "'" & ')"></div></div></div>' & @CRLF & _
			'      <div class="wall_text"><div class="wall_text_name"><a class="author" href="/horror_tales" data-from-id="-40529013" data-post-id="-40529013_603671">�������� �������</a></div> <div id="wpt-40529013_603671"><div class="wall_post_text">������<br><br>���� � ���� �������� � ˸����. �� ��� �� ����� � ��� ��� �����, ��-���������� ��� � ����� ������������. ����� ��� ������� � ��� ��������� � ����� � �� ��� ��� ������, ��� � ��� ����� ����������? ���������� ��� ���?<br><br>� ��������� ��� ���. ��<br><a class="wall_post_more" onclick="hide(this, domPS(this)); show(domNS(this));">�������� ���������..</a><span style="display: none"><br><br>��� ������ ��������� ����������, � � ����, � ��������� ������. ˸����, ������, �� ��������� ���������� ���������, � ����� �������� � � �������: ������ ���� �� �������� ���� � �����, � ������ � ���� ���������. � ������ ������, � ��� ���������� �����: ��� �� ���������� ����&#33; � � �����&#33;�. ����� �����-�� ���, � ������� �� ��� ����� � ��� ��������.<br><br></span></div><div class="page_post_sized_thumbs  clear_fix" style="width: 537px; height: 313px;"><a  onclick="return showPhoto(' & "'" & '-40529013_387030898' & "'" & ', ' & "'" & 'wall-40529013_603671' & "'" & ', {&quot;temp&quot;:{&quot;base&quot;:&quot;http://cs623924.vk.me/v623924859/&quot;,&quot;x_&quot;:[&quot;55b9e/gzPZcc8gxCM&quot;,600,350]},queue:1}, event)" style="width: 537px; height: 313px;" class="page_post_thumb_wrap  page_post_thumb_last_column page_post_thumb_last_row"><img src="http://cs623924.vk.me/v623924859/55b9e/gzPZcc8gxCM.jpg" width="537" height="313" style=""  class="page_post_thumb_sized_photo" /></a></div></div></div>' & @CRLF & _
			'      <div class="post_full_like_wrap sm fl_r">' & @CRLF & _
			'  <div class="post_full_like">' & @CRLF & _
			'    <div class="post_like fl_r"  onmouseover="wall.postLikeOver(' & "'" & '-40529013_603671' & "'" & ')" onmouseout="wall.postLikeOut(' & "'" & '-40529013_603671' & "'" & ')" onclick="wall.like(' & "'" & '-40529013_603671' & "'" & ', ' & "'" & '54c9204d67ab3f4894' & "'" & '); event.cancelBubble = true;">' & @CRLF & _
			'      <span class="post_like_link fl_l" id="like_link-40529013_603671"></span>' & @CRLF & _
			'      <i class="post_like_icon sp_main  fl_l" id="like_icon-40529013_603671"></i>' & @CRLF & _
			'      <span class="post_like_count fl_l" id="like_count-40529013_603671">1046</span>' & @CRLF & _
			'    </div>' & @CRLF & _
			'    <div class="post_share fl_r "  onmouseover="wall.postShareOver(' & "'" & '-40529013_603671' & "'" & ')" onmouseout="wall.postShareOut(' & "'" & '-40529013_603671' & "'" & ', event)" onclick="wall.likeShareCustom(' & "'" & '-40529013_603671' & "'" & '); event.cancelBubble = true;">' & @CRLF & _
			'      <span class="post_share_link fl_l" id="share_link-40529013_603671"></span>' & @CRLF & _
			'      <i class="post_share_icon sp_main fl_l" id="share_icon-40529013_603671"></i>' & @CRLF & _
			'      <span class="post_share_count fl_l" id="share_count-40529013_603671">51</span>' & @CRLF & _
			'    </div>' & @CRLF & _
			'  </div>' & @CRLF & _
			'</div>' & @CRLF & _
			'      <div class="replies"><div class="reply_link_wrap sm" id="wpe_bottom-40529013_603671">' & @CRLF & _
			'  <small><a  href="/wall-40529013_603671" onclick="return showWiki({w: ' & "'" & 'wall-40529013_603671' & "'" & '}, false, event);" ><span class="rel_date">������� � 1:05</span></a></small>' & @CRLF & _
			'</div>' & @CRLF & _
			'<div class="replies_wrap clear" id="replies_wrap-40529013_603671" style="display: none">' & @CRLF & _
			'  <div id="replies-40529013_603671"><input type="hidden" id="start_reply-40529013_603671" value="" /></div>' & @CRLF & _
			'  ' & @CRLF & _
			'</div></div>' & @CRLF & _
			'    </div>' & @CRLF & _
			'  </div>' & @CRLF & _
			'  ' & @CRLF & _
			'</div>'
	Return $htmltext
EndFunc   ;==>_htmltext



Func _HTMLTransSymb($text)

	$text = StringRegExpReplace($text,'<script[^>]*?>.*?</script>', '')
	$text = StringRegExpReplace($text,'<[\/\!]*?[^<>]*?>', @CRLF)
	$text = StringRegExpReplace($text, '&quot;', '"')
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
	$text = StringRegExpReplace($text,'([\r\n])[\s]+', @CRLF)

	; ���� ����������� ������� ����������. ���� ���� � UTF8 �� � �� ����� ���� ��������� �������, ������� ��� ���������� � ASCI ����� ���������
	$text = StringRegExpReplace($text, '[��]', '"') ; ������������ �������
	$text = StringReplace($text, ChrW(160), ' ') ; �������� ������ 160 �� ������ 32
	$text = StringReplace($text, ChrW(8226), '') ; ������� ���������
	$text = StringReplace($text, ChrW(8211), '-') ; ������� ���� �� ���������� �����
	$text = StringReplace($text, ChrW(8230), '...') ; ��������� �� ��� �����
	$text = StringReplace($text, ChrW(8212), '-') ; ����� ������� ���� �� ��������

	return $text
EndFunc

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

	return $text
Endfunc

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
