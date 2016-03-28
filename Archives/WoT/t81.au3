#include <array.au3>
#include <WinAPIEx.au3>
#include <PixelsearchEx.au3>
HotKeySet("{Esc}", "_Quit") ;Это вызов
;~ HotKeySet("{ins}", "_pixelSearchSpeed") ;Это вызов
$sFile = @ScriptDir & "\DB\" & 'User.dat'
$sFile = "D:\Мультимедиа\5 чувств страха.2013. WEB-DLRip.avi"
Global $timeConnect = TimerInit(), $turn = 1, $stop = 0, $TimeOutTurn = 0

;~ _MD5ForFile($sFile)
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : Подключился к FTP. Время подключения (в мс) = ' & TimerDiff($timeConnect) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ 	$controlID='[CLASS:Button; INSTANCE:1]'
;~ 	While 1
;~ 		ControlClick(0x00CC0008,'',$controlID)

;~ 	Opt("PixelCoordMode", 2) ;1=абсолютные, 0=относительные, 2=клиентские
;~ 	$hwnd = WinGetHandle('WoT Client')
;~ 	WinActivate($hwnd)
;~ $i = 0
;~ While 1
;~ 	_pixelSearchSpeed()
;~ 	_turn()
;~ 	Sleep(1000 + $i)
;~ 	$i += 1000
;~ 	sleep(100)
;~ WEnd






Global $turn = 1, $stop = 0, $TimeOutTurn = 0
#include <Constants.au3>
ProcessClose('Bot_WOT_s.exe')
$path = @ScriptDir & "\Bot_WOT_s.exe"
#include <array.au3>

Global $turn = 1, $stop = 0, $TimeOutTurn = 0

_stopdetect()

Func _stopdetect()
	Opt("PixelCoordMode", 2) ;1=абсолютные, 0=относительные, 2=клиентские
	$hwnd = WinGetHandle('WoT Client')
	WinActivate($hwnd)
	Sleep(500)
	$shade = 25
	$shade2 = 3
	$SCHET = 0
	$NoLifeSchet=0
	$NoLifeSchet0=0
	local $NoLifeTime, $NoLifeTime0

	While 1
		$SCHET += 1

	;~ $PixelsearchEx=PixelsearchEx(65,605-12,107-28,625-12,0x716E5F,$shade,177,1,$hwnd,$shade2)
	;~ $PixelsearchEx=PixelsearchEx(68,596,70,598,0x716E5F,$shade,177,1,$hwnd,$shade2)
	;~ $PixelsearchEx=PixelsearchEx(69,597,69,597,0x716E5F,$shade,177,1,$hwnd,$shade2)
;~ 		$PixelsearchEx = PixelsearchEx(69, 597, 69, 597, 0x736E4B, $shade, 179, 1, $hwnd, $shade2)
;~ 	 $PixelsearchEx=PixelsearchEx(69,597,69,597,0x736E4B,$shade,179,1,$hwnd,$shade2)
;~ 		If Not @error Then
		if _pixelSearchSpeed($hwnd)=1 then
	;~ 	ConsoleWrite(" Найденнно: " & $PixelsearchEx[0] &' '& $PixelsearchEx[1] &@CRLF)
			ConsoleWrite(".")
			If $stop = 0 Then $TimeStop = TimerInit()

			;Опреджеление жизни танка
			PixelSearch(4,567,4,569,0xC65E55,30,1,$hwnd)
			if not @error then
				ConsoleWrite("танк мертв")
					if $NoLifeSchet0=0 Then $NoLifeTime0=TimerInit()
					$NoLifeSchet0+=1
					if Timerdiff($NoLifeTime0)>3000 and $NoLifeSchet0>3 then Return
				EndIf
			Else
				PixelSearch(4,567,4,569,0x717D69,30,1,$hwnd)
				if not @error Then
;~ 					ConsoleWrite("танк жив")
				Else
					ConsoleWrite("танк нежив!")
					if $NoLifeSchet=0 Then $NoLifeTime=TimerInit()
					$NoLifeSchet+=1
					if Timerdiff($NoLifeTime)>10000 and $NoLifeSchet>5 then Return
				EndIf
			EndIf

			$stop = 1
			If $stop = 1 Then
				If TimerDiff($TimeStop) > 1000 Then
					$stop = 0
