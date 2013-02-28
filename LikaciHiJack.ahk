;LikaciHiJackConfig.ahk
; Author Likaci 
; http://www.xiazhiri.com
; xiazhiri[a]foxmail.com
Loop, %0%
{
	param := %A_Index%
	;MsgBox % param
	GetKeyState, ShiftPress, Shift, P
	;TrayTip, ,% param
	if param contains LikaciDefaultPro|
	{
		DefaultPro := param
		StringReplace,DefaultPro,DefaultPro,LikaciDefaultPro|,,All
		StringReplace,DefaultPro,DefaultPro,<,`%,All
		StringReplace,DefaultPro,DefaultPro,>,%A_Space%,All
		StringReplace,DefaultPro,DefaultPro,`%1,,All
		StringReplace,DefaultPro,DefaultPro,`%SystemRoot`%,C:\windows,All
		continue
	}
	if param contains LikaciHiJack|
	{
		if ShiftPress = U
			continue
		Config := param
		AnalyseConfig(Config)
		continue
	}
	TargetFile := param
	if ShiftPress = U
		run %DefaultPro% "%TargetFile%"
	else
		CreateGui()
}
Return

AnalyseConfig(Config){
	global
	StringReplace,Config,Config,LikaciHiJack|,,All
	StringSplit,ProArray,Config,|,|
Return
}

CreateGui(){
	global
	Loop %ProArray0%
	{
		Pro := ProArray%A_Index%
		StringSplit,ProNameArray,Pro,\
		ProName := ProNameArray%ProNameArray0%
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
