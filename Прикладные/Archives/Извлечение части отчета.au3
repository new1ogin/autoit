#include <string.au3>

global $sPath,$bytes,$sPathTemp,$part,$bytesStep,$steps
$sPath = 'D:\Reports\�����_�����_Smak-new\�����_�����_Smak-new.htm'
$FileW = $sPath & '.INFO.htm'
$FileW2 = $sPath & '.EVENTLOG.htm'
$Findstep = 0
$Findtxt1 = '<!-- SW --><TABLE WIDTH=100%><TD CLASS=pt><A NAME="event logs">'
$Findtxt2 = '</TABLE><BR><BR>'
$FindHead = '<!-- SW -->'
$xFindtxt1 = _StringToHex($Findtxt1)
$xFindtxt2 = _StringToHex($Findtxt2)
$xFindHead = _StringToHex($FindHead)
$End2file = @CRLF & '<HR>' & @CRLF & '<BR>' & @CRLF & 'The names of actual companies and products mentioned herein may be the trademarks of their respective owners.<BR>' & @CRLF & '</BODY>' & @CRLF & '</HTML>'
ConsoleWrite('|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||<-end' & @CRLF)

$hRead = FileOpen($sPath, 16)
$iSize = FileGetSize($sPath)
$bytesStep = 36 *1024; ;������ ���� � ������. �������� ��� ����� ���� ���-�� ������ �� ���
$steps = $iSize/$bytesStep + 1

if FileExists($FileW) Then FileDelete($FileW) ;�������� ���� ������ 1
if FileExists($FileW2) Then FileDelete($FileW2) ;�������� ���� ������ 2
$hWrite = FileOpen($FileW, 16 + 1)
$hWrite2 = FileOpen($FileW2, 16 + 1)
; ���� �������� � ������ �����
for $s=1 to $steps
	$xChunk = FileRead($hRead, $bytesStep) ; ������
	if $iSize > $s*$bytesStep Then
		;������
		if $Findstep = 3 Then ;���������� ����� ������� �����
			FileWrite($hWrite, $xChunk)
		EndIf
		if $Findstep = 2 Then ;���������� ������ ����� �����
			$Findstr = StringInStr($xChunk,$xFindtxt2)
			If $Findstr = 0 Then
				FileWrite($hWrite2, $xChunk)
			Else
				FileWrite($hWrite2, StringLeft($xChunk,$Findstr)) ; ����������� ������ ����
				FileWrite($hWrite2, $Findtxt2 & $End2file) ; ����������� ������ ����
				FileWrite($hWrite, StringRight($xChunk,Stringlen($xChunk)-$Findstr))
				ConsoleWrite('@@ Debug(' & $Findstep & ') : $Findstr = ' & $Findstr & @CRLF ) ;### Debug Console
				$Findstep += 1
			EndIf
		EndIf
		if $Findstep = 1 Then ;���������� ������ ����� �����
			$Findstr = StringInStr($xChunk,$xFindtxt1)
			If $Findstr = 0 Then
				FileWrite($hWrite, $xChunk)
			Else
				FileWrite($hWrite, StringLeft($xChunk,$Findstr))
				FileWrite($hWrite2, StringRight($xChunk,Stringlen($xChunk)-$Findstr))
				ConsoleWrite('@@ Debug(' & $Findstep & ') : $Findstr = ' & $Findstr & @CRLF ) ;### Debug Console
				$Findstep += 1
			EndIf
		EndIf
		if $Findstep = 0 Then ;���������� ���������
			$Findstr = StringInStr($xChunk,$xFindHead)
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $xChunk = ' & $xChunk & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
			If $Findstr = 0 Then
				FileWrite($hWrite, $xChunk)
				FileWrite($hWrite2, $xChunk)
			Else
				FileWrite($hWrite, $xChunk)
				FileWrite($hWrite2, _StringToHex(StringLeft($xChunk,$Findstr))) ; ���������� ��������� �� ������ ����
				ConsoleWrite('@@ Debug(' & $Findstep & ') : $Findstr = ' & $Findstr & @CRLF ) ;### Debug Console
				$Findstep += 1
			EndIf
		EndIf
