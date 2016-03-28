#RequireAdmin
#include <Process.au3>
#include <array.au3>
#include <Encoding.au3>

;Определяем наличие двух сетевых карт
;~ $scetchik=0
;~ for $i=1 to 3
;~ 	$Localip = Execute('@IPAddress'&$i)
;~ 	if $Localip = '0.0.0.0' then $scetchik+=1
;~ Next
;~ if $scetchik<>2 then


$iTempFile = @TempDir & '\NetInfo.txt'
RunWait(@ComSpec & ' /C netsh interface ip show config >> ' & $iTempFile, '', @SW_HIDE)
$NetInfoContents = FileRead($iTempFile)
if StringInStr($NetInfoContents,'Подключение по локальной сети')=0 then $NetInfoContents =_Encoding_866To1251($NetInfoContents)
$CountInt = StringSplit ( $NetInfoContents, "Подключение по локальной сети",1)
if $CountInt[0]-1=0 then
	MsgBox(0,"Сообщение",'Подключение по локальной сети не найденно!')
	Exit
EndIf
$iReg = StringRegExp($NetInfoContents, '(?s)"Подключение по локальной сети.*?(\d{2,3}\.\d{2,3}\.\d{1,3}\.\d{1,3}).*?"', 3)
;~ _ArrayDisplay($iReg)

; Сам алоритм сохранения, восстановления настроек
if stringinstr($iReg[0],'192.168.1.')<>0 and $iReg[0]<>'127.0.0.1' Then
	;Сохраняем старые настройки в файл
	$sNameSet = "1.config" ; файл настроек адаптера
	$sSaveSet = "netsh dump>"&$sNameSet
	$sLoadSet = "netsh exec "&$sNameSet
	_RunDOS($sSaveSet) ; сохранить настройки
		;_RunDOS($sLoadSet) ; загрузить настройки

	; определяем свободный ип адрес в локальной сети
	for $FreeIP=250 to 2 step -1
		if ping('192.168.1.'&$FreeIP,500) = 0 Then ExitLoop
	Next
	;Изменяем нужные настройки
	$ipaddres = '192.168.1.'&$FreeIP
	$subnetmask = '255.255.255.0'
	$gateway = '192.168.1.1'
	$dns = '78.140.0.254'
	$nameInterface = '"Подключение по локальной сети"'
	$t = Run(@ComSpec & ' /c ' & 'netsh interface ip set address '&$nameInterface&' static '&$ipaddres&' '&$subnetmask&' '&$gateway&' 1', '', @SW_HIDE)
	$t = Run(@ComSpec & ' /c ' & 'netsh interface ip set dns '&$nameInterface&' static '&$dns, '', @SW_HIDE)
	MsgBox(0,"Сообщение",'Насройки подключения изменены!',5)
else if $iReg[0]<>'127.0.0.1' and FileExists(@ScriptDir&"\1.config")
	$sNameSet = "1.config" ; файл настроек адаптера
	$sSaveSet = "netsh dump>"&$sNameSet
	$sLoadSet = "netsh exec "&$sNameSet
	;_RunDOS($sSaveSet) ; сохранить настройки
	_RunDOS($sLoadSet) ; загрузить настройки
	MsgBox(0,"Сообщение",'Насройки подключения восстановленны!',5)
Else
	MsgBox(0,"Ошибка",'Ошибка. Насройки подключения неопределены!')
EndIf


