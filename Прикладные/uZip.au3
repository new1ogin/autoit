#region Header

#cs
	Title:          uZip Extended UDF Library
	Filename:       uZip.au3
	Description:    Library to work with Zip archives
	Author:         Viktor1703
	Version:        3.3.6.0 +
	Requirements:   Developed/Tested on Windows XP Pro Service Pack 3 and Windows Vista/7
	Uses:           none.
	Note:           The library uses the following system DLLs:

	uZip.dll

	Available functions:

	_uZip_Startup
	_uZip_Shutdown
	_uZip_Create
	_uZip_AddFile
	_uZip_DeleteFile
	_uZip_RenameFile
	_uZip_AddMemory
	_uZip_LoadToMemory
	_uZip_LoadToMemoryEx
	_uZip_SaveToFile
	_uZip_SaveFromMemory
	_uZip_GetFileMD5
	_uZip_GetFileSHA1
	_uZip_SizeMemory
	_uZip_CloseMemory
	_uZip_GetFileCount
	_uZip_GetVersion
	_uZip_GetFileIndex
	_uZip_GetFileInfo
	_uZip_GetCompressedSize
	_uZip_GetCompressionMethod
	_uZip_GetCrc32
	_uZip_GetExternalFileAttributes
	_uZip_GetFileName
	_uZip_GetFlag
	_uZip_GetInternalFileAttributes
	_uZip_GetSizeFileName
	_uZip_GetFileDate
	_uZip_GetUnCompressedSize
	_uZip_GetVersionNeeded
	_uZip_AddProgressCallback
	_uZip_ExtractProgressCallback

	* Included in uZip.au3

#ce

#endregion Header

#region Global Variables and Constants

Global $_uZip_DllHandle = 0

#endregion Global Variables and Constants

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_Startup
; Description....: library initialization.
; Syntax.........: _uZip_Startup( $sDllPath )
; Parameters.....: $sDllPath  - The path to the library.
; Return values..: Success - 1.
;                  Failure - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_Startup($sDllPath = -1)
	If ($sDllPath == -1) Then
		$sDllPath = @ScriptDir & '\uZip.dll'
	EndIf
	$_uZip_DllHandle = DllOpen($sDllPath)
	If @error Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_uZip_Startup

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_Shutdown
; Description....: Close library.
; Syntax.........: _uZip_Shutdown(  )
; Parameters.....:
; Return values..:
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_Shutdown()
	DllClose($_uZip_DllHandle)
