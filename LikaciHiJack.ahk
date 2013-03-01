;LikaciHiJackConfig.ahk
; Author Likaci 
; http://www.xiazhiri.com
; xiazhiri[a]foxmail.com
Loop, %0%
{
	param := %A_Index%
	GetKeyState, ShiftPress, Shift, P
	;获取默认程序 / get the default pro
	;以下脚本中,凡是作为作为参数传递过来的,%由<代替 空格由>代替 / in this script , all the prame's "%" is replaced by "<" -n- "space" by ">"
	if param contains LikaciDefaultPro|
	{
		DefaultPro := param
		StringReplace,DefaultPro,DefaultPro,LikaciDefaultPro|,,All
		StringReplace,DefaultPro,DefaultPro,<,`%,All
		StringReplace,DefaultPro,DefaultPro,>,%A_Space%,All
		StringReplace,DefaultPro,DefaultPro,`%1,,All
		StringReplace,DefaultPro,DefaultPro,`%SystemRoot`%,C:\windows,All, ;replace %sysroot% by c:\win
		continue
	}
	if param contains LikaciHiJack|
	{	;获取弹出菜单里的程序列表 / get the program list shown in the popmenu
		;如果安住shift 那么跳出这个参数
		if ShiftPress = U
			continue
		Config := param
		AnalyseConfig(Config)
		;分析config / analyse the config to list
		continue
	}
	;获取完前面的参数之后，剩下的就作为真是的参数了 / after got previous two params get the target objet to open
	TargetFile := param
	;如果没有安装shift 创建弹出菜单 否则直接运行 / if the shift key pressed create a popmenu
	if ShiftPress = U
		run %DefaultPro% "%TargetFile%"
	else
		CreateGui()
}
Return

AnalyseConfig(Config){ ;分析字段，得到列表 / get the program list
	global
	StringReplace,Config,Config,LikaciHiJack|,,All
	StringSplit,ProArray,Config,|,|
Return
}

CreateGui(){
	global
	;循环解析字段,创建菜单 / creat the popmenu
	Loop %ProArray0%
	{
		Pro := ProArray%A_Index%
		StringSplit,ProNameArray,Pro,\
		ProName := ProNameArray%ProNameArray0%
		;注意后面的MenuRun / pay attention to MenuRun
		Menu, LikaciLaunchMenu, Add, %ProName%, MenuRun
		Menu, LikaciLaunchMenu, Icon, %ProName%,%Pro%,0
	}
	Menu, LikaciLaunchMenu, Show
Return
}

MenuRun:
	loop %ProArray0%
	{
		Pro := ProArray%A_Index%
		IfInString,Pro,%A_ThisMenuItem%
		break
	}
	run %Pro% "%TargetFile%"
return
