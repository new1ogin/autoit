#include <Array.au3>

Global $aReadStep, $file, $maxSizeObject, $SizeReadStep, $hFile,$ListObjects
$maxSizeObject = 100 * 1024 ; - 100�� ��� 65000 ��������, ������ ���� � ��������� ��� ������ $SizeReadStep
$SizeReadStep = 1024 ; ������ ������ �� ���
Dim $aReadStep[2] ;������ � ������ ������ �����
Dim $ListObjects[1] ;������ �� ������� ��������
Global $iStep = 1, $FilePos = 0,$TextPos=0

$file = 'C:\Users\�������\Desktop\NSK10.02-12.02_telegina.xml'

_ReadStep()

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aReadStep = ' & $aReadStep[0] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aReadStep = ' & $aReadStep[1] & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
_ArrayDisplay($aReadStep)

Func _ReadStep()
	If $iStep = 1 Then
		$hFile = FileOpen($file, 0)
		$aReadStep[1] = FileRead($hFile, $SizeReadStep * $iStep)
	EndIf
	_ArrayPush($aReadStep, FileRead($hFile, $SizeReadStep * $iStep), 0)
EndFunc   ;==>_ReadStep

Func _findObject()
	StringRegExp ( "test", "pattern" [, flag = 0 [, offset = 1 ]] )

Func _DetectObject($teg,$pos)


EndFunc


Func _L(T
