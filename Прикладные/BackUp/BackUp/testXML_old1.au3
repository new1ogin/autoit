#include <Array.au3>

global $aReadStep,$file,$maxSizeObject,$SizeReadStep,$hFile
$maxSizeObject = 100*1024 ; - 100�� ��� 65000 ��������
$SizeReadStep = 100;4*1024 ; ������ ������ �� ���
dim $aReadStep[2] ;������ � ������ ������ �����
global $iStep=1,$FilePos=0

$file = 'C:\Users\�������\Desktop\NSK10.02-12.02_telegina.xml'

 _ReadStep()
_ArrayDisplay($aReadStep)

Func _ReadStep()
	if $iStep=1 Then
		$hFile = FileOpen ($file,16)
		$aReadStep[1]= FileRead ($hFile, $SizeReadStep*$iStep)
	EndIf
	_ArrayPush($aReadStep,FileRead ($hFile, $SizeReadStep*$iStep),1)
EndFunc

