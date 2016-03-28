   #Include <WinAPIEx.au3>
   #include <Encoding.au3>
   #include <Excel.au3>
   #include <Date.au3>
#include <Misc.au3>



 HotKeySet("^"&"{F9}", "Terminate")
   Func Terminate()
	  TrayTip ("Подсказка","Программа закрыта, Всего хорошего :)",1501)
;~ 	  ProcessClose ( "TextPipe_8.6.7.exe" );закрыть TextPipe если он открыт
	  ;по окончании открыть файл TXT
;~ 	  Run('c:\StatHelper\Log.txt')
	  ;по окончании открыть файл в Excel
;~ 	  _Open_With_Excel()
	  sleep (1500)
	   Exit 0
   EndFunc



;~ #Include <Constants.au3>
;~ #Include <WinAPI.au3>


   ;~ AutoItSetOption ( "MustDeclareVars",1 )

   Global $ClipHome, $ClipEnd

   Global $Rus = 0x00000419; Раскладка русского языка
   Global $Eng = 0x00000409; Раскладка английского языка
   Global $Title1, $Full1, $HWnDTextPipe, $sLayoutID, $WM_INPUTLANGCHANGEREQUEST, $aRet, $hWnd


HotKeySet("{F7}", "_Poruchenie_iz_spiska_poruchenii")

   HotKeySet("{F8}", "_Poruchenie_full")
   ;Изьятие информации со строницы с открытой "Дополнительной информацией о поручении"
   Func _Poruchenie_full()
	  
	  _WinAPI_LoadKeyboardLayoutEx($Eng); переводим раскладку в АНГЛ иначе не будут работать сочетания клавиш
_SendEx("^"&"c") ;обход залипания клавиш
_SendEx("^"&"{INSERT}");обход залипания клавиш
   Send("^a")
   sleep(564)
   Send("^c")
   Send("^"&"c")

   send ("^"&"{INSERT}")
   send ("{TAB}") ;сброс выделения в браузере
_SendEx("^"&"c") ;обход залипания клавишь
_SendEx("^"&"{INSERT}");обход залипания клавиш
   $ClipPF = ClipGet()
   clipput('') ;обнуляем буффер, чтобы пользователь не вставил чего лишнего
   
   ;применяем исправления на редкие случаи неуказания имени в ЛК
   $detinfpor1 = StringRegExpReplace($ClipPF,'Получатель: \(','Получатель: Имя не заданно \(')
   $detinfpor2 = StringRegExpReplace($detinfpor1,'Руководитель получателя: \(','Руководитель получателя: Имя не заданно \(')
   $detinfpor3 = StringRegExpReplace($detinfpor2,'Отправитель: \(','Отправитель: Имя не заданно \(')
   $detinfpor4 = StringRegExpReplace($detinfpor3,'Руководитель отправителя: \(','Руководитель отправителя: Имя не заданно \(')
   
   ;Применяем преобразования
   $detinfpor5 = StringRegExpReplace($detinfpor4, '(?s).*Получатель: (.*?) \((.*?)\), телефон: (.*?)\r\nРуководитель получателя: (.*?) \((.*?)\), телефон: (.*?)\r\nОтправитель: (.*?) \((.*?)\), телефон: (.*?)\r\nРуководитель отправителя: (.*?) \((.*?)\), телефон: (.*?)\r\n(?s).*', '$1'&@CRLF&'$2'&@CRLF&'$3'&@CRLF&'$4'&@CRLF&'$5'&@CRLF&'$6'&@CRLF&'$7'&@CRLF&'$8'&@CRLF&'$9'&@CRLF&'$10'&@CRLF&'$11'&@CRLF&'$12', 1)
;~    $detinfpor5 = StringRegExpReplace($detinfpor4, '\(', '1', 1)
   
   ;разделяем результат по переменным
   $detinfpor6 = StringRegExp($detinfpor5, '(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)',1)
MsgBox(0, "Последняя переменная содержит:", $detinfpor5,1) 
 $name0 = $detinfpor6[0]
   $name1 = $detinfpor6[1]
   $name2 = $detinfpor6[2]
   $name3 = $detinfpor6[3]
   $name4 = $detinfpor6[4]
   $name5 = $detinfpor6[5]
   $name6 = $detinfpor6[6]
   $name7 = $detinfpor6[7]
   $name8 = $detinfpor6[8]
   $name9 = $detinfpor6[9]
   $name10 = $detinfpor6[10]
   $name11 = $detinfpor6[11]
   
   
   
