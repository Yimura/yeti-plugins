#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Yimura"
#define PLUGIN_VERSION "0.1.0"

#include <sourcemod>

Handle g_hAllowedSteamIds;

#pragma newdecls required

public Plugin myinfo =
{
	name = "Restricted Access",
	author = PLUGIN_AUTHOR,
	description = "Restrict access to certain STEAM_IDs or admin flags",
	version = PLUGIN_VERSION,
	url = "https://ilysi.com/"
};

public void OnPluginStart()
{
	CreateConVar("sm_ra_ver", PLUGIN_VERSION, "Restricted access version", FCVAR_REPLICATED | FCVAR_SPONLY | FCVAR_DONTRECORD | FCVAR_NOTIFY);
	g_hAllowedSteamIds = CreateConVar("sm_ra_steamids", "STEAM_0:0:55845055,STEAM_1:0:167976709", "SteamId's seperated by comma who're allowed to join");
}

public void OnClientPostAdminCheck(int client)
{
	AdminId UserAdminId = GetUserAdmin(client);
	char SteamId[64];
	GetClientAuthId(client, AuthId_Steam2, SteamId, sizeof(SteamId), true);
	if (!IsInSteamIdList(SteamId) && !GetAdminFlag(UserAdminId, Admin_Generic, Access_Real))
	{
		PrintToChatAll("%N has been kicked by the restricted access plugin", client);
		KickClient(client, "This server has restricted access! Notify the server owner for more info.");
	}
}

bool IsInSteamIdList(const char[] SteamId)
{
	if(StrEqual(SteamId, "BOT", false) || StrEqual(SteamId, "STEAM_ID_LAN", false))
		return true;

	char SteamIds[512];
	GetConVarString(g_hAllowedSteamIds, SteamIds, sizeof(SteamIds));
	char ExtractedSteamIds[100][64];
	int iStrReceived = ExplodeString(SteamIds, ",", ExtractedSteamIds, 100, 64);
	for(int i = 0; i < iStrReceived; i++)
	{
    	if (StrEqual(ExtractedSteamIds[i], SteamId, false))
        	return true;
	}
	return false;
}
