#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <Array.au3>


global $variantotveta

$ini = StringTrimRight(@ScriptFullPath, 3) & 'ini'
If Not FileExists($ini) Then
    $hFile = FileOpen($ini, 2)
    FileWrite($hFile, _
            '[1]' & @CRLF & _
            '0 = 840.����� ���� �����������' & @CRLF & _
            '1 = ������' & @CRLF & _
            '2 = Ƹ����' & @CRLF & _
			'2 = Ƹ����' & @CRLF & _
            '3 = �������' & @CRLF & @CRLF & _
            '[2]' & @CRLF & _
            '0 = 5210.������� �������' & @CRLF & _
            '1 = 12 000 ��' & @CRLF & _
			'2 = Ƹ����' & @CRLF & _
            '2 = 30 000 ��' & @CRLF & _
            '3 = 60 000 ��')
    FileClose($hFile)
EndIf

$ainiSection = IniReadSectionNames($ini)
ConsoleWrite($ainiSection & @CRLF) ;�������
If @error Then Exit MsgBox(0, '���������', 'ini-���� ������')

$iStep = 0 ; ������� �����, ����� ���������, ����� ���������� ��������� ������ ini-�����
Local $aiCountAnswer[$ainiSection[0] + 1][2] = [[0]] ; ������� ����������, ���������� ���������� �������
$sCurAnswer = 0 ; ���������� �����, ����� ����������

;���������� ������� �������
global $variantotveta, $MassivOtvetov[UBound($aiCountAnswer)]

; ������������ ����� ������� �� ���������� 10, �� ������� GUI - 9
$hGui = GUICreate('��������� ��� ������������ ������ ������', 610, 320) ; �������������� GUI ���������� � 3
GUISetFont(11)
$iQuestion = GUICtrlCreateLabel('', 5, 5, 600, 66) ; ����� ������������� $SS_CENTER + $SS_CENTERIMAGE
; GUICtrlSetBkColor(-1, 0xfdffae)
$iHorz = GUICtrlCreateLabel('-', 5, 71, 600, 0, $SS_ETCHEDHORZ) ; �������������� �����
GUICtrlSetState(-1, $GUI_HIDE)

If $CmdLine[0] Then ; ���� ������� �������� ���-������, �� �������� ����� ��������������
    $iMenu = GUICtrlCreateContextMenu($iQuestion)
    $iRnd = GUICtrlCreateMenuItem('��������� ��������� �����', $iMenu)
Else ; ����� ������ ��������
    $iRnd = GUICtrlCreateDummy()
EndIf

Local $aID[1] = [0] ; �������������� �����������
$ID_Start = 0 ; ���������� ID ��� ������� Switch -> Case �� ���������
$ID_End = -1

$iBtnNext = GUICtrlCreateButton('������ ����', 477, 276, 108, 28)
$iBtnBack = GUICtrlCreateButton('�����', 367, 276, 108, 28)
GUICtrlSetState(-1, $GUI_HIDE)
; $iStatusBar = GUICtrlCreateLabel('StatusBar', 5, 260 - 20, 150, 17)
GUISetState()
While 1
    $iMsg = GUIGetMsg()
    Switch $iMsg
        Case -3
            Exit
        Case $iRnd
            ; $iRndAns = InputBox(' ', ' ', '', '', 170, 150)
            ; If Not @error And StringIsDigit($iRndAns) Then
                ; If StringLen($iRndAns) = 1 Then
                    ; ClipPut((Random(1, 99, 1) & $iRndAns) * 19 + 23)
                ; Else
                    ; ClipPut($iRndAns * 19 + 23)
                ; EndIf
            ; EndIf
            ; ���� ����������� ������
            For $i = 1 To $aID[0]
                If GUICtrlRead($aID[$i]) = $GUI_CHECKED Then
                    $j = $aID[$i] - $aID[1] + 1 ; ����� �������� ������
					
					;�������
;~ 					ConsoleWrite($j & @CRLF)
					
                    $tmp = IniRead($ini, $ainiSection[$iStep], '0', '������') ; ������ ������
                    $tmp = StringRegExp($tmp, '^\d+?\.(.*)$', 1)
                    If @error Then
                        MsgBox(0, '������', '������')
                        ContinueLoop
                    EndIf
                    IniWrite($ini, $ainiSection[$iStep], '0', (Random(1, 99, 1) & $j) * 19 + 23 & '.' & $tmp[0])
                    ExitLoop
                EndIf
            Next
        Case $iBtnNext
            If $ID_End = -3 Then Exit
            _StepGUI()
            ; ���� ����� �������� ID, �� �������� �����
            If $ID_End <> -3 And $aiCountAnswer[$iStep][1] Then 
			   GUICtrlSetState($aiCountAnswer[$iStep][1], $GUI_CHECKED)
			EndIf
			
			; ������ ������ � ������
					 ConsoleWrite('��������� ������� ������: '&$variantotveta & '   i���= ' & $iStep & @CRLF) ; ������� 
			if $variantotveta > 0 then 
			   $MassivOtvetov[$iStep-1] = $variantotveta
			   ConsoleWrite('(������� ������ �� ����) ��������� ������� ������: '&$variantotveta & '   i���= ' & $iStep & @CRLF)
			EndIf
				  
		   ; ������� �� ����������� �����������
			If $iStep > $ainiSection[0] Then 
			   _Vyvod_Resultatyov()
			EndIf
				  
        Case $iBtnBack
            _StepGUI(0)
            ; ���� ����� �������� ID, �� �������� �����
            If $ID_End <> -1 And $aiCountAnswer[$iStep][1] Then GUICtrlSetState($aiCountAnswer[$iStep][1], $GUI_CHECKED)
        Case $ID_Start To $ID_End
            $j = $iMsg - $ID_Start + 1 ; ����� �������� ������
								   
					$variantotveta=$j
            ; MsgBox(0, 'Check', $j, 0, $hGui)
            $aiCountAnswer[$iStep][1] = $iMsg ; ��������� ID, ����� ��� �������� ��������� ���������� �����
            If $j == StringRight(($sCurAnswer - 23) / 19, 1) Then ; ����� ������ * 19 + 23, �������� ��� 3 ����� 43 * 19 + 23 = 840
                $aiCountAnswer[$iStep][0] = 1 ; '�����
            Else
                $aiCountAnswer[$iStep][0] = 0 ; �� �����
			EndIf
			 					;�������
