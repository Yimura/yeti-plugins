/*  Belangrijke urls
*   https://sm.alliedmods.net/new-api/
*/

#include <sourcemod>
#include <sdkhooks>
#include <tf2_stocks>
#include <tf2>

#define VERSION "0.1.0"

/*
*   Hieronder u defines die globaal moeten zijn
*/
bool g_bBleBle = false;
Handle g_hPluginOn;

public Plugin myinfo =
{
	name           = "[TF2] Rewrite Dominate Event",
	author         = "Ilysi Dev Team (Flop)",
	description    = "Rewrites the dominate event with a funier text",
	version        = VERSION,
	url            = "https://ilysi.com"
};

/*
*   Hier komt shit in die ge op plugin start nodig hebt zoals stuff uit u config file
*/
public void OnPluginStart()
{
    CreateConVar("sm_dominate_ver", VERSION, "Dominate Event rewrite version", FCVAR_REPLICATED | FCVAR_SPONLY | FCVAR_DONTRECORD | FCVAR_NOTIFY);
    g_hPluginOn = CreateConVar("sm_dominate_enabled", "1", "Enable domination rewriting", FCVAR_NOTIFY);
    /*  FCVAR_NOTIFY = als ge die aanpast mid game word da genotified aan de hele server
    *   Die convar linken aan g_hConVar zorgt ervoor da ge de value van die convar later kunt oproepen
    */

    // Find the Dominations/Revenge netprops before hooking and creating
	m_bPlayerDominated    = FindSendPropInfoEx("CTFPlayer", "m_bPlayerDominated");
	m_bPlayerDominatingMe = FindSendPropInfoEx("CTFPlayer", "m_bPlayerDominatingMe");

    HookEvent("player_death", OnPlayerDeath, EventHookMode_Post);
}

public Action OnPlayerDeath(Handle event, const char[] name, bool dontBroadcast)
{
    // We halen onze victim uit de event deze heet gewoon userid
    int victim = GetClientOfUserId(GetEventInt(event, "userid"));
    int attacker = GetClientOfUserId(GetEventInt(event, "attacker"));

	// Way to get dominations and revenges is death_flags
	int death_flags = GetEventInt(event, "death_flags");

	// Thanks to FaTony for this
	death_flags &= ~(TF_DEATHFLAG_KILLERDOMINATION | TF_DEATHFLAG_ASSISTERDOMINATION | TF_DEATHFLAG_KILLERREVENGE | TF_DEATHFLAG_ASSISTERREVENGE);

	// Sets the integer value of a game event's key
	SetEventInt(event, "death_flags", death_flags);

	// Disable domination features
	SetNetProps(attacker, victim);
}
