#include <Array.au3>

$UserDir = _PathSplitByRegExp(@UserProfileDir)
$UserDir = $UserDir[2]

$aDomains = _domainsList() ;Записывает в переменную список доменов верхнего уровня, для последующего поиска сайтов
$patchlnk = FileSelectFolder("Выберите папку для поиска ярлыков",'',4,$UserDir) ;Запрос на ввод директории для поиска
if $patchlnk = '' then exit
$aLnks = _FileSearch($patchlnk, "*.lnk")
$tempdir = @TempDir & '\'

dim $aListLnk[10000][8]
dim $otchet[1][3]
for $i=1 to $aLnks[0]
	$aLnkInfo = FileGetShortcut ( $aLnks[$i] )
;~ 	_ArrayDisplay($aLnkInfo)
	if not @error then
		$aListLnk[$i][0] =$aLnkInfo[0]
		$aListLnk[$i][1] =$aLnkInfo[1]
		$aListLnk[$i][2] =$aLnkInfo[2]
		$aListLnk[$i][3] =$aLnkInfo[3]
		$aListLnk[$i][4] =$aLnkInfo[4]
		$aListLnk[$i][5] =$aLnkInfo[5]
		$aListLnk[$i][6] =$aLnkInfo[6]
		$file = _PathSplitByRegExp($aLnks[$i])
		$aListLnk[$i][7] = $file[5]
	;~ 	ConsoleWrite($aLnkInfo[2] & @CRLF)
		for $d=0 to Ubound($aDomains)-1
			if StringRegExp($aLnkInfo[2], '\.'&$aDomains[$d]&'[^a-zA-Z]') = 1 or StringRegExp($aLnkInfo[2], '\.'&$aDomains[$d]&'$') = 1 Then ; '\.'&$aDomains[$i]&'[^a-zA-Z]'
;~ 				$t1 = FileCreateShortcut($aLnkInfo[0], $tempdir & $file[5], $aLnkInfo[1], '', $aLnkInfo[3], $aLnkInfo[4], $aLnkInfo[5], $aLnkInfo[6])
;~ 				$t2 = FileMove($tempdir & $file[5], $aLnks[$i], 1)
;~ 				$otchet[Ubound($otchet)-1][0] = $aLnkInfo[2] &' '&$t1&' '&$t2
				$otchet[Ubound($otchet)-1][0] = $aLnkInfo[2]
				$otchet[Ubound($otchet)-1][1] = $file[5]
				$otchet[Ubound($otchet)-1][1] = $aLnks[$i]
;~ 				ConsoleWrite($otchet[Ubound($otchet)-1][0] & @CRLF)
				ReDim $otchet[Ubound($otchet)+1][3]

			EndIf
		Next

	EndIf
Next

_ArrayDisplay($otchet)

