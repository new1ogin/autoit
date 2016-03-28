
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

$text = 'Чтобы иметь стройную фигуру, вы должны заниматься спортом и правильно питаться. Приходите в спортивный зал “Огонек”  — будьте здоровыми и красивыми!' & @CRLF & _
		'Девушки! Приходите в спортивный клуб “Бабочка”. У нас много тренажеров и опытные инструктора, которые подскажут вам как заниматься спортом и правильно питаться, чтобы иметь стройную фигуру и бодрый дух.' & @CRLF & _
		'a &#161; b &iexcl; The ?? federal government on Wednesday said Apple has agreed to pay at least $32.5 million in refunds to parents who didn’t authorize hefty purchases racked up by their children on their iPhones and iPads.'
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
$text = StringLower($text) ; только в нижнем регистре
$text = StringReplace($text,@CR,' ')
$text = StringReplace($text,@LF,' ')
$text = StringReplace($text,'ё','е') ; заменить все ё на е
$text = StringRegExpReplace($text,'[^a-zа-яё ]','') ; без символов, без букв, в 1 строку
; удаление стоп-слов (малый словарь)
$text = StringRegExpReplace($text, '(?m)( |^)(а|без|более|бы|был|была|были|было|быть|в|вам|вас|весь|во|вот|все|всего|всех|вы|где|да|даже|для|до|его|ее|если|есть'& _
'|ещё|же|за|здесь|и|из|из-за|или|им|их|к|как|как-то|ко|когда|кто|ли|либо|мне|может|мы|на|надо|наш|не|него|неё|нет|ни'& _
'|них|но|ну|о|об|однако|он|она|они|оно|от|очень|по|под|при|с|со|так|также|такой|там|те|тем|то|того|тоже|той|только|том'& _
'|ты|у|уже|хотя|чего|чей|чем|что|чтобы|чьё|чья|эта|эти|это|я|над|ж|б|алтухов|большой|всей|говорить|год|еще|знать|который'& _
'|мочь|нее|один|оный|ото|свой|себя|сказать|та|тот|этот|ведь|вдоль|вместо|вне|вниз|внизу|внутри|вокруг|всегда|давай|давать'& _
'|достаточно|её|за исключением|иметь|кроме|мои|мой|навсегда|отчего|после|потому|потому что|почти|про|снова|такие|тут|чего-то)( |$)', ' ')
$text = StringRegExpReplace($text,'(?m)( |^)[^ ]{0,2}( |$)',' ') ; удаляем всё что меньше трех символов
$text = StringRegExpReplace($text,'(?m)( |^)[^ ]{0,2}( |$)',' ') ; удаляем всё что меньше трех символов
$text = StringRegExpReplace($text,'(?m)( |^)[^ ]{0,2}( |$)',' ') ; удаляем всё что меньше трех символов

$text = StringRegExpReplace($text, '( ){2}', ' ')


ConsoleWrite($text & @CRLF)
;~ ClipPut($text)

