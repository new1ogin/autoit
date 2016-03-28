#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=icon.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=FTP Client on AutoIt v1.4
#AutoIt3Wrapper_Res_Fileversion=1.4
#AutoIt3Wrapper_Res_Language=1049
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#cs ----------------------------------------------------------------------------

	AutoIt Version: 3.3.6.1
	Author:         Sky-WaLkeR

	Script Function: FTP Client for Windows based on AutoIt.
	Thanks to all who helped me with _FTP... functions!
	Forum page - http://autoit-script.ru/index.php?topic=3870

#ce ----------------------------------------------------------------------------

#include <ButtonConstants.au3>
#include <EditConstants.au3>
#include <WindowsConstants.au3>
#include <myFTPEx.au3>
#include <GUIListbox.au3>
#include <GuiStatusBar.au3>
#include <String.au3>
#include <Array.au3>

#Region ���������� ����������
Local $StatusBar_parts_array[3] = [100, 350, -1]
Local $StatusBar_text_array[3] = ['������.', 'FTP Client on AutoIt', 'www.autoit-script.ru']
$username_startup = ''
$password_startup = ''
$ip_startup = ''
$username_checked = 0
$password_checked = 0
$passive_checked = 0
$ip_checked = 0
$i_refresh_count = 1
#EndRegion ���������� ����������

#Region ���� ����������� - �������������
$reg_remember_username_confirm = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberUsername')
If $reg_remember_username_confirm = 1 Then
	$username_checked = 1
	$username_startup = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Username')
EndIf
$reg_remember_password_confirm = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberPassword')
If $reg_remember_password_confirm = 1 Then
	$password_checked = 1
	$password_startup = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Password')
	$password_startup = _StringEncrypt ( 0, $password_startup,'FTP Client pass 7359428 OoO',1)
EndIf
$reg_remember_ip_confirm = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberIP')
If $reg_remember_ip_confirm = 1 Then
	$ip_checked = 1
	$ip_startup = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'IpAddress')
EndIf
$reg_remember_passive = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Passive')
If $reg_remember_passive = 1 Then
	$passive_checked = 1
EndIf
#EndRegion ���� ����������� - �������������

#Region ### START Koda GUI section ### Login
$Form1 = GUICreate("FTP Server Client on AutoIt- Login", 277, 232, 413, 185)
$Label1 = GUICtrlCreateLabel("FTP Server Client on AutoIt v1.4", 8, 8, 246, 17)
$user_name_field = GUICtrlCreateInput($username_startup, 8, 96, 257, 21)
GUICtrlSetTip(-1, "������� ���� ��� ������������ (�����).")
$Label2 = GUICtrlCreateLabel("��� ������������", 8, 80, 100, 15)
$Label3 = GUICtrlCreateLabel("������ (�����������)", 8, 120, 117, 15)
$user_pass_field = GUICtrlCreateInput($password_startup, 8, 136, 257, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
GUICtrlSetTip(-1, "������� ���� ������.")
$login = GUICtrlCreateButton("����� �� ������", 8, 200, 259, 25, $WS_GROUP)
GUICtrlSetTip(-1, "����� �� ������, ��������� ��������� ������.")
$remember_name = GUICtrlCreateCheckbox("��������� ���", 8, 160, 113, 17)
GUICtrlSetTip(-1, "��� ������������ ����������, � ��� �� �������� ������ ��� � ��������� ���. ����� ��������� � ����������.")
$remember_pass = GUICtrlCreateCheckbox("��������� ������", 128, 160, 137, 17)
GUICtrlSetTip(-1, "������ ����������, � ��� �� �������� ������ ��� � ��������� ���. �������� � ������������� ����. ����� ��������� � ����������.")
$Label4 = GUICtrlCreateLabel("IP �����", 8, 24, 47, 15)
$ip_address_field = GUICtrlCreateInput($ip_startup, 8, 40, 257, 21)
GUICtrlSetTip(-1, "������� ���� IP-����� �������..")
$remember_ip = GUICtrlCreateCheckbox("��������� IP �����", 8, 64, 145, 17)
GUICtrlSetTip(-1, "IP-����� ����������, � ��� �� �������� ������ ��� � ��������� ���. ����� ��������� � ����������.")
$Checkbox_passive = GUICtrlCreateCheckbox("��������� �����", 8, 176, 257, 17)
GUICtrlSetTip(-1, "����������� ����� ����������� �� ���������. ����� ��� ��������� FTP-��������, �� �������������� �������� ����� ����������.")
GUISetState(@SW_SHOW)
If $username_checked = 1 Then GUICtrlSetState($remember_name, $GUI_CHECKED)
If $password_checked = 1 Then GUICtrlSetState($remember_pass, $GUI_CHECKED)
If $ip_checked = 1 Then GUICtrlSetState($remember_ip, $GUI_CHECKED)
If $passive_checked = 1 Then GUICtrlSetState($Checkbox_passive, $GUI_CHECKED)
#EndRegion ### END Koda GUI section ### Login

; ����� - ���� ����� ����� ����������, �������� ���� � ���� ������ �����. ����, �� �������� ))
$check = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'AutoLogin')
If $check = 1 Then
	WinSetTrans("FTP Server Client on AutoIt- Login", '', 0)
	ControlClick("FTP Server Client on AutoIt- Login", '', '[CLASS:Button; INSTANCE:1]')