;~ 					_turn()
				EndIf
			EndIf

		Else
	;~ 	ConsoleWrite(" Ненайденнно! " &@CRLF)
			ConsoleWrite("0")



		EndIf
		IF MOD($SCHET,10)=0 THEN ConsoleWrite(@CRLF)
		Sleep(300)
	WEnd
EndFunc

Func _pixelSearchSpeed($hwnd)
	$shade = 25
	$shade2 = 3
	PixelSearch(69, 597, 69, 597, 0x736E4B, $shade,1,$hwnd)
	if not @error then
;~ 		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : PixelGetColor(69, 597,$hwnd) = ' & Hex(PixelGetColor(69, 597,$hwnd),6) & @CRLF) ;### Debug Console
		PixelSearch(69+1, 597+2, 69+1, 597+8, 0x7B7B61, 35)
		if @error then
			ConsoleWrite(".")
			return 1
		Else
			return 0
;~ 			ConsoleWrite("0")
		EndIf
	EndIf
EndFunc


	Func _turn()

		;смена направления поворота
		If 900000 > TimerDiff($TimeOutTurn) Then
			If $turn = 1 Then
				If TimerDiff($TimeOutTurn) > 2000 Then
					$turn = 2
				EndIf
			Else
				If $turn = 2 Then
					If TimerDiff($TimeOutTurn) > 2000 Then
						$turn = 1
					EndIf
				EndIf
			EndIf
		EndIf
		If $turn = 1 Then
			ConsoleWrite(' поворот налево ' & @CRLF)
			Send('{ф down}')
			Send('{a down}')
			Sleep(2000)
			Send('{ф up}')
			Send('{a up}')
			$TimeOutTurn = TimerInit()
		EndIf
		If $turn = 2 Then
			ConsoleWrite(' поворот направо ' & @CRLF)
			Send('{d down}')
			Send('{в down}')
			Sleep(2000)
			Send('{d up}')
			Send('{в up}')
			$TimeOutTurn = TimerInit()
		EndIf
	EndFunc   ;==>_turn



