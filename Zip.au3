Global $sZipDll = -1

Func _Zip_Startup($sDll = 'Zip.dll')
	$sZipDll = DllOpen($sDll)
	If @error Then
		Return SetError(@error, @extended, 0)
	EndIf
    Return 1
EndFunc	

Func _Zip_Create($sZipName)
	Local $iRet = DllCall($sZipDll, 'int', 'ZIPFileCreate', 'str', $sZipName)
	If (@error) Or (Not IsArray($iRet)) Then
		Return SetError(@error, @extended, 0)
	EndIf
    Return 1
EndFunc	

Func _Zip_AddFile($sPath)
	Local $iRet = DllCall($sZipDll, 'int', 'ZIPFileAddFile', 'str', $sPath)
	If (@error) Or (Not IsArray($iRet)) Then
		Return SetError(@error, @extended, 0)
	EndIf
    Return 1
EndFunc

Func _Zip_SetPassword($sPassw)
	DllCall($sZipDll, 'none', 'ZIPFileSetPassword', 'str', $sPassw)
EndFunc

Func _Zip_Extract($sZipName, $sOutPath, $sMask = '*.*')
	Local $iRet = DllCall($sZipDll, 'int', 'ZIPFileExtract', 'str', $sZipName, 'str', $sMask, 'str', $sOutPath)
	If (@error) Or (Not IsArray($iRet)) Then
		Return SetError(@error, @extended, 0)
	EndIf
    Return 1
EndFunc

Func _Zip_AddCallBack($sFunc)
	Local $tCallback = DllCallbackRegister($sFunc, 'uint', 'str;float;int')
	DllCall($sZipDll, 'none', 'ZIPFileCompressionCallBack', 'ptr', DllCallbackGetPtr($tCallback))
EndFunc

Func _Zip_ExtractCallBack($sFunc)
	Local $tCallback = DllCallbackRegister($sFunc, 'ptr', 'str;float;int')
	DllCall($sZipDll, 'none', 'ZIPFileProgressionCallback', 'ptr', DllCallbackGetPtr($tCallback))
EndFunc

Func _Zip_Close()
	DllCall($sZipDll, 'none', 'ZIPFileClose')
EndFunc