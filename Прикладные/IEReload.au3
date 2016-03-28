#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_UseX64=n
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#include <IE.au3>

if $CmdLine[0] < 2 Then
	exit
EndIf
$Search = $CmdLine[1]
$URL = $CmdLine[2]

$oIE = _IEAttach($Search , "Title")

_IENavigate($oIE, $URL) ;переход по ссылке