;~    MsgBox(0, "Ubound переменной содержит:", Ubound($detinfpor6))
   
;~ .*(Поручение: .*$).*:([0-9]{1,}?),[0-9]{1,}?RUR.*Получатель: (.*)\((.*)\), телефон: (.*)\r\n'
;~ (.*Руководитель получателя: .*\()(.*\)).*телефон: (.*$)
;~ (Отправитель: (.*?) \((.*?)\), телефон: (.*?)\r\nРуководитель отправителя: (.*?) \((.*?)\), телефон: (.*?)\r\n
;~ (.*
   
   
   
;~    $Rnumber = StringRegExp( 'сброс выделения в браузере', 'браузер',1)
;~ $Rnumber = StringRegExp( '<test>$ClipPF</Test>', '<(?i)test>оручение: R152787</(?i)test>' )
$Rnumber = StringRegExp( $ClipPF, 'Поручение: (R[0-9]*)',1)
;~ MsgBox(0, "$Rnumber содержит:", $Rnumber[0])
;~ MsgBox(0, "$Rnumber содержит:", Ubound($Rnumber))
;~ 	MsgBox(0, "$ClipPF содержит:", $ClipPF)

;исправляем ошибку первой строки
$ClipPFfix = StringRegExpReplace($detinfpor4,'Скрыть исполненные/отмененные поручения', 'Номер:'&@CRLF&'Скрыть исполненные/отмененные поручения')

$poruchenie = StringRegExp($ClipPFfix, '(Номер:)'&@CRLF&$Rnumber[0]&'(?s)(.*?)Номер:',1)


	
	;извлечение одного поручения из списка поручений
	$poruchenie1 = $poruchenie[0]&@CRLF&$Rnumber[0]&$poruchenie[1]

;исправляем неуказанный банк
	  $poruchenie1fix = StringRegExpReplace($poruchenie1,'(\d+-\d+-[0-9]{1,}?.*\r\n)>','$1 банк не указан'&@CRLF&'>')


; Записываем оба банка последними строками
   $infpor2 = StringRegExp( $poruchenie1fix, '(?s)(.*\d+-\d+-[0-9]{1,}?.*)\r\n'&'(.*)\r\n>'&'(.*)',1)
;~ MsgBox(0, "Ubound переменной содержит:", Ubound($infpor2))
;~ MsgBox(0, "Последняя переменная содержит:", $infpor2[0]&@CRLF&'2)'&$infpor2[2]&@CRLF&'1)'&$infpor2[1])
;~    MsgBox(0, "Последняя переменная содержит:", $infpor2[0]&$infpor2[1]&@CRLF&'2)'&$infpor2[3]&@CRLF&'1)'&$infpor2[2])
	
	$infpor2_1 = $infpor2[0]&@CRLF&$infpor2[2]&@CRLF&$infpor2[1]
	
	;Вырезаем "Подтверждение"
	$infpor3 = StringRegExpReplace($infpor2_1,'Подтверждение:  \r\n','')

   ;Пометим запросы Z
	$infpor4 = StringRegExpReplace($infpor3,'Запрос хранимых средств','ZЗапрос хранимых средств')
	
	;Пометим Передано на хранение вашему участнику Z
	$infpor5= StringRegExpReplace($infpor4,'Передано на хранение вашему участнику','ZПередано на хранение вашему участнику')

   ;Переводим дату в нормальный формат
   $infpor6 = StringRegExp($infpor5,'(?s)(.*\d{2,4})-(\d{2,4}.*)',1)
   $infpor6_1 = $infpor6[0]&'.'&$infpor6[1]
   $infpor6_2 = StringRegExp($infpor6_1,'(?s)(.*\d{2,4})-(\d{2,4}.*)',1)
   $infpor6_3 = $infpor6_2[0]&'.'&$infpor6_2[1]
   
   ;~ 	;удаляем пустые строки
	$infpor6_31 = StringRegExpReplace($infpor6_3, '\r\n\r\n',@CRLF)
	$infpor6_32 = StringRegExpReplace($infpor6_31, '\r\n\r\n',@CRLF)
	$infpor6_33= StringRegExpReplace($infpor6_32, '\r\n\r\n',@CRLF)
;~    $infpor6_33 = StringRegExpReplace($infpor6_3, '\r\n|\r|\n{2,}', '\1',3)
;~ 	MsgBox(0, "Последняя переменная содержит:",$infpor6_33)

   ;Преобразовываем
   $infpor6_4 = StringRegExp($infpor6_33,'.*Номер:\r\n(R[0-9]*).*(Z.*)\)(?s).*Дата создания:\r\n([0-9]{4}\.[0-9]{2}\.[0-9]{2})\t(.*?$)',1)
;~    $infpor6_4 = StringRegExp($infpor6_33,'.*Номер:\r\n(R[0-9]*)\t.*(Z[0-9])\).*Дата создания:\r\n([0-9]{4}\.[0-9]{2}\.[0-9]{2})\t(.*?$)',1)
   $infpor6_5 = $infpor6_4[0]&@CRLF&$infpor6_4[1]&@CRLF&$infpor6_4[2]&@CRLF&$infpor6_4[3]

   ;приводим к нормальному виду сумму
   $infpor7 = StringRegExpReplace($infpor6_5, '([0-9]{1,}?) ([0-9]{3}) RUR[ ]*>\t(.*)\r\n', '$1$2'&@CRLF&'$3'&@CRLF, 1)
   $infpor7_1 = StringRegExpReplace($infpor7, '([0-9]{3}) RUR[ ]*>\t(.*)\r\n', '$1'&@CRLF&'$2'&@CRLF, 1)
	$infpor7_2 = StringRegExpReplace($infpor7_1, '([0-9]{1,}?) ([0-9]{3}) RUR[ ]*>', '$1$2', 1)
   $infpor7_3 = StringRegExpReplace($infpor7_2, '([0-9]{3}) RUR[ ]*>', '$1', 1)

	
	;удаляем  табуляторы
	$infpor8 = StringRegExpReplace($infpor7_3, '\t', '', 1)	
	
	;добавить к концу текста Enter 
	$infpor9 = StringRegExpReplace($infpor8, '(&s)(.*)', '$1'&@CRLF, 1)
	
	;преобразование номер два
;~ 	$infpor10 = StringRegExpReplace($infpor9, "(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&, "$3\tСумма поручения\t$5\t\t\t\t$2\t$1\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$4\t$7\t$8\t\t\t$6", 1)
;~ 	$infpor10 = StringRegExpReplace($infpor9, "(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)", "$3\tСумма поручения\t$5\t\t\t\t$2\t$1\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$4\t$7\t$8\t\t\t$6", 1)
	$infpor10 = StringRegExpReplace($infpor9, "(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)", "$3"& @Tab &"Сумма поручения"& @Tab &"$5"& @Tab &""& @Tab &""& @Tab &""& @Tab &"$2"& @Tab &"$1"& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &$name10& @Tab &$name11& @Tab &$name9& @Tab &$name7& @Tab &$name8& @Tab &$name6& @Tab &"$7"& @Tab &"$8"& @Tab &$name1& @Tab &$name2& @Tab &$name0& @Tab &$name4& @Tab &$name5& @Tab &$name3, 1)
	
	;возвращаем запросы Z
	$infpor10_1 = StringRegExpReplace($infpor10,'ZЗапрос хранимых средств','Запрос хранимых средств')
	
	;возвращаем Передано на хранение вашему участнику Z
	$infpor10_2= StringRegExpReplace($infpor10_1,'ZПередано на хранение вашему участнику','Передано на хранение вашему участнику')

	
	
	;Помещаем найденноев буффер обмена
ClipPut($infpor10_2)
	TrayTip ("Подсказка","Готово!)",1000)
;~ 	MsgBox(0, "Последняя переменная содержит:",$infpor6_5)
;~ MsgBox(0, "Ubound переменной содержит:", Ubound($infpor7))
	MsgBox(0, "Последняя переменная содержит:", $infpor10_2,1)
;~ 	MsgBox(0, "Последняя переменная содержит:",$infpor6_4[0]&';'&$infpor6_4[1]&';'&$infpor6_4[2]&';'&$infpor6_4[3])
	
	
;~ Exit	
	  
   EndFunc


   Func _Poruchenie_iz_spiska_poruchenii()
	  
	  	  _WinAPI_LoadKeyboardLayoutEx($Eng); переводим раскладку в АНГЛ иначе не будут работать сочетания клавиш
_SendEx("^"&"c") ;обход залипания клавиш
_SendEx("^"&"{INSERT}");обход залипания клавиш
   Send("^c")
   Send("^"&"c")
   send ("^"&"{INSERT}")
;~    send ("{TAB}") ';сброс выделения в браузере'
_SendEx("^"&"c") ;обход залипания клавишь
_SendEx("^"&"{INSERT}");обход залипания клавиш
	  
	  $poruchenie1 = ClipGet()
	  
	  
	  ;исправляем неуказанный банк
	  $poruchenie1fix = StringRegExpReplace($poruchenie1,'(\d+-\d+-[0-9]{1,}?.*\r\n)>','$1 банк не указан'&@CRLF&'>')
;~ 	  msgBox(0, "Последняя переменная содержит:", $poruchenie1fix)
	  
; Записываем оба банка последними строками
   $infpor2 = StringRegExp( $poruchenie1fix, '(?s)(.*\d+-\d+-[0-9]{1,}?.*)\r\n'&'(.*)\r\n>'&'(.*)',1)
;~ MsgBox(0, "Ubound переменной содержит:", Ubound($infpor2))
;~ MsgBox(0, "Последняя переменная содержит:", $infpor2[0]&@CRLF&'2)'&$infpor2[2]&@CRLF&'1)'&$infpor2[1])
;~    MsgBox(0, "Последняя переменная содержит:", $infpor2[0]&$infpor2[1]&@CRLF&'2)'&$infpor2[3]&@CRLF&'1)'&$infpor2[2])
	
	$infpor2_1 = $infpor2[0]&@CRLF&$infpor2[2]&@CRLF&$infpor2[1]
	
	;Вырезаем "Подтверждение"
	$infpor3 = StringRegExpReplace($infpor2_1,'Подтверждение:  \r\n','')

   ;Пометим запросы Z
	$infpor4 = StringRegExpReplace($infpor3,'Запрос хранимых средств','ZЗапрос хранимых средств')
	
	;Пометим Передано на хранение вашему участнику Z
	$infpor5= StringRegExpReplace($infpor4,'Передано на хранение вашему участнику','ZПередано на хранение вашему участнику')

   ;Переводим дату в нормальный формат
   $infpor6 = StringRegExp($infpor5,'(?s)(.*\d{2,4})-(\d{2,4}.*)',1)
   $infpor6_1 = $infpor6[0]&'.'&$infpor6[1]
   $infpor6_2 = StringRegExp($infpor6_1,'(?s)(.*\d{2,4})-(\d{2,4}.*)',1)
   $infpor6_3 = $infpor6_2[0]&'.'&$infpor6_2[1]
   
   ;~ 	;удаляем пустые строки
	$infpor6_33 = StringRegExpReplace($infpor6_3, '\r\n\r\n','')
;~ 	MsgBox(0, "Последняя переменная содержит:",$infpror)

   ;Преобразовываем
   $infpor6_4 = StringRegExp($infpor6_33,'.*Номер:\r\n(R[0-9]*).*(Z.*)\)(?s).*Дата создания:\r\n([0-9]{4}\.[0-9]{2}\.[0-9]{2})\t(.*?$)',1)
;~    $infpor6_4 = StringRegExp($infpor6_33,'.*Номер:\r\n(R[0-9]*)\t.*(Z[0-9])\).*Дата создания:\r\n([0-9]{4}\.[0-9]{2}\.[0-9]{2})\t(.*?$)',1)
   $infpor6_5 = $infpor6_4[0]&@CRLF&$infpor6_4[1]&@CRLF&$infpor6_4[2]&@CRLF&$infpor6_4[3]

   ;приводим к нормальному виду сумму
   $infpor7 = StringRegExpReplace($infpor6_5, '([0-9]{1,}?) ([0-9]{3}) RUR[ ]*>\t(.*)\r\n', '$1$2'&@CRLF&'$3'&@CRLF, 1)
   $infpor7_1 = StringRegExpReplace($infpor7, '([0-9]{3}) RUR[ ]*>\t(.*)\r\n', '$1'&@CRLF&'$2'&@CRLF, 1)
	$infpor7_2 = StringRegExpReplace($infpor7_1, '([0-9]{1,}?) ([0-9]{3}) RUR[ ]*>', '$1$2', 1)
   $infpor7_3 = StringRegExpReplace($infpor7_2, '([0-9]{3}) RUR[ ]*>', '$1', 1)

	
	;удаляем  табуляторы
	$infpor8 = StringRegExpReplace($infpor7_3, '\t', '', 1)
	
	;добавить к концу текста Enter 
	$infpor9 = StringRegExpReplace($infpor8, '(&s)(.*)', '$1'&@CRLF, 1)
	
	;преобразование номер два
;~ 	$infpor10 = StringRegExpReplace($infpor9, "(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&, "$3\tСумма поручения\t$5\t\t\t\t$2\t$1\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$4\t$7\t$8\t\t\t$6", 1)
;~ 	$infpor10 = StringRegExpReplace($infpor9, "(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)", "$3\tСумма поручения\t$5\t\t\t\t$2\t$1\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$4\t$7\t$8\t\t\t$6", 1)
	$infpor10 = StringRegExpReplace($infpor9, "(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)", "$3"& @Tab &"Сумма поручения"& @Tab &"$5"& @Tab &""& @Tab &""& @Tab &""& @Tab &"$2"& @Tab &"$1"& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &"$4"& @Tab &"$7"& @Tab &"$8"& @Tab &""& @Tab &""& @Tab &"$6", 1)
	
	;возвращаем запросы Z
	$infpor10_1 = StringRegExpReplace($infpor10,'ZЗапрос хранимых средств','Запрос хранимых средств')
	
	;возвращаем Передано на хранение вашему участнику Z
	$infpor10_2= StringRegExpReplace($infpor10_1,'ZПередано на хранение вашему участнику','Передано на хранение вашему участнику')

	
	
	;Помещаем найденноев буффер обмена
ClipPut($infpor10_2)
	TrayTip ("Подсказка","Готово!)",1000)
;~ 	MsgBox(0, "Последняя переменная содержит:",$infpor6_5)
;~ MsgBox(0, "Ubound переменной содержит:", Ubound($infpor7))
;~ 	MsgBox(0, "Последняя переменная содержит:", $infpor10)
;~ 	MsgBox(0, "Последняя переменная содержит:",$infpor6_4[0]&';'&$infpor6_4[1]&';'&$infpor6_4[2]&';'&$infpor6_4[3])
	
EndFunc



;~    HotKeySet("^"&"{Home}", "Home")
;~    HotKeySet("^"&"{End}", "End")




   while 1
   sleep(15000)
   wend






   Func _WinAPI_LoadKeyboardLayoutEx($sLayoutID = 0x0409, $hWnd = 0)
	   Local Const $WM_INPUTLANGCHANGEREQUEST = 0x50
	   Local $aRet = DllCall("user32.dll", "long", "LoadKeyboardLayoutW", "wstr", Hex($sLayoutID, 8), "int", 0)
	   
	   If Not @error And $aRet[0] Then
		   If $hWnd = 0 Then
			   $hWnd = WinGetHandle(AutoItWinGetTitle())
		   EndIf
		   
		   DllCall("user32.dll", "ptr", "SendMessage", "hwnd", $hWnd, "int", $WM_INPUTLANGCHANGEREQUEST, "int", 1, "int", $aRet[0])
		   Return 1
	   EndIf
	   
	   Return SetError(1)
	   
	EndFunc																						
	
	
	Func _Open_With_Excel()
	   

$sDate=_NowDate() & _NowTime(4)
$sDate1 = StringReplace ( $sDate, ':', '-')
$Namefile = "Log" & $sDate1 & ".CSV"
$sFileTxt = @ScriptDir & '\Log.txt'
$sFileXls = @ScriptDir & '\result.xls'

$hFile = FileOpen($sFileTxt, 0)
If $hFile = -1 Then
    MsgBox(16, 'Error', 'Error')
    Exit
EndIf
$sText1 = FileRead($hFile)
FileClose($hFile)

;~ $sText = StringRegExpReplace ( $sText1, "\t", "\|")
$sText = $sText1
$sText = StringReplace ( $sText1, @TAB, ';')

;~ MsgBox(0, "$sDate содержит:", $sDate)
$file = FileOpen("4Open\" & $Namefile, 2)

   ; Проверяет, является ли файл открытым, перед тем как использовать функции чтения/записи в файл
   If $file = -1 Then
	   MsgBox(4096, "Ошибка", "Невозможно открыть файл.")
	   Exit
	EndIf
   FileWrite($file, $sText)
 $dirfile = $file  
FileClose($file)

_ExcelBookOpen("c:\StatHelper\4Open\" & $Namefile)
	EndFunc		





Func _SendEx($sSend_Data)
    Local $hUser32DllOpen = DllOpen("User32.dll")
    
    While _IsPressed("10", $hUser32DllOpen) Or _IsPressed("11", $hUser32DllOpen) Or _IsPressed("12", $hUser32DllOpen)
        Sleep(10)
    WEnd
    
    Send($sSend_Data)
    
    DllClose($hUser32DllOpen)
EndFunc