;~ 					ConsoleWrite('���� �� ������� ������: '&$j & @CRLF)

    EndSwitch
WEnd

Func _StepGUI($iNext = 1)
    If $iNext Then
        $iStep += 1
    Else
        $iStep -= 1
    EndIf
    For $i = 1 To $aID[0]
        GUICtrlDelete($aID[$i]) ; ���� �������� ���������� ���������
    Next
    If $iStep = 1 Then
        GUICtrlSetData($iBtnNext, '�����') ; ��������� ������ � ������ ������
        GUICtrlSetState($iBtnBack, $GUI_SHOW) ; ���������� ������ "�����"
        GUICtrlSetState($iHorz, $GUI_SHOW) ; ���������� �����
    EndIf
    If $iStep <= 0 Then ; ���� ����� ���� ����� 0 ��� ������ �� �����
        Dim $aID[1] = [0]
        $ID_Start = 0 ; ���������� ID ��� ������� Switch -> Case �� ���������
        $ID_End = -1
        GUICtrlSetData($iBtnNext, '������ ����') ; ��������� ������ ��� �������� � ������
        GUICtrlSetState($iBtnBack, $GUI_HIDE) ; �������� ������ "�����"
        GUICtrlSetData($iQuestion, '') ; ������������� ����� ��� �������� � ������
        WinSetTitle($hGui, '', '��������� ��� ������������ ������ ������')
        GUICtrlSetState($iHorz, $GUI_HIDE) ; �������� �����
        Return
    EndIf
    If $iStep > $ainiSection[0] Then ; ��������� ����� ��� ������, ���������� ����� ��������
        Dim $aID[1] = [0]
        $ID_Start = 0 ; ���������� ID ��� ������� Switch -> Case �� ���������
        $ID_End = -3
        GUICtrlSetData($iBtnNext, '�����') ; ��������� ������ � ����� ������
        GUICtrlSetState($iBtnBack, $GUI_HIDE)
        Local $iCountAnswer = 0
        For $i = 1 To UBound($aiCountAnswer) - 1
            $iCountAnswer += $aiCountAnswer[$i][0]
        Next
;~         GUICtrlSetData($iQuestion, '���������� �������: ' & $iCountAnswer & ' �� ' & $ainiSection[0]) ; ��������� �������
		GUICtrlSetData($iQuestion, '���������� ������������: ') ; ��������� �������
        WinSetTitle($hGui, '', '���������')
        GUICtrlSetState($iHorz, $GUI_HIDE) ; �������� �����

        Return
    EndIf
    WinSetTitle($hGui, '', '������ ' & $iStep & ' �� ' & $ainiSection[0]) ; ����������� � ���������
    $aSectionQuestion = IniReadSection($ini, $ainiSection[$iStep]) ; ������ �������� �� ������
    If @error Or $aSectionQuestion[0][0] < 2 Then Return ; ����� ���� ����� ���������� ������ ������������
    Dim $aID[$aSectionQuestion[0][0]] = [$aSectionQuestion[0][0] - 1] ; ������������ ������� ��������������� �� ����� ��������
    $tmp = StringRegExp($aSectionQuestion[1][1], '(\d+?)\.(.*)', 1) ; ������� ������� � ������
    If @error Then ; ������ ������� ������ ������� � ������
        Dim $aID[1] = [0]
        $ID_Start = 0 ; ���������� ID ��� ������� Switch -> Case �� ���������
        $ID_End = -2
        GUICtrlSetData($iQuestion, '���������� ������') ; ��������� ������� �� ��������������
        Return
    EndIf
    $sCurAnswer = $tmp[0]
    GUICtrlSetData($iQuestion,  $tmp[1]) ; ��������� �������
    $y = 50
    For $i = 2 To $aSectionQuestion[0][0]
        $y += 22
        $aID[$i - 1] = GUICtrlCreateRadio($aSectionQuestion[$i][1], 13, $y, 590, 22) ; ��������� ��������� GUI
    Next
    $ID_Start = $aID[1] ; ���������� ID ��� ������� Switch -> Case ����������� �� ��������� ����������� ��������
    $ID_End = $aID[$aID[0]]
EndFunc   ;==>_StepGUI


Func _Vyvod_Resultatyov()
   
   			  $aArray=$MassivOtvetov
			   For $i = 0 To UBound($aArray) - 1
				   MsgBox(4096, "����=2",   "$aArray[" & $i & "] = " & $aArray[$i])
				Next
				
EndFunc   ;==>_Vyvod_Resultatyov