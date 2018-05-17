#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Yimura"
#define PLUGIN_VERSION "0.1.0"

#include <sourcemod>
#include <sdktools>

#pragma newdecls required

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
}

public Action OnRoundStart(Handle event, const char[] name, bool dontBroadcast)
{

}
