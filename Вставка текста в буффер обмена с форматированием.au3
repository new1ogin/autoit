#include <GuiConstantsEx.au3>
#include <ClipBoard.au3>
#include <WindowsConstants.au3>

$sRes = ''
$String1251RTF = ''
    $bBin = StringToBinary("Ё!№;%:?*()_+~!@#$%^&*()_+\|/[]{};':,./<>?", 1) ; делаем бинарными
	$bBin = StringLower(StringTrimLeft($bBin,2))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $bBin = ' & $bBin & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	$t5=StringLen($bBin)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($bBin) = ' & StringLen($bBin) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	For $i=1 to StringLen($bBin)/2
		$String1251RTF &= "\'" & stringmid($bBin,$i*2-1,2)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $i*2 = ' & $i*2 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ($i*2)+2 = ' & ($i*2)+2 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
	Next
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $String1251RTF = ' & $String1251RTF & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;~     $sStr = BinaryToString($bBin, 1) ; делаем строковыми
;~     $sRes &= 'flag=' & 1 & @LF & 'Представленная как String() : ' & $bBin & @LF & _
;~             'Представленная как BinaryToString() '&'ANSI'&' : ' & $sStr & @LF & @LF


$RTF="{\rtf1\ansi\ansicpg1251\deff0\deflang1049{\fonttbl{\f0\fswiss\fcharset204{\*\fname Arial;}Arial CYR;}}" & _
"{\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\f0\fs20\'ea\'ee\b\fs24\'f0\'ee\b0\fs20\'e2\'e0"&$String1251RTF&"\par}"
;~ $RTF="{\rtf1\ansi\ansicpg1252{\colortbl;\red255\green255\blue255;\red255\green255\blue255;\red18\green18\blue17;} \deftab720 \pard\pardeftab720\partightenfactor0 \f0\fs28 \cf2 \cb3 \expnd0\expndtw0\kern"
;~ $RTF="{\rtf1\ansi\ansicpg1251\deff0\deflang1049" & @CRLF & _
;~ "{\*\generator Msftedit 5.41.15.1515;}\viewkind4\uc1\pard\lang1033\f0\fs20" & $String1251RTF & "}" ;@CRLF & _
;~ "\b TestType\b0\par" & @CRLF & _
;~ "TestTyoe}" & @CRLF
;~ sleep(2000)
;~ $data= 0x080000001D48000082030000BC06262A
$t3 = 49323

$t3 = 49323
$ifs = _ClipBoard_RegisterFormat("Rich Text Format" )
$t1=_ClipBoard_SetData($RTF, $ifs)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

exit

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ifs = ' & $ifs & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$teststring = StringSplit('t3|ifs|CF_TEXT|CF_BITMAP|CF_METAFILEPICT|CF_SYLK|CF_DIF|CF_TIFF|CF_OEMTEXT|CF_DIB|CF_PALETTE|CF_PENDATA|CF_RIFF|CF_WAVE|CF_UNICODETEXT|CF_ENHMETAFILE|CF_HDROP|CF_LOCALE|CF_DIBV5|CF_OWNERDISPLAY|CF_DSPTEXT|CF_DSPBITMAP|CF_DSPMETAFILEPICT|CF_DSPENHMETAFILE','|')
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $CF_TEXT = ' & $CF_TEXT & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $CF_BITMAP = ' & $CF_BITMAP & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
$ifsData = _ClipBoard_GetData($ifs)
For $i=1 to Ubound($teststring)-1
	ConsoleWrite($teststring[$i]& ' = ' & Eval ($teststring[$i]) & @CRLF)
	ConsoleWrite(BinaryToString(_ClipBoard_GetData(Eval ($teststring[$i]))) & @CRLF)
Next
sleep(1000)
;~ $t1=_ClipBoard_SetData($RTF, 49323)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ send ('+{ins}')
sleep(1000)
$t1=_ClipBoard_SetData($RTF, $ifs)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
send ('+{ins}')
sleep(1000)
;~ beep()
;~ sleep(1000)
;~ $t1=_ClipBoard_SetData($ifsData+$ifsData, $ifs)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $t1 = ' & $t1 & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

