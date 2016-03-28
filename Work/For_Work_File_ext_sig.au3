#include <File.au3>
Global $ext, $schet=0, $sSrc_Dir, $ExtTrue, $schetPravilnyhFailov=0, $FileSignDetected[69], $schetFailov=0, $schetIspravlenyhFailov=0
global $NewExtensions=0

#region FILE SIGNATURES - EXTENSIONS TABLE
;из программы chkpraser
;~ Global $FileSign[69][2]=[['jpg','0xFFD8FF'],['png','0x89504E470D0A1A0A'],['gif','GIF8'],['tif','0x49492A00'],['tif','0x4D4D002A'],['bmp','BM'],['art','0x4A47040E000000'],['art','0x4A47030E000000'],['pcx','0x0A050108'],['psp','0x5061696E74205368'],['psp','0x7E424B00'],['psd','0x3842505300010000'],['wmf','0xD7CDC69A'],['wmf','0x01000900'],['wmf','0x02000900'],['emf','0x0100000058000000'],['cpt','CPTFILE'],['dwg','0x41433130'],['rtf','{\rtf'],['xml','<?xml'],['html','<html>'],['html','<HTML>'],['html','<!doctype'],['html','<!DOCTYPE'],['eml','Delivery-date:'],['dbx','0xCFAD12FE'],['pst','!BDN'],['doc','0xD0CF11E0A1B11AE1'],['mny','0x000100004D534953'],['wpd','0xFF575043'],['eps','%!PS-Adobe'],['fm','<MakerFile'],['pdf','%PDF-1.'],['qdf','0xAC9EBD8F'],['qbb','0x458600000600'],['lwp','0x576F726450726F'],['AMI','0x5B7665725D'],['123','0x00001A00051004'],['wk4','0x00001A0002100400'],['wk3','0x00001A0000100400'],['wk1','0x2000604060'],['nsf','0x1A0000030000'],['pwl','0xE3828596'],['zip','0x504B0304'],['zip','0x504B3030'],['jar','0x5F27A889'],['rar','Rar!'],['gz','0x1F8B08'],['bz2','BZh'],['arj','0x60EA'],['7z','7zјЇ'],['zoo','0x5A4F4F20'],['rpm','0xEDABEEDB'],['ram','.ra'],['rm','.RMF'],['mpg','0x000001BA'],['mpg','0x000001B3'],['asf','0x3026B2758E66CF11'],['mid','MThd'],['chm','0x4954534603000000'],['hlp','0x3F5F0300'],['hlp','0x4C4E0200'],['exe','MZ'],['elf','0x7F454C4601010100'],['sh','#!/usr/bin/'],['sh','#!/bin/'],['_fat','0x2E202020202020202020201000'],['scn','RStudioScan'],['mov','pnot']]
;~ Global $FileSign[69][2]=[['jpg','0xFFD8FF'],['png','0x89504E470D0A1A0A'],['gif','0x47494638'],['tif','0x49492A00'],['tif','0x4D4D002A'],['bmp','0x424D'],['art','0x4A47040E000000'],['art','0x4A47030E000000'],['pcx','0x0A050108'],['psp','0x5061696E74205368'],['psp','0x7E424B00'],['psd','0x3842505300010000'],['wmf','0xD7CDC69A'],['wmf','0x01000900'],['wmf','0x02000900'],['emf','0x0100000058000000'],['cpt','0x43505446494C45'],['dwg','0x41433130'],['rtf','0x7B5C727466'],['xml','0x3C3F786D6C'],['html','0x3C68746D6C3E'],['html','0x3C48544D4C3E'],['html','0x3C21646F6374797065'],['html','0x3C21444F4354595045'],['eml','0x44656C69766572792D646174653A'],['dbx','0xCFAD12FE'],['pst','0x2142444E'],['doc','0xD0CF11E0A1B11AE1'],['mny','0x000100004D534953'],['wpd','0xFF575043'],['eps','0x252150532D41646F6265'],['fm','0x3C4D616B657246696C65'],['pdf','0x255044462D312E'],['qdf','0xAC9EBD8F'],['qbb','0x458600000600'],['lwp','0x576F726450726F'],['AMI','0x5B7665725D'],['123','0x00001A00051004'],['wk4','0x00001A0002100400'],['wk3','0x00001A0000100400'],['wk1','0x2000604060'],['nsf','0x1A0000030000'],['pwl','0xE3828596'],['zip','0x504B0304'],['zip','0x504B3030'],['jar','0x5F27A889'],['rar','0x52617221'],['gz','0x1F8B08'],['bz2','0x425A68'],['arj','0x60EA'],['7z','0x377ABCAF27'],['zoo','0x5A4F4F20'],['rpm','0xEDABEEDB'],['ram','0x2E7261'],['rm','0x2E524D46'],['mpg','0x000001BA'],['mpg','0x000001B3'],['asf','0x3026B2758E66CF11'],['mid','0x4D546864'],['chm','0x4954534603000000'],['hlp','0x3F5F0300'],['hlp','0x4C4E0200'],['exe','0x4D5A'],['elf','0x7F454C4601010100'],['sh','0x23212F7573722F62696E2F'],['sh','0x23212F62696E2F'],['_fat','0x2E202020202020202020201000'],['scn','0x5253747564696F5363616E'],['mov','0xFFD8FF']]
Global $FileSign[69][2]=[['jpg','FFD8FF'],['png','89504E470D0A1A0A'],['gif','47494638'],['tif','49492A00'],['tif','4D4D002A'],['bmp','424D'],['art','4A47040E000000'],['art','4A47030E000000'],['pcx','0A050108'],['psp','5061696E74205368'],['psp','7E424B00'],['psd','3842505300010000'],['wmf','D7CDC69A'],['wmf','01000900'],['wmf','02000900'],['emf','0100000058000000'],['cpt','43505446494C45'],['dwg','41433130'],['rtf','7B5C727466'],['xml','3C3F786D6C'],['html','3C68746D6C3E'],['html','3C48544D4C3E'],['html','3C21646F6374797065'],['html','3C21444F4354595045'],['eml','44656C69766572792D646174653A'],['dbx','CFAD12FE'],['pst','2142444E'],['doc','D0CF11E0A1B11AE1'],['mny','000100004D534953'],['wpd','FF575043'],['eps','252150532D41646F6265'],['fm','3C4D616B657246696C65'],['pdf','255044462D312E'],['qdf','AC9EBD8F'],['qbb','458600000600'],['lwp','576F726450726F'],['AMI','5B7665725D'],['123','00001A00051004'],['wk4','00001A0002100400'],['wk3','00001A0000100400'],['wk1','2000604060'],['nsf','1A0000030000'],['pwl','E3828596'],['zip','504B0304'],['zip','504B3030'],['jar','5F27A889'],['rar','52617221'],['gz','1F8B08'],['bz2','425A68'],['arj','60EA'],['7z','377ABCAF27'],['zoo','5A4F4F20'],['rpm','EDABEEDB'],['ram','2E7261'],['rm','2E524D46'],['mpg','000001BA'],['mpg','000001B3'],['asf','3026B2758E66CF11'],['mid','4D546864'],['chm','4954534603000000'],['hlp','3F5F0300'],['hlp','4C4E0200'],['exe','4D5A'],['elf','7F454C4601010100'],['sh','23212F7573722F62696E2F'],['sh','23212F62696E2F'],['_fat','2E202020202020202020201000'],['scn','5253747564696F5363616E'],['mov','FFD8FF']]