;$iFlag = 0 - Файлы и папки (по умолчанию)
;$iFlag = 1 - Только файлы
;$iFlag = 2 - Только папки
Func _FileSearch($sPath, $sFileMask, $iFlag = 0)
    Local $sOutBin, $sOut, $aOut, $sRead, $hDir, $sAttrib

    Switch $iFlag
        Case 1
            $sAttrib = ' /A-D'
        Case 2
            $sAttrib = ' /AD'
        Case Else
            $sAttrib = ' /A'
    EndSwitch

    $sOut = StringToBinary('0' & @CRLF, 2)
    $aMasks = StringSplit($sFileMask, ';')

    For $i = 1 To $aMasks[0]
        $hDir = Run(@ComSpec & ' /U /C DIR "' & $sPath & '\' & $aMasks[$i] & '" /S /B' & $sAttrib, @SystemDir, @SW_HIDE, 6)

        While 1
            $sRead = StdoutRead($hDir, False, True)

            If @error Then
                ExitLoop
            EndIf

            If $sRead <> "" Then
                $sOut &= $sRead
            EndIf
        Wend
    Next

    $aOut = StringRegExp(BinaryToString($sOut, 2), '[^\r\n]+', 3)

    If @error Then
        Return SetError(1)
    EndIf

    $aOut[0] = UBound($aOut)-1
    Return $aOut
EndFunc

Func _PathSplitByRegExp($sPath,$pDelim = '')
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"

    $aRetArray[0] = $sPath ;Full path
    $aRetArray[1] = StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
    $aRetArray[2] = StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
    $aRetArray[3] = StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
    $aRetArray[4] = StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
    $aRetArray[5] = StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
    $aRetArray[6] = StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
    $aRetArray[7] = StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file

    Return $aRetArray
EndFunc

Func _domainsList()
	$domains = 'aero|asia|biz|cat|com|coop|edu|gov|info|int|jobs|mil|mobi|museum|name|net|org|pro|tel|travel|xxx|ac|ad|ae|af|ag|ai|al|am|an|ao|aq|ar|as|at|au|aw|ax|az|ba|bb|bd|be|bf|bg|bh|bi|bj|bm|bn|bo|br|bs|bt|bv|bw|by|bz|ca|cc|cd|cf|cg|ch|ci|ck|cl|cm|cn|co|cr|cs|cu|cv|cx|cy|cz|dd|de|dj|dk|dm|do|dz|ec|ee|eg|er|es|et|eu|fi|fj|fk|fm|fo|fr|ga|gb|gd|ge|gf|gg|gh|gi|gl|gm|gn|gp|gq|gr|gs|gt|gu|gw|gy|hk|hm|hn|hr|ht|hu|id|ie|il|im|in|io|iq|ir|is|it|je|jm|jo|jp|ke|kg|kh|ki|km|kn|kp|kr|kw|ky|kz|la|lb|lc|li|lk|lr|ls|lt|lu|lv|ly|ma|mc|md|me|mg|mh|mk|ml|mm|mn|mo|mp|mq|mr|ms|mt|mu|mv|mw|mx|my|mz|na|nc|ne|nf|ng|ni|nl|no|np|nr|nu|nz|om|pa|pe|pf|pg|ph|pk|pl|pm|pn|pr|ps|pt|pw|py|qa|re|ro|rs|ru|рф|rw|sa|sb|sc|sd|se|sg|sh|si|sj|sk|sl|sm|sn|so|sr|st|su|sv|sy|sz|tc|td|tf|tg|th|tj|tk|tl|tm|tn|to|tp|tr|tt|tv|tw|tz|ua|ug|uk|us|uy|uz|va|vc|ve|vg|vi|vn|vu|wf|ws|ye|yt|za|zm|zw|xn--lgbbat1ad8j|xn--fiqs8s|xn--fiqz9s|xn--wgbh1c|xn--j6w193g|xn--h2brj9c|xn--mgbbh1a71e|xn--fpcrj9c3d|xn--gecrj9c|xn--s9brj9c|xn--xkc2dl3a5ee0h|xn--45brj9c|xn--mgba3a4f16a|xn--mgbayh7gpa|xn--mgbc0a9azcg|xn--ygbi2ammx|xn--wgbl6a|xn--p1ai|xn--mgberp4a5d4ar|xn--90a3ac|xn--yfro4i67o|xn--clchc0ea0b2g2a9gcd|xn--3e0b707e|xn--fzc2c9e2c|xn--xkc2al3hye2a|xn--ogbpf8fl|xn--kprw13d|xn--kpry57d|xn--o3cw4h|xn--pgbs0dh|xn--j1amh|xn--mgbaam7a8h|срб|укр|xn--54b7fta0cc|xn--90ae|xn--node|xn--4dbrk0ce|xn--mgb9awbf|xn--mgbai9azgqp6j|xn--mgb2ddes|бг|xn--kgbechtv|xn--hgbk6aj7f53bba|xn--0zwm56d|xn--g6w251d|xn--80akhbyknj4f|xn--11b5bs3a9aj6g|xn--jxalpdlp|xn--9t4b11yi5a|xn--deba0ad|xn--zckzah|xn--hlcj6aya9esc7a'
	$aDomains = StringSplit($domains,'|')
	return $aDomains
EndFunc
