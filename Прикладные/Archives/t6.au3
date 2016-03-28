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

$text = 'Чтобы иметь стройную фигуру, вы должны заниматься спортом и правильно питаться. Приходите в спортивный зал “Огонек”  — будьте здоровыми и красивыми!' & @CRLF & _
		'Девушки! Приходите в спортивный клуб “Бабочка”. У нас много тренажеров и опытные инструктора, которые подскажут вам как заниматься спортом и правильно питаться, чтобы иметь стройную фигуру и бодрый дух.' & @CRLF & _
		'a &#161; b &iexcl; The ?? federal government on Wednesday said Apple has agreed to pay at least $32.5 million in refunds to parents who didn’t authorize hefty purchases racked up by their children on their iPhones and iPads.'
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
	For $i = 1 to $aText[0] - $ShingleLen ; перебор слов
		$stringForHash = ''
		For $st=0 to $ShingleLen-1 ; соеденение в шингл
			$stringForHash &= $aText[$i+$st]
		Next
		; расчёт хешей
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



	$text = StringLower($text) ; только в нижнем регистре
	$text = StringReplace($text, @CR, ' ')
	$text = StringReplace($text, @LF, ' ')
	$text = StringReplace($text, 'ё', 'е') ; заменить все ё на е
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($text) = ' & StringLen($text) & @CRLF) ;### Debug Console
	$text = _deleteStopwordsBigDic($text)
	$text = StringRegExpReplace($text, '[^a-zа-яё ]', '') ; без символов, без букв, в 1 строку
	; удаление стоп-слов (малый словарь)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($text) = ' & StringLen($text) & @CRLF) ;### Debug Console
	$text = StringRegExpReplace($text, '(?m)( |^)(а|без|более|бы|был|была|были|было|быть|в|вам|вас|весь|во|вот|все|всего|всех|вы|где|да|даже|для|до|его|ее|если|есть' & _
			'|ещё|же|за|здесь|и|из|из-за|или|им|их|к|как|как-то|ко|когда|кто|ли|либо|мне|может|мы|на|надо|наш|не|него|неё|нет|ни' & _
			'|них|но|ну|о|об|однако|он|она|они|оно|от|очень|по|под|при|с|со|так|также|такой|там|те|тем|то|того|тоже|той|только|том' & _
			'|ты|у|уже|хотя|чего|чей|чем|что|чтобы|чьё|чья|эта|эти|это|я|над|ж|б|алтухов|большой|всей|говорить|год|еще|знать|который' & _
			'|мочь|нее|один|оный|ото|свой|себя|сказать|та|тот|этот|ведь|вдоль|вместо|вне|вниз|внизу|внутри|вокруг|всегда|давай|давать' & _
			'|достаточно|её|за исключением|иметь|кроме|мои|мой|навсегда|отчего|после|потому|потому что|почти|про|снова|такие|тут|чего-то)( |$)', ' ')
	$text = StringRegExpReplace($text, '(?m)( |^)[^ ]{0,2}( |$)', ' ') ; удаляем всё что меньше трех символов
	$text = StringRegExpReplace($text, '(?m)( |^)[^ ]{0,2}( |$)', ' ') ; удаляем всё что меньше трех символов
	$text = StringRegExpReplace($text, '(?m)( |^)[^ ]{0,2}( |$)', ' ') ; удаляем всё что меньше трех символов

	$text = StringRegExpReplace($text, '( ){2}', ' ')

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : TimerDiff($timer) = ' & TimerDiff($timer) & @CRLF) ;### Debug Console

	ConsoleWrite($text & @CRLF)
	;~ ClipPut($text)

	; взято из http://www.cyberforum.ru/algorithms/thread55.html Эвристическое извлечение корня из русского слова (Стеммер Портера).
;~ 	$ADJECTIVE = '(?m)( |^)([a-zа-яё]*?(ее|ие|ые|ое|ими|ыми|ей|ий|ый|ой|ем|им|ым|ом|его|ого|ему|ому|их|ых|ую|юю|ая|яя|ою|ею))( |$)'; прилагательное
	$ADJECTIVE = '(?m)( |^)([a-zа-яё]*?(ее|ие|ые|ое|ими|ыми|ей|ий|ый|ой|ем|им|ым|его|ого|ему|ому|их|ых|ую|юю|ая|яя|ою|ею))( |$)'; прилагательное
	;~ $PARTICIPLE = '(?m)( |^)((ивш|ывш|ующ)|(([ая])(ем|нн|вш|ющ|щ)))( |$)'; причастие
	$PARTICIPLE = '(?m)( |^)([a-zа-яё]*?((ивш|ывш|ующ)|[ая](ем|нн|вш|ющ|щ)))( |$)'; причастие
	;глагол
