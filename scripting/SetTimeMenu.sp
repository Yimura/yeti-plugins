#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Yimura"
#define PLUGIN_VERSION "0.1"

#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>

Handle g_hDefaultTime;
Handle g_hSetTimeHidden;

public Plugin myinfo = 
{
	name = "[Menu] Set Round Time",
	author = PLUGIN_AUTHOR,
	description = "Set round time through a menu or use the command to change the time.",
	version = PLUGIN_VERSION,
	url = ""
};

public void OnPluginStart()
{
	g_hDefaultTime = CreateConVar("sm_stdefault", "3", "Default timer value on map start.", _, true, 1.0, true, 15);

	RegAdminCmd("sm_stmenu", Command_Menu_Open, ADMFLAG_CHANGEMAP, "Open Set Time Menu.");
	RegAdminCmd("sm_settime", Command_SetTime, ADMFLAG_CHANGEMAP, "Set Time through a simple command.");
}

public OnMapStart()
{
	float iRoundTime = GetConVarInt(g_hDefaultTime) * 60;
	int entityTimer = MaxClients + 1;
	while((entityTimer = FindEntityByClassname(entityTimer, "team_round_timer")) != -1)
	{
		SetVariantFloat(iRoundTime);
		AcceptEntityInput(entityTimer, "SetTime");
	}
}

public Action Command_SetTime()
{
	
}

public Action Command_Menu_Open(int client)
{
	Menu menu = new Menu(Command_SetTime);
	menu.SetTitle("Set Round Timer (min)");
	menu.AddItem("sm_settime 3", "Default");
	menu.AddItem("sm_settime 4", "4 min");
	menu.AddItem("sm_settime 5", "5 min");
	menu.AddItem("sm_settime 6", "6 min");
	menu.AddItem("sm_settime 8", "8 min");
	menu.AddItem("sm_settime 10", "10 min");
	menu.AddItem("sm_settime 12", "12 min");
	menu.ExitButton = true;
	menu.Display(client, 360);
	
	return Plugin_Handled;
}