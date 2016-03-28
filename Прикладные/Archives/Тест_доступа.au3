#include <File.au3>
#include <array.au3>
#include <WinAPIProc.au3>
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

If @ComputerName<>"ServerAD" Then
	MsgBox(0,"Имя Вашего компьютера: "&@ComputerName,'Пожалуйста запустите программу на Сервере, откройте ярлык "ServerAD.rdp". Затем найдите и откройте программу уже там.')
	Exit
EndIf


if $cmdline[0]>0 and $cmdline[1]='runas' Then
	$user = _WinAPI_GetProcessUser (@AutoItPID)
	TrayTip('Подсказка',' Програма запущена от имени пользователя: '&$user[0] & @CRLF & 'Пожалуйста дождитесь окончания работы и появления окна результатов',5000)
Else
	Local $sUserName = "Username"
	Local $sPassword = "Password"

	#Region ### START Koda GUI section ### Form=
	$Form1 = GUICreate("Form1", 242, 215, 190, 125)
	$Label1 = GUICtrlCreateLabel("Выбор группы пользователей для проверки:", 8, 8, 231, 17)
	$Radio1 = GUICtrlCreateRadio("Дизайнеры", 8, 32, 113, 17)
	$Radio2 = GUICtrlCreateRadio("Констрктор-технолог", 8, 56, 161, 17)
	$Radio3 = GUICtrlCreateRadio("Нормировщик", 8, 80, 113, 17)
	$Radio4 = GUICtrlCreateRadio("Специалист по ЧПУ", 8, 104, 129, 17)
	$Radio5 = GUICtrlCreateRadio("Модельщик", 8, 128, 113, 17)
	$Button1 = GUICtrlCreateButton("Начать", 80, 176, 83, 25)
	$Radio6 = GUICtrlCreateRadio("Тестовый(без прав на запись)", 8, 152, 177, 17)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###

	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit

			Case $Form1
			Case $Form1
				Case $Form1
			Case $Form1
			Case $Label1
			Case $Radio1
				$sUserName = "Mitkins"
				$sPassword = "Mit301199"
			Case $Radio2
				$sUserName = "Konstruktor2"
				$sPassword = "Kon687476"
			Case $Radio3
				$sUserName = "NikiforovA"
				$sPassword = "Nik618317"
			Case $Radio4
				$sUserName = "Murtazinr"
				$sPassword = "Mur196812"
			Case $Radio5
				$sUserName = "Chernoguzovs"
				$sPassword = "Che317859"
			Case $Radio6
				$sUserName = "Тестовый"
				$sPassword = "Proff123"
			Case $Button1
				ExitLoop
		EndSwitch
	WEnd

;~ 	MsgBox(0,'',$sUserName&' '& @ComputerName&' '& $sPassword&' '& 0&' '& @AutoItExe&' runas'&' '&@ScriptDir)
	; Run a command prompt as the other user.
	RunAs($sUserName, "MAF", $sPassword, 0, @AutoItExe&' runas',@ScriptDir)
	if @error Then MsgBox(0,'Ощибка','Запустить программу из под пользователя '&$sUserName&' не удалось.',10)
;~ 	sleep(2000)
	exit
EndIf

;~ 182048940


$path = 'D:\Public'
;~ $input = InputBox('Изменение пути',""
global $_patch = FileSelectFolder('Выберите папку для проверки доступа в ней',$path,4,$path)
if $_patch = '' then exit
;~ TrayTip('Подсказка',' Програма запущена от имени пользователя: '&$user[0] & @CRLF & 'Пожалуйста дождитесь окончания работы и появления окна результатов',5000)
ToolTip($user[0]&' - Пожалуйста дождитесь окончания работы и появления окна результатов')

$aDirs = _FileListToArrayRec($path, "", $FLTAR_FILESFOLDERS, $FLTAR_RECUR, $FLTAR_SORT)

local $aDirsAcc[$aDirs[0]+1][2]
$name = 'Тестовый файл для проверки.txt'

For $i = 1 to $aDirs[0]

	$f = 0
	$aDirsAcc[$i][0] = $aDirs[$i]
		;тест права на чтение
	$ff = FileFindFirstFile ($aDirs[$i] & '\*.*')
	if @error <> 1 and $ff = -1 Then
		$f-=100
	Else
		;тест права на запись
		$h = FileOpen($aDirs[$i]&'\'&$name, 1)
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $h = ' & $h &  @CRLF) ;### Debug Console
		$f += $h
		FileClose($h)
		if FileExists($aDirs[$i]&'\'&$name) Then
			$d = FileDelete($aDirs[$i]&'\'&$name)
			if $f=-1 then $f&=' ERROR'
			if $d=0 then
				FileRecycle ($aDirs[$i]&'\'&$name)
				DirRemove($aDirs[$i]&'\'&$name,1)
				$f&=' DELETE ERROR'
			EndIf
		Else
			$f-=0.5
		EndIf
	EndIf




	$aDirsAcc[$i][1] = $f
Next
ToolTip('')
_ArrayDisplay($aDirsAcc)