;~ 	$VERB = '(?m)( |^)([a-zа-яё]*?((ила|ыла|ена|ейте|уйте|ите|или|ыли|ей|уй|ил|ыл|им|ым|ен|ило|ыло|ено|ят|ует|уют|ит|ыт|ены|ить|ыть|ишь|ую|ю)|([ая](ла|на|ете|йте|ли|й|л|ем|н|ло|но|ет|ют|ны|ть|ешь|нно))))( |$)';
	$VERB = '(?m)( |^)([a-zа-яё]*?((ила|ыла|ена|ейте|уйте|ите|или|ыли|уй|ил|ыл|им|ым|ен|ило|ыло|ено|ят|ует|уют|ит|ыт|ены|ить|ыть|ишь|ую)|([ая](ла|на|ете|йте|ли|й|л|ем|но|ет|ют|ны|ть|ешь|нно))))( |$)';
	$NOUN = '(?m)( |^)([a-zа-яё]*?(а|ев|ов|ие|ье|е|иями|ями|ами|еи|ии|и|ией|ей|ой|ий|й|иям|ям|ием|ем|ам|ом|о|у|ах|иях|ях|ы|ь|ию|ью|ю|ия|ья|я))( |$)'; существительное
	;~ $RVRE = '/^(.*?[аеиоуыэюя])(.*)$/'; если до конца слова одни гласные
	;~ $DERIVATIONAL = '(?m)( |^)([a-zа-яё]*?[^аеиоуыэюя ][аеиоуыэюя]+[^аеиоуыэюя ]+[аеиоуыэюя][^ ]*?о?сть?)( |$)'; рабочая

	StringSplit($text, ' ')

	$aADJECTIVE = StringRegExp($text, $ADJECTIVE, 3)
	$aADJECTIVE = _ClearStrregexpArray($aADJECTIVE, 1, 4)
	$aVERB = StringRegExp($text, $VERB, 3)
	$aVERB = _ClearStrregexpArray($aVERB, 1, 7)
	$aNOUN = StringRegExp($text, $NOUN, 3)
	$aNOUN = _ClearStrregexpArray($aNOUN, 1, 4)

	; отчистить от прилагательных и глаголов если удастся найти
	$aText = StringSplit($text, ' ')
	Local $atext2[$aText[0] + 1]
	$schet = 1
	For $i = 1 To $aText[0]
		If StringLen($aText[$i]) <= 3 Then
			If StringRegExp($aText[$i], $NOUN) Then
				$atext2[$schet] = $aText[$i]
				$schet += 1
			ElseIf StringRegExp($aText[$i], $ADJECTIVE) Then
				;пропустить прилагательное
			ElseIf StringRegExp($aText[$i], $VERB) Then
				;пропустить глагол
			Else
				; если не определена часть речи учесть это слово
				$atext2[$schet] = $aText[$i]
				$schet += 1
			EndIf
		Else
			; учесть все короткие слова, т.к. определить их часть речи не так просто
			$atext2[$schet] = $aText[$i]
			$schet += 1
		EndIf

	Next
	$atext2 = _ArrayClearEmpty($atext2, 0, 1)
	$atext2[0] = UBound($atext2) - 1
	;~ _ArrayDisplay($atext2)

	;Удалить окончания
	$endings = "(?m)( |^)([a-zа-яё]*?)(ы|у|ем|ым|ет|им|ам|ить|ий|ю|ый|ой|ая|ое|ые|ому|а|о|у|е|ого|ему|и|ых|ох|ия|ий|ь|я|он|ют|ат)( |$)"
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
	Local $aStopwordsBigDic[479] = ['исходя из вышеизложенного необходимо отметить', 'исходя из вышеизложенного необходимо сказать', _
			'исходя из вышеизложенного стоит отметить', 'исходя из вышеизложенного стоит сказать', _
			'исходя из вышеизложенного хотелось бы', 'набирает всё большую популярность', 'даже самым изысканным ценителям', _
			'существует устоявшееся мнение', 'каждый из нас не раз слышал', 'на самый взыскательный вкус', 'нельзя не согласиться с тем', _
			'в нашей повседневной жизни', 'также хотелось бы отметить', 'вдобавок ко всему прочему', 'по справедливости говоря', _
			'во все времена считалось', 'все мы прекрасно знаем', 'сразу следует заметить', 'также следует отметить', _
			'по своему обыкновению', 'само собой разумеется', 'нельзя не согласиться', 'ни для кого не секрет', _
			'трудно не согласиться', 'без всякого сомнения', 'вне всякого сомнения', 'как принято говорить', _
			'помимо всего прочего', 'с позволения сказать', 'лишний раз упомянуть', 'нужно сразу отметить', _
			'очень важно понимать', 'также можно отметить', 'также нужно отметить', 'кроме всего прочего', _
			'по всей вероятности', 'по чести признаться', 'с вашего позволения', 'с вашего разрешения', 'с моей точки зрения', _
			'с твоего позволения', 'с твоего разрешения', 'в некоторых случаях', 'нельзя не упомянуть', 'по словам экспертов', _
			'совершенно очевидно', 'также хочу отметить', 'хотелось бы сказать', 'как бы там ни было', 'как это ни странно', _
			'откровенно сказать', 'по совести сказать', 'по существу говоря', 'правильнее сказать', 'признаться сказать', _
			'против обыкновения', 'сказать по совести', 'нельзя не отметить', 'трудно переоценить', 'благодарение богу', _
			'в сущности говоря', 'если хотите знать', 'если хочешь знать', 'к вашему сведению', 'к примеру сказать', 'к твоему сведению', _
			'как бы то ни было', 'между нами говоря', 'ничего не скажешь', 'откровенно говоря', 'по всей видимости', 'по правде сказать', _
			'по совести говоря', 'по справедливости', 'правильнее говоря', 'сказать по правде', 'собственно говоря', 'в настоящее время', _
			'достаточно сложно', 'нельзя не сказать', 'очень важно знать', 'следует упомянуть', 'существует мнение', 'уже не новостьчто', _
			'хочу напомнитьчто', 'а вернее сказать', 'в первую очередь', 'во всяком случае', 'как вам известно', 'ко всему прочему', _
			'на первый взгляд', 'по вашему мнению', 'по правде говоря', 'по твоему мнению', 'по чести сказать', 'попросту сказать', _
			'предположительно', 'представьте себе', 'с другой стороны', 'сказать по чести', 'со своей стороны', 'шутка ли сказать', _
			'все очень просто', 'на самом же деле', 'примечательночто', 'следует заметить', 'следует отметить', 'а лучше сказать', _
			'а следовательно', 'вероятнее всего', 'вообразите себе', 'да и то сказать', 'другими словами', 'и таким образом', _
			'к радости своей', 'к слову сказать', 'как ни говорите', 'как оказывается', 'как перед богом', 'мягко выражаясь', _
			'по крайней мере', 'по моему мнению', 'по чести говоря', 'подумать только', 'попросту говоря', 'с одной стороны', _
			'что ни говорите', 'что удивительно', 'главным образом', 'если говорить о', 'известно ли вам', 'многим известно', _
			'принято считать', 'а между прочим', 'в конце концов', 'в свою очередь', 'вернее сказать', 'дай бог память', 'если позволите', _
			'если позволишь', 'еще того лучше', 'к стыду своему', 'как выяснилось', 'как выясняется', 'как говорилось', 'как исключение', _
			'как ни странно', 'как полагается', 'коротко говоря', 'кстати сказать', 'можно подумать', 'на твой взгляд', 'на худой конец', _
			'нечего сказать', 'по обыкновению', 'по определению', 'по сути говоря', 'правду сказать', 'представь себе', 'с точки зрения', _
			'соответственно', 'точнее сказать', 'что и говорить', 'что называется', 'в любом случае', 'в связи с этим', 'не удивительно', _
			'нотем не менее', 'нужно отметить', 'вернее говоря', 'вообрази себе', 'вообще говоря', 'главным делом', 'грешным делом', _
			'действительно', 'делать нечего', 'еще того хуже', 'иначе сказать', 'как говорится', 'как ни говори', 'как оказалось', _
			'как по заказу', 'как следствие', 'короче говоря', 'кстати говоря', 'легко сказать', 'лучше сказать', 'может статься', _
			'можно сказать', 'на ваш взгляд', 'на мой взгляд', 'на самом деле', 'надо полагать', 'но кроме того', 'по сообщениям', _
			'понятное дело', 'правду говоря', 'проще сказать', 'следовательно', 'строго говоря', 'судя по всему', 'так или иначе', _
			'таким образом', 'точнее говоря', 'что ни говори', 'шутка сказать', 'бытует мнение', 'в то же время', 'всем известно', _
			'многие скажут', 'не самом деле', 'а может быть', 'без сомнения', 'в самом деле', 'вне сомнения', 'главное дело', 'грубо говоря', _
			'и кроме того', 'и лучше того', 'и того лучше', 'иначе говоря', 'истинный бог', 'к прискорбию', 'как известно', 'как на заказ', _
			'как например', 'как положено', 'мало сказать', 'между прочим', 'мягко говоря', 'на несчастье', 'но вообще-то', 'одним словом', _
			'по видимости', 'по прогнозам', 'по сведениям', 'по сообщению', 'по сути дела', 'помимо всего', 'помимо этого', 'прежде всего', _
			'проще говоря', 'скорее всего', 'спрашивается', 'чего доброго', 'в наше время', 'каждый знает', 'не секретчто', 'не так давно', _
			'считаетсячто', 'тем не менее', 'что касается', 'больше того', 'в частности', 'должно быть', 'если угодно', 'если хотите', _
			'если хочешь', 'естественно', 'и того хуже', 'и хуже того', 'к несчастью', 'к огорчению', 'к сожалению', 'к удивлению', 'казалось бы', _
			'как водится', 'как говорят', 'как нарочно', 'как правило', 'как принято', 'как сказано', 'как сказать', 'кроме шуток', 'кроме этого', _
			'надо думать', 'оказывается', 'определенно', 'по преданию', 'по существу', 'по-видимому', 'поверите ли', 'поверишь ли', 'помимо того', _
			'право слово', 'предположим', 'представьте', 'согласитесь', 'так сказать', 'важно знать', 'напомнимчто', 'удивительно', 'а наоборот', _
			'а например', 'безусловно', 'более того', 'быть может', 'в общем-то', 'в принципе', 'в сущности', 'вообразите', 'знамо дело', _
			'и наоборот', 'как видите', 'как видишь', 'как всегда', 'как обычно', 'как хотите', 'как хочешь', 'кроме того', 'между нами', _
			'может быть', 'на счастье', 'называется', 'натурально', 'несомненно', 'откровенно', 'по замыслу', 'по совести', 'по счастью', _
			'пожалуйста', 'получается', 'правильнее', 'признаться', 'разумеется', 'само собой', 'сверх того', 'слава богу', 'собственно', _
			'стало быть', 'ясное дело', 'конечно же', 'напомнючто', 'скажем так', 'это значит', 'а впрочем', 'а главное', 'без шуток', 'бесспорно', _
			'в-третьих', 'верите ли', 'веришь ли', 'видит бог', 'видите ли', 'видишь ли', 'во-вторых', 'во-первых', 'воля ваша', 'воля твоя', _
			'вообще-то', 'еще лучше', 'знаете ли', 'знаешь ли', 'к примеру', 'к радости', 'к счастью', 'как видно', 'как знать', 'как назло', _
			'мало того', 'надо быть', 'однако же', 'по данным', 'по мнению', 'по обычаю', 'по правде', 'по словам', 'по слухам', 'по-вашему', _
			'по-ихнему', 'по-нашему', 'по-твоему', 'позвольте', 'положимте', 'помилуйте', 'представь', 'признаюсь', 'интересно', 'между тем', _
			'наверняка', 'считается', 'а вернее', 'а значит', 'а точнее', 'бог даст', 'вероятно', 'возможно', 'воистину', 'вообрази', 'допустим', _
			'еще хуже', 'значится', 'и вообще', 'и однако', 'и правда', 'известно', 'казалось', 'наверное', 'наоборот', 'например', 'напротив', _
			'нет слов', 'очевидно', 'по-моему', 'помнится', 'примерно', 'серьезно', 'слов нет', 'случайно', 'слышь ты', 'шутка ли', 'зачастую', _
			'новсё же', 'при этом', 'в общем', 'вестимо', 'впрочем', 'выходит', 'главное', 'говорят', 'к слову', 'к стыду', 'к ужасу', 'к чести', _
			'кажется', 'конечно', 'на беду', 'наверно', 'надеюсь', 'наконец', 'по идее', 'по сути', 'пожалуй', 'позволь', 'положим', 'помилуй', _
			'понятно', 'почитай', 'случаем', 'слыхать', 'в целом', 'бывает', 'бывало', 'вернее', 'видать', 'видимо', 'вообще', 'знаете', 'знаешь', _
			'значит', 'кажись', 'короче', 'кстати', 'небось', 'однако', 'по мне', 'похоже', 'правда', 'скажем', 'скорее', 'словом', 'слышно', _
			'точнее', 'и хотя', 'верно', 'видно', 'далее', 'жалко', 'знамо', 'знать', 'лучше', 'может', 'право', 'слышь', 'вишь', 'жаль', 'поди', _
			'итак', 'мол']
	Local $aPlaguewordsExp = ['исходя из вышеизложенного хотелось [А-яЁё]*?', '(можешь|можете) (себе )?(представить|вообразить)', _
			'(ну, это |ну это |это )?как сказать', 'при всём (должном / моём )?уважении', 'что ещё( я могу вам сказать)?', _
			'в данный момент( времени)?', 'представь(-то|то| то)?себе', '(и )?всё такое( прочее)?', '(знаешь|знаете)( ли)?', _
			'в общем(-то|то| то)?', '(грубо|мягко) говоря', 'собственно( говоря)?', 'вообще(-то|то| то)?', '(ну, |ну )?не знаю', _
			'(ну вы )?понимаете', '(вот )?смотри(те)?', '(да, |да )?кстати', '(ну )?канеш(на)?', 'типа того( что)?', _
			'понимаете( ли)?', 'по ходу( дела)?', 'вот так( вот)?', '(а )?вы знаете', 'значит(са|ца)?', '(ты )? прикинь', _
			'(значить|а) тут', 'ну (так )?вот', 'похоже( что)?', 'так-то( вот)?', 'только( вот)?', 'видите( ли)?', '(а )?в целом', _
			'(вот )?блин', '(вот )?ведь', '(ну )?на фиг', 'так( вот)?', '(ну )?там']
	Local $aPlaguewords = ['если можно так сказать', 'понимаете какое дело', 'как бы это сказать', 'это и коню понятно', 'ну как вам сказать', _
			'в некотором роде', 'сами понимаете', 'как говорится', 'на самом деле', 'я имею ввиду ', 'в самом деле', 'ёлки зелёные', 'без сомнения', _
			'предположим', 'значить так', 'практически', 'предположим', 'я бы сказал', 'так сказать', 'в принципе', 'дело в том', 'может быть', _
			'конечно же', 'ну в общем', 'потому что', 'фактически', 'абсолютно', 'буквально', 'ёшкин кот', 'а-фи-геть', 'конкретно', 'к примеру', _
			'по-любому', 'понимаешь', 'так скать', 'это самое', 'допустим', 'а как же', 'например', 'пакамись', 'покамест', 'послушай', 'допустим', _
			'такскать', 'во-о-от', 'как его', 'отлично', 'понятно', 'то есть', 'видишь', 'значит', 'кошмар', 'ужасно', 'как бы', 'короче', 'значит', _
			'ну так', 'правда', 'слушай', 'просто', 'скажем', 'ну, тк', 'ёпрст', 'жесть', 'понял', 'ну тк', 'прямо', 'прям', 'дико', 'итак', 'мэ-э', _
			'не-е', 'нутк', 'тыкс', 'типа', 'э-ээ', 'ага', 'тут', 'вот', 'что', 'так', 'дык', 'нет', 'это', 'так', 'дык', 'это', 'угу', 'ага', 'уже', _
			'да', 'ну', 'ты']

	;обработка текста
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
	$sText = StringRegExpReplace($sText, '(?s)<!--.*?-->', '') ; удаление комментариев

	; ============= блок colspan, rowspan
	$0 = Chr(0)
	$Rep = StringRegExp($sText, '(?s)(<[^<>]+?(?:colspan|rowspan)[^<>]+?>)', 3) ; в массив
	If Not @error Then
		$Tr = 1
		$sText = StringRegExpReplace($sText, '(?s)(<[^<>]+?(?:colspan|rowspan)[^<>]+?[^/]>)', $0) ; временная подмена
	EndIf
	$sText = StringRegExpReplace($sText, '(?s)(<(?:' & $teg & '))[\r\n]* [^<>]*?(>)', '\1\2') ; очистка

	If $Tr Then
		For $i = 0 To UBound($Rep) - 1
			$Rep[$i] = _Replace($Rep[$i])
			$sText = StringReplace($sText, $0, $Rep[$i], 1)
		Next
	EndIf
	; =============

	$sText = StringReplace($sText, '<p><o:p>&nbsp;</o:p></p>', '<br><br>') ; замена переносов строк
	; $sText=StringRegExpReplace($sText, '(?s)(<('&$teg&').*?>)(.*?)</\2>(\s*)\1', '\1\3\4') ; очистка дублирования
	$sText = StringRegExpReplace($sText, '(?s)<(' & $teg & ')[^<>]*?>[\x{A0}\s]*?</\1>', '') ; очистка тегов без контента

	$DelAll = 'xml|style|script'
	$sText = StringRegExpReplace($sText, '(?s)<(' & $DelAll & ')[^<>]*>(.*?)</\1>', '') ; удаление с содержимым

	$DelTag = 'span'
