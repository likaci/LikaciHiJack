;LikaciHiJackConfig.ahk
; Author Likaci 
; http://www.xiazhiri.com
; xiazhiri[a]foxmail.com
SetWorkingDir %A_ScriptDir%

AskExtension() ;��ȡ��չ��
Return

AfterAskExtension(){ ;��ȡ��չ��֮��
	global
	if !Extension
		ExitApp
GetFileType()
GetConfig()
GetNewProList()
Return
}

AskExtension(){ ;ѯ����չ��
	global
	Gui New
	Gui,Add,Text,,��������չ��,����".",���� exe
	Gui,Add,Edit,w160 vExtension
	Gui,Add,button,xp+25 yp+25 Default,ȷ��
	Gui,Add,button,xp+55 yp,ȡ��
	Gui,Show
Return
buttonȷ��:
	Gui,Submit
	Gui,Destroy
	StringReplace,Extension,Extension,%A_Space%,,All
	StringReplace,Extension,Extension,",,All
	StringReplace,Extension,Extension,*,,All
	StringReplace,Extension,Extension,.,,All
	AfterAskExtension()
	Return
buttonȡ��:
GuiClose:
	ExitApp
	Return
}

GetFileType(){
	global
	RegRead,FileType,HKEY_CLASSES_ROOT,.%Extension%
		if ErrorLevel
		{
			traytip,ʧ��,��ȡ�ļ����ͳ���`n��չ��"%Extension%"��ȷ��
			sleep 3000
			ExitApp
		}
	RegRead,Command,HKEY_CLASSES_ROOT,%FileType%\shell\open\command
		if ErrorLevel
		{
			traytip,ʧ��,��ȡ�ļ����͵Ĵ򿪷�ʽ����`nHKEY_CLASSES_ROOT\%FileType%\shell\open\Command ʧ��
			sleep 3000
			ExitApp
		}
		else 
		{
			if Command contains LikaciHiJack.exe
				HiJack = 1
			else
				HiJack = 0
		}
		RegRead,DefaultPro,HKEY_CLASSES_ROOT,%FileType%\shell\open\LikaciHiJack,DefaultPro
		if ErrorLevel ;��ǰû�����й�
		{
			RegWrite,REG_EXPAND_SZ,HKEY_CLASSES_ROOT,%FileType%\shell\open\LikaciHiJack,DefaultPro,%Command%
			DefaultPro := Command
			EverHiJack = 0
			Return 1 
		}
		else
		{
			EverHiJack =1
		}
Return 1
}

