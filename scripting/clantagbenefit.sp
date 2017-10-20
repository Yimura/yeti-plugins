#include <sourcemod>
#include <sdktools>

Handle g_hClanTag;

public void OnPluginStart()
{
	g_hClanTag = CreateConVar("sm_clantag_prefix", "| Yeti", "Clantag users need to have in their name to get benefits )");
	g_hClanTagPlacement = CreateConVar("sm_clantag_place", "Back"
	
	AutoExecConfig(true, "ClanTagBenefit");
}

public void OnClientAuthorized(client, AuthId_Steam3)
{
	GetClientName(client, clientName, sizeof(client_name));
	
	GetConVarString(g_hClanTag, ClanTag, sizeof(ClanTag));
	
	if(strcmp(clientName, ClanTag, false) == 0)
	{
		if(g_hClanTagPlacement == front)
		{
			Format(NewClientName, sizeof(NewClientName), "%s %s", clientName, ClanTag);
			SetClientName(client, NewClientName);
		}
		else if()
	}
}