;~ 		$Findstr = StringInStr($xChunk,$FindHead
;~ 		FileWrite($hWrite, $xChunk)
;~ 		ConsoleWrite('|')
	Else
		;������
		if $Findstep = 0 Then ;���������� ���������
			$Findstr = StringInStr($xChunk,$FindHead)
			If $Findstr = 0 Then
				FileWrite($hWrite, $xChunk)
				FileWrite($hWrite2, $xChunk)
			Else
				FileWrite($hWrite, $xChunk)
				FileWrite($hWrite2, StringLeft($xChunk,$Findstr)) ; ���������� ��������� �� ������ ����
				$Findstep += 1
			EndIf
		EndIf
		if $Findstep = 1 Then ;���������� ������ ����� �����
			$Findstr = StringInStr($xChunk,$Findtxt1)
			If $Findstr = 0 Then
				FileWrite($hWrite, $xChunk)
			Else
				FileWrite($hWrite, StringLeft($xChunk,$Findstr))
				FileWrite($hWrite2, StringRight($xChunk,Stringlen($xChunk)-$Findstr))
				$Findstep += 1
			EndIf
		EndIf
		if $Findstep = 2 Then ;���������� ������ ����� �����
			$Findstr = StringInStr($xChunk,$Findtxt2)
			If $Findstr = 0 Then
				FileWrite($hWrite2, $xChunk)
			Else
				FileWrite($hWrite2, StringLeft($xChunk,$Findstr)) ; ����������� ������ ����
				FileWrite($hWrite2, $Findtxt2 & $End2file) ; ����������� ������ ����
				FileWrite($hWrite, StringRight($xChunk,Stringlen($xChunk)-$Findstr))
				$Findstep += 1
			EndIf
		EndIf
		if $Findstep = 3 Then ;���������� ����� ������� �����
			FileWrite($hWrite, $xChunk)
		EndIf
	EndIf

	if Mod ($s,Round($steps/100)) = 0 then ConsoleWrite('|')

next

ConsoleWrite('@@ Debug(' & $Findstep & ') : $Findstr = ' & $Findstr & @CRLF ) ;### Debug Console
exit

;������
;~ FileSetPos($hRead, 0, 0)
;~ $i = 1
;~ While 1
;~ 	$FileW = $sPathNew & 'file_' & $i & '.small'
;~ 	$FileA = $sPathNew & 'file_' & $i &'.7z'
;~ 	if FileExists($FileW) Then FileDelete($FileW)
;~ 	_Split_n($n, $FileW)
;~ 	if $bytes > $bytesStep Then
;~ 		$hWrite = FileOpen($FileW, 16 + 1)
;~ 		for $s=1 to $steps
;~ 			$xChunk = FileRead($hRead, $bytesStep)
;~ 			FileWrite($hWrite, $xChunk)
;~ 			if Mod ($s,10) = 0 then ConsoleWrite('|')
;~ 		next
;~ 	else
;~     $hWrite = FileOpen($FileW, 16 + 2)
;~     $xChunk = FileRead($hRead, $bytes)
;~     FileWrite($hWrite, $xChunk)
;~ 	endif
;~     FileClose($hWrite)
;~ 	$7ZipAdd = _7ZipAdd(0, $FileA, $FileW, " -hide", 9)
;~ 	if FileGetSize($FileA) > 64 Then FileDelete($FileW)

;~ 	if $iSize < $bytes*$i Then Exitloop
;~ 	$i += 1
;~ WEnd

;~ ; ���������� �� ����� ����� $n
;~ Func _Split_n($n, $FileW='')
;~ 	if FileExists($FileW) Then FileDelete($FileW)
;~ 	if $bytes > $bytesStep Then
;~ 		$hWrite = FileOpen($FileW, 16 + 1)
;~ 		FileSetPos($hRead, $bytes*($n-1), 0)
;~ 		for $s=1 to Ceiling($steps)
;~ 			if $s=Ceiling($steps) Then
;~ 				$xChunk = FileRead($hRead, $bytes-($bytesStep*Floor($steps))) ; �������� �� ������ ���� ����� �����
;~ 			Else
;~ 				$xChunk = FileRead($hRead, $bytesStep)
;~ 			EndIf
;~ 			FileWrite($hWrite, $xChunk)
;~ 			if Mod ($s,10) = 0 then ConsoleWrite('|') ; ��� ���������� �� ����� ��������
;~ 		next
;~ 	else ; �� ������ ���� ���� ������ ����
;~ 		$hWrite = FileOpen($FileW, 16 + 2)
;~ 		FileSetPos($hRead, $bytes*($n-1), 0)
;~ 		$xChunk = FileRead($hRead, $bytes)
;~ 		FileWrite($hWrite, $xChunk)
;~ 	endif
;~ 	FileClose($hWrite)
;~ EndFunc