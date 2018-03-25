#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Yimura"
#define PLUGIN_VERSION "0.1.0"
#define CMD_PREFIX "[SM CHEAT] "

#include <sourcemod>
#include <sdktools>
#include <tf2>
#include <tf2_stocks>
//#include <sdkhooks>

public Plugin myinfo = 
{
	name = "Admin Cheats with sv_cheats 0",
	author = PLUGIN_AUTHOR,
	description = "Execute cheats without having sv_cheats enabled",
	version = PLUGIN_VERSION,
	url = "http://yetimountain.top"
};

public void OnPluginStart()
{
	CreateConVar("sm_cheats_redux_v", PLUGIN_VERSION, "Cheat commands version", FCVAR_SPONLY|FCVAR_REPLICATED|FCVAR_NOTIFY);
	
	RegAdminCmd("sm_ch", Command_Cheat, ADMFLAG_CHEATS, "Usage: sm_ch <client|id> <cheat>");
}

public Action Command_Cheat (int args, int client)
{
	if (args < 1)
	{
		ReplyToCommand(client, "%sUsage: sm_ch <client|id> <cheat>", CMD_PREFIX);
		return Plugin_Handled;
	}
	
	char buffer[128];
	char cmd[128];
	if (args >= 1)
	{
		GetCmdArg(1, buffer, sizeof(buffer));
		int target = FindTarget(client, buffer, false, false);
		if (target != -1)
		{
			if (IsFakeClient(target))
			{
				ReplyToCommand(client, "%sInvalid client, either console or a bot was selected...", CMD_PREFIX);
				return Plugin_Handled;
			}
			else
			{
				GetCmdArg(2, buffer, sizeof(buffer));
				for (int i = 3; i <= args; i++)
				{
					GetCmdArg(i, cmd, sizeof(cmd));
					FormatEx(cmd, sizeof(cmd), "%s %s", buffer, cmd);
				}
				
				if (args == 2)
				{
					cmd = buffer;
				}
				ReplyToCommand(client, "%sTrying cheat '%s' on chosen user...", CMD_PREFIX, cmd);
				ExecCheat(target, cmd, client);
			}
		}
		else
		{
			GetCmdArg(1, buffer, sizeof(buffer));
			for (int i = 2; i <= args; i++)
			{
				GetCmdArg(i, cmd, sizeof(cmd));
				FormatEx(cmd, sizeof(cmd), "%s %s", buffer, cmd);
			}
			if (args == 1)
			{
				cmd = buffer;
			}
			ReplyToCommand(client, "%sInvalid client, trying to execute cheat '%s'.", CMD_PREFIX, cmd);
			ExecCheat(client, cmd);
		}
	}

	return Plugin_Handled;
}

void ExecCheat (int client, char cmd[128], int origClient = -1)
{
	Handle cvar = FindConVar("sv_cheats");
	bool enabled = GetConVarBool(cvar);
	int flags = GetConVarFlags(cvar);
	char targetName[32];
	if(!enabled) 
	{
		SetConVarFlags(cvar, flags^(FCVAR_NOTIFY|FCVAR_REPLICATED));
		SetConVarBool(cvar, true);
	}
	if (origClient == -1)
	{
		ReplyToCommand(client, "%sExecuted cheat '%s'!", CMD_PREFIX, cmd);
	}
	else
	{
		GetClientName(client, targetName, sizeof(targetName));
		ReplyToCommand(client, "%sExecuted cheat '%s' on %s!", CMD_PREFIX, cmd,targetName);
	}
	FakeClientCommand(client, "%s", cmd);
	if(!enabled) 
	{
		SetConVarBool(cvar, false);
		SetConVarFlags(cvar, flags);
    }
}