EndFunc   ;==>_uZip_Shutdown

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_Create
; Description....: Create a archive file.
; Syntax.........: _uZip_Create( $sPackage[, $sPassword[, $iCompressLevel]] )
; Parameters.....: $sPackage       - The path to the archive.
;                  $sPassword      - Set the password for the archive.
;                  $iCompressLevel - Archive compression level.
;                  | 0 - min compression level.
;                  | 9 - max compression level.
; Return values..: Success  - 1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_Create($sPackage, $sPassword = '', $iCompressLevel = 6)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_Create', 'str', $sPackage, 'str', $sPassword, 'long', $iCompressLevel)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_Create

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_AddFile
; Description....: Add file to the archive.
; Syntax.........: _uZip_AddFile( $sPackage, $sFilePath )
; Parameters.....: $sPackage  - The path to the archive.
;                  $sFilePath - The path to the file for archiving.
; Return values..: Success  - 1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_AddFile($sPackage, $sFilePath)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_AddFile', 'str', $sPackage, 'str', $sFilePath)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_AddFile

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_DeleteFile
; Description....: Delete the file from the archive.
; Syntax.........: _uZip_DeleteFile( $sPackage, $sName )
; Parameters.....: $sPackage  - The path to the archive.
;                  $sName     - The file name in the archive.
; Return values..: Success  - 1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_DeleteFile($sPackage, $sName)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_DeleteFile', 'str', $sPackage, 'str', $sName)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_DeleteFile

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_RenameFile
; Description....: Rename the file in the archive.
; Syntax.........: _uZip_RenameFile( $sPackage, $sName, $sNewName )
; Parameters.....: $sPackage  - The path to the archive.
;                  $sName     - The file name in the archive.
;                  $sNewName  - The new file name in the archive.
; Return values..: Success  - 1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_RenameFile($sPackage, $sName, $sNewName)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_RenameFile', 'str', $sPackage, 'str', $sName, 'str', $sNewName)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_RenameFile

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_AddMemory
; Description....: Add data to the archive of memory.
; Syntax.........: _uZip_AddMemory( $sPackage, $sName, $pBuffer, $iBuffer )
; Parameters.....: $sPackage  - The path to the archive.
;                  $sName     - The file name in the archive.
;                  $pBuffer   - A pointer to a chunk of memory with data.
;                  $iBuffer   - The size of the memory.
; Return values..: Success  - 1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_AddMemory($sPackage, $sName, $pBuffer, $iBuffer)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_AddMemory', 'str', $sPackage, 'str', $sName, 'ptr', $pBuffer, 'long', $iBuffer)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_AddMemory

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_LoadToMemory
; Description....: Load the file from the archive to the memory.
; Syntax.........: _uZip_LoadToMemory( $sPackage, $sName[, $sPassword] )
; Parameters.....: $sPackage  - The path to the archive.
;                  $sName     - The file name in the archive.
;                  $sPassword - Password to access the data.
; Return values..: Success  - A pointer to a memory location.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_LoadToMemory($sPackage, $sName, $sPassword = '')
	Local $iRet = DllCall($_uZip_DllHandle, 'ptr', 'uZip_LoadToMemory', 'str', $sPackage, 'str', $sName, 'str', $sPassword)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_LoadToMemory

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_LoadToMemoryEx
; Description....: Load the file from the archive to the memory.
; Syntax.........: _uZip_LoadToMemoryEx( $sPackage, $sName[, $sPassword] )
; Parameters.....: $sPackage  - The path to the archive.
;                  $sName     - The file name in the archive.
;                  $sPassword - Password to access the data.
; Return values..: Success  - Binary data.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_LoadToMemoryEx($sPackage, $sName, $sPassword = '')
	Local $iRet = DllCall($_uZip_DllHandle, 'ptr', 'uZip_LoadToMemory', 'str', $sPackage, 'str', $sName, 'str', $sPassword)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	$tBuffer = DllStructCreate('byte[' & _uZip_SizeMemory($iRet[0]) & ']', $iRet[0])
	_uZip_CloseMemory($iRet[0])
	Return DllStructGetData($tBuffer, 1)