;~ global $iPID = Run($path, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
;~ Local $sOutput, $SummmenuCPU, $SummmenuMEM, $PrevCPUMEM=0
;~ local $PrevCPUMEM[3]=[2,0,0] , $PrevPrevCPUMEM[3]=[2,0,0]
;~ while 1

;~ 		$sOutput = StdoutRead($iPID)
;~ 		If @error Then ; Выход из цикла, если процесс завершён или StdoutRead возвращает ошибку.
;~ 			ExitLoop
;~ 		EndIf


;~ 		if StringinStr($sOutput,'|')<>0 then
;~ 			$CPUMEM=stringsplit($sOutput,'|')
;~ 			ConsoleWrite( @CRLF&' $CPUMEM = ' & $PrevCPUMEM[2]& ' '&$CPUMEM[2])
;~ 			if $CPUMEM[2]<$PrevCPUMEM[2] then ConsoleWrite('<'&@CRLF)
;~ 			if $CPUMEM[2]>$PrevCPUMEM[2] then ConsoleWrite('>'&@CRLF)
;~ 			$PrevCPUMEM=$CPUMEM
;~ 		EndIf

;~ sleep(1000)
;~ 	wend
;~ $hwnd=WinGetHandle('WoT Client')

;~ $thwnd=WinGetTitle('[ACTIVE]')
;~ WinActivate($hwnd)
;~ Opt("MouseCoordMode",2)
;~ MouseMove(Random(505,515),Random(45,55))
;~ MouseClick('left',Random(505,515),Random(45,55))
;~ WinActivate($thwnd)




#include <Constants.au3>
;~ $path=@ScriptDir & "\Bot_WOT_s.exe"
;~ global $iPID = Run($path, @SystemDir, @SW_HIDE, $STDERR_CHILD + $STDOUT_CHILD)
;~ Local $sOutput

;~ $iPID=Run(@ScriptDir & "\Bot_WOT_s.exe")
;~ ConsoleWrite('@@ Debug(' & $path & ') :    $iPID = ' & $iPID & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;~ While 1
;~     $sOutput = StdoutRead($iPID)
;~     If @error Then ; Выход из цикла, если процесс завершён или StdoutRead возвращает ошибку.
;~         ExitLoop
;~     EndIf
;~ 	if $sOutput<>'' then  ConsoleWrite( $sOutput&@CRLF)
;~ 	Sleep(100)
;~ WEnd


Func _MD5ForFile($sFile)

	Local $a_hCall = DllCall("kernel32.dll", "hwnd", "CreateFileW", _
			"wstr", $sFile, _
			"dword", 0x80000000, _ ; GENERIC_READ
			"dword", 1, _ ; FILE_SHARE_READ
			"ptr", 0, _
			"dword", 3, _ ; OPEN_EXISTING
			"dword", 0, _ ; SECURITY_ANONYMOUS
			"ptr", 0)

	If @error Or $a_hCall[0] = -1 Then
		Return SetError(1, 0, "")
	EndIf

	Local $hFile = $a_hCall[0]

	$a_hCall = DllCall("kernel32.dll", "ptr", "CreateFileMappingW", _
			"hwnd", $hFile, _
			"dword", 0, _ ; default security descriptor
			"dword", 2, _ ; PAGE_READONLY
			"dword", 0, _
			"dword", 0, _
			"ptr", 0)

	If @error Or Not $a_hCall[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)
		Return SetError(2, 0, "")
	EndIf

	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFile)

	Local $hFileMappingObject = $a_hCall[0]

	$a_hCall = DllCall("kernel32.dll", "ptr", "MapViewOfFile", _
			"hwnd", $hFileMappingObject, _
			"dword", 4, _ ; FILE_MAP_READ
			"dword", 0, _
			"dword", 0, _
			"dword", 0)

	If @error Or Not $a_hCall[0] Then
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(3, 0, "")
	EndIf

	Local $pFile = $a_hCall[0]
	Local $iBufferSize = FileGetSize($sFile)

	Local $tMD5_CTX = DllStructCreate("dword i[2];" & _
			"dword buf[4];" & _
			"ubyte in[64];" & _
			"ubyte digest[16]")

	DllCall("advapi32.dll", "none", "MD5Init", "ptr", DllStructGetPtr($tMD5_CTX))

	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(4, 0, "")
	EndIf

	DllCall("advapi32.dll", "none", "MD5Update", _
			"ptr", DllStructGetPtr($tMD5_CTX), _
			"ptr", $pFile, _
			"dword", $iBufferSize)

	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(5, 0, "")
	EndIf

	DllCall("advapi32.dll", "none", "MD5Final", "ptr", DllStructGetPtr($tMD5_CTX))

	If @error Then
		DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
		DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)
		Return SetError(6, 0, "")
	EndIf

	DllCall("kernel32.dll", "int", "UnmapViewOfFile", "ptr", $pFile)
	DllCall("kernel32.dll", "int", "CloseHandle", "hwnd", $hFileMappingObject)

	Local $sMD5 = Hex(DllStructGetData($tMD5_CTX, "digest"))

	Return SetError(0, 0, $sMD5)

EndFunc   ;==>_MD5ForFile


;~ $schet=0
;~ dim $result[10][2]
;~ $sFile1=@ScriptDir & "\DB\"&'User.dat'
;~ $sFile2=@ScriptDir & "\DB\"&'User.idx'
;~ $t=TimerInit
;~ $sModified1 = FileGetTime($sFile1, 0, 1)
;~ $result[0][0]=$sModified1
;~ $sModified2 = FileGetTime($sFile2, 0, 1)
;~ $result[0][1]=$sModified2
;~ While 1
;~ $sModified1n = FileGetTime($sFile1, 0, 1)
;~ $sModified2n = FileGetTime($sFile2, 0, 1)
;~ if $sModified1<>$sModified1n Then
;~ 	$schet+=1
;~ 	$result[$schet][0]=TimerDiff($t)
;~ 	$sModified1=$sModified1n
;~ EndIf
;~ if $sModified2<>$sModified2n Then
;~ 	$schet+=1
;~ 	$result[$schet][1]=TimerDiff($t)
;~ 	$sModified2=$sModified2n
;~ EndIf
;~ wend


Func _Quit()
	ProcessClose('Bot_WOT_s.exe')
;~ 	_ArrayDisplay($result)
	Exit

EndFunc   ;==>_Quit