;~ 	$sText = StringRegExpReplace($sText, '(?s)</?(' & $DelTag & ')[^<>]*>', '') ; удаление самих тегов

	Return $sText
EndFunc   ;==>_ClearHTML

Func _Replace($Rep)
	$teg = 'table|td|tr|th'
	$aRep = StringRegExp($Rep, '((?:colspan|rowspan)\h*=\h*"?\d+"?)', 3)
	$Rep = StringRegExpReplace($Rep, '(?s)(<(?:' & $teg & ')) .*?(>)', '\1') ; очистка
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
'<title>Стена</title>' & @CRLF & _
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
'" onmousedown="tnActive(this)">люди</a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td style=""><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="head_communities" href="/search?c[section]=communities" onclick="return nav.go(this, event, {search: true, nofram' & _
'e: true});" onmousedown="tnActive(this)">сообщества</a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td style=""><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="head_games" href="/apps" onclick="return nav.go(this, event, {noback: true});" onmousedown="tnActive(this)">игры<' & _
'/a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td style=""><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="head_music" href="/audios196112742?act=popular" onclick="return Pads.show('&"'"&'mus'&"'"&', event);" onmousedown' & _
'="tnActive(this)">' & @CRLF & _
'          <span id="head_music_text">музыка</span>' & @CRLF & _
'          <div id="head_play_btn" onmouseover="addClass(this, '&"'"&'over'&"'"&');" onmouseout="removeClass(this, '&"'"&'over'&"'"&'); removeClass(th' & _
'is, '&"'"&'down'&"'"&')" onmousedown="addClass(this, '&"'"&'down'&"'"&'); addClass(ge('&"'"&'head_music'&"'"&'), '&"'"&'head_play_down'&"'"&');" onmou' & _
'seup="removeClass(this, '&"'"&'down'&"'"&')" onclick="headPlayPause(event); return Pads.show('&"'"&'mus'&"'"&', event);"></div>' & @CRLF & _
'        </a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td id="support_link_td" style=""><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="top_support_link" href="/support?act=home" onclick="return nav.go(this, event, {noback: true});" onmousedown="tnA' & _
'ctive(this)">помощь</a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'      <td id="logout_link_td"><nobr>' & @CRLF & _
'        <a class="top_nav_link" id="logout_link" href="https://login.vk.com/?act=logout&hash=122ba0536ee27df72e&_origin=http://vk.com" onclick="if (c' & _
'heckEvent(event) === false) { window.Notifier && Notifier.lcSend('&"'"&'logged_off'&"'"&'); location.href = this.href; return cancelEvent(event); }" o' & _
'nmousedown="tnActive(this)">выйти</a>' & @CRLF & _
'      </nobr></td>' & @CRLF & _
'    </tr>' & @CRLF & _
'  </table>' & @CRLF & _
'  <div id="ts_wrap" class="clear_fix">' & @CRLF & _
'    <div id="ts_input_wrap" class="ts_input_wrap fl_r" onmouseover="TopSearch.highlightInput(true); TopSearch.initFriendsList();" onmouseout="TopSear' & _
'ch.highlightInput(false)">' & @CRLF & _
'      <div class="ts" onmousedown="event.cancelBubble = true;">' & @CRLF & _
'        <div class="ts_input_wrap2"><div>' & @CRLF & _
'          <input type="text" onmousedown="event.cancelBubble = true;" ontouchstart="event.cancelBubble = true;" class="text" id="ts_input" autocomple' & _
'te="off" placeholder="Поиск" />' & @CRLF & _
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
'      <a href="/id196112742" onclick="return nav.go(this, event, {noback: true})" id="myprofile" class="left_row"><span class="left_label inl_bl">Моя' & _
' Страница</span></a>' & @CRLF & _
'    </td>' & @CRLF & _
'    <td id="myprofile_edit_wrap">' & @CRLF & _
'      <a href="/edit" id="myprofile_edit" class="left_row"><span class="left_label inl_bl">ред.</span></a>' & @CRLF & _
'    </td>'
$htmltext &= '  </tr></table>' & @CRLF & _
'</li><li id="l_fr"><a href="/friends" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row">' & _
'<span class="left_count_pad" onmouseover="Pads.preload('&"'"&'fr'&"'"&')" onmousedown="return Pads.show('&"'"&'fr'&"'"&', event)" onclick="return (che' & _
'ckEvent(event) || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_wrap  fl_r"><span class="inl_bl left_count">+2</span></span></sp' & _
'an><span class="left_label inl_bl">Мои Друзья</span></a></li><li id="l_ph"><a href="/albums196112742" onclick="return nav.go(this, event, {noback: tru' & _
'e, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_pad" onmouseover="Pads.preload('&"'"&'ph'&"'"&')" onmousedown="' & _
'return Pads.show('&"'"&'ph'&"'"&', event)" onclick="return (checkEvent(event) || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_w' & _
'rap  left_void fl_r"><span class="inl_bl left_plus">+</span></span></span><span class="left_label inl_bl">Мои Фотографии</span></a></li><li id="l_vid"' & _
'><a href="/video" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_cou' & _
'nt_pad" onmouseover="Pads.preload('&"'"&'vid'&"'"&')" onmousedown="return Pads.show('&"'"&'vid'&"'"&', event)" onclick="return (checkEvent(event) || b' & _
'rowser.msie6) ? true : cancelEvent(event)"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span></span><span cl' & _
'ass="left_label inl_bl">Мои Видеозаписи</span></a></li><li><a href="/audios196112742" onclick="return nav.go(this, event, {noback: true, params: {_ref' & _
': '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class' & _
'="left_label inl_bl">Мои Аудиозаписи</span></a></li><li id="l_msg"><a href="/im" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'" & _
'left_nav'&"'"&'}});" class="left_row"><span class="left_count_pad left_count_persist" onmouseover="Pads.preload('&"'"&'msg'&"'"&')" onmousedown="r' & _
'eturn Pads.show('&"'"&'msg'&"'"&', event)" onclick="return (checkEvent(event) || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_w' & _
'rap  fl_r"><span class="inl_bl left_count">+47</span></span></span><span class="left_label inl_bl">Мои Сообщения</span></a></li><li style="display: no' & _
'ne" id="l_nts"><a href="/notes" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span c' & _
'lass="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class="left_label inl_bl">Мои Заметки</span></a></li><li id' & _
'="l_gr"><a href="/groups" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="' & _
'left_count_pad" onmouseover="Pads.preload('&"'"&'gr'&"'"&')" onmousedown="return Pads.show('&"'"&'gr'&"'"&', event)" onclick="return (checkEvent(event' & _
') || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_wrap  fl_r"><span class="inl_bl left_count">+1</span></span></span><span clas' & _
's="left_label inl_bl">Мои Группы</span></a></li><li style="display: none" id="l_ev"><a href="/events" onclick="return nav.go(this, event, {noback: tru' & _
'e, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></' & _
'span><span class="left_label inl_bl">Мои Встречи</span></a></li><li id="l_nwsf"><a href="/feed" onclick="return nav.go(this, event, {noback: true, par' & _
'ams: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><' & _
'span class="left_label inl_bl">Мои Новости</span></a></li><li id="l_nws"><a href="/feed?section=notifications" onclick="return nav.go(this, event, {no' & _
'back: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_pad left_count_persist" onmouseover="Pads.preload('&"'" & _
'nws'&"'"&')" onmousedown="return Pads.show('&"'"&'nws'&"'"&', event)" onclick="return (checkEvent(event) || browser.msie6) ? true : cancelEvent(eve' & _
'nt)"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span></span><span class="left_label inl_bl">Мои Ответы</sp' & _
'an></a></li><li id="l_set"><a href="/settings" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="le' & _
'ft_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class="left_label inl_bl">Мои Настройки</spa' & _
'n></a></li><div class="more_div"></div><li id="l_ap"><a href="/apps" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav' & _
''&"'"&'}});" class="left_row"><span class="left_count_pad left_count_persist" onmouseover="Pads.preload('&"'"&'ap'&"'"&')" onmousedown="return Pads.sh' & _
'ow('&"'"&'ap'&"'"&', event)" onclick="return (checkEvent(event) || browser.msie6) ? true : cancelEvent(event)"><span class="left_count_wrap  fl_r"><sp' & _
'an class="inl_bl left_count">+22</span></span></span><span class="left_label inl_bl">Приложения</span></a></li><li><a href="/docs" onclick="return nav' & _
'.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class=' & _
'"inl_bl left_plus">+</span></span><span class="left_label inl_bl">Документы</span></a></li><li style="display: none" id="l_ads"><a href="/ads?act=offi' & _
'ce&last=1" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&'}});" class="left_row"><span class="left_count_wrap' & _
'  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class="left_label inl_bl">Реклама</span></a></li><div class="more_div"></div><li' & _
' id="l_app3373454"><a href="/app3373454_196112742" onclick="return nav.go(this, event, {noback: true, params: {_ref: '&"'"&'left_nav'&"'"&', ref: 1}})' & _
';" class="left_row"><span class="left_count_wrap  left_void fl_r"><span class="inl_bl left_plus">+</span></span><span class="left_label inl_bl">Мертва' & _
'я зона</span></a></li>' & @CRLF & _
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
'    <b class="tab_word">Записи сообщества</b>' & @CRLF & _
'  </a>' & @CRLF & _
'</li><li id="fw_search_toggler" class="t_r"><a href="/wall-40529013?search=1">Перейти к поиску</a></li></ul>' & @CRLF & _
'</div>' & @CRLF & _
'<div class="big_wall_post"><div class="wall_module"></div></div>' & @CRLF & _
'<div class="summary_wrap" id="fw_summary_wrap"><div class="pg_pages fl_r" id="fw_pages"><a class="pg_lnk_sel fl_l" href="/wall-40529013?own=1&offset=' & _
'0"><div class="pg_in">1</div></a><a class="pg_lnk fl_l" href="/wall-40529013?own=1&offset=20" onclick="return nav.go(this, event)"><div class="pg_in"' & _
'>2</div></a><a class="pg_lnk fl_l" href="/wall-40529013?own=1&offset=40" onclick="return nav.go(this, event)"><div class="pg_in">3</div></a><a class="' & _
'pg_lnk fl_l" href="/wall-40529013?own=1&offset=12080" onclick="return nav.go(this, event)"><div class="pg_in">&raquo;</div></a></div>' & @CRLF & _
'<div class="summary" id="fw_summary">Всего 12<span class="num_delim"> </span>093 записи</div></div>' & @CRLF & _
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
"'"&'Пожаловаться'&"'"&', '&"'"&'post_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_486399'&"'"&', '&"'"&'post_delete'&"'"&')"' & _
'></div></div></div>' & @CRLF & _
'      <div class="wall_text"><div class="wall_text_name"><a class="author" href="/horror_tales" data-from-id="-40529013" data-post-id="-40529013_4863' & _
'99">Страшные истории</a> <span class="explain">&nbsp;запись закреплена</span></div> <div id="wpt-40529013_486399"><div class="page_post_sized_thumbs  ' & _
'clear_fix" style="width: 537px; height: 313px;"><a  href="/page-40529013_46371765" onclick="return showWiki({oid: -40529013, id: 46371765, hide_title:' & _
' 1}, false, event, {queue: 1});" style="width: 537px; height: 313px;" class="page_post_thumb_wrap  page_post_thumb_last_column page_post_thumb_last_ro' & _
'w"><img src="http://cs7054.vk.me/c540102/v540102388/1164e/TRPGWGKXKko.jpg" width="537" height="313" style=""  class="page_post_thumb_sized_photo" /></' & _
'a></div><div class="media_desc media_desc__">' & @CRLF & _
'  <a class="lnk"  id="post_media_lnk-40529013_486399_2" href="/page-40529013_46371765" onclick="return showWiki({oid: -40529013, id: 46371765, hide_t' & _
'itle: 1}, false, event, {queue: 1});" onmouseover="wall.postTooltip(this, '&"'"&'-40529013_486399'&"'"&', {i: '&"'"&'2'&"'"&'})">' & @CRLF & _
'    <b class="fl_l "></b>Страница' & @CRLF & _
'    <span class="a">Самые страшные истории</span></a><div class="post_media_link_preview_wrap inl_bl"><button class="flat_button" onclick="showWiki({' & _
'w: '&"'"&'page-40529013_46371765'&"'"&', hide_title: 1}, false, event, {queue: 1});"><span class="wall_postlink_preview_btn_label">Просмотреть</span><' & _
'/button></div>' & @CRLF & _
'</div></div></div>' & @CRLF & _
'      <div class="post_full_like_wrap sm fl_r">' & @CRLF & _
'  <div class="post_full_like">' & @CRLF & _
'    <div class="post_like fl_r"  onmouseover="wall.postLikeOver('&"'"&'-40529013_486399'&"'"&')" onmouseout="wall.postLikeOut('&"'"&'-40529013_486399' & _
''&"'"&')" onclick="wall.like('&"'"&'-40529013_486399'&"'"&', '&"'"&'8f5ab1088baf28db9c'&"'"&'); event.cancelBubble = true;">' & @CRLF & _
'      <span class="post_like_link fl_l" id="like_link-40529013_486399">Мне нравится</span>' & @CRLF & _
'      <i class="post_like_icon sp_main  fl_l" id="like_icon-40529013_486399"></i>' & @CRLF & _
'      <span class="post_like_count fl_l" id="like_count-40529013_486399">44436</span>' & @CRLF & _
'    </div>' & @CRLF & _
'    <div class="post_share fl_r "  onmouseover="wall.postShareOver('&"'"&'-40529013_486399'&"'"&')" onmouseout="wall.postShareOut('&"'"&'-40529013_48' & _
'6399'&"'"&', event)" onclick="wall.likeShareCustom('&"'"&'-40529013_486399'&"'"&'); event.cancelBubble = true;">' & @CRLF & _
'      <span class="post_share_link fl_l" id="share_link-40529013_486399">Поделиться</span>' & @CRLF & _
'      <i class="post_share_icon sp_main fl_l" id="share_icon-40529013_486399"></i>' & @CRLF & _
'      <span class="post_share_count fl_l" id="share_count-40529013_486399">5875</span>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>' & @CRLF & _
'</div>' & @CRLF & _
'      <div class="replies"><div class="reply_link_wrap sm" id="wpe_bottom-40529013_486399">' & @CRLF & _
'  <small><a  href="/wall-40529013_486399" onclick="return showWiki({w: '&"'"&'wall-40529013_486399'&"'"&'}, false, event);" ><span class="rel_date">3' & _
'1 дек 2013</span></a></small><span class="divide">|</span><a class="reply_link" onclick="Wall.likeShareCustom('&"'"&'-40529013_486399'&"'"&')">Ответит' & _
'ь</a>' & @CRLF & _
'</div>' & @CRLF & _
'<div class="replies_wrap clear" id="replies_wrap-40529013_486399" style="">' & @CRLF & _
'  <div id="replies-40529013_486399"><a class="wr_header" onclick="return wall.showReplies('&"'"&'-40529013_486399'&"'"&', false, false, event);" offs' & _
'="3/79" href="/wall-40529013_486399?offset=last&f=replies">' & @CRLF & _
'  <div class="wrh_text" id="wrh_text-40529013_486399">Показать все 79 комментариев</div>' & @CRLF & _
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
''&"'"&'Пожаловаться'&"'"&', '&"'"&'reply_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_600826'&"'"&', '&"'"&'reply_delete'&"'" & _
')"></div></div></div>' & @CRLF & _
'      <div class="reply_text" >' & @CRLF & _
'        <a class="author" href="/id251721594" data-from-id="251721594">Клара Альтро</a> <div id="wpt-40529013_600826"><div class="wall_reply_text">&q' & _
'uot;Приятного аппетита, дорогая&#33;&quot; и &quot;Шоу: Конструктор&quot; вообще шикарные истории&#33; Прям сочные, вах, как пэрсик&#33; Муа))</div></' & _
'div>' & @CRLF & _
'      </div>' & @CRLF & _
'      <div class="info_footer sm" id="wpe_bottom-40529013_600826">' & @CRLF & _
'        <div class="like_wrap fl_r" onclick="wall.like('&"'"&'-40529013_wall_reply600826'&"'"&', '&"'"&'2e4941fb337156ec29'&"'"&'); event.cancelBubbl' & _
'e = true;" onmouseover="wall.likeOver('&"'"&'-40529013_wall_reply600826'&"'"&')" onmouseout="wall.likeOut('&"'"&'-40529013_wall_reply600826'&"'"&')">' & _
'  <span class="like_link fl_l" id="like_link-40529013_wall_reply600826">Мне нравится</span>' & @CRLF & _
'  <i class=" fl_l" id="like_icon-40529013_wall_reply600826"></i>' & @CRLF & _
'  <span class="like_count fl_l" id="like_count-40529013_wall_reply600826">58</span>' & @CRLF & _
'</div>'
$htmltext &= '        <a class="wd_lnk"  href="/wall-40529013_486399?reply=600826" onclick="return showWiki({w: '&"'"&'wall-40529013_486399'&"'"&', reply: '&"'"&'6' & _
'00826'&"'"&'}, false, event);" ><span class="rel_date">10 сен в 19:29</span></a>' & @CRLF & _
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
''&"'"&'Пожаловаться'&"'"&', '&"'"&'reply_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_600849'&"'"&', '&"'"&'reply_delete'&"'"& _
')"></div></div></div>' & @CRLF & _
'      <div class="reply_text" >' & @CRLF & _
'        <a class="author" href="/id155008242" data-from-id="155008242">Яночка Волкова</a> <div id="wpt-40529013_600849"><div class="wall_reply_text">' & _
'Я в комментах&#33;^°^И ЗАПОМНИТЕ ЭТО КОММЕНТ НЕВОЗМОЖНО ЛАЙКНУТЬ&#33;&#33;&#33;</div></div>' & @CRLF & _
'      </div>' & @CRLF & _
'      <div class="info_footer sm" id="wpe_bottom-40529013_600849">' & @CRLF & _
'        <div class="like_wrap fl_r" onclick="wall.like('&"'"&'-40529013_wall_reply600849'&"'"&', '&"'"&'98d43e5825426b7dbf'&"'"&'); event.cancelBubbl' & _
'e = true;" onmouseover="wall.likeOver('&"'"&'-40529013_wall_reply600849'&"'"&')" onmouseout="wall.likeOut('&"'"&'-40529013_wall_reply600849'&"'"&')">' & _
'  <span class="like_link fl_l" id="like_link-40529013_wall_reply600849">Мне нравится</span>' & @CRLF & _
'  <i class=" fl_l" id="like_icon-40529013_wall_reply600849"></i>' & @CRLF & _
'  <span class="like_count fl_l" id="like_count-40529013_wall_reply600849">210</span>' & @CRLF & _
'</div>' & @CRLF & _
'        <a class="wd_lnk"  href="/wall-40529013_486399?reply=600849" onclick="return showWiki({w: '&"'"&'wall-40529013_486399'&"'"&', reply: '&"'"&'6' & _
'00849'&"'"&'}, false, event);" ><span class="rel_date">10 сен в 19:36</span></a>' & @CRLF & _
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
''&"'"&'Пожаловаться'&"'"&', '&"'"&'reply_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_602361'&"'"&', '&"'"&'reply_delete'&"'" & _
')"></div></div></div>' & @CRLF & _
'      <div class="reply_text" >' & @CRLF & _
'        <a class="author" href="/id166275243" data-from-id="166275243">Оля Петрова</a> <div id="wpt-40529013_602361"><div class="wall_reply_text">поп' & _
'ала в коменты считай что сорвала джек пот)) revenge 1,2 супер</div></div>' & @CRLF & _
'      </div>' & @CRLF & _
'      <div class="info_footer sm" id="wpe_bottom-40529013_602361">' & @CRLF & _
'        <div class="like_wrap fl_r" onclick="wall.like('&"'"&'-40529013_wall_reply602361'&"'"&', '&"'"&'ca4a1783c47f5d14f7'&"'"&'); event.cancelBubbl' & _
'e = true;" onmouseover="wall.likeOver('&"'"&'-40529013_wall_reply602361'&"'"&')" onmouseout="wall.likeOut('&"'"&'-40529013_wall_reply602361'&"'"&')">' & _
'  <span class="like_link fl_l" id="like_link-40529013_wall_reply602361">Мне нравится</span>' & @CRLF & _
'  <i class=" fl_l" id="like_icon-40529013_wall_reply602361"></i>' & @CRLF & _
'  <span class="like_count fl_l" id="like_count-40529013_wall_reply602361">21</span>' & @CRLF & _
'</div>' & @CRLF & _
'        <a class="wd_lnk"  href="/wall-40529013_486399?reply=602361" onclick="return showWiki({w: '&"'"&'wall-40529013_486399'&"'"&', reply: '&"'"&'6' & _
'02361'&"'"&'}, false, event);" ><span class="rel_date">15 окт в 2:26</span></a>' & @CRLF & _
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
"'"&'Пожаловаться'&"'"&', '&"'"&'post_delete'&"'"&')" onmouseout="wall.deactiveDeletePost('&"'"&'-40529013_603875'&"'"&', '&"'"&'post_delete'&"'"&')"' & _
'></div></div></div>' & @CRLF & _
'      <div class="wall_text"><div class="wall_text_name"><a class="author" href="/horror_tales" data-from-id="-40529013" data-post-id="-40529013_6038' & _
'75">Страшные истории</a></div> <div id="wpt-40529013_603875"><div class="wall_post_text">Ошибка подростков<br><br>Почти в каждой школе есть свои страш' & _
'илки, связанные с её зданием. Вот и в одном маленьком городке среди учеников ходила легенда, что 15-го числа каждого лунного месяца ночью в школе твор' & _
'ятся странные вещи — например, что у статуи напротив входа вращаются глаза, число ступенек в лестничных пролётах меняется, в лабораториях из кранов вм' & _
'есто воды начинает течь кровь.<br><a class="wall_post_more" onclick="hide(this, domPS(this)); show(domNS(this));">Показать полностью..</a><span style=' & _
'"display: none"> влево&#33;<br><br></span></div><div class="page_post_sized_thumbs  clear_fix" style="width: 537px; height: 231px;"><a  onclick="retur' & _
'n showPhoto('&"'"&'-40529013_387714054'&"'"&', '&"'"&'wall-40529013_603875'&"'"&', {&quot;temp&quot;:{&quot;base&quot;:&quot;http://cs627516.vk.me/v62' & _
'7516342/&quot;,&quot;x_&quot;:[&quot;26f4e/aOEZBrUSFXA&quot;,604,260]},queue:1}, event)" style="width: 537px; height: 231px;" class="page_post_thumb_w' & _
'rap  page_post_thumb_last_column page_post_thumb_last_row"><img src="http://cs627516.vk.me/v627516342/26f4e/aOEZBrUSFXA.jpg" width="537" height="231" ' & _
'style=""  class="page_post_thumb_sized_photo" /></a></div></div></div>' & @CRLF & _
'      <div class="post_full_like_wrap sm fl_r">' & @CRLF & _
'  <div class="post_full_like">' & @CRLF & _
'    <div class="post_like fl_r"  onmouseover="wall.postLikeOver('&"'"&'-40529013_603875'&"'"&')" onmouseout="wall.postLikeOut('&"'"&'-40529013_603875' & _
''&"'"&')" onclick="wall.like('&"'"&'-40529013_603875'&"'"&', '&"'"&'2c26a44d2f5f36046c'&"'"&'); event.cancelBubble = true;">' & @CRLF & _
'      <span class="post_like_link fl_l" id="like_link-40529013_603875">Мне нравится</span>' & @CRLF & _
'      <i class="post_like_icon sp_main  fl_l" id="like_icon-40529013_603875"></i>' & @CRLF & _
'      <span class="post_like_count fl_l" id="like_count-40529013_603875">294</span>' & @CRLF & _
'    </div>' & @CRLF & _
'    <div class="post_share fl_r "  onmouseover="wall.postShareOver('&"'"&'-40529013_603875'&"'"&')" onmouseout="wall.postShareOut('&"'"&'-40529013_60' & _
'3875'&"'"&', event)" onclick="wall.likeShareCustom('&"'"&'-40529013_603875'&"'"&'); event.cancelBubble = true;">' & @CRLF & _
'      <span class="post_share_link fl_l" id="share_link-40529013_603875">Поделиться</span>' & @CRLF & _
'      <i class="post_share_icon sp_main fl_l" id="share_icon-40529013_603875"></i>' & @CRLF & _
'      <span class="post_share_count fl_l" id="share_count-40529013_603875">23</span>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>' & @CRLF & _
'</div>' & @CRLF & _
'      <div class="replies"><div class="reply_link_wrap sm" id="wpe_bottom-40529013_603875">' & @CRLF & _
'  <small><a  href="/wall-40529013_603875" onclick="return showWiki({w: '&"'"&'wall-40529013_603875'&"'"&'}, false, event);" ><span class="rel_date">с' & _
'егодня в 3:04</span></a></small><span class="divide">|</span><a class="reply_link" onclick="Wall.likeShareCustom('&"'"&'-40529013_603875'&"'"&')">Отве' & _
'тить</a>' & @CRLF & _
'</div>' & @CRLF & _
'<div class="replies_wrap clear" id="replies_wrap-40529013_603875" style="display: none">' & @CRLF & _
'  <div id="replies-40529013_603875"><input type="hidden" id="start_reply-40529013_603875" value="" /></div>' & @CRLF & _
'  ' & @CRLF & _
'</div></div>' & @CRLF & _
'    </div>' & @CRLF & _
'  </div>'
$htmltext &='Граница' & @CRLF & _
			'' & @CRLF & _
			'Я служил на границе в далеком 1988 году на 18-й пограничной заставе «Гаудан» Бахарденского отряда, в школе инструкторов службы собак, что в Средней Азии. В том году, когда я получил щенка немецкой овчарки, всех собак надо было называть на «П». Я назвал щенка «Пёса».' & @CRLF & _
			'' & @CRLF & _
			'Пёса вырос толковым и смелым напарником. Время шло, все было спокойно. Но вот стали у нас на границе происходить странные дела. Исчезли два патруля, которые дежурили в районе старых развалин. Там проходила вспаханная полоса, граница СССР. На полосе были хорошо видимые свежие следы медведей — грешили на них. Конечно, была версия о дезертирстве, но факты не подтвердились.' & @CRLF & _
			'' & @CRLF & _
			'И вот как-то вечером тревога — нарушена государственная граница СССР! Нужно было срочно принять меры для задержания нарушителя. «ГАЗ-69» быстро довез нашу небольшую группу до границы леса. Я как старший инструктор, Пёса и пара «салаг» для солидности. Мы считали, что, скорее всего, опять медведи шастают — однажды мы на них уже нарывались. Но надо было проверить.' & @CRLF & _
			'' & @CRLF & _
			'На полосе опять были свежие следы медведей. Мы решили разделиться: я пошел вниз по реке в сторону развалин, «салаги» — наверх. Прошли мы где-то километр по течению реки, как вдруг собака взяла след. След абсолютно точно вел в сторону древних руин. Мы с Пёсой почти дошли до развалин (это почти три километра от реки), и тут я увидел прямо на границе леса крадущийся силуэт. Человек. Высокий, спортивного телосложения, одежда темная, на спине небольшой рюкзак. Что-то явно было не так с его ногами или обувью... Тогда я не смог рассмотреть точно, в чем дело.' & @CRLF & _
			'' & @CRLF & _
			'Человек медленно вышел из леса и пошел к остову какого-то старого здания (там фактически один кирпичный фундамент остался), шел осторожно, но даже не оглядывался — явно не ждал преследования. Я прислонился к стволу дерева и наблюдал за ним. Пёса лежал у ног и шумно дышал. Я боялся, что человек нас заметит или услышит, но ничего подобного не произошло. Мужчина спокойно уселся на фундамент и стал переобуваться. На ногах у него было что-то, похожее на сапоги из медвежьих лап, или даже просто выделанные медвежьи лапы. Из рюкзака он достал обычные высокие ботинки, обулся, не спеша начал их зашнуровывать. «Лапы» он аккуратно убрал в рюкзак. Ясно, нарушитель.' & @CRLF & _
			'' & @CRLF & _
			'Сняв с предохранителя автомат, я вышел из-за дерева и громко закричал:' & @CRLF & _
			'' & @CRLF & _
			'— Вниз! Оружие — на землю!' & @CRLF & _
			'' & @CRLF & _
			'Я даже не заметил, как в его руках оказалось оружие, услышал уже только выстрелы. Стрелял он навскидку с бедра, но не это спасло мне жизнь той ночью, а Пёса. Собака метнулась быстрее молнии — даже на тренировках она никогда не бегала так быстро. Было три выстрела. Одна пуля пробила мне руку навылет — рана несерьезная, но болезненная, — а две другие попали в собаку. Несмотря на ранение, овчарка опрокинула диверсанта на землю и держала его за горло, пока я не подошел и здоровой рукой не врезал ему прикладом по морде. Он отрубился.' & @CRLF & _
			'' & @CRLF & _
			'Разорвав майку, я кое-как сделал себе перевязку руки и тщательно перевязал собаку. Песик был очень плох. Скулил и тяжело дышал. Одна пуля лишь поцарапала голову, но другая, похоже, пробила легкое. По инструкции я должен был пристрелить собаку и доставить нарушителя на заставу. Эта задача была абсолютно приоритетна. Там бы мне выдали другого щенка. Да и Пёса ещё мог выжить — шанс был, если срочно доставить его в госпиталь. Неужели я поставлю свою карьеру под удар, нарушу инструкции и, возможно, присягу ради собаки? Нет. Но ради Друга — да.' & @CRLF & _
			'' & @CRLF & _
			'Связав «Джона» ремнем (я про себя назвал нарушителя «Джон», хотя он был абсолютно азиатской внешности; я решил, что он, вероятно, американец, ну так принято было), я несколькими сильными пощечинами привел его в чувство. Он хмуро посмотрел на меня, потом уставился перед собой, но взгляд был четкий и ясный — сотрясения нет.' & @CRLF & _
			'' & @CRLF & _
			'— Американец? — спросил я.' & @CRLF & _
			'' & @CRLF & _
			'— Ага, мексиканец, бл***, — он сплюнул.' & @CRLF & _
			'' & @CRLF & _
			'Говорил по-русски он абсолютно без акцента. О чемто задумавшись, он вдруг начал резко бледнеть — это я увидел даже при свете луны, довольно ярком.' & @CRLF & _
			'' & @CRLF & _
			'— Время!' & @CRLF & _
			'' & @CRLF & _
			'— Что — время?' & @CRLF & _
			'' & @CRLF & _
			'— Ты меня вырубил, я сколько валялся? Сколько сейчас времени?!!' & @CRLF & _
			'' & @CRLF & _
			'Он сорвался не то что на крик, а даже на визг. Может, шизанутый? Или придуривается, чтобы понизить бдительность? Ну либо все-таки прикладом ему хорошо «прилетело»...' & @CRLF & _
			'' & @CRLF & _
			'— Ну, около двенадцати, наверное. Тебе-то что?' & @CRLF & _
			'' & @CRLF & _
			'— Полночь, мать твою, полночь! Я уже в городе должен был к этому времени быть, дебил ты конченый! Уходим, уходим быстро!!!' & @CRLF & _
			'' & @CRLF & _
			'— А ты чего разверещался-то? Я без собаки никуда не пойду. Сейчас придумаю, как ее нести, тогда и пойдем. Рации у меня нет, спешить некуда, нам почти четыре километра топать.' & @CRLF & _
			'' & @CRLF & _
			'— Не понимаешь, да? Я из местных, сюда даже шаманы ночью не ходят! Ты хоть знаешь, где мы находимся?' & @CRLF & _
			'' & @CRLF & _
			'— Среди каких-то развалин, а что?' & @CRLF & _
			'' & @CRLF & _
			'— «Развалины»! Просто «развалины»?! Да ты совсем долбанутый! Сейчас не уйдем — не будет ни меня, ни тебя, ни твоей блохастой твари! Все здесь останемся, как другие! Пусть меня лучше сто раз расстреляют... Уходим!!!' & @CRLF & _
			'' & @CRLF & _
			'— Я уже тебе все сказал. А твои сказки мне не интересны.' & @CRLF & _
			'' & @CRLF & _
			'— Да какие, нахрен, сказки! Хрен бы я по этой дороге ходил, если бы это не самый короткий путь в город был. Никто по этим руинам не ходит! Нельзя, нельзя, понимаешь ты, здесь после полуночи быть! У вас же патрули пропадали, да?! Я знаю! Думаешь, я их убил, или из наших кто-то? Нет! Они меня выслеживали ночью и привал тут устроили! Теперь все, нет их, не ищите! Они с ними... И вообще ты, ты... ты права не имеешь, ты обязан меня в часть доставить! Я все расскажу, хочешь, возьму на себя убийство патрульных ваших, мне все равно... Только уходим!' & @CRLF & _
			'' & @CRLF & _
			'Когда долго работаешь с животными, перенимаешь какие-то их черты, даже ощущения. И тут я чувствовал... страх, смертельный страх. Шпионов хорошо готовят, и с артистизмом у них все в порядке, но такой взгляд затравленного зверя подделать невозможно. «Джон» боялся, боялся больше смерти того, что скрывается в этих развалинах. Я попытался положить Пёсу на плечи. Меня шатало из-за кровопотери — я никак не мог нести собаку и держать на прицеле «Джона». Но надо было уходить. Я не то чтобы поверил ему, но чувство тревоги все нарастало. Даже лунный свет изменился, стал каким-то не таким. Я все списал на кровопотерю — да и мало ли чего ночью привидится...' & @CRLF & _
			'' & @CRLF & _
			'— Режь ремень! — «Джон» вытянул вперед связанные руки.' & @CRLF & _
			'' & @CRLF & _
			'— Может, тебе еще и автомат дать? Что скромничать?' & @CRLF & _
			'' & @CRLF & _
			'— Режь. Ремень. Я. Понесу. Собаку, — он говорил так, как будто выплевывал слова.' & @CRLF & _
			'' & @CRLF & _
			'У меня иного выхода не было. Когда нас найдут, неизвестно — а Пёсе нужна операция срочная.' & @CRLF & _
			'' & @CRLF & _
			'Я перерезал ремень штыком. «Джон» аккуратно взял собаку на плечи и понес в сторону леса.' & @CRLF & _
			'' & @CRLF & _
			'— Учти, хоть раз рыпнешься — пристрелю. И мне пофигу на инструкцию.' & @CRLF & _
			'' & @CRLF & _
			'— Да уж, это я заметил. Собаку вот в часть тащишь... Сам себе срок несешь. Ты хоть знаешь, сколько этим поступком ты инструкций нарушаешь? Ты меня стеречь обязан. Я, блин, ценный, — он сплюнул. — Ради тебя же стараюсь.' & @CRLF & _
			'' & @CRLF & _
			'— Неси давай. Остальное не твое дело.' & @CRLF & _
			'' & @CRLF & _
			'Мы медленно шли в сторону леса. Погода резко испортилась, стало очень холодно и зябко. Собака стала поскуливать все громче и громе, уже перейдя фактически на тихий вой. Я решил, что это от боли. И вдруг, я вам клянусь, я услышал песню, как будто множество голосов выводят «акапелла» заунывную мелодию. Я не мог разобрать слов, но мне очень хотелось остаться, остановиться, пойти к ним — и слушать, слушать их голоса вечно. Тряхнув головой, я сбросил наваждение и увидел, что «Джон» уже бежит в сторону леса. Я не стал его окликать, а побежал вслед за ним.' & @CRLF & _
			'' & @CRLF & _
			'Мы благополучно прибыли на заставу, Пёсе сделали операцию, все было нормально. Начальство нас даже похвалило... а потом комиссовала и меня, и собаку. Считай, в 35 лет меня выбросили на улицу, хоть и с копеечной пенсией. Ну да ладно...' & @CRLF & _
			'' & @CRLF & _
			'С тех пор прошло уже много лет. Сейчас живу в Москве, работаю по разным ЧОПам, женился. Живем втроем: я, жена и Пёса — он старенький уже.' & @CRLF & _
			'' & @CRLF & _
			'А «Джон» (я так и не узнал его настоящего имени) согласился на сотрудничество, на нашу контрразведку работал, потом вышел на пенсию и сейчас ветеринарную клинику содержит. Да уж, кто бы мог подумать... Я даже как-то пересекался с ним, посидели в кафе, попили пивка, повспоминали былое. Хотел я его про развалины спросить, но ляпнул в место этого что-то вроде:' & @CRLF & _
			'' & @CRLF & _
			'— Погода сегодня прям дико жаркая, даже для лета.' & @CRLF & _
			'' & @CRLF & _
			'— Ага, градусов тридцать пять, наверное... Может глобальное потепление не такая уж и деза?' & @CRLF & _
			'' & @CRLF & _
			'Мы посмеялись. Как будто что-то не давало мне говорить на эту тему. Он тоже ни разу ее в разговоре не упомянул, как будто и не было тех развалин.' & @CRLF & _
			'' & @CRLF & _
			'Я много лет думал, вспоминал ту ночь. И наконец решился. Скоро у меня отпуск — и я обязательно поеду на эти развалины, разобью палатку и буду сидеть там всю ночь. Я должен узнать. Иначе не будет мне покоя.' & @CRLF & _
			'' & @CRLF & _
			'P. S. История реальная, но имена и география изменены.'
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

	; Заменям цифровой код символа на сам символ
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

	; блок исправлений текущей реализации. Если файл в UTF8 то в нём могут быть юникодные символы, которые при сохранении а ASCI будут испорчены
	$text = StringRegExpReplace($text, '[“”]', '"') ; неправильные кавычки
	$text = StringReplace($text, ChrW(160), ' ') ; заменить пробел 160 на пробел 32
	$text = StringReplace($text, ChrW(8226), '') ; удалить кругляшок
	$text = StringReplace($text, ChrW(8211), '-') ; длинное тире на правильный минус
	$text = StringReplace($text, ChrW(8230), '...') ; троеточие на три точки
	$text = StringReplace($text, ChrW(8212), '-') ; очень длинное тире на короткое

	Return $text
