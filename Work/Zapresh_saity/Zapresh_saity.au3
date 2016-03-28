#include <Array.au3>
$ALLDomainsNoUTF='\.xn--clchc0ea0b2g2a9gcd|\.xn--hgbk6aj7f53bba|\.xn--hlcj6aya9esc7a|\.xn--xkc2dl3a5ee0h|\.xn--mgberp4a5d4ar|\.xn--mgbai9azgqp6j|\.xn--11b5bs3a9aj6g|\.xn--xkc2al3hye2a|\.xn--80akhbyknj4f|\.xn--lgbbat1ad8j|\.xn--mgba3a4f16a|\.xn--mgbc0a9azcg|\.xn--mgbbh1a71e|\.xn--mgbayh7gpa|\.xn--mgbaam7a8h|\.xn--54b7fta0cc|\.xn--9t4b11yi5a|\.xn--fpcrj9c3d|\.xn--ygbi2ammx|\.xn--yfro4i67o|\.xn--fzc2c9e2c|\.xn--3e0b707e|\.xn--ogbpf8fl|\.xn--4dbrk0ce|\.xn--mgb9awbf|\.xn--mgb2ddes|\.xn--kgbechtv|\.xn--jxalpdlp|\.xn--j6w193g|\.xn--h2brj9c|\.xn--gecrj9c|\.xn--s9brj9c|\.xn--45brj9c|\.xn--kprw13d|\.xn--kpry57d|\.xn--pgbs0dh|\.xn--0zwm56d|\.xn--g6w251d|\.xn--deba0ad|\.xn--fiqs8s|\.xn--fiqz9s|\.xn--wgbh1c|\.xn--wgbl6a|\.xn--90a3ac|\.xn--o3cw4h|\.xn--zckzah|\.xn--j1amh|\.�C��TAH�E|\.xn--p1ai|\.xn--90ae|\.xn--node|\.museum|\.travel|\.asia|\.coop|\.info|\.jobs|\.mobi|\.name|\.arpa|\.aero|\.biz|\.cat|\.com|\.edu|\.gov|\.int|\.mil|\.net|\.org|\.pro|\.tel|\.xxx|\.CP6|\.YKP|\.ad|\.ae|\.af|\.ag|\.ai|\.al|\.am|\.an|\.ao|\.aq|\.ar|\.as|\.at|\.au|\.aw|\.ax|\.az|\.ba|\.bb|\.bd|\.be|\.bf|\.bg|\.bh|\.bi|\.bj|\.bm|\.bn|\.bo|\.br|\.bs|\.bt|\.bv|\.bw|\.by|\.bz|\.ca|\.cc|\.cd|\.cf|\.cg|\.ch|\.ci|\.ck|\.cl|\.cm|\.cn|\.co|\.cr|\.cs|\.cu|\.cv|\.cx|\.cy|\.cz|\.dd|\.de|\.dj|\.dk|\.dm|\.do|\.dz|\.ec|\.ee|\.eg|\.er|\.es|\.et|\.eu|\.fi|\.fj|\.fk|\.fm|\.fo|\.fr|\.ga|\.gb|\.gd|\.ge|\.gf|\.gg|\.gh|\.gi|\.gl|\.gm|\.gn|\.gp|\.gq|\.gr|\.gs|\.gt|\.gu|\.gw|\.gy|\.hk|\.hm|\.hn|\.hr|\.ht|\.hu|\.id|\.ie|\.il|\.im|\.in|\.io|\.iq|\.ir|\.is|\.it|\.je|\.jm|\.jo|\.jp|\.ke|\.kg|\.kh|\.ki|\.km|\.kn|\.kp|\.kr|\.kw|\.ky|\.kz|\.la|\.lb|\.lc|\.li|\.lk|\.lr|\.ls|\.lt|\.lu|\.lv|\.ly|\.ma|\.mc|\.md|\.me|\.mg|\.mh|\.mk|\.ml|\.mm|\.mn|\.mo|\.mp|\.mq|\.mr|\.ms|\.mt|\.mu|\.mv|\.mw|\.mx|\.my|\.mz|\.na|\.nc|\.ne|\.nf|\.ng|\.ni|\.nl|\.no|\.np|\.nr|\.nu|\.nz|\.om|\.pa|\.pe|\.pf|\.pg|\.ph|\.pk|\.pl|\.pm|\.pn|\.pr|\.ps|\.pt|\.pw|\.py|\.qa|\.re|\.ro|\.rs|\.ru|\.P�|\.rw|\.sa|\.sb|\.sc|\.sd|\.se|\.sg|\.sh|\.si|\.sj|\.sk|\.sl|\.sm|\.sn|\.so|\.sr|\.st|\.su|\.sv|\.sy|\.sz|\.tc|\.td|\.tf|\.tg|\.th|\.tj|\.tk|\.tl|\.tm|\.tn|\.to|\.tp|\.tr|\.tt|\.tv|\.tw|\.tz|\.ua|\.ug|\.uk|\.us|\.uy|\.uz|\.va|\.vc|\.ve|\.vg|\.vi|\.vn|\.vu|\.wf|\.ws|\.ye|\.yt|\.za|\.zm|\.zw|\.P�|\.dz|\.cn|\.cn|\.eg|\.hk|\.in|\.in|\.in|\.in|\.in|\.in|\.in|\.ir|\.jo|\.ma|\.ps|\.qa|\.ru|\.sa|\.rs|\.sg|\.sg|\.kr|\.lk|\.lk|\.sy|\.tw|\.tw|\.th|\.tn|\.ua|\.ae|\.bd|\.bg|\.ge|\.il|\.om|\.pk|\.ye|\.ac'
;~ $ALLDomains='.aero|.asia|.biz|.cat|.com|.coop|.edu|.gov|.info|.int|.jobs|.mil|.mobi|.museum|.name|.net|.org|.pro|.tel|.travel|.xxx|.ac|.ad|.ae|.af|.ag|.ai|.al|.am|.an|.ao|.aq|.ar|.as|.at|.au|.aw|.ax|.az|.ba|.bb|.bd|.be|.bf|.bg|.bh|.bi|.bj|.bm|.bn|.bo|.br|.bs|.bt|.bv|.bw|.by|.bz|.ca|.cc|.cd|.cf|.cg|.ch|.ci|.ck|.cl|.cm|.cn|.co|.cr|.cs|.cu|.cv|.cx|.cy|.cz|.dd|.de|.dj|.dk|.dm|.do|.dz|.ec|.ee|.eg|.er|.es|.et|.eu|.fi|.fj|.fk|.fm|.fo|.fr|.ga|.gb|.gd|.ge|.gf|.gg|.gh|.gi|.gl|.gm|.gn|.gp|.gq|.gr|.gs|.gt|.gu|.gw|.gy|.hk|.hm|.hn|.hr|.ht|.hu|.id|.ie|.|..il|.im|.in|.io|.iq|.ir|.is|.it|.je|.jm|.jo|.jp|.ke|.kg|.kh|.ki|.km|.kn|.kp|.kr|.kw|.ky|.kz|.la|.lb|.lc|.li|.lk|.lr|.ls|.lt|.lu|.lv|.ly|.ma|.mc|.md|.me|.mg|.mh|.mk|.ml|.mm|.mn|.mo|.mp|.mq|.mr|.ms|.mt|.mu|.mv|.mw|.mx|.my|.mz|.na|.nc|.ne|.nf|.ng|.ni|.nl|.no|.np|.nr|.nu|.nz|.om|.pa|.pe|.pf|.pg|.ph|.pk|.pl|.pm|.pn|.pr|.ps|.pt|.pw|.py|.qa|.re|.ro|.rs|.ru|.рф|.rw|.sa|.sb|.sc|.sd|.se|.sg|.sh|.si|.sj|.sk|.sl|.sm|.sn|.so|.sr|.st|.su|.sv|.sy|.sz|.tc|.td|.tf|.tg|.th|.tj|.tk|.tl|.tm|.tn|.to|.tp|.tr|.tt|.tv|.tw|.tz|.ua|.ug|.uk|.us|.uy|.uz|.va|.vc|.ve|.vg|.vi|.vn|.vu|.wf|.ws|.ye|.yt|.za|.zm|.zw|.xn--lgbbat1ad8j|.xn--fiqs8s|.xn--fiqz9s|.xn--wgbh1c|.xn--j6w193g|.xn--h2brj9c|.xn--mgbbh1a71e|.xn--fpcrj9c3d|.xn--gecrj9c|.xn--s9brj9c|.xn--xkc2dl3a5ee0h|.xn--45brj9c|.xn--mgba3a4f16a|.xn--mgbayh7gpa|.xn--mgbc0a9azcg|.xn--ygbi2ammx|.xn--wgbl6a|.xn--p1ai|.xn--mgberp4a5d4ar|.xn--90a3ac|.xn--yfro4i67o|.xn--clchc0ea0b2g2a9gcd|.xn--3e0b707e|.xn--fzc2c9e2c|.xn--xkc2al3hye2a|.xn--ogbpf8fl|.xn--kprw13d|.xn--kpry57d|.xn--o3cw4h|.xn--pgbs0dh|.xn--j1amh|.xn--mgbaam7a8h|.الجزائر.|.中国[b 1]|.中國[b 2]|.مصر.|.香港|.भारत|.بھارت.|.భారత్|.ભારત|.ਭਾਰਤ|.இந்தியா|.ভারত|.ایران.|.الاردن.|.المغرب.|.فلسطين.|.قطر.|.рф|.السعودية.|.срб|.新加坡|.சிங்கப்பூர்|.한국|.ලංකා[b 3]|.இலங்கை[b 4]|.سورية.|.台湾[b 1]|.台灣[b 2]|.ไทย|.تونس.|.укр|.امارات.|.dz|.cn|.cn|.eg|.hk|.in|.in|.in|.in|.in|.in|.in|.ir|.jo|.ma|.ps|.qa|.ru|.sa|.rs|.sg|.sg|.kr|.lk|.lk|.sy|.tw|.tw|.th|.tn|.ua|.ae|.xn--54b7fta0cc|.xn--90ae|.xn--node|.xn--4dbrk0ce|.xn--mgb9awbf|.xn--mgbai9azgqp6j|.xn--mgb2ddes|.бг|.გე|.ישראל.|.عمان.|.پاکستان.|.اليمن.|.bd|.bg|.ge|.il|.om|.pk|.ye|.xn--kgbechtv|.xn--hgbk6aj7f53bba|.xn--0zwm56d|.xn--g6w251d|.xn--80akhbyknj4f|.xn--11b5bs3a9aj6g|.xn--jxalpdlp|.xn--9t4b11yi5a|.xn--deba0ad|.xn--zckzah|.xn--hlcj6aya9esc7a|.إختبار|.آزمایشی|.测试|.測試|.испытание|.परीक्षा|.δοκιμή|.테스트|.טעסט|.テスト|.பரிட்சை|.arpa'
;~ $ALLDomainsNoUTF='.aero|.asia|.biz|.cat|.com|.coop|.edu|.gov|.info|.int|.jobs|.mil|.mobi|.museum|.name|.net|.org|.pro|.tel|.travel|.xxx|.ac|.ad|.ae|.af|.ag|.ai|.al|.am|.an|.ao|.aq|.ar|.as|.at|.au|.aw|.ax|.az|.ba|.bb|.bd|.be|.bf|.bg|.bh|.bi|.bj|.bm|.bn|.bo|.br|.bs|.bt|.bv|.bw|.by|.bz|.ca|.cc|.cd|.cf|.cg|.ch|.ci|.ck|.cl|.cm|.cn|.co|.cr|.cs|.cu|.cv|.cx|.cy|.cz|.dd|.de|.dj|.dk|.dm|.do|.dz|.ec|.ee|.eg|.er|.es|.et|.eu|.fi|.fj|.fk|.fm|.fo|.fr|.ga|.gb|.gd|.ge|.gf|.gg|.gh|.gi|.gl|.gm|.gn|.gp|.gq|.gr|.gs|.gt|.gu|.gw|.gy|.hk|.hm|.hn|.hr|.ht|.hu|.id|.ie|..il|.im|.in|.io|.iq|.ir|.is|.it|.je|.jm|.jo|.jp|.ke|.kg|.kh|.ki|.km|.kn|.kp|.kr|.kw|.ky|.kz|.la|.lb|.lc|.li|.lk|.lr|.ls|.lt|.lu|.lv|.ly|.ma|.mc|.md|.me|.mg|.mh|.mk|.ml|.mm|.mn|.mo|.mp|.mq|.mr|.ms|.mt|.mu|.mv|.mw|.mx|.my|.mz|.na|.nc|.ne|.nf|.ng|.ni|.nl|.no|.np|.nr|.nu|.nz|.om|.pa|.pe|.pf|.pg|.ph|.pk|.pl|.pm|.pn|.pr|.ps|.pt|.pw|.py|.qa|.re|.ro|.rs|.ru|.P�|.rw|.sa|.sb|.sc|.sd|.se|.sg|.sh|.si|.sj|.sk|.sl|.sm|.sn|.so|.sr|.st|.su|.sv|.sy|.sz|.tc|.td|.tf|.tg|.th|.tj|.tk|.tl|.tm|.tn|.to|.tp|.tr|.tt|.tv|.tw|.tz|.ua|.ug|.uk|.us|.uy|.uz|.va|.vc|.ve|.vg|.vi|.vn|.vu|.wf|.ws|.ye|.yt|.za|.zm|.zw|.xn--lgbbat1ad8j|.xn--fiqs8s|.xn--fiqz9s|.xn--wgbh1c|.xn--j6w193g|.xn--h2brj9c|.xn--mgbbh1a71e|.xn--fpcrj9c3d|.xn--gecrj9c|.xn--s9brj9c|.xn--xkc2dl3a5ee0h|.xn--45brj9c|.xn--mgba3a4f16a|.xn--mgbayh7gpa|.xn--mgbc0a9azcg|.xn--ygbi2ammx|.xn--wgbl6a|.xn--p1ai|.xn--mgberp4a5d4ar|.xn--90a3ac|.xn--yfro4i67o|.xn--clchc0ea0b2g2a9gcd|.xn--3e0b707e|.xn--fzc2c9e2c|.xn--xkc2al3hye2a|.xn--ogbpf8fl|.xn--kprw13d|.xn--kpry57d|.xn--o3cw4h|.xn--pgbs0dh|.xn--j1amh|.xn--mgbaam7a8h|..P�|..CP6|.YKP|..dz|.cn|.cn|.eg|.hk|.in|.in|.in|.in|.in|.in|.in|.ir|.jo|.ma|.ps|.qa|.ru|.sa|.rs|.sg|.sg|.kr|.lk|.lk|.sy|.tw|.tw|.th|.tn|.ua|.ae|.xn--54b7fta0cc|.xn--90ae|.xn--node|.xn--4dbrk0ce|.xn--mgb9awbf|.xn--mgbai9azgqp6j|.xn--mgb2ddes|..bd|.bg|.ge|.il|.om|.pk|.ye|.xn--kgbechtv|.xn--hgbk6aj7f53bba|.xn--0zwm56d|.xn--g6w251d|.xn--80akhbyknj4f|.xn--11b5bs3a9aj6g|.xn--jxalpdlp|.xn--9t4b11yi5a|.xn--deba0ad|.xn--zckzah|.xn--hlcj6aya9esc7a|.�C��TAH�E|.arpa'
$buffer = ClipGet()
;���������� "������"/"����� � �������" ������� ���������� �������
;~ Dim $Replaceletter[33][2]=[['�','A'],['�','6'],['�','B'],['�','R'],['�','D'],['�','E'],['�','E'],['�','G'],['�','3'],['�','N'],['�','N'],['�','K'],['�','L'],['�','M'],['�','H'],['�','O'],['�','N'],['�','P'],['�','C'],['�','T'],['�','Y'],['�','F'],['�','X'],['�','4'],['�','B'],['�','R'],['�','bl']]
global $Replaceletter[16][2]=[['�','A'],['�','6'],['�','B'],['�','R'],['�','E'],['�','3'],['�','K'],['�','M'],['�','H'],['�','O'],['�','P'],['�','C'],['�','T'],['�','Y'],['�','X'],['�','B']]
;~ _ArrayDisplay($Replaceletter)