EndIf

While 1
	$nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE ; ������� �� ���� ������
			Exit
		Case $login ; ������ ����� �� ������
			$user_name = GUICtrlRead($user_name_field) ; ������ ��� � ������ � �������
			$user_pass = GUICtrlRead($user_pass_field)
			If GUICtrlRead($remember_name) = 1 Then ; ���� ����� ��������� ���
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberUsername', 'REG_SZ', '1')
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Username', 'REG_SZ', $user_name)
			Else
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberUsername', 'REG_SZ', '0')
			EndIf
			If GUICtrlRead($remember_pass) = 1 Then ; ���� ����� ��������� ������
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberPassword', 'REG_SZ', '1')
				$user_pass_encoded = _StringEncrypt ( 1, $user_pass,'FTP Client pass 7359428 OoO',1)
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Password', 'REG_SZ', $user_pass_encoded)
			Else
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberPassword', 'REG_SZ', '0')
			EndIf
			If GUICtrlRead($remember_ip) = 1 Then ; ���� ����� ��������� �����
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberIP', 'REG_SZ', '1')
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'IpAddress', 'REG_SZ', GUICtrlRead($ip_address_field))
			Else
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberIP', 'REG_SZ', '0')
			EndIf
			If GUICtrlRead($Checkbox_passive) = 1 Then ; ���� ����� ��������� �����
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Passive', 'REG_SZ', '1')
				$connect_type = 1
			Else
				RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Passive', 'REG_SZ', '0')
				$connect_type = 0
			EndIf

			$ftp_session = _FTP_Open("FTP Client on AutoIt") ; ��������� ������
			If @error Then
				MsgBox(0, 'FTP Server Client on AutoIt', '������ �����! ���������� ����������� �����.')
			Else
				$ftp_server_ip = GUICtrlRead($ip_address_field) ; ������ �����
				$ftp_session_connect = _FTP_Connect($ftp_session, $ftp_server_ip, $user_name, $user_pass, $connect_type) ; ������������
				If @error Then
					MsgBox(0, 'FTP Server Client on AutoIt', '������ �����! ���������� ����������� �����.')
					Exit
				EndIf
				GUIDelete($Form1) ; ������� ���� ������

