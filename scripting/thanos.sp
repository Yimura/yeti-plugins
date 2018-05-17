#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Yimura"
#define PLUGIN_VERSION "0.1.0"

#include <sourcemod>
#include <sdktools>
#include <tf2attributes>

#pragma newdecls required

bool g_bEnablePlugin = false;
Handle g_hPluginOn;

public Plugin myinfo =
{
	name = "[TF2] Thanos Gamemode",
	author = PLUGIN_AUTHOR,
	description = "Thanos did nothing wrong, he just wanted to help",
	version = PLUGIN_VERSION,
	url = "https://ilysi.com"
};

public void OnPluginStart()
{
	if(GetEngineVersion() != Engine_TF2)
	{
		SetFailState("Thanos is retiring... Running engine doesn't match Engine_TF2");
	}

	CreateConVar("sm_thanos_ver", PLUGIN_VERSION, "Thanos gamemode version", FCVAR_REPLICATED | FCVAR_SPONLY | FCVAR_DONTRECORD | FCVAR_NOTIFY);
	g_hPluginOn = CreateConVar("sm_thanos_enable", "1", "Enable/Disable Thanos gamemode");

	// Global events
	//HookEvent("teamplay_round_start", OnRoundStart);

	// Player events
	//HookEvent("player_spawn", OnPlayerSpawn);
	//HookEvent("player_death", OnPlayerDeath);
	HookEvent("post_inventory_application", OnPlayerInventory, EventHookMode_Post);

	int pluginEnabled = GetConVarInt(g_hPluginOn);
	if(pluginEnabled == 1)
	{
		g_bEnablePlugin = true;
	}
}

public Action OnPlayerInventory(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bEnablePlugin)
	{
		return;
	}

	int client = GetClientOfUserId(GetEventInt(event, "userid"));
}

//public Action OnRoundStart(Handle event, const char[] name, bool dontBroadcast)

/*
*	Do our checks for which weapon slot is active
*/
public void OnGameFrame()
{
	int[] clients = new int[MaxClients];
	clients = GetAllClients();

	for(int i = 0; i < MaxClients; ++)
	{
		if (TF2_GetPlayerClass(i) == TFClass_Medic)
		{
			int weapon = getActiveWeapon(i)
		}
	}
}

/*	Class: Heavy
*	Melee only -> buffed powers
*/
void setupHulk(int client)
{
	TF2Attrib_SetByName(client, "damage bonus", 8.0);
	TF2Attrib_SetByName(client, "max health additive bonus", 8.0);
	TF2Attrib_SetByName(client, "active health regen", 25.0);

	// Remove slots 1,2,4,5 (slot 3 is melee)
	TF2_RemoveWeaponSlot(client, 1);
	TF2_RemoveWeaponSlot(client, 2);
	TF2_RemoveWeaponSlot(client, 4);
	TF2_RemoveWeaponSlot(client, 5);
}

/*	Class: Pyro
*	Jetpack -> already exists in TF2
*/
void setupIronMan(int client)
{

}

/*	Class: Medic
*	Use Halloween spells and keep healing ability (possibly)
*/
void setupDrStrange(int client)
{

}

/*	Class: Sniper
*	Sniper has the huntsman we can use that for his arrows
*/
void setupHawkEye(int client)
{

}

/*	Class: Scout
*	Use grappling hook as spidermans web
*/
void setupSpiderMan(int client)
{

}

/*	Class: Soldier
*	Soldier is America in itself will have to find something later tho
*/
void setupCptAmerica(int client)
{

}

/*	Class: Demoman
*	Will need a custom model tho
*/
void setupThanos(int client)
{

}

void getActiveWeapon(int client)
{
	int hClientWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	return hClientWeapon;
}

void GetAllClients()
{
	int count = 0;
	int[] clients = new int[MaxClients];
	for(int i = 0; i < MaxClients; ++)
	{
		if(IsClientInGame(i))
		{
			clients[count] = i;
			count++;
		}
	}

	return (count == 0) ? -1 : clients;
}
