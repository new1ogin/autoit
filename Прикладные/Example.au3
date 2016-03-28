#include <array.au3>

#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <Encoding.au3>
#include <array.au3>
#include <FTPEx.au3>
#Include <Constants.au3>
#include <Crypt.au3>
#include <WindowsConstants.au3>
#include<File.au3>

global $sPath,$bytes,$sPathTemp,$part,$bytesStep,$steps,$hRead,$iSize
$bytes=4*1024
$bytesStep=$bytes
$steps=1
$sPathDir = 'D:\Temp\temp'
$sPath='C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\3_one_sell'
;~ $sPath = 'D:\Temp\temp\07.03.2015-27.03.2015\1Cv8.1CD'
$folder = '4_one_each'
DirCreate('C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\'&$folder)
$hRead = FileOpen($sPath, 16)
$iSize = FileGetSize($sPath)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iSize = ' & $iSize & @CRLF) ;### Debug Console
; Массив для хранения хешей
Dim $aHashes[10000]
Dim $aHashes2[10000]
;~ Dim $aHashes3[10000*2]
;~ _ComparefileHash('Orig.txt','4_one_each.txt')
;~ _ComparefileHash('Orig.txt','3_one_sell.txt')
;~ FileExists($name)

;~ 	$name = $sPathDir&"\26.txt"
;~ 	$name2 = $sPathDir&"\27.txt"
;~ $Osize=_ComparefileHash($name,$name2)
;~ ConsoleWrite("$Osize="&$Osize&@CRLF)
;~ exit

;~ _ArrayDisplay($newHash)

; сравнение двух блоьших файлов
;~ $Osize=0
;~ For $i=1 to 36
;~ 	$name = $sPathDir&"\26\26."&StringRight('00'&$i,3)
;~ 	$name2 = $sPathDir&"\27\27."&StringRight('00'&$i,3)
;~ 	$Osize+=_ComparefileHash($name,$name2)
;~ Next
;~ ConsoleWrite("$Osize="&$Osize&@CRLF)
;~ exit

; Массив для хранения хешей
Dim $aHashes[840043+50000]

$HashFileOrig = 'C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\Orig'
$sPath='C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\1Cv8.1CD'
$sPathtest='C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\1Cv8 - копия.1CD'
$sPath2='C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\Orig'
;~ $sPath='C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\26.21'
$PatchResult = _PathSplitByRegExp($sPath,'', 2) & '\_' & _PathSplitByRegExp($sPath,'', 5)
$HashDir = $PatchResult
if not FileExists($PatchResult) then dircreate($PatchResult)
$hRead = FileOpen($sPath, 16)
$iSize = FileGetSize($sPath)
$bytesl=4096
$bytesm=16777216 ; кратное $bytesl
$WName=1
$num=0

;~  _testModify($sPathtest)
;~ _CreatHashFiles($sPathtest)
_CheckFiles_Arch($sPath2,$sPath)
$Dir='c:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\_1Cv8.1CD\087_07-39-27'
;~ _UnpackFiles($sPath,$Dir)
exit

_Crypt_Startup()
$timer = Timerinit()
For $i=1 to $iSize/$bytes
;~ 	$WName=$i
;~ _Split_n($WName, 'C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\'&$folder&'\'&StringRight('000000'&$WName,6))
	$aHashes[$i-$num]=_Crypt_HashData(FileRead($hRead, $bytesStep), $CALG_SHA1)

;~ 	if $i=9999 Then
;~ 		_FileWriteFromArray($sPathDir&'\'&$num&'.txt', $aHashes)
;~ 		$aHashes=0
;~ 		$num+=9999
;~ 	EndIf
Next
_Crypt_Shutdown()
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashes[$i-$num-1] = ' & $aHashes[$i-$num-1] & @CRLF) ;### Debug Console
ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : TimerDiff($timer)1 = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
exit
_FileWriteFromArray($sPathDir&'\'&$num&'.txt', $aHashes)

Func _testModify($sPath)
	$hWrite=FileOpen($sPath,1+16+8)
	$SizeFile = FileGetSize($sPath)
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileGetPos ( $hWrite ) = ' & FileGetPos ( $hWrite ) & @CRLF) ;### Debug Console
	FileSetPos ( $hWrite, 3, 0 )
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileGetPos ( $hWrite ) = ' & FileGetPos ( $hWrite ) & @CRLF) ;### Debug Console
For $num=1 to 6
FileSetPos ( $hWrite, $num*1000*4096, 0 )
FileWrite($hWrite,StringReplace(0xF7F6F5F4F3F2F1F0,"F",$num))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileGetPos ( $hWrite ) = ' & FileGetPos ( $hWrite ) & @CRLF) ;### Debug Console

next
FileClose($hWrite)
Endfunc
Func _UnpackFiles($sPath,$Dir)
	Dim $aBlocks
	_FileReadToArray($Dir & '\' & 'InfoBloks.txt', $aBlocks)
	$hRead = FileOpen($sPath, 16+8)
	$SizeFile = FileGetSize($sPath)
	$hReadBlocks = FileOpen($Dir & '\' & 'Bloks.arch', 16+8)
	if FileExists($Dir & '\' & '1Cv8.1CD') Then FileDelete($Dir & '\' & '1Cv8.1CD')
	$hWrite = FileOpen($Dir & '\' & '1Cv8.1CD',16+1+8)
	$indexblock=1
	$FileContentGeneral =  Binary('')
	$NumberBlocksToWrite=100
	$NumWrite=1
	_ArrayAdd($aBlocks,"") ; добовление пустого значения в конец
_ArrayDisplay($aBlocks)
	;генерируем строку для создание структуры
;~ 	if not $Struct Then
		$Struct = ''
		For $i=1 to $NumberBlocksToWrite-1
			$Struct &= 'byte[' & $bytesl & '];'
		Next
		$Struct &= 'byte[' & $bytesl & ']'
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($Struct) = ' & StringLen($Struct) & @CRLF) ;### Debug Console
;~ 	EndIf
	$FileContGener = DllStructCreate($Struct)

;~ For $i=1 to $SizeFile/$bytesl
;~ 	DllStructSetData($FileContGener,$NumWrite, FileRead($hRead,$bytesl))
;~ 	if $i=1 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileContentL = ' & $FileContentL & @CRLF) ;### Debug Console
;~ 	$FileContentGeneral &= DllStructGetData($FileContGener,$NumWrite)
;~ 	$FileContentL = FileRead($hRead,$bytesl)
;~ 	$FileContentGeneral =   Binary($FileContentGeneral) &  Binary($FileContentL)
;~ 	$NumWrite+=1
;~ 		if Mod($i,100)=0 then
;~ 			FileWrite($hWrite,$FileContentGeneral)
;~ 			$FileContentGeneral = ''
;~ 			$NumWrite=1
;~ 		EndIf
;~ Next
;~ FileWrite($hWrite,$FileContentGeneral)
;~ exit
;~ 	_arraydisplay($aBlocks)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sPath = ' & $sPath & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $SizeFile/$bytesl = ' & $SizeFile/$bytesl & @CRLF) ;### Debug Console
;~ 	exit
	; Цикл создания новой базы из старой базы и информации из архива
	For $i=1 to $SizeFile/$bytesl
		$FileContentL = FileRead($hRead,$bytesl)
;~ 		if $i < 3 then ConsoleWrite(BinaryToString($FileContentL) & @CRLF)
;~ 		if $FileContentL='' then exitloop
		if Mod($i,100)=0 then
			FileWrite($hWrite,$FileContentGeneral)
;~ 			ConsoleWrite('@@ Debug(' & $i & ') : StringLen($FileContentL) = ' & StringLen($FileContentL) & @CRLF) ;### Debug Console
;~ 			ConsoleWrite('@@ Debug(' & $i & ') : StringLen($FileContentGeneral) = ' & StringLen($FileContentGeneral) & @CRLF) ;### Debug Console
			$FileContentGeneral = ''
		EndIf
		if $aBlocks[$indexblock] == $i Then ;Если в InfoBloks.txt записан этот блок, то этот блок брать из архива
			$FileContentL = FileRead($hReadBlocks,$bytesl)
			$indexblock+=1
			ConsoleWrite('@@ Debug(' & $i & ') : $indexblock = ' & $indexblock & @CRLF) ;### Debug Console
		Else ;Если записи в InfoBloks.txt нет, то читать из файла оригинала

		EndIf
;~ 		$FileContentGeneral = Binary($FileContentGeneral) & Binary($FileContentL)

;~ 		$FileContentGeneral &= $FileContentL
		$FileContentGeneral &= BinaryToString($FileContentL)
;~ 		if $i > 1 then
;~ 			$FileContentGeneral &= BinaryToString($FileContentL)
;~ 		Else
;~ 			$FileContentGeneral &= BinaryToString($FileContentL)
;~ 		EndIf

	Next
	;Запись оставщихся блоков
	FileWrite($hWrite,$FileContentGeneral)
			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($FileContentGeneral) = ' & StringLen($FileContentGeneral) & @CRLF) ;### Debug Console

; ОПАСНО СЛИШКОМ БОЛЬШОЕ ПЕРЕПОЛНЕНИЕ РАЗМЕРА ЧТЕНИЯ ФАЙЛА МОЖЕТ ВЫЗВАТЬ ОШИБКУ
	;дописывание остальных данных в конец базы
	if $aBlocks<>"" Then
		FileWrite($hWrite,FileRead($hRead))
	EndIf




EndFunc



Func _CheckFiles_Arch($sPath,$HashDir,$DistDir='')
	if $DistDir='' then $DistDir = @YDAY & '_' & @HOUR & '-' & @MIN & '-' & @SEC
	DirCreate($HashDir & '\'& $DistDir)
	Dim $aHashesM,$aHashesL
	_FileReadToArray($HashDir & '\' & '_HashesM.txt', $aHashesM)
	_FileReadToArray($HashDir & '\' & '_HashesL.txt', $aHashesL)
	$hRead = FileOpen($sPath, 16+8)
	$hWriteBlocks=FileOpen($HashDir & '\'& $DistDir & '\' & 'Bloks.arch',16+1+8)
	$SizeFile = FileGetSize($sPath)
	Dim $aBlocks[$SizeFile/$bytesl+1]
	$indexblock=0
	$FileContentGeneral = ''

	;сравнение больших хеш сумм
	For $m=1 to $aHashesM[0] ; Floor($iSize/$bytesm)-1
		$FileContentM=FileRead($hRead, $bytesm)
		if $aHashesM[$m] <> _Crypt_HashData($FileContentM, $CALG_SHA1) Then
			;сравнение маленьких хеш суммы
			FileSetPos($hRead, $bytesm*($m-1), 0)
			$mstep = ($m-1)*($bytesm/$bytesl-1)
			For $l=1 to $bytesm/$bytesl-1
				$FileContentL=FileRead($hRead, $bytesl)
				if $FileContentL = '' then exitloop
				if $aHashesL[$l+$mstep] <> _Crypt_HashData($FileContentL, $CALG_SHA1) Then
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileContentL = ' & StringLeft($FileContentL,1000) & @CRLF) ;### Debug Console
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _Crypt_HashData($FileContentL, $CALG_SHA1) = ' & _Crypt_HashData($FileContentL, $CALG_SHA1) & @CRLF) ;### Debug Console
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesL[$l+$mstep] = ' & $aHashesL[$l+$mstep] & @CRLF) ;### Debug Console
;~ 					FileWrite($HashDir & "\" & $l+$mstep, $FileContentL)
;~ 					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $l+$mstep = ' & $l+$mstep & @CRLF) ;### Debug Console
					;Запись накопленных блоков
					if Mod($indexblock,100)=0 then
						FileWrite($hWriteBlocks,$FileContentGeneral)
						$FileContentGeneral = ''
					EndIf
					$FileContentGeneral &= BinaryToString($FileContentL)
					ConsoleWrite($indexblock&@CRLF)
					$aBlocks[$indexblock]=$l+$mstep
					$indexblock+=1
				EndIf
			Next
		EndIf
	Next

	;Запись оставщихся блоков
	FileWrite($hWriteBlocks,$FileContentGeneral)

	; корректировака пустых значений в конце массива
	$Dimens = Ubound($aBlocks)
	For $i = 1 to $Dimens-1
		if $aBlocks[$Dimens-$i] Then ExitLoop
	next
	Redim $aBlocks[$Dimens-($i-1)]

	_FileWriteFromArray($HashDir & '\'& $DistDir & '\' & 'InfoBloks.txt',$aBlocks)


Endfunc

Func _CreatHashFiles($sPath)
	$PatchResult = _PathSplitByRegExp($sPath,'', 2) & '\_' & _PathSplitByRegExp($sPath,'', 5)
	if not FileExists($PatchResult) then dircreate($PatchResult)
	$hRead = FileOpen($sPath, 16+8)
	$SizeFile = FileGetSize($sPath)
	Dim $aHashesM[Floor($iSize/$bytesm)+10]
	Dim $aHashesL[($iSize/$bytesl)+10]
	if $SizeFile <= 16777216 Then _Quite('Файл меньше 16 мегабайт, и использование программы не рекомендуеться')
	;создание больших хеш сумм
	For $m=0 to Floor($iSize/$bytesm)-1
		$FileContentM=FileRead($hRead, $bytesm)
		$aHashesM[$m] = _Crypt_HashData($FileContentM, $CALG_SHA1)
		;создание маленьких хеш суммы
		$mstep = $m*($bytesm/$bytesl-1)
		FileSetPos($hRead, $bytesm*($m), 0)
		For $l=0 to $bytesm/$bytesl-1
			$FileContentL=FileRead($hRead, $bytesl)
;~ 			if $FileContentL = '' then exitloop
			$aHashesL[$l+$mstep] = _Crypt_HashData($FileContentL, $CALG_SHA1)
		Next
	Next
	;обрабатываем остаток файла
	if Floor($iSize/$bytesm)<>$iSize/$bytesm Then
		$FileContentM=FileRead($hRead, Mod($iSize,$bytesm))
		$aHashesM[$m] = _Crypt_HashData($FileContentM, $CALG_SHA1)
		;создание маленьких хеш суммы
		$mstep = $m*($bytesm/$bytesl-1)
		FileSetPos($hRead, $bytesm*($m), 0)
; НЕОБХОДИМО ПОСТАВИТЬ КОСТЫЛЬ НА ВСЯКИЙ СЛУЧАЙ !!!
		if Mod(Mod($iSize,$bytesm),$bytesl) <> 0 Then _Quite('Файл 1С не подходит. Размер не кратен 4096')
		For $l=0 to Mod($iSize,$bytesm)/$bytesl-1
			$FileContentL=FileRead($hRead, $bytesl)
			$aHashesL[$l+$mstep] = _Crypt_HashData($FileContentL, $CALG_SHA1)
		Next
	Else
		ReDim $aHashesM[Ubound($aHashesM)-1]
		ReDim $aHashesL[Ubound($aHashesL)-1]
	EndIf

	; корректировака пустых значений в конце массива
	$Dimens = Ubound($aHashesM)
	For $i = 1 to $Dimens-1
		if $aHashesM[$Dimens-$i] Then ExitLoop
	next
	Redim $aHashesM[$Dimens-($i-1)]
	$Dimens = Ubound($aHashesL)
	For $i = 1 to $Dimens-1
		if $aHashesL[$Dimens-$i] Then ExitLoop
	next
	Redim $aHashesL[$Dimens-($i-1)]

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesM[Ubound($aHashesM)] = ' & $aHashesM[Ubound($aHashesM)-1] & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesL[Ubound($aHashesL)] = ' & $aHashesL[Ubound($aHashesL)-1] & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($aHashesL) = ' & Ubound($aHashesL) & @CRLF) ;### Debug Console
	_FileWriteFromArray($PatchResult & '\' & '_HashesM.txt',$aHashesM)
	_FileWriteFromArray($PatchResult & '\' & '_HashesL.txt',$aHashesL)

;~ 	$PatchResult

EndFunc

;~ $FileW= 'C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\'&$folder&'\'&StringRight('000000'&$WName+1,6)
;~ if FileExists($FileW) Then FileDelete($FileW)
;~ if Mod($iSize,$bytes)<>0 Then
;~ 	$hWrite = FileOpen($FileW, 16 + 2)
;~ 	FileSetPos($hRead, $bytes*($WName), 0)
;~ 	$xChunk = FileRead($hRead, $bytes)
;~ 	FileWrite($hWrite, $xChunk)
;~ EndIf

;~ Mod($iSize,$bytes)
;~ _Split_n($WName, 'C:\Users\Виталий.PROFF\Documents\1C\Platform8Demo\1\'&StringRight('000000'&$WName,6))
;~ $iSize/$bytes
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Mod($iSize,$bytes) = ' & Mod($iSize,$bytes) & @CRLF) ;### Debug Console
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $WName = ' & Round($iSize/$bytes)*$bytes-$iSize & @CRLF) ;### Debug Console

func _Quite($text='')
	if $text<>'' Then
		Msgbox(0,"Ошибка",$text)
	EndIf
	Exit
EndFunc

exit
Func _ComparefileHash($file1,$File2,$unicfile='')
	if not FileExists($file1) Then
		msgbox(0,'','file not exist '&$file1)
		return 0
	EndIf
	if not FileExists($File2) Then
		msgbox(0,'','file not exist '&$File2)
		return 0
	EndIf

_FileReadToArray($file1, $aHashes)
_FileReadToArray($File2, $aHashes2)
_ArrayConcatenate($aHashes,$aHashes2)
$OldUbound = Ubound($aHashes)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($aHashes) = ' & Ubound($aHashes) & @CRLF) ;### Debug Console
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($aHashes2) = ' & Ubound($aHashes2) & @CRLF) ;### Debug Console
$newHash = _ArrayUnique($aHashes)
;~ $OldUbound = Ubound(_ArrayUnique($aHashes2))
ConsoleWrite("$OldUbound="&$OldUbound&@CRLF)
$NewUbound = Ubound($newHash)
$Size = $OldUbound-$NewUbound
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $Size = ' & $Size & @CRLF) ;### Debug Console
;~ if $unicfile<>'' Then
;~ 	_FileWriteFromArray($unicfile,$newHash
return $Size
EndFunc

; Извлечение из файла части $n
Func _Split_n($n, $FileW='')
	if FileExists($FileW) Then FileDelete($FileW)
	if $bytes > $bytesStep Then
		$hWrite = FileOpen($FileW, 16 + 1)
		FileSetPos($hRead, $bytes*($n-1), 0)
		for $s=1 to Ceiling($steps)
			if $s=Ceiling($steps) Then
				$xChunk = FileRead($hRead, $bytes-($bytesStep*Floor($steps))) ; добавить не ровный шагу конец файла
			Else
				$xChunk = FileRead($hRead, $bytesStep)
			EndIf
			FileWrite($hWrite, $xChunk)
;~ 			if Mod ($s,10) = 0 then ConsoleWrite('|') ; Для наблюдения за ходом процесса
		next
	else ; На случай если файл меньше шага
		$hWrite = FileOpen($FileW, 16 + 2)
		FileSetPos($hRead, $bytes*($n-1), 0)
		$xChunk = FileRead($hRead, $bytes)
		FileWrite($hWrite, $xChunk)
	endif
	FileClose($hWrite)
EndFunc

Func _CreatHashFilesOld($sPath)
	$hRead = FileOpen($sPath, 16)
	$SizeFile = FileGetSize($sPath)
	Dim $aHashesM[Floor($iSize/$bytesm)+10]
	Dim $aHashesL[($iSize/$bytesl)+10]
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : ($iSize/$bytesl)+1 = ' & ($iSize/$bytesl)+1 & @CRLF) ;### Debug Console
	if $SizeFile <= 16777216 Then _Quite('Файл меньше 16 мегабайт, и использование программы не рекомендуеться')
	;создание больших хеш сумм
	$SizeM=Floor($iSize/$bytesm)-1
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Floor($iSize/$bytesm) = ' & Floor($iSize/$bytesm) & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iSize/$bytesm = ' & $iSize/$bytesm & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $iSize = ' & $iSize & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $SizeM = ' & $SizeM & @CRLF) ;### Debug Console
	For $m=0 to Floor($iSize/$bytesm)-1
		$FileContentM=FileRead($hRead, $bytesm)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileContentM = ' & Stringleft($FileContentM,1000) & @CRLF) ;### Debug Console
		$aHashesM[$m] = _Crypt_HashData($FileContentM, $CALG_SHA1)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesM[$m] = ' & $aHashesM[$m] & @CRLF) ;### Debug Console
		;создание маленьких хеш суммы
		FileSetPos($hRead, $bytesm*($m), 0)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $bytesm*($m-1) = ' & $bytesm*($m) & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : 0+$m*($bytesm/$bytesl-1) = ' & 0+$m*($bytesm/$bytesl-1) & @CRLF) ;### Debug Console
		For $l=0 to $bytesm/$bytesl-1
			$FileContentL=FileRead($hRead, $bytesl)
;~ 			if $FileContentL = '' then exitloop
			if $l<2 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileContentL = ' & Stringleft($FileContentL,1000) & @CRLF) ;### Debug Console
			if $aHashesL[$l+$m*($bytesm/$bytesl-1)] Then ConsoleWrite("$aHashesL[$l+$m*$SizeM] = "&$aHashesL[$l+$m*($bytesm/$bytesl-1)]&@CRLF)
			$aHashesL[$l+$m*($bytesm/$bytesl-1)] = _Crypt_HashData($FileContentL, $CALG_SHA1)
		Next
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesL[1] = ' & $aHashesL[1] & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileContentL = ' & Stringleft($FileContentL,1000) & @CRLF)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileRead($hRead, 1) = ' & FileRead($hRead, 1) & @CRLF) ;### Debug Console
	Next
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $m = ' & $m & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileGetPos($hRead) = ' & FileGetPos($hRead) & @CRLF) ;### Debug Console
	;обрабатываем остаток файла
	if Floor($iSize/$bytesm)<>$iSize/$bytesm Then
;~ 		ConsoleWrite('Остаточный размер ' & Mod($iSize,$bytesm) & @CRLF)
		$FileContentM=FileRead($hRead, Mod($iSize,$bytesm))
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileContentM = ' & Stringleft($FileContentM,1000) & @CRLF) ;### Debug Console
		$aHashesM[$m] = _Crypt_HashData($FileContentM, $CALG_SHA1)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesM[$m] = ' & $aHashesM[$m] & @CRLF) ;### Debug Console
		;создание маленьких хеш суммы
		FileSetPos($hRead, $bytesm*($m), 0)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $bytesm*($m) = ' & $bytesm*($m) & @CRLF) ;### Debug Console
; НЕОБХОДИМО ПОСТАВИТЬ КОСТЫЛЬ НА ВСЯКИЙ СЛУЧАЙ !!!
		if Mod(Mod($iSize,$bytesm),$bytesl) <> 0 Then _Quite('Файл 1С не подходит. Размер не кратен 4096')
					ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : 0+$m*($bytesm/$bytesl-1) = ' & 0+$m*($bytesm/$bytesl-1) & @CRLF) ;### Debug Console
		For $l=0 to Mod($iSize,$bytesm)/$bytesl-1
			$FileContentL=FileRead($hRead, $bytesl)
			if $l<3 then ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileContentL = ' & Stringleft($FileContentL,1000) & @CRLF) ;### Debug Console
			if $l+$m*($bytesm/$bytesl-1) > 10495 then
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileContentL = ' & Stringleft($FileContentL,1000) & @CRLF)
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : 0+$m*($bytesm/$bytesl-1) = ' & $l+$m*($bytesm/$bytesl-1) & @CRLF) ;### Debug Console
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $bytesm/$bytesl-1 = ' & $bytesm/$bytesl-1 & @CRLF) ;### Debug Console
				ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $l = ' & $l & @CRLF) ;### Debug Console
			EndIf
			;~ 			if $aHashesL[$l+$m*$SizeM] Then ConsoleWrite("$aHashesL[$l+$m*$SizeM] = "&$aHashesL[$l+$m*$SizeM]&@CRLF)
			$aHashesL[$l+$m*($bytesm/$bytesl-1)] = _Crypt_HashData($FileContentL, $CALG_SHA1)

		Next
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesL[1] = ' & $aHashesL[1] & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $FileContentL = ' & Stringleft($FileContentL,1000) & @CRLF)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : FileRead($hRead, 1) = ' & FileRead($hRead, 1) & @CRLF) ;### Debug Console
	Else
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesM[Ubound($aHashesM)] = ' & $aHashesM[Ubound($aHashesM)-1] & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesL[Ubound($aHashesL)] = ' & $aHashesL[Ubound($aHashesL)-1] & @CRLF) ;### Debug Console
		ReDim $aHashesM[Ubound($aHashesM)-1]
		ReDim $aHashesL[Ubound($aHashesL)-1]
	EndIf

	; корректировака пустых значений в конце массива
	$Dimens = Ubound($aHashesM)
	For $i = 1 to $Dimens-1
		if $aHashesM[$Dimens-$i] Then ExitLoop
	next
	Redim $aHashesM[$Dimens-($i-1)]
	$Dimens = Ubound($aHashesL)
	For $i = 1 to $Dimens-1
		if $aHashesL[$Dimens-$i] Then ExitLoop
	next
	Redim $aHashesL[$Dimens-($i-1)]

	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesM[Ubound($aHashesM)] = ' & $aHashesM[Ubound($aHashesM)-1] & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $aHashesL[Ubound($aHashesL)] = ' & $aHashesL[Ubound($aHashesL)-1] & @CRLF) ;### Debug Console
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Ubound($aHashesL) = ' & Ubound($aHashesL) & @CRLF) ;### Debug Console


;~ 	$PatchResult

EndFunc

Exit
global $NumberSplits = 100, $aMemoryImage, $Struct, $NumTables=0
Dim $aMemoryImage[$NumberSplits+1][10] ; массив для хранения информации для сравнения. Вторая размерность массива [10] - максимальное число сравнений

$title='Виталий'
$title=WinGetHandle($title)
$keysleep = 64
$StepSleep = 1000
$aPasswords = 'string'

ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _CompareImageWin($title,0) = ' & _CompareImageWin($title,0) & @CRLF) ;### Debug Console


WinActivate($title)

Sleep($StepSleep)
	Clipput($aPasswords)
	Send('+{Ins}')
	sleep($StepSleep)
ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _CompareImageWin($title,0) = ' & _CompareImageWin($title,0) & @CRLF) ;### Debug Console
;~ While 1
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _CompareImageWin($title,1) = ' & _CompareImageWin($title,1) & @CRLF) ;### Debug Console
;~ 	sleep($StepSleep)
;~ Wend

Func _CompareImageWin($hWnd,$mod=-1)
	$IndexCompare=0
	$posWin = WinGetPos($hwnd)

	;генерируем строку для создание структуры
	if not $Struct Then
		$Struct = ''
		For $i=1 to $NumberSplits
			$Struct &= 'byte[' & Ceiling(($posWin[2] * $posWin[3] * 4)/$NumberSplits) & '];'
		Next
		$Struct &= 'byte[' & ($posWin[2] * $posWin[3] * 4)-Ceiling(($posWin[2] * $posWin[3] * 4)/$NumberSplits)*($NumberSplits-1) & ']'
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen($Struct) = ' & StringLen($Struct) & @CRLF) ;### Debug Console
	EndIf

	;цикл поиска/сравнения
	_GDIPlus_Startup()
	$hBitmap = _GDIPlus_BitmapCreateFromHBITMAP(_WinCapture($hWnd, $posWin[2], $posWin[3]))
	$tMap = _GDIPlus_BitmapLockBits($hBitmap, 0, 0, $posWin[2], $posWin[3], $GDIP_ILMREAD, $GDIP_PXF32ARGB)
	$tData = DllStructCreate($Struct, DllStructGetData($tMap, 'Scan0'))
	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : DllStructGetData($tData, $i) = ' & StringLeft(DllStructGetData($tData, 2),1000) & @CRLF) ;### Debug Console

;~ 	; проверка на пустое возвращение
;~ 	For $i = 1 To 3
;~ 		$tempData = StringLeft(DllStructGetData($tData, $i),1000)
;~ 		$timer = Timerinit()
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen(DllStructGetData($tData, $i)) = ' & StringLen($tempData) & @CRLF) ;### Debug Console

;~ 		ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : TimerDiff($timer)1 = ' & TimerDiff($timer) & @CRLF) ;### Debug Console
;~ 		$timer = Timerinit()
;~ 		$tempData=StringReplace($tempData,'000000',"")
;~ 		$tempData=StringReplace($tempData,'FF',"")
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : StringLen(DllStructGetData($tData, $i)) = ' & StringLen($tempData) & @CRLF) ;### Debug Console
;~ 		ConsoleWrite('@@ Debug(' & @MIN&@SEC & ') : TimerDiff($timer)2 = ' & TimerDiff($timer) & @CRLF) ;### Debug Console

;~ 	Next
	if $mod = 0 then
		$test=0
		For $i = 1 To $NumberSplits ; Заполняем таблицу уникальными данными
			$tempData = DllStructGetData($tData, $i)
			if $aMemoryImage[$i][0] <> $tempData Then
				$aMemoryImage[$i][$NumTables] = $tempData
				$test+=1
			EndIf
		Next
		if $test<>0 Then $NumTables +=1
;~ 			ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $test = ' & $test & @CRLF) ;### Debug Console
	Else
		For $i = 1 To $NumberSplits
			$test=0
			For $j = 0 to $NumTables
				if $aMemoryImage[$i][$j] Then ;Если ячейка заполнена, то сравниваем
					if $aMemoryImage[$i][$j] <> DllStructGetData($tData, $i) Then $test += 1
					$test-=1
				EndIf
			Next
			if $test=0 Then $IndexCompare += 1
		Next
;~ 		_ArrayDisplay($aMemoryImage)
	EndIf
	_GDIPlus_BitmapUnlockBits($hBitmap, $tMap)
	_GDIPlus_BitmapDispose($hBitmap)
	_GDIPlus_Shutdown()

	$IndexCompare = 100*$IndexCompare/$NumberSplits
	return $IndexCompare
EndFunc

Func _WinCapture($hWnd, $iWidth = -1, $iHeight = -1)
    Local $iH, $iW, $hDDC, $hCDC, $hBMP
    If $iWidth = -1 Then $iWidth = _WinAPI_GetWindowWidth($hWnd)
    If $iHeight = -1 Then $iHeight = _WinAPI_GetWindowHeight($hWnd)
    $hDDC = _WinAPI_GetDC($hWnd)
    $hCDC = _WinAPI_CreateCompatibleDC($hDDC)
    $hBMP = _WinAPI_CreateCompatibleBitmap($hDDC, $iWidth, $iHeight)
    _WinAPI_SelectObject($hCDC, $hBMP)
    DllCall("User32.dll", "int", "PrintWindow", "hwnd", $hWnd, "hwnd", $hCDC, "int", 0)
    _WinAPI_ReleaseDC($hWnd, $hDDC)
    _WinAPI_DeleteDC($hCDC)
    Return $hBMP
EndFunc   ;==>_WinCapture

Func _PathSplitByRegExp($sPath,$pDelim='', $mod=-1)
    If $sPath = "" Or (StringInStr($sPath, "\") And StringInStr($sPath, "/")) Then Return SetError(1, 0, -1)

    Local $aRetArray[8] ;, $pDelim = ""

    If StringRegExp($sPath, '^(?i)([A-Z]:|\\)(\\[^\\]+)+$') Then $pDelim = "\"
    If StringRegExp($sPath, '(?i)(^.*:/)(/[^/]+)+$') Then $pDelim = "//"

    If $pDelim = "" Then $pDelim = "/"
    If Not StringInStr($sPath, $pDelim) Then Return $sPath
    If $pDelim = "\" Then $pDelim &= "\"

;~     $pDelim = "/"
	if $mod >= 0 Then
		Switch $mod
			Case 0
				return $sPath
			Case 1
				return StringRegExpReplace($sPath,  $pDelim & '.*', $pDelim) ;Drive letter
			Case 2
				return StringRegExpReplace($sPath, $pDelim & '[^' & $pDelim & ']*$', '') ;Path without FileName and extension
			Case 3
				return StringRegExpReplace($sPath, '\.[^.]*$', '') ;Full path without File Extension
			Case 4
				return StringRegExpReplace($sPath, '(?i)([A-Z]:' & $pDelim & ')', '') ;Full path without drive letter
			Case 5
				return StringRegExpReplace($sPath, '^.*' & $pDelim, '') ;FileName and extension
			Case 6
				return StringRegExpReplace($sPath, '.*' & $pDelim & '|\.[^.]*$', '') ;Just Filename
			Case 7
				return StringRegExpReplace($sPath, '^.*\.', '') ;Just Extension of a file
		EndSwitch
	EndIf

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