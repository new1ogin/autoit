   #Include <WinAPIEx.au3>
   #include <Encoding.au3>
   #include <Excel.au3>
   #include <Date.au3>
#include <Misc.au3>



 HotKeySet("^"&"{F9}", "Terminate")
   Func Terminate()
	  TrayTip ("���������","��������� �������, ����� �������� :)",1501)
;~ 	  ProcessClose ( "TextPipe_8.6.7.exe" );������� TextPipe ���� �� ������
	  ;�� ��������� ������� ���� TXT
;~ 	  Run('c:\StatHelper\Log.txt')
	  ;�� ��������� ������� ���� � Excel
;~ 	  _Open_With_Excel()
	  sleep (1500)
	   Exit 0
   EndFunc



;~ #Include <Constants.au3>
;~ #Include <WinAPI.au3>


   ;~ AutoItSetOption ( "MustDeclareVars",1 )

   Global $ClipHome, $ClipEnd

   Global $Rus = 0x00000419; ��������� �������� �����
   Global $Eng = 0x00000409; ��������� ����������� �����
   Global $Title1, $Full1, $HWnDTextPipe, $sLayoutID, $WM_INPUTLANGCHANGEREQUEST, $aRet, $hWnd


HotKeySet("{F7}", "_Poruchenie_iz_spiska_poruchenii")

   HotKeySet("{F8}", "_Poruchenie_full")
   ;������� ���������� �� �������� � �������� "�������������� ����������� � ���������"
   Func _Poruchenie_full()
	  
	  _WinAPI_LoadKeyboardLayoutEx($Eng); ��������� ��������� � ���� ����� �� ����� �������� ��������� ������
_SendEx("^"&"c") ;����� ��������� ������
_SendEx("^"&"{INSERT}");����� ��������� ������
   Send("^a")
   sleep(564)
   Send("^c")
   Send("^"&"c")

   send ("^"&"{INSERT}")
   send ("{TAB}") ;����� ��������� � ��������
_SendEx("^"&"c") ;����� ��������� �������
_SendEx("^"&"{INSERT}");����� ��������� ������
   $ClipPF = ClipGet()
   clipput('') ;�������� ������, ����� ������������ �� ������� ���� �������
   
   ;��������� ����������� �� ������ ������ ���������� ����� � ��
   $detinfpor1 = StringRegExpReplace($ClipPF,'����������: \(','����������: ��� �� ������� \(')
   $detinfpor2 = StringRegExpReplace($detinfpor1,'������������ ����������: \(','������������ ����������: ��� �� ������� \(')
   $detinfpor3 = StringRegExpReplace($detinfpor2,'�����������: \(','�����������: ��� �� ������� \(')
   $detinfpor4 = StringRegExpReplace($detinfpor3,'������������ �����������: \(','������������ �����������: ��� �� ������� \(')
   
   ;��������� ��������������
   $detinfpor5 = StringRegExpReplace($detinfpor4, '(?s).*����������: (.*?) \((.*?)\), �������: (.*?)\r\n������������ ����������: (.*?) \((.*?)\), �������: (.*?)\r\n�����������: (.*?) \((.*?)\), �������: (.*?)\r\n������������ �����������: (.*?) \((.*?)\), �������: (.*?)\r\n(?s).*', '$1'&@CRLF&'$2'&@CRLF&'$3'&@CRLF&'$4'&@CRLF&'$5'&@CRLF&'$6'&@CRLF&'$7'&@CRLF&'$8'&@CRLF&'$9'&@CRLF&'$10'&@CRLF&'$11'&@CRLF&'$12', 1)
;~    $detinfpor5 = StringRegExpReplace($detinfpor4, '\(', '1', 1)
   
   ;��������� ��������� �� ����������
   $detinfpor6 = StringRegExp($detinfpor5, '(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)'&@CRLF&'(.*)',1)
MsgBox(0, "��������� ���������� ��������:", $detinfpor5,1) 
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
   
   
   
;~    MsgBox(0, "Ubound ���������� ��������:", Ubound($detinfpor6))
   
