#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%
CoordMode Mouse,Screen
SetControlDelay -1
SendMode  Input
p:=0
RowNumber:=0
Gui Add, Text, x16 y8, Button:
Gui Add, DropDownList, x81 y5 w120 vModeClick, Left||Middle|Right
Gui Add, Text, x215 y8 ,Hotkey:
Gui Add, Hotkey, x260 y5 w120 h21 vHotkey
Gui Add, Text, x16 y32 w60 h23 +0x200, Count:
Gui Add, Edit, x81 y34 w65 h21 number vCount,
Gui Add, UpDown, x128 y32 w18 h21, 1
Gui Add, Text, x215 y36 w60 h23 , WinKey:
Gui,Add, CheckBox, x260 y36 vCB
Gui Add, ListView, x16 y62 w391 h150 vMyListView, Hotkey |     X     |     Y     |  Button  |  Count
Gui Add, Button, x240 y218 w80 h23 gSave , Save
Gui Add, Button, x328 y218 w80 h23 gDellList, Delete
Gui Add, Button, x15 y218 w80 h23 gHelp, Help
Gui Show, , KeyToClick v1.3
Menu, MyContextMenu, Add, Delete, Delete
Menu, MyContextMenu, Add, Delete List, DellList
Menu, Tray, NoStandard 
Menu, Tray, Click, 1
Menu, Tray, Add, Pause, Pause_Unpause
Menu, Tray, Default, Pause

Menu, Tray, MainWindow
Menu, Tray, Add, Show, Show
Menu, Tray, Add, Hide, GuiClose
Menu, Tray, Add, Exit, Exit
Gui,Submit,Nohide

IniRead, Saved, KeyToClick.ini,Total,Total
Loop,%Saved%
{
	IniRead, Hotkey,    KeyToClick.ini, Hotkey,  %A_Index%
	IniRead, X, 		KeyToClick.ini, X, 		 %A_Index%
	IniRead, Y, 		KeyToClick.ini, Y, 		 %A_Index%
	IniRead, ModeClick, KeyToClick.ini, Button,  %A_Index%
	IniRead, Count,		KeyToClick.ini, Count,	 %A_Index%
	LV_Add("",Hotkey,X,Y,ModeClick,Count)
	RowNumber++
}
Loop % LV_GetCount()
	{
		LV_GetText(Temp,A_Index,1)
		Hotkey,%Temp%,Label%A_Index%,On
	}
return

F2::
Gui,Submit,Nohide
if (Hotkey<>""||CB)
if (RowNumber<50)
{
Gui,Submit,Nohide
MouseGetPos,X,Y
if CB
Hotkey:= "#" Hotkey
Loop % LV_GetCount()
{
LV_GetText(duplicate,A_Index,1)
if(Hotkey=duplicate)
Return
}
LV_Add("",Hotkey,X,Y,ModeClick,Count)
LV_ModifyCol(1,Auto)
RowNumber++
LV_GetText(Temp,RowNumber,1)
Hotkey,%Temp%,Label%RowNumber%,On

}
return

Save:
IniRead, Saved, KeyToClick.ini,Hotkey
if Saved 
{
MsgBox, 4,, Will overwrite KeyToClick.ini? 
IfMsgBox Yes
	Gosub Overwrite
}
else
Gosub Overwrite
Return

Action(Row)
{
	Loop,5
	LV_GetText(Data_%A_Index%,Row,A_Index)
	MouseGetPos,curX,curY
	MouseClick,%Data_4%,%Data_2%,%Data_3%,%Data_5%,0,,
	MouseMove,%curX%,%curY%
	
}
Return

Overwrite:
{
IniDelete,KeyToClick.ini,Hotkey
IniDelete,KeyToClick.ini,X
IniDelete,KeyToClick.ini,Y
IniDelete,KeyToClick.ini,Button
IniDelete,KeyToClick.ini,Count
	Loop % LV_GetCount()
	{
		LV_GetText(temp,A_Index,1)
		IniWrite,%temp%,KeyToClick.ini,Hotkey,%A_Index%
		LV_GetText(temp,A_Index,2)
		IniWrite,%temp%,KeyToClick.ini,X,%A_Index%
		LV_GetText(temp,A_Index,3)
		IniWrite,%temp%,KeyToClick.ini,Y,%A_Index%
		LV_GetText(temp,A_Index,4)
		IniWrite,%temp%,KeyToClick.ini,Button,%A_Index%
		LV_GetText(temp,A_Index,5)
		IniWrite,%temp%,KeyToClick.ini,Count,%A_Index%
	}
temp := LV_GetCount()
IniWrite,%temp%,KeyToClick.ini,Total,Total
}
Return