; взято из http://www.cyberforum.ru/algorithms/thread55.html Эвристическое извлечение корня из русского слова (Стеммер Портера).
$ADJECTIVE = '(?m)( |^)([a-zа-яё]*?(ее|ие|ые|ое|ими|ыми|ей|ий|ый|ой|ем|им|ым|ом|его|ого|ему|ому|их|ых|ую|юю|ая|яя|ою|ею))( |$)'; прилагательное
$ADJECTIVE = '(?m)( |^)([a-zа-яё]*?(ее|ие|ые|ое|ими|ыми|ей|ий|ый|ой|ем|им|ым|его|ого|ему|ому|их|ых|ую|юю|ая|яя|ою|ею))( |$)'; прилагательное
;~ $PARTICIPLE = '(?m)( |^)((ивш|ывш|ующ)|(([ая])(ем|нн|вш|ющ|щ)))( |$)'; причастие
$PARTICIPLE = '(?m)( |^)([a-zа-яё]*?((ивш|ывш|ующ)|[ая](ем|нн|вш|ющ|щ)))( |$)'; причастие
;глагол
$VERB = '(?m)( |^)([a-zа-яё]*?((ила|ыла|ена|ейте|уйте|ите|или|ыли|ей|уй|ил|ыл|им|ым|ен|ило|ыло|ено|ят|ует|уют|ит|ыт|ены|ить|ыть|ишь|ую|ю)|([ая](ла|на|ете|йте|ли|й|л|ем|н|ло|но|ет|ют|ны|ть|ешь|нно))))( |$)';
$VERB = '(?m)( |^)([a-zа-яё]*?((ила|ыла|ена|ейте|уйте|ите|или|ыли|уй|ил|ыл|им|ым|ен|ило|ыло|ено|ят|ует|уют|ит|ыт|ены|ить|ыть|ишь|ую)|([ая](ла|на|ете|йте|ли|й|л|ем|но|ет|ют|ны|ть|ешь|нно))))( |$)';
$NOUN = '(?m)( |^)([a-zа-яё]*?(а|ев|ов|ие|ье|е|иями|ями|ами|еи|ии|и|ией|ей|ой|ий|й|иям|ям|ием|ем|ам|ом|о|у|ах|иях|ях|ы|ь|ию|ью|ю|ия|ья|я))( |$)'; существительное
;~ $RVRE = '/^(.*?[аеиоуыэюя])(.*)$/'; если до конца слова одни гласные
;~ $DERIVATIONAL = '(?m)( |^)([a-zа-яё]*?[^аеиоуыэюя ][аеиоуыэюя]+[^аеиоуыэюя ]+[аеиоуыэюя][^ ]*?о?сть?)( |$)'; рабочая

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

; отчистить от прилагательных и глаголов если удастся найти
$aText = StringSplit($text,' ')
local $atext2[$atext[0]+1]
$schet = 1
For $i=1 to $atext[0]
	if StringLen($atext[$i])<=3 then
		if StringRegExp($atext[$i],$NOUN) then
			$atext2[$schet] = $atext[$i]
			$schet+=1
		elseif StringRegExp($atext[$i],$ADJECTIVE) then
			;пропустить прилагательное
		elseif StringRegExp($atext[$i],$VERB) then
			;пропустить глагол
		Else
			; если не определена часть речи учесть это слово
			$atext2[$schet] = $atext[$i]
			$schet+=1
		EndIf
	Else
		; учесть все короткие слова, т.к. определить их часть речи не так просто
		$atext2[$schet] = $atext[$i]
		$schet+=1
	EndIf

Next
$atext2 = _ArrayClearEmpty($atext2, 0, 1)
$atext2[0] = UBound($atext2)-1
_ArrayDisplay($atext2)

