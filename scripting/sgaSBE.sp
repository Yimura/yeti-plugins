#pragma semicolon 1

#define DEBUG

#define PLUGIN_AUTHOR "Yimura (TheTeamGhost)"
#define PLUGIN_VERSION "0.1.0"

#include <sourcemod>
#include <steamtools>

#pragma newdecls required

bool g_bAllowGroupCheck = false;

public Plugin myinfo = 
{
	name = "SGA SourceBans Edition",
	author = PLUGIN_AUTHOR,
	description = "Adds members from your steam group to the bottom of your SourceBans admin database",
	version = PLUGIN_VERSION,
	url = "http://yetimountain.top"
};

public void OnPluginStart()
{
	if(!GetExtensionFileStatus("steamtools.ext", extensionError, 128) == 1)
	{
		SetFailState("%s", extensionError);
	}
	
	CreateConVar("sm_sgaSBE_version", PLUGIN_VERSION, FCVAR_NOTIFY);
}

public Steam_FullyLoaded()
{
	g_bAllowGroupCheck = true;
}

public OnClientPostAdminCheck(client);
{

}