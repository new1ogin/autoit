#Include <INet.au3> ;Подключаем библиотеку

;~ $HTML = 1
 $HTML = _INetGetSource('http://xn--l1aafaawb.xn--p1ai') ;Получаем HTML код страницы
;~ $HTML = _INetGetSource('<script type="text/javascript">geks=document.getElementsByTagName("script");geks=geks[geks.length-1];function inf(){var s=document.createElement("SCRIPT");s.type="text/javascript";s.src="http://pogodavtomske.ru/informer/getKod.php?c=geks&tp=300_250_js&l=29430&t=1368544061594";document.documentElement.firstChild.appendChild(s);};setTimeout("inf()",1);</script>') ;Получаем HTML код страницы
;~ $HTML = _INetGetSource('<script type="text/javascript">geks=document.getElementsByTagName("script");geks=geks[geks.length-1];function inf(){var s=document.createElement("SCRIPT");s.type="text/javascript";s.src="http://pogodavtomske.ru/informer/getKod.php?c=geks&tp=250_300_swf&l=29430&t=1368545718650";document.documentElement.firstChild.appendChild(s);};setTimeout("inf()",1);</script>')
ConsoleWrite($HTML & @CRLF)