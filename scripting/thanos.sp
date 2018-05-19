#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Yimura"
#define PLUGIN_VERSION "0.1.0"

// Fixed
#define CLASS_SCOUT 1
#define CLASS_SNIPER 2
#define CLASS_SOLDIER 3
#define CLASS_DEMOMAN 4
#define CLASS_MEDIC 5
#define CLASS_HEAVY 6
#define CLASS_PYRO 7
#define CLASS_SPY 8
#define CLASS_ENGINEER 9

#define TEAM_RED 2
#define TEAM_BLUE 3

#include <sourcemod>
#include <sdktools>
#include <tf2_stocks>
#include <tf2>
#include <tf2attributes>

#pragma newdecls required

bool g_bPluginOn = false;
Handle g_hPluginOn;

int g_iCountDownStart = 20;
int g_iCountDown_def = 20;

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
	g_hPluginOn = CreateConVar("sm_thanos_enable", "1", "Enable/Disable Thanos gamemode", FCVAR_NOTIFY);

	// Global events
	HookEvent("teamplay_round_start", OnRoundStart);

	// Player events
	//HookEvent("player_spawn", OnPlayerSpawn);
	//HookEvent("player_death", OnPlayerDeath);
	HookEvent("post_inventory_application", OnPlayerInventory, EventHookMode_Post);

	HookConVarChange(g_hPluginOn, PluginState);

	int pluginEnabled = GetConVarInt(g_hPluginOn);
	if (pluginEnabled == 1)
	{
		g_bPluginOn = true;
	}
	else
	{
		g_bPluginOn = false;
	}
}

public Action OnPlayerInventory(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bPluginOn)
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
			PrintCenterText(client, "Playing as Hulk");
			SetupHulk(client);
		}
		else if (class == CLASS_PYRO)
		{
			PrintCenterText(client, "Playing as Ironman");
			SetupIronMan(client);
		}
		else if (class == CLASS_MEDIC)
		{
			PrintCenterText(client, "Playing as Dr Strange");
			SetupDrStrange(client);
		}
		else if (class == CLASS_SNIPER)
		{
			PrintCenterText(client, "Playing as Hawk Eye");
			SetupHawkEye(client);
		}
		else if (class == CLASS_SOLDIER)
		{
			PrintCenterText(client, "Playing as Cpt America");
			SetupCptAmerica(client);
		}
		else if (class == CLASS_SCOUT)
		{
			PrintCenterText(client, "Playing as Spiderman");
			SetupSpiderMan(client);
		}
	}
}

public Action OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{
	if (!g_bPluginOn)
	{
		return;
	}

	CreateTimer(1.0, CountDown, _, TIMER_REPEAT);
}

/*
*	Do our checks for which weapon slot is active
*/
public void OnGameFrame()
{
	if (!g_bPluginOn)
	{
		return;
	}

	for (int i = 1; i < MaxClients; i++)
	{
		if (IsClientInGame(i))
		{
			if (TF2_GetPlayerClass(i) == TFClass_Medic)
			{
				//int weapon = GetActiveWeapon(i);
			}
		}
	}
}

public Action CountDown(Handle timer)
{
	if(g_iCountDownStart <= 0)
	{
		// Call our function to choose Thanos
		ChooseThanos();
		// Kill our timer to prevent it from firing again
		KillTimer(timer);
		// Set the default value back for next round
		g_iCountDownStart = g_iCountDown_def;
	}

	if(g_iCountDownStart < 20)
	{
		PrintHintTextToAll("Thanos will be chosen in %i seconds!", g_iCountDownStart);
	}
	g_iCountDownStart--;
}

void ChooseThanos()
{
	int client = GetRandomClient();
	if (client == -1)
	{
		PrintToChatAll("No valid clients found?");
	}

	ChangeClientTeam(client, TEAM_BLUE);
	TF2_RespawnPlayer(client);
}

/*	Class: Heavy
*	Melee only -> buffed powers
*/
void SetupHulk(int client)
{
	int weapon = GetPlayerWeaponSlot(client, 2); // Will get the melee weapon
	SetEntPropEnt(client, Prop_Send, "m_hActiveWeapon", weapon);

	// Remove slots 1,2, (slot 3 is melee)
	TF2_RemoveWeaponSlot(client, 0); // Primary
	TF2_RemoveWeaponSlot(client, 1); // Secondary
	// TF2_RemoveWeaponSlot(client, 2); // Melee Weapon
	TF2_RemoveWeaponSlot(client, 3); // Engineer PDA
	TF2_RemoveWeaponSlot(client, 4); // Possibly taunts 1-4
	TF2_RemoveWeaponSlot(client, 5); // Possibly taunts 5-8

	// Apply attributes on weapon -> never bind them to a client
	TF2Attrib_SetByName(weapon, "damage bonus", 8.0);
	TF2Attrib_SetByName(weapon, "max health additive bonus", 700.0);
	TF2Attrib_SetByName(weapon, "health regen", 10.0);
	TF2Attrib_SetByName(weapon, "cancel falling damage", 1.0);
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
	// Remove the medics weapons we'll give him new ones
	TF2_RemoveAllWeapons(client);


}

/*bool CreateDrStrangeWeapons(int client)
{

	return true;
}*/

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
	PrintToChat(client, "Boi you thanos");
}

int GetActiveWeapon(int client)
{
	int hClientWeapon = GetEntPropEnt(client, Prop_Send, "m_hActiveWeapon");
	return hClientWeapon;
}

int GetRandomClient()
{
	int count;
	int[] clients = new int[MaxClients];
	for (int i = 1; i <= MaxClients; i++)
	{
		if(IsClientInGame(i) && !IsClientReplay(i) && !IsClientSourceTV(i))
		{
			clients[count++] = i;
		}
	}
	return (count == 0) ? -1 : clients[GetRandomInt(0, count-1)];
}

void PluginState(ConVar convar, const char[] oldValue, const char[] newValue)
{
	if (strlen(newValue) > 0)
	{
		g_bPluginOn = (StringToInt(newValue)!=0 ? true : false);
	}
	else
	{
		PrintToServer("Invalid ConVar value was set");
	}
	return;
}