EndFunc   ;==>_uZip_LoadToMemoryEx

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_SaveToFile
; Description....: Extract the file from the archive.
; Syntax.........: _uZip_SaveToFile( $sPackage, $sName[, $sPassword[, $sOutPath]] )
; Parameters.....: $sPackage  - The path to the archive.
;                  $sName     - The file name in the archive.
;                  $sPassword - Password to access the data.
;                  $sOutPath   - Way to extract.
; Return values..: Success  - 1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_SaveToFile($sPackage, $sName, $sPassword = '', $sOutPath = @ScriptDir)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_SaveToFile', 'str', $sPackage, 'str', $sName, 'str', $sPassword, 'str', $sOutPath)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_SaveToFile

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_SaveFromMemory
; Description....: Save data from memory to a file.
; Syntax.........: _uZip_SaveFromMemory( $pMemory, $sOutFile )
; Parameters.....: $pMemory  - A pointer to a memory location.
;                  $sOutFile - The path and file name.
; Return values..: Success  - 1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_SaveFromMemory($pMemory, $sOutFile)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_SaveFromMemory', 'ptr', $pMemory, 'str', $sOutFile)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_SaveFromMemory

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetFileMD5
; Description....: MD5 checksum.
; Syntax.........: _uZip_GetFileMD5( $pBuffer )
; Parameters.....: $pBuffer - A pointer to a memory location.
; Return values..: Success  - MD5.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetFileMD5($pBuffer)
	Local $iRet = DllCall($_uZip_DllHandle, 'str', 'uZip_GetFileMD5', 'ptr', $pBuffer)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetFileMD5

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetFileSHA1
; Description....: SHA1 checksum.
; Syntax.........: _uZip_GetFileSHA1( $pBuffer )
; Parameters.....: $pBuffer - A pointer to a memory location.
; Return values..: Success  - SHA1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetFileSHA1($pBuffer)
	Local $iRet = DllCall($_uZip_DllHandle, 'str', 'uZip_GetFileSHA1', 'ptr', $pBuffer)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetFileSHA1

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_SizeMemory
; Description....: The size of the memory.
; Syntax.........: _uZip_SizeMemory( $pBuffer )
; Parameters.....: $pBuffer - A pointer to a memory location.
; Return values..: Success  - Size.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_SizeMemory($pBuffer)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_SizeMemory', 'ptr', $pBuffer)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_SizeMemory

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_CloseMemory
; Description....: Free the memory area.
; Syntax.........: _uZip_CloseMemory( $pBuffer )
; Parameters.....: $pBuffer - A pointer to a memory location.
; Return values..: Success  - 1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_CloseMemory($pBuffer)
	DllCall($_uZip_DllHandle, 'none', 'uZip_CloseMemory', 'ptr*', $pBuffer)
	If (@error) Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_uZip_CloseMemory

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetFileCount
; Description....: The number of files in the archive.
; Syntax.........: _uZip_GetFileCount( $sPackage )
; Parameters.....: $sPackage - The path to the archive.
; Return values..: Success  - File count.
;                  Failure  - -1 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetFileCount($sPackage)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetFileCount', 'str', $sPackage)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetFileCount

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetVersion
; Description....: Zip version of the module.
; Syntax.........: _uZip_GetVersion( )
; Parameters.....:
; Return values..: Success  - Version.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetVersion()
	Local $iRet = DllCall($_uZip_DllHandle, 'str', 'uZip_GetVersion')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetVersion

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetFileIndex
; Description....: Find out the index file in the archive by name.
; Syntax.........: _uZip_GetFileIndex( $sPackage, $sName )
; Parameters.....: $sPackage - The path to the archive.
;                  $sName    - The file name in the archive.
; Return values..: Success  - File Index.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetFileIndex($sPackage, $sName)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetFileIndex', 'str', $sPackage, 'str', $sName)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetFileIndex

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetFileInfo
; Description....: Find out information about a file.
; Syntax.........: _uZip_GetFileInfo( $sPackage, $iIndexFile )
; Parameters.....: $sPackage   - The path to the archive.
;                  $iIndexFile - File Index.
; Return values..: Success  - 1.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetFileInfo($sPackage, $iIndexFile)
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetFileInfo', 'str', $sPackage, 'long', $iIndexFile)
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetFileInfo

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetCompressedSize
; Description....: Information about file compression.
; Syntax.........: _uZip_GetCompressedSize(  )
; Parameters.....:
; Return values..: Success  - Compressed Size.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetCompressedSize()
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetCompressedSize')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetCompressedSize

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetCompressionMethod
; Description....: Information about the method of compression.
; Syntax.........: _uZip_GetCompressionMethod(  )
; Parameters.....:
; Return values..: Success  - Compressed method.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetCompressionMethod()
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetCompressionMethod')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetCompressionMethod

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetCrc32
; Description....: Information about checksum CRC32 file.
; Syntax.........: _uZip_GetCrc32(  )
; Parameters.....:
; Return values..: Success  - Check sum.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetCrc32()
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetCrc32')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return Hex($iRet[0])
EndFunc   ;==>_uZip_GetCrc32

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetExternalFileAttributes
; Description....: Information on external file attributes.
; Syntax.........: _uZip_GetExternalFileAttributes(  )
; Parameters.....:
; Return values..: Success  - Attributes.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetExternalFileAttributes()
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetExternalFileAttributes')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetExternalFileAttributes

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetFileName
; Description....: Information about the file.
; Syntax.........: _uZip_GetFileName(  )
; Parameters.....:
; Return values..: Success  - File name.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetFileName()
	Local $iRet = DllCall($_uZip_DllHandle, 'str', 'uZip_GetFileName')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetFileName

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetFlag
; Description....: Information on a password.
; Syntax.........: _uZip_GetFlag(  )
; Parameters.....:
; Return values..: Success  - Non-zero.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetFlag()
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetFlag')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetFlag

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetInternalFileAttributes
; Description....: Information on internal file attributes.
; Syntax.........: _uZip_GetInternalFileAttributes(  )
; Parameters.....:
; Return values..: Success  - Attributes.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetInternalFileAttributes()
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetInternalFileAttributes')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetInternalFileAttributes

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetSizeFileName
; Description....: Information about the size of the file name.
; Syntax.........: _uZip_GetSizeFileName(  )
; Parameters.....:
; Return values..: Success  - Size file name.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetSizeFileName()
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetSizeFileName')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetSizeFileName

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetFileDate
; Description....: Information on the date file was last modified.
; Syntax.........: _uZip_GetFileDate(  )
; Parameters.....:
; Return values..: Success  - Date.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetFileDate()
	Local $iRet = DllCall($_uZip_DllHandle, 'str', 'uZip_GetFileDate')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetFileDate

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetUnCompressedSize
; Description....: Information on the size of the uncompressed.
; Syntax.........: _uZip_GetUnCompressedSize(  )
; Parameters.....:
; Return values..: Success  - Size.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetUnCompressedSize()
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetUnCompressedSize')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetUnCompressedSize

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_GetVersionNeeded
; Description....: Information required for release.
; Syntax.........: _uZip_GetVersionNeeded(  )
; Parameters.....:
; Return values..: Success  - Version.
;                  Failure  - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_GetVersionNeeded()
	Local $iRet = DllCall($_uZip_DllHandle, 'long', 'uZip_GetVersionNeeded')
	If (@error Or (Not IsArray($iRet))) Then
		Return SetError(1, 0, 0)
	EndIf
	Return $iRet[0]
