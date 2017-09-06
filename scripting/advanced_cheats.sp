#include <sourcemod>
#include <sdktools>

#undef REQUIRE_PLUGIN
#include <updater>

#define PLUGIN_VERSION "1.11.1"

#define UPDATE_URL "http://yetimountain.top/.updater/advanced_cheats/acupdater.txt"


/* When making this plugin everything went smooth but there was one thing I didn't think about
Client-Side cheats oh noooes well the problem is upon connecting a client or your game recieves from the server that
sv_cheats is disabled (which it is) so I tried making a code which switched sv_cheats on did the client command and switch it back off.
1 big problem SourceMod can't run all client commands to prevent servers from causing changes to player settings, 
well guess what the client-side cheats we're accessing are blocked from us to be run*/

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
	
	//g_hEnableClientSideCMDs = CreateConVar("sm_clientcheat", "0", "Enable Client-Side cheats (if you don't know what this means leave it disabled).");
	
	RegAdminCmd("sm_ch", Command_Cheat_Command, ADMFLAG_CHEATS, "Usage: sm_ch <addcond #/hurtme>");
	//RegAdminCmd("sm_cc", Command_Client_Cheat, ADMFLAG_CHEATS, "Usage: sm_cc <impulse>")
	
	if (LibraryExists("updater"))
	{
		Updater_AddPlugin(UPDATE_URL);
	}
	
	AutoExecConfig(true, "advanced_cheats");
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
	if(args < 1)
	{
		ReplyToCommand(client, "[SM] Usage: sm_ch <cheat-cmd>");
		return Plugin_Handled
	}
	else
	{
		PerformCheatCommand(client, cmd);
		decl String:clientname[64];
		GetClientName(client, clientname, sizeof(clientname));
		ShowActivity2(client, "[SM] %s used cheat %s.", clientname, cmd);
		return Plugin_Handled;
	}
}

stock PerformCheatCommand(client, String:cmd[])
{
	new Handle:cvar = FindConVar("sv_cheats"), bool:enabled = GetConVarBool(cvar), flags = GetConVarFlags(cvar);
	if(!enabled) 
	{
		SetConVarFlags(cvar, flags^(FCVAR_NOTIFY|FCVAR_REPLICATED));
		SetConVarBool(cvar, true);
	}
	FakeClientCommand(client, "%s", cmd);
	if(!enabled) 
	{
		SetConVarBool(cvar, false);
		SetConVarFlags(cvar, flags);
    }
	CreateTimer(0.1, ExecDelay, 0);
}

public Action:ExecDelay(Handle:timer)
{
	ServerCommand("exec sm_cheats_cvars.cfg");
}


/*
 This piece of code is meant to be used if for client-side cheats like impulses.
 I wasn't able to test it to be fully functional but here just a piece of code for ya.
*/

/*new Handle:FakeCvarTimers[MAXPLAYERS+1];
	 
public void OnAdminPostChecked(int client)
{
	if((GetUserFlagBits(client) & ADMFLAG_CHEATS) == ADMFLAG_CHEATS)
	{
		FakeCvarTimers[client] = CreateTimer(5.0, CvarFaked, client);
	}
}
 
public void OnClientDisconnect(int client)
{
	if (FakeCvarTimers[client] != null)
	{
		KillTimer(FakeCvarTimers[client]);
		FakeCvarTimers[client] = null;
	}
}

public Action CvarFaked(Handle timer, any client)
{
	new Handle:cvar = FindConVar("sv_cheats");
	SendConVarValue(client, cvar, "1");
	decl String:clientname[64];
	GetClientName(client, clientname, sizeof(clientname));
	PrintToServer("sv_cheats_1 faked to %s", clientname);
	FakeCvarTimers[client] = null;
}

public Action:Command_Client_Cheat(client, args)
{
	decl String:ccmd[65];
	GetCmdArgString(ccmd, sizeof(ccmd));
	
	new Handle:cvar = FindConVar("sv_cheats");
	SetConVarBool(cvar, true);
	FakeClientCommand(client, ccmd);
	SetConVarBool(cvar, false);
	return Plugin_Handled;
}*/