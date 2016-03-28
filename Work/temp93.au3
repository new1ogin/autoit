#include <GUIConstants.au3>
#include <Array.au3>

$sFileType = '*.cp';���������� �������������� ������, ����� ����� � �������
$sSearch1 = 'G01X0.000Y0.000';������� ������
$sSearch2 = 'M02'
$sSign = '#';������ ��� ����������� ������ �����

$hGUI = GUICreate('���������� ������ *.cp', 640, 220);����
$hInputPath = GUICtrlCreateInput('', 5, 5, 630, 21);���� ��� ������ ���� � ��������
GUICtrlSetState(-1, $GUI_DISABLE);���� ������ "������ ��� ������"
$hButtonOpenFolder = GUICtrlCreateButton('������� �����', 480, 30, 150, 25);������ ������ ��������
$hButtonChek = GUICtrlCreateButton('����������', 10, 30, 120, 24);������ �������� ������
$hButtonStart = GUICtrlCreateButton('����', 250, 30, 80, 24);������ ������ ���������
$hLabelInfo = GUICtrlCreateLabel('', 10, 60, 620, 120)
$hProgress = GUICtrlCreateProgress(10, 190, 620, 15)
GUISetState(@SW_SHOW)

While 1
    $hMsg = GUIGetMsg();����������� ������� �� ������
    Select
        Case $hMsg = $GUI_EVENT_CLOSE; �������� ���� ���������
            Exit
        Case $hMsg = $hButtonOpenFolder; ������ ������ ����� ��������
            $hFolder = FileOpenDialog('�������� ���� ��� ���������',@ScriptDir, "Html (*.htm; *.html)|��� (*.*)")
            If $hFolder <> '' Then  GUICtrlSetData($hInputPath, $hFolder);���� ������������ �� ����� ������ ��� �� ������ ���� ������ ��������, �� ������� ���������� ���� � ���� �����
        Case $hMsg = $hButtonStart; ������ ������ ����� �������
            $sFolder = GUICtrlRead($hInputPath);������ ���� �� ��������
            If $sFolder = '' Then;���� �� ��� ������
                MsgBox(0, '������', '�� ������ ������� ��� ���������')
            ElseIf Not FileExists($sFolder) Then;����� ������� �� ����������
                MsgBox(0, '������', '������� �������� �� ����������')
            Else
                $sOut = _processing($sFolder, $sSign);������� ��������� ������
                If Not @error Then
                    GUICtrlSetData($hLabelInfo, '����� ������� � ���������� ������: ' & $sOut)
                Else
                    MsgBox(0, '������ �� �������', '� ������ �������� �� ������� �� ������ ����������� �����')
                EndIf
            EndIf
        Case $hMsg = $hButtonChek; ������ ������ �������� ������
            $sFolder = GUICtrlRead($hInputPath);������ ���� �� ��������
            If $sFolder = '' Then;���� �� ��� ������
                MsgBox(0, '������', '�� ������ ������� ��� ���������')
            ElseIf Not FileExists($sFolder) Then;����� ������� �� ����������
                MsgBox(0, '������', '������� �������� �� ����������')
            Else
                $aOut = _checkFiles($sFolder);������� ������� ������
                If Not @error Then
                    GUICtrlSetData($hLabelInfo, '����� ������� ������: ' & $aOut[0] & @CRLF & '���������� �����: ' & $aOut[1])
                Else
                    MsgBox(0, '������ �� �������', '� ������ �������� �� ������� �� ������ ����������� �����')
                EndIf
            EndIf
    EndSelect
WEnd

Func _checkFiles($sPath)
    $aFiles = _FileSearch($sPath, $sFileType); ���� ����� ������� ���������� � ������� � ������
    If Not @error And $aFiles[0] > 0 Then; ������ ���� �� ���� ����
        Local $iSumm = 0;����� ����� ������� ����� ���� �����, ���������� � ������ ������
        For $i = 1 To $aFiles[0]
            $iSumm += Number(StringRegExpReplace($aFiles[$i], '^.*\\.*?\=(\d+).*', '$1'));�� ������� ���� ����� ��������� ������ ����� ����� ����� �����, �������� ��� � ��������� �������� � ��������
        Next
        Dim $aOut[2] = [$aFiles[0], $iSumm]
        Return $aOut
    Else;������ �� �������
        SetError(1)
        Return 0
    EndIf
EndFunc

Func _processing($sPath, $sStr)
    $aFiles = _FileSearch($sPath, $sFileType); ���� ����� ������� ���������� � ������� � ������
    If Not @error And $aFiles[0] > 0 Then; ������ ���� �� ���� ����
        Dim $aNewNames[$aFiles[0] + 1][2];������ ��� �������� ����� ���� ������
        $sPattern = '\Q' & $sSearch1 & '\E\v+\Q' & $sSearch2 & '\E$';������ ��� ������ ������� ����� � ����� �����
        For $i = 1 To $aFiles[0]
            GUICtrlSetData($hProgress, 100*(Round($i/$aFiles[0], 2)));������� ��������
            GUICtrlSetData($hLabelInfo, '�������������� ����: ' & $aFiles[$i] & @CRLF & '���������� ������: ' & $i & ' �� ' & $aFiles[0])
            $aNewNames[$i][0] = StringRegExpReplace($aFiles[$i], '\\[^\\]*$', '');�� ������� ���� ����� ��������� ������ ���� �� �����
            $aNewNames[$i][1] = StringRegExpReplace($aFiles[$i], '^.*\\', '');�� ������� ���� ����� ��������� ������ ��� � ����������
            $sFile = FileRead($aFiles[$i]);��������� ����
            If StringRegExp($sFile, $sPattern, 0) Then;� ����� ������� ������� ������ - �������
                $sNewFile = StringRegExpReplace($sFile, $sPattern, '');������� ��������� ������ � ������
                $hFile = FileOpen($aFiles[$i], 2); ��������� ���� ��� ����������
                FileWrite($hFile, $sNewFile); ����� � ����
                FileClose($hFile);��������� ����
            EndIf
            FileMove($aFiles[$i], $aNewNames[$i][0] & '\' & $sStr & $aNewNames[$i][1], 1); ��������������� ������������ �����
        Next
        Return $aFiles[0]
    Else;������ �� �������
        SetError(1)
        Return 0
    EndIf
EndFunc

Func _FileSearch($sPath, $sFileMask, $iSubDir = 1); ������� ������ ������ (����� �������), ���� �� ����� ������
    ;������ �������� - ����, ������ ����� ������ ��� ������, ������ - ���� ������ � ������������
    Local $sOutBin, $sOut, $aOut, $sRead, $hDir, $sAttrib
    If $iSubDir = 1 Then
        $sAttrib = ' /S /B /A'
    Else
        $sAttrib = ' /B /A'
    EndIf
    $sOut = StringToBinary('0' & @CRLF, 2)
    $aMasks = StringSplit($sFileMask, ';')
    For $i = 1 To $aMasks[0]
        $hDir = Run(@ComSpec & ' /U /C DIR "' & $sPath & '\' & $aMasks[$i] & '"' & $sAttrib, @SystemDir, @SW_HIDE, 6)
        While 1
            $sRead = StdoutRead($hDir, False, True)
            If @error Then
                ExitLoop
            EndIf
            If $sRead <> '' Then
                $sOut &= $sRead
            EndIf
        WEnd
    Next
    $aOut = StringRegExp(BinaryToString($sOut, 2), '[^\r\n]+', 3)
    If @error Then
        Return SetError(1)
    EndIf
    $aOut[0] = UBound($aOut) - 1
    Return $aOut
EndFunc   ;==>_FileSearch