;������� ��� �������  �����
StringRegExpReplace ( $buffer, " [�-��-�]{3,}", "replace", )

$testtime=Timerinit()
$Text1=$buffer
For $i=0 to Ubound($Replaceletter)-1
	$Text1=StringReplace($Text1,$Replaceletter[$i][0],$Replaceletter[$i][1])
Next
ConsoleWrite(TimerDiff($testtime)&@CRLF)

$NewText=StringRegExp ( $Text1, '('&$ALLDomainsNoUTF&')' , 3  )
_ArrayDisplay($NewText)

$BufferOut=$Text1
;~ ClipPut($BufferOut)

#comments-start
;���������� ����� �� ������ ����� ������� ����� ��������, �������� Nero (����� ������� ��� ���������� Nero �� ������)
$EqualString = 'Nokia Ovi' & '|' & _
'Samsung PC Studio 3'; & '|' & _
$DelteString=0
$SplitDelteString = StringSplit($DelteString, '|')
;~ _ArrayDisplay($SplitDelteString)


$buffer = ClipGet()
;~ $SplitBuffer = StringSplit(StringStripCR($buffer), @LF) ;������ ������� ��������
$SplitBuffer = StringSplit($buffer, @CR)
Consolewrite($SplitBuffer[0])
;~ _ArrayDisplay($splitBuffer,'��')



