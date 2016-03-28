Local $a[5]=['', 'ANSI', 'UTF16-LE', 'UTF16-BE', 'UTF8']
$sRes = ''
For $i = 1 To 4
    $bBin = StringToBinary("Привет мир", $i) ; делаем бинарными
    $sStr = BinaryToString($bBin, $i) ; делаем строковыми
    $sRes &= 'flag=' & $i & @LF & 'Представленная как String() : ' & $bBin & @LF & _
            'Представленная как BinaryToString() '&$a[$i]&' : ' & $sStr & @LF & @LF
Next
MsgBox(0, 'Сообщение', $sRes)