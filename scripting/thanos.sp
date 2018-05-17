#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Yimura"
#define PLUGIN_VERSION "0.1.0"

#define CLASS_SCOUT 1
#define CLASS_SOLDIER 2
#define CLASS_PYRO 3
#define CLASS_ENGINEER 4
#define CLASS_HEAVY 5
#define CLASS_DEMOMAN 6
#define CLASS_MEDIC 7
#define CLASS_SNIPER 8
#define CLASS_SPY 9

#include <sourcemod>
#include <sdktools>
#include <tf2_stocks>
#include <tf2>
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
	TFTeam team = TF2_GetClientTeam(client);
	if (team == TFTeam_Blue)
	{
		SetupThanos(client);
	}
	else if (team == TFTeam_Red)
	{
		int class = GetEntProp(client, Prop_Send, "m_iClass");
		if (class == CLASS_HEAVY)
		{
			SetupHulk(client);
		}
		else if (class == CLASS_PYRO)
		{
			SetupIronMan(client);
		}
		else if (class == CLASS_MEDIC)
		{
			SetupDrStrange(client);
		}
		else if (class == CLASS_SNIPER)
		{
			SetupHawkEye(client);
		}
		else if (class == CLASS_SOLDIER)
		{
			SetupCptAmerica(client);
		}
	}
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
void SetupHulk(int client)
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
void SetupIronMan(int client)
{

}

/*	Class: Medic
*	Use Halloween spells and keep healing ability (possibly)
*/
void SetupDrStrange(int client)
{

}

/*	Class: Sniper
*	Sniper has the huntsman we can use that for his arrows
*/
void SetupHawkEye(int client)
{

}

/*	Class: Scout
*	Use grappling hook as spidermans web
*/
void SetupSpiderMan(int client)
{

}

/*	Class: Soldier
*	Soldier is America in itself will have to find something later tho
*/
void SetupCptAmerica(int client)
{

}

/*	Class: Demoman
*	Will need a custom model tho
*/
void SetupThanos(int client)
{

}

void GetActiveWeapon(int client)
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