EndFunc   ;==>_HTMLTransSymb

Func _HTMLTransSymbOld($text)
	; Замена некоторых часто испольхуемых спецсимволов, а их на самом деле больше
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

	; Замена знаков юникода выраженных числовым кодом
	$a = StringRegExp($text, '&#(\d+);', 3)
	If Not @error Then
;~     $log &= UBound($a) & '   &#(\d+);' & @CRLF
		$a = _ArrayUnique($a)
		For $i = 1 To $a[0]
			$a[$i] = Number($a[$i])
		Next
		_ArraySort($a, 1, 1) ; чтобы не испортить к примеру число 853 числом 85
		; _ArrayDisplay($a, "Массив после сортировки по убыванию")
		For $i = 1 To $a[0]
			$text = StringReplace($text, '&#' & $a[$i] & ';', ChrW($a[$i]))
		Next
	EndIf


	; i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!i!

	; блок исправлений текущей реализации. Если файл в UTF8 то в нём могут быть юникодные символы, которые при сохранении а ASCI будут испорчены
	$text = StringRegExpReplace($text, '[“”]', '"') ; неправильные кавычки
;~ If Not @error Then $log &= @extended & '   кавычки “ ”' & @CRLF

	$text = StringReplace($text, ChrW(160), ' ') ; заменить пробел 160 на пробел 32
;~ If @extended Then $log &= @extended & '   пробел' & @CRLF

	$text = StringReplace($text, ChrW(8226), '') ; удалить кругляшок
;~ If @extended Then $log &= @extended & '   о > ' & @CRLF

	$text = StringReplace($text, ChrW(8211), '-') ; длинное тире на правильный минус
;~ If @extended Then $log &= @extended & '   - > -' & @CRLF

	$text = StringReplace($text, ChrW(8230), '...') ; троеточие на три точки
;~ If @extended Then $log &= @extended & '   ...' & @CRLF

	$text = StringReplace($text, ChrW(8212), '-') ; очень длинное тире на короткое
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
