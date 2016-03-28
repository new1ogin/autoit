#include <GUIConstantsEx.au3>
#include <ProgressConstants.au3>
#include <array.au3>
#include <WinAPI.au3>
#include <ScreenCapture.au3>
#include <IE.au3>
#include <log.au3>
HotKeySet("{F7}", "_Exit")
HotKeySet("{F6}", "_GO")
$sleep=100
While 1
	sleep(100)
WEnd


Opt("SendKeyDelay", 64)             ;5 миллисекунд
Opt("SendKeyDownDelay", 32)     ;1 миллисекунда

Func _Go()
#include <Array.au3>

Global $aArray1[] = [0,1,3,4,5]
Global $aArray2[] = [1,3,4,6,7]

_ArrayDisplay(_ArrayCompare($aArray1, $aArray2))
_ArrayDisplay(_ArrayCompare($aArray2, $aArray1))



EndFunc

Func _ArrayCompare(Const ByRef $a1, Const ByRef $a2)
  If Not IsArray($a1) Or Not IsArray($a2) Then Return
  If UBound($a1, 0) <> 1 Or UBound($a2, 0) <> 1 Then Return
  Local $sUniq = ""
  For $i = 0 To UBound($a1) - 1
    For $j = 0 To UBound($a2) - 1
      If $a1[$i] = $a2[$j] Then ExitLoop
    Next
    If $j = UBound($a2) Then $sUniq &= $a1[$i] & "|"
  Next
  Return StringSplit(StringTrimRight($sUniq, 1), "|", 2)
EndFunc


Func _exit()
	Exit
EndFunc
