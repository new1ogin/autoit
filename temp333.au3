Local $a[5]=['', 'ANSI', 'UTF16-LE', 'UTF16-BE', 'UTF8']
$sRes = ''
For $i = 1 To 4
    $bBin = StringToBinary("������ ���", $i) ; ������ ���������
    $sStr = BinaryToString($bBin, $i) ; ������ ����������
    $sRes &= 'flag=' & $i & @LF & '�������������� ��� String() : ' & $bBin & @LF & _
            '�������������� ��� BinaryToString() '&$a[$i]&' : ' & $sStr & @LF & @LF
Next
MsgBox(0, '���������', $sRes)