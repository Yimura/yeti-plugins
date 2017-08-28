#include <sourcemod>
#include <sdktools>

#define PLUGIN_VERSION "1.3"


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
	
	RegAdminCmd("sm_c", Command_Cheat_Command, ADMFLAG_CHEATS);
	
	FindConVar("sv_cheats");
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
	if(!enabled) {
		SetConVarBool(cvar, false);
		SetConVarFlags(cvar, flags);
    }
	CreateTimer(0.1, ExecDelay, 0);
	
	//if (String:cmd = "impulse 101");
	//{
		//SetConVarBool(sv_cheats, true);
		//FakeClientCommand(client, "impulse 101");
		//SetConVarBool(sv_cheats, false);
	//}
}

public Action:ExecDelay(Handle:timer)
{
	ServerCommand("exec sm_cheat_cvars.cfg");
}