;~ 				������� ���� ������������

				$Form2 = GUICreate("FTP Server Client on AutoIt", 469, 448, 263, 157)
				$Label1 = GUICtrlCreateLabel("����� � ����� �� �������:", 8, 8, 145, 17)
				$list = GUICtrlCreateList("", 8, 40, 449, 266, BitOR($LBS_DISABLENOSCROLL, $WS_BORDER, $WS_HSCROLL, $WS_VSCROLL))
				GUICtrlSetData(-1, "")
				$ftp_file_download = GUICtrlCreateButton("������� ����", 8, 312, 147, 25, $WS_GROUP)
				GUICtrlSetTip(-1, "������� ���� � ������� �� ���� ���������.")
				$ftp_file_upload = GUICtrlCreateButton("�������� ����", 160, 312, 147, 25, $WS_GROUP)
				GUICtrlSetTip(-1, "�������� ���� �� ������ ���������� �� ������.")
				$ftp_file_delete = GUICtrlCreateButton("������� ����", 312, 312, 147, 25, $WS_GROUP)
				GUICtrlSetTip(-1, "������� ���� � �������.")
				$disconnect = GUICtrlCreateButton("����������� � �����", 240, 400, 219, 25, $WS_GROUP)
				GUICtrlSetTip(-1, "��������� ���������� � ����� �� ���������.")
				$settings = GUICtrlCreateButton("���������", 8, 400, 219, 25, $WS_GROUP)
				GUICtrlSetTip(-1, "��������� ���������.")
				$refresh = GUICtrlCreateButton("��������", 8, 344, 147, 25, $WS_GROUP)
				GUICtrlSetTip(-1, "�������� ������ ������.")
				$file_md = GUICtrlCreateButton("������� �����", 160, 344, 146, 25, $WS_GROUP)
				GUICtrlSetTip(-1, "������� ����� �� �������.")
				$file_rd = GUICtrlCreateButton("������� �����", 312, 344, 146, 25, $WS_GROUP)
				GUICtrlSetTip(-1, "������� ����� �� �������.")
				$StatusBar = _GUICtrlStatusBar_Create($Form2, $StatusBar_parts_array, $StatusBar_text_array)
				$button_cd_back = GUICtrlCreateButton("�� ������� �����", 8, 24, 219, 17, BitOR($BS_FLAT, $WS_GROUP))
				GUICtrlSetTip(-1, "��������� � ���������� �����.")
				$button_cd = GUICtrlCreateButton("������� � �����", 232, 24, 227, 17, $WS_GROUP)
				GUICtrlSetTip(-1, "������� � ���������� �����.")
;~ 				������� ����������� ���� �� �������� ListView
				$contextmenu = GUICtrlCreateContextMenu()
				$list_context = GUICtrlCreateContextMenu($list)
				$context_ftp_folder_cd = GUICtrlCreateMenuItem("������� � �����", $list_context)
				$context_ftp_folder_cd_back = GUICtrlCreateMenuItem("������� �� ������� �����", $list_context)
				$context_ftp_folder_md = GUICtrlCreateMenuItem("������� �����", $list_context)
				$context_ftp_folder_rd = GUICtrlCreateMenuItem("������� �����", $list_context)
				$context_separator = GUICtrlCreateMenuItem("", $list_context)
				$context_ftp_file_upload = GUICtrlCreateMenuItem("�������� ����", $list_context)
				$context_ftp_file_download = GUICtrlCreateMenuItem("������� ����", $list_context)
				$context_ftp_file_delete = GUICtrlCreateMenuItem("������� ����", $list_context)

				GUISetState(@SW_SHOW)
;~ 				����� ��� �����������
;~              ���������� ����� ������
				$ftp_dir_list = _FTP_ListToArrayEx($ftp_session_connect, 0, $INTERNET_FLAG_RELOAD)
				$i = 1
				While 1
					$i = $i + 1
					If Not IsArray($ftp_dir_list) Then ExitLoop
					If $i = $ftp_dir_list[0][0] + 1 Then ExitLoop
					$string = $ftp_dir_list[$i][0]
					If $ftp_dir_list[$i][2] = 16 Then $string = '[�����] ' & $string
					GUICtrlSetData($list, $string)
				WEnd
				_GUICtrlListBox_SetCurSel($list, 0)
;~              ���������� ����� � ������� �����
				While 1 ; ���� ����-������������
					$nMsg = GUIGetMsg()
					Switch $nMsg
						Case $GUI_EVENT_CLOSE
							Exit
						Case $disconnect
							_FTP_Close($ftp_session)
							Exit
						Case $refresh
							my_Ftp_List_Update()
						Case $ftp_file_upload
							_GUICtrlStatusBar_SetText($StatusBar, "���������...", 0)
							my_FTP_File_Upload()
							_GUICtrlStatusBar_SetText($StatusBar, "������.", 0)
						Case $context_ftp_file_upload
							_GUICtrlStatusBar_SetText($StatusBar, "���������...", 0)
							my_FTP_File_Upload()
							_GUICtrlStatusBar_SetText($StatusBar, "������.", 0)
						Case $ftp_file_download
							_GUICtrlStatusBar_SetText($StatusBar, "��������...", 0)
							my_FTP_File_Download()
							_GUICtrlStatusBar_SetText($StatusBar, "������.", 0)
						Case $context_ftp_file_download
							_GUICtrlStatusBar_SetText($StatusBar, "��������...", 0)
							my_FTP_File_Download()
							_GUICtrlStatusBar_SetText($StatusBar, "������.", 0)
						Case $ftp_file_delete
							my_FTP_File_Delete()
						Case $context_ftp_file_delete
							my_FTP_File_Delete()
						Case $context_ftp_folder_cd
							my_FTP_Change_Dir()
							my_Ftp_List_Update()
						Case $context_ftp_folder_cd_back
							my_FTP_Change_Dir_Back()
							my_Ftp_List_Update()
						Case $button_cd
							my_FTP_Change_Dir()
							my_Ftp_List_Update()
						Case $button_cd_back
							my_FTP_Change_Dir_Back()
							my_Ftp_List_Update()
						Case $settings
							my_Settings()
						Case $file_md
							my_FTP_DirCreate()
							my_Ftp_List_Update()
						Case $context_ftp_folder_md
							my_FTP_DirCreate()
							my_Ftp_List_Update()
						Case $file_rd
							my_FTP_DirDelete()
							my_Ftp_List_Update()
						Case $context_ftp_folder_rd
							my_FTP_DirDelete()
							my_Ftp_List_Update()
					EndSwitch
				WEnd
			EndIf
	EndSwitch
