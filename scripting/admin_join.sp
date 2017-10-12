#pragma semicolon 1
#pragma newdecls required

#define PLUGIN_AUTHOR "TheTeamGhost (Yimura)"
#define PLUGIN_VERSION "0.1.0"

#include <sourcemod>
#include <sdktools>

Handle = g_hPluginEnabled;
Handle = g_hAdminSteamIDs;

bool g_bSilentJoin = true;

public Plugin myinfo = 
{
	name = "Admin Join Announcer",
	author = PLUGIN_AUTHOR,
	description = "Announces when an admin joins the game.",
	version = PLUGIN_VERSION,
	url = "https://yetimountain.top/"
};

public void OnPluginStart()
{
	g_hPluginEnabled = CreateConVar("sm_adminjoin_on", "1", "Enable the plugin", _, true, 0.0, true, 1.0);
	g_hAdminSteamIDs = CreateConVar("sm_adminjoin_steamids", "STEAM_0:1:51792522,STEAM_0:0:50729140", "Admin SteamIDs seperated by ,");
	
	HookEvent("teamplay_waiting_ends", Waiting_Ends);
	
	SetHudTextParams(0.1, 0.1, 3, 255, 255, 255, 1, 1, 2.0, 2.0, 2.0);
	
	AutoExecConfig(true, "Admin_Join");
}

public Action Waiting_Ends()
{
	if(g_hPluginEnabled)
	{
		g_bSilentJoin = false;
	}
}

public void OnClientPostAdminCheck(client)
{
	if(!g_bSilentJoin)
	{
		GetClientAuthId(client, AuthId_Steam2, id, 32, true);
		if(id == "STEAM_1:0:55845055")
		{
			ShowHudText(client, 2, "Hi there guys!");
		}
		char sSteamIDs[32]:
		GetConVarString(g_hAdminSteamIDs, sSteamIDs, sizeof(sSteamIDs));
		ExplodeString("sSteamIDs", ",", ADMIN_STEAMIDS, 128, 32);
		if(id == ADMIN_STEAMIDS)
		{
			ShowHudText(client, -1, "ADMIN joined the game!");
		}
	}
}
