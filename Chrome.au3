global $primer,$1,$2,$3,$znak1,$znak2,$otvet
_zadacha(random(0,9,1))


#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>
Opt("GUIOnEventMode", 1)
#Region ### START Koda GUI section ### Form=E:\Vitaliy\PROGRAMS\autoitv3.3.8.1\chrome.kxf
$Form1_2 = GUICreate("Проверка", 261, 121, -1, -1)
GUISetOnEvent($GUI_EVENT_CLOSE, "Form1_2Close")
$Label1 = GUICtrlCreateLabel("Для запуска пожалуйста решите этот пример:", 8, 8, 241, 17)
$otvet = GUICtrlCreateInput("", 72, 56, 121, 21, BitOR($GUI_SS_DEFAULT_INPUT,$ES_CENTER))
GUICtrlSetResizing(-1, $GUI_DOCKVCENTER+$GUI_DOCKHEIGHT)
$Label2 = GUICtrlCreateLabel($primer, 7, 32, 246, 17, $SS_CENTER)
GUICtrlSetResizing(-1, $GUI_DOCKVCENTER)
$Button1 = GUICtrlCreateButton("OK", 93, 88, 75, 25, $BS_CENTER)
GUICtrlSetResizing(-1, $GUI_DOCKVCENTER+$GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
GUICtrlSetOnEvent(-1, "Button1Click")
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1
	Sleep(100)
WEnd







_zadacha(random(0,9,1))

Func _zadacha($tip)
	$1=random(0,99,1)
	$2=random(0,99,1)
	$3=random(0,99,1)
	$znak1=random(0,1,1)
	$znak2=random(0,1,1)
	if $znak1=0 then $znak1=' + '
	if $znak1=1 then $znak1=' - '
	if $znak2=0 then $znak2=' + '
	if $znak2=1 then $znak2=' - '

	$primer = $1&$znak1&$2&$znak2&$3&' ='

if $znak1=' - ' then $2=-$2
if $znak2=' - ' then $3=-$3

$otvet=$1+$2+$3

EndFunc


Func Button1Click()
	msgbox(0,'',$otvet&'  и '&GUICtrlRead($otvet))
 if $otvet=GUICtrlRead($otvet) then exit

EndFunc
Func Form1_2Close()
	exit
EndFunc