;~ .*(���������: .*$).*:([0-9]{1,}?),[0-9]{1,}?RUR.*����������: (.*)\((.*)\), �������: (.*)\r\n'
;~ (.*������������ ����������: .*\()(.*\)).*�������: (.*$)
;~ (�����������: (.*?) \((.*?)\), �������: (.*?)\r\n������������ �����������: (.*?) \((.*?)\), �������: (.*?)\r\n
;~ (.*
   
   
   
;~    $Rnumber = StringRegExp( '����� ��������� � ��������', '�������',1)
;~ $Rnumber = StringRegExp( '<test>$ClipPF</Test>', '<(?i)test>��������: R152787</(?i)test>' )
$Rnumber = StringRegExp( $ClipPF, '���������: (R[0-9]*)',1)
;~ MsgBox(0, "$Rnumber ��������:", $Rnumber[0])
;~ MsgBox(0, "$Rnumber ��������:", Ubound($Rnumber))
;~ 	MsgBox(0, "$ClipPF ��������:", $ClipPF)

;���������� ������ ������ ������
$ClipPFfix = StringRegExpReplace($detinfpor4,'������ �����������/���������� ���������', '�����:'&@CRLF&'������ �����������/���������� ���������')

$poruchenie = StringRegExp($ClipPFfix, '(�����:)'&@CRLF&$Rnumber[0]&'(?s)(.*?)�����:',1)


	
	;���������� ������ ��������� �� ������ ���������
	$poruchenie1 = $poruchenie[0]&@CRLF&$Rnumber[0]&$poruchenie[1]

;���������� ����������� ����
	  $poruchenie1fix = StringRegExpReplace($poruchenie1,'(\d+-\d+-[0-9]{1,}?.*\r\n)>','$1 ���� �� ������'&@CRLF&'>')


; ���������� ��� ����� ���������� ��������
   $infpor2 = StringRegExp( $poruchenie1fix, '(?s)(.*\d+-\d+-[0-9]{1,}?.*)\r\n'&'(.*)\r\n>'&'(.*)',1)
;~ MsgBox(0, "Ubound ���������� ��������:", Ubound($infpor2))
;~ MsgBox(0, "��������� ���������� ��������:", $infpor2[0]&@CRLF&'2)'&$infpor2[2]&@CRLF&'1)'&$infpor2[1])
;~    MsgBox(0, "��������� ���������� ��������:", $infpor2[0]&$infpor2[1]&@CRLF&'2)'&$infpor2[3]&@CRLF&'1)'&$infpor2[2])
	
	$infpor2_1 = $infpor2[0]&@CRLF&$infpor2[2]&@CRLF&$infpor2[1]
	
	;�������� "�������������"
	$infpor3 = StringRegExpReplace($infpor2_1,'�������������:  \r\n','')

   ;������� ������� Z
	$infpor4 = StringRegExpReplace($infpor3,'������ �������� �������','Z������ �������� �������')
	
	;������� �������� �� �������� ������ ��������� Z
	$infpor5= StringRegExpReplace($infpor4,'�������� �� �������� ������ ���������','Z�������� �� �������� ������ ���������')

   ;��������� ���� � ���������� ������
   $infpor6 = StringRegExp($infpor5,'(?s)(.*\d{2,4})-(\d{2,4}.*)',1)
   $infpor6_1 = $infpor6[0]&'.'&$infpor6[1]
   $infpor6_2 = StringRegExp($infpor6_1,'(?s)(.*\d{2,4})-(\d{2,4}.*)',1)
   $infpor6_3 = $infpor6_2[0]&'.'&$infpor6_2[1]
   
   ;~ 	;������� ������ ������
	$infpor6_31 = StringRegExpReplace($infpor6_3, '\r\n\r\n',@CRLF)
	$infpor6_32 = StringRegExpReplace($infpor6_31, '\r\n\r\n',@CRLF)
	$infpor6_33= StringRegExpReplace($infpor6_32, '\r\n\r\n',@CRLF)
;~    $infpor6_33 = StringRegExpReplace($infpor6_3, '\r\n|\r|\n{2,}', '\1',3)
;~ 	MsgBox(0, "��������� ���������� ��������:",$infpor6_33)

   ;���������������
   $infpor6_4 = StringRegExp($infpor6_33,'.*�����:\r\n(R[0-9]*).*(Z.*)\)(?s).*���� ��������:\r\n([0-9]{4}\.[0-9]{2}\.[0-9]{2})\t(.*?$)',1)
;~    $infpor6_4 = StringRegExp($infpor6_33,'.*�����:\r\n(R[0-9]*)\t.*(Z[0-9])\).*���� ��������:\r\n([0-9]{4}\.[0-9]{2}\.[0-9]{2})\t(.*?$)',1)
   $infpor6_5 = $infpor6_4[0]&@CRLF&$infpor6_4[1]&@CRLF&$infpor6_4[2]&@CRLF&$infpor6_4[3]

   ;�������� � ����������� ���� �����
   $infpor7 = StringRegExpReplace($infpor6_5, '([0-9]{1,}?) ([0-9]{3}) RUR[ ]*>\t(.*)\r\n', '$1$2'&@CRLF&'$3'&@CRLF, 1)
   $infpor7_1 = StringRegExpReplace($infpor7, '([0-9]{3}) RUR[ ]*>\t(.*)\r\n', '$1'&@CRLF&'$2'&@CRLF, 1)
	$infpor7_2 = StringRegExpReplace($infpor7_1, '([0-9]{1,}?) ([0-9]{3}) RUR[ ]*>', '$1$2', 1)
   $infpor7_3 = StringRegExpReplace($infpor7_2, '([0-9]{3}) RUR[ ]*>', '$1', 1)

	
	;�������  ����������
	$infpor8 = StringRegExpReplace($infpor7_3, '\t', '', 1)	
	
	;�������� � ����� ������ Enter 
	$infpor9 = StringRegExpReplace($infpor8, '(&s)(.*)', '$1'&@CRLF, 1)
	
	;�������������� ����� ���
;~ 	$infpor10 = StringRegExpReplace($infpor9, "(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&, "$3\t����� ���������\t$5\t\t\t\t$2\t$1\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$4\t$7\t$8\t\t\t$6", 1)
;~ 	$infpor10 = StringRegExpReplace($infpor9, "(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)", "$3\t����� ���������\t$5\t\t\t\t$2\t$1\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$4\t$7\t$8\t\t\t$6", 1)
	$infpor10 = StringRegExpReplace($infpor9, "(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)", "$3"& @Tab &"����� ���������"& @Tab &"$5"& @Tab &""& @Tab &""& @Tab &""& @Tab &"$2"& @Tab &"$1"& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &$name10& @Tab &$name11& @Tab &$name9& @Tab &$name7& @Tab &$name8& @Tab &$name6& @Tab &"$7"& @Tab &"$8"& @Tab &$name1& @Tab &$name2& @Tab &$name0& @Tab &$name4& @Tab &$name5& @Tab &$name3, 1)
	
	;���������� ������� Z
	$infpor10_1 = StringRegExpReplace($infpor10,'Z������ �������� �������','������ �������� �������')
	
	;���������� �������� �� �������� ������ ��������� Z
	$infpor10_2= StringRegExpReplace($infpor10_1,'Z�������� �� �������� ������ ���������','�������� �� �������� ������ ���������')

	
	
	;�������� ���������� ������ ������
ClipPut($infpor10_2)
	TrayTip ("���������","������!)",1000)
;~ 	MsgBox(0, "��������� ���������� ��������:",$infpor6_5)
;~ MsgBox(0, "Ubound ���������� ��������:", Ubound($infpor7))
	MsgBox(0, "��������� ���������� ��������:", $infpor10_2,1)
;~ 	MsgBox(0, "��������� ���������� ��������:",$infpor6_4[0]&';'&$infpor6_4[1]&';'&$infpor6_4[2]&';'&$infpor6_4[3])
	
	
;~ Exit	
	  
   EndFunc


   Func _Poruchenie_iz_spiska_poruchenii()
	  
	  	  _WinAPI_LoadKeyboardLayoutEx($Eng); ��������� ��������� � ���� ����� �� ����� �������� ��������� ������
_SendEx("^"&"c") ;����� ��������� ������
_SendEx("^"&"{INSERT}");����� ��������� ������
   Send("^c")
   Send("^"&"c")
   send ("^"&"{INSERT}")
;~    send ("{TAB}") ';����� ��������� � ��������'
_SendEx("^"&"c") ;����� ��������� �������
_SendEx("^"&"{INSERT}");����� ��������� ������
	  
	  $poruchenie1 = ClipGet()
	  
	  
	  ;���������� ����������� ����
	  $poruchenie1fix = StringRegExpReplace($poruchenie1,'(\d+-\d+-[0-9]{1,}?.*\r\n)>','$1 ���� �� ������'&@CRLF&'>')
;~ 	  msgBox(0, "��������� ���������� ��������:", $poruchenie1fix)
	  
; ���������� ��� ����� ���������� ��������
   $infpor2 = StringRegExp( $poruchenie1fix, '(?s)(.*\d+-\d+-[0-9]{1,}?.*)\r\n'&'(.*)\r\n>'&'(.*)',1)
;~ MsgBox(0, "Ubound ���������� ��������:", Ubound($infpor2))
;~ MsgBox(0, "��������� ���������� ��������:", $infpor2[0]&@CRLF&'2)'&$infpor2[2]&@CRLF&'1)'&$infpor2[1])
;~    MsgBox(0, "��������� ���������� ��������:", $infpor2[0]&$infpor2[1]&@CRLF&'2)'&$infpor2[3]&@CRLF&'1)'&$infpor2[2])
	
	$infpor2_1 = $infpor2[0]&@CRLF&$infpor2[2]&@CRLF&$infpor2[1]
	
	;�������� "�������������"
	$infpor3 = StringRegExpReplace($infpor2_1,'�������������:  \r\n','')

   ;������� ������� Z
	$infpor4 = StringRegExpReplace($infpor3,'������ �������� �������','Z������ �������� �������')
	
	;������� �������� �� �������� ������ ��������� Z
	$infpor5= StringRegExpReplace($infpor4,'�������� �� �������� ������ ���������','Z�������� �� �������� ������ ���������')

   ;��������� ���� � ���������� ������
   $infpor6 = StringRegExp($infpor5,'(?s)(.*\d{2,4})-(\d{2,4}.*)',1)
   $infpor6_1 = $infpor6[0]&'.'&$infpor6[1]
   $infpor6_2 = StringRegExp($infpor6_1,'(?s)(.*\d{2,4})-(\d{2,4}.*)',1)
   $infpor6_3 = $infpor6_2[0]&'.'&$infpor6_2[1]
   
   ;~ 	;������� ������ ������
	$infpor6_33 = StringRegExpReplace($infpor6_3, '\r\n\r\n','')
;~ 	MsgBox(0, "��������� ���������� ��������:",$infpror)

   ;���������������
   $infpor6_4 = StringRegExp($infpor6_33,'.*�����:\r\n(R[0-9]*).*(Z.*)\)(?s).*���� ��������:\r\n([0-9]{4}\.[0-9]{2}\.[0-9]{2})\t(.*?$)',1)
;~    $infpor6_4 = StringRegExp($infpor6_33,'.*�����:\r\n(R[0-9]*)\t.*(Z[0-9])\).*���� ��������:\r\n([0-9]{4}\.[0-9]{2}\.[0-9]{2})\t(.*?$)',1)
   $infpor6_5 = $infpor6_4[0]&@CRLF&$infpor6_4[1]&@CRLF&$infpor6_4[2]&@CRLF&$infpor6_4[3]

   ;�������� � ����������� ���� �����
   $infpor7 = StringRegExpReplace($infpor6_5, '([0-9]{1,}?) ([0-9]{3}) RUR[ ]*>\t(.*)\r\n', '$1$2'&@CRLF&'$3'&@CRLF, 1)
   $infpor7_1 = StringRegExpReplace($infpor7, '([0-9]{3}) RUR[ ]*>\t(.*)\r\n', '$1'&@CRLF&'$2'&@CRLF, 1)
	$infpor7_2 = StringRegExpReplace($infpor7_1, '([0-9]{1,}?) ([0-9]{3}) RUR[ ]*>', '$1$2', 1)
   $infpor7_3 = StringRegExpReplace($infpor7_2, '([0-9]{3}) RUR[ ]*>', '$1', 1)

	
	;�������  ����������
	$infpor8 = StringRegExpReplace($infpor7_3, '\t', '', 1)
	
	;�������� � ����� ������ Enter 
	$infpor9 = StringRegExpReplace($infpor8, '(&s)(.*)', '$1'&@CRLF, 1)
	
	;�������������� ����� ���
;~ 	$infpor10 = StringRegExpReplace($infpor9, "(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&"(.*)"&@CRLF&, "$3\t����� ���������\t$5\t\t\t\t$2\t$1\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$4\t$7\t$8\t\t\t$6", 1)
;~ 	$infpor10 = StringRegExpReplace($infpor9, "(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)", "$3\t����� ���������\t$5\t\t\t\t$2\t$1\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t\t$4\t$7\t$8\t\t\t$6", 1)
	$infpor10 = StringRegExpReplace($infpor9, "(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)\r\n(.*)", "$3"& @Tab &"����� ���������"& @Tab &"$5"& @Tab &""& @Tab &""& @Tab &""& @Tab &"$2"& @Tab &"$1"& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &""& @Tab &"$4"& @Tab &"$7"& @Tab &"$8"& @Tab &""& @Tab &""& @Tab &"$6", 1)
	
	;���������� ������� Z
	$infpor10_1 = StringRegExpReplace($infpor10,'Z������ �������� �������','������ �������� �������')
	
	;���������� �������� �� �������� ������ ��������� Z
	$infpor10_2= StringRegExpReplace($infpor10_1,'Z�������� �� �������� ������ ���������','�������� �� �������� ������ ���������')

	
	
	;�������� ���������� ������ ������
ClipPut($infpor10_2)
	TrayTip ("���������","������!)",1000)
;~ 	MsgBox(0, "��������� ���������� ��������:",$infpor6_5)
;~ MsgBox(0, "Ubound ���������� ��������:", Ubound($infpor7))
;~ 	MsgBox(0, "��������� ���������� ��������:", $infpor10)
;~ 	MsgBox(0, "��������� ���������� ��������:",$infpor6_4[0]&';'&$infpor6_4[1]&';'&$infpor6_4[2]&';'&$infpor6_4[3])
	
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

;~ MsgBox(0, "$sDate ��������:", $sDate)
$file = FileOpen("4Open\" & $Namefile, 2)

   ; ���������, �������� �� ���� ��������, ����� ��� ��� ������������ ������� ������/������ � ����
   If $file = -1 Then
	   MsgBox(4096, "������", "���������� ������� ����.")
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