EndFunc   ;==>_uZip_GetVersionNeeded

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_AddProgressCallback
; Description....: Status of file uploads to the archive.
; Syntax.........: _uZip_AddProgressCallback( $pProc )
; Parameters.....: $pProc  - Pointer to function.
; Return values..: Success - Version.
;                  Failure - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_AddProgressCallback($pProc)
	DllCall($_uZip_DllHandle, 'none', 'uZip_AddProgressCallback', 'ptr', $pProc)
	If (@error) Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_uZip_AddProgressCallback

; #FUNCTION# ====================================================================================================================
; Name...........: _uZip_ExtractProgressCallback
; Description....: Status of the file extraction.
; Syntax.........: _uZip_ExtractProgressCallback( $pProc )
; Parameters.....: $pProc  - Pointer to function.
; Return values..: Success - Version.
;                  Failure - 0 and sets the @error flag to non-zero.
; Author.........: Viktor1703
; Modified.......:
; Remarks........:
; Related........:
; Link...........:
; Example........: Yes
; ===============================================================================================================================

Func _uZip_ExtractProgressCallback($pProc)
	DllCall($_uZip_DllHandle, 'none', 'uZip_ExtractProgressCallback', 'ptr', $pProc)
	If (@error) Then
		Return SetError(1, 0, 0)
	EndIf
	Return 1
EndFunc   ;==>_uZip_ExtractProgressCallback