global $delete [$SplitBuffer[0]+1]
$schet=0
global $splitBufferCell[1]
For $i=1 to $SplitBuffer[0]
;~ 	  ConsoleWrite('���' & $i & ' ')
;~ 	  ConsoleWrite($splitBuffer[$i] & @CRLF)
	  If StringRegExp ( $splitBuffer[$i], "\S" ) = 0 Then
		 $delete[$i]=1
;~ 		 ConsoleWrite('������ ������ '&$i&' '&$splitBuffer[$i]&@CRLF)
	  Else
		 For $t=1 to $SplitDelteString[0]
;~ 			If StringInStr ( $splitBuffer[$i], $SplitDelteString[$t]) <>0 Then
			If StringRegExp ( $splitBuffer[$i], '\Q'& $SplitDelteString[$t] &'\E') <>0 Then
			   $delete[$i]=1
;~ 			   ConsoleWrite('�������� ���������� '&$i&' '&$splitBuffer[$i]&@CRLF)
			EndIf
		 Next

		 ;�������� �����, ���� ������ ������ ��� �����������
		 $schet+=1
		 if $schet>1 then
			$splitBufferCell2=StringSplit($splitBuffer[$i], @TAB)
			if not @error then
			   For $t=1 to Ubound($splitBufferCell)-1
				  If StringCompare ( $splitBufferCell2[1], $splitBufferCell[$t])=0 then
					 $delete[$i]=1
					 ConsoleWrite('�������� ���������� '&$i&' '&$splitBuffer[$i]&@CRLF)
				  EndIf
			   Next
			EndIf
		 endif
		 ;��������� ������� ������ ����� �������, ��� �������� ���������� � ���
			$splitBufferCells=0
			$splitBufferCells=StringSplit($splitBuffer[$i], @TAB)
			If not @error Then
			   Redim $splitBufferCell[Ubound($splitBufferCell)+1]
			   $splitBufferCell[$i]=$splitBufferCells[1]
			EndIf
	  Endif