#endregion FILE SIGNATURES - EXTENSIONS TABLE



$sPath = FileSelectFolder('Выберите директорию для обработки', '', 1 + 2 + 4, 'd:\prog\test\')
If @error Then
MsgBox(4096, "Ошибка", "Ни один из файлов или каталогов не соответствует маске поиска")
Exit
endif

_vypolnenie($sPath)

ConsoleWrite(' Задание завершено, количество подтвержденных фалов = ' & $schetPravilnyhFailov & @CRLF & 'Общее количество файлов = ' & $schetFailov & @CRLF & 'количество исправленных файлов = ' & $schetIspravlenyhFailov )

Func _vypolnenie($sSrc_Dir)

    Local $iRet_Extended = 0, $sRegExp_Filter, $hSearch, $sFile_Path, $sFile_Name
    Local $iSrc_FileTime, $iDst_FileTime


	; Скрипт показывает имена всех файлов и каталогов в указанной директории.
	$hSearch = FileFindFirstFile($sSrc_Dir & '\*') ; возвращает дескриптор поиска, определяющий путь и маску

	; Проверка, является ли поиск успешным
	If $hSearch = -1 Then
		MsgBox(4096, "Ошибка", "Ни один из файлов или каталогов не соответствует маске поиска")
		Exit
	EndIf


		While 1
			$sFile_Name = FileFindNextFile($hSearch)
			If @error Then ExitLoop

			$sFile_Path = $sSrc_Dir & "\" & $sFile_Name

			;Условие папка, непапка - тогда выполнять
			If StringInStr(FileGetAttrib($sFile_Path), "D") > 0 Then
				_vypolnenie($sFile_Path)
				$iRet_Extended += @extended
			Else
			   $schetFailov=$schetFailov+1
			   ;условие подходит под искомое разширение или нет
			   $ext = _ExtDefine($sFile_Name)
			   $ExtTrue=0
			   for $i=0 to Ubound($FileSign)-1
				  If $ext = $FileSign[$i][0] then $ExtTrue=1
			   Next
				  
			   ;Действие на отсутствие расширения
			   if $ext = '' then 
				  ConsoleWrite('найдеен файл без расширения' & @CRLF)
					 
					 ;цикл сравнивания
					 For $i=0 to Ubound($FileSign)-1			 					 
						;поиск по HEX
						If StringInStr(Hex(Binary($Texto)), $FileSign[$i][1]) > 0 then 
						   ConsoleWrite($FileSign[$i][0] & '          ')
						   $FileSignDetected[$i]=$FileSign[$i][0] ;массив подходящих разширений
						EndIf	
					 next
					 
						$NewExtensions=0
						for $i=0 to Ubound($FileSignDetected)-1
						   if $FileSignDetected[0]<>0 Then
							  if $NewExtensions=0 Then
								 $NewExtensions= $FileSignDetected[0]
							  Else
								 $NewExtensions = $NewExtensions & '|' & $FileSignDetected[0]
							  EndIf
						   EndIf  
						next
						
						If $NewExtensions=0 then
						   $sNewFileName= 'DELETE '& $sFile_Name
						   FileMove($sFile_Path, StringRegExpReplace($sFile_Path, "\\[^\\]*$", "\\") & $sNewFileName)
						   $schetIspravlenyhFailov=$schetIspravlenyhFailov+1
						Else
						   if StringInStr($NewExtensions, '|') > 0 Then
							  $sNewFileName= 'RENAME('&$NewExtensions&') '& $sFile_Name
							  FileMove($sFile_Path, StringRegExpReplace($sFile_Path, "\\[^\\]*$", "\\") & $sNewFileName)
							  $schetIspravlenyhFailov=$schetIspravlenyhFailov+1								 
						   Else
							  $sNewFileName= $sFile_Name & '.' & $NewExtensions
							  FileMove($sFile_Path, StringRegExpReplace($sFile_Path, "\\[^\\]*$", "\\") & $sNewFileName)
							  $schetIspravlenyhFailov=$schetIspravlenyhFailov+1	
						   EndIf	   
						EndIf  
			  
			   EndIf
			   
				  
			   ;Действие на имеющиеся в базе расширение
			   if $ExtTrue=1 then
			   
				   $Texto = FileRead($sFile_Path, 15)
				   for $i=0 to Ubound($FileSignDetected)-1
				   $FileSignDetected[$i]=0
				   next
					 ;цикл сравнивания
					 For $i=0 to Ubound($FileSign)-1

						;поиск по HEX
						If StringInStr(Hex(Binary($Texto)), $FileSign[$i][1]) > 0 then 
						   ConsoleWrite($FileSign[$i][0] & '          ')
						   $FileSignDetected[$i]=$FileSign[$i][0] ;массив подходящих разширений
						   if $ext = $FileSign[$i][0] Then 
							  $ExtTrue=2 ; 2 значит разширение подтверждено
							  $schetPravilnyhFailov=$schetPravilnyhFailov+1
						   EndIf
						EndIf
					 next
					 
					 ;исключение файлов уже исправленных
					 if StringInStr($sFile_Name, "RENAME", 1) > 0  OR StringInStr($sFile_Name, "DELETE", 1) > 0 then $ExtTrue=2 
					 
					 ;принятие решения на счёт файла
					 if $ExtTrue<>2 then ;если разширение не подтвержденно
						
						;поиск найденно ли какое ни будь разширение в файле
						$NewExtensions=0
						for $i=0 to Ubound($FileSignDetected)-1
						   if $FileSignDetected[0]<>0 Then
							  if $NewExtensions=0 Then
								 $NewExtensions= $FileSignDetected[0]
							  Else
								 $NewExtensions = $NewExtensions & '|' & $FileSignDetected[0]
							  EndIf
						   EndIf  
						next
						;переименование файла в случае если было обнаруженно другое разширение файла
						if $NewExtensions<>0 then 
						   $sNewFileName= 'RENAME('&$NewExtensions&') '& $sFile_Name
						   FileMove($sFile_Path, StringRegExpReplace($sFile_Path, "\\[^\\]*$", "\\") & $sNewFileName)
						   $schetIspravlenyhFailov=$schetIspravlenyhFailov+1
						Else
						   ;если другого расширения не найденно пометить файл на удаление
						   $sNewFileName= 'DELETE '& $sFile_Name
						   FileMove($sFile_Path, StringRegExpReplace($sFile_Path, "\\[^\\]*$", "\\") & $sNewFileName)
						   $schetIspravlenyhFailov=$schetIspravlenyhFailov+1
						EndIf
						
						
					 EndIf
					 
					   $tooltip=Binary( $Texto)
					   If @error = 1 Then MsgBox(0,'','@error = 1')
   ;~ 				If StringInStr(Hex(Binary($Texto)), "D0CF11E0A1B11AE1") > 0 Then
				   $schet=$schet+1
				   ConsoleWrite($schet & '   ' & 'Файл или каталог: ' & $sFile_Name & '    ' & 'Путь: ' & $sFile_Path &  ' расширение: ' &  $ext& @CRLF)
				Else
				   ;если не подходит искомое разширение
				EndIf
			EndIf
		WEnd

	; Закрывает дескриптор поиска
	FileClose($hSearch)

EndFunc



;;; Function for determination of file extension
Func _ExtDefine($file)
    If StringInStr($file, '\') Then
        $aFile = StringSplit($file, '\')
        $file = $aFile[$aFile[0]]
    EndIf
    If Not StringInStr($file, '.') Then Return ''
    $aFile = StringSplit($file, '.')
    Return $aFile[$aFile[0]]
EndFunc




	;~ While 1
	;~     $sFile = FileFindNextFile($hSearch) ; возвращает следующий файл, начиная от первого до последнего
	;~     If @error Then ExitLoop

;~ 			$ext = _ExtDefine($sFile)
;~ 			$schet=$schet+1
;~ 			ConsoleWrite($schet & '   ' & 'Файл или каталог: ' & $sFile & '    ' & 'Путь: ' & $sPath & '\' & $sFile &@CRLF)

	;~ WEnd