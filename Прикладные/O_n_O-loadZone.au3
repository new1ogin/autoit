#RequireAdmin
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
;~ #include <GuiTreeView.au3>
;~ #include <GuiListView.au3>
;~ #include <array.au3>

HotKeySet("^+{F7}", "_Quit") ;Это вызов

$TxtFile = ''
; получение из ком строки
if $CmdLine[0] > 0 and FileExists($CmdLine[1]) then $TxtFile = $CmdLine[1]

if $TxtFile = '' Then
	$TxtFile = FileOpenDialog("Выберите файл содержащий правила для зоны",@ScriptDir,"Все (*.*)",3,'fast.txt') ;Запрос на ввод директории для поиска
EndIf
$zone = 1
$zone = InputBox("Выбор", "Выберите номер зоны","1")

$text = FileRead ($TxtFile)
$text = StringReplace($text,@CR,'')
$text = StringSplit($text,@LF)


For $i=1 to $text[0]
	$hwnd = WinWait("Настройка зонирования",'',10)
	_ClickAdd($hwnd,$zone)
	$hwnd2 = WinWait("Добавление правила к зоне",'',10)
	ControlSend($hwnd2,'',"[CLASS:Edit; INSTANCE:1]",StringStripWS($text[$i],3))
	ControlClick($hwnd2,'',"[CLASS:Button; INSTANCE:2]")
Next


Func _Quit($message = 0)
	Exit
EndFunc

Func _ClickAdd($hwnd,$nstanse = 1,$num=0)
;~ 	WinActivate($hwnd)
	$wpos = WinGetPos($hwnd)
	$pos = ControlGetPos ($hwnd, '', '[CLASS:XTPReport; INSTANCE:'&$nstanse&']')
	$PlusPos = PixelSearch($wpos[0]+$pos[0]+30,$wpos[1]+$pos[1]+$pos[3]+20,$wpos[0]+$pos[0],$wpos[1]+$pos[1]+20,0x304860,15)
	if @error Then
		$ClickPlusx = $wpos[0]+$pos[0]+11
		$ClickPlusy = $wpos[1]+$pos[1]+20+35
	Else
		$ClickPlusx = $PlusPos[0]-4
		$ClickPlusy = $PlusPos[1]-4
	EndIf
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ClickPlusx = ' & $ClickPlusx & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $ClickPlusy = ' & $ClickPlusy & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

	For $i=0 to 3
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $i = ' & $i & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		WinActivate($hwnd)
		$AddPos = PixelSearch($ClickPlusx,$ClickPlusy,$ClickPlusx+50,$ClickPlusy+110,0x0000FF,15)
		if not @error Then
			exitloop
		Else
			$AddPos = PixelSearch($ClickPlusx,$ClickPlusy,$ClickPlusx+50,$ClickPlusy+110,0x0A246A,15)
			if not @error Then ExitLoop
			$AddPos = PixelSearch($ClickPlusx,$ClickPlusy,$ClickPlusx+50,$ClickPlusy+110,0x3399FF,15)
			if not @error Then ExitLoop
		EndIf
		ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $i = ' & $i & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
		MouseMove($ClickPlusx,$ClickPlusy,0)
		MouseDown('left')
		sleep(128)
		MouseUp('left')
;~ 		MouseClick('left',$ClickPlusx,$ClickPlusy,1,0)
		$AddPos = PixelSearch($ClickPlusx,$ClickPlusy,$ClickPlusx+50,$ClickPlusy+110,0x0000FF,15)
		if not @error Then
			exitloop
		Else
			$AddPos = PixelSearch($ClickPlusx,$ClickPlusy,$ClickPlusx+50,$ClickPlusy+110,0x0A246A,15)
			if not @error Then ExitLoop
			$AddPos = PixelSearch($ClickPlusx,$ClickPlusy,$ClickPlusx+50,$ClickPlusy+110,0x3399FF,15)
			if not @error Then ExitLoop
		EndIf
		sleep(500)
	Next
	MouseWheel ( "down",10)
;~ 	sleep(200)
	MouseClick('left',$AddPos[0]+25,$AddPos[1]+5,1,0)
	If WinExists("Добавление правила к зоне") Then
		return 1
	ElseIf $num = 0 Then
		return _ClickAdd($hwnd,$nstanse,1)
	Else
		return 0
	EndIf

EndFunc

;~ $hListview = ControlGetHandle($hWnd, "", "[CLASS:SysTreeView32; INSTANCE:1]")
;~ _GUICtrlListView_GetItemCount($hListview)
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GUICtrlListView_GetItemCount($hListview) = ' & _GUICtrlListView_GetItemCount($hListview) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ControlFocus($hWnd, "", "SysListView321")
;~     $num = ControlListView($hWnd, "", '', "GetItemCount")
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $num = ' & $num & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~     $sub = ControlListView($hWnd, "", '', "GetSubItemCount")
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sub = ' & $sub & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
;~ ControlListView($hWnd, "", "SysListView321", "Selectclear")
;~ ControlListView($hWnd, "", "SysListView321", "Select", 0)
;~ $hListView = ControlGetHandle($hWnd, "", "SysListView321")
;~ $iIndex = 0
;~ $sText1 = _GUICtrlListView_GetItemTextString($hListView, $iIndex)
;~ $sText2 = _GUICtrlListView_GetItemText($hListView, $iIndex, 0)
;~ MsgBox(0, "", $sText1 & @LF & $sText2)

;~ #RequireAdmin
;~ MouseMove($ClickPlusx,$ClickPlusy)
;~ MouseClick('left',$ClickPlusx,$ClickPlusy,1,0)
;~ MsgBox(0,'',$ClickPlusx & ' ' & $ClickPlusy)


;~ $sTextmetka = ControlGetText($hwnd,'',"[CLASS:SysTreeView32; INSTANCE:1]")
;~ ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $sTextmetka = ' & $sTextmetka & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console


;~ $hTreeView = ControlGetHandle($hwnd, '', '[CLASS:SysTreeView32; INSTANCE:1]')
;~     If Not $hTreeView Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber)
;~     $hItem = _GUICtrlTreeView_FindItem($hTreeView, 'Все диски')
;~     If Not $hItem Then ConsoleWrite('@@ Debug(' & @ScriptLineNumber)
;~     _GUICtrlTreeView_EnsureVisible($hTreeView, $hItem)
;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : _GUICtrlListView_GetItemText($hWnd, ) = ' & _GUICtrlListView_GetItemText($hTreeView, 0 ) & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console

;~ 	ControlClick($hwnd, '', '[CLASS:XTPReport; INSTANCE:1]', 'left', 1, 520, $pos[3]/2)
;~ ControlClick($hwnd,'','[CLASS:XTPReport; INSTANCE:1]',"left",2, 9, 35)
;~ ControlClick($hwnd,'','[CLASS:XTPReport; INSTANCE:1]',"left",2, 64, 55)

;~ 	ConsoleWrite('@@ Debug(' & @ScriptLineNumber & ') : $TxtFile = ' & $TxtFile & @CRLF & '>Error code: ' & @error & @CRLF) ;### Debug Console