WEnd


Func my_Ftp_List_Update()
	_GUICtrlListBox_ResetContent($list)
	$ftp_dir_list = _FTP_ListToArrayEx($ftp_session_connect, 0, $INTERNET_FLAG_RELOAD)
	$i = 0
	If Not IsArray($ftp_dir_list) = 0 Then
		While 1
			$i = $i + 1
			If $i = $ftp_dir_list[0][0] + 1 Then ExitLoop
			$string = $ftp_dir_list[$i][0]
			If $ftp_dir_list[$i][2] = 16 Then $string = '[�����] ' & $string
			GUICtrlSetData($list, $string)
		WEnd
	Else
		GUICtrlSetData($list, '��� ������.')
	EndIf
	_GUICtrlListBox_SetCurSel($list, 0)
EndFunc   ;==>my_Ftp_List_Update
Func my_FTP_File_Upload()
	$def_dir = @DesktopDepth
	$file_local = FileOpenDialog('������ ����', $def_dir, '�� ����� ����� (*.*)')
	If Not $file_local = '' Then
		$file_path_array = StringSplit($file_local, '\')
		_ArrayReverse($file_path_array)
		$file_remote = InputBox('�������� �����', '������ ������� ��� ����� �� �������', $file_path_array[0])
		If Not $file_remote = '' Then
			_FTP_ProgressUpload($ftp_session_connect, $file_local, $file_remote)
		EndIf
	EndIf
	my_Ftp_List_Update()
EndFunc   ;==>my_FTP_File_Upload
Func my_FTP_File_Download()
	$file_remote = _GUICtrlListBox_GetCurSel($list)
	$file_remote = _GUICtrlListBox_GetText($list, $file_remote)
	If Not $file_remote = 0 Then
		$confirm = MsgBox(BitOR(32, 4), '�������������', '������� ���� ' & $file_remote & ' ?')
		If $confirm = 6 Then
			$def_dir = @DesktopDepth
			$file_local = FileSaveDialog("������ ���� ���������", $def_dir, "�� ����� (*.*)", 16, $file_remote)
			If Not $file_local = '' Then
				_FTP_ProgressDownload($ftp_session_connect, $file_local, $file_remote)
			EndIf
		EndIf
	EndIf
EndFunc   ;==>my_FTP_File_Download
Func my_FTP_File_Delete()
	$file_remote = _GUICtrlListBox_GetCurSel($list)
	$file_remote = _GUICtrlListBox_GetText($list, $file_remote)
	If Not $file_remote = 0 Then
		$confirm = MsgBox(BitOR(32, 4), '�������������', '������� ���� "' & $file_remote & '" � FTP-�������?')
		If $confirm = 6 Then
			_FTP_FileDelete($ftp_session_connect, $file_remote)
			my_Ftp_List_Update()
		EndIf
	EndIf
EndFunc   ;==>my_FTP_File_Delete
Func my_FTP_Change_Dir_Back()
	$sDir = _FTP_DirGetCurrent($ftp_session_connect)
	_FTP_DirSetCurrent($ftp_session_connect, '..')
EndFunc   ;==>my_FTP_Change_Dir_Back
Func my_FTP_Change_Dir()
	$dir_remote = _GUICtrlListBox_GetCurSel($list)
	$dir_remote = _GUICtrlListBox_GetText($list, $dir_remote)
	If StringInStr($dir_remote, '[�����]') Then
		$dir_name = StringTrimLeft($dir_remote, 8)
		_GUICtrlListBox_ResetContent($list)
		_FTP_DirSetCurrent($ftp_session_connect, $dir_name)
	EndIf
EndFunc   ;==>my_FTP_Change_Dir
Func my_FTP_DirCreate()
	$dir_name = InputBox('�������� �����', '������ ������� ��� ����� �� �������', '����� �����')
	If Not $dir_name = '' Then
		_FTP_DirCreate($ftp_session_connect, _FTP_DirGetCurrent($ftp_session_connect) & '\' & $dir_name)
	EndIf
EndFunc   ;==>my_FTP_DirCreate
Func my_FTP_DirDelete()
	$dir_remote = _GUICtrlListBox_GetCurSel($list)
	$dir_remote = _GUICtrlListBox_GetText($list, $dir_remote)
	If Not $dir_remote = 0 And StringInStr($dir_remote, '[�����]') = 1 Then
		$dir_remote = StringTrimLeft($dir_remote, 8)
		$confirm = MsgBox(BitOR(32, 4), '�������������', '������� ����� "' & $dir_remote & '" � FTP-�������?')
		If $confirm = 6 Then
			$dir_remote = _FTP_DirGetCurrent($ftp_session_connect) & '\' & $dir_remote
			_FTP_DirDelete($ftp_session_connect, $dir_remote)
		EndIf
	EndIf
EndFunc   ;==>my_FTP_DirDelete

Func my_Settings() ; ��������� - ����
	WinSetState("FTP Server Client on AutoIt", '', @SW_HIDE)
	$form_settings = GUICreate("���������", 309, 365, 192, 124)
	$sgroup_settings_main = GUICtrlCreateGroup("��������", 8, 16, 289, 193)
	$settings_remember_name = GUICtrlCreateCheckbox("���������� ���", 16, 32, 113, 17)
	GUICtrlSetTip(-1, "��� ������������ ����������, � ��� �� �������� ������ ��� � ��������� ���.")
	$settings_remember_pass = GUICtrlCreateCheckbox("���������� ������", 136, 32, 145, 17)
	GUICtrlSetTip(-1, "������ ����������, � ��� �� �������� ������ ��� � ��������� ���.�������� � ������������� ����.")
	$settings_remember_ip = GUICtrlCreateCheckbox("���������� IP-����� �������", 16, 48, 273, 17)
	GUICtrlSetTip(-1, "IP-����� ����������, � ��� �� �������� ����� ��� � ��������� ���.")
	$settings_auto_login = GUICtrlCreateCheckbox("������������ � ������� �����, ����� ��� � ������ �� �����������", 16, 72, 273, 25, BitOR($BS_CHECKBOX, $BS_AUTOCHECKBOX, $BS_MULTILINE, $WS_TABSTOP))
	$settings_new_name = GUICtrlCreateCheckbox("��������� ����� ���:", 16, 130, 129, 20)
	$settings_new_name_input = GUICtrlCreateInput("", 168, 128, 121, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$settings_new_ip = GUICtrlCreateCheckbox("��������� ����� IP", 16, 110, 145, 18)
	$settings_new_ip_input = GUICtrlCreateInput("", 168, 105, 121, 21)
	GUICtrlSetState(-1, $GUI_DISABLE)
	$settings_new_pass = GUICtrlCreateCheckbox("��������� ����� ������:", 16, 152, 145, 20)
	$settings_new_pass_input = GUICtrlCreateInput("", 168, 150, 121, 21, BitOR($ES_PASSWORD, $ES_AUTOHSCROLL))
	GUICtrlSetState(-1, $GUI_DISABLE)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$settings_advanced = GUICtrlCreateGroup("�������������", 8, 216, 289, 97)
	$settings_passive = GUICtrlCreateCheckbox("������������ ��������� �����", 16, 240, 257, 17)
	GUICtrlSetTip(-1, "����������� ����� ����������� �� ���������. ����� ��� ��������� FTP-��������, �� �������������� �������� ����� ����������.")
	GUICtrlCreateLabel("��� ��������� ���� ��������� �� ������", 16, 256, 220, 17)
	GUICtrlCreateGroup("", -99, -99, 1, 1)
	$settings_button_ok = GUICtrlCreateButton("��", 8, 328, 131, 25, $WS_GROUP)
	$settings_button_cancel = GUICtrlCreateButton("������", 152, 328, 147, 25, $WS_GROUP)

	$check = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberUsername')
	If $check = 1 Then GUICtrlSetState($settings_remember_name, $GUI_CHECKED)
	$check = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberPassword')
	If $check = 1 Then GUICtrlSetState($settings_remember_pass, $GUI_CHECKED)
	$check = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'AutoLogin')
	If $check = 1 Then GUICtrlSetState($settings_auto_login, $GUI_CHECKED)
	$check = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberIp')
	If $check = 1 Then GUICtrlSetState($settings_remember_ip, $GUI_CHECKED)
	$check = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Username')
	GUICtrlSetData($settings_new_name_input, $check)
	$check = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'IpAddress')
	GUICtrlSetData($settings_new_ip_input, $check)
	$check = RegRead("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Passive')
	If $check = 1 Then GUICtrlSetState($settings_passive, $GUI_CHECKED)


	GUISetState(@SW_SHOW)
	While 1
		$nMsg = GUIGetMsg()
		Switch $nMsg
			Case $GUI_EVENT_CLOSE
				Exit
			Case $settings_button_cancel
				GUIDelete($form_settings)
				WinSetState("FTP Server Client on AutoIt", '', @SW_SHOW)
				ExitLoop
			Case $settings_new_name
				$check = GUICtrlRead($settings_new_name)
				If $check = 1 Then
					GUICtrlSetState($settings_new_name_input, $GUI_ENABLE)
				Else
					GUICtrlSetState($settings_new_name_input, $GUI_DISABLE)
				EndIf
			Case $settings_new_pass
				$check = GUICtrlRead($settings_new_pass)
				If $check = 1 Then
					GUICtrlSetState($settings_new_pass_input, $GUI_ENABLE)
				Else
					GUICtrlSetState($settings_new_pass_input, $GUI_DISABLE)
				EndIf
			Case $settings_new_ip
				$check = GUICtrlRead($settings_new_ip)
				If $check = 1 Then
					GUICtrlSetState($settings_new_ip_input, $GUI_ENABLE)
				Else
					GUICtrlSetState($settings_new_ip_input, $GUI_DISABLE)
				EndIf
			Case $settings_button_ok
				$check = GUICtrlRead($settings_new_name)
				If $check = 1 Then
					$new_name = GUICtrlRead($settings_new_name_input)
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Username', 'REG_SZ', $new_name)
				EndIf
				$check = GUICtrlRead($settings_new_pass)
				If $check = 1 Then
					$new_pass = _StringEncrypt ( 1, GUICtrlRead($settings_new_pass_input),'FTP Client pass 7359428 OoO',1)
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Password', 'REG_SZ', $new_pass)
				EndIf
				$check = GUICtrlRead($settings_remember_name)
				If $check = 1 Then
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberUsername', 'REG_SZ', '1')
				Else
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberUsername', 'REG_SZ', '0')
				EndIf
				$check = GUICtrlRead($settings_remember_pass)
				If $check = 1 Then
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberPassword', 'REG_SZ', '1')
				Else
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberPassword', 'REG_SZ', '0')
				EndIf
				$check = GUICtrlRead($settings_auto_login)
				If $check = 1 Then
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'AutoLogin', 'REG_SZ', '1')
				Else
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'AutoLogin', 'REG_SZ', '0')
				EndIf
				$check = GUICtrlRead($settings_remember_ip)
				If $check = 1 Then
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberIp', 'REG_SZ', '1')
				Else
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'RememberIp', 'REG_SZ', '0')
				EndIf
				$check = GUICtrlRead($settings_new_ip)
				If $check = 1 Then
					$new_ip = GUICtrlRead($settings_new_ip_input)
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'IpAddress', 'REG_SZ', $new_ip)
				EndIf
				$check = GUICtrlRead($settings_passive)
				If $check = 1 Then
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Passive', 'REG_SZ', '1')
				Else
					RegWrite("HKEY_CURRENT_USER\SOFTWARE\FTP Client on AutoIt", 'Passive', 'REG_SZ', '0')
				EndIf
				GUIDelete($form_settings)
				WinSetState("FTP Server Client on AutoIt", '', @SW_SHOW)
				ExitLoop
		EndSwitch
	WEnd
EndFunc   ;==>my_Settings
