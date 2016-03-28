#include <Array.au3>
$ALLDomainsNoUTF='\.xn--clchc0ea0b2g2a9gcd|\.xn--hgbk6aj7f53bba|\.xn--hlcj6aya9esc7a|\.xn--xkc2dl3a5ee0h|\.xn--mgberp4a5d4ar|\.xn--mgbai9azgqp6j|\.xn--11b5bs3a9aj6g|\.xn--xkc2al3hye2a|\.xn--80akhbyknj4f|\.xn--lgbbat1ad8j|\.xn--mgba3a4f16a|\.xn--mgbc0a9azcg|\.xn--mgbbh1a71e|\.xn--mgbayh7gpa|\.xn--mgbaam7a8h|\.xn--54b7fta0cc|\.xn--9t4b11yi5a|\.xn--fpcrj9c3d|\.xn--ygbi2ammx|\.xn--yfro4i67o|\.xn--fzc2c9e2c|\.xn--3e0b707e|\.xn--ogbpf8fl|\.xn--4dbrk0ce|\.xn--mgb9awbf|\.xn--mgb2ddes|\.xn--kgbechtv|\.xn--jxalpdlp|\.xn--j6w193g|\.xn--h2brj9c|\.xn--gecrj9c|\.xn--s9brj9c|\.xn--45brj9c|\.xn--kprw13d|\.xn--kpry57d|\.xn--pgbs0dh|\.xn--0zwm56d|\.xn--g6w251d|\.xn--deba0ad|\.xn--fiqs8s|\.xn--fiqz9s|\.xn--wgbh1c|\.xn--wgbl6a|\.xn--90a3ac|\.xn--o3cw4h|\.xn--zckzah|\.xn--j1amh|\.иCпыTAHиE|\.xn--p1ai|\.xn--90ae|\.xn--node|\.museum|\.travel|\.asia|\.coop|\.info|\.jobs|\.mobi|\.name|\.arpa|\.aero|\.biz|\.cat|\.com|\.edu|\.gov|\.int|\.mil|\.net|\.org|\.pro|\.tel|\.xxx|\.CP6|\.YKP|\.ad|\.ae|\.af|\.ag|\.ai|\.al|\.am|\.an|\.ao|\.aq|\.ar|\.as|\.at|\.au|\.aw|\.ax|\.az|\.ba|\.bb|\.bd|\.be|\.bf|\.bg|\.bh|\.bi|\.bj|\.bm|\.bn|\.bo|\.br|\.bs|\.bt|\.bv|\.bw|\.by|\.bz|\.ca|\.cc|\.cd|\.cf|\.cg|\.ch|\.ci|\.ck|\.cl|\.cm|\.cn|\.co|\.cr|\.cs|\.cu|\.cv|\.cx|\.cy|\.cz|\.dd|\.de|\.dj|\.dk|\.dm|\.do|\.dz|\.ec|\.ee|\.eg|\.er|\.es|\.et|\.eu|\.fi|\.fj|\.fk|\.fm|\.fo|\.fr|\.ga|\.gb|\.gd|\.ge|\.gf|\.gg|\.gh|\.gi|\.gl|\.gm|\.gn|\.gp|\.gq|\.gr|\.gs|\.gt|\.gu|\.gw|\.gy|\.hk|\.hm|\.hn|\.hr|\.ht|\.hu|\.id|\.ie|\.il|\.im|\.in|\.io|\.iq|\.ir|\.is|\.it|\.je|\.jm|\.jo|\.jp|\.ke|\.kg|\.kh|\.ki|\.km|\.kn|\.kp|\.kr|\.kw|\.ky|\.kz|\.la|\.lb|\.lc|\.li|\.lk|\.lr|\.ls|\.lt|\.lu|\.lv|\.ly|\.ma|\.mc|\.md|\.me|\.mg|\.mh|\.mk|\.ml|\.mm|\.mn|\.mo|\.mp|\.mq|\.mr|\.ms|\.mt|\.mu|\.mv|\.mw|\.mx|\.my|\.mz|\.na|\.nc|\.ne|\.nf|\.ng|\.ni|\.nl|\.no|\.np|\.nr|\.nu|\.nz|\.om|\.pa|\.pe|\.pf|\.pg|\.ph|\.pk|\.pl|\.pm|\.pn|\.pr|\.ps|\.pt|\.pw|\.py|\.qa|\.re|\.ro|\.rs|\.ru|\.Pф|\.rw|\.sa|\.sb|\.sc|\.sd|\.se|\.sg|\.sh|\.si|\.sj|\.sk|\.sl|\.sm|\.sn|\.so|\.sr|\.st|\.su|\.sv|\.sy|\.sz|\.tc|\.td|\.tf|\.tg|\.th|\.tj|\.tk|\.tl|\.tm|\.tn|\.to|\.tp|\.tr|\.tt|\.tv|\.tw|\.tz|\.ua|\.ug|\.uk|\.us|\.uy|\.uz|\.va|\.vc|\.ve|\.vg|\.vi|\.vn|\.vu|\.wf|\.ws|\.ye|\.yt|\.za|\.zm|\.zw|\.Pф|\.dz|\.cn|\.cn|\.eg|\.hk|\.in|\.in|\.in|\.in|\.in|\.in|\.in|\.ir|\.jo|\.ma|\.ps|\.qa|\.ru|\.sa|\.rs|\.sg|\.sg|\.kr|\.lk|\.lk|\.sy|\.tw|\.tw|\.th|\.tn|\.ua|\.ae|\.bd|\.bg|\.ge|\.il|\.om|\.pk|\.ye|\.ac'
;~ $ALLDomains='.aero|.asia|.biz|.cat|.com|.coop|.edu|.gov|.info|.int|.jobs|.mil|.mobi|.museum|.name|.net|.org|.pro|.tel|.travel|.xxx|.ac|.ad|.ae|.af|.ag|.ai|.al|.am|.an|.ao|.aq|.ar|.as|.at|.au|.aw|.ax|.az|.ba|.bb|.bd|.be|.bf|.bg|.bh|.bi|.bj|.bm|.bn|.bo|.br|.bs|.bt|.bv|.bw|.by|.bz|.ca|.cc|.cd|.cf|.cg|.ch|.ci|.ck|.cl|.cm|.cn|.co|.cr|.cs|.cu|.cv|.cx|.cy|.cz|.dd|.de|.dj|.dk|.dm|.do|.dz|.ec|.ee|.eg|.er|.es|.et|.eu|.fi|.fj|.fk|.fm|.fo|.fr|.ga|.gb|.gd|.ge|.gf|.gg|.gh|.gi|.gl|.gm|.gn|.gp|.gq|.gr|.gs|.gt|.gu|.gw|.gy|.hk|.hm|.hn|.hr|.ht|.hu|.id|.ie|.|..il|.im|.in|.io|.iq|.ir|.is|.it|.je|.jm|.jo|.jp|.ke|.kg|.kh|.ki|.km|.kn|.kp|.kr|.kw|.ky|.kz|.la|.lb|.lc|.li|.lk|.lr|.ls|.lt|.lu|.lv|.ly|.ma|.mc|.md|.me|.mg|.mh|.mk|.ml|.mm|.mn|.mo|.mp|.mq|.mr|.ms|.mt|.mu|.mv|.mw|.mx|.my|.mz|.na|.nc|.ne|.nf|.ng|.ni|.nl|.no|.np|.nr|.nu|.nz|.om|.pa|.pe|.pf|.pg|.ph|.pk|.pl|.pm|.pn|.pr|.ps|.pt|.pw|.py|.qa|.re|.ro|.rs|.ru|.СЂС„|.rw|.sa|.sb|.sc|.sd|.se|.sg|.sh|.si|.sj|.sk|.sl|.sm|.sn|.so|.sr|.st|.su|.sv|.sy|.sz|.tc|.td|.tf|.tg|.th|.tj|.tk|.tl|.tm|.tn|.to|.tp|.tr|.tt|.tv|.tw|.tz|.ua|.ug|.uk|.us|.uy|.uz|.va|.vc|.ve|.vg|.vi|.vn|.vu|.wf|.ws|.ye|.yt|.za|.zm|.zw|.xn--lgbbat1ad8j|.xn--fiqs8s|.xn--fiqz9s|.xn--wgbh1c|.xn--j6w193g|.xn--h2brj9c|.xn--mgbbh1a71e|.xn--fpcrj9c3d|.xn--gecrj9c|.xn--s9brj9c|.xn--xkc2dl3a5ee0h|.xn--45brj9c|.xn--mgba3a4f16a|.xn--mgbayh7gpa|.xn--mgbc0a9azcg|.xn--ygbi2ammx|.xn--wgbl6a|.xn--p1ai|.xn--mgberp4a5d4ar|.xn--90a3ac|.xn--yfro4i67o|.xn--clchc0ea0b2g2a9gcd|.xn--3e0b707e|.xn--fzc2c9e2c|.xn--xkc2al3hye2a|.xn--ogbpf8fl|.xn--kprw13d|.xn--kpry57d|.xn--o3cw4h|.xn--pgbs0dh|.xn--j1amh|.xn--mgbaam7a8h|.Ш§Щ„Ш¬ШІШ§Ш¦Ш±.|.дё­е›Ѕ[b 1]|.дё­ењ‹[b 2]|.Щ…ШµШ±.|.й¦™жёЇ|.а¤­а¤ѕа¤°а¤¤|.ШЁЪѕШ§Ш±ШЄ.|.а°­а°ѕа°°а°¤а±Ќ|.аЄ­аЄѕаЄ°аЄ¤|.аЁ­аЁѕаЁ°аЁ¤|.а®‡а®ЁаЇЌа®¤а®їа®Їа®ѕ|.а¦­а¦ѕа¦°а¦¤|.Ш§ЫЊШ±Ш§Щ†.|.Ш§Щ„Ш§Ш±ШЇЩ†.|.Ш§Щ„Щ…ШєШ±ШЁ.|.ЩЃЩ„ШіШ·ЩЉЩ†.|.Щ‚Ш·Ш±.|.СЂС„|.Ш§Щ„ШіШ№Щ€ШЇЩЉШ©.|.СЃСЂР±|.ж–°еЉ еќЎ|.а®ља®їа®™аЇЌа®•а®ЄаЇЌа®ЄаЇ‚а®°аЇЌ|.н•њкµ­|.а¶Ѕа¶‚а¶ља·Џ[b 3]|.а®‡а®Іа®™аЇЌа®•аЇ€[b 4]|.ШіЩ€Ш±ЩЉШ©.|.еЏ°ж№ѕ[b 1]|.еЏ°зЃЈ[b 2]|.а№„аё—аёў|.ШЄЩ€Щ†Ші.|.СѓРєСЂ|.Ш§Щ…Ш§Ш±Ш§ШЄ.|.dz|.cn|.cn|.eg|.hk|.in|.in|.in|.in|.in|.in|.in|.ir|.jo|.ma|.ps|.qa|.ru|.sa|.rs|.sg|.sg|.kr|.lk|.lk|.sy|.tw|.tw|.th|.tn|.ua|.ae|.xn--54b7fta0cc|.xn--90ae|.xn--node|.xn--4dbrk0ce|.xn--mgb9awbf|.xn--mgbai9azgqp6j|.xn--mgb2ddes|.Р±Рі|.бѓ’бѓ”|.Ч™Ч©ЧЁЧђЧњ.|.Ш№Щ…Ш§Щ†.|.ЩѕШ§Ъ©ШіШЄШ§Щ†.|.Ш§Щ„ЩЉЩ…Щ†.|.bd|.bg|.ge|.il|.om|.pk|.ye|.xn--kgbechtv|.xn--hgbk6aj7f53bba|.xn--0zwm56d|.xn--g6w251d|.xn--80akhbyknj4f|.xn--11b5bs3a9aj6g|.xn--jxalpdlp|.xn--9t4b11yi5a|.xn--deba0ad|.xn--zckzah|.xn--hlcj6aya9esc7a|.ШҐШ®ШЄШЁШ§Ш±|.ШўШІЩ…Ш§ЫЊШґЫЊ|.жµ‹иЇ•|.жё¬и©¦|.РёСЃРїС‹С‚Р°РЅРёРµ|.а¤Єа¤°аҐЂа¤•аҐЌа¤·а¤ѕ|.ОґОїОєО№ОјО®|.н…ЊмЉ¤нЉё|.ЧЧўЧЎЧ|.гѓ†г‚№гѓ€|.а®Єа®°а®їа®џаЇЌа®љаЇ€|.arpa'
;~ $ALLDomainsNoUTF='.aero|.asia|.biz|.cat|.com|.coop|.edu|.gov|.info|.int|.jobs|.mil|.mobi|.museum|.name|.net|.org|.pro|.tel|.travel|.xxx|.ac|.ad|.ae|.af|.ag|.ai|.al|.am|.an|.ao|.aq|.ar|.as|.at|.au|.aw|.ax|.az|.ba|.bb|.bd|.be|.bf|.bg|.bh|.bi|.bj|.bm|.bn|.bo|.br|.bs|.bt|.bv|.bw|.by|.bz|.ca|.cc|.cd|.cf|.cg|.ch|.ci|.ck|.cl|.cm|.cn|.co|.cr|.cs|.cu|.cv|.cx|.cy|.cz|.dd|.de|.dj|.dk|.dm|.do|.dz|.ec|.ee|.eg|.er|.es|.et|.eu|.fi|.fj|.fk|.fm|.fo|.fr|.ga|.gb|.gd|.ge|.gf|.gg|.gh|.gi|.gl|.gm|.gn|.gp|.gq|.gr|.gs|.gt|.gu|.gw|.gy|.hk|.hm|.hn|.hr|.ht|.hu|.id|.ie|..il|.im|.in|.io|.iq|.ir|.is|.it|.je|.jm|.jo|.jp|.ke|.kg|.kh|.ki|.km|.kn|.kp|.kr|.kw|.ky|.kz|.la|.lb|.lc|.li|.lk|.lr|.ls|.lt|.lu|.lv|.ly|.ma|.mc|.md|.me|.mg|.mh|.mk|.ml|.mm|.mn|.mo|.mp|.mq|.mr|.ms|.mt|.mu|.mv|.mw|.mx|.my|.mz|.na|.nc|.ne|.nf|.ng|.ni|.nl|.no|.np|.nr|.nu|.nz|.om|.pa|.pe|.pf|.pg|.ph|.pk|.pl|.pm|.pn|.pr|.ps|.pt|.pw|.py|.qa|.re|.ro|.rs|.ru|.Pф|.rw|.sa|.sb|.sc|.sd|.se|.sg|.sh|.si|.sj|.sk|.sl|.sm|.sn|.so|.sr|.st|.su|.sv|.sy|.sz|.tc|.td|.tf|.tg|.th|.tj|.tk|.tl|.tm|.tn|.to|.tp|.tr|.tt|.tv|.tw|.tz|.ua|.ug|.uk|.us|.uy|.uz|.va|.vc|.ve|.vg|.vi|.vn|.vu|.wf|.ws|.ye|.yt|.za|.zm|.zw|.xn--lgbbat1ad8j|.xn--fiqs8s|.xn--fiqz9s|.xn--wgbh1c|.xn--j6w193g|.xn--h2brj9c|.xn--mgbbh1a71e|.xn--fpcrj9c3d|.xn--gecrj9c|.xn--s9brj9c|.xn--xkc2dl3a5ee0h|.xn--45brj9c|.xn--mgba3a4f16a|.xn--mgbayh7gpa|.xn--mgbc0a9azcg|.xn--ygbi2ammx|.xn--wgbl6a|.xn--p1ai|.xn--mgberp4a5d4ar|.xn--90a3ac|.xn--yfro4i67o|.xn--clchc0ea0b2g2a9gcd|.xn--3e0b707e|.xn--fzc2c9e2c|.xn--xkc2al3hye2a|.xn--ogbpf8fl|.xn--kprw13d|.xn--kpry57d|.xn--o3cw4h|.xn--pgbs0dh|.xn--j1amh|.xn--mgbaam7a8h|..Pф|..CP6|.YKP|..dz|.cn|.cn|.eg|.hk|.in|.in|.in|.in|.in|.in|.in|.ir|.jo|.ma|.ps|.qa|.ru|.sa|.rs|.sg|.sg|.kr|.lk|.lk|.sy|.tw|.tw|.th|.tn|.ua|.ae|.xn--54b7fta0cc|.xn--90ae|.xn--node|.xn--4dbrk0ce|.xn--mgb9awbf|.xn--mgbai9azgqp6j|.xn--mgb2ddes|..bd|.bg|.ge|.il|.om|.pk|.ye|.xn--kgbechtv|.xn--hgbk6aj7f53bba|.xn--0zwm56d|.xn--g6w251d|.xn--80akhbyknj4f|.xn--11b5bs3a9aj6g|.xn--jxalpdlp|.xn--9t4b11yi5a|.xn--deba0ad|.xn--zckzah|.xn--hlcj6aya9esc7a|.иCпыTAHиE|.arpa'
$buffer = ClipGet()
;Записываем "строки"/"слова в строках" которые необходимо удалить
;~ Dim $Replaceletter[33][2]=[['а','A'],['б','6'],['в','B'],['г','R'],['д','D'],['е','E'],['ё','E'],['ж','G'],['з','3'],['и','N'],['й','N'],['к','K'],['л','L'],['м','M'],['н','H'],['о','O'],['п','N'],['р','P'],['с','C'],['т','T'],['у','Y'],['ф','F'],['х','X'],['ч','4'],['ь','B'],['я','R'],['ы','bl']]
global $Replaceletter[16][2]=[['а','A'],['б','6'],['в','B'],['г','R'],['е','E'],['з','3'],['к','K'],['м','M'],['н','H'],['о','O'],['р','P'],['с','C'],['т','T'],['у','Y'],['х','X'],['ь','B']]
;~ _ArrayDisplay($Replaceletter)