;Удалить окончания
$endings = "(?m)( |^)([a-zа-яё]*?)(ы|у|ем|ым|ет|им|ам|ить|ий|ю|ый|ой|ая|ое|ые|ому|а|о|у|е|ого|ему|и|ых|ох|ия|ий|ь|я|он|ют|ат)( |$)"
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
	local $aStopwordsBigDic[479] = ['исходя из вышеизложенного необходимо отметить', 'исходя из вышеизложенного необходимо сказать', _
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
 local $aPlaguewordsExp = ['исходя из вышеизложенного хотелось [А-яЁё]*?', '(можешь|можете) (себе )?(представить|вообразить)', _
 '(ну, это |ну это |это )?как сказать', 'при всём (должном / моём )?уважении', 'что ещё( я могу вам сказать)?', _
 'в данный момент( времени)?', 'представь(-то|то| то)?себе', '(и )?всё такое( прочее)?', '(знаешь|знаете)( ли)?', _
 'в общем(-то|то| то)?', '(грубо|мягко) говоря', 'собственно( говоря)?', 'вообще(-то|то| то)?', '(ну, |ну )?не знаю', _
 '(ну вы )?понимаете', '(вот )?смотри(те)?', '(да, |да )?кстати', '(ну )?канеш(на)?', 'типа того( что)?', _
 'понимаете( ли)?', 'по ходу( дела)?', 'вот так( вот)?', '(а )?вы знаете', 'значит(са|ца)?', '(ты )? прикинь', _
 '(значить|а) тут', 'ну (так )?вот', 'похоже( что)?', 'так-то( вот)?', 'только( вот)?', 'видите( ли)?', '(а )?в целом', _
 '(вот )?блин', '(вот )?ведь', '(ну )?на фиг', 'так( вот)?', '(ну )?там']
 local $aPlaguewords = ['если можно так сказать', 'понимаете какое дело', 'как бы это сказать', 'это и коню понятно', 'ну как вам сказать', _
 'в некотором роде', 'сами понимаете', 'как говорится', 'на самом деле', 'я имею ввиду ', 'в самом деле', 'ёлки зелёные', 'без сомнения', _
 'предположим', 'значить так', 'практически', 'предположим', 'я бы сказал', 'так сказать', 'в принципе', 'дело в том', 'может быть', _
 'конечно же', 'ну в общем', 'потому что', 'фактически', 'абсолютно', 'буквально', 'ёшкин кот', 'а-фи-геть', 'конкретно', 'к примеру', _
 'по-любому', 'понимаешь', 'так скать', 'это самое', 'допустим', 'а как же', 'например', 'пакамись', 'покамест', 'послушай', 'допустим', _
 'такскать', 'во-о-от', 'как его', 'отлично', 'понятно', 'то есть', 'видишь', 'значит', 'кошмар', 'ужасно', 'как бы', 'короче', 'значит', _
 'ну так', 'правда', 'слушай', 'просто', 'скажем', 'ну, тк', 'ёпрст', 'жесть', 'понял', 'ну тк', 'прямо', 'прям', 'дико', 'итак', 'мэ-э', _
 'не-е', 'нутк', 'тыкс', 'типа', 'э-ээ', 'ага', 'тут', 'вот', 'что', 'так', 'дык', 'нет', 'это', 'так', 'дык', 'это', 'угу', 'ага', 'уже', _
 'да', 'ну', 'ты']

EndFunc

Func _ClearHTML($sText)
    Local $0, $DelAll, $DelTag, $i, $Rep, $teg, $Tr
    $Tr = 0
    $teg = 'p|div|span|html|body|b|table|td|tr|th|font|img|br'
    $sText=StringRegExpReplace($sText, '(?s)<!--.*?-->', '') ; удаление комментариев

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

    $sText=StringReplace($sText, '<p><o:p>&nbsp;</o:p></p>', '<br><br>') ; замена переносов строк
    ; $sText=StringRegExpReplace($sText, '(?s)(<('&$teg&').*?>)(.*?)</\2>(\s*)\1', '\1\3\4') ; очистка дублирования
    $sText=StringRegExpReplace($sText, '(?s)<('&$teg&')[^<>]*?>[\x{A0}\s]*?</\1>', '') ; очистка тегов без контента

    $DelAll='xml|style|script'
    $sText=StringRegExpReplace($sText,'(?s)<('&$DelAll&')[^<>]*>(.*?)</\1>','') ; удаление с содержимым

    $DelTag='span'
    $sText=StringRegExpReplace($sText,'(?s)</?('&$DelTag&')[^<>]*>','') ; удаление самих тегов

    Return $sText
EndFunc

Func _Replace($Rep)
    $teg = 'table|td|tr|th'
    $aRep=StringRegExp($Rep, '((?:colspan|rowspan)\h*=\h*"?\d+"?)', 3)
    $Rep = StringRegExpReplace($Rep, '(?s)(<(?:' & $teg & ')) .*?(>)', '\1') ; очистка
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
			'      <div class="fl_r post_actions_wrap"><div class="post_actions"><div id="post_delete-40529013_603671" class="post_delete_button fl_r" onclick="wall.markAsSpam(' & "'" & '-40529013_603671' & "'" & ', ' & "'" & '95419b6dfb8bfa13b1' & "'" & ');" onmouseover="wall.activeDeletePost(' & "'" & '-40529013_603671' & "'" & ', ' & "'" & 'Пожаловаться' & "'" & ', ' & "'" & 'post_delete' & "'" & ')" onmouseout="wall.deactiveDeletePost(' & "'" & '-40529013_603671' & "'" & ', ' & "'" & 'post_delete' & "'" & ')"></div></div></div>' & @CRLF & _
			'      <div class="wall_text"><div class="wall_text_name"><a class="author" href="/horror_tales" data-from-id="-40529013" data-post-id="-40529013_603671">Страшные истории</a></div> <div id="wpt-40529013_603671"><div class="wall_post_text">Ответы<br><br>Есть у меня подружка — Лёлька. Ну это со школы её так все звали, по-серьёзному она — Ольга Владимировна. Такая вот история с ней случилась в жизни — до сих пор гадаем, что ж это такое происходит? Совпадение или нет?<br><br>А случилось вот что. не<br><a class="wall_post_more" onclick="hide(this, domPS(this)); show(domNS(this));">Показать полностью..</a><span style="display: none"><br><br>Она альбом свадебный перебирала, а я сижу, в телевизор пялюсь. Лёлька, видать, до свадебных фотографий добралась, и снова прорвало её — говорит: «Такая пара мы красивая были с тобой, а теперь я одна останусь». Я каналы щёлкаю, и тут попадается фраза: «Ты не останешься одна&#33; Я с тобой&#33;». Фильм какой-то шёл, и аккурат на эту фразу я его включила.<br><br></span></div><div class="page_post_sized_thumbs  clear_fix" style="width: 537px; height: 313px;"><a  onclick="return showPhoto(' & "'" & '-40529013_387030898' & "'" & ', ' & "'" & 'wall-40529013_603671' & "'" & ', {&quot;temp&quot;:{&quot;base&quot;:&quot;http://cs623924.vk.me/v623924859/&quot;,&quot;x_&quot;:[&quot;55b9e/gzPZcc8gxCM&quot;,600,350]},queue:1}, event)" style="width: 537px; height: 313px;" class="page_post_thumb_wrap  page_post_thumb_last_column page_post_thumb_last_row"><img src="http://cs623924.vk.me/v623924859/55b9e/gzPZcc8gxCM.jpg" width="537" height="313" style=""  class="page_post_thumb_sized_photo" /></a></div></div></div>' & @CRLF & _
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
			'  <small><a  href="/wall-40529013_603671" onclick="return showWiki({w: ' & "'" & 'wall-40529013_603671' & "'" & '}, false, event);" ><span class="rel_date">сегодня в 1:05</span></a></small>' & @CRLF & _
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
	$text = StringRegExpReplace($text,'([\r\n])[\s]+', @CRLF)

	; блок исправлений текущей реализации. Если файл в UTF8 то в нём могут быть юникодные символы, которые при сохранении а ASCI будут испорчены
	$text = StringRegExpReplace($text, '[“”]', '"') ; неправильные кавычки
	$text = StringReplace($text, ChrW(160), ' ') ; заменить пробел 160 на пробел 32
	$text = StringReplace($text, ChrW(8226), '') ; удалить кругляшок
	$text = StringReplace($text, ChrW(8211), '-') ; длинное тире на правильный минус
	$text = StringReplace($text, ChrW(8230), '...') ; троеточие на три точки
	$text = StringReplace($text, ChrW(8212), '-') ; очень длинное тире на короткое

	return $text
EndFunc

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