;~ 	  ConsoleWrite('���' & $i & ' ')
Next





;�������� ���������� �����
For $i=1 to $SplitBuffer[0]
   if $delete[$i]=1 then
;~ 	  _ArrayDelete($splitBuffer, $i)
	  $splitBuffer[$i]=''
   EndIf
Next
$delete=0

;�������� ������ �����
   $SplitBuffer=_ArrayClearEmpty($splitBuffer, 0, 1)
;�������� ����������
;~ $SplitBuffer=_ArrayUnique($splitBuffer)
$SplitBuffer=_ArrayRemoveDuplicates($splitBuffer)


;~ ;�������� ����� ������� � ������
$BufferOut=''
For $i=1 to Ubound($SplitBuffer)-1
;~    $BufferOut += $SplitBuffer[$i] & @CRLF
   $BufferOut=$BufferOut & $SplitBuffer[$i]
Next
;~ ConsoleWrite($BufferOut)
ClipPut($BufferOut)

;~ ConsoleWrite( $DelteString )
_ArrayDisplay($splitBuffer,'�����')


#comments-end









Func _ArrayRemoveDuplicates(Const ByRef $aArray)
    If Not IsArray($aArray) Then Return SetError(1, 0, 0)
    Local $oSD = ObjCreate("Scripting.Dictionary")
    For $i In $aArray
        $oSD.Item($i) ; shown by wraithdu
    Next
    Return $oSD.Keys()
EndFunc

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
        Case 2
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
    Return SetError(0, $i_UBound_Row - $i_Index, $a_TempArray)
EndFunc   ;==>_ArrayClearEmpty