;Удалить все русские  слова
StringRegExpReplace ( $buffer, " [а-яА-я]{3,}", "replace", )

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
;Записываем слова из первых ячеек которые можно обобщить, например Nero (чтобы удалить все дополнения Nero из списка)
$EqualString = 'Nokia Ovi' & '|' & _
'Samsung PC Studio 3'; & '|' & _
$DelteString=0
$SplitDelteString = StringSplit($DelteString, '|')
;~ _ArrayDisplay($SplitDelteString)


$buffer = ClipGet()
;~ $SplitBuffer = StringSplit(StringStripCR($buffer), @LF) ;второй вариант разбития
$SplitBuffer = StringSplit($buffer, @CR)
Consolewrite($SplitBuffer[0])
;~ _ArrayDisplay($splitBuffer,'ДО')



global $delete [$SplitBuffer[0]+1]
$schet=0
global $splitBufferCell[1]
For $i=1 to $SplitBuffer[0]
;~ 	  ConsoleWrite('нач' & $i & ' ')
;~ 	  ConsoleWrite($splitBuffer[$i] & @CRLF)
	  If StringRegExp ( $splitBuffer[$i], "\S" ) = 0 Then
		 $delete[$i]=1
;~ 		 ConsoleWrite('пустая строка '&$i&' '&$splitBuffer[$i]&@CRLF)
	  Else
		 For $t=1 to $SplitDelteString[0]