GuiContextMenu:
if A_GuiControl <> MyListView
  return
Menu, MyContextMenu, Show, %A_GuiX%, %A_GuiY%
return

DellList:
Loop % LV_GetCount()
{
	LV_GetText(Temp,A_Index,1)
	Hotkey,%Temp%,Off

}
	Count:=LV_GetCount()
	LV_Delete()
	RowNumber:=0
return

Delete:
	DeleteRow:=LV_GetNext([1, "Checked | Focused"])
	LV_GetText(Temp,DeleteRow,1)
	Hotkey,%Temp%,off
	LV_Delete(DeleteRow)
	RowNumber--
	Loop % LV_GetCount()
	{
		LV_GetText(Temp,A_Index,1)
		Hotkey,%Temp%,Label%A_Index%,On
	}
Return

Show:
Gui,Show
Return

MainWindow:
Gui,Show
Return


Pause_Unpause:
Suspend
if (p = 0)
{
	p:=1
	Menu,Tray,Rename,Pause,Unpause
	Return
}

if (p = 1)
{
	p:=0
	Menu,Tray,Rename,Unpause,Pause
	Return
}

GuiEscape:
GuiClose:
Gui,Hide
 Return
 
Help:
About=
(
KeyToClick v1.3       
Programed by Phạm Đức Vượng in AHK

*******************************************************************

                                             INTRUCTIONS
1. Select Mouse Button, Count and Hotkey 
    (Tick the WinKey box to use Winkey)
2. Move the mouse pointer to the position need to click
3. Press F2 to add your options to the list (Max 50)
4. And now your keys are ready to click
5. Save your list for use in your next time
    (Data will be saved to KeyToClick.ini)

Click Exit button to hide the window
Choose Exit from tray icon to close app
You can temporarily disable your hotkeys by click the tray icon
)
MsgBox,8192	,Help,%About%,

Return

 
Exit:
Exitapp

Label1:
Action(1)
Return
Label2:
Action(2)
Return
Label3:
Action(3)
Return
Label4:
Action(4)
Return
Label5:
Action(5)
Return
Label6:
Action(6)
Return
Label7:
Action(7)
Return
Label8:
Action(8)
Return
Label9:
Action(9)
Return
Label10:
Action(10)
Return
Label11:
Action(11)
Return
Label12:
Action(12)
Return
Label13:
Action(13)
Return
Label14:
Action(14)
Return
Label15:
Action(15)
Return
Label16:
Action(16)
Return
Label17:
Action(17)
Return
Label18:
Action(18)
Return
Label19:
Action(19)
Return
Label20:
Action(20)
Return
Label21:
Action(21)
Return
Label22:
Action(22)
Return
Label23:
Action(23)
Return
Label24:
Action(24)
Return
Label25:
Action(25)
Return
Label26:
Action(26)
Return
Label27:
Action(27)
Return
Label28:
Action(28)
Return
Label29:
Action(29)
Return
Label30:
Action(30)
Return
Label31:
Action(31)
Return
Label32:
Action(32)
Return
Label33:
Action(33)
Return
Label34:
Action(34)
Return
Label35:
Action(35)
Return
Label36:
Action(36)
Return
Label37:
Action(37)
Return
Label38:
Action(38)
Return
Label39:
Action(39)
Return
Label40:
Action(40)
Return
Label41:
Action(41)
Return
Label42:
Action(42)
Return
Label43:
Action(43)
Return
Label44:
Action(44)
Return
Label45:
Action(45)
Return
Label46:
Action(46)
Return
Label47:
Action(47)
Return
Label48:
Action(48)
Return
Label49:
Action(49)
Return
Label50:
Action(50)
Return

 
Esc::
send,^s
reload