GetConfig(){
	global
	
	;���˻�ȡ��Ĭ�ϴ򿪷�ʽ �� �Ƿ�ٳֹ�
	StringSplit,CommandArray,Command,%A_Space%,
	Loop % CommandArray0 ;ѭ������ ��ȡ �Ƿ�ٳ��ˡ���
	{
		if !CommandArray%A_Index%
			continue
		if CommandArray%A_Index% contains LikaciHiJack.exe
		{
			HiJack = 1 ;�ٳ�
			continue
		}
		if CommandArray%A_Index% contains LikaciDefaultPro|
		{
			LikaciDefaultPro := CommandArray%A_Index%
			StringReplace,LikaciDefaultPro,LikaciDefaultPro,LikaciDefaultPro|,,All
			StringReplace,LikaciDefaultPro,LikaciDefaultPro,",,All
			StringReplace,LikaciDefaultPro,LikaciDefaultPro,>,%A_Space%,All
			StringReplace,LikaciDefaultPro,LikaciDefaultPro,<,`%,All
			if HiJack
				if LikaciDefaultPro != %DefaultPro%
					DefaultPro := LikaciDefaultPro
			continue ;���� Ĭ�ϳ���
		}
		if CommandArray%A_Index% contains LikaciHiJack|
		{ ;�Ƿ��г���"�б�"
			LikaciHiJackList := CommandArray%A_Index%
			StringReplace,LikaciHiJackList,LikaciHiJackList,LikaciHiJack|,,All
			StringReplace,LikaciHiJackList,LikaciHiJackList,",,All
			StringReplace,LikaciHiJackList,LikaciHiJackList,>,%A_Space%,All
			StringReplace,LikaciHiJackList,LikaciHiJackList,<,`%,All
			StringReplace,LikaciHiJackList,LikaciHiJackList,|,`n,All
			continue
		}
		if command contains `%
		{
			Param := CommandArray%A_Index%
			continue
		}
	}
		if !LikaciHiJackList
		{
			RegRead,LikaciHiJackList,HKEY_CLASSES_ROOT,%FileType%\shell\open\LikaciHiJack,LikaciHiJack
			StringReplace,LikaciHiJackList,LikaciHiJackList,LikaciHiJack|,,All
			StringReplace,LikaciHiJackList,LikaciHiJackList,",,All
			StringReplace,LikaciHiJackList,LikaciHiJackList,>,%A_Space%,All
			StringReplace,LikaciHiJackList,LikaciHiJackList,<,`%,All
			StringReplace,LikaciHiJackList,LikaciHiJackList,|,`n,All
		}
	Return 1
}

GetNewProList(){
	global
	Gui New
	;Gui,Add,Picture,%DefaultIcon%
	Gui,Add,Text,x12 y12,��չ��  : %Extension%
	Gui,Add,Text,yp+18,�ļ�����: %FileType%
	if HiJack
		Gui,Add,Text,yp+18,�ٳ����: *��*�ٳ�
	else
		Gui,Add,Text,yp+18,�ٳ����: *δ*�ٳ�
	Gui,Add,Text,yp+18,ϵͳĬ�ϳ���:`n%DefaultPro%
	Gui,Add,Text,,Ҫѡ��ĳ���*·��*�����·���ÿ��һ��
	Gui,Add,Edit,w300 r5 vLikaciHiJackList,%LikaciHiJackList%
	gui,Add,button,xp+10 y+10,�ٳ�
	gui,Add,button,xp+60 ,����ٳ�
	gui,Add,button,xp+80 ,ȡ��
	Gui Show
Return
button�ٳ�:
	Gui,Submit
	;��ʼ��������б�
	StringReplace,LikaciHiJackList,LikaciHiJackList,`n,|,All
	StringReplace,LikaciHiJackList,LikaciHiJackList,%A_Space%,>,All
	StringReplace,LikaciHiJackList,LikaciHiJackList,`%,<,All
	LikaciHiJackList = "LikaciHiJack|%LikaciHiJackList%"
	Loop
	{
		if LikaciHiJackList not contains ||
			break
		StringReplace,LikaciHiJackList,LikaciHiJackList,||,|,All
	}
	RegWrite,REG_EXPAND_SZ,HKEY_CLASSES_ROOT,%FileType%\shell\open\LikaciHiJack,LikaciHiJack,%LikaciHiJackList%
	;��������б����
	LikaciHiJackPath = "%A_WorkingDir%\LikaciHiJack.exe"
	IfNotExist LikaciHiJack.exe
	{
		traytip,ʧ��,��ȷ�� LikaciHiJack.exe ��LikaciHiJackConfig.exe ��ͬһĿ¼��
		Sleep 3000
		ExitApp
	}
	StringReplace,DefaultProInReg,DefaultPro,%A_Space%,>,All
	StringReplace,DefaultProInReg,DefaultProInReg,`%,<,All
	DefaultProInReg = "LikaciDefaultPro|%DefaultProInReg%"
	;����DefaultProInReg ����
	Command=%LikaciHiJackPath% %DefaultProInReg% %LikaciHiJackList% "`%1"
	;MsgBox % command
	RegWrite,REG_EXPAND_SZ,HKEY_CLASSES_ROOT,%FileType%\shell\open\command,,%Command%
		if ErrorLevel
			traytip,�ٳ�ʧ��,���� HKEY_CLASSES_ROOT\%FileType%\shell\open\command д������ʱ����
		else
			traytip,�ٳֳɹ�,��չ��: *.%Extension% ����: %FileType% �ٳֳɹ���
		Sleep 3000
		ExitApp
	Return

	button����ٳ�:
		Gui,Destroy
			if !HiJack
				traytip,��ѽ��ѽ,û�нٳֹ� ��չ��*.%Extension% ����%FileType%������ж�ء�
		RegWrite,REG_EXPAND_SZ,HKEY_CLASSES_ROOT,%FileType%\shell\open\command,,%DefaultPro%
			if !ErrorLevel
				traytip,����ɹ�,����ٳ� ��չ��*.%Extension% ����%FileType% ���ļ���
		Sleep 3000
		ExitApp
	Return
}