;~ 			If StringInStr ( $splitBuffer[$i], $SplitDelteString[$t]) <>0 Then
			If StringRegExp ( $splitBuffer[$i], '\Q'& $SplitDelteString[$t] &'\E') <>0 Then
			   $delete[$i]=1
;~ 			   ConsoleWrite('Найденно совпадение '&$i&' '&$splitBuffer[$i]&@CRLF)
			EndIf
		 Next

		 ;Удаление строк, если первая ячейка уже повторялась
		 $schet+=1
		 if $schet>1 then
			$splitBufferCell2=StringSplit($splitBuffer[$i], @TAB)
			if not @error then
			   For $t=1 to Ubound($splitBufferCell)-1
				  If StringCompare ( $splitBufferCell2[1], $splitBufferCell[$t])=0 then
					 $delete[$i]=1
					 ConsoleWrite('Найденно совпадение '&$i&' '&$splitBuffer[$i]&@CRLF)
				  EndIf
			   Next
			EndIf
		 endif
		 ;Получение массива первых ячеек таблицы, для удаления дубликатов в них
			$splitBufferCells=0
			$splitBufferCells=StringSplit($splitBuffer[$i], @TAB)
			If not @error Then
			   Redim $splitBufferCell[Ubound($splitBufferCell)+1]
			   $splitBufferCell[$i]=$splitBufferCells[1]
			EndIf
	  Endif
;~ 	  ConsoleWrite('кон' & $i & ' ')
Next





;Удаление отмеченных строк
For $i=1 to $SplitBuffer[0]
   if $delete[$i]=1 then
;~ 	  _ArrayDelete($splitBuffer, $i)
	  $splitBuffer[$i]=''
   EndIf
Next
$delete=0

;Удаление пустых строк
   $SplitBuffer=_ArrayClearEmpty($splitBuffer, 0, 1)
;Удаление дубликатов
;~ $SplitBuffer=_ArrayUnique($splitBuffer)
$SplitBuffer=_ArrayRemoveDuplicates($splitBuffer)


;~ ;помещаем текст обратно в буффер
$BufferOut=''
For $i=1 to Ubound($SplitBuffer)-1
;~    $BufferOut += $SplitBuffer[$i] & @CRLF
   $BufferOut=$BufferOut & $SplitBuffer[$i]
Next
;~ ConsoleWrite($BufferOut)
ClipPut($BufferOut)

;~ ConsoleWrite( $DelteString )
_ArrayDisplay($splitBuffer,'После')


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