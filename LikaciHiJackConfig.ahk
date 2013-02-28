;LikaciHiJackConfig.ahk
; Author Likaci 
; http://www.xiazhiri.com
; xiazhiri[a]foxmail.com
SetWorkingDir %A_ScriptDir%

AskExtension() ;获取拓展名
Return

AfterAskExtension(){ ;获取拓展名之后
	global
	if !Extension
		ExitApp
GetFileType()
GetConfig()
GetNewProList()
Return
}

AskExtension(){ ;询问拓展名
	global
	Gui New
	Gui,Add,Text,,请输入拓展名,不含".",例如 exe
	Gui,Add,Edit,w160 vExtension
	Gui,Add,button,xp+25 yp+25 Default,确定
	Gui,Add,button,xp+55 yp,取消
	Gui,Show
Return
button确定:
	Gui,Submit
	Gui,Destroy
	StringReplace,Extension,Extension,%A_Space%,,All
	StringReplace,Extension,Extension,",,All
	StringReplace,Extension,Extension,*,,All
	StringReplace,Extension,Extension,.,,All
	AfterAskExtension()
	Return
button取消:
GuiClose:
	ExitApp
	Return
}

GetFileType(){
	global
	RegRead,FileType,HKEY_CLASSES_ROOT,.%Extension%
		if ErrorLevel
		{
			traytip,失败,获取文件类型出错！`n拓展名"%Extension%"正确吗？
			sleep 3000
			ExitApp
		}
	RegRead,Command,HKEY_CLASSES_ROOT,%FileType%\shell\open\command
		if ErrorLevel
		{
			traytip,失败,获取文件类型的打开方式出错`nHKEY_CLASSES_ROOT\%FileType%\shell\open\Command 失败
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
		if ErrorLevel ;以前没有运行过
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
	
	;至此获取完默认打开方式 和 是否劫持过
	StringSplit,CommandArray,Command,%A_Space%,
	Loop % CommandArray0 ;循环解析 获取 是否劫持了……
	{
		if !CommandArray%A_Index%
			continue
		if CommandArray%A_Index% contains LikaciHiJack.exe
		{
			HiJack = 1 ;劫持
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
			continue ;跳过 默认程序
		}
		if CommandArray%A_Index% contains LikaciHiJack|
		{ ;是否有程序“"列表"
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
	Gui,Add,Text,x12 y12,拓展名  : %Extension%
	Gui,Add,Text,yp+18,文件类型: %FileType%
	if HiJack
		Gui,Add,Text,yp+18,劫持情况: *已*劫持
	else
		Gui,Add,Text,yp+18,劫持情况: *未*劫持
	Gui,Add,Text,yp+18,系统默认程序:`n%DefaultPro%
	Gui,Add,Text,,要选择的程序*路径*填入下方，每行一个
	Gui,Add,Edit,w300 r5 vLikaciHiJackList,%LikaciHiJackList%
	gui,Add,button,xp+10 y+10,劫持
	gui,Add,button,xp+60 ,解除劫持
	gui,Add,button,xp+80 ,取消
	Gui Show
Return
button劫持:
	Gui,Submit
	;开始处理程序列表
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
	;处理程序列表结束
	LikaciHiJackPath = "%A_WorkingDir%\LikaciHiJack.exe"
	IfNotExist LikaciHiJack.exe
	{
		traytip,失败,请确保 LikaciHiJack.exe 和LikaciHiJackConfig.exe 在同一目录。
		Sleep 3000
		ExitApp
	}
	StringReplace,DefaultProInReg,DefaultPro,%A_Space%,>,All
	StringReplace,DefaultProInReg,DefaultProInReg,`%,<,All
	DefaultProInReg = "LikaciDefaultPro|%DefaultProInReg%"
	;处理DefaultProInReg 结束
	Command=%LikaciHiJackPath% %DefaultProInReg% %LikaciHiJackList% "`%1"
	;MsgBox % command
	RegWrite,REG_EXPAND_SZ,HKEY_CLASSES_ROOT,%FileType%\shell\open\command,,%Command%
		if ErrorLevel
			traytip,劫持失败,在向 HKEY_CLASSES_ROOT\%FileType%\shell\open\command 写入数据时出错！
		else
			traytip,劫持成功,拓展名: *.%Extension% 类型: %FileType% 劫持成功！
		Sleep 3000
		ExitApp
	Return

	button解除劫持:
		Gui,Destroy
			if !HiJack
				traytip,哎呀妈呀,没有劫持过 拓展名*.%Extension% 类型%FileType%，无需卸载。
		RegWrite,REG_EXPAND_SZ,HKEY_CLASSES_ROOT,%FileType%\shell\open\command,,%DefaultPro%
			if !ErrorLevel
				traytip,解除成功,解除劫持 拓展名*.%Extension% 类型%FileType% 的文件。
		Sleep 3000
		ExitApp
	Return
}


