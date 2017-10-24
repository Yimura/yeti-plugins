#include <sourcemod>
#include <sdktools>

Handle g_hClanTag;
Handle g_hClanTagPlace;
Handle g_hClanTagMode;

public void OnPluginStart()
{
	g_hClanTag = CreateConVar("sm_clantag_prefix", "Yeti", "Clantag users need to have in their name to get benefits");
	g_hClanTagReplace = CreateConVar("sm_clantag_replacement", "Supporter", "Tag to put in front of the name");
	g_hClanTagMode = CreateConVar("sm_clantag_mode", "0", "0 for build in benefits, 1 for mode with flags, 2 for both");
	
	AutoExecConfig(true, "ClanTagBenefit");
}

public void OnClientAuthorized(client, AuthId_Steam3)
{
	GetClientName(client, clientName, sizeof(client_name));
	
	GetConVarString(g_hClanTag, ClanTag, sizeof(ClanTag));
	
	if(strcmp(clientName, ClanTag, false) == 0)
	{
		GetConVarString(g_hClanTagReplace, ClanTagReplace, sizeof(ClanTagReplac));
		Format(NewClientName, sizeof(NewClientName), "%s | %s", ClanTagReplace, clientName);
		SetClientName(client, NewClientName);
	}
	
	if(g_hClanTagMode == "0" || g_hClanTagMode == "2")
	{
		
	}
	if(g_hClanTag == "1" || g_hClanTagMode == "2")
	{
		GetClientAuthId(client, AuthId_Steam2, Steam_Id, sizeof(Steam_Id), true);
		SetAdminFlag(Steam_Id, ADMIN_FLAG
	}
}