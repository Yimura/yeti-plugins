#include <sourcemod>
#include <sdktools>
#include <updater>

#define PLUGIN_VERSION "1.6"

#define UPDATE_URL "http://yetimountain.top/.updater/advanced_cheats/acupdater.txt"


public Plugin:myinfo = 
{
	name = "Cheat commands",
	author = "Yimura",
	description = "Use cheat commands without sv_cheats 1",
	version = PLUGIN_VERSION,
	url = "http://yetimountain.top/"
};
public OnPluginStart()
{
	CreateConVar("sm_cheat_version", PLUGIN_VERSION, "Cheat commands version", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
	RegAdminCmd("sm_ch", Command_Cheat_Command, ADMFLAG_CHEATS);
	
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
}

public void OnLibraryAdded(const char[] libname)
{
	if(StrEqual(libname, "updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
}

public int Updater_OnPluginUpdated()
{
	ReloadPlugin(GetMyHandle())
}

public Action:Command_Cheat_Command(client, args)
{
	decl String:cmd[65];
	GetCmdArgString(cmd, sizeof(cmd));
	PerformCheatCommand(client, cmd);
	return Plugin_Handled;
}

stock PerformCheatCommand(client, String:cmd[])
{
	new Handle:cvar = FindConVar("sv_cheats"), bool:enabled = GetConVarBool(cvar), flags = GetConVarFlags(cvar);
	if(!enabled) {
		SetConVarFlags(cvar, flags^(FCVAR_NOTIFY|FCVAR_REPLICATED));
		SetConVarBool(cvar, true);
	}
	FakeClientCommand(client, "%s", cmd);
	decl String:clientname[64];
	GetClientName(client, clientname, sizeof(clientname));
	ReplyToCommand(client, "[SM] %s used cheat %s.", clientname, cmd);
	if(!enabled) {
		SetConVarBool(cvar, false);
		SetConVarFlags(cvar, flags);
    }
	CreateTimer(0.1, ExecDelay, 0);
}

public Action:ExecDelay(Handle:timer)
{
	ServerCommand("exec sm_cheat_cvars.cfg");
	{	
		SetFailState("write sm_cheat_cvars.cfg")
		{
			ReloadPlugin(GetMyHandle())	
		}
	}
}